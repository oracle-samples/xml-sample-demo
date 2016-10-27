
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

select xmlElement(
         "部門",
         xmlAttributes( d.DEPARTMENT_ID as "部門ID"),
         xmlElement("部門名", d.DEPARTMENT_NAME),
         xmlElement(
           "住所",
           xmlForest(
              STREET_ADDRESS as "番地", CITY as "市町村", STATE_PROVINCE as "都道府県",
              POSTAL_CODE as "郵便番号",COUNTRY_NAME as "国名"
           )
         ),
         xmlElement(
           "社員リスト",
           (
             select xmlAgg(
                      xmlElement(
                        "社員",
                        xmlAttributes(e.EMPLOYEE_ID as "社員番号" ),
                        xmlForest(
                          e.FIRST_NAME as "名", e.LAST_NAME as "姓", e.EMAIL as "Emailアドレス",
                          e.PHONE_NUMBER as "電話番号", e.HIRE_DATE as "入社年月日", j.JOB_TITLE as "役職",
                          e.SALARY as "給料"
                        ),
                        xmlElement("COMMISSION", e.COMMISSION_PCT ),
                        xmlElement("上司", m.FIRST_NAME, ' ', m.LAST_NAME)
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
   and DEPARTMENT_NAME = 'Executive'
/
--
