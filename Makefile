# Sega Dreamcast Toolchain Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#
# Please edit 'config.mk' to customize your 'dc-chain' setup.
#

# Display startup banner
include scripts/banner.mk

# User configuration
include config.mk

# Detect host machine
include scripts/host-detect.mk

# Initialization rules
include scripts/init.mk

# Makefile variables
include scripts/variables.mk

all: patch build

# ---- patch {{{

include scripts/patch.mk

# ---- }}}

# ---- build {{{

include scripts/build.mk

include scripts/binutils.mk
include scripts/gcc-pass1.mk
include scripts/newlib.mk
include scripts/gcc-pass2.mk

# ---- }}}}

# ---- optional components {{{

include scripts/gdb.mk
include scripts/insight.mk

# ---- }}}}

# ---- support {{{

include scripts/clean.mk
include scripts/logdir.mk
include scripts/options.mk

# ---- }}}

# ---- phony targets {{{

include scripts/phony.mk

# ---- }}}}

# vim:tw=0:fdm=marker:fdc=2:fdl=1
