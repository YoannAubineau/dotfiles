#!/usr/bin/env bash
# Usage: set_permissions_for_shared_directory.sh <group> <target>

set -x -e

GROUP=$1
TARGET=$2

# Set and insure group ownership
chgrp -R $GROUP $TARGET
find $TARGET -type d -exec chmod g+s {} \;

# Set and insure permissions
chmod -R ug=rwX,o=X $TARGET
setfacl -Rm 'd:g::rwx,d:o::--x' $TARGET

