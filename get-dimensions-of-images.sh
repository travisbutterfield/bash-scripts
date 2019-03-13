#!/bin/bash

declare -a arr="($(ls /var/www/html/conversion/sites/default/files/content/people/)"

#uncomment next line to check array
#printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  identify -format "%f,%w,%h\n" *.jpg > /home/travis/Desktop/people-jpg.csv
done

unset arr
