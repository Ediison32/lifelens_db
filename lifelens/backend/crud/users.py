from flask import jsonify
from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from lifelens.backend.db import db
from dotenv import load_dotenv
import os
import requests

load_dotenv()



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
    print("esntro a eliminar")
    print(table, id_column, id_value)
    try:
        table = table.lower()

        if table == "user" and id_column == "id_user":
            # 1. Obtener el usuario por document
            row = db.session.execute(
                text("SELECT id_user, id_result, id_gonogo, id_stroop, id_t_hanoi, id_trail_making "
                    "FROM user WHERE id_user = :doc"),
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
            return {"message": "User and related records deleted"}, 200

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
    print("inteento crar ")
    try:
        dup = db.session.execute(
            text("SELECT 1 FROM user WHERE document = :doc"),
            {"doc": data["document"]}).fetchone()
        if dup:
            return {"error": "User already exists (duplicate document)"}, 409  

        
        db.session.execute(
            text("CALL add_user_pack(:name, :name2, :last_name, :last_name2,  :document, :city, :clan, :topy)"),
            data
        )
        db.session.commit()
        return {"message": "User created with auxiliary tables"}, 201
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
        return {"message": f"Updated results for user {user_id}"}, 200

    except SQLAlchemyError as e:
        db.session.rollback()
        return {"error": str(e)}, 500
    

def get_all_totals():
    sql = text("""
        SELECT
            u.document,                                   
            g.total_gonogo,
            s.total_stroop,
            h.total_hanoi,
            t.total_trail_making,
            COALESCE(s.total_stroop,0) + COALESCE(g.total_gonogo,0)         AS calc_inhibitory,
            COALESCE(g.total_gonogo,0)  + COALESCE(h.total_hanoi,0)         AS calc_flexibility,
            COALESCE(h.total_hanoi,0)   + COALESCE(t.total_trail_making,0)  AS calc_planning,
            COALESCE(h.total_hanoi,0)                                       AS calc_strategic,
            COALESCE(t.total_trail_making,0) + COALESCE(h.total_hanoi,0)    AS calc_processing,
            COALESCE(s.total_stroop,0) + COALESCE(g.total_gonogo,0)
            + COALESCE(h.total_hanoi,0) + COALESCE(t.total_trail_making,0)  AS calc_comprehensive,
            r.Inhibitory_control,
            r.executive_functioning,
            r.working_memory,
            r.cognitive_flexibility,
            r.planning,
            r.strategic_learning,
            r.processing_speed,
            r.comprehensive_outcome
        FROM user AS u
        LEFT JOIN gonogo       g ON g.id_gonogo        = u.id_gonogo
        LEFT JOIN stroop       s ON s.id_stroop        = u.id_stroop
        LEFT JOIN t_hanoi      h ON h.id_t_hanoi       = u.id_t_hanoi
        LEFT JOIN trail_making t ON t.id_trail_making  = u.id_trail_making
        LEFT JOIN result       r ON r.id_result        = u.id_result
    """)
    try:
        rows = db.session.execute(sql).mappings().fetchall()
        return jsonify([dict(r) for r in rows]), 200
    except SQLAlchemyError as e:
        return _handle_error(e)
    


## ia 


BASE_PROMPT  = '''
Eres un psicólogo experto en evaluación cognitiva. Te daré los resultados de varias pruebas neuropsicológicas.

Tu tarea es:

Resaltar primero los aspectos positivos y fortalezas de la persona.

Señalar de manera breve y amable las áreas que puede mejorar.

Dar recomendaciones prácticas y fáciles de aplicar para entrenar esas habilidades.

Importante:

No muestres ni repitas valores, escalas o resultados numéricos.

No generes tablas ni listas de puntajes.

Usa los resultados solo como referencia interna para tu análisis.

La respuesta debe ser breve, motivadora y clara.

Ejemplo de cómo quiero la respuesta:

    Has demostrado una buena capacidad de organización y rapidez en el procesamiento de la información,
    lo cual es una fortaleza importante para resolver problemas de manera eficiente. Una de tus oportunidades 
    de mejora está en la memoria de trabajo, donde podrías beneficiarte de ejercicios que fortalezcan la concentración
    y la retención de información a corto plazo. Para ello, te recomiendo practicar juegos de memoria, 
    realizar ejercicios de atención plena y pequeños desafíos mentales diarios. Estas actividades te ayudarán a
        potenciar aún más tu rendimiento.
'''


def ia_api(data: str, usuario: str):
    try:
        finalPrompt = (
            f"{os.getenv('BASE_PROMPT', 'BASE_PROMPT_NO_DEFINIDO')}\n\n"
            f"Nombre del usuario: {usuario}\n"
            f"Resultados: {data}"
        )

        print("welcome that server")

        headers = {
            "Authorization": f"Bearer {os.getenv('OPENAI_API_KEY')}",
            "Content-Type": "application/json",
        }

        body = {
            "model": "gpt-4o-mini",
            "messages": [{"role": "user", "content": finalPrompt}],
            "temperature": 0.7,
            "max_tokens": 600,
        }

        response = requests.post(
            "https://api.openai.com/v1/chat/completions",
            headers=headers,
            json=body
        )
        response.raise_for_status()  
        return response.json()

    except Exception as e:
        return {"error": str(e)}