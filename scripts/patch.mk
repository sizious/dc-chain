# Sega Dreamcast Toolchain Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

binutils_patches 	:= $(wildcard $(patches)/binutils-$(binutils_ver)*.diff)
gcc_patches    		:= $(wildcard $(patches)/gcc-$(sh_gcc_ver)*.diff)
newlib_patches 		:= $(wildcard $(patches)/newlib-$(newlib_ver)*.diff)
kos_patches    		:= $(wildcard $(patches)/kos-*.diff)

ifdef MINGW
# Additional patches for MinGW/MSYS
  binutils_patches	+= $(wildcard $(patches)/$(host_triplet)/binutils-$(binutils_ver)*.diff)	
endif

stamp_patch_binutils = patch-binutils.stamp
stamp_patch_gcc      = patch-gcc.stamp
stamp_patch_newlib   = patch-newlib.stamp
stamp_patch_kos      = patch-kos.stamp

patch_targets = patch-binutils patch-gcc patch-newlib patch-kos

patch: $(patch_targets)

# Binutils
patch-binutils: $(binutils_patches)
	@touch $(stamp_patch_binutils)
$(binutils_patches):
	@if ! test -f "$(stamp_patch_binutils)"; then \
		patch -N -d $(binutils_dir) -p1 < $@; \
	fi;

# GNU Compiler Collection (GCC)
patch-gcc: $(gcc_patches)
	@touch $(stamp_patch_gcc)
$(gcc_patches):
	@if ! test -f "$(stamp_patch_gcc)"; then \
		patch -N -d $(gcc_dir) -p1 < $@; \
	fi;
	
# Newlib
patch-newlib: $(newlib_patches)
	@touch $(stamp_patch_newlib)
$(newlib_patches):
	@if ! test -f "$(stamp_patch_newlib)"; then \
		patch -N -d $(newlib_dir) -p1 < $@; \
	fi;

# KallistiOS
patch-kos: $(kos_patches)
	@touch $(stamp_patch_kos)
$(kos_patches):
	@if ! test -f "$(stamp_patch_kos)"; then \
		patch -N -d $(kos_root) -p1 < $@; \
	fi;
