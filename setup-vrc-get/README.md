# Resolve VPM Packages

Github Action to resolve all VPM Packages in your unity project.

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
       - uses: anatawa12/sh-actions/reesolve-vpm-packages@master
       # You can test using game-ci/unity-test-runner@v2
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

| Name           | Type   | Description                                                      |
|----------------|--------|------------------------------------------------------------------|
| `project-path` | String | Path to your project. By default, GITHUB_WORKSPACE will be used. |
| `repos`        | List   | List of repository urls.                                         |
