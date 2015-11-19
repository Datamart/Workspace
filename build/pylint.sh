#!/bin/bash
#
# Downloads and runs pychecker, pylint and pep8ify.
# Guide: https://google.github.io/styleguide/shell.xml
# Link: http://sourceforge.net/projects/pychecker/files/latest/
# Link: http://www.pylint.org/#install
# Link: https://pypi.python.org/pypi/pep8ify

readonly CWD=$(cd $(dirname $0); pwd)
readonly LIB="${CWD}/lib"
readonly TMP="${CWD}/tmp"
readonly ROOT="${CWD}/.."

# TODO(user): Replace to project related path.
readonly PY_SOURCES="${CWD}/../src"

readonly PYCHECKER_VER="0.8.19"
readonly PYCHECKER_ZIP="pychecker-${PYCHECKER_VER}.tar.gz"
readonly PYCHECKER_URL="http://downloads.sourceforge.net/project/pychecker/pychecker/${PYCHECKER_VER}/${PYCHECKER_ZIP}"

readonly WGET="$(which wget)"
readonly CURL="$(which curl)"
readonly PYTHON="$(which python)"


#
# Downloads pychecker, pylint and pep8ify.
#
function download() {
  if [[ ! -e "$(which pychecker)" ]]; then
    echo "Downloading pychecker:"
    mkdir -p "${LIB}"
    rm -rf "${TMP}" && mkdir "${TMP}" && cd "${TMP}"
    if [[ -n "$WGET" ]]; then
      $WGET "${PYCHECKER_URL}" -O "${TMP}/${PYCHECKER_ZIP}"
    else
      $CURL -L "${PYCHECKER_URL}" > "${TMP}/${PYCHECKER_ZIP}"
    fi
    echo "Done"

    echo -n "Extracting pychecker: "
    tar -xzf "${TMP}/${PYCHECKER_ZIP}" -C "${LIB}"
    echo "Done"

    echo "Installing pychecker:"
    cd "${LIB}/pychecker-${PYCHECKER_VER}"
    $PYTHON setup.py --quiet build && sudo $PYTHON setup.py --quiet install
    echo "Done"

    cd "${CWD}" && rm -rf "${TMP}"
  fi

  if [[ ! -e "$(which pylint)" ]]; then
    echo "Installing pylint:"
    if [[ "$(uname)" == "Darwin" ]]; then
      sudo easy_install --quiet pip
      sudo pip install pylint
    else
      sudo apt-get install pylint
    fi
    echo "Done"
  fi

  if [[ ! -e "$(which pep8ify)" ]]; then
    echo "Installing pep8ify:"
    if [[ "$(uname)" == "Darwin" ]]; then
      sudo easy_install --quiet pip
      sudo pip install pep8ify
    else
      sudo apt-get install pep8ify
    fi
    echo "Done"
  fi
}

#
# Runs pychecker, pylint and pep8ify.
#
function run() {
  echo "Running pychecker, pylint and pep8ify:"
  local PYCHECKER="$(which pychecker)"
  local PYLINT="$(which pylint)"
  local PEP8IFY="$(which pep8ify)"

  echo "Running pychecker."
  $PYCHECKER --stdlib --quiet --no-shadowbuiltin "${PY_SOURCES}"/*.py
  echo "Running pylint."
  $PYLINT --reports=no --disable=I "${PY_SOURCES}"/*.py
  echo "Running pep8ify."
  $PEP8IFY -f all -f maximum_line_length "${PY_SOURCES}"/*.py
  echo "Done"
}

#
# The main function.
#
function main() {
  download
  run
}

main "$@"
