# -*- mode: dockerfile; -*-
# vi: set ft=dockerfile:

ARG TAG
FROM ubuntu:18.04
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get update -qq \
  && apt-get dist-upgrade -qy -o Dpkg::Options::=--force-confdef \
      -o Dpkg::Options::=--force-confnew -o Dpkg::Use-Pty=0 \
  && apt-get install -qy -o Dpkg::Options::=--force-confdef \
      -o Dpkg::Options::=--force-confnew -o Dpkg::Use-Pty=0 locales sudo \
  && rm -rf /var/lib/apt/lists/* \
  && locale-gen en_US.UTF-8 \
  && groupadd -g 1000 ubuntu \
  && useradd -d /home/ubuntu -g ubuntu -m ubuntu -s /bin/bash -u 1000 \
  && echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/ubuntu \
  && chmod 0440 /etc/sudoers.d/ubuntu \
  && mkdir -p /home/ubuntu \
  && chown -R ubuntu:ubuntu /home/ubuntu
ENV HOME=/home/ubuntu LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LOGNAME=ubuntu \
  SHELL=/bin/bash USER=ubuntu
USER ubuntu
WORKDIR /home/ubuntu
