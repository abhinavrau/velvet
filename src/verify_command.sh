#inspect_args
input_file=${args[input_file]}
format=${args[--format]}
token=${GCP_ACCESS_TOKEN}

if [ -z "$token" ]; then 
    token=$(gcloud auth print-access-token)
fi

# Check if the file exists
if [ ! -f "$input_file" ]; then
  echo "File not found: $input_file"
  exit 1
fi

# Read the CSV file line by line
read -r header < "$input_file" # Read the first line as header
column_names=($(echo "$header" | tr ',' '\n')) # Split header into array based on comma delimiter

# Verify column names or take any actions based on them
expected_columns=("id" "query" "expected_summary" "expected_document_link_1" "expected_document_link_2") # Define expected column names
if [ "${#column_names[@]}" -ne "${#expected_columns[@]}" ]; then
  echo "Column count doesn't match!"
  exit 1
fi

for ((i = 0; i < ${#expected_columns[@]}; i++)); do
  if [ "${column_names[$i]}" != "${expected_columns[$i]}" ]; then
    echo "Column '${expected_columns[$i]}' not found!"
    exit 1
  fi
done

ids=()
queries=()
expected_summaries=()
expected_document_links_1=()
expected_document_links_2=()

# Read the rest of the rows and store individual fields in arrays
while IFS=',' read -r id query expected_summary expected_document_link_1 expected_document_link_2 ; do
  ids+=("$id")
  queries+=("$query")
  expected_summaries+=("$expected_summary")
  expected_document_links_1+=("$expected_document_link_1")
  expected_document_links_2+=("$expected_document_link_2")
done < <(tail -n +2 "$input_file")




output=""
summary_correct_count=0
link_1_correct_count=0
link_2_correct_count=0
total_documents=${#ids[@]}
# Loop through the entries and call vertex ai search and then call palm bison to match the summaries
for ((i = 0; i < total_documents; i++)); do
  #echo "ID: ${ids[$i]}, query: ${queries[$i]}, expected_summary: ${expected_summaries[$i]}, expected_document_link: ${expected_document_links[$i]}"
  # Skip line with empty id field
  if [ -z "${ids[$i]}" ]; then
      continue;
  else
    current_id="${ids[$i]}"
    expected_link_1="${expected_document_links_1[$i]}"
    expected_link_2="${expected_document_links_2[$i]}"
    expected_link_1=$(echo "$expected_link_1" | xargs)
    expected_link_2=$(echo "$expected_link_2" | xargs)
    
    query=${queries[$i]}
    call_vertex_ai_search

    if [ "$link_1" == "${expected_link_1}" ]; then
        link_1_match="matched"
        p0_precision=1.0
    else 
        link_1_match="not_matched"
        p0_precision=0.0
    fi

    if [[ "$link_1" == "${expected_link_1}" || "$link_1" == "${expected_link_2}" ]]; then
        link_1_correct_count=$((link_1_correct_count + 1))
    fi 
    p1_precision=$(echo "scale=4; $link_1_correct_count / ($i+1) " | bc)
    

    if [ "$link_2" == "${expected_link_2}" ]; then
        link_2_match="matched"
    else 
        link_2_match="not_matched"
    fi

    if [[ "$link_2" == "${expected_link_1}" || "$link_2" == "${expected_link_2}" ]]; then
        link_2_correct_count=$((link_2_correct_count + 1))
    fi 
    p2_precision=$(echo "scale=4; $link_2_correct_count / ($i+1) " | bc)


    expected_summary=${expected_summaries[$i]}
    # Verify the summary by calling text-bison
    call_palm_text_bison

    # Calculate precision
    
    if [ "$summary_match" == "same" ];then 
      summary_correct_count=$((summary_correct_count + 1))
    fi 
    summary_precision=$(echo "scale=4; $summary_correct_count / ($i+1) " | bc)

    # Create JSONL output
    #output+="{\"id\": \"$current_id\", \"actual_summary\": \"$summary\", \"expected_summary\": \"$expected_summary\", \"summary_match\": \"$summary_match\" , \"expected_link_1\": \"$expected_link_1\"  ,  \"actual_link_1\": \"$link_1\", \"link_1_match\": \"$link_1_match\", \"expected_link_2\": \"$expected_link_2\" ,  \"actual_link_2\": \"$link_2\"  ,\"link_2_match\": \"$link_2_match\", \"summary_p\": \"$summary_precision\" ,  \"@p0\": \"$p0_precision\", \"@p1\": \"$p1_precision\", \"@p2\": \"$p2_precision\"}"$'\n'
    output+="{\"id\": \"$current_id\", \"actual_summary\": \"$summary\", \"expected_summary\": \"$expected_summary\" , \"expected_link_1\": \"$expected_link_1\"  ,  \"actual_link_1\": \"$link_1\", \"expected_link_2\": \"$expected_link_2\" ,  \"actual_link_2\": \"$link_2\" , \"summary_p\": \"$summary_precision\" ,  \"@p0\": \"$p0_precision\", \"@p1\": \"$p1_precision\", \"@p2\": \"$p2_precision\"}"$'\n'


      
  fi
done


format_output
