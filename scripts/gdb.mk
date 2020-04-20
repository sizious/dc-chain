# Sega Dreamcast Toolchain Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

gdb_name = gdb-$(gdb_ver)
gdb_file = $(gdb_name).tar.$(gdb_tarball_type)
gdb_url  = $(download_protocol)://ftp.gnu.org/gnu/gdb/$(gdb_file)

stamp_gdb_unpack = gdb_unpack.stamp
stamp_gdb_patch = gdb_patch.stamp
stamp_gdb_build = gdb_build.stamp
stamp_gdb_install = gdb_install.stamp

# Under MinGW/MSYS, fixes are needed
ifdef MINGW
  gdb_patches := $(wildcard $(patches)/$(host_triplet)/$(gdb_name)*.diff)	
endif

$(gdb_file):
	@echo "+++ Downloading GDB..."
ifndef USE_CURL
	wget -c $(gdb_url)
else
	curl -O -J $(gdb_url)
endif

unpack_gdb: $(gdb_file) $(stamp_gdb_unpack) $(stamp_gdb_patch)

$(stamp_gdb_unpack):
	@echo "+++ Unpacking GDB..."
	rm -f $@
	rm -rf $(gdb_name)
	tar xf $(gdb_file)
	touch $@

$(stamp_gdb_patch):
	rm -f $@
ifdef MINGW
	patch -N -d $(gdb_name) -p1 < $(gdb_patches)
endif
	touch $@

build_gdb: log = $(logdir)/$(gdb_name).log
build_gdb: logdir
build_gdb: unpack_gdb $(stamp_gdb_build)

$(stamp_gdb_build):
	@echo "+++ Building GDB..."
	rm -f $@
	> $(log)
	rm -rf build-$(gdb_name)
	mkdir build-$(gdb_name)
	cd build-$(gdb_name); \
      ../$(gdb_name)/configure \
      --disable-werror \
      --prefix=$(sh_prefix) \
      --target=$(sh_target) \
      CC=$(CC) \
      $(static_flag) \
      $(to_log)
	$(MAKE) $(makejobs) -C build-$(gdb_name) $(to_log)
	touch $@

install_gdb: log = $(logdir)/$(gdb_name).log
install_gdb: logdir
install_gdb: build_gdb $(stamp_gdb_install)

$(stamp_gdb_install):
	@echo "+++ Installing GDB..."
	rm -f $@
	$(MAKE) -C build-$(gdb_name) install DESTDIR=$(DESTDIR) $(to_log)
	touch $@

gdb: install_gdb
