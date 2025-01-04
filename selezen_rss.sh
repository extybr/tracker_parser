#!/bin/bash
# $> ./selezen_rss.sh

source ./text-color.sh

source ./proxy.sh 1> /dev/null

src='https://use.selezen.club/rss.xml'

tag1='<title>'
tag2='<\/title'
tag3='<link>'
tag4='<\/link'
html=$(curl -s ${proxy} "${src}")
title=$(echo "${html}" | grep -oP "${tag1}[^<]+${tag2}" | sed "s/${tag1}//g ; s/${tag2}//g" | tail +2)
link=($(echo "${html}" | grep -oP "${tag3}[^<]+${tag4}" | sed "s/${tag3}//g ; s/${tag4}//g" | tail +2))

IFS=$'\n'
counter=0
for i in $(echo "${title}"); do
  echo -e "${blue}${i}"
  echo -e "${purple}${link[$counter]}\n"
  ((counter+=1))
done
echo -ne "${normal}"

