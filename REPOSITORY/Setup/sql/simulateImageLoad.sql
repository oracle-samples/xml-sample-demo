
/* ================================================  
 *    
 * Copyright (c) 2016 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================ */

--
-- Simulate Loading images via protocols using Create Resource.
--
declare
  cursor getDocuments 
  is
  select '%HOMEFOLDER%/' || FILENAME FILENAME, CONTENT 
    from TABLE(
         XDBPM.AS_ZIP.unZip(
                             xdburitype('%DEMOCOMMON%/simulation/ImageLibrary.zip').getBlob(),NULL
                           )
       );
  V_RESULT BOOLEAN;
begin
  for d in getDocuments loop
  	if DBMS_XDB.existsResource(d.FILENAME) then
	    DBMS_XDB.deleteResource(d.FILENAME);
	    commit;
	  end if;
    V_RESULT := DBMS_XDB.createResource(d.FILENAME,d.CONTENT);
    commit;
  end loop;
end;

