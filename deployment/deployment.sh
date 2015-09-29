#!/bin/bash

environnement=$1
username=$USER
shasum=`git rev-parse HEAD`

if [[$environnement == 'prod']]; then
  echo 'Are you sure to deploye in production? [Yes/no]'
  read response
  if [[$response == 'Yes']]; then
    shasum_old=`$username@163.5.245.187 "cd /var/www/WernickeZone/ && git rev-parse HEAD"`
    rsync -az ../../WernickeZone $username@163.5.245.187:/var/www/
    ssh $username@163.5.245.187 "cp /var/www/WernickeZone/deployment/Dockerfile /var/www/"
    ssh $username@163.5.245.187 "cd /var/www/ && docker build -t $shasum --no-cache=true ."
    ssh $username@163.5.245.187 "docker kill $shasum_old"
    ssh $username@163.5.245.187 "docker run -d --name production ."
  else
    echo 'Abort'
  fi
elif [[$environnement == 'dev']]; then
  rsync -az ../../WernickeZone $username@163.5.245.187:/home/$username/
else
  echo "Usage: deployment.sh dev or prod"
fi
