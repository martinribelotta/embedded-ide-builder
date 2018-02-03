BASE=/tmp
OUT=/outside
SOURCE_TARGZ=embedded_ide-master.tar.gz
SOURCE_URL=https://github.com/martinribelotta/embedded-ide/archive/master.tar.gz
SOURCE_DIR=$(BASE)/embedded-ide-master
BUILD_DIR=$(BASE)/build-$(SOURCE_DIR)
BINARY_BUILD=$(BUILD_DIR)/build/embedded-ide
INSTALL_DIR=$(BASE)/embedded-ide
APP_IMAGE_NAME=Embedded_IDE-x86_64.AppImage
DEPLOY_OPT=-no-translations -verbose=2 -executable=$(INSTALL_DIR)/usr/bin/embedded-ide
DESKTOP_FILE=$(INSTALL_DIR)/usr/share/applications/embedded-ide.desktop
VER=$(shell cat $(SOURCE_DIR)/ide/src/version.cpp |grep -oE 'v[0-9]+\.[0-9]+')

all: $(APP_IMAGE_NAME)
	cp $< $(OUT)/Embedded_IDE-$(VER)-x86_64.AppImage

$(SOURCE_TARGZ):
	cd $(BASE)
	wget $(SOURCE_URL) -O $@

$(SOURCE_DIR): $(SOURCE_TARGZ)
	cd $(BASE)
	tar xf $<

$(BINARY_BUILD): $(SOURCE_DIR)
	mkdir -p $(BUILD_DIR) && \
	cd $(BUILD_DIR) && \
	/opt/qt58/bin/qmake $< && \
	make && \
	make install INSTALL_ROOT=$(INSTALL_DIR)

$(APP_IMAGE_NAME): $(BINARY_BUILD)
	cd $(BASE)
	linuxdeployqt $(DESKTOP_FILE) -qmake=/opt/qt58/bin/qmake $(DEPLOY_OPT) -appimage
	cp /opt/qt58/lib/libQt5Svg.so.5 $(INSTALL_DIR)/usr/lib
	cp /opt/qt58/plugins/imageformats/libqsvg.so $(INSTALL_DIR)/usr/plugins/imageformats/
	linuxdeployqt $(DESKTOP_FILE) -qmake=/opt/qt58/bin/qmake -appimage
