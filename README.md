<div align="center">

# asdf-polaris [![Build](https://github.com/particledecay/asdf-polaris/actions/workflows/test.yml/badge.svg)](https://github.com/particledecay/asdf-polaris/actions/workflows/test.yml) [![Lint](https://github.com/particledecay/asdf-polaris/actions/workflows/lint.yml/badge.svg)](https://github.com/particledecay/asdf-polaris/actions/workflows/lint.yml)


[polaris](https://github.com/FairwindsOps/polaris) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Why?](#why)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add polaris
# or
asdf plugin add polaris https://github.com/particledecay/asdf-polaris.git
```

polaris:

```shell
# Show all installable versions
asdf list-all polaris

# Install specific version
asdf install polaris latest

# Set a version globally (on your ~/.tool-versions file)
asdf global polaris latest

# Now polaris commands are available
polaris version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/particledecay/asdf-polaris/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Joey Espinosa](https://github.com/particledecay/)
