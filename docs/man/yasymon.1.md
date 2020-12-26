---
title: YASYMON
section: 1
header: User Manual
footer: yasymon 0.1.0
date: December 26, 2020
---

# NAME

yasymon - Program for obtaining CPU, RAM and Swap usage information.

# SYNOPSIS

**yasymon** [*OPTION*]...

# DESCRIPTION

**yasymon** is a command line program for obtaining CPU, RAM and Swap related system information.  
It can serve as a flexible building block for creating your own system monitor tool.

# OPTIONS
**-h** 
: display help message

**-cp** 
: output CPU usage as a percentage

**-cf** 
: output CPU frequency in MHz

**-ct** 
: output CPU temperature in degrees Celsius

**-ru** 
: output RAM usage in MB

**-rt** 
: output RAM total in MB

**-rp** 
: output RAM usage as a percentage

**-su** 
: output Swap usage in MB

**-st** 
: output Swap total in MB

**-sp** 
: output Swap usage as a percentage

# EXAMPLES
**yasymon**
: Displays usage information and then exits.

**yasymon -cp -ru -ct**
: Outputs CPU usage, RAM usage and CPU temperature, e.g. "12.5 2398 46.3"

# EXIT VALUES
**0**
: Success

# AUTHOR

Written by PragmaticLinux.

# REPORTING BUGS

Submit bug reports online at: <https://github.com/pragmaticlinuxblog/yasymon/issues>

# COPYRIGHT
Copyright (c) 2020 PragmaticLinux. License MIT: <https://opensource.org/licenses/MIT>  
This  is  free software: you are free to change and redistribute it. There is NO WARRANTY,  
to the extent permitted by law.

# SEE ALSO
Full documentation and sources at: <https://github.com/pragmaticlinuxblog/yasymon>


