#!/bin/bash
set -eu

infer_current_target() {
    local arch suffix

    case "$(uname -m)" in
        arm64 | aarch64 | armv8? ) arch="aarch64" ;;
        i?86 | x86_64 )            arch="x86_64" ;;
        * ) echo "Error: unknown arch: $(uname -m)" >&2; exit 1;
    esac

    case "`uname`" in
        CYGWIN* | MINGW* ) suffix=pc-windows-msvc ;;
        Darwin* )          suffix=apple-darwin ;;
        Linux* )           suffix=unknown-linux-musl ;;
        * ) echo "Error: unknown platform: $(uname)" >&2; exit 1;
    esac

    echo "$arch-$suffix"
}

executable_suffix() {
    case "$1" in
        *-windows-* ) echo '.exe' ;;
        * ) ;;
    esac
}

main() {
    # parameter check
    VERSION="${1:-latest}"
    TARGET="${2:-"$(infer_current_target)"}"
    OVERRIDE="${3:-"true"}"

    # compute
    SUFFIX="$(executable_suffix "$TARGET")"

    OUTPUT_PATH="$(dirname $0)/path"

    OUTPUT_FILE="$OUTPUT_PATH/vrc-get$SUFFIX"

    if [ "$VERSION" = latest ]; then
        URL="https://github.com/anatawa12/vrc-get/releases/latest/download/$TARGET-vrc-get$SUFFIX"
    else
        URL="https://github.com/anatawa12/vrc-get/releases/download/$VERSION/$TARGET-vrc-get$SUFFIX"
    fi

    if [ "$TARGET" = aarch64-pc-windows-msvc ]; then
        # aarch64-pc-windows-msvc is not supported
        TARGET="x86_64-pc-windows-msvc"
    fi

    if ! [ "$OVERRIDE" = true ] && command vrc-get --version >/dev/null 2>&1; then
        echo "vrc-get is already installed" >&2;
        exit 0
    fi

    echo "installing vrc-get version $VERSION from $URL" >&2;

    # do download
    mkdir -p "$OUTPUT_PATH"
    curl -sfL "$URL" > "$OUTPUT_FILE"
    chmod +x "$OUTPUT_FILE"

    # add to path
    echo "$OUTPUT_PATH" >> $GITHUB_PATH

    # print version
    "$OUTPUT_FILE" --version
}

read_guid() {
    grep '^guid: ' "$1" | head -1 | sed 's#^guid: *##'
}

. "$(dirname $0)/../common/utils.bash"

# execute
main "$@"
