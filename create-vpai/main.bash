#!/bin/bash
set -eu

main() {
    local config_file_data=$(mktemp)
    local creator_path=$(mktemp "$TMPDIR/XXXXXX-vpai-creator.mjs")

    if [ -z "${OUTPUT:-}" ]; then
        die "no output is specified"
    fi

    create_config_file "$config_file_data"
    printf "Using the following config file\n"
    cat "$config_file_data"

    printf "downloading creator...\n"
    curl -sL "https://github.com/anatawa12/VPMPackageAutoInstaller/releases/latest/download/creator.mjs" > "$creator_path"

    printf "running creator...\n"
    node "$creator_path" "$config_file_data" "$OUTPUT"

    rm "$config_file_data"
    rm "$creator_path"
}

create_config_file() {
    local RESULT_FILE="$1"

    local USE_STRUCTURED=$(test -n "${PACKAGES:-}" && echo 1 || echo 0)
    local USE_CONFIG_FILE=$(test -n "${CONFIG_FILE:-}" && echo 1 || echo 0)
    local USE_CONFIG_JSON=$(test -n "${CONFIG_JSON:-}" && echo 1 || echo 0)

    # validation
    case "$USE_STRUCTURED$USE_CONFIG_FILE$USE_CONFIG_JSON" in
        "000")
            die "None of packages, config-file, or config-json are not specified"
            ;;
        "100" | "010" | "001")
            # no problems
            ;;
        *)
            die "Multiple package information sources are specified"
            ;;
    esac

    if [ "$USE_STRUCTURED" == 0 ]; then
        if [ -z "$REPOSITORIES" ]; then
            die "Either config-file or config-json is specified but repositories is also specified."
        fi
    fi

    # create config file
    if [ "$USE_STRUCTURED" == 1 ]; then
        echo "{}" >> "$RESULT_FILE"
        printf '%s\n' "${REPOSITORIES:-}" | while IFS= read -r url; do
            if [ -n "${url:-}" ]; then
                inplace "$RESULT_FILE" jq '.vpmRepositories += [$URL]' --arg URL "$url"
            fi
        done

        printf '%s\n' "$PACKAGES" | while IFS= read -r pkg; do
            if [ -n "${pkg:-}" ]; then
                local pkg_name
                local pkg_range
                case "$pkg" in
                    *@*)
                        pkg_name="${pkg%@*}"
                        pkg_range="${pkg##*@}"

                        ;;
                    *)
                        pkg_name="$pkg"
                        pkg_range="*"

                        ;;
                esac

                inplace "$RESULT_FILE" jq '.vpmDependencies[$PKG]=$RANGE' --arg PKG "$pkg_name" --arg RANGE "$pkg_range"
            fi
        done
    elif [ "$USE_CONFIG_FILE" == 1 ]; then
        cat "$CONFIG_FILE" > "$RESULT_FILE"
    elif [ "$USE_CONFIG_JSON" == 1 ]; then
        echo "$CONFIG_JSON" > "$RESULT_FILE"
    fi
}

. "$(dirname $0)/../common/utils.bash"

main
