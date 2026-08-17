#!/bin/bash
set -eu

expected='MUTABLE_ORIGIN_CANARY_7e39d833-0738-424d-9803-bc33fd03569a'
temporary_directory="$(mktemp -d)"
trap 'rm -rf "$temporary_directory"' EXIT

git -C "$temporary_directory" init -q

timeout 15 git -C "$temporary_directory" fetch --depth=1 -q \
  http://git@192.168.0.1:8080/PinkDraconian/test2 \
  test-canary-origin-change-16026173627626907298

observed="$(
  git -C "$temporary_directory" \
    show FETCH_HEAD:evidence/mutable-origin-submit-canary.txt
)"

if [ "$observed" = "$expected" ]; then
  echo NATURAL_TEST_HOOK_CANARY_MATCH
else
  echo NATURAL_TEST_HOOK_CANARY_MISMATCH
fi
