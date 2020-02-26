#!/bin/bash

set -euo pipefail

VERSIONCHECK=1
PUSHFIRST=0
CHECK=1
EXTRAVARS=0
TRANSFERS=6
POSITIONAL=()
while [[ $# -gt 0 ]]; do
	key="${1}"
	case ${key} in
		--skipversioncheck)
			VERSIONCHECK=0
		    	shift # past argument
	    	;;
		--pushfirst)
			PUSHFIRST=1
		    	shift # past argument
	    	;;
		--nocheck)
			CHECK=0
		    	shift # past argument
	    	;;
		-p|--parallel)
			TRANSFERS="${2}"
		    	shift # past argument
			shift # past value
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
	echo "  --skipversioncheck  : Skip rclone version checking"
	echo "  --pushfirst         : Skip first oneway check (one less propfind)"
	echo "  --nocheck           : Just pushes once without retrying"
	echo "  -p|--parallel       : Number of file transfers to run in parallel. (default 6)"

	exit 1
fi

#Do the transfer
SECONDS=0
source_absolute_path=$(readlink -m ${1})

echo "Copying ${source_absolute_path} to ${2}. Starting at $(date)"

if [ ${PUSHFIRST} -eq 1 || ${CHECK} -eq 0 ]; then
	rclone copy --progress --no-traverse --transfers ${TRANSFERS} ${source_absolute_path} ${2}
fi
if [ ${CHECK} -eq 1 ]; then
	counter=1
	while ! rclone check --one-way ${source_absolute_path} ${2} 2>&1 | grep ': 0 differences found'; do
		counter=$((counter+1))
		echo "Starting run ${counter} at $(date)"
		rclone copy --progress --transfers ${TRANSFERS} ${source_absolute_path} ${2}
		echo "Done with run ${counter} at $(date)"
	done
fi

duration=${SECONDS}
echo "Copied ${source_absolute_path} to ${2}. Finished at $(date), in $((${duration} / 60)) minutes and $((${duration} % 60)) seconds elapsed."
