
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

set define off
set echo on
create or replace view DEPARTMENT_SPREADSHEET of xmltype 
with object id 
(
   XMLCast
   (
     XMLQuery
     (
       'declare default element namespace "urn:schemas-microsoft-com:office:spreadsheet"; (: :)
        declare namespace ss = "urn:schemas-microsoft-com:office:spreadsheet"; (: :)
        $X/Workbook/Worksheet/Table/Row[@ss:Index="2"]/Cell[@ss:Index="8"]/Data/text()'
        passing OBJECT_VALUE as "X" returning content
     )
     as VARCHAR2(32)
   )
) 
as
select xmlroot (
         xmlConcat(xmlpi ("mso-application", 'progid="Excel.Sheet"'),
         xmlElement
         (
           "Workbook",
           xmlAttributes
           (
              'urn:schemas-microsoft-com:office:spreadsheet' as "xmlns",
              'urn:schemas-microsoft-com:office:office' as "xmlns:o",
              'urn:schemas-microsoft-com:office:excel' as "xmlns:x",
              'urn:schemas-microsoft-com:office:spreadsheet' as "xmlns:ss",
              'http://www.w3.org/TR/REC-html40' as "xmlns:html"
           ),
           xmlElement
           (	
             "DocumentProperties",
             xmlAttributes('urn:schemas-microsoft-com:office:office' as "xmlns"),
             xmlForest
             (
               USER as "Author",
               USER as "LastAuthor",
               '2002-10-11T15:47:35Z' as "Created",
               'Oracle Corporation' as "Company",
               '11.5703' as "Version"
             )
           ),
           xmlElement
           (	
             "OfficeDocumentSettings",
             xmlAttributes('urn:schemas-microsoft-com:office:office' as "xmlns"),
             xmlElement("DownloadComponents"),
             xmlElement
             (
               "LocationOfComponents",
               xmlAttributes('file://' as "HRef")
             )
           ),
           xmlElement
           (	
             "ExcelWorkbook",
             xmlAttributes('urn:schemas-microsoft-com:office:excel' as "xmlns"),
             xmlForest
             (
               '8835' as "WindowHeight",
               '14220' as "WindowWidth",
               '480' as "WindowTopX",
               '60' as "WindowTopY",
               'False' as "ProtectStructure",
               'False' as "ProtectWindows"
             ),
             xmlElement("HideHorizontalScrollBar")
           ),		
           xdburiType('/%DEMOCOMMON%/xml/Styles.xml').getXML(),
           xmlElement
           (
             "Worksheet",
             xmlAttributes(d.DEPARTMENT_NAME as "ss:Name"),
             xmlElement
             (
               "Table",
               xmlAttributes
               (
                 '11' as "ss:ExpandedColumnCount",
                 ( select '' || 14 + count(*) || '' from HR.EMPLOYEES e where e.DEPARTMENT_ID = d.DEPARTMENT_ID) as "ss:ExpandedRowCount",
                 '1' as "x:FullColumns",
                 '1' as "x:FullRows"
               ),
               xmlElement("Column",xmlAttributes('25' as "ss:Width")),
               xmlElement("Column",xmlAttributes('75' as "ss:Width")),
               xmlElement("Column",xmlAttributes('60' as "ss:Width", '1' as "ss:Span")),
               xmlElement("Column",xmlAttributes('5' as "ss:Index", '75' as "ss:Width")),
               xmlElement("Column",xmlAttributes('100' as "ss:Width", '1' as "ss:Span")),
               xmlElement("Column",xmlAttributes('8' as "ss:Index", '100' as "ss:Width")),
               xmlElement("Column",xmlAttributes('60' as "ss:Width")),
               xmlElement("Column",xmlAttributes('60' as "ss:Width")),
               xmlElement("Column",xmlAttributes('75' as "ss:Width")),
               xmlElement
               (
                 "Row",
                 xmlAttributes('2' as "ss:Index"),                 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('2' as "ss:Index", '3' as "ss:MergeAcross", '2' as "ss:MergeDown",'DepartmentName' as "ss:StyleID"), 
                   xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'Department : ' || DEPARTMENT_NAME )
                 ), 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('7' as "ss:Index", 'Caption' as "ss:StyleID"),
                   xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'ID :' )
                 ), 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('8' as "ss:Index", 'Bold' as "ss:StyleID"), 
                   xmlElement("Data", xmlAttributes('String' as "ss:Type"), d.DEPARTMENT_ID )
                 )
               ),
               xmlElement
               (
                 "Row",
                 xmlAttributes('4' as "ss:Index"),                 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('7' as "ss:Index", 'Caption' as "ss:StyleID"), 
                   xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'Location :' )
                 ), 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('8' as "ss:Index", 'Bold' as "ss:StyleID"), 
                   xmlElement("Data", xmlAttributes('String' as "ss:Type"), STREET_ADDRESS )
                 )
               ),
               xmlElement
               (
                 "Row",
                 xmlAttributes('5' as "ss:Index"),                 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('8' as "ss:Index", 'Bold' as "ss:StyleID"), 
                   xmlElement("Data", xmlAttributes('String' as "ss:Type"), CITY )
                 )
               ),
               xmlElement
               (
                 "Row",
                 xmlAttributes('6' as "ss:Index"),                 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('8' as "ss:Index", 'Bold' as "ss:StyleID"), 
                   xmlElement("Data", xmlAttributes('String' as "ss:Type"), STATE_PROVINCE )
                 )
               ),
               xmlElement
               (
                 "Row",
                 xmlAttributes('7' as "ss:Index"),                 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('8' as "ss:Index", 'Bold' as "ss:StyleID"), 
                   xmlElement("Data", xmlAttributes('String' as "ss:Type"), POSTAL_CODE )
                 )
               ),
               xmlElement
               (
                 "Row",
                 xmlAttributes('8' as "ss:Index"),                 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('8' as "ss:Index", 'Bold' as "ss:StyleID"), 
                   xmlElement("Data", xmlAttributes('String' as "ss:Type"), COUNTRY_NAME )
                 )
               ),
               xmlElement
               (
                 "Row",
                 xmlAttributes('10' as "ss:Index"),                 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('7' as "ss:Index", 'Caption' as "ss:StyleID"), 
	           xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'Manager :' )
	         ), 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('8' as "ss:Index", 'Bold' as "ss:StyleID"), 
                   xmlElement("Data", xmlAttributes('String' as "ss:Type"), m.FIRST_NAME || ' ' || m.LAST_NAME )
                 )
               ),
               xmlElement
               (
                 "Row",
                 xmlAttributes('12' as "ss:Index"),                 
                 xmlElement
                 (
                   "Cell", 
                   xmlAttributes('2' as "ss:Index", 'BoldRight' as "ss:StyleID"), 
                   xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'Employee ID')
                 ),
                 xmlElement("Cell", xmlAttributes('BoldLeft' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'First Name')),
                 xmlElement("Cell", xmlAttributes('BoldLeft' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'Last Name')),
                 xmlElement("Cell", xmlAttributes('BoldLeft' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'Email Address' )),
                 xmlElement("Cell", xmlAttributes('BoldCentered' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'Phone Number' )),
                 xmlElement("Cell", xmlAttributes('BoldRight' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'Hire Date')),
                 xmlElement("Cell", xmlAttributes('BoldRight' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'Job Title')),
                 xmlElement("Cell", xmlAttributes('BoldRight' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'Salary')),
                 xmlElement("Cell", xmlAttributes('BoldRight' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"), 'Commission'))
               ),
               xmlElement
               (
                 "Row",
                 xmlElement("Cell",xmlAttributes('2' as "ss:Index", 'BodyDefault' as "ss:StyleID")),
                 xmlElement("Cell", xmlAttributes('BodyDefault' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('BodyDefault' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('BodyDefault' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('BodyDefault' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('BodyDefault' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('BodyDefault' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('BodyDefault' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('BodyDefault' as "ss:StyleID"))
               ),
               ( select xmlAgg
                        (
                          xmlElement
                          (
                            "Row",
                            xmlElement
                            (
                              "Cell", 
                              xmlAttributes('2' as "ss:Index", 'BodyDefault' as "ss:StyleID"), 
                              xmlElement("Data", xmlAttributes('Number' as "ss:Type"),  e.EMPLOYEE_ID)
                            ),
                            xmlElement("Cell", xmlAttributes('BodyDefault' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"),  e.FIRST_NAME)),
                            xmlElement("Cell", xmlAttributes('BodyDefault' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"),  e.LAST_NAME)),
                            xmlElement("Cell", xmlAttributes('BodyDefault' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"),  e.EMAIL )),
                            xmlElement("Cell", xmlAttributes('BodyRight' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"),  e.PHONE_NUMBER )),
                            xmlElement("Cell", xmlAttributes('HireDate' as "ss:StyleID"), xmlElement("Data", xmlAttributes('DateTime' as "ss:Type"),  to_char(to_char(e.HIRE_DATE,'YYYY-MM-DD"T00:00:00.000"')))),
                            xmlElement("Cell", xmlAttributes('BodyRight' as "ss:StyleID"), xmlElement("Data", xmlAttributes('String' as "ss:Type"),  j.JOB_TITLE)),
                            xmlElement("Cell", xmlAttributes('Currency' as "ss:StyleID"), xmlElement("Data", xmlAttributes('Number' as "ss:Type"),  e.SALARY)),
                            xmlElement("Cell", xmlAttributes('Percent' as "ss:StyleID"), xmlElement("Data", xmlAttributes('Number' as "ss:Type"),  e.COMMISSION_PCT))
                          )
                        )
                   from HR.EMPLOYEES e, HR.JOBS j   
                  where e.DEPARTMENT_ID = d.DEPARTMENT_ID
                    and e.JOB_ID = j.JOB_ID
               ),
               xmlElement
               (
                 "Row",
                 xmlElement("Cell", xmlAttributes('2' as "ss:Index", 'TableBottom' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('TableBottom' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('TableBottom' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('TableBottom' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('TableBottom' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('TableBottom' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes('TableBottom' as "ss:StyleID")), 
                 xmlElement("Cell", xmlAttributes
                                    (
                                      'SalaryTotal' as "ss:StyleID", 
                                      'SUM(R[-' || ( select '' || count(*) || '' from HR.EMPLOYEES e where e.DEPARTMENT_ID = d.DEPARTMENT_ID) || ']C:R[-1]C)' as "ss:Formula")
                                    ), 
                 xmlElement("Cell", xmlAttributes('TableBottom' as "ss:StyleID"))
               )
             ),
             xmlElement
             (
               "WorksheetOptions",
               xmlAttributes('urn:schemas-microsoft-com:office:excel' as "xmlns"),
               xmlElement
               (
                 "Print",
                 xmlElement("ValidPrintInfo"),
                 xmlElement("HorizontalResolution",96),
                 xmlElement("VerticalResolution",96),
                 xmlElement("NumberOfCopies",0)
               ),
	       xmlElement("DoNotDisplayGridlines"),
               xmlElement("Selected"),
               xmlElement
               (
                 "Panes",
                 xmlElement
                 (
                   "Pane",
                   xmlElement("Number",1),
                   xmlElement("ActiveRow",1),
                   xmlElement("ActiveCol",1)
                 )
               ),
               xmlElement("ProectedObjects",'False'),
               xmlElement("ProectedSecenarios",'False')
             )   
           )
          )
         ),
         version '1.0'
       )
  from HR.DEPARTMENTS d, HR.LOCATIONS l, HR.COUNTRIES c, HR.EMPLOYEES m
 where d.LOCATION_ID = l.LOCATION_ID
   and l.COUNTRY_ID = c.COUNTRY_ID
   and d.MANAGER_ID = m.EMPLOYEE_ID
/
create or replace trigger DEPARTMENT_SPREADSHEET
instead of INSERT or UPDATE or DELETE on DEPARTMENT_SPREADSHEET
begin
 null;
end;
/
--
