#!/bin/bash

# dependiencies: hidapi, 7z, build-essential, wget,
# sudo apt-get install libhidapi-dev p7z build-essential wget git

VERSION=0.5.0
QT_VERSION=5.9.1
QTSDK_DIR=/opt/Qt/${QT_VERSION}/gcc_64/
OUTPATH=${PWD}/build-embedded-ide-${VERSION}-x86_64.AppImage
OUTFILE=${PWD}/embedded-ide-${VERSION}-x86_64.AppImage

FILE_EMBIDE=embedded-ide.tar.gz

URL_EMBIDE="https://github.com/martinribelotta/embedded-ide/archive/v${VERSION}.tar.gz"
URL_APPIMAGE="https://github.com/probonopd/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"

log_file=build-$(date --rfc-3339=s|tr ' ' _)

exec &> >(tee -a "$log_file")

if true; then
    echo "Initialize out with skeleton"
    mkdir -p ${OUTPATH}
    cp -fR skeleton/* ${OUTPATH}
    echo "done"
fi

if true; then
    echo "doenloading embedded-ide"
    wget --no-check-certificate ${URL_EMBIDE} -O ${FILE_EMBIDE}
    tar xf ${FILE_EMBIDE}
    O=${PWD}
    cd embedded-ide-${VERSION} &&
    ${QTSDK_DIR}/bin/qmake && make &&
    cp build/embedded-ide ${OUTPATH}/bin
    cd ${O}
fi

if true; then
    mkdir -p ${OUTPATH}/lib
    echo "copy qt libs to ${OUTPATH}"
    for l in libQt5Core.so libQt5DBus.so libQt5Gui.so libQt5Network.so \
             libQt5Svg.so libQt5Widgets.so libQt5XcbQpa.so libQt5Xml.so libQt5Concurrent.so \
             libQt5PrintSupport.so ibcc1.so libicudata.so libicui18n.so libicuuc.so
    do
        cp -vP ${QTSDK_DIR}/lib/${l}* ${OUTPATH}/lib
    done
    cp -fPRv ${QTSDK_DIR}/plugins ${OUTPATH}
    echo "copy qt libs done"
fi

APPIMAGE_EXE=$(basename ${URL_APPIMAGE})
wget --no-check-certificate ${URL_APPIMAGE} -O ${APPIMAGE_EXE}
chmod a+x ${APPIMAGE_EXE}
rm -fR ${OUTFILE}
echo "Building app image..."
./${APPIMAGE_EXE} ${OUTPATH} ${OUTFILE}

echo "Done all"
