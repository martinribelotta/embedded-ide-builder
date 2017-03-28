#!/bin/sh

get_unzip_re7z_and_store () {
    D=$INSTALLER_PATH/packages/$4/data
    echo Getting $1 from $2 to $3 repacket to pkg $4
    if [ -f $1 ]
    then
        echo "Already download"
    else
        echo "Downloading"
        wget --no-check-certificate -O $1 $2
    fi
    if [ -d $3 ]
    then
        echo "Already unzip"
    else
        echo "mkdir and unzip"
        mkdir $3 && unzip -d $3 $1
    fi
}

get_and_store_pkg () {
    D=$INSTALLER_PATH/packages/$2/data
    echo Getting $1 from package $2 ($D)
    if [ -f $1 ]
    then
        echo "Already download"
    else
        echo "Downloading"
        wget --no-check-certificate -O $1 $D
    fi
}

if false; then
    export GCC_URL=https://developer.arm.com/-/media/Files/downloads/gnu-rm/6_1-2017q1/gcc-arm-none-eabi-6-2017-q1-update-win32.zip
    export GCC_LOCAL=$(basename $GCC_URL)
    export GCC_LOCAL_TMP_DIR=$BASE/gcc-arm-embedded
    export GCC_LOCAL_DIR=$BASE_MSYS/gcc-arm-embedded

    get_unzip_re7z_and_store $GCC_LOCAL $GCC_URL $GCC_LOCAL_DIR
fi

export OOCD_URL=http://www.freddiechopin.info/en/download/category/4-openocd?download=154%3Aopenocd-0.10.0
export OOCD_LOCAL=openocd-0.10.0.7z
export OOCD_LOCAL_PKG=org.nongnu.openocd

get_and_store $OOCD_LOCAL $OOCD_URL $OOCD_LOCAL_PKG

export EIDE_URL=https://github.com/martinribelotta/embedded-ide/releases/download/v0.4.0/embedded-ide-v0.4.0-win32.7z
export EIDE_LOCAL=$(basename $EIDE_URL)
export EIDE_LOCAL_PKG=org.rusotech.embedded_ide

get_and_unzip $EIDE_LOCAL $EIDE_URL $EIDE_LOCAL_PKG

test -d /etc/profile.d || mkdir /etc/profile.d

cat >/etc/profile.d/extra_path.sh <<EOM
export PATH=$PATH:/oocd/bin:/gcc-arm-embedded/bin:/embedded-ide
EOM
cp $BASE/msys.bat.in $BASE_MSYS/msys.bat
cp $BASE/start-ide.bat.in $BASE_MSYS/start-ide.bat
bash -i
exit 0
