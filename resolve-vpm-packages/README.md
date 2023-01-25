# Setup [`vrc-get`][vrc-get]

Github Action to install [`vrc-get`][vrc-get] command

This action will download latest or specified version of vrc-get command.

## Usage

```yaml
name: ci
on:
　push:
jobs:
  test:
　  runs-on: ubuntu-latest
　　  steps:
       - uses: anatawa12/sh-actions/setup-vrc-get@master
```

## Customizing

### inputs

Following inputs can be used as `step.with` keys:

> `List` type is a newline-delimited string
> ```yaml
> driver-opts: |
>   image=moby/buildkit:master
>   network=host
> ```

| Name      | Type   | Description                                                                |
|-----------|--------|----------------------------------------------------------------------------|
| `version` | String | [vrc-get] version. (eg. `v0.3.0`, `latest`)                                |
| `target`  | String | Target triple to be downloaded. By default, current platform will be used. |

[vrc-get]: https://github.com/anatawa12/vrc-get
