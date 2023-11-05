#!/usr/bin/env bash

cd "$(dirname "$0")" || exit
rm -rf lib
mkdir lib
cd lib || exit

curl -L -O -J https://github.com/pgrange/bash_unit/archive/v2.1.0.tar.gz
tar -zxvf bash_unit-2.1.0.tar.gz
mv bash_unit-2.1.0 bash_unit
