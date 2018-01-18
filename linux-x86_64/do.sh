docker build -t embedded-ide_builder-dock . && \
docker run -ti -v ${PWD}:/outside --privileged --cap-add=ALL -it -v /dev:/dev -v /lib/modules:/lib/modules embedded-ide_builder-dock
