#!/usr/bin/env bash

set -ueo pipefail

function configure() {
    CONSUL_VERSION=1.18.1
    CONSUL_SHA256=5faa9cc3f2832e3ae454a3ec2dbc6799179d14e1e09463f220bb906c590f4b05
}

function main() {
    setup
    configure

    mkdir -p "${RELEASE_DIR}/tmp/blobs"
    pushd "${RELEASE_DIR}/tmp/blobs" > /dev/null

        local blob_file
        set -x

        blob_file="consul_${CONSUL_VERSION}_linux_amd64.zip"
        add_blob "consul" "${blob_file}" "consul/${blob_file}"

    popd > /dev/null
}

function setup() {
    RELEASE_DIR=$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd)
}

function add_blob() {
    local blob_name=$1
    local blob_file=$2
    local blob_path=$3

    if [[ ! -f "${blob_file}" ]]; then
        "download_${blob_name}" "${blob_file}"
    fi
    bosh add-blob --dir="${RELEASE_DIR}" "${blob_file}" "${blob_path}"
}

function download_consul() {
    local output_file=$1

    curl -fsSL "https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip" \
        -o "${output_file}"
    shasum -a 256 --check <<< "${CONSUL_SHA256}  ${output_file}"
}

main "$@"
