# Sega Dreamcast Toolchain Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

sh_prefix    := $(toolchains_base)/$(sh_target)
arm_prefix   := $(toolchains_base)/$(arm_target)
install       = $(prefix)/bin
pwd          := $(shell pwd)
patches      := $(pwd)/patches
logdir       := $(pwd)/logs
PATH         := $(sh_prefix)/bin:$(arm_prefix)/bin:$(PATH)
