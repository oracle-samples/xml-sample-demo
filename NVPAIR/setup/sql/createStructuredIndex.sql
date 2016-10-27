
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

call DBMS_XMLINDEX.registerParameter(
                    'P_DEPARTMENT',
                    'GROUP G_DEPARTMENT
                       xmlTable DEPARTMENT_SXI  
						          ''/DataSet[@objectType="DEPARTMENT"]''
         							passing object_value
         							columns
         								DEPARTMENT_ID      NUMBER       path ''IntegerValue[@name="DEPARTMENT_ID"]/@value'',
         								LOCATION_ID        NUMBER       path ''IntegerValue[@name="LOCATION_ID"]/@value'',
         								MANAGER_ID         NUMBER       path ''IntegerValue[@name="MANAGER_ID"]/@value'',
         								DEPARTMENT_NAME  VARCHAR2(4000) path ''StringValue[@name="DEPARTMENT_NAME"]/@value''
         		        '
         		      )
/         					 
create index P_DATA_SET_SXI
          on DATA_SET_TABLE (OBJECT_VALUE)
             indextype is XDB.XMLINDEX
             parameters ('PARAM P_DEPARTMENT')
/                
call DBMS_XMLINDEX.registerParameter(
                    'P_EMPLOYEE',
                    'ADD_GROUP GROUP G_EMPLOYEE
                       xmlTable EMPLOYEE_SXI 
                       ''/DataSet[@objectType="EMPLOYEE"]''
                       passing object_value
                       columns
                       EMPLOYEE_ID        NUMBER(6) path ''IntegerValue[@name="EMPLOYEE_ID"]/@value'',
                       FIRST_NAME      VARCHAR2(20) path ''StringValue[@name="FIRST_NAME"]/@value'',
                       LAST_NAME       VARCHAR2(25) path ''StringValue[@name="LAST_NAME"]/@value'',
                       EMAIL           VARCHAR2(25) path ''StringValue[@name="EMAIL"]/@value'',
                       PHONE_NUMBER    VARCHAR2(20) path ''StringValue[@name="PHONE_NUMBER"]/@value'',
                       HIRE_DATE               DATE path ''DateValue[@name="HIRE_DATE"]/@value'',
                       JOB_ID          VARCHAR2(10) path ''StringValue[@name="JOB_ID"]/@value'',
                       SALARY           NUMBER(8,2) path ''FloatValue[@name="SALARY"]/@value'',
                       COMMISSION_PCT   NUMBER(2,2) path ''FloatValue[@name="COMMISSION_PCT"]/@value'',
                       MANAGER_ID         NUMBER(6) path ''IntegerValue[@name="MANAGER_ID"]/@value'',
                       DEPARTMENT_ID      NUMBER(4) path ''IntegerValue[@name="DEPARTMENT_ID"]/@value'''
                     )
/
alter index P_DATA_SET_SXI parameters ('PARAM P_EMPLOYEE')
/       

