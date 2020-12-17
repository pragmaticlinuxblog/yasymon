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

## Installation

### Prerequisites

Before installing Yasymon, make sure that your Linux system has Python and Git development related packages installed. On Debian you would do this with:

`sudo apt install git python3 build-essential python3-dev python3-venv python3-pip`

### Getting the code

To get the code, run the following command to clone the Git repository to a subdirectory inside your own home directory: 

`git clone https://github.com/pragmaticlinuxblog/yasymon.git ~/yasymon`

### Python virtual environment

Because Yasymon depends on packages from the Python Package Index (PyPi), it is recommended to install Yasymon into a dedicated Python virtual environment, instead of directly in your system's Python environment. Otherwise it could eventually happen that another Python program installation needs to install a conflicting version of the same package from the PyPi.

Run the following commands to create a virtual environment and install Yasymon into it:

`cd ~/yasymon`

`sudo su`

`python3 -m venv /opt/venvs/yasymon`

`source /opt/venvs/yasymon/bin/activate`

`pip install wheel`

`pip install .`

`ln -s /opt/venvs/yasymon/bin/yasymon /usr/local/bin/yasymon`

`deactivate`

`exit`

All users on your system can now run Yasymon, simply by typing `yasymon` in the terminal.

### Clean up

After completing the Yasymon installation, you can remove the cloned Git repository:

`rm -rf ~/yasymon`

## Removal

Run the following commands to remove Yasymon from your system:

`sudo rm /usr/local/bin/yasymon`

`sudo rm -rf /opt/venvs/yasymon`