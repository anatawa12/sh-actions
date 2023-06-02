# conventional-commitlint

Run conventional-commitlint

## Usage

```yaml
name: ci

on:
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: anatawa12/sh-actions/conventional-commitlint@master
```

## Customizing

### inputs

Following inputs can be used as `step.with` keys:

| Name         | Type   | Description                                                                                         |
|--------------|--------|-----------------------------------------------------------------------------------------------------|
| `workspace`  | String | Path to your project. By default, GITHUB_WORKSPACE will be used.                                    |
| `head`       | String | The head ref. By default, `github.head_ref` will be used.                                           |
| `base`       | String | The base ref. By default, `github.base_ref` will be used.                                           |
| `repository` | String | This command will initializes treeless clone of repository if does not exists. The git url for that |
| `version`    | String | [conventional-commitlint] version. (eg. `v0.3.0`, `latest`)                                         |
| `target`     | String | Target triple to be downloaded. By default, current platform will be used.                          |

[conventional-commitlint]: https://github.com/anatawa12/conventional-commitlint
