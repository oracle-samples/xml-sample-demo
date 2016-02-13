
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
-- XDB_CLEANUP deletes old versions of the XDB Utilities. Some of these may have been installed under XDB, or XDBPM
--
declare
  cursor getPublicSynonyms is
  select SYNONYM_NAME
    from all_synonyms 
   where SYNONYM_NAME in 
         (
            'RESOURCE_MONITOR',
            'RESOURCE_MONITOR_11100'
         )
     and OWNER = 'PUBLIC'
     and TABLE_OWNER = 'SYS';
begin
	for s in getPublicSynonyms loop
    execute immediate 'drop public synonym "' || s.SYNONYM_NAME || '"';
	end loop;
end;
/
declare 
  cursor getPackages 
  is
  select OBJECT_NAME
    from ALL_OBJECTS
   where OBJECT_NAME in
         (
           'RESOURCE_MONITOR',
           'RESOURCE_MONITOR_11100'
		  	 )
		 and OBJECT_TYPE = 'PACKAGE'
     and OWNER = 'SYS';
begin
  for p in getPackages loop
    execute immediate 'drop package "SYS"."' || p.OBJECT_NAME || '"';
  end loop;
end;
/
declare
  cursor getPublicSynonyms is
  select SYNONYM_NAME
    from all_synonyms 
   where SYNONYM_NAME in 
         (
            'XDB_CONFIGURATION',
            'XDB_TOOLS',
            'XDB_DOM_HELPER',
            'XDB_UTILITIES',
            'XDB_ANNOTATE_SCHEMA',
            'XMLSCH_HELPER',
            'XMLIDX_PATH_UTILITIES',
            'XMLSCH_UTILITIES',
            'XMLIDX_UTILITIES',
            'XDBQBE_UTILITIES',
            'XDBPM_HELPER',
            'XDB_HELPER',
            'XMLROOT',
            'XMLCDATA'
         )
     and OWNER = 'PUBLIC'
     and TABLE_OWNER = 'XDB';
begin
	for s in getPublicSynonyms loop
    execute immediate 'drop public synonym "' || s.SYNONYM_NAME || '"';
	end loop;
end;
/
declare
  cursor getLocalSynonyms is
  select SYNONYM_NAME
    from all_synonyms 
   where SYNONYM_NAME in 
         (
            'XDB_CONFIGURATION',
            'XDB_TOOLS',
            'XDB_DOM_HELPER',
            'XDB_UTILITIES',
            'XDB_ANNOTATE_SCHEMA',
            'XMLSCH_HELPER',
            'XMLIDX_PATH_UTILITIES',
            'XMLSCH_UTILITIES',
            'XMLIDX_UTILITIES',
            'XDBQBE_UTILITIES',
            'XDBPM_HELPER',
            'XDB_HELPER',
            'XMLROOT',
            'XMLCDATA'
         )
     and OWNER = 'XDB'
     and TABLE_OWNER = 'XDB';
begin
	for s in getLocalSynonyms loop
    execute immediate 'drop synonym "XDB"."' || s.SYNONYM_NAME || '"';
	end loop;
end;
/
declare 
  cursor getPackages 
  is
  select OBJECT_NAME
    from ALL_OBJECTS
   where OBJECT_NAME in
         (
           'XDB_CONFIGURATION',
           'XDB_CONFIGURATION_11100',
           'XDB_TOOLS',
           'XDB_TOOLS_11100',
           'XDB_NAMESPACES',
           'XDB_NAMESPACES_11100',
           'XDB_DOM_HELPER',
           'XDB_DOM_HELPER_11100',
           'XDB_UTILITIES',
           'XDB_UTILITIES_11100',
           'XDB_ANNOTATE_XMLSCHEMA',
           'XDB_ANNOTATE_XMLSCHEMA_11100',
           'XMLSCH_HELPER_11100',
           'XMLSCH_UTILITIES_11100',
           'XMLIDX_PATH_UTILITIES_11100',
           'XDB_HELPER_11100',
           'XDB_HELPER_10200',
           'XDBPM_HELPER_10200',
           'XDBPM_HELPER_11100',
           'XMLIDX_UTILITIES_11100',
					 'XDBQBE_UTILITIES_11100'
		  	 )
		 and OBJECT_TYPE = 'PACKAGE'
     and OWNER = 'XDB';
begin
  for p in getPackages loop
    execute immediate 'drop package "XDB"."' || p.OBJECT_NAME || '"';
  end loop;
end;
/
declare 
  cursor getPackages 
  is
  select OBJECT_NAME
    from ALL_OBJECTS
   where OBJECT_NAME in
         (
					 'XDBPM_IMPORT_HELPER'
		  	 )
		 and OBJECT_TYPE = 'PACKAGE'
     and OWNER = 'SYS';
begin
  for p in getPackages loop
    execute immediate 'drop package "SYS"."' || p.OBJECT_NAME || '"';
  end loop;
end;
/
declare 
  cursor getPackages 
  is
  select OBJECT_NAME
    from ALL_OBJECTS
   where OBJECT_NAME in
         (
           'XDBPM_HELPER',              
           'XDBPM_RESCONFIG',           
           'XDBPM_RESCONFIG_HELPER',    
           'XDBPM_RV_HELPER',           
           'XDBPM_XDB',                 
           'XDBPM_HELPER',              
           'XDBPM_RESCONFIG',           
           'XDBPM_RESCONFIG_HELPER',    
           'XDBPM_RV_HELPER',           
           'XDBPM_XDB'   
 		  	 )
		 and OBJECT_TYPE = 'PACKAGE'
     and OWNER = 'XDB';
begin
  for p in getPackages loop
    execute immediate 'drop package "XDB"."' || p.OBJECT_NAME || '"';
  end loop;
end;
/
declare 
  cursor getFunctions
  is
  select OBJECT_NAME
    from ALL_OBJECTS
   where OBJECT_NAME in
         (
           'XMLROOT',
           'XMLROOT_10103',
           'XMLCDATA',
           'XMLCDATA_10103'              
 		  	 )
		 and OBJECT_TYPE = 'FUNCTION'
     and OWNER = 'XDB';
begin
  for p in getFunctions loop
    execute immediate 'drop function "XDB"."' || p.OBJECT_NAME || '"';
  end loop;
end;
/
select object_name 
  from all_objects
 where owner = 'XDB' and object_type = 'PACKAGE' and (object_name like 'XDB_%' or object_name like 'XDBPM_%')
/
declare
  cursor getPublicSynonyms is
  select SYNONYM_NAME
    from all_synonyms 
   where SYNONYM_NAME in 
         (
            'ALL_XML_OUT_OF_LINE_STORAGE',
            'USER_XML_OUT_OF_LINE_STORAGE',
            'ALL_XML_NESTED_TABLES',
            'USER_XML_NESTED_TABLES',
            'ALL_XML_OOL_TABLES',
            'USER_XML_OOL_TABLES',
            'ALL_XML_SCOPED_TABLES',
            'USER_XML_SCOPED_TABLES',
            'ALL_XDB_NAMESPACES_VIEW',
            'USER_XDB_NAMESPACES_VIEW',
            'ALL_XDB_GLOBAL_ELEMENTS_VIEW',
						'USER_XDB_GLOBAL_ELEMENTS_VIEW',
					  'ALL_XDB_SUBGROUP_MEMBERS_VIEW',
					  'USER_XDB_SUBGROUP_MEMBERS_VIEW',
 						'ALL_XDB_SUBGROUP_HEAD_VIEW',
 						'USER_XDB_SUBGROUP_HEAD_VIEW',
 						'ALL_XDB_COMPLEX_TYPES_VIEW',
 						'USER_XDB_COMPLEX_TYPES_VIEW',
						'ALL_XDB_SIMPLE_TYPES_VIEW',
						'USER_XDB_SIMPLE_TYPES_VIEW',
            'XDB_ADMIN',
            'XDB_ANALYZE_SCHEMA',
            'XDB_ANALYZE_XMLSCHEMA',
            'XDB_ANNOTATE_SCHEMA',
            'XDB_ANNOTATE_XMLSCHEMA',
            'XDB_CONFIGURATION',
            'XDB_CONSTANTS',
            'XDB_DEBUG',
            'XDB_DOM_UTILITIES',
            'XDB_EDIT_XMLSCHEMA',
            'XDB_IMPORT_UTILITIES',
            'XDB_MONITOR',
            'XDB_NAMESPACES',
            'XDB_OUTPUT',
            'XDB_PATH_HELPER',
            'XDB_REPOSITORY_SEARCH',
            'XDB_TABLE_UPLOAD',
            'XDB_USERNAME',
            'XDB_UTILITIES',
            'XDB_XMLINDEX_SEARCH',
            'XDB_XMLSCHEMA_SEARCH'
         )
     and OWNER = 'PUBLIC'
     and TABLE_OWNER = 'XDBPM';
begin
	for s in getPublicSynonyms loop
    execute immediate 'drop public synonym "' || s.SYNONYM_NAME || '"';
	end loop;
end;
/
declare
  cursor getViews is
  select VIEW_NAME
    from ALL_VIEWS
   where VIEW_NAME in 
         (
            'ALL_XML_OUT_OF_LINE_STORAGE',
            'USER_XML_OUT_OF_LINE_STORAGE',
            'ALL_XML_NESTED_TABLES',
            'USER_XML_NESTED_TABLES',
            'ALL_XML_OOL_TABLES',
            'USER_XML_OOL_TABLES',
            'ALL_XML_SCOPED_TABLES',
            'USER_XML_SCOPED_TABLES',
            'ALL_XDB_NAMESPACES_VIEW',
            'USER_XDB_NAMESPACES_VIEW',
            'ALL_XDB_GLOBAL_ELEMENTS_VIEW',
						'USER_XDB_GLOBAL_ELEMENTS_VIEW',
					  'ALL_XDB_SUBGROUP_MEMBERS_VIEW',
					  'USER_XDB_SUBGROUP_MEMBERS_VIEW',
 						'ALL_XDB_SUBGROUP_HEAD_VIEW',
 						'USER_XDB_SUBGROUP_HEAD_VIEW',
 						'ALL_XDB_COMPLEX_TYPES_VIEW',
 						'USER_XDB_COMPLEX_TYPES_VIEW',
						'ALL_XDB_SIMPLE_TYPES_VIEW',
						'USER_XDB_SIMPLE_TYPES_VIEW'
         )
     and OWNER = 'XDBPM';
begin
	for v in getViews loop
    execute immediate 'drop view "XDBPM"."' || v.VIEW_NAME || '"';
	end loop;
end;
/
--