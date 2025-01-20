#!/bin/bash
# $> ./kinobox_popular.sh

source ./text-color.sh

host=$(curl -s --location 'https://kinobox.tv/go/demo' | \
       grep "location.href = '" | \
       sed "s/location.href = '//g ; s/...$//g" | awk '{print $1}')

for type in film series; do 
  echo -e "${red}Популярные ${type}"
  title_film=$(curl -s "https://kinobox.tv/api/films/popular?type=${type}")
  for number in {0..49}; do 
    title=$(echo -n "${title_film}" | jq -r ".[$number].title")
    id=$(echo -n "${title_film}" | jq -r ".[$number].id")
    echo -e "${blue}${title}: ${violet}${host}/film/${id}"
    done
  done
echo -ne "${normal}"

