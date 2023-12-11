function precision_at() {
  local actual_link="$1"
  local expected_link_1="$2"
  local expected_link_2="$3"
  local position="$4"
  local precision=0
  # For each document link in the expected results, check if it is also in the actual results.
  if [ "$actual_link" == "${expected_link_1}" ]; then
        precision=$(echo "scale=4; $position/1" | bc)
  elif [ "$actual_link" == "${expected_link_2}" ]; then
        precision=$(echo "scale=4; $position/2" | bc)
  fi
  # Return the p value.
  echo "$precision"
}