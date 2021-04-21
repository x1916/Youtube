#!/bin/bash

# condition checks to see if all arguments are entered


if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]
then 
        echo "Illegal usage"
        echo "Usage $0 <url list> <destination directory> <logfile>"
        exit 1
fi

# install/upgrade youtube-dl using pip3

sudo -H pip3 install --upgrade youtube-dl

# assigment of arguments to variables #

URLLIST_FILE=$1

DESTINATION=$2

LOGFILE=$3


# condition checks to see if arguments actually exist


if [ ! -e ${URLLIST_FILE} ]
	then
        	echo "${URLLIST_FILE} does not exist"
        	exit 2
	fi

if [ ! -e ${LOGFILE} ]
	then
		touch $LOGFILE
	else
               read -r -p "${LOGFILE} already exists, OK to overwrite? (y / N)" CREATELOG

               if [[ "$CREATELOG" =~ ^([y|Y])$ ]]
		then
			> $LOGFILE
               else

                       exit 1

               fi

fi

# read in the contents of the ip file.
# download the videos to the DESTINATION directory.
# write the log to the logfile.

while read LINE; do

	youtube-dl --no-part -o "$(pwd)/$DESTINATION%(title)s.%(ext)s" $LINE

	TITLE=$(youtube-dl -e $LINE)

# grep the full titles from the download directory, ignore special characters.

	FULLTITLE=$(ls -1 $DESTINATION | grep -F "$TITLE")

	echo $(date -u) "VIDEONAME:" $TITLE "MD5: " $(md5sum $(pwd)"/"$DESTINATION"$FULLTITLE") >> $LOGFILE;

done < $URLLIST_FILE

