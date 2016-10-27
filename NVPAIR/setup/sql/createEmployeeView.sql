
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
 * ================================================
 */

create or replace view EMPLOYEE_VIEW as
select xt.* 
  from DATA_SET_TABLE,
       xmltable(
         '/DataSet[@objectType="EMPLOYEE"]'
         passing object_value
         columns
         EMPLOYEE_ID        NUMBER(6) path 'IntegerValue[@name="EMPLOYEE_ID"]/@value',
         FIRST_NAME      VARCHAR2(20) path 'StringValue[@name="FIRST_NAME"]/@value',
         LAST_NAME       VARCHAR2(25) path 'StringValue[@name="LAST_NAME"]/@value',
         EMAIL           VARCHAR2(25) path 'StringValue[@name="EMAIL"]/@value',
         PHONE_NUMBER    VARCHAR2(20) path 'StringValue[@name="PHONE_NUMBER"]/@value',
         HIRE_DATE               DATE path 'DateValue[@name="HIRE_DATE"]/@value',
         JOB_ID          VARCHAR2(10) path 'StringValue[@name="JOB_ID"]/@value',
         SALARY           NUMBER(8,2) path 'FloatValue[@name="SALARY"]/@value',
         COMMISSION_PCT   NUMBER(2,2) path 'FloatValue[@name="COMMISSION_PCT"]/@value',
         MANAGER_ID         NUMBER(6) path 'IntegerValue[@name="MANAGER_ID"]/@value',
         DEPARTMENT_ID      NUMBER(4) path 'IntegerValue[@name="DEPARTMENT_ID"]/@value'
      ) xt
/
set autotrace on explain lines 256 pages 50
--
select FIRST_NAME, LAST_NAME
  from EMPLOYEE_VIEW
 where EMPLOYEE_ID = 122
/

