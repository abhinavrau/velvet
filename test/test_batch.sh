#!/usr/bin/env bash

function test_search_batch() {

  cd "${PROJECT_DIR}" || exit

  TMP_FILE=$(mktemp)

  result=$("${SRC}"/"${SCRIPT_NAME}" batch-search "${TEST}"/data/batch_test.txt > "$TMP_FILE")

  assert_equals 0 $?

  # Check if more than 1 line is output 
  success=1
  num_lines=$(wc -l "$TMP_FILE" | tr ' ' '\n' | head -1)
  if [ "$num_lines" -gt 2 ]; then
    success=0
  fi

  rm "$TMP_FILE"
  
  assert_equals 0 "$success"
}