# Sega Dreamcast Toolchain Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

# Catch-all: CXX
ifeq ($(CXX),)
  CXX := "g++"
endif

# Catch-all: CC
ifeq ($(CC),)
  CC := "gcc"
endif

# MinGW/MSYS
# Check the MSYS POSIX emulation layer version...
#
# This is needed as a severe bug exists in the '/bin/msys-1.0.dll' file.
# Indeed, the heap size is hardcoded and too small, which causes the error:
#
#   Couldn't commit memory for cygwin heap, Win32 error
#
# The only solution to build gcc for sh-elf target under MinGW/MSYS is to
# temporarily replace the '/bin/msys-1.0.dll' shipped with MinGW environment
# (which is the v1.0.19 at this time) with the patched version provided in the
# ./doc/mingw/ directory. You just need the 'msys-1.0.dll' file from this
# package. Copy the original file somewhere outside your MinGW/MSYS installation
# and replace it with the provided patched version.
#
# The patched version is coming from the C::B Advanced package. The major fix 
# applied is the heap size increase, from 256 MB to more than 1024 MB.
#
# After building the whole toolchain, please remove the patched version and move
# the original '/bin/msys-1.0.dll' file back in place.
#
ifdef MINGW
  msys_patched_checksum = 2e627b60938fb8894b3536fc8fe0587a5477f570
  msys_checksum = $(shell sha1sum /bin/msys-1.0.dll | cut -c-40)
  ifneq ($(msys_checksum),$(msys_patched_checksum))	
    $(warning Please consider temporarily patching '/bin/msys-1.0.dll'!)
  endif
endif

# Detect where Bash is installed
SHELL = /bin/bash
ifdef FREEBSD
  SHELL = /usr/local/bin/bash
endif

# Check if we are curl or wget...
web_downloader := $(shell command -v wget)
ifeq ($(web_downloader),)
  USE_CURL = 1
endif

# KOS Git root directory (contains kos/ and kos-ports/)
kos_root = $(CURDIR)/../../..

# kos_base is equivalent of KOS_BASE (contains include/ and kernel/)
kos_base = $(CURDIR)/../..

# SH toolchain
sh_target = sh-elf

# ARM toolchain
arm_target = arm-eabi

# Handle macOS
ifdef MACOS
  ifdef MACOS_MOJAVE_AND_UP
    # Starting from macOS Mojave (10.14+)
    sdkroot = $(shell xcrun --sdk macosx --show-sdk-path)
    macos_extra_args = -isysroot $(sdkroot)
    CC := "$(CC) -Wno-nullability-completeness"
    CXX := "$(CXX) -stdlib=libc++ -mmacosx-version-min=10.7"
    SH_CC_FOR_TARGET := "$(sh_target)-gcc $(macos_extra_args)"
    SH_CXX_FOR_TARGET := "$(sh_target)-g++ $(macos_extra_args)"
    macos_gcc_configure_args = --with-sysroot --with-native-system-header=/usr/include
  else
    # Up to macOS High Sierra (10.13)
    CC := "$(CC)"

    # GCC compiles fine with clang only if we use libstdc++ instead of libc++.
    CXX := "$(CXX) -stdlib=libstdc++"
  endif
endif

# Handle Cygwin
ifdef CYGWIN
  CC := "$(CC) -D_GNU_SOURCE"
endif

# Set static flags to pass to configure if needed
ifeq ($(standalone_binary),1)
  ifndef MINGW
    $(warning standalone_binary should be used ONLY on MinGW/MSYS environment)
  endif
  # Note the extra minus before -static
  # See: https://stackoverflow.com/a/29055118/3726096
  static_flag := --enable-static --disable-shared "LDFLAGS=--static"
endif

# For all Windows systems (i.e. Cygwin, MinGW/MSYS and MinGW-w64/MSYS2)
ifdef WINDOWS
  executable_extension=.exe
endif

# Handle makejobs exceptions
ifdef MINGW
  makejobs=
endif

ifdef WSL
  makejobs=-j2
endif

