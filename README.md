# vscode-sysroot

Allows VS Code 1.99+ to run on legacy systems.

A sysroot with glibc 2.28 and kernel 3.10 is built using `crosstool-ng` in Docker, following the [unofficial instructions](https://code.visualstudio.com/docs/remote/faq#_can-i-run-vs-code-server-on-older-linux-distributions) with some modifications. [patchelf](https://github.com/NixOS/patchelf) is also installed into the sysroot. Once it is copied to the remote system, and the proper environment variables are set up, the server will patch itself on startup.

This is confirmed to work on CentOS 7.9 / RHEL 7.9 / Oracle Linux 7.9. (i.e. STFC Aquilon, CentOS 7 at time of writing)
It may work on Ubuntu 18.04, but see below.

## Instructions

### Sysroot: Prebuilt Binary
![GitHub Release](https://img.shields.io/github/v/release/AlexCK-STFC/vscode-sysroot)

A prebuilt binary for the config in this repo (x84_64, Kernel 3.10) is available as a [GitHub release](https://github.com/AlexCK-STFC/vscode-sysroot/releases/latest).
Untested, your mileage may vary.

### Sysroot: Building Locally
- Ensure you have a working Docker installation
- Use `make` to build a sysroot tarball in `toolchain/`

Changes may be made to the config file, the path of which can be changed in the Dockerfile. Official example configs are linked on the [VSCode docs](https://code.visualstudio.com/docs/remote/faq#_can-i-run-vs-code-server-on-older-linux-distributions).
### Using Sysroot on a server
- Copy `toolchain/vscode-sysroot-x86_64-linux-gnu.tgz` to the remote legacy server
- Untar the sysroot into `~/.vscode-server/sysroot` on the remote
  - `tar zxf vscode-sysroot-x86_64-linux-gnu.tgz -C ~/.vscode-server`
- Copy `sysroot.sh` to `~/.vscode-server/sysroot.sh` on the remote server
- `source ~/.vscode-server/sysroot.sh` from your `.bashrc` or other login script

Now connect to your remote server in VS Code, and in the `Output > Remote - SSH` tab, you will see `Patching glibc` and `Patching linker`
just after `Starting server...`. Any error output is also visible in this tab.

### Note: Kernel version for i.e. Ubuntu 18.04

On Ubuntu 18.04, which uses kernel 4.15 or later, this config is untested but may work as-is.
However, you might have to change the following versions to `"4.15"` (or later) in `x86_64-gcc-8.5.0-glibc-2.28.config`.
In [Microsoft's example](https://github.com/microsoft/vscode-linux-build-agent/blob/main/x86_64-gcc-8.5.0-glibc-2.28.config),
they are set to exactly `4.19.287`. If you confirm this either way, please open an issue with your findings.

```
  CT_LINUX_VERSION="3.10"
  CT_GLIBC_MIN_KERNEL="3.10"
```
