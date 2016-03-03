
/* ================================================  
 * Oracle XFiles Demonstration.  
 *    
 * Copyright (c) 2014 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================
 */

--
create or replace view XMLINDEX_LIST of XMLTYPE
with object id
(
  'XMLINDEX_LIST'
)
as 
select xmlelement(
         "indexList",
         (
           select xmlelement(
                    "localIndexes",
                    xmlagg(
                      xmlelement(
                        "index",
                        xmlElement("indexName", INDEX_NAME),
                        xmlElement("tableName", uxi.TABLE_NAME),
			                  xmlElement("owner", TABLE_OWNER),
			                  xmlElement("pathTableName",PATH_TABLE_NAME),
			                  xmlElement("uploadFolder",XDB_TABLE_UPLOAD.getUploadFolderPath(TABLE_NAME)),
			                  xmlElement("Parameters",PARAMETERS),
                        xmlElement("Asynchronous",ASYNC),
                        xmlElement("StaleOperation",STALE),
                        xmlElement("PendingRowTable",PEND_TABLE_NAME)
                      )
                    )
                  )
             from user_xml_indexes uxi 
         ),
         (
           select xmlelement(
                    "globalIndexes",
                    xmlagg(
                      xmlelement(
                        "index",
                        xmlElement("indexName", INDEX_NAME),
                        xmlElement("indexOwner", INDEX_OWNER),
                 			  xmlElement("tableName", TABLE_NAME),
			                  xmlElement("owner", TABLE_OWNER),
			                  xmlElement("pathTableName",PATH_TABLE_NAME),
			                  xmlElement("uploadFolder",XDB_TABLE_UPLOAD.getUploadFolderPath(TABLE_NAME,TABLE_OWNER)),
			                  xmlElement("Parameters",PARAMETERS),
                        xmlElement("Asynchronous",ASYNC),
                        xmlElement("StaleOperation",STALE),
                        xmlElement("PendingRowTable",PEND_TABLE_NAME)
			                )
                    )
                  )
             from all_xml_indexes axi
            where INDEX_OWNER <> USER
         )
       ) 
  from dual
/
create or replace trigger XMLINDEX_LIST_DML
instead of INSERT or UPDATE or DELETE on XMLINDEX_LIST
begin
 null;
end;
/
grant select on XMLINDEX_LIST 
             to public
/
--