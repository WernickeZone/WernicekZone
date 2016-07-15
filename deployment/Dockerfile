FROM debian:jessie
RUN echo "deb http://ftp.debian.org/debian jessie main \n deb http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y locales
RUN echo "Europe/Paris" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="fr_FR.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=fr_FR.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64
ENV CXXFLAGS='-I/usr/lib/jvm/java-7-openjdk-amd64/include'
ENV LANG=fr_FR.UTF-8
RUN apt-get update && apt-get upgrade -y
RUN echo 'LANG="fr_FR.UTF-8"' > /etc/default/locale
RUN apt-get install -y ruby\
    ruby-dev\
    ruby-rails\
    ruby-rmagick\
    nodejs\
    nodejs-dev\
    git\
    gcc\
    build-essential\
    openjdk-7-jdk\
    openjdk-7-jre-lib\
    ImageMagick\
    libmagickcore-dev\
    libmagick++-dev\
    libleptonica-dev\
    zlib1g-dev\
    python-pkgconfig\
    aspell\
    aspell-fr\
    libaspell-dev\
    tesseract-ocr\
    tesseract-ocr-fra\
    libtesseract-dev\
    verbiste\
    sqlite3\
    libsqlite3-dev\
    mongodb\
    mongodb-dev\
    curl\
    wget

ADD ../WernickeZone-master /var/www/
RUN gem install rake -v 10.4.2
RUN gem install railties -v 4.2.4
RUN cd /var/www/&& bundle install
RUN cd /var/www/ && bin/rake db:migrate RAILS_ENV=development
RUN irb /var/www/treat_postinstall.rb
RUN echo "#!/bin/bash \n cd /var/www/ \n passenger start -p 80" > /exec.sh
RUN chmod +x exec.sh
