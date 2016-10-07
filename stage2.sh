export WGET_CMD="wget --no-check-certificate"

get_and_unzip () {
echo Getting $1 from $2 to $3
test -f $1 || $(echo "downloading" && $WGET_CMD -O $1 $2) && echo "Already download"
test -d $3 || $(echo "Mkdir and unzip" && mkdir $3 && unzip -d $3 $1) && echo "Already unzip"
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

test -d /etc/profile.d || mkdir /etc/profile.d

cat >/etc/profile.d/extra_path.sh <<EOM
export PATH=$PATH:/oocd/bin:/gcc-arm-embedded/bin
EOM

bash -i
exit 0
