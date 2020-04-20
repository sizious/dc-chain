# Sega Dreamcast Toolchain Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

gdb_name = gdb-$(gdb_ver)
gdb_file = $(gdb_name).tar.$(gdb_tarball_type)
gdb_url  = $(download_protocol)://ftp.gnu.org/gnu/gdb/$(gdb_file)

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

unpack_gdb: $(gdb_file) unpack_gdb_stamp patch_gdb_stamp

unpack_gdb_stamp:
	@echo "+++ Unpacking GDB..."
	rm -f $@
	rm -rf $(gdb_name)
	tar xf $(gdb_file)
	touch $@

patch_gdb_stamp:
	rm -f $@
ifdef MINGW
	patch -N -d $(gdb_name) -p1 < $(gdb_patches)
endif
	touch $@

build_gdb: log = $(logdir)/$(gdb_name).log
build_gdb: logdir
build_gdb: unpack_gdb build_gdb_stamp

build_gdb_stamp:
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
install_gdb: build_gdb install_gdb_stamp

install_gdb_stamp:
	@echo "+++ Installing GDB..."
	rm -f $@
	$(MAKE) -C build-$(gdb_name) install DESTDIR=$(DESTDIR) $(to_log)
	touch $@

gdb: install_gdb