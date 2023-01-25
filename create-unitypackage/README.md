# Create UnityPackage

Github Action to create UnityPackage.

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
      - uses: anatawa12/sh-actions/create-unitypackage@master
        with:
          output-path: output.unitypackage
          package-path: Assets/YourProject
```

## Customizing

### inputs

Following inputs can be used as `step.with` keys:

| Name           | Type   | Description                                                                                          |
|----------------|--------|------------------------------------------------------------------------------------------------------|
| `output-path`  | String | Path to output `unitypackage` file.                                                                  |
| `package-path` | String | Path to contents root of the unitypackage. Contents in the directory will be packed to unitypackage. |
| `path-prefix`  | String | Path prefix in the unitypackage. by default, `package-path` will be used.                            |
