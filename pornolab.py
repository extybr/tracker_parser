#!/bin/python3
############################
# $> ./pornolab.py         #
# $> ./pornolab.py 0       #
# $> ./pornolab.py 0 1867  #
# $> ./pornolab.py 1867    #
# $> ./pornolab.py -h      #
############################

import sys
import re
import subprocess

red = "\033[31m"
yellow = "\033[33m"
blue = "\033[36m"
normal = "\033[0m"

proxy = subprocess.getoutput('./proxy.sh')
number = 1872


def fail() -> None:
    print(f'{red}*** Fail ***{normal}')
    exit(0)


def help_message() -> str:
    return (f' {yellow}Примеры запуска:\n'
            f' {yellow}Справка: {blue}./pornolab.py help\n'
            f' {yellow}Без прокси: {blue}./pornolab.py 0\n'
            f' {yellow}Сайтрипы 2025 (HD Video) / SiteRip`s 2025 (HD Video):'
            f' {blue}./pornolab.py 1872\n {yellow}Эротические студии Разное /'
            f' Erotic Picture Gallery (various): {blue}./pornolab.py 883\n'
            f' {yellow}MetArt & MetModels: {blue}./pornolab.py 1726{normal}')


if len(sys.argv) == 1:
    print(help_message())
    exit(0)
elif len(sys.argv) == 2:
    if sys.argv[1] in ('h', '-h', 'help', '-help'):
        print(help_message())
        exit(0)
    elif sys.argv[1] == '0':
        proxy = ''
    elif sys.argv[1] == '1':
        pass
    else:
        number = sys.argv[1] if sys.argv[1].isdigit() else fail()
elif len(sys.argv) == 3:
    if sys.argv[1] == '0':
        proxy = ''
    number = sys.argv[2] if sys.argv[2].isdigit() else fail()
elif len(sys.argv) > 3:
    fail()

cmd = f"curl -s {proxy} --max-time 10 --location "
link = f"'https://pornolab.net/forum/viewforum.php?f={number}'"
html = subprocess.getoutput(cmd + link, encoding='cp1251')

if not html:
    fail()

pattern = r'.+tt-text.+</a>'
result = re.compile(pattern).findall(html)

for item in result:
    url = 'https://pornolab.net/forum/' + item[13:36]
    title = item[65:-4].replace('<wbr>', '')
    print(f'{blue}{title}{normal}\n{yellow}{url}{normal}\n')
