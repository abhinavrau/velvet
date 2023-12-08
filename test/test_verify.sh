#!/usr/bin/env bash

function test_verify_csv() {

  cd "${PROJECT_DIR}" || exit
  TMP_FILE=$(mktemp)

  result=$("${SRC}"/"${SCRIPT_NAME}" verify test/data/expected_verfication_success.csv -f=csv > "$TMP_FILE")

  assert_equals 0 $? "verify command returned failure"

  # Match to expected results
  expected="test/data/expected_results/expected_verfication_success.csv"

  assert_no_diff <(cat "$expected") <(cat "$TMP_FILE") "Resultng CSV does not match expected file $expected"

  rm "$TMP_FILE"
}

function test_verify_jsonl() {

  cd "${PROJECT_DIR}" || exit
  TMP_FILE=$(mktemp)

  result=$("${SRC}"/"${SCRIPT_NAME}" verify test/data/expected_verfication_success.csv -f=jsonl > "$TMP_FILE")

  assert_equals 0 $? "verify command returned failure"

  # Match to expected results
  expected="test/data/expected_results/expected_verfication_success.jsonl"

  assert_no_diff <(cat "$expected") <(cat "$TMP_FILE") "Resultng JSONL does not match expected file $expected"

  rm "$TMP_FILE"
}