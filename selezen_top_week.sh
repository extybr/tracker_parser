#!/bin/bash
# $> ./selezen_top_week.sh

source ./text-color.sh

source ./proxy.sh 1> /dev/null

src='https://use.selezen.club/best-of-the-week.html'
tag1='<h6 class=\"mb-1 font-14\">'
tag2='<tr role=\"row\" class=\"cursor-pointer\" onclick=\"location.href='

html=$(curl -s ${proxy} ${src})
name=$(echo "${html}" | grep -oP "${tag1}[^<]+" | sed "s/${tag1}//g")
url=($(echo "${html}" | grep -oP "${tag2}[^<]+" | sed "s/${tag2}//g ; s/;\">//g ; s/html'/html/g ; s/'https/https/g"))

IFS=$'\n'
counter=0
for title in ${name}; do
  echo -e "${violet}${title}${normal}"
  echo -e "${blue}${url[$counter]}${normal}\n"
  ((counter+=1))
done

