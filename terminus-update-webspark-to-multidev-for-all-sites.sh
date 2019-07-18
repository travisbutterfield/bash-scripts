#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass Webspark upstream \n
updates to all of your Pantheon sites on the multidev 'wsupdt' environment\n\n"

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/morrison-institute/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"

#uncomment next line to check array
#printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  printf "..... $i .....\n";
  terminus upstream:updates:apply --updatedb --accept-upstream -- "$i".wsupdt;
  printf "....................\n\n";
done

unset arr
