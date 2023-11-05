#!/usr/bin/env bash

function test_search_batch() {

  cd "${PROJECT_DIR}" || exit
  result=$("${SRC}"/"${SCRIPT_NAME}" batch-search "${TEST}"/data/batch_test.txt  /tmp/batch_search_result_1.csv)

  assert_equals 0 $?

  # Check if more than 1 line is output 
  success=1
  num_lines=$(wc -l /tmp/batch_search_result_1.csv | tr ' ' '\n' | head -1)
  if [ "$num_lines" -gt 2 ]; then
    success=0
  fi
  assert_equals 0 "$success"
}