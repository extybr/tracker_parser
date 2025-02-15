#!/bin/python3
# $> ./lostfilm_new_series.py
# Выход новой серии
import subprocess

data = subprocess.getoutput('./lostfilm_new_series.sh').split('\n')

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
LINE = "\n"

color = {1: MAGENTA, 2: WHITE, 3: CYAN, 4: YELLOW, 5: BLUE, 6: B_CYAN, 7: B_CYAN, 8: LINE}

c = 0
for dt in data:
    s = '\n'
    if c == 1 or c == 3:
        s = ' | '
    elif c == 8:
        c = 0
    c += 1
    print(f"{color[c]}{dt}{NORMAL}", end=s)
