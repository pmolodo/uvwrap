#!/bin/bash

set -e
set -u

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "${THIS_DIR}/uv_install.bash"

if [[ "${UVWRAP_OS_TYPE}" == "windows" ]]; then
    export UVWRAP_VENV_BIN_DIRNAME="Scripts"
else
    export UVWRAP_VENV_BIN_DIRNAME="bin"
fi

if [ -z "${UV_PROJECT_ENVIRONMENT:-}" ]; then
    if [ -z "${UVWRAP_VENV_NAME:-}" ]; then
        export UVWRAP_VENV_NAME=".venv"
    fi
    export UV_PROJECT_ENVIRONMENT="${THIS_DIR}/${UVWRAP_VENV_NAME}"
else
    export UVWRAP_VENV_NAME="$(basename "${UV_PROJECT_ENVIRONMENT}")"
fi

if [ -z "${UV_PROJECT:-}" ]; then
    export UV_PROJECT="${THIS_DIR}"
fi

export UVWRAP_VENV_BIN_DIR="${UV_PROJECT_ENVIRONMENT}/${UVWRAP_VENV_BIN_DIRNAME}"
export UVWRAP_VENV_ACTIVATE="${UVWRAP_VENV_BIN_DIR}/activate"

# if UVWRAP_VERBOSITY is defined, but set to an empty string, that's a valid
# value - don't overwrite it
if [ -z "${UVWRAP_VERBOSITY+defined}" ]; then
    export UVWRAP_VERBOSITY=--quiet
fi

"${UVWRAP_UV_PATH}" "${UVWRAP_VERBOSITY}" sync

if [ "${UVWRAP_VERBOSITY}" = "--quiet" ] || [ "${UVWRAP_VERBOSITY}" = "--q" ]; then
    . "${UVWRAP_VENV_ACTIVATE}" &> /dev/null
else
    . "${UVWRAP_VENV_ACTIVATE}"
fi

