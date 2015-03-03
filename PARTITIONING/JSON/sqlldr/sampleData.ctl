OPTIONS (DIRECT=TRUE)
load data
infile 'C:\xdb\Demo\PARTITIONING\JSON\sampleData\purchaseOrderFiles.dat'
append
into table SAMPLE_DATASET_PARTN 
xmltype(XMLDATA) (
 filename filler char(120),
 XMLDATA  lobfile(filename) terminated by eof)

