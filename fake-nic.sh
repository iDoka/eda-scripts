#!/bin/bash
#######################################################################################
##  Project    : Collect of various scripts for working with EDA-tools (ASIC/FPGA/etc)
##  Designer   : Dmitry Murzinov (kakstattakim@gmail.com)
##  Link       : https://github.com/iDoka/eda-scripts
##  Module     : (Additional) NIC-adaptor creator
##  Description: create virtual NIC with manually specifyed HostID
##               (of course, pick any random MAC)
##  Usage      : refer to fake-nic.adoc for usage help
##  Revision   : $Rev
##  Date       : $LastChangedDate$
##  License    : MIT
#######################################################################################

# user should be a root
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root"
  exit 1
fi

# OS version detect
OS_VERSION=`uname -r | sed 's/[0-9.\-]*el\([0-9]*\)[a-zA-Z0-9_.]*/\1/g'`

# setup HostID and device
MAC="E4:7D:DE:AD:BE:EF"
DEV="eth1"

case $OS_VERSION in
6*) # RHEL/CentOS 6
  yum install -y tunctl
  tunctl -p -u root -t ${DEV}
  ifconfig ${DEV} hw ether ${MAC}
  ifconfig ${DEV} up
;;
7*) # RHEL/CentOS 7
  yum install -y bridge-utils
  ip tuntap add ${DEV} mode tap
  ifconfig ${DEV} hw ether ${MAC}
  ifconfig ${DEV} up
;;
*) # unsupported OS
  echo "Your OS is unsupported"
;;
esac

