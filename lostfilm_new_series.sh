#!/bin/bash
# $> ./lostfilm_new_series.sh
# Выход новой серии

function new_series {
  curl -s $(./proxy.sh) --max-time 7 'https://www.lostfilm.today/new/' | \
  grep -oP '<div class="(name-ru|name-en|left-part|alpha|beta)[^<]+' | \
  sed 'N;N;N;N;N;N; s/<div class="//g ; s/name-ru">//g ; s/name-en">//g; s/left-part">//g ; s/alpha">//g ; s/beta">//g ; G'
}

new_series

