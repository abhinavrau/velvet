# shellcheck disable=SC2148
function rank_reciprocal_at_2() {
  local actual_link_1="$1"
  local actual_link_2="$2"
  local expected_link_1="$3"
  local expected_link_2="$4"
  
  local rank=0

  # For each document link in the expected results, check if it is also in the actual results.
  if [ "$actual_link_1" == "${expected_link_1}" ]; then
        rank=$(echo "scale=4; 1" | bc)
  elif [ "$actual_link_2" == "${expected_link_1}" ]; then
        rank=$(echo "scale=4; 1/2" | bc)
  elif [ "$actual_link_1" == "${expected_link_2}" ]; then
        rank=$(echo "scale=4; 1/2" | bc)
  elif [ "$actual_link_2" == "${expected_link_2}" ]; then
        rank=$(echo "scale=4; 1/2" | bc)
  fi 
  # Return the rank_reciprocal_at_2 value.
  echo "$rank"
}