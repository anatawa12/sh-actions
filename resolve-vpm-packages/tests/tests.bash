source ./common/tests.bash

check_package() {
    test -d "./resolve-vpm-packages/tests/$TEST_NAME/project/Packages/$1"
    test -f "./resolve-vpm-packages/tests/$TEST_NAME/project/Packages/$1/package.json"
}
