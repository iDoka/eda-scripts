#!/bin/sh
#######################################################################################
##  Project    : Collect of various scripts for working with EDA-tools (ASIC/FPGA/etc)
##  Designer   : Dmitry Murzinov (kakstattakim@gmail.com)
##  Link       : https://github.com/iDoka/eda-scripts
##  Module     : Build-in revision number into FPGA-image
##  Description:
##  Usage      : refer to vergen-fpga.adoc for usage help
##  Revision   : $Rev
##  Date       : $LastChangedDate$
##  License    : MIT
#######################################################################################


################################################################
##### $1 - filename.mcs FPGA image
##### Please specify correct Addresses, total length is 20 byte:
#####     4 byte - data stamp and
#####    16 byte - MD5 signature
################################################################


ADDRESS1=0xF800
ADDRESS2=0xF814

FILENAME=`echo $1 | cut -d. -f1`

FPGAIMAGE=fpgaimage.hex


######### Setup output format #############
case $OS_VERSION in
### For Intel ihex ###
[iI]*)
  FORMAT=intel
  FILEEXT=hex
;;
### For Motorola s-rec ###
[mM]*)
  FORMAT=motorola
  FILEEXT=srec
;;
*) # unsupported options
  echo "Incorrect specifyed options!"
  echo "Allovable values for specify output format is [I]ntel or [M]otorolla"
;;
esac


### Converting to Intel ihex ###
promgen -p hex -r $1 -o $FPGAIMAGE
echo Date:  `stat $1 --format=%z`
DATEIMAGE=`stat $1 --format=%Z`
CHECKSUM=`md5sum $1 | cut -d' ' -f1`
FWSTRING=`printf "0x%x%s" $DATEIMAGE $CHECKSUM | sed -e :a -e 's/\(.*[0-9a-f]\)\([0-9a-f]\{2\}\)/\1 0x\2/;ta'`


srec_cat -generate $ADDRESS1 $ADDRESS2 -repeat-data $FWSTRING $FPGAIMAGE -exclude $ADDRESS1 $ADDRESS2 -output ${FILENAME}.${FILEEXT} -${FORMAT} && echo "...Done!"
