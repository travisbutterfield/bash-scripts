#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for deleting a multidev environment from all sites in Pantheon.\n\n"

read -p 'Please enter the name of the multidev to delete: ' multidevname

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/morrison-institute/d' | sed -e '/azwater/d' | sed -e '/lodestar/d' | sed -e '/copp-community/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#create a custom array by uncommenting and editing the next line:
# declare -a arr=("pubsrvstarter")

#uncomment next line to check array
#printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  gnome-terminal --tab --title="$i" -- bash -c 'printf "..... '"$i"' .....\n"; terminus multidev:delete --delete-branch -y -- '"$i"'.'"$multidevname"'; printf "....................\n\n"; $SHELL'
  # printf "..... $i .....\n";
  # terminus multidev:create "$i".live $multidevname;
  # printf "....................\n\n";
done

unset arr
