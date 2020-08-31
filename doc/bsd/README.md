# Sega Dreamcast Toolchains Maker (`dc-chain`) with BSD #

This document contains all the instructions to create a fully working
toolchains targeting the **Sega Dreamcast** system under **Berkeley Software
Distribution** (**BSD**).

This document was written when using **FreeBSD** (`11.2`) but it should be
applicable on all **BSD** systems like **NetBSD** and **OpenBSD**.

## Introduction ##

On **FreeBSD** system, the package manager is the `pkg` tool.
 
If you never used the `pkg` tool before, you will be asked to install it. Please
do this before continuing reading the document.

All the operations in this document should be executed with the `root` user. If 
you don't want to connect with the `root` user, another option is to install
the `sudo` command by entering:

	pkg install sudo

In that case, you will need to add the `sudo` command before entering all the
commands specified below.

## Prerequisites ##

Before doing anything, you will have to install some prerequisites in order to
build the whole toolchains.

### Installation of required packages ###

The packages below need to be installed:

	pkg install gcc gmake binutils texinfo bash libjpeg-turbo png libelf

In **BSD** systems, the `make` is **NOT** the same as the **GNU Make** tool.
Everything in the package needs `gmake`, you can't use `make` in **BSD**
systems.

Plus, by default the `sh` shell is run, and the whole **KallistiOS** package
needs `bash`, that's why it needs to be installed.

### Installation of additional packages ###

These additional packages are required too:

	pkg install git subversion python2

**Git** is needed right now, as **Subversion Client** and **Python 2** will be
needed only when building `kos-ports`. But it's better to install these now.

By the way you can check the installation success by entering something like
`git --version`. This should returns something like `git version X.Y.Z`.

A cool text editor should be useful too:

	pkg install nano

Of course, this step is optional, you can use `vi` or something else if you
want.

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
		git clone https://gitlab.com/kallistios/dcload-serial.git
		git clone https://gitlab.com/kallistios/dcload-ip.git

Everything is ready, now it's time to make the toolchains.

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

1. Run `bash`, if not already done:

		bash

2. Navigate to the `dc-chain` directory by entering:

		cd /opt/toolchains/dc/kos/utils/dc-chain/
	
3. Enter the following to download all source packages for all components:

		./download.sh

4. Enter the following to unpack all source packages.

		./unpack.sh

5. Enter the following to launch the process:

		gmake

Now it's time to take a coffee as this process is really long: several hours
will be needed to make the full toolchains!

### Making the GNU Debugger (gdb) ###

If you want to install the **GNU Debugger** (`gdb`), just enter:

	gmake gdb

This will install `sh-elf-gdb` and can be used to debug programs through
`dc-load/dc-tool`.

### Removing all useless files ###

After everything is done, you can cleanup all temporary files by entering:

	./cleanup.sh

## Next steps ##

After following this guide, the toolchains should be ready.

Now it's time to compile **KallistiOS**.

You may consult the `README` file from KallistiOS now.
