FROM debian:bookworm

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Rome
ENV LANG="en_US.UTF-8" LC_ALL="C" LANGUAGE="en_US.UTF-8"

RUN set -x && apt-get update -y && apt-get install -y \
  build-essential \
  sudo \
  cmake \
  curl \
  git \
  man-db \
  python3 \
  python3-pip \
  python3-full \
  tmux \
  vim \
  wget \
  zsh

# configure locales
#RUN locale-gen "en_US.UTF-8" \
#  && dpkg-reconfigure locales
#RUN echo LC_ALL="en_US.UTF-8" >> /etc/default/locale

# create user and create home directory
RUN useradd -Um -d /home/work -G sudo -s /bin/bash --uid 1000 work

RUN echo work ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/work \
  && echo "root:root" | chpasswd \
  && echo "work:work" | chpasswd

# switch to user
USER work
WORKDIR /home/work

CMD [ "zsh" ]
