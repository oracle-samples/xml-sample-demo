load data
infile '%DEMODIRECTORY%/%USER%/install/2015.dat'
truncate
into table %DATA_STAGING_TABLE%
xmltype(XMLDATA) (
 filename filler char(999),
 XMLDATA  lobfile(filename) terminated by eof)

