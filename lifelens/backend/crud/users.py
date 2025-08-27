
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from lifelens.backend.db import db

def _handle_error(e: SQLAlchemyError):
    db.session.rollback()
    return {"error": str(e)}, 500

def create_record(table: str, data: dict):
    try:
        columns = ", ".join(data.keys())
        placeholders = ", ".join(f":{k}" for k in data.keys())
        sql = text(f"INSERT INTO {table} ({columns}) VALUES ({placeholders})")
        db.session.execute(sql, data)
        db.session.commit()
        return {"message": f"Record created in {table}"}, 201
    except SQLAlchemyError as e:
        return _handle_error(e)
    


def get_records(table: str,):
    try:
        rows = db.session.execute(text(f"SELECT * FROM {table}")).mappings().all()
        return [dict(r) for r in rows], 200
    except SQLAlchemyError as e:
        return _handle_error(e)

def get_record(table: str, id_value: int, id_column: str):
    try:
        print(table, id_value, id_column)
        row = db.session.execute(
            text(f"SELECT * FROM {table} WHERE {id_column} = :id_val"),
            {"id_val": id_value}
        ).mappings().first()
        return (dict(row), 200) if row else ({"error": "Not found"}, 404)
    except SQLAlchemyError as e:
        return _handle_error(e)

def update_record(table: str, id_value: int, data: dict, id_column: str = "id"):
    try:
        set_clause = ", ".join(f"{k} = :{k}" for k in data.keys())
        sql = text(f"UPDATE {table} SET {set_clause} WHERE {id_column} = :id_val")
        data["id_val"] = id_value
        db.session.execute(sql, data)
        db.session.commit()
        return {"message": f"Record updated in {table}"}, 200
    except SQLAlchemyError as e:
        return _handle_error(e)


def delete_record(table: str, id_value: int, id_column: str = "id"):
    try:
        table = table.lower()

        if table == "user" and id_column == "id_user":
            # 1. Obtener el usuario por document
            row = db.session.execute(
                text("SELECT id_user, id_result, id_gonogo, id_stroop, id_t_hanoi, id_trail_making "
                    "FROM user WHERE document = :doc"),
                {"doc": id_value}
            ).mappings().first()
            if not row:
                return {"error": "Usuario no encontrado"}, 404


            user_id = row["id_user"]
            deletes = [
                ("user",         "id_user",         user_id),
                ("result",       "id_result",       row["id_result"]),
                ("gonogo",       "id_gonogo",       row["id_gonogo"]),
                ("stroop",       "id_stroop",       row["id_stroop"]),
                ("t_hanoi",      "id_t_hanoi",      row["id_t_hanoi"]),
                ("trail_making", "id_trail_making", row["id_trail_making"]),
            ]
            for tbl, col, val in deletes:
                db.session.execute(text(f"DELETE FROM {tbl} WHERE {col} = :v"), {"v": val})

            db.session.commit()
            return {"message": "Usuario y registros relacionados eliminados"}, 200

        else:
            sql = text(f"DELETE FROM {table} WHERE {id_column} = :id_val")
            res = db.session.execute(sql, {"id_val": id_value})
            db.session.commit()
            return {"message": f"Record deleted from {table}"}, 200 if res.rowcount else ({"error": "Not found"}, 404)

    except SQLAlchemyError as e:
        db.session.rollback()
        return _handle_error(e)
    

def create_user(table: str, data: dict):

    print(data)
    try:
        dup = db.session.execute(
            text("SELECT 1 FROM user WHERE document = :doc"),
            {"doc": data["document"]}).fetchone()
        if dup:
            return {"error": "User already exists (duplicate document)"}, 409  

        
        db.session.execute(
            text("CALL add_user_pack(:name, :last_name, :document, :city, :clan, :topy)"),
            data
        )
        db.session.commit()
        return {"message": "Usuario creado con tablas auxiliares"}, 201
    except SQLAlchemyError as e:
        return _handle_error(e)
    

# actualizar tabla result 
def update_result(user_id: int):
    try:
        sql = text("""
            UPDATE result AS r
        JOIN user         AS u ON u.id_result        = r.id_result
        JOIN stroop       AS s ON s.id_stroop        = u.id_stroop
        JOIN gonogo       AS g ON g.id_gonogo        = u.id_gonogo
        JOIN t_hanoi      AS h ON h.id_t_hanoi       = u.id_t_hanoi
        JOIN trail_making AS t ON t.id_trail_making  = u.id_trail_making
        SET
            r.inhibitory_control    = COALESCE(s.total_stroop,0) + COALESCE(g.total_gonogo,0),
            r.executive_functioning = COALESCE(s.total_stroop,0) + COALESCE(h.total_hanoi,0),
            r.working_memory        = COALESCE(s.total_stroop,0) + COALESCE(g.total_gonogo,0),
            r.cognitive_flexibility = COALESCE(g.total_gonogo,0) + COALESCE(h.total_hanoi,0),
            r.planning              = COALESCE(h.total_hanoi,0)   + COALESCE(t.total_trail_making,0),
            r.strategic_learning    = COALESCE(h.total_hanoi,0),
            r.processing_speed      = COALESCE(t.total_trail_making,0) + COALESCE(h.total_hanoi,0),
            r.comprehensive_outcome = (
            COALESCE(s.total_stroop,0)
            + COALESCE(g.total_gonogo,0)
            + COALESCE(h.total_hanoi,0)
            + COALESCE(t.total_trail_making,0)
            ) / 4
            WHERE u.id_user = :uid
        """)
        db.session.execute(sql, {'uid': user_id})
        db.session.commit()
        return {"message": f"Resultados actualizados para usuario {user_id}"}, 200

    except SQLAlchemyError as e:
        db.session.rollback()
        return {"error": str(e)}, 500