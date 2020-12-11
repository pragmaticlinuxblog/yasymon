#!/usr/bin/env python3
"""
A program for obtaining CPU, RAM and Swap usage information for monitoring purposes.
"""
__docformat__ = 'reStructuredText'


import argparse
import psutil


def main():
    """
    Entry point into the program.
    """
    # Create argument parser object with description from file summary up top.
    parser = argparse.ArgumentParser(description=__doc__)
    # Add optional command line parameters.
    parser.add_argument('-cp', action='store_true', dest='cpu_usage_pct', default=False,
                        help='output CPU usage as a percentage')
    parser.add_argument('-cf', action='store_true', dest='cpu_frequency', default=False,
                        help='output CPU frequency in MHz')
    parser.add_argument('-ct', action='store_true', dest='cpu_temp', default=False,
                        help='output CPU temperature in degrees Celsius')
    parser.add_argument('-ru', action='store_true', dest='ram_usage', default=False,
                        help='output RAM usage in MB')
    parser.add_argument('-rt', action='store_true', dest='ram_total', default=False,
                        help='output RAM total in MB')
    parser.add_argument('-rp', action='store_true', dest='ram_usage_pct', default=False,
                        help='output RAM usage as a percentage')
    parser.add_argument('-su', action='store_true', dest='swap_usage', default=False,
                        help='output Swap usage in MB')
    parser.add_argument('-st', action='store_true', dest='swap_total', default=False,
                        help='output Swap total in MB')
    parser.add_argument('-sp', action='store_true', dest='swap_usage_pct', default=False,
                        help='output Swap usage as a percentage')

    # Perform actual command line parameter parsing.
    args = parser.parse_args()

    # Initialize resulting string to output.
    result = ''

    # Check if CPU usage percentage should be included.
    if args.cpu_usage_pct:
        result = '{}'.format(get_cpu_usage_pct())

    # Check if CPU frequency should be included.
    if args.cpu_frequency:
        # Add space if the result already contains a value
        if result:
            result += ' '
        result += '{}'.format(get_cpu_frequency())

    # Check if CPU temperature should be included.
    if args.cpu_temp:
        # Add space if the result already contains a value
        if result:
            result += ' '
        result += '{}'.format(get_cpu_temp())

    # Check if RAM usage in MB should be included.
    if args.ram_usage:
        # Add space if the result already contains a value
        if result:
            result += ' '
        result += '{}'.format(int(get_ram_usage() / 1024 / 1024))

    # Check if total available RAM in MB should be included.
    if args.ram_total:
        # Add space if the result already contains a value
        if result:
            result += ' '
        result += '{}'.format(int(get_ram_total() / 1024 / 1024))

    # Check if RAM usage in percent should be included.
    if args.ram_usage_pct:
        # Add space if the result already contains a value
        if result:
            result += ' '
        result += '{}'.format(get_ram_usage_pct())

    # Check if Swap usage in MB should be included.
    if args.swap_usage:
        # Add space if the result already contains a value
        if result:
            result += ' '
        result += '{}'.format(int(get_swap_usage() / 1024 / 1024))

    # Check if total available Swap in MB should be included.
    if args.swap_total:
        # Add space if the result already contains a value
        if result:
            result += ' '
        result += '{}'.format(int(get_swap_total() / 1024 / 1024))

    # Check if Swap usage in percent should be included.
    if args.swap_usage_pct:
        # Add space if the result already contains a value
        if result:
            result += ' '
        result += '{}'.format(get_swap_usage_pct())

    # Output the resulting string with values.
    print(result)


def get_cpu_usage_pct():
    """
    Obtains the system's average CPU load as measured over a period of 500 milliseconds.
    :returns: System CPU load as a percentage.
    :rtype: float
    """
    return psutil.cpu_percent(interval=0.5)


def get_cpu_frequency():
    """
    Obtains the real-time value of the current CPU frequency.
    :returns: Current CPU frequency in MHz.
    :rtype: int
    """
    return int(psutil.cpu_freq().current)


def get_cpu_temp():
    """
    Obtains the current value of the CPU temperature.
    :returns: Current value of the CPU temperature if successful, zero value otherwise.
    :rtype: float
    """
    # Initialize the result.
    result = 0.0
    # The first line in this file holds the CPU temperature as an integer times 1000.
    # Read the first line and remove the newline character at the end of the string.
    with open('/sys/class/thermal/thermal_zone0/temp') as f:
        line = f.readline().strip()
    # Test if the string is an integer as expected.
    if line.isdigit():
        # Convert the string with the CPU temperature to a float in degrees Celsius.
        result = float(line) / 1000
    # Give the result back to the caller.
    return result


def get_ram_usage():
    """
    Obtains the absolute number of RAM bytes currently in use by the system.
    :returns: System RAM usage in bytes.
    :rtype: int
    """
    return int(psutil.virtual_memory().total - psutil.virtual_memory().available)


def get_ram_total():
    """
    Obtains the total amount of RAM in bytes available to the system.
    :returns: Total system RAM in bytes.
    :rtype: int
    """
    return int(psutil.virtual_memory().total)


def get_ram_usage_pct():
    """
    Obtains the system's current RAM usage.
    :returns: System RAM usage as a percentage.
    :rtype: float
    """
    return psutil.virtual_memory().percent


def get_swap_usage():
    """
    Obtains the absolute number of Swap bytes currently in use by the system.
    :returns: System Swap usage in bytes.
    :rtype: int
    """
    return int(psutil.swap_memory().used)


def get_swap_total():
    """
    Obtains the total amount of Swap in bytes available to the system.
    :returns: Total system Swap in bytes.
    :rtype: int
    """
    return int(psutil.swap_memory().total)


def get_swap_usage_pct():
    """
    Obtains the system's current Swap usage.
    :returns: System Swap usage as a percentage.
    :rtype: float
    """
    return psutil.swap_memory().percent


if __name__ == "__main__":
    main()
