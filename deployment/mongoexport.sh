#!/bin/bash
# mongoexport.sh
# Description : Epxorte les données des bases de mongodb
# Version : 1.0
# Auteur : Florent Grognet
# Licence : libre

USAGE="USAGE: check_imexpire.sh -c <newsletters/contacts>"
DB="boostrap_development"
COLLECTION_CONTACT="contacts"
COLLECTION_NEWSLETTER="newsletters"
DATE=`date +"%Y%m%d"`

#Récupère les arguments dans des variables
while getopts ":c:" option
	do
     case $option in
        c)
             collection=$OPTARG
             ;;
         \?)
             echo $USAGE
             exit 1
             ;;
	  esac
	done
#Vérifie que tous les arguments sont présents
 if [ -z ${collection} ]
     then
		echo $USAGE
		exit 1
 fi
 
#Exporte les collections
 if [ ${collection} == "newsletters" ]
 then
	FILE_NAME=""$COLLECTION_NEWSLETTER"-"$DATE".csv"
	mongoexport --csv -d $DB -c $COLLECTION_NEWSLETTER -f 'email' -o $FILE_NAME
 elif [ ${collection} == "contacts" ]
 then
	FILE_NAME=""$COLLECTION_CONTACT"-"$DATE".csv"
	mongoexport --csv -d $DB -c $COLLECTION_CONTACT -f 'nom','email','message' -o $FILE_NAME
 else 
	echo $USAGE
	exit 1
 fi
 
 exit 0
 