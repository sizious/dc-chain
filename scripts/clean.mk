# Sega Dreamcast Toolchains Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

clean:
	-rm -rf build-newlib-$(sh_target)-$(newlib_ver)
	-rm -rf build-newlib-$(arm_target)-$(newlib_ver)
	-rm -rf build-gcc-$(sh_target)-$(sh_gcc_ver)
	-rm -rf build-gcc-$(arm_target)-$(arm_gcc_ver)
	-rm -rf build-binutils-$(sh_target)-$(sh_binutils_ver)
	-rm -rf build-binutils-$(arm_target)-$(arm_binutils_ver)
	-rm -rf build-$(gdb_name)
	-rm -rf build-$(insight_name)
	-rm -rf *.stamp
