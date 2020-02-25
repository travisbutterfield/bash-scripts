#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass sync of the watts_views module across all sites.\n\n"


declare -a arr="($(ls /var/www/html/ | grep -v "\." | grep -v '\<copp\>' | sed -e '/morrison-institute/d' | sed -e '/d8composer2/d' | sed -e '/azwater/d') 'copp-community')"

#declare -a arr="(pubsrvstarter)"

for i in "${arr[@]}"
do
  #echo $i
  #rm -rf /var/www/html/$i/sites/all/modules/custom/watts_views/watts_views
  printf $i' .... '
  eval 'rm -rf /var/www/html/$i/sites/all/modules/custom/watts_views; cp -Tr /var/www/html/copp/sites/all/modules/custom/watts_views /var/www/html/$i/sites/all/modules/custom/watts_views'
  printf 'done\n\n'
done

unset arr
