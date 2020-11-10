#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for creating a multidev environment on all Pantheon sites!\n\n"

read -r -p 'Please name your multidev instance: ' multidev

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/morrison-institute/d' | sed -e '/drupal8/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#create a custom array by uncommenting and editing the next line:
# declare -a arr=("cord")

#uncomment next line to check array
#printf '%s\n' "${arr[@]}"

for site in "${arr[@]}"
do
  function checkmultidevs() {
    checkfirst=$(terminus multidev:list --fields=id --format=list -- "$site" | grep "$multidev")
#    printf "$checkfirst\n\n"
    if [[ "$checkfirst" != "$multidev" ]]
    then
      gnome-terminal --tab --title="$site" -- bash -c "printf '..... %s .....\n' ""$site""; terminus multidev:create $site.live $multidev; printf '....................\n\n'; $SHELL"
    else
      printf 'The \"%s\" multidev already exists on %s\n\n' "$checkfirst" "$site"
    fi
  }
  checkmultidevs
done

unset arr
