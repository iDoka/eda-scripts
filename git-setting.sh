#!/bin/bash
#######################################################################################
##  Project    : Collect of various scripts for working with EDA-tools (ASIC/FPGA/etc)
##  Designer   : Dmitry Murzinov (kakstattakim@gmail.com)
##  Link       : https://github.com/iDoka/eda-scripts
##  Module     : git-setting.sh
##  Description: Initial git settings of repository
##  Usage      : refer to git-setting.adoc for usage help
##  Revision   : $Rev
##  Date       : $LastChangedDate$
##  License    : MIT
#######################################################################################



#### check passing path
if [ -z "$1" ]; then
    echo "No path to repository supplied. Exit."
    exit 1
fi

###### variables
CWD=`pwd`
GIT_DIR=$1

GIT_USER=`finger $USER | head -1 | cut -d: -f3 | sed 's/^[ ]*//'`
GIT_MAIL=${USER}@${HOSTNAME}.com


########## assembly .gitignore
rm -f ${GIT_DIR}/.gitignore
for f in gitignore/*.gitignore
  do
  sed '1,8d' $f | cat >> ${GIT_DIR}/.gitignore
done

########## assembly .gitattributes
rm  -f ${GIT_DIR}/.gitattributes
for f in gitattributes/*.gitattributes
  do
  sed '1,8d' $f | cat >> ${GIT_DIR}/.gitattributes
done

########## git repo setting
cd ${GIT_DIR}
git init
git config user.name  "${GIT_USER}"
git config user.email  ${GIT_MAIL}
git config color.ui true
git config format.pretty oneline
git add .gitattributes .gitignore
git commit -m "[git] settings was added"
cd ${CWD}

echo "Done!"
