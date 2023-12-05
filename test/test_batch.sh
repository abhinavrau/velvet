#!/usr/bin/env bash

function test_batch_search_csv() {

  cd "${PROJECT_DIR}" || exit

  TMP_FILE=$(mktemp)

  result=$("${SRC}"/"${SCRIPT_NAME}" bsearch "${TEST}"/data/batch_test_with_prompt.txt -f=csv > "$TMP_FILE")

  assert_equals 0 $?  "batch search command returned failure"

  # Match to expected results
  expected="test/data/expected_results/expected_batch_with_prompt.csv"

  assert_no_diff <(cat "$expected") <(cat "$TMP_FILE") "Resultng CSV does not match expected file $expected"
  rm "$TMP_FILE"
}

function test_batch_search_json() {

  cd "${PROJECT_DIR}" || exit
  TMP_FILE=$(mktemp)
  
  result=$("${SRC}"/"${SCRIPT_NAME}" bsearch "${TEST}"/data/batch_test_with_prompt.txt -f=jsonl > "$TMP_FILE")
  assert_equals 0 $? "batch search command returned failure"


 # Check for valid json
  if jq -e . < "$TMP_FILE" >/dev/null 2>&1; then
     # JSON is valid.
    success=0
  else 
    success=1
  fi
  assert_equals 0 "$success" "Output is not valid JSON"

  # Match to expected results
  expected="test/data/expected_results/expected_batch_with_prompt.jsonl"

  assert_no_diff <(cat "$expected") <(cat "$TMP_FILE") "Resultng JSONL does not match expected file $expected"
  rm "$TMP_FILE"

}