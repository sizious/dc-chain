# Sega Dreamcast Toolchain Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

sh_prefix    := $(toolchain_base)/$(sh_target)
arm_prefix   := $(toolchain_base)/$(arm_target)
install       = $(prefix)/bin
pwd          := $(shell pwd)
patches      := $(pwd)/patches
logdir       := $(pwd)/logs
PATH         := $(sh_prefix)/bin:$(arm_prefix)/bin:$(PATH)

# Source directories
binutils_dir  = binutils-$(binutils_ver)
gcc_dir       = gcc-$(sh_gcc_ver)
newlib_dir    = newlib-$(newlib_ver)
