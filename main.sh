#!/bin/zsh
##################
# $> ./main.sh   #
##################

source ./text-color.sh

cat << EOF

    ┌─┐┌─┐┬─┐┬┌─┐┌┬┐       ┌─┐┌─┐┬─┐┌─┐┌─┐┬─┐
    └─┐│  ├┬┘│├─┘ │   ───  ├─┘├─┤├┬┘└─┐├┤ ├┬┘
    └─┘└─┘┴└─┴┴   ┴        ┴  ┴ ┴┴└─└─┘└─┘┴└─
       
EOF

script_dir=$(pwd)

if [ "$#" -ne 1 ]; then 
  ls --color *.sh *.py
  echo -e "\n${yellow}Выбор скриптов, в названии которых есть определенные" \
  "символы.\nПример запуска сортировки: ${blue}./main.sh ru${normal}\n"
  exit 0
fi

chr="$1" 
for file in $(ls "${script_dir}"); do
  slice=${${file}#*$chr}
  if (( "${#slice}" <  "${#file}" )) \
  && ! [ "${file}" = 'main.sh' ] \
  && ! [ "${file}" = 'preview.png' ] \
  && ! [ "${file}" = 'README.md' ] \
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

