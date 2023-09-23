from requests import post
import os
from dotenv import load_dotenv
import time
import pymssql

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


def chunks(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]


def insert(query, data, chunk=500):
    insert_q, values_q = query.split('VALUES')
    insert_q += 'VALUES'
    for chunk_data in chunks(data, chunk):
        flat_list = [item for sublist in chunk_data for item in sublist]
        chunk_query = insert_q + ','.join([values_q] * len(chunk_data))
        cursor.execute(chunk_query, tuple(flat_list))
        conn.commit()

# --------------------------------------------------------------------------------------------------------------------------------------------------


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

# --------------------------------------------------------------------------------------------------------------------------------------------------


offset = 0
companies = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/companies', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                        'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields name; limit 500; offset ' + str(offset) + ';'})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    companies.extend(getTuples(res))
    print(".", end="")

insert("INSERT INTO BD2.dbo.company(company_id, name) VALUES (%d, %s)", companies)

end = time.time()
print('Companies Added: ' + str(len(companies)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")

# --------------------------------------------------------------------------------------------------------------------------------------------------

offset = 0
lenguage = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/languages', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                        'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields name, native_name; limit 500; offset ' + str(offset) + ';  '})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    lenguage.extend(getTuples(res))
    print(".", end="")


insert(
    "INSERT INTO BD2.dbo.[language](lenguage_id, name, native_name) VALUES (%d, %s, %s)", lenguage)

end = time.time()
print('Lenguages Added: ' + str(len(lenguage)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")

# --------------------------------------------------------------------------------------------------------------------------------------------------


offset = 0
platforms = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/platforms', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                        'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields name; limit 500; offset ' + str(offset) + ';  '})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    platforms.extend(getTuples(res))
    print(".", end="")

print("")

insert(
    "INSERT INTO BD2.dbo.platform(platform_id, name)VALUES(%d, %s)", platforms)

end = time.time()
print('Platforms Added: ' + str(len(platforms)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")

# --------------------------------------------------------------------------------------------------------------------------------------------------

insert(
    "INSERT INTO BD2.dbo.region(id_region, name)VALUES(%d, %s)", [(1, 'europe'), (2, 'north_america'), (3, 'australia'), (
        4, 'new_zealand'), (5, 'japan'), (6, 'china'), (7, 'asia'), (8, 'worldwide'), (9, 'korea'), (10, 'brazil'),]
)

# --------------------------------------------------------------------------------------------------------------------------------------------------


offset = 0
themes = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/themes', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                     'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields name; limit 500; offset ' + str(offset) + ';  '})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    themes.extend(getTuples(res))
    print(".", end="")

print("")

insert(
    "INSERT INTO BD2.dbo.theme(theme_id, name)VALUES(%d, %s)", themes)

end = time.time()
print('Themes Added: ' + str(len(themes)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")

# --------------------------------------------------------------------------------------------------------------------------------------------------


offset = 0
game_modes = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/game_modes', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                         'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields name; limit 500; offset ' + str(offset) + '; '})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    game_modes.extend(getTuples(res))
    print(".", end="")

print("")

insert(
    "INSERT INTO BD2.dbo.game_mode(game_mode_id, name)VALUES(%d, %s)", game_modes)

end = time.time()
print('Modes Added: ' + str(len(game_modes)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")

# --------------------------------------------------------------------------------------------------------------------------------------------------

offset = 0
genres = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/genres', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                     'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields name; limit 500; offset ' + str(offset) + ';  '})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    genres.extend(getTuples(res))
    print(".", end="")

print("")

insert(
    "INSERT INTO BD2.dbo.genre(genre_id, name)VALUES(%d, %s)", genres)

end = time.time()
print('Genres Added: ' + str(len(genres)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")

# --------------------------------------------------------------------------------------------------------------------------------------------------


offset = 0
game_engines = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/game_engines', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                           'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields name; limit 500; offset ' + str(offset) + ';  '})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    game_engines.extend(getTuples(res))
    print(".", end="")

print("")

insert(
    "INSERT INTO BD2.dbo.game_engine(game_engine_id, name)VALUES(%d, %s)", game_engines)

end = time.time()
print('Engines Added: ' + str(len(game_engines)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")

# --------------------------------------------------------------------------------------------------------------------------------------------------

offset = 0
player_perspectives = []
start = time.time()
while True:
    response = post('https://api.igdb.com/v4/player_perspectives', **{'headers': {'Client-ID': os.getenv('CLIENT_ID'),
                                                                                  'Authorization': os.getenv('AUTORIZATION')}, 'data': 'fields name; limit 500; offset ' + str(offset) + ';  '})

    if (response.status_code != 200):
        print("Code: ", str(response.status_code))
        print("Error: ", response.text)
        break

    res = response.json()

    if res == []:
        break

    offset += 500
    player_perspectives.extend(getTuples(res))
    print(".", end="")

print("")

insert(
    "INSERT INTO BD2.dbo.perspective(perspective_id, name)VALUES(%d, %s)", player_perspectives)

end = time.time()
print('Perspectives Added: ' + str(len(player_perspectives)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")


# --------------------------------------------------------------------------------------------------------------------------------------------------

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

    break

print("")

insert("INSERT INTO BD2.dbo.involved_companies(involved_id, company_id, developer, game_id, porting, publisher, supporting )VALUES(%d, %d, %d, %d, %d, %d, %d)", involved_companies)

end = time.time()
print('Involved Companies Added: ' + str(len(involved_companies)))
print('Elapsed Time: ' + str(end - start) + 's')
print("-----------------------------------")
