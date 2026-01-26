function rat --description 'RAT: Refresh AWS Tokens with MFA'
    # https://aws.amazon.com/premiumsupport/knowledge-center/authenticate-mfa-cli/

    echo "RAT: Refresh AWS Tokens"

    if test (count $argv) -eq 0
        echo "No OTP code provided. Exiting."
        return 1
    end

    aws_tokens_clean
    set -l mfa_arn (cat ~/.config/aws/$USER/mfa)
    set -l res (aws sts get-session-token --serial-number $mfa_arn --token-code $argv[1] --duration-seconds 86400)

    if test $status -eq 0
        # Linux and WSL
        set -gx AWS_ACCESS_KEY_ID (printf '%s' $res | jq -r '.Credentials.AccessKeyId')
        set -gx AWS_SECRET_ACCESS_KEY (printf '%s' $res | jq -r '.Credentials.SecretAccessKey')
        set -gx AWS_SESSION_TOKEN (printf '%s' $res | jq -r '.Credentials.SessionToken')
        echo "Tokens refreshed"
    end
end
