#!/bin/bash
# $> ./kinobox_popular.sh

source ./text-color.sh

host=$(curl -s --location 'https://kinobox.tv/go/demo' | \
       grep "location.href = '" | \
       sed "s/location.href = '//g ; s/...$//g" | awk '{print $1}')

for type in film series; do 
  echo -e "${red}Популярные ${type}"
  title_film=$(curl -s "https://kp.kinobox.tv/films/popular?${type}=true")
  for number in {0..49}; do 
    title=$(echo -n "${title_film}" | jq -r ".data.films.[$number].title.russian")
    id=$(echo -n "${title_film}" | jq -r ".data.films.[$number].id")
    echo -e "${blue}${title}: ${violet}${host}/film/${id}"
    done
  done
echo -ne "${normal}"

