
/* ================================================  
 *    
 * Copyright (c) 2015 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================ */

insert into DATA_SET_TABLE
select COLUMN_VALUE 
  from XMLTABLE(
        'xquery version "1.0"; (: :)
         declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance"; (: :) 
         for $row in fn:collection("oradb:/HR/DEPARTMENTS")/ROW
         return (
            element DataSet { 
               attribute {"xsi:noNamespaceSchemaLocation"} { "http://xmlns.oracle.com/xdb/demonstration/xsd/nvPairStorage.xsd" }, 
               attribute {"objectType"} {"DEPARTMENT"},                    
               for $column in $row/*
                 let $name := fn:local-name($column)
                 return element {                      
                          if ($name="DEPARTMENT_ID" or $name="MANAGER_ID" or $name="LOCATION_ID")  then
                            "IntegerValue"
                          else
                            "StringValue"
                        } 
                        {
                          attribute {"name"} {$name},
                          attribute value {$column/text()
                        }
         	    }
            }
         )'
       )
/
select * 
  from DATA_SET_TABLE
 where XMLExists(
         '/DataSet[@objectType="DEPARTMENT" and IntegerValue[@name="DEPARTMENT_ID" and @value=10]]'
         passing OBJECT_VALUE
       )
/       
insert into DATA_SET_TABLE
select COLUMN_VALUE 
  from XMLTABLE(
        'xquery version "1.0"; (: :)
         declare namespace xsi = "http://www.w3.org/2001/XMLSchema-instance"; (: :) 
         for $row in fn:collection("oradb:/HR/EMPLOYEES")/ROW
         return (
            element DataSet { 
               attribute {"xsi:noNamespaceSchemaLocation"} { "http://xmlns.oracle.com/xdb/demonstration/xsd/nvPairStorage.xsd" }, 
               attribute {"objectType"} {"EMPLOYEE"},                    
               for $column in $row/*
                 let $name := fn:local-name($column)
                 return element {
                          if ($name="EMPLOYEE_ID" or $name="MANAGER_ID" or $name="DEPARTMENT_ID") then
                            "IntegerValue"
                          else if ($name="SALARY" or $name="COMMISSION_PCT") then
                            "FloatValue"
                          else if ($name="HIRE_DATE") then
                            "DateValue"
                          else
                            "StringValue"
                       }
                       {
                         attribute {"name"} {$name},
                         attribute value {$column/text()}
         	             }
            }
         )'
       )
/
select * 
  from DATA_SET_TABLE
 where XMLExists(
         '/DataSet[@objectType="EMPLOYEE" and IntegerValue[@name="EMPLOYEE_ID" and @value=122]]'
         passing OBJECT_VALUE
       )
/       

