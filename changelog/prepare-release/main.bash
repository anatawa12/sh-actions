#!/bin/bash
set -eu

main() {
    # first, normalize PRERELEASE
    if [ "$PRERELEASE" != true ]; then
        PRERELEASE=false
    fi

    if [ ! -w "$PRERELEASE_PATH" ]; then
        NO_PRERELEASE=true
    else
        NO_PRERELEASE=false
    fi

    if ! $PRERELEASE || $NO_PRERELEASE ; then
        # shellcheck disable=SC2153
        main_changelog_file_path="$RELEASE_PATH"
    else
        main_changelog_file_path="$PRERELEASE_PATH"
    fi

    # first, remove empty section of changelog
    ! $PRERELEASE && prepare_changelog "$RELEASE_PATH"
    ! $NO_PRERELEASE && prepare_changelog "$PRERELEASE_PATH"

    # then, get release notes for unreleased
    unreleased_release_note_path=$(mktemp)
    <"$main_changelog_file_path" \
        prepare_changelog_core \
        | get_unreleased_release_note \
        >"$unreleased_release_note_path"

    # after that, make unreleased -> released
    if [ -z "$RELEASE_DATE" ]; then
        RELEASE_DATE="$(date +%Y-%m-%d)"
    fi
    # for release, update normal
    ! $PRERELEASE && update_changelog "$RELEASE_PATH" "$VERSION_NAME" "$RELEASE_DATE"
    # for both prerelease and release, update -SNAPSHOTS
    ! $NO_PRERELEASE && update_changelog "$PRERELEASE_PATH" "$VERSION_NAME" "$RELEASE_DATE"

    # create release note for GitHub release page
    release_note_path=$(mktemp)
    {
        if $PRERELEASE; then
            test -n "$PRERELEASE_NOTE_HEADING" && ( echo "$PRERELEASE_NOTE_HEADING"; echo "" )
        else
            test -n "$RELEASE_NOTE_HEADING" && ( echo "$RELEASE_NOTE_HEADING"; echo "" )
        fi
        cat "$unreleased_release_note_path"
    } >>"$release_note_path"

    echo "release-note=$release_note_path" >> "$GITHUB_OUTPUT"
}

read_guid() {
    grep '^guid: ' "$1" | head -1 | sed 's#^guid: *##'
}

. "$(dirname -- "$0")/lib.bash"
. "$(dirname -- "$0")/../../common/utils.bash"

# execute
main "$@"
