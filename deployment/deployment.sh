#!/bin/bash

environnement=$1
username=$USER

if [ $environnement == 'prod' ]; then
  echo 'Are you sure to deploye in production? [Yes/no]'
  read response
  if [ $response == 'Yes' ]; then
    rsync -az ../../WernickeZone $username@163.5.245.187:/var/www/
    ssh $username@163.5.245.187 "cp /var/www/WernickeZone/deployment/Dockerfile /var/www/"
    ssh $username@163.5.245.187 "cd /var/www/ && docker build -t production ."
    testps=`ssh $username@163.5.245.187 "docker ps -a | grep wernickeZone"`
    test=`echo $testps | cut -d \  -f 14`
    if [ -z $test ]; then
      ssh $username@163.5.245.187 "docker run -d -p 3000:3000 --name 'wernickeZone' production sh exec.sh"
    else
      ssh $username@163.5.245.187 "docker restart wernickeZone"
    fi
  else
    echo 'Abort'
  fi
elif [ $environnement == 'dev' ]; then
  rsync -az ../../WernickeZone $username@163.5.245.187:/home/$username/
  port=`ssh $username@163.5.245.187 "cat /home/$username/port"`
  if [ -z $port ]; then
    echo "Abort\nCannot load port number"
  else
    ssh $username@163.5.245.187 "cp /home/$username/WernickeZone/deployment/Dockerfile /home/$username/"
    ssh $username@163.5.245.187 "cd /home/$username/ && docker build -t $username-dev --no-cache=true ."
    testps=`ssh $username@163.5.245.187 "docker ps -a | grep $username-dev-fi"`
    test=`echo $testps | cut -d \  -f 14`
    if [ -z $test ]; then
      ssh $username@163.5.245.187 "docker run -d -p $port:3000 --name '$username-dev-fi' $username-dev sh exec.sh"
    else
      ssh $username@163.5.245.187 "docker restart $username-dev-fi"
    fi
  fi
else
  echo "Usage: deployment.sh dev or prod"
fi
