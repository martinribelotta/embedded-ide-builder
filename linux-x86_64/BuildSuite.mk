.DEFAULT: all
BASE=/tmp
OUT=/outside
SOURCE_TARGZ=embedded_ide-master.tar.gz
SOURCE_URL=https://github.com/martinribelotta/embedded-ide/archive/master.tar.gz
SOURCE_DIR=$(BASE)/embedded-ide-master
BUILD_DIR=$(BASE)/build-$(SOURCE_DIR)
BINARY_BUILD=$(BUILD_DIR)/build/embedded-ide
INSTALL_DIR=$(BASE)/embedded-ide
APP_IMAGE_NAME=Embedded_IDE-x86_64.AppImage
APP_IMAGE_EXEC=$(INSTALL_DIR)/embedded-ide.sh.wrapper
APP_IMAGE_EXEC2=$(INSTALL_DIR)/embedded-ide.sh
DEPLOY_OPT="-qmake=/opt/qt58/bin/qmake -no-translations -verbose=2 -appimage"
DEKSTOP_FILE=$(INSTALL_DIR)/usr/share/applications/embedded-ide.desktop
VER=$(shell cat $(SOURCE_DIR)/ide/src/version.cpp |grep -oE 'v[0-9]+\.[0-9]+')

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

$(APP_IMAGE_EXEC): $(SOURCE_DIR)/ide/skeleton/embedded-ide.sh.wrapper
	install -m 0755 $< $@

$(APP_IMAGE_EXEC2): $(SOURCE_DIR)/ide/skeleton/embedded-ide.sh
	install -m 0755 $< $@

$(INSTALL_DIR)/embedded-ide.png.png: $(INSTALL_DIR)/usr/share/icons/default/256x256/apps/embedded-ide.png
	ln -s $< $@

.PHONY: extras
extras: $(INSTALL_DIR)/embedded-ide.png.png $(APP_IMAGE_EXEC2) $(APP_IMAGE_EXEC)

$(APP_IMAGE_NAME): $(BINARY_BUILD) extras
	cd $(BASE)
	linuxdeployqt $(DESKTOP_FILE) $(DEPLOY_OPT) -executable=$(APP_IMAGE_EXEC)

.PHONY: all
all: $(APP_IMAGE_NAME)
	cp $< $(OUT)/Embedded_IDE-$(VER)-x86_64.AppImage
