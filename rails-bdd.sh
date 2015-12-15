
#!/bin/bash

#Auteur : Florent Grognet
usage="rails-bdd.sh -r -s -b \n
		\t-r : remise à zéro de la base de données \n
		\t-s : importe les données par défaut ou 'seeds' \n
		\t-b : execution via le bundle"
rake="/usr/bin/rake"
bundle="bundle exec"
r=0
s=0
b=0
#Récupère les arguments dans des variables
 while getopts ":rsb" option
 do
     case $option in
         r)
             r=1
             ;;
	 s)
	     s=1
	     ;;
	 b)
	     b=1
	     ;;
         \?)
             echo -e $usage
             exit 1
             ;;
       esac
 done

#Contrôle des arguments
if [ $r -eq 0 ]
then 
    if [ $s -eq 0 ]
    then
	echo -e $usage
	exit 1
    fi
fi

#Exécution des commandes sur la base de données.
if [ $b -eq 0 ]
then
    if [ $r -eq 1 ]
    then
	$rake db:migrate:reset
    fi
    if [ $s -eq 1 ]
    then
	$rake db:seeds
    fi	
else
    if [ $r -eq 1 ]
    then
	$bundle $rake db:migrate:reset
    fi
    if [ $s -eq 1 ]
    then
	$bundle $rake db:seeds
    fi
fi

exit 0
