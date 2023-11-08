#!/usr/bin/env bash

function test_search_csv() {

  cd "${PROJECT_DIR}" || exit
  result=$("${SRC}"/"${SCRIPT_NAME}" usearch 'What was the Google Cloud revenue in Q4 of 2022?' -c > /tmp/search_result_1.csv)

  assert_equals 0 $?

  # Check if more than 1 line is output 
  success=1
  num_lines=$(wc -l /tmp/search_result_1.csv | tr ' ' '\n' | head -1)
  if [ "$num_lines" -gt 1 ]; then
    success=0
  fi
  assert_equals 0 "$success"
}

function test_search_json() {

  cd "${PROJECT_DIR}" || exit
  result=$("${SRC}"/"${SCRIPT_NAME}" usearch 'What was the Google Cloud revenue in Q4 of 2022?' > /tmp/search_result_1.json 2>/dev/null)

  assert_equals 0 $?


  # Check for valid json
  if jq empty < /tmp/search_result_1.json >/dev/null 2>&1; then
     # JSON is valid.
    success=0
  else 
    success=1
  fi
  assert_equals 0 "$success"
}