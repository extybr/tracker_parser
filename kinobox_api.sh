#!/bin/bash
# $> ./kinobox_api.sh 'Resident Evil'

source ./text-color.sh

host=$(curl -s --location 'https://kinobox.tv/go/demo' | \
       grep "location.href = '" | \
       sed "s/location.href = '//g ; s/...$//g" | awk '{print $1}')

if [ "$#" -eq 0 ]; then
  echo -e " ${yellow}Примеры запуска:\n"\
          "${yellow}Поиск по названию:"\
          "${blue}./kinobox_api.sh 'Resident Evil'\n${normal}"
  exit 0
fi

if [ "$#" -ne 1 ]
	then echo -e "${yellow}ожидалось 1 параметр, а передано $#${normal}"
	exit 1
fi

film=$(./url_coder.py "encoder" "$1" | sed 's/ /%20/g')
url="https://kp.kinobox.tv/films/search/?query=${film}"
request=$(curl -s "${url}")
if [[ "${request}" ]]; then
  for item in {0..100}; do
    title=$(echo "${request}" | jq -r ".data.films.[$item].title.original")
    alternativeTitle=$(echo "${request}" | jq -r ".data.films.[$item].title.russian")
    id=$(echo "${request}" | jq -r ".data.films.[$item].id")
    year=$(echo "${request}" | jq -r ".data.films.[$item].posterUrl.year")
    if [[ "${title}" = 'null' ]]; then
      break
    else echo -e "${blue}${title}${normal}"\
    "(${violet}${alternativeTitle}${normal} / ${yellow}${year}${normal}):"\
    "${bold}${host}/film/${white}${id}${normal}"
    fi
  done
fi

