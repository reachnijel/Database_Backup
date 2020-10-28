Database Backup Deployement Steps
Prerequisite

Make sure the management node where the script is being deployed eg : Management node 1 have mysql client
Make sure the postgres client is installed in management node.
Step 1 : Create a backup folder
eg: mkdir /home/hdsuser/edlDBbackup

Step 2: Create config file for postgres in the home dir
eg: vi /home/hdsuser/.pgpass
enter the following line <hostname>:<port>:<schema>:<db user>:<db password>
eg : localhost:5432:ambari:ambari:bigdata

Step 3: Change the permission of the file to 600
eg : chmod 600 /home/hdsuser/.pgpass

Step 4 : Create the Mysql config file using mysql_config_editor tool
Execute the command for the db users for hive, rangerdba and rangerkms mysql_config_editor set --login-path=dbuser> --host=db host name --user=db user--password
eg :

    mysql_config_editor set --login-path=hive --host=azslvedlmgtdd01.d01saedl.manulife.com --user=hive --password
    mysql_config_editor set --login-path=rangerdba --host=azslvedlmgtdd01.d01saedl.manulife.com --user=rangerdba --password
    mysql_config_editor set --login-path=rangerkms --host=azslvedlmgtdd01.d01saedl.manulife.com --user=rangerkms --password

Step 5: Deploy the dbbackup.sh and provide execute access to the shell
eg copy the file dbbackup.sh under /home/hdsuser/bin

a. Update the variable in dbbackup.sh rhost with remote hostname . Make sure the host from which the cron job is executing have password less ssh configured to remote host
b. Update the variable in dbbackup.sh rbase with remote backup location. Make sure the backup folder exists in the remote host. In our example it is /home/hdsuser/edlDBbackup
Step 6: Create a cron job to schedule the execution of the job
crontab -e
enter the following entry in to cron tab eg for scheduling daily backup at 4:00 am
0 04 * * * /home/hdsuser/bin/dbbackup.sh /home/hdsuser/edlDBbackup/backup.log 2&1