
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

create or replace VIEW XDBPM_ALL_TYPES
as 
select OWNER,                      
       TYPE_NAME,                  
       TYPE_OID,                   
       TYPECODE,                   
       ATTRIBUTES,                 
       METHODS,                    
       PREDEFINED,                 
       INCOMPLETE,                 
       FINAL,                      
       INSTANTIABLE,               
       SUPERTYPE_OWNER,            
       SUPERTYPE_NAME,             
       LOCAL_ATTRIBUTES,           
       LOCAL_METHODS,              
       TYPEID   
  from ALL_TYPES
/
show errors
--
grant all on XDBPM.XDBPM_ALL_TYPES to public
/
create or replace VIEW XDBPM_ALL_TYPE_ATTRS
as 
select OWNER,
       TYPE_NAME,
       ATTR_NAME,
       ATTR_TYPE_MOD,
       ATTR_TYPE_OWNER,
       ATTR_TYPE_NAME,
       LENGTH,
       PRECISION,
       SCALE,
       CHARACTER_SET_NAME,
       ATTR_NO,
       INHERITED,
       CHAR_USED
  from ALL_TYPE_ATTRS
/
show errors
--
grant all on XDBPM.XDBPM_ALL_TYPE_ATTRS to public
/
create or replace view XDBPM_ALL_COLL_TYPES
as
select OWNER,
       TYPE_NAME,
       COLL_TYPE,
       UPPER_BOUND,
       ELEM_TYPE_MOD,
       ELEM_TYPE_OWNER,
       ELEM_TYPE_NAME,
       LENGTH,
       PRECISION,
       SCALE,
       CHARACTER_SET_NAME,
       ELEM_STORAGE,
       NULLS_STORED,
       CHAR_USED
  from ALL_COLL_TYPES
/
show errors
--
grant all on XDBPM.XDBPM_ALL_COLL_TYPES to public
/
