#!/bin/bash
#
# Downloads and runs Google closure stylesheets compiler.
# Guide: https://google.github.io/styleguide/shell.xml
# Link: https://github.com/google/closure-stylesheets

readonly CWD=$(cd $(dirname $0); pwd)
readonly LIB="${CWD}/lib"

# TODO(user): Replace to project related path.
readonly CSS_COMPILED="${CWD}/../assets/compiled.css"
readonly CSS_SOURCES="${CWD}/../css"

readonly CSS_COMPILER_URL="https://github.com/google/closure-stylesheets/releases/download/1.0/closure-stylesheets.jar"
readonly CSS_COMPILER_JAR="${LIB}/closure-stylesheets.jar"

readonly WGET="$(which wget)"
readonly CURL="$(which curl)"


#
# Downloads closure stylesheets compiler.
#
function download() {
  if [[ ! -f "${CSS_COMPILER_JAR}" ]]; then
    echo "Downloading closure stylesheets compiler:"
    if [[ -n "$WGET" ]]; then
      $WGET "${CSS_COMPILER_URL}" -O "${CSS_COMPILER_JAR}"
    else
      $CURL -L "${CSS_COMPILER_URL}" > "${CSS_COMPILER_JAR}"
    fi
    echo "Done"
  fi
}

#
# Runs closure stylesheets compiler.
#
function run() {
  echo "Running closure stylesheets compiler:"
  local java="$(which java)"
  if [[ ! -f "${LIB}/java" ]]; then
    java="${LIB}/java"
  if

  if [ -d "${CSS_SOURCES}" ]; then
    rm -rf "${CSS_COMPILED}"
    touch "${CSS_COMPILED}" && chmod 0666 "${CSS_COMPILED}"

    find "${CSS_SOURCES}" -name "*.css" -print \
      | sed 's/.*/ &/' \
      | xargs ${java} -jar "${CSS_COMPILER_JAR}" \
          --allow-unrecognized-properties \
          --allow-unrecognized-functions \
          --output-file "${CSS_COMPILED}"
  fi
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
