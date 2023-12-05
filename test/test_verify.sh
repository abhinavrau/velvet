#!/usr/bin/env bash

function test_verify_csv_with_prompt() {

  cd "${PROJECT_DIR}" || exit
  TMP_FILE=$(mktemp)

  result=$("${SRC}"/"${SCRIPT_NAME}" verify test/data/verify_test_with_prompt.csv -f=csv > "$TMP_FILE")

  assert_equals 0 $? "verify command returned failure"

  # Match to expected results
  expected="test/data/expected_results/expected_verify_with_prompt.csv"

  assert_no_diff <(cat "$expected") <(cat "$TMP_FILE") "Resultng CSV does not match expected file $expected"

  rm "$TMP_FILE"
}

function test_verify_jsonl_with_prompt() {

  cd "${PROJECT_DIR}" || exit
  TMP_FILE=$(mktemp)

  result=$("${SRC}"/"${SCRIPT_NAME}" verify test/data/verify_test_with_prompt.csv -f=jsonl > "$TMP_FILE")

  assert_equals 0 $? "verify command returned failure"

  # Check for valid json
  if jq -e . < "$TMP_FILE" >/dev/null 2>&1; then
     # JSON is valid.
    success=0
  else 
    success=1
  fi
  assert_equals 0 "$success" "Output is not valid JSON"

  # Match to expected results
  expected="test/data/expected_results/expected_verify_with_prompt.jsonl"


  assert_no_diff <(cat "$expected") <(cat "$TMP_FILE") "Resultng JSONL does not match expected file $expected"

  rm "$TMP_FILE"
}

function test_verify_csv_no_prompt() {

  cd "${PROJECT_DIR}" || exit
  TMP_FILE=$(mktemp)

  result=$("${SRC}"/"${SCRIPT_NAME}" verify test/data/verify_test_no_prompt.csv -f=csv > "$TMP_FILE")

  assert_equals 0 $? "verify command returned failure"

  # Match to expected results
  expected="test/data/expected_results/expected_verify_no_prompt.csv"

  assert_no_diff <(cat "$expected") <(cat "$TMP_FILE") "Resultng CSV does not match expected file $expected"

  rm "$TMP_FILE"
}

function test_verify_failure() {

  cd "${PROJECT_DIR}" || exit
  TMP_FILE=$(mktemp)

  result=$("${SRC}"/"${SCRIPT_NAME}" verify test/data/verify_test_failure.csv -f=csv > "$TMP_FILE")

  assert_equals 1 $? "verify command returned success. Should return failure."

  rm "$TMP_FILE"
}