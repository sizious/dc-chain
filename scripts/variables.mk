# Sega Dreamcast Toolchains Maker (dc-chain)
# This file is part of KallistiOS.
#
# Created by Jim Ursetto (2004)
# Initially adapted from Stalin's build script version 0.3.
#

# Handle web downloader
ifeq ($(force_downloader),)
  # Check if we are cURL or Wget...
  web_downloader_tester_curl := $(shell command -v curl)
  ifneq ($(web_downloader_tester_curl),)
    web_downloader = $(curl_cmd)
  else
    web_downloader_tester_wget := $(shell command -v wget)
    ifneq ($(web_downloader_tester_wget),)
      web_downloader = $(wget_cmd)
    else
      $(error You must have either Wget or cURL installed)
    endif
  endif
else
  ifeq ($(force_downloader),curl)
    web_downloader = $(curl_cmd)
  else ifeq ($(force_downloader),wget)
    web_downloader = $(wget_cmd)
  else
    $(error Only Wget or cURL are supported) 
  endif  
endif

# KOS Git root directory (contains kos/ and kos-ports/)
kos_root = $(CURDIR)/../../..

# kos_base is equivalent of KOS_BASE (contains include/ and kernel/)
kos_base = $(CURDIR)/../..

# Installation path for SH
sh_prefix    := $(toolchains_base)/$(sh_target)

# Installation path for ARM
arm_prefix   := $(toolchains_base)/$(arm_target)

# Various directories 
install       = $(prefix)/bin
pwd          := $(shell pwd)
patches      := $(pwd)/patches
logdir       := $(pwd)/logs

# Handling PATH environment variable
PATH         := $(sh_prefix)/bin:$(arm_prefix)/bin:$(PATH)
