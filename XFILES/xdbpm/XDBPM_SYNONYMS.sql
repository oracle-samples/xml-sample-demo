
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


-- All public synonyms should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace synonym XDB_PATH_HELPER                 for XDBPM_PATH_HELPER
/
create or replace public synonym XDB_USERNAME             for XDBPM_USERNAME
/
create or replace public synonym XDB_CONSTANTS            for XDBPM_CONSTANTS
/
create or replace public synonym XDB_NAMESPACES           for XDBPM_NAMESPACES
/
create or replace public synonym XDB_OUTPUT               for XDBPM.XDBPM_OUTPUT
/
create or replace public synonym XDB_DEBUG                for XDBPM.XDBPM_DEBUG
/
create or replace public synonym XDB_EDIT_XMLSCHEMA       for XDBPM.XDBPM_EDIT_XMLSCHEMA
/
create or replace public synonym XDB_ANNOTATE_XMLSCHEMA   for XDBPM.XDBPM_ANNOTATE_XMLSCHEMA
/
create or replace public synonym XDB_ANNOTATE_SCHEMA      for XDBPM.XDBPM_ANNOTATE_XMLSCHEMA
/
create or replace public synonym XDB_OPTIMIZE_XMLSCHEMA   for XDBPM.XDBPM_OPTIMIZE_XMLSCHEMA
/
create or replace public synonym XDB_OPTIMIZE_SCHEMA      for XDBPM.XDBPM_OPTIMIZE_XMLSCHEMA
/
create or replace public synonym XDB_ORDER_XMLSCHEMAS     for XDBPM.XDBPM_ORDER_XMLSCHEMAS
/
create or replace public synonym XDB_XMLSCHEMA_UTILITIES  for XDBPM.XDBPM_XMLSCHEMA_UTILITIES
/
create or replace public synonym XDB_REGISTRATION_HELPER  for XDBPM.XDBPM_REGISTRATION_HELPER
/
create or replace public synonym XDB_ANALYZE_XMLSCHEMA    for XDBPM.XDBPM_ANALYZE_XMLSCHEMA
/
create or replace public synonym XDB_ANALYZE_SCHEMA       for XDBPM.XDBPM_ANALYZE_XMLSCHEMA
/
create or replace public synonym XDB_UTILITIES 					  for XDBPM_UTILITIES
/
create or replace public synonym XDB_MONITOR  					  for XDBPM_MONITOR
/
create or replace public synonym XDB_DOM_UTILITIES  			for XDBPM_DOM_UTILITIES
/
create or replace public synonym XDB_XMLINDEX_SEARCH  	  for XDBPM_XMLINDEX_SEARCH
/
create or replace public synonym XDB_XMLSCHEMA_SEARCH			for XDBPM_XMLSCHEMA_SEARCH
/
create or replace public synonym XDB_REPOSITORY_SEARCH	  for XDBPM_REPOSITORY_SEARCH
/
create or replace public synonym XDB_RESCONFIG_MANAGER	  for XDBPM_RESCONFIG_MANAGER
/
create or replace public synonym XDB_TABLE_UPLOAD   			for XDBPM_TABLE_UPLOAD
/
create or replace public synonym XDB_ZIP_UTILITY 		      for XDBPM_ZIP_UTILITY
/
create or replace public synonym XDB_IMPORT_UTILITIES 		for XDBPM_IMPORT_UTILITIES
/
create or replace public synonym XDB_CONFIGURATION     		for XDBPM_CONFIGURATION
/
create or replace public synonym XDB_IMPORT_HELPER        for XDBPM_IMPORT_HELPER
/
alter session set current_schema = SYS
/
