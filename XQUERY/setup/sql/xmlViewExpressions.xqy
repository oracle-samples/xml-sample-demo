xquery version "1.0";
let $DEPARTMENT := "Executive"
for $d in fn:collection("oradb:/SCOTT/DEPARTMENT_XML")/Department[Name=$DEPARTMENT]
  return $d
/
xquery version "1.0";
let $NAME := "Grant"
for $d in fn:collection("oradb:/SCOTT/DEPARTMENT_XML")/Department[EmployeeList/Employee/LastName=$NAME]/Name
  return $d
/