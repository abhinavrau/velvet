#!/usr/bin/env bash

function test_init() {

  cd "${PROJECT_DIR}" || exit
  result=$("${SRC}"/"${SCRIPT_NAME}" init)

  assert_equals 0 $?
  file_path="jtbl"
  # Check for jtbl
  if [ -e "$file_path" ]; then
    success=0
  else
    success=1
  fi
  assert_equals 0 "$success"

}

