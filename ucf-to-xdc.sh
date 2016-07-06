#!/bin/bash
#######################################################################################
##  Project    : Collect of various scripts for working with EDA-tools (ASIC/FPGA/etc)
##  Designer   : Dmitry Murzinov (kakstattakim@gmail.com)
##  Link       : https://github.com/iDoka/eda-scripts
##  Module     : sdc -> xdc converter
##  Description: for Xilinx tools: that convert ISE-style to Vivado-style constraints
##  Usage      : refer to ucf-to-xdc.adoc for usage help
##  Revision   : $Rev
##  Date       : $LastChangedDate$
##  License    : MIT
#######################################################################################


FILE=`basename $1 | cut -d. -f1`
# echo "${FILE}"

sed '/^$/d;s/[\"=|;]//g;s/[\t]*//g;s/\ \{1,\}/\ /g;s/NET[ ]*\(.*\)[ ]*LOC[ ]*\([A-Z0-9]*\)[ ]*IOSTANDARD[ ]*\([_A-Z0-9]*\)[ ]*VCCAUX_IO[ ]*\([A-Z]*\)[ ]*SLEW[ ]*\([A-Z]*\)/set_property PACKAGE_PIN \2 \[get_ports \1\]\nset_property IOSTANDARD  \3 \[get_ports \1\]\nset_property VCCAUX_IO   \4 \[get_ports \1\]\nset_property SLEW        \5 \[get_ports \1\]\n\n/g' \
  $FILE.ucf > $FILE.xdc

