FROM ubuntu:14.04
MAINTAINER Martin Ribelotta <martinribelotta@gmail.com>

WORKDIR /tmp
RUN apt update
RUN apt install -y software-properties-common
RUN add-apt-repository -y ppa:beineri/opt-qt58-trusty
RUN apt update
RUN apt install -y build-essential qt58base qt58tools qt58svg qt58imageformats qt58x11extras libglu1-mesa-dev wget fuse
ADD BuildQSCI.mk /tmp
ADD BuildIDE-standalone.mk /tmp/
ADD BuildIDE-suite.mk /tmp/
ADD universal-ctags /tmp
ADD https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage /usr/bin/linuxdeployqt
RUN chmod 0755 /usr/bin/linuxdeployqt
VOLUME ["/outside"]
