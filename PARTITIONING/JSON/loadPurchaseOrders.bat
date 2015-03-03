C:\app\oracle\product\12.1.0\dbhome_1\bin\SQLPLUS.exe JSON/JSON@PDB12102 @C:\xdb\Demo\PARTITIONING\JSON\sql\disableTrigger.sql
C:\app\oracle\product\12.1.0\dbhome_1\bin\SQLLDR.exe userid=JSON/JSON@PDB12102 control=C:\xdb\Demo\PARTITIONING\JSON\sampleData\loadPurchaseOrders.ctl log=C:\xdb\Demo\PARTITIONING\JSON\loadPurchaseOrders.log
@echo off
echo open localhost 21 > uploadLog.ftp
echo user JSON JSON >> uploadLog.ftp
echo cd /home/JSON/demonstrations/partitioning >> uploadLog.ftp
echo put C:\xdb\Demo\PARTITIONING\JSON\loadPurchaseOrders.log loadPurchaseOrders.log >> uploadLog.ftp
echo quit >> uploadLog.ftp
ftp -i -v -n -s:uploadLog.ftp
rm uploadLog.ftp
C:\app\oracle\product\12.1.0\dbhome_1\bin\SQLPLUS.exe JSON/JSON@PDB12102 @C:\xdb\Demo\PARTITIONING\JSON\sql\enableTrigger.sql

