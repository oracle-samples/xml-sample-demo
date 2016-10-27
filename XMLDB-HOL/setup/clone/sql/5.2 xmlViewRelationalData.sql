
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
 
--
-- Use SQL/XML to create a persistant XML view of relational content
--
create or replace view DEPARTMENT_XML of xmltype
with object id
(
  XMLCAST(XMLQUERY('/Department/Name' passing OBJECT_VALUE returning CONTENT) as VARCHAR2(30))
) 
as
select xmlElement
       (
         "Department",
         xmlAttributes( d.DEPARTMENT_ID as "DepartmentId"),
         xmlElement("Name", d.DEPARTMENT_NAME),
         xmlElement
         (
           "Location",
           xmlForest
           (
              STREET_ADDRESS as "Address", CITY as "City", STATE_PROVINCE as "State",
              POSTAL_CODE as "Zip",COUNTRY_NAME as "Country"
           )
         ),
         xmlElement
         (
           "EmployeeList",
           (
             select xmlAgg
                    (
                      xmlElement
                      (
                        "Employee",
                        xmlAttributes ( e.EMPLOYEE_ID as "employeeNumber" ),
                        xmlForest
                        (
                          e.FIRST_NAME as "FirstName", e.LAST_NAME as "LastName", e.EMAIL as "EmailAddress",
                          e.PHONE_NUMBER as "Telephone", e.HIRE_DATE as "StartDate", j.JOB_TITLE as "JobTitle",
                          e.SALARY as "Salary", m.FIRST_NAME || ' ' || m.LAST_NAME as "Manager"                
                        ),
                        xmlElement ( "Commission", e.COMMISSION_PCT )
                      )
                    )
               from HR.EMPLOYEES e, HR.EMPLOYEES m, HR.JOBS j
              where e.DEPARTMENT_ID = d.DEPARTMENT_ID
                and j.JOB_ID = e.JOB_ID
                and m.EMPLOYEE_ID = e.MANAGER_ID
           )
         )
       ) as XML
  from HR.DEPARTMENTS d, HR.COUNTRIES c, HR.LOCATIONS l
 where d.LOCATION_ID = l.LOCATION_ID
   and l.COUNTRY_ID  = c.COUNTRY_ID
/