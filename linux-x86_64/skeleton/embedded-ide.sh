#!/bin/sh
APP_DIR=`dirname $0`
APP_DIR=`cd "${APP_DIR}";pwd`
export PATH=${APP_DIR}/bin:${PATH}
export LD_LIBRARY_PATH="${APP_DIR}/lib":
exec "${APP_DIR}/bin/embedded-ide" "$@"
