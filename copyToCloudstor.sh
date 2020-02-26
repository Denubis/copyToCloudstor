#!/bin/bash

counter=1
set -euo pipefail

VERSIONCHECK=1
EXTRAVARS=0
POSITIONAL=()
while [[ $# -gt 0 ]]; do
	key="${1}"
	case ${key} in
		--skipversioncheck)
			VERSIONCHECK=0
		    	shift # past argument
	    	;;
    		*)    # unknown option
			EXTRAVARS=1
			POSITIONAL+=("$1") # save it in an array for later
			shift # past argument
    		;;
	esac
done
if [ ${EXTRAVARS} -eq 1 ]; then
	set -- "${POSITIONAL[@]}" # restore positional parameters
fi

#Check for latest rclone version
if [ ${VERSIONCHECK} -eq 1 ]; then
	if [ $(rclone version --check | grep -e 'yours\|latest' | sed 's/  */ /g' | cut -d' ' -f2 | uniq | wc -l) -gt 1 ]; then
		rclone version --check
		echo "Upgrade rclone (curl https://rclone.org/install.sh | sudo bash)"
		exit 1
	else 
		echo "rclone is latest version."
	fi
fi

#Usage
if [ "$#" -ne 2 ]; then
	echo "./copyToCloudstor <src> <rcloneEndpoint:dest>"
	echo "  --skipversioncheck"

	exit 1
fi


source_absolute_path=$(readlink -m ${1})

echo "Copying ${source_absolute_path} to ${2}. Starting at $(date)"

while ! rclone check --one-way ${source_absolute_path} ${2} 2>&1 | grep ': 0 differences found'; do
	counter=$((counter+1))
	echo "Starting run ${counter} at $(date)"
	rclone copy --progress --transfers 6 ${source_absolute_path} ${2}
	echo "Done with run ${counter} at $(date)"
done

duration=${SECONDS}
echo "Copied ${source_absolute_path} to ${2}. Finished at $(date), in $((${duration} / 60)) minutes and $((${duration} % 60)) seconds elapsed."
