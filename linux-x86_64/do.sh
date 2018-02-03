#!/bin/bash
docker build -t embedded-ide_builder-dock . && \
if [ "x$1" = "x--suite" ]; then
    echo "Building suite"
    docker run -ti -v ${PWD}:/outside --privileged --cap-add=ALL -it -v /dev:/dev -v /lib/modules:/lib/modules embedded-ide_builder-dock make -C /tmp -f BuildIDE-suite.mk
else
    echi "Building standalone"
    docker run -ti -v ${PWD}:/outside --privileged --cap-add=ALL -it -v /dev:/dev -v /lib/modules:/lib/modules embedded-ide_builder-dock make -C /tmp -f BuildIDE-standalone.mk
fi
