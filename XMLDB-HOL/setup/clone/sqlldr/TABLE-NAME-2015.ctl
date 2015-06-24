-- OPTIONS (DIRECT=TRUE)
load data
infile '%DEMODIRECTORY%/%USER%/sqlldr/2015.dat'
truncate
into table %TABLE_NAME%
xmltype(XMLDATA) (
 filename filler char(120),
 XMLDATA  lobfile(filename) terminated by eof)

