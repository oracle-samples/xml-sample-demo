load data
infile '%DEMODIRECTORY%/%USER%/sqlldr/2015.dat'
truncate
into table %TABLE_NAME%
xmltype(XMLDATA) (
 filename filler char(999),
 XMLDATA  lobfile(filename) terminated by eof)

