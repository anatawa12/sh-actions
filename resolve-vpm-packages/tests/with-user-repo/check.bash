#!/bin/bash

set -eu

. "./resolve-vpm-packages/tests/tests.bash"

check_package "com.vrchat.core.vpm-resolver"
check_package "com.vrchat.base"
check_package "com.vrchat.avatars"
check_package "nadena.dev.modular-avatar"
check_package "com.anatawa12.animator-controller-as-a-code"
check_package "com.anatawa12.custom-localization-for-editor-extension"
