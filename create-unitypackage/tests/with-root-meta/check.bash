#!/bin/bash

set -eu

source ./create-unitypackage/tests/tests.bash

: ${PREFIX:=create-unitypackage/tests/simple/contents}
CONTENTS="create-unitypackage/tests/simple/contents"

check_file_asset   "2323c8d8e5fb402b9fdbc30bb0235b4c" "test.cs"
check_folder_asset "395c349e3ab442ffb639bbe5be174bb4" "folder"
check_root_folder_asset "a1ec0f532ac842168c8b14bb7f772974"
