#!/bin/bash
##############################################################################
# $> ./rutracker.sh 1                                                        #
# $> ./rutracker.sh 1 help                                                   #
# $> ./rutracker.sh 1 252                                                    #
# $> ./rutracker.sh 1 'https://rutracker.org/forum/viewtopic.php?t=6549631'  #
# $> ./rutracker.sh 0 'https://rutracker.org/forum/viewtopic.php?t=6549631'  #
##############################################################################

source ./text-color.sh

function magnet {
    proxy=''

    if ! [ "$#" -eq 2 ]; then
      echo -e "${red} Ожидалось 2 параметра, а передано $#${normal}"
      exit 0
    fi

    if [ "$1" = '1' ]; then
      source ./proxy.sh 1> /dev/null
    fi

    url="$2"

    user_agent='Mozilla/5.0 (X11; Linux x86_64; rv:133.0) Gecko/20100101 Firefox/133.0'
    request=$(curl -s --location -A "${user_agent}" ${proxy} --max-time 10 "${url}")

    result=$(echo "${request}" | grep -oP 'magnet[^<]+net"' | sed 's/net"/net/g')
    if [ "${result}" ]
      then echo -e "\n${blue}${result}${normal}\n"
    else echo -e "${red}*** Fail ***${normal}"
    fi

    if command -v xclip > /dev/null
      then echo "${result}" | xclip -sel clip
      else echo -e "xclip: ${red}not found${normal}"
    fi
}

if [ "$#" -eq 0 ]
  then ./rutracker.py
elif [ "$#" -eq 1 ]
  then ./rutracker.py "$1"
elif [ "$#" -eq 2 ]; then
  if ! [[ "$1" = 0 || "$1" = 1 ]]; then
    echo -e "${red} Первым параметром ожидалось 0 или 1${normal}"
    exit 0
  fi
  
  if [ "$2" -gt 1 ] 2>/dev/null; then
    ./rutracker.py "$1" "$2"
  elif [[ "$2" =~ 'https://rutracker.org/forum/viewtopic.php?t=' ]]; then
    magnet "$1" "$2"
  else echo -e "${red} Неверный параметр (ссылка)${normal}"
  fi
  
else echo -e "${red} Ожидалось не более 2-х параметров, а передано $#${normal}"
fi

