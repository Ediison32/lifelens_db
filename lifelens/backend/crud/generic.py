# from sqlalchemy import text
# from sqlalchemy.exc import SQLAlchemyError
# from lifelens.backend.db import db
# from lifelens.backend.crud.functions import update_results

# def _handle_error(e: SQLAlchemyError):
#     db.session.rollback()
#     return {"error": str(e)}, 500

# def create_record(table: str, data: dict, user_id: int):
#     print(table, data, user_id)
#     """
#     Inserta una fila en la tabla indicada.
#     Si la tabla es 'trail_making' recalcula results para el usuario.
#     Devuelve (respuesta_json, status_code) y el id insertado.
#     """
#     try:
#         cols   = ", ".join(data.keys())
#         values = ", ".join(f":{k}" for k in data.keys())
#         sql = text(f"INSERT INTO {table} ({cols}) VALUES ({values})")
#         result = db.session.execute(sql, data)
#         db.session.commit()
#         new_id = result.lastrowid

#         # Lanzar recálculo solo al final
#         print("El nombre de la tabla es : "+ table + "entro al grupo ")
#         if table == 'trail_making':
#             print("El nombre de la tabla es : "+ table + "entro al grupo ")
#             update_results(user_id)

#         return {"id": new_id, "message": f"Row inserted in {table}"}, 201
#     except SQLAlchemyError as e:
#         return _handle_error(e)