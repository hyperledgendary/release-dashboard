#!/usr/bin/env bash
#
# SPDX-License-Identifier: Apache-2.0
#

: "${GITHUB_WORKSPACE:?}"

for repo in fabric fabric-ca fabric-chaincode-java fabric-chaincode-node fabric-contract-api-go fabric-gateway-java fabric-sdk-go fabric-sdk-java fabric-sdk-node
do
  echo "Repo: $repo"
  curl --silent "https://api.github.com/repos/hyperledger/${repo}/releases/latest" | jq '{ version: .tag_name, published: .published_at, url: .html_url, days_since: (((now - ( .published_at | fromdateiso8601? )) / 86400) | floor ) }' > ${GITHUB_WORKSPACE}/docs/_data/repos/${repo}.json
  cat ${GITHUB_WORKSPACE}/docs/_data/repos/${repo}.json
done
