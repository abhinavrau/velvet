# shellcheck disable=SC2148
format_output() {
    if [ "$format" = "table" ]; then
        echo "$output" | ./jtbl 
    elif [ "$format" == "csv" ]; then
        echo "$output" | ./jtbl -c
    elif [ "$format" == "jsonl" ]; then
        echo "$output" 
    fi 
}