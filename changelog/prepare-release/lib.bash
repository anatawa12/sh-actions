
# substitute unreleased release note from stdin
get_unreleased_release_note() {
    sed -e "1,/^## /d" -e '/^## /,$d' -e '/^\[Unreleased\]:/,$d'
}

prepare_changelog() {
    local temp INPUT
    INPUT="$1"
    temp="$(mktemp)"

    cp "$INPUT" "$temp"

    sed -e "/^###/{
    N
    /###.*\n$/d
    }" <"$temp" \
      | perl -pe 's/(?<= )`#(\d+)`(?= |$)/[`#$1`]($ENV{"REPO_URL"}\/pull\/$1)/g' \
      >"$INPUT"

    rm "$temp"
}

update_changelog() {
    local INPUT VERSION DATE LAST_VERSION temp

    INPUT="$1"
    VERSION="$2"
    DATE="$3"

    LAST_VERSION="$(grep '\[Unreleased\]: ' -A1 < "$INPUT" | tail -1 | sed -E 's/^\[([0-9a-zA-Z.-]*)]: .*$/\1/')"

    if [ "$LAST_VERSION" = "Unreleased" ]; then
        update_changelog_first "$INPUT" "$VERSION" "$DATE"
    else
        update_changelog_continuous "$INPUT" "$VERSION" "$DATE" "$LAST_VERSION"
    fi
}

update_changelog_first() {
    local INPUT VERSION DATE temp

    INPUT="$1"
    VERSION="$2"
    DATE="$3"

    temp="$(mktemp)"
cat <"$INPUT" >"$temp"
sed -e "/#* \\[Unreleased]/{
a\\
### Added\\
\\
### Changed\\
\\
### Deprecated\\
\\
### Removed\\
\\
### Fixed\\
\\
### Security\\
\\
## [$VERSION] - $DATE
}
/^\\[Unreleased]/ {
a\\
[Unreleased]: $REPO_URL/compare/$TAG_PREFIX$VERSION...HEAD\\
[$VERSION]: $REPO_URL/releases/tag/$TAG_PREFIX$VERSION
D
}
" <"$temp" >"$INPUT"

    rm "$temp"
}

update_changelog_continuous() {
    local INPUT VERSION DATE LAST_VERSION temp

    INPUT="$1"
    VERSION="$2"
    DATE="$3"
    LAST_VERSION="$4"

    temp="$(mktemp)"
cat <"$INPUT" >"$temp"
sed -e "/#* \\[Unreleased]/{
a\\
### Added\\
\\
### Changed\\
\\
### Deprecated\\
\\
### Removed\\
\\
### Fixed\\
\\
### Security\\
\\
## [$VERSION] - $DATE
}
/^\\[Unreleased]/ {
a\\
[Unreleased]: $REPO_URL/compare/$TAG_PREFIX$VERSION...HEAD\\
[$VERSION]: $REPO_URL/compare/$TAG_PREFIX$LAST_VERSION...$TAG_PREFIX$VERSION
D
}
" <"$temp" >"$INPUT"

    rm "$temp"
}
