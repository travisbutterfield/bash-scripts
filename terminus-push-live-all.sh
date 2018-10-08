#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass git push operations on all of your Pantheon sites (from test to live)!\n\n"

read -p 'Please add a note for this mass deployment: ' note

declare -a arr="($(terminus site:list --fields=name,framework | sed -e '/wordpress/d' | sed -e '/morrison-institute/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"

for i in "${arr[@]}"
do
  printf "..... $i .....\n";
  terminus env:deploy --note="$note" --cc --updatedb -- "$i".live;
  printf "....................\n\n";
done

unset arr
