# Sega Dreamcast Toolchains Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

# Catch-all: CC
GCC = gcc
ifeq ($(CC),)
  CC := $(GCC)
endif

# Catch-all: CXX
GXX = g++
ifeq ($(CXX),)
  CXX := $(GXX)
endif

# Detect where Bash is installed
SHELL = /bin/bash
ifdef FREEBSD
  SHELL = /usr/local/bin/bash
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
    $(warning Please consider temporarily patching '/bin/msys-1.0.dll')
  endif
endif

# SH toolchain
sh_target = sh-elf
SH_CC_FOR_TARGET = $(sh_target)-$(GCC)
SH_CXX_FOR_TARGET = $(sh_target)-$(GXX)

# ARM toolchain
arm_target = arm-eabi

# Handle macOS
ifdef MACOS
  ifdef MACOS_MOJAVE_AND_UP
    # Starting from macOS Mojave (10.14+)
    sdkroot = $(shell xcrun --sdk macosx --show-sdk-path)
    macos_extra_args = -isysroot $(sdkroot)
    CC += -Wno-nullability-completeness -Wno-missing-braces $(macos_extra_args)
    CXX += -stdlib=libc++ -mmacosx-version-min=10.7 $(macos_extra_args)
    SH_CC_FOR_TARGET += $(macos_extra_args)
    SH_CXX_FOR_TARGET += $(macos_extra_args)
    macos_gcc_configure_args = --with-sysroot --with-native-system-header=/usr/include
    macos_gdb_configure_args = --with-sysroot=$(sdkroot)  
  endif
endif

# Handle Cygwin
ifdef CYGWIN
  CC += -D_GNU_SOURCE
  CXX += -D_GNU_SOURCE
endif

# Set static flags to pass to configure if needed
ifeq ($(standalone_binary),1)
  ifndef MINGW
    $(warning 'standalone_binary' should be used *ONLY* on MinGW/MSYS environment)
  endif
  # Note the extra minus before -static
  # See: https://stackoverflow.com/a/29055118/3726096
  static_flag := --enable-static --disable-shared "LDFLAGS=--static"
endif

# For all Windows systems (i.e. Cygwin, MinGW/MSYS and MinGW-w64/MSYS2)
ifdef WINDOWS
  executable_extension=.exe
endif

# MinGW/MSYS
# Disable makejobs possibility in legacy MinGW/MSYS environment as this breaks
# the build
ifdef MINGW
  ifneq ($(makejobs),)
    $(warning 'makejobs' is unsupported in this environment.  Ignoring.)
    makejobs=
  endif
endif

# Web downloaders command-lines
wget_cmd=wget -c
curl_cmd=curl -C - -O -J

# Determine if we want to apply fixup sh4 newlib
do_auto_fixup_sh4_newlib := 1
ifdef auto_fixup_sh4_newlib
  ifeq (0,$(auto_fixup_sh4_newlib))
    do_auto_fixup_sh4_newlib := 0
  endif
endif

ifeq (0,$(do_auto_fixup_sh4_newlib))
  ifeq (kos,$(thread_model))
    $(error kos thread model is unsupported when Newlib fixup is disabled)
  endif
endif
