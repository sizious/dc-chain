# Sega Dreamcast Toolchains Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

.PHONY: all
.PHONY: patch patch-sh4 patch-arm $(patch_sh4_targets) $(patch_arm_targets)
.PHONY: $(patch_binutils) $(patch_gcc) $(patch_newlib) $(patch_kos)
.PHONY: build build-sh4 build-arm $(build_sh4_targets) $(build_arm_targets) clean
.PHONY: build-binutils build-newlib build-gcc-pass1 build-gcc-pass2 fixup-sh4-newlib
.PHONY: gdb install_gdb build_gdb unpack_gdb
.PHONY: insight install_insight build_insight unpack_insight
