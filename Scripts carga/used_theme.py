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


def parseData(games):
    global counter
    new_games = []
    for game in games:

        if 'themes' not in game:
            continue

        for theme in game['themes']:
            new_games.append((counter, game['id'], theme))
            counter += 1

    return new_games


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
used_themes = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/games', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                    'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields themes; limit 500; offset ' + str(offset) + '; where themes != null;'})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    used_themes.extend(parseData(res))

    print(".", end="")

print("")

insert("INSERT INTO BD2.dbo.used_theme (used_theme_id, game_id, theme_id) VALUES (%d, %d, %d)", used_themes)

end = time.time()
print('Used Themes Added: ' + str(len(used_themes)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")
