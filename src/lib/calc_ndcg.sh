function calc_ndcg() {

    local link_1
    local link_2
    local expected_link_1
    local expected_link_2
    local relevance_scores
    local ideal_relevance_scores
    local dcg
    local idcg
    local ndcg

    link_1="$1"
    link_2="$2"
    expected_link_1="$3"
    expected_link_2="$4"


    # Define relevance and ideal relevance scores
    relevance_scores=()
    if [[ "$link_1" == "$expected_link_1" ]]; then
        relevance_scores+=(2)
    elif [[ "$link_1" == "$expected_link_2" ]]; then
        relevance_scores+=(1)
    else
        relevance_scores+=(0)
    fi

    if [[ "$link_2" == "$expected_link_1" ]]; then
        relevance_scores+=(1)
    elif [[ "$link_2" == "$expected_link_2" ]]; then
        relevance_scores+=(1)
    else
        relevance_scores+=(0)
    fi

    # Calculate and print NDCG for current row
    dcg=0
    for i in "${!relevance_scores[@]}"; do
        local relevance_score="${relevance_scores[$i]}"
        dcg=$(echo "scale=10; $dcg + $relevance_score / l($i + 2)" | bc -l)
    done
    #echo "dcg=$dcg"

    ideal_relevance_scores=()
    ideal_relevance_scores+=(2)
    ideal_relevance_scores+=(2)

    idcg=0
    for i in "${!ideal_relevance_scores[@]}"; do
        local ideal_relevance_score="${ideal_relevance_scores[$i]}"
        idcg=$(echo "scale=10; $idcg + $ideal_relevance_score / l($i + 2)" | bc -l)
    done
    #echo "idcg=$idcg"

    ndcg=0
    if (( $(echo "$idcg > 0" | bc -l) )); then
        ndcg=$(echo "scale=4; $dcg / $idcg" | bc -l)
    fi

    echo "$ndcg"
}