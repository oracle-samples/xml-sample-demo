#! /bin/sh
DBAPWD=${1}
USERPWD=${2}
DBA=${3:-system}
USER=${4:-%USER%}
sqlplus -L ${DBA}/${DBAPWD} @"0.0 setupLab.sql" ${USER} ${USERPWD}
sqlldr -userid=${USER}/${USERPWD} -control=%HOLDIRECTORY%/install/%DATA_STAGING_TABLE%.ctl -log=%DATA_STAGING_TABLE%.log
cat %DATA_STAGING_TABLE%.log
sqlplus -L ${USER}/${USERPWD} @"0.0 resetLab.sql" 
