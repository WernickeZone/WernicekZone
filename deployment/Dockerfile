FROM debian:sid
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
RUN apt-get dist-upgrade -y
RUN apt-get install -y aptitude
RUN echo 'LANG="fr_FR.UTF-8"' > /etc/default/locale
RUN apt-get install -y ruby\
        ruby-dev\
        nodejs\
        nodejs-dev\
        ruby-rails\
        git\
        gcc\
        build-essential
RUN apt-get install -y openjdk-7-jdk\
         openjdk-7-jre-lib\
         ImageMagick\
         libmagickcore-dev\
         zlib1g-dev\
         python-pkgconfig\
         ruby-rmagick\
         aspell\
         aspell-fr\
         libmagick++-dev\
         libleptonica-dev\
         tesseract-ocr-fra\
         libtesseract-dev\
         tesseract-ocr\
         sqlite3\
         libsqlite3-dev\
        libaspell-dev
ADD WernickeZone /var/www/
RUN gem install rake -v 10.4.2
RUN gem install railties
RUN cd /var/www/&& bundle install
RUN cd /var/www/ && bin/rake db:migrate RAILS_ENV=development
RUN echo "#!/bin/bash \n cd /var/www/ \n rails s -p 3000" > /exec.sh
