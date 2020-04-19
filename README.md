# Sega Dreamcast Toolchain Maker (`dc-chain`)

This directory contains a set of files which both simplifies building the whole 
**Sega Dreamcast** toolchain and gives you substantial control.

The whole toolchain for the Dreamcast is composed by:

- A `sh-elf` toolchain, which is the main toolchain as it targets the CPU of the 
**Dreamcast**, i.e. the **Hitachi SH-4 CPU** (**SuperH**).
- An `arm-eabi` toolchain, which is the toolchain used only for the **Yamaha
Super Intelligent Sound Processor** (**AICA**). This processor is based
on an **ARM7** core.

The **dc-chain** package is ready to build everything you need to compile
**KallistiOS** and then develop for the **Sega Dreamcast** system.

## Toolchains overview

Components included in the toolchains are:

- **Binutils** (mainly `ld` plus other tools)
- **GNU Compiler Collection** (`gcc`)
- **Newlib** (mainly `libc` plus other libraries)
- **GNU Debugger** (`gdb`) - Optional

Binutils and GCC are installed for both targets (i.e. `sh-elf` and `arm-eabi`)
where Newlib and GNU Debugger (GDB) are installed only for the main
toolchain (`sh-elf`).

## Configuration

If you want to tweak your setup, open the `config.mk` file in your favorite
editor.

Speaking about the best versions of the components to use for the Dreamcast
development, they are already declared in the `Makefile`.

The most well tested combination is GCC 4.7.4 with Newlib 2.0.0, for both
targets but there are also newer possibilities that are in testing (GCC 9.3.0
with Newlib 3.3.0)..

The GCC's maximum version number possible for the `arm-eabi` toolchain is
`8.4.0`. In GCC 9, the ARM7 CPU used in the Dreamcast is not anymore available.

## Advanced options

You may attempt to spawn multiple jobs with `make`. Using `make -j2` is
recommended for speeding up the building of the toolchain. There is an option 
inside the `Makefile` to set the number of jobs for the building phases.
Set the `makejobs` variable in the `Makefile` to whatever you would normally
feel the need to use on the command line, and it will do the right thing.

In the old times, this option may breaks things, so, if you run into
trouble, you should clear this variable and try again with just one
job running.

On **MinGW/MSYS** environment, it has been confirmed that multiple jobs breaks
the toolchain, so please don't try to do that under this environment. This
option is disabled by default in this scenario. This doesn't apply to the
others environments, including **MinGW-w64/MSYS2**.

## Usage

Before you start, please browse the `./doc` directory and check if they are
full instructions for building the whole toolchain for your environment.

### Making the toolchain

Below you will find some generic instructions:

1. Change the variables in the `config.mk` file to match your environment. 
   They can be overridden at the command line as well. Please note, a lot of
   conditional instructions have been added, so it should work most of the time
   just out-of-the-box for your environment.

2. Then execute the following for preparing the sources:

		./download.sh
		./unpack.sh

3. Finally, input (for **BSD**, please use `gmake` instead):

		make
	
Depending of your environment, this can take a bunch of hours. So please be
patient!

If anything goes wrong, check the output in `logs/`.

### Making the GNU Debugger (gdb)

For the `sh-elf` toolchain, if you want to use the **GNU Debugger** (`gdb`),
you can make it by entering:

	make gdb

This will install `gdb` in the `sh-elf` toolchain (`gdb` is used with
`dcload/dc-tool` programs, which are part of **KallistiOS** too).

### Removing all useless files

After the toolchain compilation, you can cleanup everything by entering:

	./cleanup.sh

This will save a lot of space.

## Final note

Please see the comments at the top of the `Makefile` for more build options.
