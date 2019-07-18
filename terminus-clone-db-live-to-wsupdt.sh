#!/bin/bash

printf "\nHello!\n\nThis tool clones the live database to the wsupdt multidev\n\n"

#declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/morrison-institute/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"

declare -a arr=("northamericanprocess" "publicpolicy" "crd" "cemhs" "morrison-institute" "cpop" "copp" "urbaninnovation" "lodestar" "conversion" "cabhp" "socialwork" "pubsrvstarter" "lifelonglearning")

#uncomment next line to check array
#printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  printf "..... $i .....\n";
  terminus env:clone-content --db-only --yes -- "$i".live wsupdt;
  printf "....................\n\n";
done

unset arr
