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

UCFNAME=`basename $1`
DOTCOUNT=`echo ${UCFNAME} | sed 's/[^.]//g' | awk '{ print length }'`
FILE=`basename $1 | cut -d. -f-${DOTCOUNT}`
DIR=`dirname $1`
# echo "${FILE}"

##### obsolete syntax (saved for references):
#sed '/^$/d;s/[\"=|;]//g;s/[\t]*//g;s/\ \{1,\}/\ /g;s/NET[ ]*\(.*\)[ ]*LOC[ ]*\([A-Z0-9]*\)[ ]*IOSTANDARD[ ]*\([_A-Z0-9]*\)[ ]*VCCAUX_IO[ ]*\([A-Z]*\)[ ]*SLEW[ ]*\([A-Z]*\)/set_property PACKAGE_PIN \2 \[get_ports \1\]\nset_property IOSTANDARD  \3 \[get_ports \1\]\nset_property VCCAUX_IO   \4 \[get_ports \1\]\nset_property SLEW        \5 \[get_ports \1\]\n\n/g' \
#  $FILE.ucf > $FILE.xdc


sed '/^$/d;s/[\"=|;]//g;s/[\t]*//g;s/\ \{1,\}/\ /g;s/NET[ ]*\(.*\)[ ]*LOC[ ]*\([A-Z0-9]*\)[ ]*IOSTANDARD[ ]*\([_A-Z0-9]*\)[ ]*VCCAUX_IO[ ]*\([A-Z]*\)[ ]*SLEW[ ]*\([A-Z]*\)/set_property -dict \{PACKAGE_PIN \2 \tIOSTANDARD \3 \tVCCAUX_IO \4 \tSLEW \5\} \[get_ports \1\];\n/g' \
  $1 > $DIR/$FILE.xdc
#  $FILE.ucf > $FILE.xdc

