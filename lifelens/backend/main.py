from flask import request, jsonify
from lifelens.backend import create_app
from flask_cors import CORS
from lifelens.backend.crud.users import (
    create_record, 
    get_records, 
    get_record,
    update_record, 
    delete_record,
    create_user, 
    update_result,
    get_all_totals
)

# Creamos la app Flask
app = create_app()
CORS(app)

# -------------------------------
# Endpoints principales
# -------------------------------

@app.route("/")
def home():
    return {"msg": "Servidor Flask corriendo"}

# CRUD genérico para cualquier tabla
@app.route("/<string:table>", methods=["GET", "POST"])
def handle_table(table):
    if request.method == "POST" and table != 'user':
        print(request.json)
        return create_record(table, request.json)
    
    elif request.method == "POST" and table == 'user':
        return create_user(table, request.json)
    
    elif table == "users_total":
        return get_all_totals()
    
    return get_records(table)

# Actualizar toda la tabla result según el id
@app.route("/users/<int:user_id>/calculate", methods=["POST"])
def recalc_user(user_id):
    return update_result(user_id)

# Endpoint de IA (comentado por ahora)
# @app.route("/api/chat/<string:data>", methods=["POST"])
# def api_chat(data):
#     body = request.get_json()
#     # ia_api(body,data)
#     return jsonify(ia_api(body,data))

# Obtener usuario por documento
@app.route("/<string:table>/<string:document>", methods=["GET"])
def get_user(user_id):
    # 1. El usuario se busca en la tabla "users" por su id_user
    table  = "user"
    id_val = user_id
    id_col = "document"
    return get_record(table, id_val, id_col)

# CRUD por ID
@app.route("/<string:table>/<int:id_val>", methods=["GET", "PUT", "DELETE"])
def handle_record(table, id_val):
    id_col = request.args.get("id_col", "id")  # Permite cambiar la PK

    # Traer usuario por documento
    if request.method == "GET" and table == 'document':
        table = "user"
        id_col = "document"
        return get_record(table, id_val, id_col)
    
    # GET por id de tabla
    elif request.method == "GET":
        id_col = "id_" + table
        return get_record(table, id_val, id_col)
    
    # PUT actualizar con id
    elif request.method == "PUT":
        id_col = "id_" + table
        return update_record(table, id_val, request.json, id_col)
    
    # DELETE
    elif request.method == "DELETE":
        if table == 'user':
            id_col = "id_" + table
            return delete_record(table, id_val, id_col)

# -------------------------------
# Favicon para evitar errores 500
# -------------------------------
@app.route("/favicon.ico")
def favicon():
    return "", 204

# -------------------------------
# Serverless para Vercel
# -------------------------------
from serverless_wsgi import handle_request

def handler(event, context):
    return handle_request(app, event, context)

# -------------------------------
# Nota: Se elimina app.run() ya que Vercel usa serverless
# -------------------------------
# if __name__ == "__main__":
#     app.run(host="0.0.0.0", port=5000)
