#!/bin/bash

set -e
set -

uname_s="$(uname -s)"

windows=0
case "${uname_s,,}" in
    linux*)     runtime=linux; os_type=$runtime;;
    darwin*)    runtime=mac; os_type=$runtime;;
    cygwin*)    runtime=cygwin; os_type=windows;;
    mingw*)     runtime=mingww; os_type=windows;;
    msys*)      runtime=msys; os_type=windows;;
    *)
        echo "unrecognized runtime/os: '${uname_s}'"
        exit 101
esac

export UVWRAP_OS_TYPE="${os_type}"
export UVWRAP_OS_RUNTIME="${runtime}"

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -z "${UVWRAP_INSTALL_DIR:-}" ]; then
    UVWRAP_INSTALL_DIR="${THIS_DIR}/.uv"
fi

if ! [ -d "$UVWRAP_INSTALL_DIR" ]; then
    mkdir -p $UVWRAP_INSTALL_DIR
fi

#make UVWRAP_INSTALL_DIR absolute
UVWRAP_INSTALL_DIR="$(cd "$UVWRAP_INSTALL_DIR" && pwd)"


if [ "${UVWRAP_OS_TYPE}" = "windows" ]; then
    export UVWRAP_BIN_EXT=".exe"
else
    export UVWRAP_BIN_EXT=""
fi

export UVWRAP_FILENAME="uv${UVWRAP_BIN_EXT}"

# check if UV already installed
export UVWRAP_UV_PATH="${UVWRAP_INSTALL_DIR}/${UVWRAP_FILENAME}"
if [ -f "${UVWRAP_UV_PATH}" ]; then
    return 0
fi

# the uv install script uses XDG_BIN_HOME to tell it where to install
(
    export XDG_BIN_HOME="${UVWRAP_INSTALL_DIR}"
    export UV_NO_MODIFY_PATH=1
    export INSTALLER_PRINT_QUIET=1
    curl -LsSf https://astral.sh/uv/install.sh | sh
)
