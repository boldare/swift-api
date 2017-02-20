#!/bin/bash

set -e

function exitIfLastStatusWasUnsuccessful() {
  STATUS=${PIPESTATUS[0]}
  if [ $STATUS -ne 0 ]; then
    exit $STATUS
  fi
}
