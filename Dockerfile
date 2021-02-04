# базовый образ
FROM ubuntu

# подпись
LABEL maintainer="Dmitriy Detkov"
LABEL email="maliciousgenius@gmail.com"
LABEL tel="+79604565686"

# apt conf
ENV DEBIAN_FRONTEND=noninteractive

# apt update & upgrade
RUN apt update --quiet ; \
    apt upgrade --quiet --yes ;

# configure deb-backend
RUN echo "debconf debconf/frontend select noninteractive" | debconf-set-selections ; \
    dpkg-reconfigure --frontend=noninteractive debconf ;

# install some the packages to full system provision
RUN apt install --quiet --yes --no-install-recommends \
        ca-certificates \
        apt-transport-https \
        software-properties-common ;

# common pakages
RUN apt install --quiet --yes --no-install-recommends \
        # ru lang support
        locales language-pack-ru-base \
        # time data
        tzdata ;

# ru lang
ENV LANG="ru_RU.UTF-8" \
    LANGUAGE="ru_RU.UTF-8" \
    LC_ALL="ru_RU.UTF-8" \
    LC_CTYPE="ru_RU.UTF-8"
RUN sed -i "s/^[^#]*ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/g" /etc/locale.gen ; \
    sed -i "s/^[^#]*en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g" /etc/locale.gen ; \
    echo $LANGUAGE >> /etc/default/locale ; \
    echo $LC_ALL >> /etc/default/locale ; \
    locale-gen ; \
    update-locale LANG=$LANG LC_ALL=$LC_ALL LANGUAGE=$LANGUAGE ; \
    dpkg-reconfigure --frontend=noninteractive locales ;

# timezone
ENV TIMEZONE="Europe/Moscow"
RUN echo $TIMEZONE > /etc/timezone ; \
    ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime ; \
    dpkg-reconfigure --frontend=noninteractive tzdata ;

# установка дополнительных пакетов
RUN apt install --quiet --yes --no-install-recommends \
        bash bash-completion ;

# установка postfix
RUN apt install --quiet --yes --no-install-recommends \
        ansible ;

# clearnup apt
RUN apt autoremove --yes ; \
    apt clean ; \
    rm -rf /var/lib/apt/lists/* ;

# backup origin config
RUN cp -R /etc/ansible /etc/ansible-origin ;

