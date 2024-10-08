# sets TEMPDIR global variable
create_temp_dir() {
    TEMPDIR="$(mktemp -d "${TMPDIR:-/tmp}/${1:-temp}.XXXXXX")"
    debugf "temp: $TEMPDIR"
    #trap 'rm -rf $TEMPDIR' EXIT
}

#region logging
# echo to stderr and exit
die () {
    echo "$@" >&2
    exit 1
}

printf_prefix() {
    local PREFIX="$1"
    local FMT="$2"
    shift
    shift
    printf "$PREFIX$FMT\n" "$@"
}

if [ "${GITHUB_ACTIONS:-}" = "true" ]; then
warnf () { printf_prefix "::warning::" "$@" >&2 ;}
debugf () { printf_prefix "::debug::" "$@" ;}
else
warnf () { printf_prefix "w: " "$@" >&2 ;}
debugf () { :; }
fi

#endregion

#region path utils

relativize_path() {
    local COMPONENTS JOINED
    # first, remove `[^/]+/../`
    IFS="/" read -r -a COMPONENTS <<< "$1"


    for index in "${!COMPONENTS[@]}" ; do
        if [ "${COMPONENTS[index]}" = '.' ]; then
            COMPONENTS[index]=''
        elif [ "${COMPONENTS[index]}" = '..' ]; then
            # path/something////../path
            # -> path/////../path
            for prev in `seq 0 $(($index - 1)) | tac`; do
                if [ -n "${COMPONENTS[$prev]}" ]; then
                    COMPONENTS[$prev]=''
                    break
                fi
            done
            COMPONENTS[index]=''
        fi
    done
    JOINED="$(IFS="/"; echo "${COMPONENTS[*]}")"

    # remove multiple / and leading/heading /
    echo "$JOINED" | sed -e 's#//*#/#g' -e 's#^/##' -e 's#/$##'
}

#endregion

inplace() {
    local INOUT="$1"
    local TMP="$(mktemp)"
    shift
    "$@" <"$INOUT" >"$TMP"
    mv "$TMP" "$INOUT"
}

#region polyfills
# tac is not posix command. use tail -r instead
which tac > /dev/null || tac() { tail -r "$@"; }
#endregion
