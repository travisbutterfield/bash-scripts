#!/bin/bash
IFS=$'\n'
printf "\nHello!\n\nWelcome to my bash script for resetting a multidev environment on Pantheon\n\n"

read -p "Please designate the desired website by short name: " site
read -p "Please designate the multidev you want to reset: " multidev

localfolder="/var/www/html/$site"

local_test() {
	test=$(ls -1a /var/www/html | grep -w "^$site$")
	if [[ $test == $site ]]
	then
		return
	else
		giturl="$(terminus connection:info --format="string" --fields=git_url -- $site.dev)"
		printf "...Please wait while I clone the site to your local environment...\n"
		git clone "$giturl" "/var/www/html/$site"
	fi
}
local_test

terminus env:wipe --yes $site.$multidev
cd $localfolder
git fetch --all
git checkout $multidev
git pull
commit_hash="$(git merge-base $multidev master)"
git reset $commit_hash --hard
git pull -X theirs origin master

while true; do
    read -p $'\e[33mAre sure you want to do a force push to $site.$multidev? (y/n)\e[0m: \n> ' yn
    echo    # (optional) move to a new line
    case $yn in
        [Yy]* ) git push origin $multidev --force; break;;
        [Nn]* ) printf "Exiting script"; exit 1;;
        * ) echo "Please answer yes or no.";;
    esac
done
terminus env:clone-content --updatedb --yes -- $site.live $multidev
terminus env:clear-cache -- $site.$multidev