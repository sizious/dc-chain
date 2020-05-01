# Sega Dreamcast Toolchains Maker (`dc-chain`) with Alpine Linux #

This document contains all the instructions to create a fully working
toolchains targeting the **Sega Dreamcast** system under **Alpine Linux**.

**Alpine Linux** is a regular **GNU/Linux** system but it's a great candidate
for making **Docker** images; that's why a special document was written for
that distribution.

## Introduction ##

On **Alpine Linux** family system, the package manager is the `apk` tool.

All the operations in this document should be executed with the `root` user. 
You have to type the `su -` command which comes installed by default on
**Alpine Linux**.

## Prerequisites ##

Before doing anything, you will have to install some prerequisites in order to
build the whole toolchains.

### Installation of required packages ###

The packages below need to be installed:

	apk --update add build-base patch bash texinfo libjpeg-turbo-dev libpng-dev	curl wget
	
At this time of writing, the `libelf-dev` package was missing from the main
repository, so you have to execute the following to install it:

	apk --update add libelf-dev --repository=http://dl-cdn.alpinelinux.org/alpine/v3.9/main

This may not be necessary depending if the `apk` repository was updated. Please
keep in mind that you have to install the `libelf-dev` package.

### Installation of additional packages ###

These additional packages are required too:

	apk --update add git python subversion

**Git** is needed right now, as **Subversion Client** and **Python 2** will be
needed only when building `kos-ports`. But it's better to install these now.

By the way you can check the installation success by entering something like
`git --version`. This should returns something like `git version X.Y.Z`.

## Preparing the environment installation ##

1. Enter the following to prepare **KallistiOS** and the toolchains:

		mkdir -p /opt/toolchains/dc/
		cd /opt/toolchains/dc/
		git clone https://github.com/KallistiOS/KallistiOS.git kos
		git clone https://github.com/KallistiOS/kos-ports.git

2. Enter the following to prepare **dcload**/**dc-tool** (part of 
   **KallistiOS**):
 
		mkdir -p /opt/toolchains/dc/dcload/
		cd /opt/toolchains/dc/dcload/
		git clone https://github.com/KallistiOS/dcload-serial.git
		git clone https://github.com/KallistiOS/dcload-ip.git

Everything is ready, now it's time to use the make the toolchains.

## Compilation ##

**KallistiOS** provides a complete system that make and install all required
toolchains from source codes: **dc-chain**.

The **dc-chain** system is mainly composed by a `Makefile` doing all the
necessary. Open the `config.mk` file with a text editor (e.g. `nano`). 
You can tweak some parameters, but usually everything is ready to work
out-of-the-box. For example, it isn't recommended to change the toolchains
program versions. The highest versions confirmed to work with the **Dreamcast**
are always already set in that `config.mk`.

### Making the toolchains ###

To make the toolchains, do the following:

1. Navigate to the `dc-chain` directory by entering:

		cd /opt/toolchains/dc/kos/utils/dc-chain/
	
2. Enter the following to download all source packages for all components:

		./download.sh

3. Enter the following to unpack all source packages.

		./unpack.sh

4. Enter the following to launch the process:

		make

Now it's time to take a coffee as this process is really long: several hours
will be needed to make the full toolchains!

### Making the GNU Debugger (gdb) ###

If you want to install the **GNU Debugger** (`gdb`), just enter:

	make gdb

This will install `sh-elf-gdb` and can be used to debug programs through
`dc-load/dc-tool`.

### Removing all useless files ###

After everything is done, you can cleanup all temporary files by entering:

	./cleanup.sh

## Next steps ##

After following this guide, the toolchains should be ready.

Now it's time to compile **KallistiOS**.

Please read the `/opt/toolchains/dc/kos/doc/README` file to learn the next
steps.

## About Docker images ##

You may use the `docker` directory in order to have an example of working
`Dockerfile`.
