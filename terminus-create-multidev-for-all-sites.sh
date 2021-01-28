#!/bin/bash

IFS=$'\n'

printf "\nHello!\n\nWelcome to my bash script for creating a multidev environment on all Pantheon sites!\n\n"

read -r -p 'Please name your multidev instance: ' MULTIDEV

declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/vanillad7/d' | sed -e '/pubsrvstarter/d' | sed -e '/policyinformatics/d' | sed -e '/drupal8/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#create a custom array by uncommenting and editing the next line:
# declare -a arr=("copp")

#uncomment next line to check array
printf '%s\n' "${arr[@]}"

for SITE in "${arr[@]}"
do
  export SITE
  export MULTIDEV
  function checkmultidevs() {
    CHECKFIRST=$(terminus multidev:list --fields=id --format=list -- "$SITE" | grep "$MULTIDEV")
   # printf "Checkfirst: $CHECKFIRST\n\n"
    if [[ "$CHECKFIRST" != "$MULTIDEV" ]]
    then
      printf "..... %s .....\n" "$SITE"; terminus multidev:create $SITE.live $MULTIDEV; printf "....................\n\n"
    else
      printf 'The \"%s\" multidev already exists on %s\n\n' "$CHECKFIRST" "$SITE"
    fi
  }

  export -f checkmultidevs
  gnome-terminal --tab --title="$SITE" -- bash -c "checkmultidevs; $SHELL"
done

unset arr
