#!/bin/bash
set -eu

main() {
    # parameter check
    test -z "${1:-}" && die "no OUTPUT"
    test -z "${2:-}" && die "no ROOT"
    OUTPUT="$1"
    ROOT="$2"
    PREFIX="${3:-"$(relativize_path "$ROOT")"}"

    # prepare other variables
    create_temp_dir create-unitypackage

    local ROOT_META meta_path TAR_ROOT file_path GUID

    TAR_ROOT="$TEMPDIR/tar_root"
    mkdir "$TAR_ROOT"

  pushd "$ROOT" > /dev/null
    # find root meta file. maybe used later. ROOT_META is empty if not found.
    ROOT_META="../$(basename "$ROOT").meta"
    test ! -f "$ROOT_META" && ROOT_META=""

    # find all files in the directory
    find -L "." -name "*.meta" | sed 's#^\./##' | while IFS="" read -r meta_path; do
        file_path="${meta_path%%.meta}"
        GUID="$(read_guid "$meta_path")"

        debugf '%s for %s (guid: %s)' "$meta_path" "$file_path" "$GUID"

        if [ -z "$GUID" ]; then
            warnf "GUID for %s not found!" "$meta_path"
            continue
        fi
        if [ ! -e "$file_path" ]; then
            warnf "Asset file/directory for %s not found!" $meta_path
            continue
        fi

        mkdir "$TAR_ROOT/$GUID"
        cp -L "$meta_path" "$TAR_ROOT/$GUID/asset.meta"
        # copy asset only if the asset is file
        test -f "$file_path" && cp -L "$file_path" "$TAR_ROOT/$GUID/asset"
        printf "%s/%s" "$PREFIX" "$file_path" > "$TAR_ROOT/$GUID/pathname"
    done

    # if exists, add meta file for package root
    if [ -n "$ROOT_META" ]; then
        debugf "%s for root folder found\n" "$ROOT_META"
        GUID="$(read_guid "$ROOT_META")"

        if [ -z "$GUID" ]; then
            warnf "GUID for %s not found!" "$ROOT_META"
        else
            mkdir "$TAR_ROOT/$GUID"
            cp -L "$ROOT_META" "$TAR_ROOT/$GUID/asset.meta"
            printf "%s" "$PREFIX" > "$TAR_ROOT/$GUID/pathname"
        fi
    fi

  popd > /dev/null

    # create unitypackage file with tar
    tar -czf "$OUTPUT" -C "$TAR_ROOT" '.'
}

read_guid() {
    grep '^guid: ' "$1" | head -1 | sed 's#^guid: *##'
}

. "$(dirname $0)/../common/utils.bash"

# execute
main "$@"
