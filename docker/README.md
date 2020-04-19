This repository contains the minimal toolchains used for **Sega Dreamcast**
development. All of these images are based on [Alpine Linux](https://alpinelinux.org/).

Provided toolchains are:
* A `sh-elf` toolchain, targetting the main CPU, which is located in `/opt/toolchains/dc/sh-elf`;
* An `arm-eabi` toolchain, targetting the DSP (Audio), which is located in `/opt/toolchains/dc/arm-eabi` ;
* The regular toolchain (e.g. `gcc`), used for compiling various tools.

These images may be used to compile [KallistiOS](https://en.wikipedia.org/wiki/KallistiOS), the open source **Sega Dreamcast** development library.

Source `Dockerfiles` may be found in [KallistiOS Nitro](https://gitlab.com/simulant/community/kallistios-nitro/-/tree/master/utils%2Fdc-chain%2Fdocker) repository. In the same time, these images are used for [KallistiOS Nitro](https://gitlab.com/simulant/community/kallistios-nitro) through its [GitLab CI/CD](https://gitlab.com/simulant/community/kallistios-nitro/pipelines) pipeline.

[Need help? Join the Discord Channel!](https://discord.gg/TRx94EV)
