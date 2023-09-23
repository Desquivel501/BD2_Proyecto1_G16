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


def sortDict(d):
    keys = list(d.keys())
    keys.sort()
    sorted_dict = {i: d[i] for i in keys}
    return sorted_dict


def addMissingKeys(games):
    new_games = []
    for game in games:
        if 'comment' not in game:
            game['comment'] = ""
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
titles = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/alternative_names', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                    'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields name, game, comment; limit 500; offset ' + str(offset) + ';'})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    titles.extend(getTuples(addMissingKeys(res)))

    print(".", end="")

print("")

insert("INSERT INTO BD2.dbo.alternate_title(comment, game_id, alternate_title_id, title )VALUES(%s, %d, %d, %s)", titles)

end = time.time()
print('Alternative Titles Added: ' + str(len(titles)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")
