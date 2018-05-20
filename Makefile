
PHONY := _all
_all:

ifeq ("$(origin V)", "command line")
  KBUILD_VERBOSE = $(V)
endif
ifndef KBUILD_VERBOSE
  KBUILD_VERBOSE = 0
endif

ifeq ($(KBUILD_VERBOSE),1)
  Q =
else
  Q = @
endif

ARCH := x86

srctree = .

KBUILD_MODULES :=
KBUILD_BUILTIN := 1

export Q 
export ARCH 
export srctree 
export KBUILD_MODULES KBUILD_BUILTIN

# SHELL used by kbuild
CONFIG_SHELL := $(shell if [ -x "$$BASH" ]; then echo $$BASH; \
	  else if [ -x /bin/bash ]; then echo /bin/bash; \
	  else echo sh; fi ; fi)

HOST_LFS_CFLAGS := $(shell getconf LFS_CFLAGS)
HOST_LFS_LDFLAGS := $(shell getconf LFS_LDFLAGS)
HOST_LFS_LIBS := $(shell getconf LFS_LIBS)

HOSTCC       = gcc
HOSTCXX      = g++
HOSTCFLAGS   := -Wall -Wmissing-prototypes -Wstrict-prototypes -O2 \
		-fomit-frame-pointer -std=gnu89 $(HOST_LFS_CFLAGS)
HOSTCXXFLAGS := -O2 $(HOST_LFS_CFLAGS)
HOSTLDFLAGS  := $(HOST_LFS_LDFLAGS)
HOST_LOADLIBES := $(HOST_LFS_LIBS)

export CONFIG_SHELL
export HOSTCC HOSTCFLAGS 
export HOSTCXX HOSTCXXFLAGS
export HOSTLDFLAGS HOST_LOADLIBES

# We need some generic definitions (do not try to remake the file).
scripts/Kbuild.include: ;
include scripts/Kbuild.include

# ===========================================================================
# Rules shared between *config targets and build targets

# Basic helpers built in scripts/basic/
PHONY += scripts_basic
scripts_basic:
	$(Q)$(MAKE) $(build)=scripts/basic
	$(Q)rm -f .tmp_quiet_recordmcount

# To avoid any implicit rule to kick in, define an empty command.
scripts/basic/%: scripts_basic ;

include arch/$(ARCH)/Makefile

%config: scripts_basic FORCE
	$(Q)$(MAKE) $(build)=scripts/kconfig $@

PHONY += FORCE
FORCE:

# Declare the contents of the .PHONY variable as phony.  We keep that
# information in a variable so we can use it in if_changed and friends.
.PHONY: $(PHONY)

