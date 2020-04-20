# Sega Dreamcast Toolchain Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

# This Makefile determines on what platform we are running. Instead of the
# 'Makefile.hostdetect' included in dcload packages, this version uses
# the 'config.guess' mecanism which is more complete and accurate.

# Check the presence of ./config.guess
# This will help a lot to execute conditional steps depending on the host.
is_clean_target=$(findstring clean,$(MAKECMDGOALS))
config_guess_check=$(shell test -f ./config.guess || echo 0)
ifeq ($(is_clean_target),)
  ifeq ($(config_guess_check),0)
    $(error Please execute ./download.sh first)
  endif
endif

# Retrieve the host triplet
ifneq ($(config_guess_check),0)
  host_triplet=$(shell ./config.guess)
endif

# Retrieve the system
uname_s := $(shell uname -s)
uname_r := $(shell uname -r)

# Determine if we are running macOS
ifeq ($(uname_s),Darwin)
  $(info macOS build environment detected)
  MACOS := 1

  # Detect if we are on macOS Mojave (10.14) or up; as starting from that
  # version, some breaking changes were introduced by Apple
  macos_ver = $(shell sw_vers -productVersion)
  macos_ver_major = $(shell echo $(macos_ver) | cut -d'.' -f 1)
  macos_ver_minor = $(shell echo $(macos_ver) | cut -d'.' -f 2)
  MACOS_MOJAVE_AND_UP := $(shell [ $(macos_ver_major) -gt 10 -o \( $(macos_ver_major) -eq 10 -a $(macos_ver_minor) -ge 14 \) ] && echo "1")
endif

# Determine if we are running Linux
ifeq ($(uname_s),Linux)
  $(info GNU/Linux build environment detected)
  LINUX := 1
endif

# Determine if we are running under FreeBSD
ifneq ($(shell echo "$(host_triplet)" | grep -i 'freebsd'),)
  $(info FreeBSD build environment detected)
  FREEBSD := 1
  BSD := 1
endif

# Determine if we are on WSL
ifneq ($(shell echo "$(uname_r)" | grep -i 'microsoft'),)
  $(info WSL build environment detected)
  WSL := 1
  WINDOWS := 1
endif

# Determine if we are running Cygwin
ifneq ($(shell echo "$(host_triplet)" | grep -i 'cygwin'),)
  $(info Cygwin build environment detected)
  CYGWIN := 1
  WINDOWS := 1  
endif

# Determine if we are running under MinGW/MSYS
# This will make difference between MinGW/MSYS and MinGW-w64/MSYS2
ifneq ($(shell echo "$(host_triplet)" | grep -i 'mingw'),)
  is_legacy_mingw=$(shell pacman --version >/dev/null 2>&1 || echo 1)
  ifeq ($(is_legacy_mingw),1)
    $(info MinGW/MSYS build environment detected)
    MINGW := 1
  else
    $(info MinGW-w64/MSYS2 build environment detected)
    MINGW64 := 1
    # config.guess is not reliable in this environment	
    host_triplet=$(shell echo $$MSYSTEM_CHOST)
  endif
  MINGW32 := 1  
  WINDOWS := 1  
endif
