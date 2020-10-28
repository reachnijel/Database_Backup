#!/usr/bin/bash
# Backing up HDP cluster supporting databases
# Local host backup dir
echo "`date `: starting the db backup"
base=/home/hdsuser/edlDBbackup/
echo "Backup location $base"
# Remote host and its backup diri
#### modify this rhost with the host name of the node where dumps to archived###
rhost=azslvedlmgtdd02.d01saedl.manulife.com
echo "using remote host $rhost"
rbase=/home/hdsuser/edlDBbackup/
echo "remote backup loaction $rbase"
###############################################################################

dt=$(date +%Y%m%d)
dir=$base/$dt
mkdir -p $dir
echo "backup folder $dir"

########### DB Back up ####################
# pg password in ~/.pgpass
export PGPASSFILE=~/.pgpass
echo "executing ambari db backup"
pg_dump -U ambari ambari | gzip - > $dir/amb-db-$dt.sql.gz
if [ $? -eq 0 ]; then
    echo "executed postgres dump" 
else
    echo "postgres dump failed"
fi
# mysql passwords i
echo "executing  hive db backup "
mysqldump --login-path=hive -u hive hive | gzip - > $dir/hive-db-$dt.sql.gz
if [ $? -eq 0 ]; then
    echo "executed hive dump successfully"
else
    echo "hive dump failed"
fi

echo "executing ranger  db backup "
mysqldump --login-path=rangerdba -u rangerdba ranger | gzip - > $dir/ranger-db-$dt.sql.gz
if [ $? -eq 0 ]; then
    echo "executed ranger db  dump successfully"
else
    echo "ranger db dump failed"
fi

echo "executing rangerkms  db backup "
mysqldump --login-path=rangerkms -u rangerkms rangerkms | gzip - > $dir/rangerkms-db-$dt.sql.gz
if [ $? -eq 0 ]; then
    echo "executed rangerkms dump successfully"
else
    echo "rangerkms dump failed"
fi

#######################Copying the Backup to remote host########################
echo "copying backup to remote host "
scp -pr $dir $rhost:$rbase
if [ $? -eq 0 ]; then
    echo "copied db  dump to remote host  successfully"
else
    echo "db dump copy to remote host has failed"
fi
#keep only last 5 backups  
echo "$base removing old back up "
ls -td  $base/*/ | tail -n +6 |xargs -I {} rm  {}