#!/usr/bin/env bash
#
# SPDX-License-Identifier: Apache-2.0
#

: "${GITHUB_WORKSPACE:?}"
: "${RUNNER_TEMP:?}"

mkdir -p "${RUNNER_TEMP:?}/releases"
for repo in fabric fabric-ca fabric-chaincode-java fabric-chaincode-node fabric-contract-api-go fabric-gateway-java fabric-gateway fabric-sdk-go fabric-sdk-java fabric-sdk-node
do
  echo "Repo: $repo"
  curl --silent "https://api.github.com/repos/hyperledger/${repo}/releases/latest" | jq --arg repo "${repo}" '{ name: $repo, version: .tag_name, published: .published_at, url: .html_url, days_since: (((now - ( .published_at | fromdateiso8601? )) / 86400) | floor ) }' > "${RUNNER_TEMP:?}/releases/${repo}.json"
  cat "${RUNNER_TEMP:?}/releases/${repo}.json"
done

jq -s . "${RUNNER_TEMP:?}/releases/"*.json > "${GITHUB_WORKSPACE}/docs/_data/releases.json"

jq '{ last_updated: now | todateiso8601 }' <<< "{}" > "${GITHUB_WORKSPACE}/docs/_data/meta.json"
