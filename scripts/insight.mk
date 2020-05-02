# Sega Dreamcast Toolchains Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

insight_name = insight-$(insight_ver)a
insight_file = $(insight_name).tar.$(insight_tarball_type)
insight_url  = $(download_protocol)://sourceware.org/pub/insight/releases/$(insight_file)

stamp_insight_unpack = insight_unpack.stamp
stamp_insight_build = insight_build.stamp
stamp_insight_install = insight_install.stamp

$(insight_file):
	@echo "+++ Downloading Insight..."
	$(web_downloader) $(insight_url)

unpack_insight: $(insight_file) $(stamp_insight_unpack)

$(stamp_insight_unpack):
	@echo "+++ Unpacking Insight..."
	rm -f $@
	rm -rf $(insight_name)
	tar xf $(insight_file)
	touch $@

build_insight: log = $(logdir)/build-$(insight_name).log
build_insight: logdir
build_insight: unpack_insight $(stamp_insight_build)

$(stamp_insight_build):
	@echo "+++ Building Insight..."
	rm -f $@
	> $(log)
	rm -rf build-$(insight_name)
	mkdir build-$(insight_name)
	cd build-$(insight_name); \
        ../$(insight_name)/configure \
          --disable-werror \
          --prefix=$(sh_prefix) \
          --target=$(sh_target) \
          $(static_flag) \
          $(to_log)
	$(MAKE) $(makejobs) -C build-$(insight_name) $(to_log)
	touch $@

install_insight: log = $(logdir)/build-$(insight_name).log
install_insight: logdir
install_insight: build_insight $(stamp_insight_install)

$(stamp_insight_install):
	@echo "+++ Installing Insight..."
	rm -f $@
	$(MAKE) -C build-$(insight_name) install DESTDIR=$(DESTDIR) $(to_log)
	touch $@

insight: install_insight
