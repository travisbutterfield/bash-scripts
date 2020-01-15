#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for creating a wsupdt multidev environment for updating webspark!\n\n"

read -p 'Please name your multidev instance: ' multidevname

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/morrison-institute/d' | sed -e '/lodestar/d' | sed -e '/copp-community/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#create a custom array by uncommenting and editing the next line:
#declare -a arr=("spa" "socialwork")

#uncomment next line to check array
#printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  printf "..... $i .....\n";
  terminus multidev:create "$i".live $multidevname;
  printf "....................\n\n";
done

unset arr
