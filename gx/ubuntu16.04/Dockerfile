FROM ubuntu:16.04

ARG rootpassword=newpassword

SHELL ["/bin/bash", "-c"] 
VOLUME ["/code"]
RUN echo root:$rootpassword | chpasswd
RUN mkdir /test
RUN apt-get update -y
RUN apt-get install -y make g++ build-essential git python lzip ncurses-dev minicom locales bc ca-certificates file rsync gcc-multilib unzip wget cpio;
ENTRYPOINT touch /test/test.log && echo 'Started c-sky docker' && tail -f /test/test.log
