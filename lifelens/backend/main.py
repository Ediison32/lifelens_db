from flask import request, jsonify
from lifelens.backend import create_app
from flask_cors import CORS
from lifelens.backend.crud.users import (
    create_record, get_records, get_record,
    update_record, delete_record,create_user, update_result
)

app = create_app()
CORS(app)    
@app.route("/")
def home():
    return {"msg": "Servidor Flask corriendo"}

# CRUD genérico para cualquier tabla

@app.route("/<string:table>", methods=["GET", "POST"])
def handle_table(table):
    print(table)
    if request.method == "POST" and table != 'user':
        print(  request.json)
        return create_record(table, request.json)
    
    if( request.method == "POST" and table == 'user'):
        return create_user(table, request.json)

    return get_records(table)

# actualizar toda la tabla result segunel id 
# POST /users/7/calculate
@app.route("/users/<int:user_id>/calculate", methods=["POST"])
def recalc_user(user_id):
    print("entro a result")
    print(user_id)
    return update_result(user_id)



# get user 
#GET /user/12345678
@app.route("/<string:table>/<string:document>", methods=["GET"])
def get_user(user_id):
    # 1. El usuario se busca en la tabla "users" por su id_user
    table  = "user"
    id_val = user_id
    id_col = "document"
    print(table, id_val, id_col)
    return get_record(table, id_val, id_col)



@app.route("/<string:table>/<int:id_val>", methods=["GET", "PUT", "DELETE"])
def handle_record(table, id_val):
    id_col = request.args.get("id_col", "id")  # Permite cambiar la PK
    print(id_val , table)


    # para traer usuario por documento ---- > http://localhost:5000/document/documento
    if request.method == "GET" and table == 'document':
        table = "user"
        id_col = "document"
        print("mostarar por documento ")
       
        return get_record(table, id_val, id_col)
    

    #http://localhost:5000/user/id_user
    elif request.method == "GET":
        id_col = "id_"+table
        print(id_col, id_val)
        return get_record(table, id_val, id_col)
    

    # actualizar con id 
    elif request.method == "PUT":
        id_col = "id_"+table
        return update_record(table, id_val, request.json, id_col)
    

    elif request.method == "DELETE":
        if table == 'user': 
            
            print("entoroo ")
            id_col = "id_"+table
            print(table, id_val, id_col)
            return delete_record(table, id_val, id_col)

if __name__ == "__main__":
    app.run(debug=True, host="0.0.0.0", port=5000)