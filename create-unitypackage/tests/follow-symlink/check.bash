#!/bin/bash

set -eu

source ./create-unitypackage/tests/tests.bash

: ${PREFIX:=create-unitypackage/tests/follow-symlink/contents}
CONTENTS="create-unitypackage/tests/follow-symlink/contents"

check_file_asset   "2323c8d8e5fb402b9fdbc30bb0235b4c" "test.cs"
check_folder_asset "395c349e3ab442ffb639bbe5be174bb4" "folder"
check_file_asset   "42962cc3730a4cd286f19db25b321d98" "folder/content.txt"
