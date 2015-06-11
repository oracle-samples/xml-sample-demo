OPTIONS (DIRECT=TRUE)
load data
infile '%DEMODIRECTORY%\%USER%\sampleData\purchaseOrderFiles.dat'
append
into table %DATA_STAGING_TABLE% 
xmltype(XMLDATA) (
 filename filler char(999),
 XMLDATA  lobfile(filename) terminated by eof)
