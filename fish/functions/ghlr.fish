function ghlr --description 'gh cli - monitor or view last workflow run'
    set -l run_id (gh run list --json databaseId -q '.[0].databaseId')
    set -l watch_msg (gh run watch $run_id 2>&1)

    if string match -q '*already*' $watch_msg
        echo "Run $run_id has completed."
        gh run view $run_id
    else
        gh run watch $run_id
    end
end
