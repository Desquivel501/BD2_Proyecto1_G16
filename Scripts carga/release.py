from requests import post
import os
from dotenv import load_dotenv
import time
import pymssql
import json
from datetime import datetime

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


def sortDict(d):
    keys = list(d.keys())
    keys.sort()
    sorted_dict = {i: d[i] for i in keys}
    return sorted_dict


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
releases = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/release_dates', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                            'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields game, platform, date, region; limit 500; offset ' + str(offset) + ';'})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    res = changeDate(res)

    offset += 500
    releases.extend(getTuples(res))

    print(".", end="")

print("")

insert(
    "INSERT INTO BD2.dbo.[release]([date], game_id, release_id, platform_id, region_id ) VALUES (%s, %d, %d, %d, %d)", releases)

end = time.time()
print('Releases Added: ' + str(len(releases)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")
