#!/bin/sh

get_and_unzip () {
echo Getting $1 from $2 to $3
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

export GCC_URL=https://launchpad.net/gcc-arm-embedded/5.0/5-2016-q3-update/+download/gcc-arm-none-eabi-5_4-2016q3-20160926-win32.zip
export GCC_LOCAL=$(basename $GCC_URL)
export GCC_LOCAL_DIR=$BASE_MSYS/gcc-arm-embedded

get_and_unzip $GCC_LOCAL $GCC_URL $GCC_LOCAL_DIR

#test -f $GCC_LOCAL || $WGET_CMD -O $GCC_LOCAL $GCC_URL
#test -d $GCC_LOCAL_DIR || $(mkdir $GCC_LOCAL_DIR && unzip -d $GCC_LOCAL_DIR $GCC_LOCAL)

export OOCD_URL=http://sysprogs.com/files/gnutoolchains/arm-eabi/openocd/OpenOCD-20160901.zip
export OOCD_LOCAL=$(basename $OOCD_URL)
export OOCD_LOCAL_DIR=$BASE_MSYS/oocd

get_and_unzip $OOCD_LOCAL $OOCD_URL $OOCD_LOCAL_DIR

export EIDE_URL=https://github.com/martinribelotta/embedded-ide/releases/download/v0.1/embedded-ide-0.1.1-win32.zip
export EIDE_LOCAL=$(basename $EIDE_URL)
export EIDE_LOCAL_DIR=$BASE_MSYS/embedded-ide

get_and_unzip $EIDE_LOCAL $EIDE_URL $EIDE_LOCAL_DIR

test -d /etc/profile.d || mkdir /etc/profile.d

cat >/etc/profile.d/extra_path.sh <<EOM
export PATH=$PATH:/oocd/bin:/gcc-arm-embedded/bin:/embedded-ide
EOM

bash -i
exit 0