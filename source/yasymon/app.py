"""
Program for obtaining CPU, RAM and Swap usage information for monitoring purposes.
"""
__docformat__ = 'reStructuredText'

import sys
import os
import psutil


def main():
    """
    Entry point into the program.
    """
    # Display help info if no extra arguments were specified or just the '-h' one.
    if len(sys.argv) == 1 or (len(sys.argv) == 2 and sys.argv[1] == '-h'):
        display_help()

    # Initialize the resulting string to output.
    result = ''

    # Loop through all input arguments, just skipping the first one with the script name.
    for arg in sys.argv[1:]:
        # Process the argument and store the string related to the argument.
        arg_string = process_arg(arg)
        # Valid string returned?
        if arg_string:
            # Add a space to the resulting string if it already contains something.
            if result:
                result += ' '
            # Append argument related string to the resulting string.
            result += arg_string

    # Output the resulting string with values.
    print(result)


def display_help():
    """
    Displays program help and usage information.
    """
    print('usage: yasymon [-h] [-cp] [-cf] [-ct] [-ru] [-rt] [-rp] [-su] [-st] [-sp]')
    print()
    print('Program for obtaining CPU, RAM and Swap usage information for monitoring')
    print('purposes.')
    print()
    print('optional arguments:')
    print('  -h,         show this help message and exit')
    print('  -cp         output CPU usage as a percentage')
    print('  -cf         output CPU frequency in MHz')
    print('  -ct         output CPU temperature in degrees Celsius')
    print('  -ru         output RAM usage in MB')
    print('  -rt         output RAM total in MB')
    print('  -rp         output RAM usage as a percentage')
    print('  -su         output Swap usage in MB')
    print('  -st         output Swap total in MB')
    print('  -sp         output Swap usage as a percentage')


def process_arg(arg):
    """
    Processes a specific command line argument, excluding the '-h' one. Note that package argparse wasn't used on
    purpose, because then you cannot get info about the order in which the arguments were specified.
    :param arg: Command line argument to process.
    :returns: Output string related to the command line argument
    :rtype: string
    """
    # Initialize the result.
    result = ''

    # Argument to output CPU usage as a percentage?
    if arg.strip() == '-cp':
        result = '{}'.format(get_cpu_usage_pct())
    # Argument to output CPU frequency in MHz?
    elif arg.strip() == '-cf':
        result = '{}'.format(get_cpu_frequency())
    # Argument to output CPU temperature in degrees Celsius?
    elif arg.strip() == '-ct':
        result = '{}'.format(get_cpu_temp())
    # Argument to output RAM usage in MB?
    elif arg.strip() == '-ru':
        result = '{}'.format(int(get_ram_usage() / 1024 / 1024))
    # Argument to output RAM total in MB?
    elif arg.strip() == '-rt':
        result = '{}'.format(int(get_ram_total() / 1024 / 1024))
    # Argument to output RAM usage as a percentage?
    elif arg.strip() == '-rp':
        result = '{}'.format(get_ram_usage_pct())
    # Argument to output Swap usage in MB?
    elif arg.strip() == '-su':
        result = '{}'.format(int(get_swap_usage() / 1024 / 1024))
    # Argument to output Swap total in MB?
    elif arg.strip() == '-st':
        result = '{}'.format(int(get_swap_total() / 1024 / 1024))
    # Argument to output Swap usage as a percentage?
    elif arg.strip() == '-sp':
        result = '{}'.format(get_swap_usage_pct())

    # Give the result back to the caller.
    return result


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
    if os.path.isfile('/sys/class/thermal/thermal_zone0/temp'):
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
