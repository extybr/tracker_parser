#!/bin/bash
# $> ./kinobox_popular.sh

source ./text-color.sh

host=$(curl -s --location 'https://kinobox.tv/go/demo' | \
       grep "location.href = '" | \
       sed "s/location.href = '//g ; s/...$//g" | \
       awk '{print $1}' | sed 's/\//\\\//g')
host="${host}\/film\/"

for type in films series; do
  popular=$(curl -s "https://kp.kinobox.tv/films/popular?${type}=true&released=true&page=1")
  echo -e "${red}Популярные ${type}${normal}"
  title=$(echo -n "${popular}" | jq -r ".data.films.[] | .title.russian, .id" | sed "N;s/\n/ 👉 ${host}/")
  echo -e "${blue}${title}${normal}"
done

