#!/bin/zsh
####################
# $> ./torrent.sh  #
####################

source ./text-color.sh

cat << EOF

 _                                    _    
| |_   ___   _ __  _ __   ___  _ __  | |_  
| __| / _ \ | '__|| '__| / _ \| '_ \ | __| 
| |_ | (_) || |   | |   |  __/| | | || |_  
 \__| \___/ |_|   |_|    \___||_| |_| \__| 
                                           

EOF

script_dir=$(pwd)

if [ "$#" -ne 1 ]; then 
  ls --color "${script_dir}"
  echo -e "\n${yellow}Выбор скриптов, в названии которых есть символы" \
  "'ru'\nПример запуска сортировки: ${blue}./torrent.sh ru${normal}"
  exit 0
fi

chr="$1" 
for file in $(ls "${script_dir}"); do
  slice=${${file}#*$chr}
  if (( "${#slice}" <  "${#file}" )) \
  && ! [ "${file}" = 'main.sh' ] \
  && ! [ "${file}" = 'proxy.sh' ] \
  && ! [ "${file}" = 'text-color.sh' ] \
  && ! [ "${file}" = 'rutracker.py' ] \
  && ! [ "${file}" = 'rutracker-magnet.sh' ] \
  && ! [ "${file}" = 'url_coder.py' ]; then
    array+=("${file}\n")
  fi
done

echo -en "${array}" | nl

echo -en "${yellow}Скрипт под каким номером запустить и с \
какими параметрами (опционально)$(tput blink) =>: ${normal}"

read number params

if [[ ! "${number}" || "${number}" -gt "${#array}" ]]; then
  exit 0
fi

echo
cd "${script_dir}"
script=$(echo -en "./${array[${number}]}")
zsh -c "${script} ${params}" 2> /dev/null

