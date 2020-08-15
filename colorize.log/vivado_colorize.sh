#!/bin/sh
#######################################################################################
##  Project    : Collect of various scripts for working with EDA-tools (ASIC/FPGA/etc)
##  Designer   : Dmitry Murzinov (kakstattakim@gmail.com)
##  Link       : https://github.com/iDoka/eda-scripts
##  Module     : Colorizer for Xilinx Vivado cli log
##  Description:
##  Usage      : use sed syntax below to add into your own build scripts and Makefiles
##  Revision   : $Rev
##  Date       : $LastChangedDate$
##  License    : MIT
#######################################################################################

FPGA_LOG=fpga.log

rm -rf $FPGA_LOG

vivado -nojournal -mode batch -source vivado.tcl | tee $FPGA_LOG | sed --unbuffered \
    -e '/\(^#.*\)/d' \
    -e "s/\('[\*\/._a-zA-Z0-9]*'\)/\o033[2m\1\o033[22m/g" \
    -e "s/\('[\*\/._a-zA-Z0-9]*\[[0-9]*\]'\)/\o033[2m\1\o033[22m/g" \
    -e 's/\(^|.*\)/\o033[1m\1\o033[0m/' \
    -e 's/\(^----.*\)/\o033[1m\1\o033[0m/' \
    -e 's/\(^====.*\)/\o033[1m\1\o033[0m/' \
    -e 's/\(^\+.*\)/\o033[1m\1\o033[0m/' \
    -e 's/\(^Phase.*\)/\o033[7m\1\o033[27m/' \
    -e 's/\(^Start.*\)/\o033[7m\1\o033[27m/' \
    -e 's/\(^WNS.*\)/\o033[36m\1\o033[39m/' \
    -e 's/\(^INFO.*\)/\o033[92m\1\o033[39m/' \
    -e 's/\(^WARNING.*\)/\o033[34m\1\o033[39m/' \
    -e 's/\(.*CRITICAL.*\)/\o033[35m\1\o033[39m/' \
    -e 's/\(^ERROR.*\)/\o033[31m\1\o033[39m/'
