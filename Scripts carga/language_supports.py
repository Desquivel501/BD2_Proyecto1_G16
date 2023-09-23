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
support = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/language_supports', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                                'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields game, language_support_type, language; limit 500; offset ' + str(offset) + ';'})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    support.extend(getTuples(res))

    print(".", end="")

print("")

insert("INSERT INTO BD2.dbo.language_support(language_supports_id, game_id, lenguage_id, support_type_id)VALUES(%d, %d, %d, %d)", support)

end = time.time()
print('Languages Added: ' + str(len(support)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")
