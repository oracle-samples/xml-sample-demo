OPTIONS (DIRECT=FALSE)
load data
infile '%DEMODIRECTORY%\%USER%\sampleData\purchaseOrderFiles.dat'
append
into table %TABLE1% 
xmltype(XMLDATA) (
 filename filler char(999),
 XMLDATA  lobfile(filename) terminated by eof)
