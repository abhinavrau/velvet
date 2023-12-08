#!/usr/bin/env bash
set -e 

b
# Set project root as the working directory
cd "$(dirname "$0")" || exit

bashly="docker run --rm -it --user $(id -u):$(id -g) --volume "$PWD:/app" dannyben/bashly"
echo "$bashly"

PROJECT_DIR="$(realpath ".")"
export PROJECT_DIR
PATH=$PROJECT_DIR:$PATH 
export PATH
SCRIPT_NAME="vlvt"
export SCRIPT_NAME
export SRC="${PROJECT_DIR}"
export TEST="${PROJECT_DIR}/test"
export BUILD="${PROJECT_DIR}/build"

$($bashly generate)
#test/lib/bash_unit/bash_unit test/test*.sh
