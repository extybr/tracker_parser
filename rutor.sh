#!/bin/bash
##############################################################
# $> ./rutor.sh                                              #
# $> ./rutor.sh 1                                            #
# $> ./rutor.sh 1 Marvel                                     #
# $> ./rutor.sh 0 'Resident evil'                            #
# $> ./rutor.sh 1 s                                          #
# $> ./rutor.sh 0 'http://rutor.info/torrent/999364'         #
# $> ./rutor.sh 1 'http://tracker.rutor.is/torrent/999364'   #
##############################################################

source ./text-color.sh

path='top'
proxy=''
titles=60

if [ "$#" -eq 0 ] || ( [ "$#" -eq 1 ] && [ "$1" = 'h' ] ); then
  echo -e "${yellow}\n Примеры запуска:\n"\
          "${yellow}Поиск по названию: ${blue}./rutor.sh 1 'Resident evil'\n"\
          "${yellow}Поиск по названию без прокси: ${blue}./rutor.sh 0 Marvel\n"\
          "${yellow}Сериалы по дате убывания (последние вышедшие вверху): "\
          "${blue}./rutor.sh 1 s\n"\
          "${yellow}Сериалы по дате убывания (последние вышедшие за сегодня): "\
          "${blue}./rutor.sh 1 sd\n"\
          "${yellow}Поиск магнет-ссылки по url-ссылке:${blue}"\
          "./rutor.sh 1 'http://rutor.info/torrent/999364'\n${normal}"
  exit 0
fi

if [ "$#" -eq 2 ]; then
  search=$(echo "$2" | sed 's/ /%20/g')
  path="search/${search}"
fi

if [ "$1" = '1' ]; then
  source ./proxy.sh 1> /dev/null
fi

if [ "$#" -eq 2 ] && [ "$2" = 's' ]; then
  path='seriali'
  titles=200
fi

if [ "$#" -eq 2 ] && [ "$2" = 'sd' ]; then
  path='seriali'
  title_day=$(curl -s ${proxy} --max-time 5 "http://rutor.info/${path}" | \
              grep -oP "<td>$(date '+%d')[^<]+" | wc -l)
  titles=$(( "${title_day}" * 2 ))
fi

rutor() {
request=$(curl -s ${proxy} --max-time 5 "http://rutor.info/${path}")
}

main() {

if rutor; then
  response=$(echo "${request}" | grep -oP '<a href="/torrent/[^<]+' | \
  sed 's/<a href="/http:\/\/rutor.info/g' | \
  sed "s/\">/\\n/g" | tail -n +7)

  IFS='|'
  result=$(echo "${response}" | head -n "${titles}")

  IFS=$'\n'
  count=1
  temp=''
  for line in ${result}
  do 
    if [ $(expr "${count}" \% 2) -eq 0 ]; then 
      number=$(expr ${count} / 2)
      printf "${blue}%s${normal}. ${violet}%s${normal}\\n%s\\n\\n" "${number}" "${line}" "${temp}"
    else temp=$(echo "${line}")
    fi
    count=$(expr "${count}" + 1)
  done

else echo "timeout"
  main
fi
}

magnet() {
url="$1"
request=$(curl -s ${proxy} --max-time 5 "${url}" | grep -oP 'magnet[^<]+ce' | grep amp)
echo -e "\n${blue}${request}${normal}\n"
if command -v xclip > /dev/null
  then echo "${request}" | xclip -sel clip
  else echo -e "xclip: ${red}not found${normal}"
fi
}

if [[ ${search%'rutor'*} = 'http://' ]] || [[ ${search%'tracker.rutor'*} = 'http://' ]]
  then magnet "$2"
  else main
fi

