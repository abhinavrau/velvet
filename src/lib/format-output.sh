# shellcheck disable=SC2148
format_output() {
    if [ "$format" = "table" ]; then
        echo "$output" | ./jtbl
    elif [ "$format" == "csv" ]; then
       format_json_to_csv "$output"
    elif [ "$format" == "jsonl" ]; then
        echo "$output" 
    elif [ "$format" == "raw" ]; then
        echo "$command_output" 
    fi 
}