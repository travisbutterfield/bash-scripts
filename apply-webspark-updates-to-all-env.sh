#!/bin/bash

printf "\nHello!\n\nWelcome to my bash script for mass deployment of webspark updates!\n\n"
IFS=$'\n'
read -r -p 'Please designate the desired environment (multidev name): ' env
read -r -p 'Please enter the nickname of the webspark release: ' release

#force $release to be lowercase and convert spaces to dashes
release=$(echo "$release" | awk '{print tolower($0)}' | sed -e 's/ /-/g' )

#get list of sites and clean it up
declare -a arr="($(terminus site:list --team --fields=name,framework | sed -e '/wordpress/d' | sed -e '/drupal8/d' | sed -e '/policyinformatics/d' | sed -e '/vanillad7/d' | sed -n '1,3 !p' | sed -n '$ !p' | tr -s ' ' | cut -d ' ' -f-2))"
#arr=("cemhs")
printf '%s\n' "${arr[@]}"

for i in "${arr[@]}"
do
  export i
  export release
  export env
  terminus connection:set "$i"."$env" -- git
  function getrelease() {
#    printf "%s\n" "test"
    cd /var/www/html/"$i" || exit
    checkremote=$(git remote | grep -c webspark)
    if [[ "$checkremote" -eq 0 ]]; then
      printf "The \"webspark\" remote is not configured on this site. Adding now...\n\n"
      git remote add webspark https://github.com/ASU/webspark-drops-drupal7.git
    fi
    git fetch --all
    fullname=$(git tag --list | grep -P "^v.*?-$release")
#    printf "fullname: %s" "$fullname"
    if [[ -z "$fullname" ]]; then
        printf "I couldn't find a release by the name \"%s.\" Please try again.\n\n" "$release"
        return 1
    else
      git checkout "$env"
      git pull origin "$env"
      git pull -X theirs webspark "$fullname" >> /dev/null 2>&1
      status=$(git status --porcelain=1)
      conflicts=$(git status --porcelain=1 | grep "^[\sMARCDU][\sMARCDU]")
      delconfs=$(git status --porcelain=1 | grep "^[U][D]")
#        printf "delconfs: %s\n" "$delconfs"
#        printf "conflicts:\n%s\n" "$conflicts"
      count=$(printf "%s\n" "$conflicts" | grep -c "^[\sMARCDU][\sMARCDU]")
#        printf "count: %s" "$count"
      delcount=$(printf "%s\n" "$delconfs" | grep -c "^[U][D]")
#        printf "delcount: %s\n" "$delcount"
      export conflicts
      export count
      export delcount
#        printf "conflicts: %d\n"
      if [[  "$count" -gt 0 ]] && [[ "$count" -eq "$delcount" ]]; then
        git add -u
        git commit -m "update to Webspark $fullname"
        git push origin "$env"
        terminus drush "$i"."$env" -- updb -y
        terminus env:cc -- "$i"."$env"
        printf "%s\n" "-------------------------------------------------------------"
        printf "PLEASE NOTE:\n"
        printf "There were minor \"delete\" conflicts which have been resolved.\n"
        printf "The committed changes were pushed to your remote branch.\n"
        printf "%s\n" "-------------------------------------------------------------"
      elif [[  "$count" -gt 0 ]] && [[ "$count" -ne "$delcount" ]]; then
        printf "%s\n" "-------------------------------------------------------------"
        printf "PLEASE NOTE:\n"
        printf "There are at least %d conflict(s) that need to be resolved.\n" "$count"
        printf "Please run \"git status\" and resolve the conflicts.\n"
        printf "When finished, push the changes to your remote branch.\n"
        printf "%s\n" "-------------------------------------------------------------"
      elif [[ -z "$status" ]]; then
        git commit -m "update to Webspark $fullname"
        git push origin "$env"
        terminus drush "$i"."$env" -- updb -y
        terminus env:cc -- "$i"."$env"
        printf "%s\n" "-------------------------------------------------------------"
        printf "PLEASE NOTE:\n"
        printf "There were no conflicts.\n"
        printf "The committed changes were (probably) pushed to your remote branch.\n"
        printf "%s\n" "-------------------------------------------------------------"
      else
        printf "%s\n" "-------------------------------------------------------------"
        printf "PLEASE NOTE:\n"
        printf "You may have missed something. Please run \"git status\" now.\n"
        printf "%s\n" "-------------------------------------------------------------"
      fi
      git status
    fi
  }
  export -f getrelease
  gnome-terminal --tab --title="$i" -- bash -c "getrelease; $SHELL"
done
