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
rss=$(echo "${html}" | grep "${tag1}" -A 3 | tail +5 | \
      sed "2~5d;3~5d ; s/${tag1}/\\${blue}/g ; s/${tag2}/\\${violet}/g ; s/${tag3}//g ; s/${tag4}//g ; s/--//g" )

echo -e "${rss}${normal}"

