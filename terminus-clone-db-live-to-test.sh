#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing a mass clone of the database from live to test on all of your Pantheon sites!\n\n"

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/morrison-institute/d' | sed -e '/lodestar/d' | sed -e '/copp-community/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#declare -a arr=("csteps" "gcahr" "cord" "childwelfare" "psa" "cvpcsd7" "coppconnect" "northamericanprocess" "cpop")

#uncomment next line to check array
#printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  printf "..... $i .....\n";
  terminus env:clone-content --yes --db-only -- "$i".live test;
  printf "....................\n\n";
done

unset arr
