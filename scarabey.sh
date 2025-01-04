#!/bin/sh
#######################
# $> ./scarabey.sh    #
#######################

source ./text-color.sh

source ./proxy.sh 1> /dev/null

# URL страницы канала
CHANNEL_URL="https://scarfilm.org/novinki-kino-v-seti/"

# Количество видео для получения
NUM_URLS=18

# Функция загрузки HTML-страницы
get_html() {
  html=$(curl -s ${proxy} --location --max-time 3 "${CHANNEL_URL}")
}

# Функция для получения последних видео из HTML-страницы
get_latest_videos_from_html() {
  # Загружаем HTML страницу канала
  if get_html; then

  # Извлекаем названия и ссылки на видео
  href=$(echo "${html}" | grep -oP '<a href="[^<]+</a></h3>')

  # Соединяем видео
  paste -d '\n' <(echo "${href}")
    
  else get_latest_videos_from_html
  fi
}

# Получение видео
result=$(get_latest_videos_from_html | head -n "${NUM_URLS}")

# Вывод видео
echo "${result}" | while IFS='\n' read -r item; do
  title=$(echo "${item}" | grep -oP 'title="[^<]+">' | sed 's/title="//g ; s/">//g')
  url=$(echo "${item}" | grep -oP '<a href="[^<]+" t' | sed 's/<a href="//g ; s/\/" t//g')
  echo -e "${yellow}${title}${normal}"
  echo -e "${blue}${url}${normal}\n"
done

