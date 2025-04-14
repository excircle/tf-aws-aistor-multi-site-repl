#!/bin/bash

function pre-reqs() {
    # Check if 'gh' CLI tool is installed on MacOS
    GH_CLI_TOOL=$(command -v gh)
    if [ -z "$GH_CLI_TOOL" ]; then
        echo "[ERROR]: gh CLI tool could not be found. Please install using 'brew install gh'."
    else 
        echo "[SUCCESS]: gh CLI tool is installed at $GH_CLI_TOOL"
    fi

    # Check if 'jq' CLI tool is installed on MacOS
    JQ_CLI_TOOL=$(command -v jq)
    if [ -z "$JQ_CLI_TOOL" ]; then
        echo "[ERROR]: jq CLI tool could not be found. Please install using 'brew install jq'."
    else 
        echo "[SUCCESS]: jq CLI tool is installed at $JQ_CLI_TOOL"
    fi

    # Check if target.json file exists
    TARGET_JSON_FILE="target.json"
    if [ ! -f "$TARGET_JSON_FILE" ]; then
        echo -e "[WARN]: $TARGET_JSON_FILE file does not exist. Creating..."
        sleep 1
        cp ./example-target.json "$TARGET_JSON_FILE"
        if [ $? -ne 0 ]; then
            echo "[ERROR]: Failed to create $TARGET_JSON_FILE file. Please check permissions."
            exit 1
        else 
            echo "[SUCCESS]: $TARGET_JSON_FILE file created successfully."
            echo "[WARN]: PLEASE update $TARGET_JSON_FILE with correct values and run setup.sh again."
        fi
    else 
        echo "[SUCCESS]: $TARGET_JSON_FILE file exists."
    fi
}

function write-to-github() {
    # Check if default values have been changed
    EXAMPLE_SHA=$(sha1sum example-target.json | awk '{print $1}')
    TARGET_SHA=$(sha1sum target.json | awk '{print $1}')
    if [ "$EXAMPLE_SHA" = "$TARGET_SHA" ]; then
        echo "[ERROR]: Please update the target.json file with correct values before running this script."
        exit 1
    fi

    # Check if the user is authenticated with GitHub CLI
    GH_AUTH=$(gh auth status 2>&1)
    if [[ $GH_AUTH == *"not logged in"* ]]; then
        echo "[ERROR]: You are not authenticated with GitHub CLI. Please run 'gh auth login' to authenticate."
        exit 1
    else
        echo "[SUCCESS]: You are authenticated with GitHub CLI."
    fi

    # Write AWS_ACCESS_KEY_ID repository secret
    AWS_ACCESS_KEY_ID=$(jq -r '.AWS_ACCESS_KEY_ID' target.json)
    if [ -z "$AWS_ACCESS_KEY_ID" ]; then
        echo "[ERROR]: AWS_ACCESS_KEY_ID is not set in target.json."
        exit 1
    else
        gh secret set AWS_ACCESS_KEY_ID -b "$AWS_ACCESS_KEY_ID"
        if [ $? -ne 0 ]; then
            echo "[ERROR]: Failed to set AWS_ACCESS_KEY_ID secret. Please check permissions."
            exit 1
        else 
            echo "[SUCCESS]: AWS_ACCESS_KEY_ID secret set successfully."
        fi
    fi

    # Write AWS_SECRET_ACCESS_KEY repository secret
    AWS_SECRET_ACCESS_KEY=$(jq -r '.AWS_SECRET_ACCESS_KEY' target.json)
    if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
        echo "[ERROR]: AWS_SECRET_ACCESS_KEY is not set in target.json."
        exit 1
    else
        gh secret set AWS_SECRET_ACCESS_KEY -b "$AWS_SECRET_ACCESS_KEY"
        if [ $? -ne 0 ]; then
            echo "[ERROR]: Failed to set AWS_SECRET_ACCESS_KEY secret. Please check permissions."
            exit 1
        else 
            echo "[SUCCESS]: AWS_SECRET_ACCESS_KEY secret set successfully."
        fi
    fi

    # Write PA_TOKEN repository secret
    PA_TOKEN=$(jq -r '.PA_TOKEN' target.json)
    if [ -z "$PA_TOKEN" ]; then
        echo "[ERROR]: PA_TOKEN is not set in target.json."
        exit 1
    else
        gh secret set PA_TOKEN -b "$PA_TOKEN"
        if [ $? -ne 0 ]; then
            echo "[ERROR]: Failed to set PA_TOKEN secret. Please check permissions."
            exit 1
        else 
            echo "[SUCCESS]: PA_TOKEN secret set successfully."
        fi
    fi

    # Write PRIVATE_SSHKEY repository secret
    PRIVATE_SSHKEY_PATH=$(jq -r '.PRIVATE_SSHKEY' target.json)
    if [ -z "$PRIVATE_SSHKEY_PATH" ]; then
        echo "[ERROR]: PRIVATE_SSHKEY path is not set in target.json."
        exit 1
    fi

    if [ ! -f "$PRIVATE_SSHKEY_PATH" ]; then
        echo "[ERROR]: PRIVATE_SSHKEY file not found at $PRIVATE_SSHKEY_PATH."
        exit 1
    fi

    # Base64 encode the private SSH key file
    PRIVATE_SSHKEY_ENCODED=$(base64 -i "$PRIVATE_SSHKEY_PATH")
    if [ $? -ne 0 ]; then
        echo "[ERROR]: Failed to base64 encode PRIVATE_SSHKEY file."
        exit 1
    fi

    gh secret set PRIVATE_SSHKEY -b "$PRIVATE_SSHKEY_ENCODED"
    if [ $? -ne 0 ]; then
        echo "[ERROR]: Failed to set PRIVATE_SSHKEY secret. Please check permissions."
        exit 1
    else 
        echo "[SUCCESS]: PRIVATE_SSHKEY secret set successfully."
    fi

    # Write PUBLIC_SSHKEY repository secret
    PUBLIC_SSHKEY_PATH=$(jq -r '.PUBLIC_SSHKEY' target.json)
    if [ -z "$PUBLIC_SSHKEY_PATH" ]; then
        echo "[ERROR]: PUBLIC_SSHKEY path is not set in target.json."
        exit 1
    fi

    if [ ! -f "$PUBLIC_SSHKEY_PATH" ]; then
        echo "[ERROR]: PUBLIC_SSHKEY file not found at $PUBLIC_SSHKEY_PATH."
        exit 1
    fi

    # Base64 encode the public SSH key file
    PUBLIC_SSHKEY_ENCODED=$(base64 -i "$PUBLIC_SSHKEY_PATH")
    if [ $? -ne 0 ]; then
        echo "[ERROR]: Failed to base64 encode PUBLIC_SSHKEY file."
        exit 1
    fi

    gh secret set PUBLIC_SSHKEY -b "$PUBLIC_SSHKEY_ENCODED"
    if [ $? -ne 0 ]; then
        echo "[ERROR]: Failed to set PUBLIC_SSHKEY secret. Please check permissions."
        exit 1
    else 
        echo "[SUCCESS]: PUBLIC_SSHKEY secret set successfully."
    fi

    # Write MINIO_LICENSE repository secret
    MINIO_LICENSE=$(jq -r '.MINIO_LICENSE' target.json)
    if [ -z "$MINIO_LICENSE" ]; then
        echo "[ERROR]: MINIO_LICENSE path is not set in target.json."
        exit 1
    else
        gh secret set MINIO_LICENSE -b "$MINIO_LICENSE"
        if [ $? -ne 0 ]; then
            echo "[ERROR]: Failed to set MINIO_LICENSE secret. Please check permissions."
            exit 1
        else 
            echo "[SUCCESS]: MINIO_LICENSE secret set successfully."
        fi
    fi





}

function main() {
    pre-reqs
    write-to-github
}

main
