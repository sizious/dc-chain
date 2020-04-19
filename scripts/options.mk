# If erase=1, erase build directories on the fly.
ifeq (1,$(erase))
  define clean_up
    @echo "+++ Cleaning up $(build)..."
    -rm -rf $(build)
  endef
  # Hack to clean up ARM gcc pass 1
  define clean_arm_hack
    @echo "+++ Cleaning up build-gcc-$(arm_target)-$(gcc_ver)..."
    -rm -rf build-gcc-$(arm_target)-$(gcc_ver)
  endef
endif

# If verbose=1, display output to screen as well as log files
ifeq (1,$(verbose))
  to_log = 2>&1 | tee -a $(log) && [ $$PIPESTATUS -eq 0 ]
else
  to_log = >> $(log) 2>&1
endif