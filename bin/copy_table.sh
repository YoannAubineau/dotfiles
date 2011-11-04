#!/usr/bin/env bash

set -x
set -e

TABLENAME=$1
TMP_FILEPATH=$(mktemp)
CPU_COUNT=$(grep -c processor /proc/cpuinfo)

pg_dump -h sql1.meilleursagents -U meilleursagents meilleursagents -t $TABLENAME -F custom > $TMP_FILEPATH
pg_restore -h localhost -U meilleursagents_dev -d meilleursagents_dev --clean --jobs=$CPU_COUNT $TMP_FILEPATH

rm $TMP_FILEPATH

