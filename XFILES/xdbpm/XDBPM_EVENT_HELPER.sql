
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
alter session set CURRENT_SCHEMA = XDBPM
--
create or replace package XDBPM_EVENT_HELPER 
as
  getEventName(P_EVENT PLS_INTEGER) return VARCHAR2;
end;
--
/
show errors
--
grant execute to public on XDBPM_EVENT_HELPER
/
create or replace package body XDBPM_EVENT_HELPER
as
--
  TYPE EVENT_LIST_T IS VARRAY(32) OF VARCHAR2(50);                                          
--
  G_EVENT_LIST      EVENT_LIST_T;                                                             
--
procedure loadEventList
as
begin
	G_EVENT_LIST := EVENT_LIST_T();
	G_EVENT_LIST.EXTEND(32); 
  G_EVENT_LIST(DBMS_XEVENT.RENDER_EVENT)                   := 'RENDER_EVENT';                  
  G_EVENT_LIST(DBMS_XEVENT.PRE_CREATE_EVENT)               := 'PRE_CREATE_EVENT';              
  G_EVENT_LIST(DBMS_XEVENT.POST_CREATE_EVENT)              := 'POST_CREATE_EVENT';             
  G_EVENT_LIST(DBMS_XEVENT.PRE_DELETE_EVENT)               := 'PRE_DELETE_EVENT';              
  G_EVENT_LIST(DBMS_XEVENT.POST_DELETE_EVENT)              := 'POST_DELETE_EVENT';             
  G_EVENT_LIST(DBMS_XEVENT.PRE_UPDATE_EVENT)               := 'PRE_UPDATE_EVENT';              
  G_EVENT_LIST(DBMS_XEVENT.POST_UPDATE_EVENT)              := 'POST_UPDATE_EVENT';             
  G_EVENT_LIST(DBMS_XEVENT.PRE_LOCK_EVENT)                 := 'PRE_LOCK_EVENT';                
  G_EVENT_LIST(DBMS_XEVENT.POST_LOCK_EVENT)                := 'POST_LOCK_EVENT';               
  G_EVENT_LIST(DBMS_XEVENT.PRE_UNLOCK_EVENT)               := 'PRE_UNLOCK_EVENT';              
  G_EVENT_LIST(DBMS_XEVENT.POST_UNLOCK_EVENT)              := 'POST_UNLOCK_EVENT';             
  G_EVENT_LIST(DBMS_XEVENT.PRE_LINKIN_EVENT)               := 'PRE_LINKIN_EVENT';              
  G_EVENT_LIST(DBMS_XEVENT.POST_LINKIN_EVENT)              := 'POST_LINKIN_EVENT';             
  G_EVENT_LIST(DBMS_XEVENT.PRE_LINKTO_EVENT)               := 'PRE_LINKTO_EVENT';              
  G_EVENT_LIST(DBMS_XEVENT.POST_LINKTO_EVENT)              := 'POST_LINKTO_EVENT';             
  G_EVENT_LIST(DBMS_XEVENT.PRE_UNLINKIN_EVENT)             := 'PRE_UNLINKIN_EVENT';            
  G_EVENT_LIST(DBMS_XEVENT.POST_UNLINKIN_EVENT)            := 'POST_UNLINKIN_EVENT';           
  G_EVENT_LIST(DBMS_XEVENT.PRE_UNLINKFROM_EVENT)           := 'PRE_UNLINKFROM_EVENT';          
  G_EVENT_LIST(DBMS_XEVENT.POST_UNLINKFROM_EVENT)          := 'POST_UNLINKFROM_EVENT';         
  G_EVENT_LIST(DBMS_XEVENT.PRE_CHECKIN_EVENT)              := 'PRE_CHECKIN_EVENT';             
  G_EVENT_LIST(DBMS_XEVENT.POST_CHECKIN_EVENT)             := 'POST_CHECKIN_EVENT';            
  G_EVENT_LIST(DBMS_XEVENT.PRE_CHECKOUT_EVENT)             := 'PRE_CHECKOUT_EVENT';            
  G_EVENT_LIST(DBMS_XEVENT.POST_CHECKOUT_EVENT)            := 'POST_CHECKOUT_EVENT';           
  G_EVENT_LIST(DBMS_XEVENT.PRE_UNCHECKOUT_EVENT)           := 'PRE_UNCHECKOUT_EVENT';          
  G_EVENT_LIST(DBMS_XEVENT.POST_UNCHECKOUT_EVENT)          := 'POST_UNCHECKOUT_EVENT';         
  G_EVENT_LIST(DBMS_XEVENT.PRE_VERSIONCONTROL_EVENT)       := 'PRE_VERSIONCONTROL_EVENT';      
  G_EVENT_LIST(DBMS_XEVENT.POST_VERSIONCONTROL_EVENT)      := 'POST_VERSIONCONTROL_EVENT';     
  G_EVENT_LIST(DBMS_XEVENT.PRE_OPEN_EVENT)                 := 'PRE_OPEN_EVENT';                
  G_EVENT_LIST(DBMS_XEVENT.POST_OPEN_EVENT)                := 'POST_OPEN_EVENT';               
  -- G_EVENT_LIST(DBMS_XEVENT.PRE_INCONSISTENT_UPDATE_EVENT)  := 'PRE_INCONSISTENT_UPDATE_EVENT'; 
  -- G_EVENT_LIST(DBMS_XEVENT.POST_INCONSISTENT_UPDATE_EVENT) := 'POST_INCONSISTENT_UPDATE_EVENT';
end;
--
function getEventName(P_EVENT PLS_INTEGER) 
return varchar2
as
begin
	return G_EVENT_LIST(P_EVENT);
end;
--
begin
	loadEventList();
end;
/
show errors
--
