#!/bin/bash
# $> ./megapeer_rss.sh

source ./text-color.sh

source ./proxy.sh 1> /dev/null

src='https://megapeer.vip/rss'
tag1='<title>'
tag2='<link>'
tag3='<\/title>'
tag4='<\/link>'

html=$(curl -s ${proxy} ${src})
rss=$(echo "${html}" | iconv -f cp1251 | grep "${tag1}" -A 1 | tail +6 | \
      sed "4~6d;5~6d;6~6d ; s/${tag1}/\\${blue}/g ; s/${tag2}/\\${violet}/g ; s/${tag3}//g ; s/${tag4}//g ; s/--//g" )

echo -e "${rss}${normal}"

