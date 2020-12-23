# Generic and reusable Makefile for creating a standalone executable of a Python program,
# with the help of PyInstaller. The resulting standalone executuble can optionally be
# installed on the Linux system.
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
# While buildng the standalone executable with target 'all', a Python virtual environment
# is automatically created. All dependencies are installed into this virtual environment,
# including PyInstaller. Once done, PyInstaller creates the actual standalone executable.

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
# related packages on your Linux system. Example for Debian/Ubuntu:
#
#   sudo apt install build-essential python3 python3-dev python3-venv
#


#|---------------------------------------------------------------------------------------
#| Configure the program name
#|---------------------------------------------------------------------------------------
PROGNAME=yasymon


#|---------------------------------------------------------------------------------------
#| Target "all"
#|---------------------------------------------------------------------------------------
# Command "make all" or simply just "make", because this is the first target in the
# makefile. This target creates a virtual environment in subdirectory "venv" and then
# attempts to install the python program into it, by running its setup.py. Next, it runs
# PyInstaller to create the standalone executable of your Python program. Once completed,
# you can test the resulting executable by running ./dist/<program name>.
.PHONY: all
all: venv_build
	@echo "+++ Installing $(PROGNAME) into the virtual environment"
	venv/bin/pip install .
	@echo "+++ Creating $(PROGNAME) standalone executable with PyInstaller"
	venv/bin/pyinstaller --onefile venv/bin/$(PROGNAME)
	@echo "+++ Completed setup of $(PROGNAME) into the virtual environment"


#|---------------------------------------------------------------------------------------
#| Target "clean"
#|---------------------------------------------------------------------------------------
# Command "make clean" removes the virtual environment and all files and directories
# that were created by PyInstaller.
.PHONY: clean
clean:
	@echo "+++ Cleaning build environment"
	rm -rf build
	rm -rf dist
	rm -rf venv
	rm -f $(PROGNAME).spec
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
	cp dist/$(PROGNAME) $(DESTDIR)/usr/bin/$(PROGNAME)
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
# executable of the program, with the help of PyInstaller
.PHONY: venv_build
venv_build: venv/bin/pyinstaller
	@echo "+++ Completed setup of the virtual environment"  

venv/bin/pyinstaller: venv/bin/wheel
	@echo "+++ Installing wheel into the virtual environment"
	venv/bin/pip install pyinstaller

venv/bin/wheel: venv/bin/pip
	@echo "+++ Installing wheel into the virtual environment"
	venv/bin/pip install wheel

venv/bin/pip: 
	@echo "+++ Creating virtual environment in venv/"
	python3 -m venv venv
	

