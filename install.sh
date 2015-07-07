#!/bin/bash

aptitude update
aptitude upgrade -y
aptitude install -y ruby2.1 ruby2.1-dev nodejs nodejs-dev ruby-rails
aptitude install -y openjdk-7-jdk openjdk-7-jre-lib
aptitude install -y ImageMagick libmagickcore-dev libmagick-dev zlib1g-dev python-pkgconfig ruby-rmagick
gem install bundler
gem install matrix
gem install rake –v 10.3.2
gem install tf-idf-similarity
gem install jrb
gem install stanford-core-nlp
gem install treat
git clone https://github.com/WernickeZone/WernickeZone.git
cd WernickeZone
bundle install
rails s -d -p 80
