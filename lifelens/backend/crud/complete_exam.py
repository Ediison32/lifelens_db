from sqlalchemy import text
from sqlalchemy.exc import SQLAlchemyError
from lifelens.backend.db import db
from lifelens.backend.crud.generic import create_record
from lifelens.backend.crud.functions import update_results

def _handle_error(e: SQLAlchemyError):
    db.session.rollback()
    return {"error": str(e)}, 500

def complete_exam_logic(data: dict):
    """
    1. Busca al usuario por documento
    2. Crea filas en gonogo, hanoi, stroop, trail_making y results
    3. Actualiza el usuario con los nuevos IDs
    4. Recalcula results
    """
    try:
        # 1. Localizar usuario
        user = db.session.execute(
            text("SELECT id_user, id_results FROM users WHERE document = :doc"),
            {"doc": data["document"]}
        ).mappings().first()
        if not user:
            return {"error": "User not found"}, 404
        uid = user["id_user"]

        # 2. Crear filas hijas y capturar los IDs
        gonogo_id, _ = create_record("gonogo", data["gonogo"],uid)
        hanoi_id, _  = create_record("T_hanoi", data["hanoi"],uid)
        stroop_id, _ = create_record("stroop", data["stroop"],uid)
        trail_id, _  = create_record("trail_making", data["trail_making"],uid)
        results_id, _ = create_record("results", {},uid)  # vacío, luego se recalcula

        # 3. Actualizar usuario con los nuevos IDs
        db.session.execute(
            text("""
                UPDATE users
                SET id_gonogo = :g,
                    id_hanoi  = :h,
                    id_stroop = :s,
                    id_trail_making = :t,
                    id_results = :r
                WHERE id_user = :uid
            """),
            {"g": gonogo_id[0], "h": hanoi_id[0], "s": stroop_id[0],
             "t": trail_id[0],  "r": results_id[0], "uid": uid}
        )
        db.session.commit()

        # 4. Recalcular results
        return update_results(uid)
    except SQLAlchemyError as e:
        return _handle_error(e)