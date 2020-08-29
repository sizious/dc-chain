# Dockerfile

This directory contain a `Dockerfile` which demonstrate you how to build a
Docker image containing the minimal toolchains used for **Sega Dreamcast**
development.

The Docker image foundation is based on [Alpine Linux](https://alpinelinux.org/).

Built toolchains are:
* A `sh-elf` toolchain, targeting the main CPU, which will be located in 
  `/opt/toolchains/dc/sh-elf`;
* An `arm-eabi` toolchain, targeting the audio chip, which will be located in
  `/opt/toolchains/dc/arm-eabi` ;
* The regular toolchain used for compiling various tools.

These images may be used to compile [KallistiOS](https://en.wikipedia.org/wiki/KallistiOS),
the open source **Sega Dreamcast** development library.

In clear, this `Dockerfile` doesn't build KallistiOS itself, only the required
toolchains. KallistiOS is not part of the toolchains. Plus, KallistiOS may be
updated often so it's better to have a separate image with the toolchains as
building them can take hours.

Of course, the Docker image produced here can be used for CI/CD pipelines!

Don't hesitate to have multiple `config.mk` files; this may be useful for
building customized toolchains (e.g. a `stable` Docker image with `gcc-9.3.0`
and a `legacy` one with `gcc-4.7.4`...).
