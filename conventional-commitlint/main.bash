#!/bin/bash
set -eu

infer_current_target() {
    local arch suffix target

    case "$(uname -m)" in
        arm64 | aarch64 | armv8? ) arch="aarch64" ;;
        i?86 | x86_64 )            arch="x86_64" ;;
        * ) die "Error: unknown arch: $(uname -m)";
    esac

    case "`uname`" in
        CYGWIN* | MINGW* ) suffix=pc-windows-msvc ;;
        Darwin* )          suffix=apple-darwin ;;
        Linux* )           suffix=unknown-linux-musl ;;
        * ) die "Error: unknown platform: $(uname)";
    esac

    target="$arch-$suffix"

    if [ "$target" = "aarch64-pc-windows-msvc" ]; then
        target="x86_64-pc-windows-msvc"
    fi

    echo $target
}

executable_suffix() {
    case "$1" in
        *-windows-* ) echo '.exe' ;;
        * ) ;;
    esac
}

install() {
    VERSION="${1:-"$(die "version not specified")"}"
    TARGET="${2:-"$(die "target not specified")"}"
    # compute
    SUFFIX="$(executable_suffix "$TARGET")"

    OUTPUT_PATH="$(cd "$(dirname "$0")" && pwd)"

    OUTPUT_FILE="$OUTPUT_PATH/conventional-commitlint$SUFFIX"

    if [ "$VERSION" = latest ]; then
        URL="https://github.com/anatawa12/conventional-commitlint/releases/latest/download/$TARGET-conventional-commitlint$SUFFIX"
    else
        URL="https://github.com/anatawa12/conventional-commitlint/releases/download/$VERSION/$TARGET-conventional-commitlint$SUFFIX"
    fi

    echo "installing conventional-commitlint version $VERSION from $URL" >&2;

    # do download
    curl -sfL "$URL" > "$OUTPUT_FILE"
    chmod +x "$OUTPUT_FILE"
}

may_init_git() {
    REPOSITORY="${1:-""}"
    HEAD="${2:-""}"
    if git rev-parse --git-dir >/dev/null 2>&1; then
        echo "skipping initializing repository for $REPOSITORY" >&2;
    else
        REPOSITORY="${REPOSITORY:-"$(die "git repo not found")"}"
        echo "initializing repository for $REPOSITORY" >&2;
        git init --quiet
        git remote add origin "$REPOSITORY"
        git config remote.origin.promisor true
        git config remote.origin.partialclonefilter tree:0
        git fetch origin "$HEAD"
    fi
}

main() {
    # parameter check
    VERSION="${1:-latest}"
    TARGET="${2:-"$(infer_current_target)"}"
    WORKSPACE="${3:-"$(pwd)"}"
    REPOSITORY="${4:-""}"
    HEAD="${5:-"$(die "head not specified")"}"
    BASE="${6:-"$(die "base not specified")"}"

    install "$VERSION" "$TARGET"

    mkdir -p "$WORKSPACE"
    cd "$WORKSPACE"
    may_init_git "$REPOSITORY" "$HEAD"
    echo "running check for $HEAD .. $BASE"
    "$OUTPUT_FILE" check "origin/$HEAD" "origin/$BASE"
}

. "$(dirname $0)/../common/utils.bash"

# execute
main "$@"
