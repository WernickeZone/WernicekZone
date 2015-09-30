#!/bin/bash

echo "deb http://ftp.fr.debian.org/debian/ sid main\ndeb-src http://ftp.fr.debian.org/debian/ sid main" > /etc/apt/sources.list

apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y
apt-get install -y aptitude

aptitude install -y ruby ruby-dev nodejs nodejs-dev ruby-rails git
aptitude install -y openjdk-7-jdk openjdk-7-jre-lib
aptitude install -y ImageMagick libmagickcore-dev libmagick++-dev zlib1g-dev python-pkgconfig ruby-rmagick aspell aspell-fr libmagick++-dev libleptonica-dev tesseract-ocr-fra libtesseract-dev

export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64/

gem install bundler matrix tf-idf-similarity jrb stanford-core-nlp treat railties tesseract
gem install rake -v 10.4.2

git clone https://github.com/FloGro/WernickeZone.git

cd WernickeZone
bundle install
bin/rake db:migrate RAILS_ENV=development
rails s -d -p 80
