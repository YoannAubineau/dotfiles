#!/usr/bin/env bash
# Usage: set_permissions_for_shared_directory.sh <group> <target>

set -x -e

GROUP=$1
TARGET=$2

# Fix permissions
chgrp -R $GROUP $TARGET
chmod -R ug=rwX,o=X $TARGET
find $TARGET -type d -exec chmod g+s {} \;

# Force more permissive umask
setfacl -Rm d:g::rwx,d:o::--x $TARGET

