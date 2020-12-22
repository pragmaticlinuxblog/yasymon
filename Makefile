# Generic and reusable Makefile for build testing and system-wide installation of a
# Python program into its own dedicated virtual environment. This includes the automatic
# installation of package dependencies, for example from PyPi, into the virtual
# environment.
#
# The installation creates a symlink in /usr/bin/<program name> to make the Python
# program conveniently available to all users.
#
# This Makefile should be stored in the same directory as where your Python program's
# "setup.py" file is located. 
#
# The Makefile offers the usual targets: "all", "clean", "install" and "uninstall", as 
# you normally expect for a C/C++ program. The idea behind this is that it will make
# DEB and RPM packaging easier.
#
# The only change you need to make, is configuring the name of your Python program
# in variable PROGNAME at the top of this file.
#
# Using the Makefile assumes that you already installed Python and general development
# related packages on your system. Example for Debian/Ubuntu:
#
#   sudo apt install make gcc python3 python3-dev python3-venv
#


#|---------------------------------------------------------------------------------------
#| Configure the program name
#|---------------------------------------------------------------------------------------
PROGNAME=yasymon


#|---------------------------------------------------------------------------------------
#| Target "all"
#|---------------------------------------------------------------------------------------
# Command "make all" or simply just "make", because this is the first target in the
# makefile.
# This target creates a virtual environment in subdirectory "venv" and then attempts
# to install the python program into it, by running its setup.py. Can be used to see
# if errors occur, prior to the actual system installation with target "install".
# Once completed, you can test the python program by running ./venv/bin/<program name>.
.PHONY: all
all: venv_build
	@echo "+++ Installing $(PROGNAME) into the virtual environment"
	venv/bin/pip install .
	@echo "+++ Completed setup of $(PROGNAME) into the virtual environment"


#|---------------------------------------------------------------------------------------
#| Target "clean"
#|---------------------------------------------------------------------------------------
# Command "make clean" removes the virtual environment, including all the packages that
# were installed into it by target "all".
.PHONY: clean
clean:
	@echo "+++ Cleaning build environment"
	rm -rf venv
	@echo "+++ Clean complete"  


#|---------------------------------------------------------------------------------------
#| Target "install"
#|---------------------------------------------------------------------------------------
# Command "sudo make install" installs the python program on the Linux system. It creates
# a virtual environment in /usr/lib/<program name>/venv/ and installs the python
# program and all its dependencies into it. To make the python program available on the
# path, a symlink is created in /usr/bin/<program name>. 
# To test the installation first in a user directory, you can override the installation
# directory with variable $(DESTDIR). For example:
# "make DESTDIR=/tmp/testing install"
.PHONY: install
install: venv_dist
	@echo "+++ Installing $(PROGNAME) into $(DESTDIR)/usr/lib/$(PROGNAME)/venv/"
	$(DESTDIR)/usr/lib/$(PROGNAME)/venv/bin/pip install .
	@echo "+++ Creating symlink $(DESTDIR)/usr/bin/$(PROGNAME)"
	mkdir -p $(DESTDIR)/usr/bin
	ln -sf ../lib/$(PROGNAME)/venv/bin/$(PROGNAME) $(DESTDIR)/usr/bin/$(PROGNAME)
	@echo "+++ Completed installation of $(PROGNAME)"


#|---------------------------------------------------------------------------------------
#| Target "uninstall"
#|---------------------------------------------------------------------------------------
# Command "sudo make uninstall" removes the previously installed python program from the
# Linux system. 
# If the python program was previously installed in a user directory, you an override the
# location with variable $(DESTDIR). For example:
# "make DESTDIR=/tmp/testing uninstall"
.PHONY: uninstall
uninstall:
	@echo "+++ Removing symlink $(DESTDIR)/usr/bin/$(PROGNAME)"
	rm -f $(DESTDIR)/usr/bin/$(PROGNAME)
	@echo "+++ Removing $(DESTDIR)/usr/lib/$(PROGNAME)"
	rm -rf $(DESTDIR)/usr/lib/$(PROGNAME)
	@echo "+++ Completed removal of $(PROGNAME)"

	
#|---------------------------------------------------------------------------------------
#| Target "venv_build"
#|---------------------------------------------------------------------------------------
# Internally used target for creating a virtual environment for building and testing
# the setup script of the python program.
.PHONY: venv_build
venv_build: venv/bin/wheel
	@echo "+++ Completed setup of the virtual environment"  

venv/bin/wheel: venv/bin/pip
	@echo "+++ Installing wheel into the virtual environmnet"
	venv/bin/pip install wheel

venv/bin/pip: 
	@echo "+++ Creating virtual environment in venv/"
	python3 -m venv venv
	
	
#|---------------------------------------------------------------------------------------
#| Target "venv_dist"
#|---------------------------------------------------------------------------------------
# Internally used target for creating a virtual environment for the actual installation
# of the python program.
.PHONY: venv_dist
venv_dist: $(DESTDIR)/usr/lib/$(PROGNAME)/venv/bin/wheel
	@echo "+++ Completed setup of the virtual environment"  

$(DESTDIR)/usr/lib/$(PROGNAME)/venv/bin/wheel: $(DESTDIR)/usr/lib/$(PROGNAME)/venv/bin/pip
	@echo "+++ Installing wheel into the virtual environmnet"
	$(DESTDIR)/usr/lib/$(PROGNAME)/venv/bin/pip install wheel

$(DESTDIR)/usr/lib/$(PROGNAME)/venv/bin/pip: 
	@echo "+++ Creating virtual environment in $(DESTDIR)/usr/lib/$(PROGNAME)/venv/"
	python3 -m venv $(DESTDIR)/usr/lib/$(PROGNAME)/venv

