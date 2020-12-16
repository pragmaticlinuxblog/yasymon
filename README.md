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

To get the code, run the following command to clone the GIT repository to a subdirectory inside your own home directory: 

`git clone https://github.com/pragmaticlinuxblog/yasymon.git ~/yasymon`

This assumes GIT is installed on your Linux system. On Debian you would do this with command `sudo apt install git`.

## Installation

### Prerequisites

Before installing Yasymon, make sure that your Linux system has Python development related packages installed. On Debian you would do this with:

`sudo apt install python3 build-essential python3-dev python3-venv`

### Install system-wide

To install Yasymon on your system, go to the directory where the file `setup.py` is located and install with `pip`. For example on Debian:

`cd ~/yasymon`

`pip install .`

Note that this installs both Yasymon and all its dependent packages on your system. If you do not want this, read on about how to install in a virtual environment.

### Install in a virtual environment

First create the virtual environment and activate it:

`python3 -m venv ~/venv/yasymon`

`source ~/venv/yasymon/bin/activate`

Next, install Yasymon into the virtual environment:

`cd ~/yasymon`

`pip install .`

You can now start Yasymon with the `yasymon` command inside your virtual environment.

To exit the virtual environment, run:

`deactivate`

### Building a standalone binary

With the help of PyInstaller you can create a standalone binary of the Yasymon program. This binary file itself packs the Python interpreter and the needed packages. So basically one single executable file, which you can move around and even copy to other systems. This has the following benefits:

* The Python packages, which Yasymon depends on, are not installed on your system.
* In case you went with the virtual environment approach, you do not need to activate a virtual environment each time you want to run Yasymon.

Make sure you created a virtual environment and activated it, as described above and that you installed Yasymon into it. Next, install PyInstaller into the virtual environment:

`pip install pyinstaller`

To create the standalone executable, run the following commands:

`cd ~/yasymon`

`pyinstaller yasymon/app.py --name yasymon --onefile`

The resulting binary can be found at:

`~/yasymon/dist/yasymon`

#### Installing the standalone binary

With the standalone binary created, you can now install it, simply by copying it to directory `/usr/local/bin`. This makes Yasymon available to all users on the system:

`sudo cp ~/yasymon/dist/yasymon /usr/local/bin/yasymon`

#### Clean up

With Yasymon built as a standalone executable and installed, you can do a bit of housekeeping to remove the virtual environment and sources again. Start with deactivating the virtual environment:

`deactivate`

As a final step, remove the virtual environment and the sources:

`cd ~`

`rm -rf ~/venv/yasymon ~/yasymon`

If you have no other virtual environments installed in the `venv` directory, you can also remove this one:

`rmdir ~/venv`

