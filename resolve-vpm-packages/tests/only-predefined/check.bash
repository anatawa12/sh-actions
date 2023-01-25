#!/bin/bash

set -eu

. "./resolve-vpm-packages/tests/tests.bash"

check_package "com.vrchat.clientsim"
check_package "com.vrchat.worlds"
check_package "com.vrchat.base"
check_package "com.vrchat.core.vpm-resolver"
