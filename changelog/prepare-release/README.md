# Update Changelogs

Update `CHANGELOG.md` and `CHANGELOG-PRERELEASE.md` in format of [this template](../CHANGELOG-template.md).

## Usage

```yaml
name: ci

on:
  workflow_dispatch:
    inputs:
      version:
        required: true

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - id: action
        if: ${{ matrix.run }}
        uses: anatawa12/sh-actions/changelog/prepare-release@master
        with:
            version: ${{ inputs.version }}
            prerelease-note-prefix: |
                Version ${{ inputs.version }}
                ---

                **This is SNAPSHOT, not a stable release. make sure this may have many bugs.**
            release-note-prefix: |
                Version ${{ inputs.version }}
                ---
```

## Customizing

### inputs

Following inputs can be used as `step.with` keys:

| Name                      | Type   | Description                                                                                                                          |
|---------------------------|--------|--------------------------------------------------------------------------------------------------------------------------------------|
| `path`                    | Path   | Path to CHANGELOG file for stable releases. by default, `CHANGELOG.md` will be used.                                                 |
| `prerelease-path`         | Path   | Path to CHANGELOG file for pre-releases. by default, `CHANGELOG-PRERELEASE.md` will be used.                                         |
| `prerelease`              | Bool   | `true` if current release is pre-release, `false` for stable releases. by default, `false`                                           |
| `prerelease-note-heading` | Text   | The heading text of release note for pre-releases. This will be prepended to release notes for pre-releases.                         |
| `release-note-heading`    | Text   | The heading text of release note for stable releases. This will be prepended to release notes for stable-releases.                   |
| `version`                 | String | The name of version. This must be tag name and will also be used as changelog.                                                       |
| `date`                    | String | The release date of the version. Will be used in changelog. By default, current date in `YYYY-MM-DD` format.                         |
| `tag-prefix`              | String | The release date of the version. Will be used in changelog. By default, current date in `YYYY-MM-DD` format.                         |
| `repository-url`          | URL    | URL to the repository. Will be used as prefix for compare url or PullRequest link. like  (`${repository-url}/compare/<tag>...<tag>`) |
