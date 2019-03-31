BASE=/tmp
QSCI_VER=2.11.1
SOURCE_URL=https://www.riverbankcomputing.com/static/Downloads/QScintilla/${QSCI_VER}/QScintilla_gpl-$(QSCI_VER).tar.gz
SOURCE_TARGZ=$(notdir $(SOURCE_URL))
SOURCE_DIR=$(BASE)/QScintilla_gpl-$(QSCI_VER)
BUILD_DIR=$(SOURCE_DIR)/Qt4Qt5
BINARY_BUILD=$(BUILD_DIR)/libqscintilla2_qt5.so

all: $(BINARY_BUILD)

$(SOURCE_TARGZ):
	cd $(BASE)
	wget $(SOURCE_URL) -O $@

$(SOURCE_DIR): $(SOURCE_TARGZ)
	cd $(BASE)
	tar xf $<

$(BINARY_BUILD): $(SOURCE_DIR)
	mkdir -p $(BUILD_DIR) && \
	cd $(BUILD_DIR) && \
	/opt/qt58/bin/qmake && \
	make && \
	make install

