#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass cache clear on all live environments! Please wait while I work in multiple tabs...\n\n"
IFS='\n'

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -e '/morrison-institute/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#create a custom array by uncommenting and editing the next line:
# declare -a arr=("pubsrvstarter")

#uncomment next line to check array
# printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  gnome-terminal --tab --title="$i" -- bash -c 'printf "..... '"$i"' .....\n"; terminus env:cc -- '"$i"'.live; printf "....................\n\n"; $SHELL'
  # printf "..... $i .....\n";
  # terminus env:deploy --sync-content --note="$note" --cc --updatedb -- "$i".live;
  # printf "....................\n\n";
done

unset arr
