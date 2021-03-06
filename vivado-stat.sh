#!/bin/bash
#######################################################################################
##  Project    : Collect of various scripts for working with EDA-tools (ASIC/FPGA/etc)
##  Designer   : Dmitry Murzinov (kakstattakim@gmail.com)
##  Link       : https://github.com/iDoka/eda-scripts
##  Module     : Xilinx Vivado CPU and Memory usage statistic
##  Description: that prints CPU and Memory usage of all instances of Vivado tools
##  Usage      : refer to vivado-stat.adoc for usage help
##  Revision   : $Rev
##  Date       : $LastChangedDate$
##  License    : MIT
#######################################################################################


CMD="vivado"
PERIOD="1s"

#PID=`ps aux | grep ${CMD} | grep lnx64.o | sed 's/\ \{1,\}/\ /g' | cut -d' ' -f2`
PIDS=`ps aux | grep ${CMD} | grep lnx64.o | sed 's/\ \{1,\}/\ /g' | cut -d' ' -f2 | sed ':a;N;$!ba;s/\n/\,/g'`

while true; do
  IS_RUN=`ps -C ${CMD} -o comm= | head -1`
  #[ -n ${IS_RUN} ] || break
  if [ "${IS_RUN}" == "" ]; then
    break
  fi
  #CPU=`ps -C ${CMD} -o pcpu= | sed ':a;N;$!ba;s/\n/\+/g' | bc -l | cut -d. -f1 | sed 's/$/%/'`
  #CPU=`top -p ${PID} -n1 | awk '{if (NR==8) print $10 }' | cut -d. -f1 | sed 's/$/%/'`
  CPU=`top -p ${PIDS} -n1 | awk '{if (NR>=8) print $10 }' | sed '/^$/d' | sed ':a;N;$!ba;s/\n/\+/g' | bc -l | cut -d. -f1 | sed 's/$/%/'`
  MEM=`ps -C ${CMD} -o size= | sed 's/$/\/1024/g' | sed ':a;N;$!ba;s/\n/\+/g' | bc -l | cut -d. -f1 | sed 's/$/M/'`
  echo -e "$CPU\t$MEM"
  sleep ${PERIOD}
done

DATE=`date "+%H:%M %d.%m.%Y"`
echo "*** ${CMD} was finished running at ${DATE} ***"

