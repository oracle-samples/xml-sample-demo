select xmlSerialize(
         DOCUMENT
         XDB_MONITOR.GETSTATISTICS()
         as CLOB INDENT SIZE = 2
       )
  from dual
/
