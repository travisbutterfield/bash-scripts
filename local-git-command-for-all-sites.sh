#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for doing mass local git operations on all of\nyour downloaded Pantheon sites!\n\nPlease enter your full git command below.\n\n"
IFS='\n'
read -p 'Enter command: ' command

declare -a arr="($(ls /var/www/html/ | grep -v "\."))"
#declare -a arr="(crim crd)"

# #printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  gnome-terminal --tab --title="$i" -- bash -c 'cd /var/www/html/'"$i"'; printf "..... '"$i"' .....\n"; eval '"$command"' | head -n 15; printf "....................\n\n";$SHELL'
done

unset arr
