#!/bin/bash
##############################
# $> ./nnmclub-rss.sh help   #
# $> ./nnmclub-rss.sh 1      #
# $> ./nnmclub-rss.sh 0 411  #
# $> ./nnmclub-rss.sh 1 10   #
##############################

source ./text-color.sh

if [ "$#" -eq 0 ]; then
  echo -e " ${yellow}Примеры запуска:\n"\
          "${yellow}Справка: ${blue}./nnmclub-rss.sh help\n"\
          "${yellow}Зарубежные Новинки (HD, FHD, UHD, 3D): ${blue}./nnmclub-rss.sh 1 954\n"\
          "${yellow}Горячие новинки Игр: ${blue}./nnmclub-rss.sh 1 411\n"\
          "${yellow}Зарубежная поп-музыка: ${blue}./nnmclub-rss.sh 1 353\n"\
          "${yellow}Новинки кино: ${blue}./nnmclub-rss.sh 1 10\n"\
          "${yellow}Новинки кино без прокси: ${blue}./nnmclub-rss.sh 0 10\n"\
          "${yellow}Зарубежные сериалы: ${blue}./nnmclub-rss.sh 1 3\n${normal}"
  exit 0
fi

forum='https://nnmclub.to/forum'
number=954

if [[ "$#" -lt 1 || "$#" -gt 2 ]]; then
  echo -e "${white} Ожидалось 1 или 2 параметра${normal}"
  exit 0
elif [ "$#" -eq 1 ]; then
  if [[ "$1" = 'h' || "$1" = '-h' || "$1" = 'help' || "$1" = '-help' ]]; then
    echo -e "${white}\n 954 - Зарубежные Новинки (HD, FHD, UHD, 3D)\n\
 411 - Горячие новинки Игр\n 353 - Зарубежная поп-музыка\n\
 10 - Новинки кино\n 3 - Зарубежные сериалы\n${normal}"
    exit 0
  fi
  if ! [[ "$1" = 0 || "$1" = 1 ]]; then
    echo -e "${white} Первым параметром ожидалось 0 или 1${normal}"
    exit 0
  fi
else
  if ! [[ "$1" = 0 || "$1" = 1 ]]; then
    echo -e "${white} Первым параметром ожидалось 0 или 1${normal}"
    exit 0
  fi 
  if [ "$2" -lt 2 ] 2>/dev/null; then
    echo -e "${white} Вторым параметром ожидалось число более 2-х${normal}"
    exit 0
  else number="$2"
  fi
fi

proxy=''
if [ "$1" -eq 1 ]; then
  source ./proxy.sh &> /dev/null
fi

function category() {
counter=1
IFS=$'\n'
for line in ${result}; do
  echo -e "${yellow}${line}\n${normal}${blue}" | tac
done
}

function section() {
counter=1
IFS=$'\n'
for line in ${result}; do
  if (( $counter % 2 == 0 )); then
    echo -e "${yellow}${line}${normal}\n"
  else echo -e "${blue}${line}${normal}"
  fi
  counter=$((counter+1))
done
}

if [[ "${number}" -eq 10 || "${number}" -eq 3 ]]; then
  result=$(curl -s ${proxy} "${forum}/portal.php?c=${number}" | \
           iconv -f cp1251 | grep -oP 'class="pgenmed" href[^>]+' | \
           sed "s/class=\"pgenmed\" href=\"//g; s/\" title=\"/\\\n/g ; s/]\"/]/g ; \
           s/viewtopic/https:\/\/nnmclub.to\/forum\/viewtopic/g")
  category
else
  result=$(curl -s --max-time 10 ${proxy} "${forum}/rss.php?f=${number}&t=1" | \
           iconv -f cp1251 | grep -oP '(<title>[^>]+</|<link>[^>]+</)' | \
           sed "s/<title>//g ; s/::/==>/g ; s/<link>//g ; s/<\///g" | tail -n +5)
  section
fi

