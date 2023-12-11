# shellcheck disable=SC2148
call_palm_text_bison() {


    prompt="You will get two answers to a question, you should determine if they are semantically similar or not. 
    examples - answer_1: I was created by X. answer_2: X created me. output:same 
    answer_1:There are 52 days in a year. answer_2: A year is fairly long. output:different"
    full_payload=$prompt". Now answer answer_1: $summary,
        answer_2: $expected_summary
        output:"

    jsonPayload="   
    {
            \"instances\": [
                {
                    \"content\": \"${full_payload}\"
                }
            ],
            \"parameters\": {
                \"candidateCount\": 1,
                \"maxOutputTokens\": 1024,
                \"temperature\": 0.2
            }
    }"
    #echo "$jsonPayload"

    API_ENDPOINT="${TEXT_BISON_LOCATION_ID}-aiplatform.googleapis.com"
    MODEL_ID="text-bison"

    match_result=$(curl \
    -s \
    -X POST \
    -H "Authorization: Bearer $token" \
    -H "Content-Type: application/json" \
    "https://${API_ENDPOINT}/v1/projects/${TEXT_BISON_PROJECT_ID}/locations/${TEXT_BISON_LOCATION_ID}/publishers/google/models/${MODEL_ID}:predict" -d "$jsonPayload")
    error=$(echo "$match_result" | jq '.error.code' )
    if [ -z "$error" ]; then
        error_message=$(echo "$match_result" | jq '.error.message' )
        echo "Calling Vertex AI search failed. ErrorCode:$error ErrorMessage:$error_message"
        exit 1
    fi

    summary_match=$(echo "$match_result" | jq '.predictions[0].content' | sed 's/"//g' | xargs)
}
