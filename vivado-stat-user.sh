#!/bin/bash
#######################################################################################
##  Project    : Collect of various scripts for working with EDA-tools (ASIC/FPGA/etc)
##  Designer   : Dmitry Murzinov (kakstattakim@gmail.com)
##  Link       : https://github.com/iDoka/eda-scripts
##  Module     : Xilinx Vivado CPU and Memory usage statistic
##  Description: that prints CPU and Memory usage of current user instances of Vivado
##  Usage      : refer to vivado-stat.adoc for usage help
##  Revision   : $Rev
##  Date       : $LastChangedDate$
##  License    : MIT
#######################################################################################



CMD="vivado"
PERIOD="3s"

while true; do 
  IS_RUN=`ps -C ${CMD} -o comm= | head -1`
  #[ -n ${IS_RUN} ] || break
  if [ "${IS_RUN}" == "" ]; then
    break
  fi
  CPU=`ps -C ${CMD} -o user=,pcpu= | grep $USER | sed 's/\ \{1,\}/\ /g' | cut -d' ' -f2 | sed ':a;N;$!ba;s/\n/\+/g' | bc -l | cut -d. -f1 | sed 's/$/%/'`
  MEM=`ps -C ${CMD} -o user=,size= | grep $USER | sed 's/\ \{1,\}/\ /g' | cut -d' ' -f2 | sed 's/$/\/1024/g' | sed ':a;N;$!ba;s/\n/\+/g' | bc -l | cut -d. -f1 | sed 's/$/M/'`
  echo -e "$CPU\t$MEM"
  sleep ${PERIOD}
done

DATE=`date "+%H:%M %d.%m.%Y"`
echo "*** ${CMD} was finished running at ${DATE} ***"
