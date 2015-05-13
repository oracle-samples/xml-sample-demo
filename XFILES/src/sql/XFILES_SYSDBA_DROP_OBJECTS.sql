
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
-- Drop objects related to the KML demo from the XDB Schema. 
-- This task must be performed with SYSDBA privileges
--
declare
  cursor getPublicSynonyms is
  select SYNONYM_NAME
    from ALL_SYNONYMS
   where OWNER = 'PUBLIC'
     and TABLE_OWNER = 'XDB'
     and SYNONYM_NAME in 
         (
            'MAP_POI_PLACEMARK',
            'KML_PLACEMARKS'
         );
begin
	for s in getPublicSynonyms loop
    execute immediate 'drop public synonym "' || s.SYNONYM_NAME || '"';
	end loop;
end;
/
declare
  cursor getLocalViews is
  select VIEW_NAME
    from ALL_VIEWS
   where OWNER = 'XDB'
     and VIEW_NAME in 
         (
            'MAP_POI_PLACEMARK',
            'KML_PLACEMARKS'
         );
begin
	for v in getLocalViews loop
    execute immediate 'drop view "XDB"."' || v.VIEW_NAME || '"';
	end loop;
end;
/
--