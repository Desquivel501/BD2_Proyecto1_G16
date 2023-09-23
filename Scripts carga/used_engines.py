from requests import post
import os
from dotenv import load_dotenv
import time
import pymssql
import json

load_dotenv()

conn = pymssql.connect(
    host=os.getenv('HOST'),
    user=os.getenv('USER_NAME'),
    password=os.getenv('PASSWORD'),
    database=os.getenv('DATABASE')
)

cursor = conn.cursor(as_dict=True)


def getTuples(lst):
    join = []
    for i in lst:
        join.append(tuple(i.values()))
    return join


counter = 1


def parseData(game_list):
    global counter
    new_franchises = []
    for game in game_list:
        for engine in game['game_engines']:
            new_franchises.append((counter, engine, game['id']))
            counter += 1

    return new_franchises


def chunks(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]


def insert(query, data, chunk=999):
    insert_q, values_q = query.split('VALUES')
    insert_q += 'VALUES'
    for chunk_data in chunks(data, chunk):
        flat_list = [item for sublist in chunk_data for item in sublist]
        chunk_query = insert_q + ','.join([values_q] * len(chunk_data))
        cursor.execute(chunk_query, tuple(flat_list))
        conn.commit()


offset = 0
engines = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/games', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                    'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields game_engines; limit 500; offset ' + str(offset) + '; where game_engines != null;'})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    engines.extend(parseData(res))

    print(".", end="")


print("")

insert("INSERT INTO BD2.dbo.used_engine(used_engine_id, game_engine_id, game_id)VALUES(%d, %d, %d)", engines)

end = time.time()
print('Used Engines Added: ' + str(len(engines)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")
