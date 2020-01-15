#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass backup on the test environment of all of your Pantheon sites!\n\n"

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/morrison-institute/d' | sed -e '/lodestar/d' | sed -e '/copp-community/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
# declare -a arr=("crim" "socialwork" "crd" "spa")
#uncomment next line to check array
#printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  printf "..... $i .....\n";
  terminus backup:create -- "$i".dev;
  printf "....................\n\n";
done

unset arr
