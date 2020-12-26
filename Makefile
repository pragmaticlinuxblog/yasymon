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
# While building the standalone executable with target 'all', a Python virtual
# environment is automatically created. All dependencies are installed into this virtual
# environment, including PyInstaller. Once done, PyInstaller creates the actual
# standalone executable.
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
	venv/bin/pip3 install .
	@echo "+++ Creating $(PROGNAME) standalone executable with pyinstaller"
	venv/bin/pyinstaller --onefile venv/bin/$(PROGNAME)
	@echo "+++ Creating $(PROGNAME) man-page with pandoc"
	pandoc docs/man/$(PROGNAME).1.md -s -t man -o docs/man/$(PROGNAME).1
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

venv/bin/pyinstaller: venv/bin/pip3
	@echo "+++ Installing pyinstaller into the virtual environment"
	venv/bin/pip3 install pyinstaller

venv/bin/pip3: 
	@echo "+++ Creating virtual environment in venv/"
	virtualenv --python=python3 venv

