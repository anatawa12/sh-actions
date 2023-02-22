source ./common/tests.bash

check_file_asset() {
    check_asset_meta "$1" "$2"
    check_asset_content "$1" "$2"
    check_asset_path "$1" "$2"
}

check_folder_asset() {
    check_asset_meta "$1" "$2"
    test ! -e unitypackage-contents/"$1"/asset || die "asset content of folder asset $2 (guid: $1) exists"
    check_asset_path "$1" "$2"
}

check_root_folder_asset() {
    check_root_asset_meta "$1"
    test ! -e unitypackage-contents/"$1"/asset || die "asset content of root folder asset (guid: $1) exists"
    check_root_asset_path "$1"
}

check_asset_meta() {
    die_if_symlink unitypackage-contents/"$1"/asset.meta
    die_if_differ unitypackage-contents/"$1"/asset.meta "$CONTENTS/$2.meta" "asset content of $2 (guid: $1) differ"
}

check_asset_content() {
    die_if_symlink unitypackage-contents/"$1"/asset
    die_if_differ unitypackage-contents/"$1"/asset "$CONTENTS/$2" "asset content of $2 (guid: $1) differ"
}

check_asset_path() {
    printf '%s/%s' "$PREFIX" "$2" > pathbuf
    die_if_differ unitypackage-contents/"$1"/pathname pathbuf "pathname of $2 (guid: $1) differ"
}

check_root_asset_meta() {
    die_if_symlink unitypackage-contents/"$1"/asset.meta
    die_if_differ unitypackage-contents/"$1"/asset.meta "$CONTENTS.meta" "asset content of root asset (guid: $1) differ"
}

check_root_asset_path() {
    printf '%s' "$PREFIX" > pathbuf
    die_if_differ unitypackage-contents/"$1"/pathname pathbuf "pathname of root asset (guid: $1) differ"
}

die_if_differ() {
    diff "$1" "$2" >&2 || ( shift; shift; die "$@" )
}

die_if_symlink() {
    test -L "$1" && ( shift; die "$@" )
}
