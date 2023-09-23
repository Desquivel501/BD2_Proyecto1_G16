from requests import post
import os
from dotenv import load_dotenv
import time
import pymssql
import json

load_dotenv()

conn = pymssql.connect(
    host=os.getenv('HOST'),
    user=os.getenv('USERNAME'),
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
involved_companies = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/involved_companies', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                                 'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields game, company, developer, porting, publisher, supporting; limit 500; offset ' + str(offset) + ';'})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    involved_companies.extend(getTuples(res))

    print(".", end="")

print("")

insert("INSERT INTO BD2.dbo.involved_companies(involved_id, company_id, developer, game_id, porting, publisher, supporting )VALUES(%d, %d, %d, %d, %d, %d, %d)", involved_companies)

end = time.time()
print('Involved Companies Added: ' + str(len(involved_companies)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")
