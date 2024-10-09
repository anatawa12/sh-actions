# Create [VPAI] unitypackage

[VPAI]: https://github.com/anatawa12/VPMPackageAutoInstaller

## Usage

```yaml
name: ci

on:
  push:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: anatawa12/sh-actions/create-vpai@master
        with:
          # list of repositories separated by new lines
          # if you're creating VPAI unitypackage for curated / official repository,
          # this can be omitted
          repositories: |
            https://vpm.anatawa12.com/vpm.json
            https://vpm.nadena.dev/vpm.json
          # list of packages that will be installed with the VPAI unitypackage.
          # We can specify version range by appending @range
          packages: |
            com.anatawa12.gists
            com.anatawa12.avatar-optimizer@1.x.x
          # Specify output file name.
          output: your-installer-unitypackage-name.unitypackage
```

## Customizing

### inputs

Following inputs can be used as `step.with` keys:

> `List` type is a newline-delimited string
> ```yaml
> driver-opts: |
>   https://vpm.anatawa12.com/vpm.json
>   https://vpm.nadena.dev/vpm.json
>   https://vpm.nadena.dev/vpm-prerelease.json
> ```

| Name           | Type   | Description                                                                                                                        |
|----------------|--------|------------------------------------------------------------------------------------------------------------------------------------|
| `repositories` | List   | List of repositories that will be used to search the package and added to VCC.                                                     |
| `packages`     | List   | List of packages to be installed. You can specify version range by appending `@range` like `com.anatawa12.avatar-optimizer@1.x.x`. |
| `config-file`  | String | Path to vpai config file.                                                                                                          |
| `config-json`  | String | Embedded vpai config file.                                                                                                         |
| `output`       | String | Path to unitypackage                                                                                                               |

One of `packages`, `config-file`, `config-json` is required, and if either `config-file` or `config-json` is specified, `repositories` must not be specified.
`output` is required.

## Dependencies

Posix shell / commands and following commands

- `node` or `deno` as a javascript / webassembly runtime
- `jq` to construct config file.
