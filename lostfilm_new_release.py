#!/bin/python3
# $> ./lostfilm_new_release.py
# Выход нового релиза
import requests

headers = {
    'Referer': 'https://www.lostfilm.today/series/?type=search&s=3&t=0',
    'Content-Type': 'application/x-www-form-urlencoded',
}

proxies = {
    'http': 'http://localhost:1080',
    'https': 'http://localhost:1080',
}

data = {'act': 'serial', 'type': 'search', 'o': '0', 's': '3', 't': '0'}

response = requests.post('https://www.lostfilm.today/ajaxik.php', 
                         headers=headers, data=data, proxies=proxies, timeout=7).json()

data = response.get('data', {})
if not data:
    exit(0)

RED = "\033[31m"
YELLOW = "\033[33m"
BLUE = "\033[34m"
MAGENTA = "\033[35m"
CYAN = "\033[36m"
B_CYAN = "\033[7;36m"
WHITE = "\033[37m"
NORMAL = "\033[0m"

for dt in data:
    title, title_orig, date = dt['title'], dt['title_orig'], dt['date']
    link, status_season = dt['link'], dt['status_season']
    genres, channels = dt['genres'], dt['channels']
    if not status_season:
        status_season = 'еще не вышел в прокат'
    print(f"название: {WHITE}{title}{NORMAL} ({MAGENTA}{title_orig}{NORMAL})")
    print(f"жанр: {CYAN}{genres}{NORMAL}")
    print(f"ссылка: {RED}https://www.lostfilm.today{link}{NORMAL}")
    print(f"сезон: {B_CYAN}{status_season}{NORMAL}, "
          f"год: {YELLOW}{date}{NORMAL}, студия: {BLUE}{channels}{NORMAL}\n")
