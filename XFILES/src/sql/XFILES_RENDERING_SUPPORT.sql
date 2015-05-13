
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
create or replace package XFILES_RENDERING
authid DEFINER
as
  function renderAsHTML(P_SOURCE_DOC BLOB) return CLOB;
  function renderAsText(P_SOURCE_DOC BLOB) return CLOB;
end;
/
show errors
--
create or replace package body XFILES_RENDERING
as
--
function renderAsHTML(P_SOURCE_DOC BLOB) 
return CLOB
as
  V_HTML_CONTENT CLOB;
begin
  dbms_lob.createTemporary(V_HTML_CONTENT,true,DBMS_LOB.SESSION);
  ctx_doc.policy_filter(policy_name => 'XFILES_HTML_GENERATION',
                        document => P_SOURCE_DOC,
                        restab => V_HTML_CONTENT,
                        plaintext => false);
  return V_HTML_CONTENT;
end;
--
function renderAsText(P_SOURCE_DOC BLOB) 
return CLOB
as
  V_CONTENT CLOB;
begin
  dbms_lob.createTemporary(V_CONTENT,true,DBMS_LOB.SESSION);
  ctx_doc.policy_filter(policy_name => 'XFILES_HTML_GENERATION',
                        document => P_SOURCE_DOC,
                        restab => V_CONTENT,
                        plaintext => true);
  return V_CONTENT;
end;
--
end;
/
show errors
--