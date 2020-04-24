# Sega Dreamcast Toolchain Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#
# Interesting targets (you can 'make' any of these):
# all: patch build
# patch: patch-gcc patch-newlib patch-kos
# build: build-sh4 build-arm
# build-sh4: build-sh4-binutils build-sh4-gcc
# build-arm: build-arm-binutils build-arm-gcc
# build-sh4-gcc: build-sh4-gcc-pass1 build-sh4-newlib build-sh4-gcc-pass2
# build-arm-gcc: build-arm-gcc-pass1
# build-sh4-newlib: build-sh4-newlib-only fixup-sh4-newlib
# gdb
# insight

# Indicate the root directory where toolchains will be installed
# This should match your 'environ.sh' configuration
toolchain_base=/opt/toolchains/dc

# Toolchain for SH
sh_binutils_ver=2.34
sh_gcc_ver=9.3.0
newlib_ver=3.3.0
gdb_ver=9.1
insight_ver=6.8-1

# Toolchain for ARM
# The ARM version of binutils/gcc is separated out as the particular CPU
# versions we need may not be available in newer versions of GCC.
arm_binutils_ver=2.34
arm_gcc_ver=8.4.0

# Specify here if you want to use custom GMP, MPFR and MPC libraries; they are
# required for building GCC. If you leave this parameter commented, these
# dependencies will be downloaded by using the provided 'download_prerequisites'
# script from GCC, which is recommended.
#use_custom_dependencies=1

# Internal custom GCC libraries (i.e. GMP, MPFR and MPC) versions to use
# These versions are used only if 'use_custom_dependencies' flag is enabled.
sh_gmp_ver=6.1.0
sh_mpfr_ver=3.1.4
sh_mpc_ver=1.0.3
sh_isl_ver=0.18
arm_gmp_ver=6.1.0
arm_mpfr_ver=3.1.4
arm_mpc_ver=1.0.3
arm_isl_ver=0.18

# GCC threading model (single|kos)
# With GCC 4.x versions and up, the patches provide a 'kos' thread model, so you 
# should use it. If you really don't want threading support for C++ (or 
# Objective C/Objective C++), you can set this to 'single' (why you would is
# beyond me, though). With GCC 3.4.6, you probably want 'posix' here; but this 
# mode is deprecated as the GCC 3.x branch is not supported anymore.
thread_model=kos

# Erase build directories on the fly to save space
erase=1

# Display output to screen as well as log files
verbose=1

# Set this value to -jn where n is the number of jobs you want to run with make.
# If you only want one job, just set this to nothing (i.e, "makejobs=").
# Tracking down problems with multiple make jobs is much more difficult than
# with just one running at a time. So, if you run into trouble, then you should
# clear this variable and try again with just one job running.
# Please note, this value may be overriden in some cases; as issues were
# detected on some OS.
makejobs=-j2

# Set the languages to build for pass 2 of building gcc for sh-elf. The default
# here is to build C, C++, Objective C, and Objective C++. You may want to take
# out the latter two if you're not worried about them and/or you're short on
# hard drive space.
pass2_languages=c,c++,objc,obj-c++

# download_protocol (https|ftp)
# Specify here the protocol you want to use for downloading the packages.
download_protocol=https

# Specify here the tarball extensions to download
sh_binutils_tarball_type=xz
sh_gcc_tarball_type=xz
newlib_tarball_type=gz
gdb_tarball_type=xz
insight_tarball_type=bz2
arm_binutils_tarball_type=xz
arm_gcc_tarball_type=xz

# GCC dependencies tarball extensions
sh_gmp_tarball_type=bz2
sh_mpfr_tarball_type=bz2
sh_mpc_tarball_type=gz
sh_isl_tarball_type=bz2
arm_gmp_tarball_type=bz2
arm_mpfr_tarball_type=bz2
arm_mpc_tarball_type=gz
arm_isl_tarball_type=bz2

# Install mode (install-strip|install)
# Use 'install-strip' mode for removing debugging symbols of the toolchains
# Use 'install' to enable debug symbols for the toolchains. This may be
# useful only if you plan to debug the toolchain itself!
install_mode=install-strip

# MinGW/MSYS
# Define this if you want a standalone, no dependency binary (i.e. static)
# When the binary is standalone, it can be run outside MinGW/MSYS environment.
# This is NOT recommended. Use it if you know what you are doing.
#standalone_binary=1
