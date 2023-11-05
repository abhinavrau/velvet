#!/usr/bin/env bash

function test_search_csv() {

  cd "${PROJECT_DIR}" || exit
  result=$("${SRC}"/"${SCRIPT_NAME}" usearch 'How I make a payment using the mobile app' -c > /tmp/search_result_1.csv)

  assert_equals 0 $?

  # Check if more than 1 line is output 
  success=1
  num_lines=$(wc -l /tmp/search_result_1.csv | tr ' ' '\n' | head -1)
  if [ "$num_lines" -gt 1 ]; then
    success=0
  fi
  assert_equals 0 "$success"
}