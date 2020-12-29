# Generic and reusable Makefile for creating a standalone executable of a Python program,
# with the help of Shiv. The resulting standalone executuble can optionally be installed
# on the Linux system.
#
# Usage for installation:
#
#   make clean all
#   sudo make install
#
# Usage for removal:
#
#   sudo make uninstall
#
# While building the standalone executable with target 'all', a Python virtual
# environment is automatically created. All dependencies are installed into this virtual
# environment, including Shiv. Once done, Shiv creates the actual
# standalone executable.
#
# Note that the Shiv created standalone executable is a so called "zipapp". This means
# that it includes the Python program and its dependencies, but not the actual Python
# interpreter. So the Linux system where you want to run the standalone executable on,
# should have a Python interpreter installed. This is the case for pretty much all 
# Linux distributions.
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
# Using the Makefile assumes that you already installed Python and its development
# related packages on your Linux system:
# 
# * Debian:   sudo apt install make gcc python3 python3-dev virtualenv pandoc
# * Ubuntu:   sudo apt install make gcc python3 python3-dev virtualenv pandoc
# * Fedora:   sudo dnf install make gcc python3 python3-devel python3-virtualenv pandoc
# * openSUSE: sudo zypper install make gcc python3 python3-devel python3-virtualenv pandoc
#


#|---------------------------------------------------------------------------------------
#| Configure the program name
#|---------------------------------------------------------------------------------------
PROGNAME = yasymon


#|---------------------------------------------------------------------------------------
#| Set flags for the "pip" command
#|---------------------------------------------------------------------------------------
# During a build, Python package dependencies are downloaded from PyPi and installed into
# the Python virtual environment. This assumes the availability of an Internet
# connection during the build. This Makefile also supports offline builds, in case no
# Internet connection is available. For this you would first manually download the Python
# package dependencies and store them in a certain directory. Next, you specify this
# directory with the help of variable PYPACKDIR. For example when calling make:
# "make PYPACKDIR=../../SOURCES all"
# This automatically updates the PIP_FLAGS such that "pip" will not access the PyPi and
# instead look for the needed Python packages in directory PYPACKDIR.
ifneq ($(PYPACKDIR),)
PIP_FLAGS = --no-index --find-links=$(PYPACKDIR)
endif


#|---------------------------------------------------------------------------------------
#| Target "all"
#|---------------------------------------------------------------------------------------
# Command "make all" or simply just "make", because this is the first target in the
# makefile. This target creates a virtual environment in subdirectory "venv" and then
# attempts to install the python program into it, by running its setup.py. Next, it runs
# Shiv to create the standalone executable of your Python program. Once completed,
# you can test the resulting executable by running ./dist/<program name>. 
.PHONY: all
all: venv_build
	@echo "+++ Installing $(PROGNAME) into the virtual environment"
	venv/bin/pip3 install $(PIP_FLAGS) .
	@echo "+++ Creating subdirectory dist"
	mkdir dist
	@echo "+++ Creating $(PROGNAME) standalone executable with shiv"
	venv/bin/shiv -c $(PROGNAME) -o dist/$(PROGNAME) ./
	@echo "+++ Creating $(PROGNAME) man-page with pandoc"
	pandoc docs/man/$(PROGNAME).1.md -s -t man -o docs/man/$(PROGNAME).1
	@echo "+++ Completed setup of $(PROGNAME) into the virtual environment"


#|---------------------------------------------------------------------------------------
#| Target "clean"
#|---------------------------------------------------------------------------------------
# Command "make clean" removes the virtual environment and all files and directories
# that were created by Shiv.
.PHONY: clean
clean:
	@echo "+++ Cleaning build environment"
	rm -rf dist
	rm -rf venv
	rm -f docs/man/$(PROGNAME).1
	@echo "+++ Clean complete"  


#|---------------------------------------------------------------------------------------
#| Target "install"
#|---------------------------------------------------------------------------------------
# Command "sudo make install" installs the standalone executable of the Python program on
# the Linux system.  To test the installation first in a user directory, you can override
# the installation directory with variable $(DESTDIR). For example:
# "make DESTDIR=/tmp/testing install"
.PHONY: install
install:
	@echo "+++ Installing $(PROGNAME) into $(DESTDIR)/usr/bin/"
	mkdir -p $(DESTDIR)/usr/bin
	install -m 0755 dist/$(PROGNAME) $(DESTDIR)/usr/bin/$(PROGNAME)
	@echo "+++ Completed installation of $(PROGNAME)"


#|---------------------------------------------------------------------------------------
#| Target "uninstall"
#|---------------------------------------------------------------------------------------
# Command "sudo make uninstall" removes the previously installed standalone executable
# of the Python program from the Linux system. If the python program was previously
# installed in a user directory, you an override the location with variable $(DESTDIR). 
# For example:
# "make DESTDIR=/tmp/testing uninstall"
.PHONY: uninstall
uninstall:
	@echo "+++ Removing $(PROGNAME) from $(DESTDIR)/usr/bin/"
	rm -f $(DESTDIR)/usr/bin/$(PROGNAME)
	@echo "+++ Completed removal of $(PROGNAME)"

	
#|---------------------------------------------------------------------------------------
#| Target "venv_build"
#|---------------------------------------------------------------------------------------
# Internally used target for creating a virtual environment for building the standalone
# executable of the program, with the help of Shiv
.PHONY: venv_build
venv_build: venv/bin/shiv
	@echo "+++ Completed setup of the virtual environment"  

venv/bin/shiv: venv/bin/pip3
	@echo "+++ Installing shiv into the virtual environment"
	venv/bin/pip3 install $(PIP_FLAGS) shiv

venv/bin/pip3: 
	@echo "+++ Creating virtual environment in venv/"
	virtualenv --python=python3 venv

