# gcc-pass2
$(build_gcc_pass2): log = $(logdir)/$(build)-pass2.log
$(build_gcc_pass2): logdir
	@echo "+++ Building $(src_dir) to $(build) (pass 2)..."
	-mkdir -p $(build)
	> $(log)
	cd $(build); \
        ../$(src_dir)/configure \
          --target=$(target) \
          --prefix=$(prefix) \
          --with-newlib \
          --disable-libssp \
          --disable-tls \
          --enable-threads=$(thread_model) \
          --enable-languages=$(pass2_languages) \
          --enable-checking=release \
          $(extra_configure_args) \
          $(macos_gcc_configure_args) \
          CC=$(CC) \
          CXX=$(CXX) \
#          CC_FOR_TARGET=$(CC_FOR_TARGET) \
#          CXX_FOR_TARGET=$(CXX_FOR_TARGET) \
          $(static_flag) \
          $(to_log)
	$(MAKE) $(makejobs) -C $(build) DESTDIR=$(DESTDIR) $(to_log)
	$(MAKE) -C $(build) $(install_mode) DESTDIR=$(DESTDIR) $(to_log)
	$(clean_up)