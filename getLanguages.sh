#!/bin/bash

# Replace with your organization name
ORG="octodemo"

# Check if ORG is null
if [ -z "$ORG" ]
then
    echo "ORG cannot be null"
    exit 1
fi

# Get list of repos
REPOS=$(gh api orgs/$ORG/repos --paginate | jq -r '.[] | .name')

# Start of JSON
echo "[" > languages-$ORG.json

# For each repo, get the languages
for REPO in $REPOS
do
    LANGUAGES=$(gh api repos/$ORG/$REPO/languages | jq -r 'keys[]')
    echo "{ \"repo\": \"$REPO\", \"languages\": [" >> languages-$ORG.json
    for LANGUAGE in $LANGUAGES
    do
        echo "\"$LANGUAGE\"," >> languages-$ORG.json
    done
    echo "] }," >> languages-$ORG.json
done

# End of JSON
echo "]" >> languages-$ORG.json
