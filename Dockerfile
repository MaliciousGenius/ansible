# базовый образ
FROM ubuntu

# подпись
LABEL maintainer="Dmitry Detkov"
LABEL email="maliciousgenius@gmail.com"
LABEL tel="+79604565686"

# опцци пакетного менеджера
ENV DEBIAN_FRONTEND=noninteractive
RUN echo "debconf debconf/frontend select noninteractive" | debconf-set-selections ; \
    dpkg-reconfigure --frontend=noninteractive debconf ;

# обновление пакетов
RUN apt update --quiet ; \
    apt upgrade --quiet --yes ;

# несколько пакетов для полной подготовки системы 
RUN apt install --quiet --yes --no-install-recommends \
        ca-certificates \
        apt-transport-https \
        software-properties-common ;

# локализация
RUN apt install --quiet --yes --no-install-recommends \
        # ru lang support
        locales language-pack-ru-base \
        # time data
        tzdata ;
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

# установка дополнительных пакетов
RUN apt install --quiet --yes --no-install-recommends \
        bash make sshpass ;

# установка ansible
RUN apt install --quiet --yes --no-install-recommends \
        ansible ;

# очистка кеша пакетного менеджера
RUN apt autoremove --yes ; \
    apt clean ; \
    rm -rf /var/lib/apt/lists/* ;
