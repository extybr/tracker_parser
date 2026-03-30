#!/bin/bash
##################################
# $> ./rss-rutracker.sh 1 252    #
##################################

if [ "$#" -ne 2 ]; then
  echo "*** Ожидалось 2 параметра ***" && exit 0
fi

NUMBER="$2"
SOURCE="https://feed.rutracker.cc/atom/f/$NUMBER.atom"
source ./proxy.sh 1> /dev/null
PROXY="${proxy}"

function rss {
  curl -s $PROXY $SOURCE | \
  grep -oP '(<link|title>)\K[^<]+' | sed 's/" \/>//g ; s/href="//g ; n;G'
}

function rss_time {
  curl -s $PROXY $SOURCE | grep -oP '(id>|<link|title>)\K[^<]+' | \
  sed 's/" \/>//g ; s/ href="//g ; s/tag:rto.feed,//g ; s/:\/t\// /g' | \
  sed 'n;n;G'
}

rss_time

