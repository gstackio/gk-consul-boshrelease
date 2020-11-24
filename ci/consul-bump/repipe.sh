#!/usr/bin/env bash

set -eo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

pushd "${SCRIPT_DIR}" > /dev/null

(
    set -x
    fly --target="gk-plat-devs" \
        set-pipeline --pipeline="consul-bump" \
        --config="consul-bump-pipeline.yml" \
        --load-vars-from="../config.yml"
)

popd > /dev/null
