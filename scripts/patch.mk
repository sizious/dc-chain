# Sega Dreamcast Toolchains Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

patch: patch-sh4 patch-arm patch-kos
patch-sh4: patch-sh4-binutils patch-sh4-gcc patch-sh4-newlib
patch-arm: patch-arm-binutils patch-arm-gcc

# Ensure that, no matter where we enter, prefix and target are set correctly.
patch_sh4_targets = patch-sh4-binutils patch-sh4-gcc patch-sh4-newlib
patch_arm_targets = patch-arm-binutils patch-arm-gcc

# Available targets for SH
$(patch_sh4_targets): target = $(sh_target)
$(patch_sh4_targets): gcc_ver = $(sh_gcc_ver)
$(patch_sh4_targets): binutils_ver = $(sh_binutils_ver)

# Available targets for ARM
$(patch_arm_targets): target = $(arm_target)
$(patch_arm_targets): gcc_ver = $(arm_gcc_ver)
$(patch_arm_targets): binutils_ver = $(arm_binutils_ver)

# To avoid code repetition, we use the same commands for both architectures.
# But we can't create a single target called 'patch-binutils' for both sh4 and
# arm, because phony targets can't be run multiple times. So we create multiple
# targets.
patch_binutils      = patch-sh4-binutils patch-arm-binutils
patch_gcc           = patch-sh4-gcc patch-arm-gcc
patch_newlib        = patch-sh4-newlib
patch_kos           = patch-kos

# This is a common 'patch_apply' function used in all the cases
define patch_apply
	@stamp_file=patch-$(stamp_radical_name).stamp; \
	patches=$$(echo "$(diff_patches)" | xargs); \
	if ! test -f "$${stamp_file}"; then \
		if ! test -z "$${patches}"; then \
			echo "+++ Patching $(patch_target_name)..."; \
			patch -N -d $(src_dir) -p1 < $${patches}; \
		fi; \
		touch "$${stamp_file}"; \
	fi;
endef

# Binutils
$(patch_binutils): patch_target_name = Binutils
$(patch_binutils): src_dir = binutils-$(binutils_ver)
$(patch_binutils): stamp_radical_name = $(src_dir)
$(patch_binutils): diff_patches := $(wildcard $(patches)/$(src_dir)*.diff)
$(patch_binutils): diff_patches += $(wildcard $(patches)/$(host_triplet)/$(src_dir)*.diff)
$(patch_binutils):
	$(call patch_apply)

# GNU Compiler Collection (GCC)
$(patch_gcc): patch_target_name = GCC
$(patch_gcc): src_dir = gcc-$(gcc_ver)
$(patch_gcc): stamp_radical_name = $(src_dir)
$(patch_gcc): diff_patches := $(wildcard $(patches)/$(src_dir)*.diff)
$(patch_gcc): diff_patches += $(wildcard $(patches)/$(host_triplet)/$(src_dir)*.diff)
$(patch_gcc):
	$(call patch_apply)

# Newlib
$(patch_newlib): patch_target_name = Newlib
$(patch_newlib): src_dir = newlib-$(newlib_ver)
$(patch_newlib): stamp_radical_name = $(src_dir)
$(patch_newlib): diff_patches := $(wildcard $(patches)/$(src_dir)*.diff)
$(patch_newlib): diff_patches += $(wildcard $(patches)/$(host_triplet)/$(src_dir)*.diff)
$(patch_newlib):
	$(call patch_apply)

# KallistiOS
$(patch_kos): patch_target_name = KallistiOS
$(patch_kos): src_dir = $(kos_root)
$(patch_kos): stamp_radical_name = kos
$(patch_kos): diff_patches := $(wildcard $(patches)/$(src_dir)*.diff)
$(patch_kos): diff_patches += $(wildcard $(patches)/$(host_triplet)/$(src_dir)*.diff)
$(patch_kos):
	$(call patch_apply)
