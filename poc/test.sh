#!/bin/bash
set -eu

{
  echo "PRIVATE_SUBMODULE_CANARY:"
  cat owned-private-submodule/test
} | tee test-results.txt
