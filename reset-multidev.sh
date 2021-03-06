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
		printf "\n\n...Please wait while I clone the site to your local environment...\n\n"
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

# Uncomment this section if you want to add a warning about the force push
# while true; do
#     read -p $'\e[33m'"Are sure you want to do a force push to $site.$multidev? (y/n): "$'\e[0m \n> ' yn
#     case $yn in
#         [Yy]* ) git push origin $multidev --force; break;;
#         [Nn]* ) printf "Exiting script"; exit 1;;
#         * ) echo "Please answer yes or no.";;
#     esac
# done

git push origin $multidev --force # Remove this line if you opt for the force push warning
terminus env:clone-content --updatedb --yes -- $site.live $multidev
terminus env:clear-cache -- $site.$multidev
git checkout master