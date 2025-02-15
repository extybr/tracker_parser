#!/bin/bash
# $> ./lostfilm_new_release.sh
# Выход нового релиза

function new_release {
  curl 'https://www.lostfilm.today/ajaxik.php' -s --max-time 7 \
  POST -H 'Referer: https://www.lostfilm.today/series/?type=search&s=3&t=0' \
  -d 'act=serial&type=search&o=0&s=3&t=0' | \
  jq -r '.data.[] | .title, .title_orig, .date, .link, .genres, .channels, .status_season' | \
  sed 'N;N;N;N;N;N; s/\n/ * /g ; G' 
}

new_release

