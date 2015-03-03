OPTIONS (DIRECT=FALSE)
load data
infile 'C:\xdb\Demo\PARTITIONING\JSON\sampleData\purchaseOrderFiles.dat'
append
into table PURCHASEORDER 
xmltype(XMLDATA) (
 filename filler char(120),
 XMLDATA  lobfile(filename) terminated by eof)

