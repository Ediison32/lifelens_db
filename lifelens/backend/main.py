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

app = create_app()
CORS(app)    
@app.route("/")
def home():
    return {"msg": "Servidor Flask corriendo"}

# CRUD genérico para cualquier tabla

@app.route("/<string:table>", methods=["GET", "POST"])
def handle_table(table):
    if request.method == "POST" and table != 'user':
        print(  request.json)
        return create_record(table, request.json)
    
    elif( request.method == "POST" and table == 'user'):
        return create_user(table, request.json)
    elif(table == "users_total"):
        return get_all_totals()
    return get_records(table)


# actualizar toda la tabla result segunel id 
# POST /users/7/calculate
@app.route("/users/<int:user_id>/calculate", methods=["POST"])
def recalc_user(user_id):
    return update_result(user_id)



@app.route("/<string:table>/<string:document>", methods=["GET"])
def get_user(user_id):
    # 1. El usuario se busca en la tabla "users" por su id_user
    
    table  = "user"
    id_val = user_id
    id_col = "document"
    return get_record(table, id_val, id_col)



@app.route("/<string:table>/<int:id_val>", methods=["GET", "PUT", "DELETE"])
def handle_record(table, id_val):
    id_col = request.args.get("id_col", "id")  # Permite cambiar la PK

    # para traer usuario por documento ---- > http://localhost:5000/document/documento
    if request.method == "GET" and table == 'document':
        table = "user"
        id_col = "document"
        
        return get_record(table, id_val, id_col)
    

    #http://localhost:5000/user/id_user
    elif request.method == "GET":
        id_col = "id_"+table
        if table == "user":
            update_result(id_val)
        return get_record(table, id_val, id_col)
    

    # actualizar con id 
    elif request.method == "PUT":
        id_col = "id_"+table
        return update_record(table, id_val, request.json, id_col)
    

    elif request.method == "DELETE":
        if table == 'user': 
            id_col = "id_"+table
            return delete_record(table, id_val, id_col)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)


# https://lifelensadmin.vercel.app/analitica.html?id=2