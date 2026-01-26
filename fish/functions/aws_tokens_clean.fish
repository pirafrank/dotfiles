function aws_tokens_clean --description 'unset AWS session tokens'
    # https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/
    set -e AWS_ACCESS_KEY_ID
    set -e AWS_SECRET_ACCESS_KEY
    set -e AWS_SESSION_TOKEN
    echo "Variables unset"
end
