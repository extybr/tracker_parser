#!/bin/bash
# $> ./megapeer_top.sh

source ./text-color.sh

source ./proxy.sh 1> /dev/null

src='https://megapeer.vip/top'
tag1='<a href=\"\/torrent'
tag2='\" class'
tag3='https:\/\/megapeer.vip\/torrent'

html=$(curl -s ${proxy} ${src})
url=($(echo "${html}" | grep -oP "${tag1}[^<]+${tag2}" | sed "s/${tag1}/${tag3}/g ; s/${tag2}/\\n/g"))

echo -e "${top}ТОП за последние 24 часа${normal}"
for i in {0..29}; do
  echo -e "${blue}${url[$i]}"
done

echo -e "${top}Зарубежные фильмы${normal}"
for i in {30..44}; do
  echo -e "${blue}${url[$i]}"
done

echo -e "${top}Зарубежные сериалы${normal}"
for i in {60..74}; do
  echo -e "${blue}${url[$i]}"
done
echo -ne "${normal}"

