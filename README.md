# Yasymon
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)  

Yasymon is a command line program for obtaining CPU, RAM and Swap related system information. It's name stands for Yet Another SYstem MONitor. It output the requested values on one line, separated by spaces. The idea is that Yasymon serves as a flexible building block for creating your own system monitor. Some ideas: 

- Quickly create a system visualization tool for the terminal with [Sampler](https://sampler.dev/).
- Capture real-time system information in an [InfluxDB](https://www.influxdata.com/) time series database and visualize with [Grafana](https://grafana.com/).
- Continuously collect system information in a log-file for a fixed amount of time with [logrotate](https://linux.die.net/man/8/logrotate).

For example, to obtain the CPU load as a percentage and the RAM usage in MB:

`yasymon -cp -ru`

Example output:

`9.4 3524`

The example outputs a CPU load of 9.4% and a RAM usage of 3524 MB.

Refer to the help information for a complete list of available command line options:

```
usage: yasymon [-h] [-cp] [-cf] [-ct] [-ru] [-rt] [-rp] [-su] [-st] [-sp]

A program for obtaining CPU, RAM and Swap usage information for monitoring
purposes.

optional arguments:
  -h,         show this help message and exit
  -cp         output CPU usage as a percentage
  -cf         output CPU frequency in MHz
  -ct         output CPU temperature in degrees Celsius
  -ru         output RAM usage in MB
  -rt         output RAM total in MB
  -rp         output RAM usage as a percentage
  -su         output Swap usage in MB
  -st         output Swap total in MB
  -sp         output Swap usage as a percentage
```

## Getting the code

To get the code, simple run the following command to clone the GIT repository to a subdirectory inside your own home directory: 

`git clone https://github.com/pragmaticlinuxblog/yasymon.git ~/yasymon`

This assumes GIT is installed on your Linux system. On Debian you would do this with command`sudo apt install git`.

## Building the code

This section outlines how to build the Yasymon code into a standalone binary, with the help of [PyInstaller](https://www.pyinstaller.org/). 

### Installing dependencies

Yasymon uses a package from PyPi. To not unnecessarily install this package on your Linux system, it is recommended to build the code in a Python virtual environment. Make sure the required software for this is installed on your system. On Debian you would do this with:

`sudo apt install python3 build-essential python3-dev python3-venv`

### Creating and activate the virtual environment

As a next step we create the virtual environment:

`python3 -m venv ~/venv/yasymon`

Once created, we can activate it:

`source ~/venv/yasymon/bin/activate`

### Installing requirements

With the virtual environment activated, we can go to the source code directory and install the required packages:

`cd ~/yasymon/source`

File *requirements.txt* lists all the packages Yasymon needs to run. To be able to install packages listed in this file, we also need packages `wheel` and  `setuptools`. Later on we also plan on creating a standalone binary, for which we need package `pyinstaller` . The following commands install these requirements automatically:

`pip install wheel setuptools pyinstaller -r requirements.txt`

### Building the standalone binary

With the help of PyInstaller we can create a standalone binary of the Yasymon program. This binary file itself back the Python interpreter and the needed packages. So basically one single executable file, which we can move around and even copy to other systems. Here's the command to create the Yasymon standalone binary:

`pyinstaller yasymon.py --onefile`

The resulting binary can be found at:

`~/yasymon/source/dist/yasymon`

### Installing the standalone binary

With the standalone binary created, we can now install it. Simply by copying it to directory `/usr/local/bin`. This makes Yasymon available to all users on the system:

`sudo cp ~/yasymon/source/dist/yasymon /usr/local/bin/yasymon`

### Clean up

With Yasymon built and installed, we can do a bit of housekeeping to remove the virtual environment and sources again. Let's start with deactivating the virtual environment:

`deactivate`

As a final step, we remove the virtual environment and the sources:

`cd ~`

`rm -rf ~/venv/yasymon ~/yasymon`

If you have no other virtual environments installed in the `venv` directory, you can also remove this one:

`rmdir ~/venv`