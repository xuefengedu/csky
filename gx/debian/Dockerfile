FROM debian:stable

ARG rootpassword=newpassword

SHELL ["/bin/bash", "-c"] 
VOLUME ["/code"]
RUN echo root:$rootpassword | chpasswd
RUN mkdir /test
RUN dpkg --add-architecture i386
RUN apt-get update -qq
RUN apt-get install -y -qq --no-install-recommends build-essential locales bc ca-certificates file rsync gcc-multilib git bzr cvs mercurial subversion libc6:i386 unzip wget cpio;
RUN sed -i 's/# \(en_US.UTF-8\)/\1/' /etc/locale.gen
RUN /usr/sbin/locale-gen en_US.UTF-8
ENTRYPOINT touch /test/test.log && echo 'Started c-sky docker' && tail -f /test/test.log
