BASE=/tmp
OUT=/outside
SOURCE_TARGZ=embedded_ide-master.tar.gz
SOURCE_URL=https://github.com/martinribelotta/embedded-ide/archive/master.tar.gz
SOURCE_DIR=$(BASE)/embedded-ide-master
BUILD_DIR=$(BASE)/build-$(SOURCE_DIR)
BINARY_BUILD=$(BUILD_DIR)/build/embedded-ide
INSTALL_DIR=$(BASE)/embedded-ide
OUT_PATH=$(INSTALL_DIR)/usr
APP_IMAGE_NAME=CIAA_Suite-x86_64.AppImage
DEPLOY_OPT=-no-translations -verbose=2 -executable=$(INSTALL_DIR)/usr/bin/embedded-ide
DESKTOP_FILE=$(INSTALL_DIR)/usr/share/applications/embedded-ide.desktop
VER=$(shell cat $(SOURCE_DIR)/ide/src/version.cpp |grep -oE 'v[0-9]+\.[0-9]+')

WORK_DIR=$(BASE)/work

VER_MAKE=4.2
VER_CTAGS=5.8
VER_DIFF=3.5
VER_PATCH=2.7
VER_CLANG=5.0.1

URL_MAKE:="http://ftp.gnu.org/gnu/make/make-${VER_MAKE}.tar.bz2"
LOCAL_MAKE:=$(WORK_DIR)/make-${VER_MAKE}.tar.bz2
UNCOMPRESS_MAKE:=$(WORK_DIR)/make-${VER_MAKE}/configure
BUILD_MAKE:=$(dir $(UNCOMPRESS_MAKE))/make
INSTALL_MAKE:=$(INSTALL_DIR)/usr/bin/make

URL_OPENOCD:="https://github.com/gnu-mcu-eclipse/openocd/releases/download/v0.10.0-7-20180123/gnu-mcu-eclipse-openocd-0.10.0-7-20180123-1217-centos64.tgz"
LOCAL_OPENOCD:=$(WORK_DIR)/gnu-mcu-eclipse-openocd-0.10.0-7-20180123-1217-centos64.tgz
BASE_OPENOCD:=$(WORK_DIR)/gnu-mcu-eclipse/openocd/0.10.0-7-20180123-1217
UNCOMPRESS_OPENOCD:="$(BASE_OPENOCD)/licenses/libusb-1.0.20/COPYING"
INSTALL_OPENOCD:=$(INSTALL_DIR)/usr/bin/openocd

URL_CTAGS:="http://prdownloads.sourceforge.net/ctags/ctags-${VER_CTAGS}.tar.gz"
LOCAL_CTAGS:="$(WORK_DIR)/ctags-${VER_CTAGS}.tar.gz"
UNCOMPRESS_CTAGS:=$(WORK_DIR)/ctags-${VER_CTAGS}/configure
BUILD_CTAGS:=$(dir $(UNCOMPRESS_CTAGS))/ctags
INSTALL_CTAGS:=$(INSTALL_DIR)/usr/bin/ctags

URL_DIFF:="http://ftp.gnu.org/gnu/diffutils/diffutils-${VER_DIFF}.tar.xz"
LOCAL_DIFF:="$(WORK_DIR)/diffutils-${VER_DIFF}.tar.xz"
UNCOMPRESS_DIFF:=$(WORK_DIR)/diffutils-${VER_DIFF}/configure
BUILD_DIFF:=$(dir $(UNCOMPRESS_DIFF))/src/diff
INSTALL_DIFF:=$(INSTALL_DIR)/usr/bin/diff

URL_PATCH:="http://ftp.gnu.org/gnu/patch/patch-${VER_PATCH}.tar.xz"
LOCAL_PATH:="$(WORK_DIR)/patch-${VER_PATCH}.tar.xz"
UNCOMPRESS_PATH:=$(WORK_DIR)/patch-${VER_PATCH}/configure
BUILD_PATH:=$(dir $(UNCOMPRESS_PATH))/src/patch
INSTALL_PATH:=$(INSTALL_DIR)/usr/bin/patch

URL_CLANG:="http://releases.llvm.org/${VER_CLANG}/clang+llvm-${VER_CLANG}-x86_64-linux-gnu-debian8.tar.xz"
LOCAL_CLANG:=$(WORK_DIR)/clang+llvm-${VER_CLANG}-x86_64-linux-gnu-debian8.tar.xz
CLANG_BASE_DIR:=$(basename $(basename $(LOCAL_CLANG)))
UNCOMPRESS_CLANG:=$(CLANG_BASE_DIR)/bin/clang-5.0
INSTALL_CLANG:=$(UNCOMPRESS_CLANG:$(CLANG_BASE_DIR)/%=$(INSTALL_DIR)/usr/%)

URL_ARMGCC:="https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-rm/7-2017q4/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2"
LOCAL_ARMGCC:=$(WORK_DIR)/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2
LOCALDIR_ARMGCC:=$(WORK_DIR)/gcc-arm-none-eabi-7-2017-q4-major
INSTALL_ARMGCC:=$(INSTALL_DIR)/usr/bin/arm-none-eabi-gcc

.PHONY: all extras
all: $(WORK_DIR) extras $(APP_IMAGE_NAME)
	cp $(APP_IMAGE_NAME) $(OUT)/CIAA-Suite-$(VER)-x86_64.AppImage

extras: do_remote_oocd do_static_make do_static_ctags do_static_diff do_static_path do_remote_clang do_remote_armgcc

$(WORK_DIR):
	@mkdir -p $@

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
	mkdir -p $(INSTALL_DIR)/usr/lib $(INSTALL_DIR)/usr/plugins/imageformats/
	cp -fRpv /opt/qt58/lib/libQt5Svg.so.5 $(INSTALL_DIR)/usr/lib
	cp -fRpv /opt/qt58/plugins/imageformats/libqsvg.so $(INSTALL_DIR)/usr/plugins/imageformats/
	sed -ir 's/Embedded IDE/CIAA Suite/' $(DESKTOP_FILE)
	linuxdeployqt $(DESKTOP_FILE) -qmake=/opt/qt58/bin/qmake $(DEPLOY_OPT) -appimage

download_oocd: 
	@touch $@

$(LOCAL_OPENOCD): $(WORK_DIR)
	wget $(URL_OPENOCD) -O $@

$(UNCOMPRESS_OPENOCD): $(LOCAL_OPENOCD)
	cd $(dir $<) &&	tar xf $<

$(INSTALL_OPENOCD): $(UNCOMPRESS_OPENOCD)
	mkdir -p $(INSTALL_DIR)/usr && cp -fRpv $(BASE_OPENOCD)/* $(INSTALL_DIR)/usr/

do_remote_oocd: $(INSTALL_OPENOCD)

$(LOCAL_MAKE): $(WORK_DIR)
	wget $(URL_MAKE) -O $@

$(UNCOMPRESS_MAKE): $(LOCAL_MAKE)
	cd $(WORK_DIR) && tar xf $<

$(BUILD_MAKE): $(UNCOMPRESS_MAKE)
	cd $(dir $(UNCOMPRESS_MAKE)) && ./configure LDFLAGS=-static && make

$(INSTALL_MAKE): $(BUILD_MAKE)
	install -D $< $@
	rm -fr config.log

do_static_make: $(INSTALL_MAKE)

$(LOCAL_CTAGS): $(WORK_DIR)
	wget $(URL_CTAGS) -O $@

$(UNCOMPRESS_CTAGS): $(LOCAL_CTAGS)
	cd $(WORK_DIR) && tar xf $<

$(BUILD_CTAGS): $(UNCOMPRESS_CTAGS)
	cd $(dir $<) && ./configure LDFLAGS=-static && make

$(INSTALL_CTAGS): $(BUILD_CTAGS)
	install -D $< $@
	rm -fR config.log

do_static_ctags: $(INSTALL_CTAGS)

$(LOCAL_DIFF): $(WORK_DIR)
	wget $(URL_DIFF) -O $@

$(UNCOMPRESS_DIFF): $(LOCAL_DIFF)
	cd $(WORK_DIR) && tar xf $<

$(BUILD_DIFF): $(UNCOMPRESS_DIFF)
	cd $(dir $<) && ./configure LDFLAGS=-static && make

$(INSTALL_DIFF): $(BUILD_DIFF)
	install -D $< $@

do_static_diff: $(INSTALL_DIFF)

$(LOCAL_PATH): $(WORK_DIR)
	wget $(URL_PATCH) -O $@

$(UNCOMPRESS_PATH): $(LOCAL_PATH)
	cd $(WORK_DIR) && tar xf $<

$(BUILD_PATH): $(UNCOMPRESS_PATH)
	cd $(dir $<) && ./configure LDFLAGS=-static && make

$(INSTALL_PATH): $(BUILD_PATH)
	install -D $< $@

do_static_path: $(INSTALL_PATH)

$(LOCAL_CLANG): $(WORK_DIR)
	wget --no-check-certificate ${URL_CLANG} -O $(LOCAL_CLANG)

$(UNCOMPRESS_CLANG): $(LOCAL_CLANG)
	cd $(WORK_DIR) && tar vxf $(LOCAL_CLANG)

$(INSTALL_CLANG): $(UNCOMPRESS_CLANG)
	install -D -b -t $(INSTALL_DIR)/usr/bin $< && \
	cd $(INSTALL_DIR) && ln -s $(notdir $@) clang && ln -s $(notdir $@) clang++

do_remote_clang: $(INSTALL_CLANG)

$(LOCAL_ARMGCC): $(WORK_DIR)
	wget $(URL_ARMGCC) -O $@

$(INSTALL_ARMGCC): $(LOCAL_ARMGCC)
	cd $(WORL_DIR) && tar xf $< --strip-components=1 -C $(INSTALL_DIR)/usr

do_remote_armgcc: $(INSTALL_ARMGCC)
