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


def sortDict(d):
    keys = list(d.keys())
    keys.sort()
    sorted_dict = {i: d[i] for i in keys}
    return sorted_dict


def addMissingKeys(games):
    new_games = []
    for game in games:
        if 'summary' not in game:
            game['summary'] = ""
        else:
            game['summary'] = str(game['summary'][0:4000])

        if 'total_rating' not in game:
            game['total_rating'] = 0

        if 'total_rating_count' not in game:
            game['total_rating_count'] = 0

        if 'storyline' not in game:
            game['storyline'] = ""
        else:
            game['storyline'] = str(game['storyline'][0:4000])

        new_games.append(sortDict(game))
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
games = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/games', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                    'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields name, total_rating, total_rating_count, summary, storyline, franchise; limit 500; offset ' + str(offset) + ';'})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    res = addMissingKeys(res)

    offset += 500
    games.extend(getTuples(res))
    print(".", end="")

print("")

insert(
    "INSERT INTO BD2.dbo.game(game_id, name, storyline, summary, rating, total_ratings)VALUES(%d, %s, %s, %s, %d, %d)",
    games)


end = time.time()
print('Games Added: ' + str(len(games)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")
