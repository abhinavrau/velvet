#Convert a jsonl file to a csv file
format_json_to_csv() {

  TMP_FILE=$(mktemp)
  # Define the filename

  echo "$1" > "$TMP_FILE"
  output=""
  # Get the first line's keys as the header
  keys=$(head -n 1 "${TMP_FILE}" | jq -r 'keys_unsorted'| tr -d '[]"' | tr -d '\n')
  # Add the keys as header to the output
  output+="${keys}"$'\n'

  while read -r line; do
    # Check if the line is blank
    if [[ -z "${line}" ]]; then
      continue
    fi

    # Get the values from the line
    values=$(echo "${line}"  | jq -r '.[] | values' | tr '\n' ',')
    
    # Output the values except the last comma
    output+="${values%?}"$'\n'

  done < "${TMP_FILE}"
  # Remove the temporary file
  rm "${TMP_FILE}"
  echo "${output}"

}
