#!/bin/bash
# $> ./film_rating.sh 1274452

source ./text-color.sh

if [ "$#" -eq 0 ]; then
  echo -e "\n ${yellow}Примеры запуска:\n"\
          "${yellow}Поиск рейтинга фильма по его ID на кинопоиске: ${blue}./film_rating.sh 1274452\n${normal}"
  exit 0
fi

if [ "$#" -ne 1 ]
	then echo -e "${white}ожидалось 1 параметр, а передано $#${normal}"
	exit 1
fi

rating=$(curl -s "https://rating.kinopoisk.ru/1274452.xml")
result=($(echo "${rating}" | grep -oP ">[^<]+" | sed 's/^.//'))
echo "KINOPOISK: ${result[0]}"
echo "IMDB: ${result[1]}"
# echo "${rating}" | grep -oE '>[1-9]{1}.[1-9]{1,5}' | sed 's/^.//'
# echo "${rating}" | awk -F'[><]' '{for (i=1; i<=NF; i++) if ($i ~ /^[0-9]+\.[0-9]+$/) print $i}'
# echo "${rating}" | sed -n 's/.*>\([0-9]\+\.[0-9]\+\)<.*>\([0-9]\+\.[0-9]\+\)<.*/\1\n\2/p'
# echo "${rating}" | perl -nle 'print $1 while />(\d+\.\d+)</g'
echo -e "${violet}https://rating.kinopoisk.ru/$1.gif${normal}"

