#!/bin/bash
counter=1
set -euo pipefail

`rclone version --check | sed -E 's/:\s*/=/g' | sed -E 's/\s{2,}.*//g'`
if [ "$yours" -ne "$latest" ]; then
	rclone version --check | sed -E 's/:\s*/=/g' | sed -E 's/\s{2,}.*//g'
	echo "Upgrade rclone"
	exit 1
else
	echo "rclone is latest version."
fi


if [ "$#" -ne 2 ]; then
	echo "./copyToCloudstor <src> <rcloneEndpoint:dest>"
	exit 1
fi
source_absolute_path=$(readlink -m $1)

echo "Copying ${source_absolute_path} to ${2}. Starting at $(date)"


while ! rclone check $source_absolute_path $2 2>&1 | grep ': 0 differences found'; 
do
	counter=$((counter+1))
	echo "Starting run ${counter} at $(date)"
	rclone copy --progress --transfers 10 $source_absolute_path $2
	echo "Done with run ${counter} at $(date)"
done

duration=$SECONDS
echo "Copied ${source_absolute_path} to ${2}. Finished at $(date), in $(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."