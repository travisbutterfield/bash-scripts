#!/bin/bash -e

printf "\nHello!\n\nWelcome to my bash script for doing mass local git operations on all of\nyour downloaded Pantheon sites!\n\nPlease enter your full git command.\n\n"
IFS='\n'
read -p 'Enter command: ' command

declare -a arr="($(ls /var/www/html/ | grep -v "\." | sed -e '/morrison-institute/d' | sed -e '/d8composer2/d' | sed -e '/azwater/d'))"
# declare -a arr="(crim crd)"

#gnome-terminal --tab --title="test" -- bash -c 'eval echo '"'$command'"'; $SHELL'

# #printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  gnome-terminal --tab --title="$i" -- bash -c 'cd /var/www/html/'"$i"'; printf "..... '"$i"' .....\n"; eval '"'$command'"'; printf "....................\n\n";$SHELL'
done

unset arr
