#!/bin/bash

# dependiencies: hidapi, 7z, build-essential, wget,
# sudo apt-get install libhidapi-dev p7z build-essential wget git

VERSION=0.5.0

#QTSDK_DIR=/opt/Qt5.8.0/5.8/gcc_64
# Examples:
QTSDK_DIR=/opt/Qt/5.9.1/gcc_64/
# QTSDK_DIR=/opt/Qt5.8.0/5.8/gcc_64

OUTPATH=${PWD}/build-CIAA_SUITE-${VERSION}-x86_64.AppImage
OUTFILE=${PWD}/CIAA_SUITE-${VERSION}-x86_64.AppImage

VER_COREUTILS=8.27
VER_MAKE=4.2
VER_CTAGS=5.8
VER_DIFF=3.5
VER_PATCH=2.7
VER_CLANG=4.0.0
VER_OPENOCD=0.10.0

URL_COREUTILS="http://ftp.gnu.org/gnu/coreutils/coreutils-${VER_COREUTILS}.tar.xz"
URL_MAKE="http://ftp.gnu.org/gnu/make/make-${VER_MAKE}.tar.bz2"
URL_CTAGS="http://prdownloads.sourceforge.net/ctags/ctags-${VER_CTAGS}.tar.gz"
URL_DIFF="http://ftp.gnu.org/gnu/diffutils/diffutils-${VER_DIFF}.tar.xz"
URL_PATCH="http://ftp.gnu.org/gnu/patch/patch-${VER_PATCH}.tar.xz"
URL_CLANG="http://releases.llvm.org/${VER_CLANG}/clang+llvm-${VER_CLANG}-x86_64-linux-gnu-debian8.tar.xz"
URL_OPENOCD=
#"https://github.com/gnu-mcu-eclipse/openocd/releases/download/v0.10.0-2-20170622-1535-dev/gnu-mcu-eclipse-openocd-0.10.0-2-20170622-1535-dev-debian32.tgz"
URL_ARMGCC="https://developer.arm.com/-/media/Files/downloads/gnu-rm/6_1-2017q1/gcc-arm-none-eabi-6-2017-q1-update-linux.tar.bz2"
URL_EMBIDE="https://github.com/martinribelotta/embedded-ide/archive/master.tar.gz"
URL_APPIMAGE="https://github.com/probonopd/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage"

FILE_ARMGCC=$(basename ${URL_ARMGCC})
FILE_EMBIDE=embedded-ide.tar.gz

RULE_MAKE="./configure LDFLAGS=-static && make && cp make ${OUTPATH}/bin"
RULE_DIFF="./configure LDFLAGS=-static && make && cp src/diff ${OUTPATH}/bin"
RULE_PATCH="./configure LDFLAGS=-static && make && cp src/patch ${OUTPATH}/bin"
RULE_CTAGS="./configure LDFLAGS=-static && make && cp ctags ${OUTPATH}/bin"
RULE_OPENOCD="./configure --prefix=$OUTPATH --enable-cmsis-dap --enable-ftdi --enable-sysfsgpio  --enable-static LDFLAGS=-static && make && make install"

log_file=build-$(date --rfc-3339=s|tr ' ' _)

exec &> >(tee -a "$log_file")
if false; then
if true; then
    echo "Initialize out with skeleton"
    mkdir -p ${OUTPATH}
    cp -fR skeleton/* ${OUTPATH}
    echo "done"
fi

if true; then
    for TARGET in OPENOCD MAKE CTAGS DIFF PATCH
    do
        vu="URL_${TARGET}"
        URL=${!vu}
        vr="RULE_${TARGET}"
        RULE=${!vr}
        OUT=$(basename ${URL} | cut -f 1 -d '?')
        OUTDIR=$(echo ${OUT} | sed -E 's/.tar.gz|.tar.bz2|.tar.xz|.7z//')
        echo "downloading ${URL}"
        wget -O ${OUT} --no-check-certificate ${URL}
        echo "uncompress ${OUT}"
        tar xf ${OUT}
        old=${PWD}
        echo "compiling with rule ${vr}: ${RULE}"
        cd ${OUTDIR}
        eval ${RULE}
        cd ${old}
    done
fi

if true; then
    echo "doenloading gcc arm embedded..."
    wget --no-check-certificate ${URL_ARMGCC} -O ${FILE_ARMGCC}
    echo "uncrompress gcc arm embedded..."
    tar xf ${FILE_ARMGCC} --strip-components=1 -C ${OUTPATH}
    echo "done."
fi

if true; then
    echo "download and install clang..."
    F=$(basename ${URL_CLANG})
    D=$(echo ${F} | sed -E 's/.tar.gz|.tar.bz2|.tar.xz//')
    wget --no-check-certificate ${URL_CLANG} -O ${F}
    tar vxf ${F} --strip-components=1 -C ${OUTPATH} ${D}/bin/clang-4.0 ${D}/bin/clang ${D}/bin/clang++
fi

if true; then
    echo "doenloading embedded-ide"
    wget --no-check-certificate ${URL_EMBIDE} -O ${FILE_EMBIDE}
    tar xf ${FILE_EMBIDE}
    O=${PWD}
    cd embedded-ide-master &&
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
fi
APPIMAGE_EXE=$(basename ${URL_APPIMAGE})
wget --no-check-certificate ${URL_APPIMAGE} -O ${APPIMAGE_EXE}
chmod a+x ${APPIMAGE_EXE}
rm -fR ${OUTFILE}
echo "Building app image..."
./${APPIMAGE_EXE} ${OUTPATH} ${OUTFILE}

echo "Done all"
