#!/bin/bash

#Don't forget to run shellcheck (https://github.com/koalaman/shellcheck) after making edits.
counter=1
set -euo pipefail

yours="-1"
latest="-2"

for line in $(rclone version --check | sed -E 's/:\s*/=/g' | sed -E 's/\s{2,}.*//g');
do
	if [[ $line == *"="* ]]; then
		eval "$line"
	fi

done

if  (( $(echo "$yours == $latest" | bc -l) )) ; then
	echo "rclone is latest version."

else
	rclone version --check
	echo "Upgrade rclone"
	exit 1
fi


if [ "$#" -ne 2 ]; then
	echo "./copyToCloudstor <src> <rcloneEndpoint:dest>"
	exit 1
fi
source_absolute_path=$(readlink -m "$1")

echo "Copying ${source_absolute_path} to ${2}. Starting at $(date)"


while ! rclone check --one-way "$source_absolute_path" "$2" 2>&1 | grep ': 0 differences found'; 
do
	counter=$((counter+1))
	echo "Starting run ${counter} at $(date)"
	rclone copy --progress --transfers 6 "$source_absolute_path" "$2"
	echo "Done with run ${counter} at $(date)"
done

duration=$SECONDS
echo "Copied ${source_absolute_path} to ${2}. Finished at $(date), in ($duration / 60) minutes and ($duration % 60) seconds elapsed."