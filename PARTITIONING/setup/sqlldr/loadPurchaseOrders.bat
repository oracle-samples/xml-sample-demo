%ORACLEHOME%\bin\SQLPLUS.exe %USER%/%PASSWORD%@%TNSALIAS% @%DEMODIRECTORY%\%USER%\sql\disableTrigger.sql
%ORACLEHOME%\bin\SQLLDR.exe userid=%USER%/%PASSWORD%@%TNSALIAS% control=%DEMODIRECTORY%\%USER%\sampleData\loadPurchaseOrders.ctl log=%DEMODIRECTORY%\%USER%\loadPurchaseOrders.log
@echo off
echo open %HOSTNAME% %FTPPORT% > uploadLog.ftp
echo user %USER% %PASSWORD% >> uploadLog.ftp
echo cd %DEMOLOCAL% >> uploadLog.ftp
echo put %DEMODIRECTORY%\%USER%\loadPurchaseOrders.log loadPurchaseOrders.log >> uploadLog.ftp
echo quit >> uploadLog.ftp
ftp -i -v -n -s:uploadLog.ftp
rm uploadLog.ftp
%ORACLEHOME%\bin\SQLPLUS.exe %USER%/%PASSWORD%@%TNSALIAS% @%DEMODIRECTORY%\%USER%\sql\enableTrigger.sql
