build: build-sh4 build-arm
build-sh4: build-sh4-binutils build-sh4-gcc
build-arm: build-arm-binutils build-arm-gcc
build-sh4-gcc: build-sh4-gcc-pass1 build-sh4-newlib build-sh4-gcc-pass2
build-arm-gcc: build-arm-gcc-pass1
	$(clean_arm_hack)
build-sh4-newlib: build-sh4-newlib-only fixup-sh4-newlib

# Ensure that, no matter where we enter, prefix and target are set correctly.
build_sh4_targets = build-sh4-binutils build-sh4-gcc build-sh4-gcc-pass1 \
                    build-sh4-newlib build-sh4-newlib-only build-sh4-gcc-pass2
build_arm_targets = build-arm-binutils build-arm-gcc build-arm-gcc-pass1

# Available targets for SH
$(build_sh4_targets): prefix = $(sh_prefix)
$(build_sh4_targets): target = $(sh_target)
$(build_sh4_targets): extra_configure_args = --with-multilib-list=m4-single-only --with-endian=little --with-cpu=m4-single-only
$(build_sh4_targets): gcc_ver = $(sh_gcc_ver)
$(build_sh4_targets): binutils_ver = $(sh_binutils_ver)

ifdef MINGW
# To compile dc-tool, we need to install libbfd for sh-elf.
# This is done when making build-sh4-binutils.
  $(build_sh4_targets): libbfd_install_flag = -enable-install-libbfd
  $(build_sh4_targets): libbfd_src_bin_dir = $(sh_prefix)/$(host_triplet)/$(sh_target)
endif

# Available targets for ARM
$(build_arm_targets): prefix = $(arm_prefix)
$(build_arm_targets): target = $(arm_target)
$(build_arm_targets): extra_configure_args = --with-arch=armv4 --with-mode=arm --disable-multilib
$(build_arm_targets): gcc_ver = $(arm_gcc_ver)
$(build_arm_targets): binutils_ver = $(arm_binutils_ver)

# To avoid code repetition, we use the same commands for both architectures.
# But we can't create a single target called 'build-binutils' for both sh4 and
# arm, because phony targets can't be run multiple times. So we create multiple
# targets.
build_binutils      = build-sh4-binutils  build-arm-binutils
build_gcc_pass1     = build-sh4-gcc-pass1 build-arm-gcc-pass1
build_newlib        = build-sh4-newlib-only
build_gcc_pass2     = build-sh4-gcc-pass2
