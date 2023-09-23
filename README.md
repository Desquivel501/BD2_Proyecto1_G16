# BD2_Proyecto1_G16

## Carga de datos

La carga de datos se realizara con una serie de apis de pythn.

### Insert

Debido a la cantidad de datos se ha elaborado una función que hace udo de las bulk insert de SQL Server:

```SQL
INSERT INTO Tabla(columna1, columna2, columna3) VALUES (?,?,?)
```

Utilizando este comando de SQL se puede insertar multiples datos al concatenar multiples tuplas.

Primero se definio una funcion que separa las tuplas en chunks de n valores, para asi poder controlar cuantas filas se insertaran por peticion.

```Python
def chunks(lst, n):
for i in range(0, len(lst), n):
    yield lst[i:i + n]
```

Una vez se pueden separar las tuplas se procede formular la peticion. Esto se hara con la funcion:

```Python
def insert(query, data, chunk=500):
    insert_q, values_q = query.split('VALUES')
    insert_q += 'VALUES'
    for chunk_data in chunks(data, chunk):
        flat_list = [item for sublist in chunk_data for item in sublist]
        chunk_query = insert_q + ','.join([values_q] * len(chunk_data))
        cursor.execute(chunk_query, tuple(flat_list))
        conn.commit()
```

Procederemos a explicar el funcionamiento de esta funcion paso por paso.

1. Esta función está diseñada para insertar datos en una tabla de base de datos en fragmentos más pequeños para mejorar el rendimiento. Se necesitan tres argumentos:

   - `query`: la consulta SQL para insertar datos en la tabla.
   - `data`: la lista de datos que se insertarán en la tabla de la base de datos.
   - `chunk` (opcional, el valor predeterminado es 500): un número entero que especifica el tamaño de los chunks para dividir la lista de datos.

2. La función comienza dividiendo la consulta SQL de entrada en dos partes: la parte anterior a la palabra clave `VALUES` (`insert_q`) que contiene el nombre de la tabla y las columnas y la parte posterior (`values_q`), que contiene los tipos de cada valor en la columna.

3. Agrega `VALUES` a insert_q para garantizar la sintaxis SQL adecuada.

4. A continuación, la función utiliza un ciclo for para recorrer chunks de la lista de datos. Para cada fragmento, aplana el fragmento (que puede contener sublistas) en una única lista plana (`flat_list`).

5. Luego construye una nueva consulta SQL (`chunk_query`) repitiendo los valores_q para la cantidad de elementos en el fragmento.

6. Finalmente, utiliza un cursor de base de datos para ejecutar la consulta en `chunk_query` con los datos aplanados (`flat_list`) como parámetro y confirma los cambios en la base de datos.

Esta funcion para cargar los datos a SQL Server demostro ser ampliamente superior a realizar las peticiones de forma individual o incluso utilizar el metodo `bulk-insert` incluido en la libreria `pymssql`

### Consumir API

Para obtener los datos se consumira la API de `igdb`.
Esta API tiene el invonveniente que solo puede regresar 500 datos a la vez, por lo que fue necesario utilizar un ciclo `while` y un offset para obtener todos los datos.

Un ejemplo de este proceso es:

```Python
offset = 0
franchises = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/franchises', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                         'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields name; limit 500; offset ' + str(offset) + ';'})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    franchises.extend(getTuples(res))

insert("INSERT INTO BD2.dbo.franchise(franchise_id, name) VALUES (%d, %s)", franchises)

end = time.time()
print('Franchises Added: ' + str(len(franchises)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")
```

Procederemos a explicar el funcionamiento de este ciclo paso por paso.

1. Primero se declaran 3 variables que seran utilizadas en el ciclo:

   - `offset`: Este sera utilizado para saber a partir de que dato se deberan de recibir de la API
   - `franchises`: Lista donde se almacenaran los datos recolectados
   - `start`: Variable donde se almacenara el tiempo de cuando inicio la carga.

2. Se inicia el ciclo `While True`

3. Se realizara la llamada a la API. Para esto se necesita colocar el URL de la API, una lista con los headers y las restricciones de los datos.

   - API URL: Este es el endpoint de donde se recibiran los datos.
   - `headers`: Estos seran headers necesarios para conectarse con la API, estos son:
     - `Client-ID`: Identificador unico de la aplicacion
     - `Authorization`: Este es un token generado en IGDB para poder consumir la API
   - `data`: Estas seran restricciones para los datos recibidos de la API.

4. Se verificara si la peticion fue exitosa (Regreso un codigo HTTP 200)

5. Se obtienen los datos.

6. Se convierte el JSON en una tupla y se agrega a la lista

7. Se envia la lista de tuplas a la funcion `insert` para ser ingresadas a la base de datos

8. Se muestra cuantos registros fueron ingresados en la base de datos y cuanto tiempo tardo en realizarse la subida de datos.

### Casos especiales

Mientras que el proceso explicado anteriormente funciona para algunas tablas, otras tienen algunas caracteristicas que hacen que se deba de modificar ligeramente.

Un ejemplo de esto puede ser cuando en los datos recolectados una de las llaves de algun objeto no esten presentes, esto impide que se pueda convertir a tuplas, ya que no todas serian del mismo tamaño. Para esto se realizan dos funciones, una que buscara llaves faltantes y otro que ordenara el objeto, para que al ser convertido en tuplas todos sean iguales:

```Python
def addMissingKeys(games):
    new_games = []
    for game in games:
        if 'comment' not in game:
            game['comment'] = ""
        new_games.append(sortDict(game))
    return new_games

def sortDict(d):
    keys = list(d.keys())
    keys.sort()
    sorted_dict = {i: d[i] for i in keys}
    return sorted_dict

```

1. Se recorre la lista de objetos, si una de las llaves problematicas no esta en ese objeto se agrega con un valor vacio.

2. Se ordena el diccionario, esto se hace:
   1. Obteniendo todas las llaves del diccionario en una lista.
   2. Ordenando esta lista con la funcion incluida en python `.sort()`
   3. Se crea el nuevo diccionario, recorriendo la lista de llaves y emparejandolas con su valor respectivo.

Otro caso especial es cuando el endpoint regresa valores en una lista dentro del diccionario. Esto nos obliga a tener que parsear esta lista para generar las tuplas de manera manual.

```Python
counter = 1
def parseData(game_list):
    global counter
    new_franchises = []
    for game in game_list:
        for franchise in game['franchises']:
            new_franchises.append((counter, franchise, game['id']))
            counter += 1

    return new_franchises
```

1. Se define una variable contador, esta actuara como el indice de cada registro.

2. Se obtiene la lista de datos crudos (`game_list`).

3. Se define una lista donde se almacenaran los nuevos valores.

4. Se recorre la lista de juegos en `game_list`

5. En este caso, cada juego tiene una lista de franquicias, por lo que recorreremos esta lista.

6. Por cada valor en la lista de franquicias agregaremos una nueva tubla, agregando el indice, los datos de la franquicia y el id del juego.

7. Se aumenta el contador.

Otro problema ocurre con las fechas, ya que estas pueden o no estar presentes en el diccionario, y si estan presentes no estan parseadas para ser utilizadas en la base de datos, por lo que se debera de parsear cada fecha individualmente.

```Python
def changeDate(lst):
    new_lst = []
    for i in lst:
        if 'date' not in i:
            i['date'] = '1900-01-01'
        else:
            i['date'] = datetime.utcfromtimestamp(
                i['date']).strftime('%Y-%m-%d')

        new_lst.append(sortDict(i))

    return new_lst
```

1. Se obtiene la lista de objetos `lst`

2. Se recorre esta lista de objetos.

3. Si la llave `date` se agrega al diccionario con un valor por defecto.

4. Si la llave si existe se procede a parsear la fecha con el formato '%Y-%m-%d'.

5. Se ordena el diccionario.
