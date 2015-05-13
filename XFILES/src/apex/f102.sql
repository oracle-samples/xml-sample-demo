
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

set define off
set verify off
set serveroutput on size 1000000
set feedback off
WHENEVER SQLERROR EXIT SQL.SQLCODE ROLLBACK
begin wwv_flow.g_import_in_progress := true; end; 
/
 
 
--application/set_environment
prompt  APPLICATION 102 - XFILES 1.0
--
-- Application Export:
--   Application:     102
--   Name:            XFILES 1.0
--   Date and Time:   17:39 Sunday November 8, 2009
--   Exported By:     ADMIN
--   Flashback:       0
--   Export Type:     Application Export
--   Version: 3.2.1.00.10
 
-- Import:
--   Using application builder
--   or
--   Using SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
 
-- Application Statistics:
--   Pages:                 6
--     Items:              31
--     Computations:        1
--     Validations:         0
--     Processes:          18
--     Regions:             9
--     Buttons:             6
--   Shared Components
--     Breadcrumbs:         1
--        Entries           1
--     Items:               6
--     Computations:        0
--     Processes:           7
--     Parent Tabs:         0
--     Tab Sets:            1
--        Tabs:             1
--     NavBars:             1
--     Lists:               0
--     Shortcuts:           0
--     Themes:              3
--     Templates:
--        Page:            33
--        List:            45
--        Report:          22
--        Label:           15
--        Region:          64
--     Messages:            0
--     Build Options:       0
 
 
--       AAAA       PPPPP   EEEEEE  XX      XX
--      AA  AA      PP  PP  EE       XX    XX
--     AA    AA     PP  PP  EE        XX  XX
--    AAAAAAAAAA    PPPPP   EEEE       XXXX
--   AA        AA   PP      EE        XX  XX
--  AA          AA  PP      EE       XX    XX
--  AA          AA  PP      EEEEEE  XX      XX
prompt  Set Credentials...
 
begin
 
  -- Assumes you are running the script connected to SQL*Plus as the Oracle user APEX_030200 or as the owner (parsing schema) of the application.
  wwv_flow_api.set_security_group_id(p_security_group_id=>1046423805817399);
 
end;
/

begin wwv_flow.g_import_in_progress := true; end;
/
begin 

select value into wwv_flow_api.g_nls_numeric_chars from nls_session_parameters where parameter='NLS_NUMERIC_CHARACTERS';

end;

/
begin execute immediate 'alter session set nls_numeric_characters=''.,''';

end;

/
begin wwv_flow.g_browser_language := 'en-us'; end;
/
prompt  Check Compatibility...
 
begin
 
-- This date identifies the minimum version required to import this file.
wwv_flow_api.set_version(p_version_yyyy_mm_dd=>'2009.01.12');
 
end;
/

prompt  Set Application ID...
 
begin
 
   -- SET APPLICATION ID
   wwv_flow.g_flow_id := 102;
   wwv_flow_api.g_id_offset := 0;
null;
 
end;
/

--application/delete_application
 
begin
 
   -- Remove Application
wwv_flow_api.remove_flow(102);
 
end;
/

 
begin
 
wwv_flow_audit.remove_audit_trail(102);
null;
 
end;
/

--application/create_application
 
begin
 
wwv_flow_api.create_flow(
  p_id    => 102,
  p_display_id=> 102,
  p_owner => 'APEX_XFILES',
  p_name  => 'XFILES 1.0',
  p_alias => 'F101104',
  p_page_view_logging => 'YES',
  p_default_page_template=> 4241491426114026 + wwv_flow_api.g_id_offset,
  p_printer_friendly_template=> 4243590760114032 + wwv_flow_api.g_id_offset,
  p_default_region_template=> 4250378089114043 + wwv_flow_api.g_id_offset,
  p_error_template    => 4241491426114026 + wwv_flow_api.g_id_offset,
  p_checksum_salt_last_reset => '20091108173906',
  p_max_session_length_sec=> 28800,
  p_home_link         => 'f?p=&APP_ID.:1:&SESSION.',
  p_flow_language     => 'en-us',
  p_flow_language_derived_from=> '',
  p_flow_image_prefix => '/i/',
  p_documentation_banner=> '',
  p_authentication    => 'CUSTOM2',
  p_login_url         => '',
  p_logout_url        => 'wwv_flow_custom_auth_std.logout?p_this_flow=&APP_ID.&amp;p_next_flow_page_sess=&APP_ID.:1',
  p_application_tab_set=> 1,
  p_public_url_prefix => '',
  p_public_user       => '',
  p_dbauth_url_prefix => '',
  p_proxy_server      => '',
  p_cust_authentication_process=> '.'||to_char(5188811089808429 + wwv_flow_api.g_id_offset)||'.',
  p_cust_authentication_page=> '',
  p_custom_auth_login_url=> '',
  p_flow_version      => 'release 1.0',
  p_flow_status       => 'AVAILABLE_W_EDIT_LINK',
  p_flow_unavailable_text=> '',
  p_build_status      => 'RUN_AND_BUILD',
  p_exact_substitutions_only=> 'Y',
  p_vpd               => '',
  p_theme_id => 20,
  p_default_label_template => 4261285833114065 + wwv_flow_api.g_id_offset,
  p_default_report_template => 4259062755114060 + wwv_flow_api.g_id_offset,
  p_default_list_template => 4256977378114056 + wwv_flow_api.g_id_offset,
  p_default_menu_template => 4261581807114066 + wwv_flow_api.g_id_offset,
  p_default_button_template => 4245073391114034 + wwv_flow_api.g_id_offset,
  p_default_chart_template => 4247376159114039 + wwv_flow_api.g_id_offset,
  p_default_form_template => 4247667412114039 + wwv_flow_api.g_id_offset,
  p_default_wizard_template => 4251863043114044 + wwv_flow_api.g_id_offset,
  p_default_tabform_template => 4250378089114043 + wwv_flow_api.g_id_offset,
  p_default_reportr_template   =>4250378089114043 + wwv_flow_api.g_id_offset,
  p_default_menur_template => 4246460268114039 + wwv_flow_api.g_id_offset,
  p_default_listr_template => 4250378089114043 + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'ADMIN',
  p_last_upd_yyyymmddhh24miss=> '20091108173906',
  p_required_roles=> wwv_flow_utilities.string_to_table2(''));
 
 
end;
/

prompt  ...authorization schemes
--
 
begin
 
null;
 
end;
/

--application/shared_components/navigation/navigation_bar
prompt  ...navigation bar entries
--
 
begin
 
wwv_flow_api.create_icon_bar_item(
  p_id             => 5189094243808429 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_icon_sequence  => 200,
  p_icon_image     => '',
  p_icon_subtext   => 'Logout',
  p_icon_target    => '&LOGOUT_URL.',
  p_icon_image_alt => 'Logout',
  p_icon_height    => 32,
  p_icon_width     => 32,
  p_icon_height2   => 24,
  p_icon_width2    => 24,
  p_icon_bar_disp_cond      => '',
  p_icon_bar_disp_cond_type => 'CURRENT_LOOK_IS_1',
  p_begins_on_new_line=> '',
  p_cell_colspan      => 1,
  p_onclick=> '',
  p_icon_bar_comment=> '');
 
 
end;
/

prompt  ...application processes
--
--application/shared_components/logic/application_processes/xdb_reset_principal
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  RES BOOLEAN;'||chr(10)||
'begin'||chr(10)||
'  if (:F101_USER_DN != NULL) then'||chr(10)||
'    RES := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 3286150951019652 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'XDB_RESET_PRINCIPAL',
  p_process_sql_clob=> p,
  p_process_error_message=> 'Failed to reset application principal',
  p_process_when=> '',
  p_process_when_type=> 'ALWAYS',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

--application/shared_components/logic/application_processes/xdb_set_prinicipal
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'DECLARE'||chr(10)||
'  RES BOOLEAN;'||chr(10)||
'BEGIN'||chr(10)||
'  RES := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(:F101_USER_DN,TRUE);'||chr(10)||
'END;';

wwv_flow_api.create_flow_process(
  p_id => 3239550011445237 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'BEFORE_BOX_BODY',
  p_process_type=> 'PLSQL',
  p_process_name=> 'XDB_SET_PRINICIPAL',
  p_process_sql_clob=> p,
  p_process_error_message=> 'XDB_AUTHENTICATE_LOAD : Error while Setting Priniciple :F101_USER_DN ',
  p_process_when=> '',
  p_process_when_type=> 'ALWAYS',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

--application/shared_components/logic/application_processes/doc_menu
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'htp.prn(''<a href="f?p=''||:APP_ID||'':ACTIONS:''||:SESSION||'':COPY::::">Copy</a>'');'||chr(10)||
'htp.prn(''<a href="f?p=''||:APP_ID||'':ACTIONS:''||:SESSION||'':MOVE::::">Move</a>'');'||chr(10)||
'htp.prn(''<a href="f?p=''||:APP_ID||'':ACTIONS:''||:SESSION||'':LINK::::">Link</a>'');'||chr(10)||
'htp.prn(''<a href="#" onlcikc="false"></a>'');'||chr(10)||
'htp.prn(''<a href="f?p=''||:APP_ID||'':ACTIONS:''||:SESSION||'':RENAME::::">Rename</a>'');'||chr(10)||
'htp.prn(''<a href="f?p=''||:A';

p:=p||'PP_ID||'':ACTIONS:''||:SESSION||'':DELETE::::">Delete</a>'');'||chr(10)||
'htp.prn(''<a href="#" onlcikc="false"></a>'');'||chr(10)||
'htp.prn(''<a href="f?p=''||:APP_ID||'':ACTIONS:''||:SESSION||'':LOCK::::">Lock</a>'');'||chr(10)||
'htp.prn(''<a href="f?p=''||:APP_ID||'':ACTIONS:''||:SESSION||'':UNLOCK::::">Unlock</a>'');'||chr(10)||
'htp.prn(''<a href="#" onlcikc="false"></a>'');'||chr(10)||
'htp.prn(''<a href="f?p=''||:APP_ID||'':ACTIONS:''||:SESSION||'':PUBLISH::::">Publish</a>'');';

p:=p||''||chr(10)||
'htp.prn(''<a href="f?p=''||:APP_ID||'':ACTIONS:''||:SESSION||'':SETACL::::">Set ACL</a>'');'||chr(10)||
'htp.prn(''<a href="#" onlcikc="false"></a>'');'||chr(10)||
'htp.prn(''<a href="f?p=''||:APP_ID||'':ACTIONS:''||:SESSION||'':VERSION::::">Make Versioned</a>'');'||chr(10)||
'htp.prn(''<a href="f?p=''||:APP_ID||'':ACTIONS:''||:SESSION||'':CHECKIN::::">Check In</a>'');'||chr(10)||
'htp.prn(''<a href="f?p=''||:APP_ID||'':ACTIONS:''||:SESSION||'':CHECKOUT::::">Check Out</a>';

p:=p||''');';

wwv_flow_api.create_flow_process(
  p_id => 4233977077189369 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DOC_MENU',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

--application/shared_components/logic/application_processes/show_children
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  V_HTML CLOB;'||chr(10)||
'  V_LENGTH NUMBER;'||chr(10)||
'  V_START_OFFSET NUMBER := 1;'||chr(10)||
'begin'||chr(10)||
'  V_HTML := XFILES_APEX_SERVICES.SHOWCHILDREN'||chr(10)||
'            ('||chr(10)||
'              :F101_USER_DN,'||chr(10)||
'              :APP_SESSION,'||chr(10)||
'              :APP_PAGE_ID, '||chr(10)||
'              :BRANCH_ID'||chr(10)||
'            ).getClobVal();'||chr(10)||
''||chr(10)||
'  V_LENGTH := DBMS_LOB.getLength(V_HTML);'||chr(10)||
'  if  (V_LENGTH < 4000) then'||chr(10)||
'    htp.prn(V_HTML);'||chr(10)||
'  else'||chr(10)||
'    while ((V_START_OFF';

p:=p||'SET + 4000) < V_LENGTH) loop'||chr(10)||
'      htp.prn(DBMS_LOB.SUBSTR(V_HTML,4000,V_START_OFFSET));'||chr(10)||
'      V_START_OFFSET := V_START_OFFSET + 4000;'||chr(10)||
'    end loop;'||chr(10)||
'    htp.prn(DBMS_LOB.SUBSTR(V_HTML,V_LENGTH - V_START_OFFSET,V_START_OFFSET));'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 4272375929745019 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'SHOW_CHILDREN',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

--application/shared_components/logic/application_processes/hide_children
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  V_HTML CLOB;'||chr(10)||
'  V_LENGTH NUMBER;'||chr(10)||
'  V_START_OFFSET NUMBER := 1;'||chr(10)||
'begin'||chr(10)||
'  V_HTML := XFILES_APEX_SERVICES.HIDECHILDREN '||chr(10)||
'            ('||chr(10)||
'              :F101_USER_DN,'||chr(10)||
'              :APP_SESSION, '||chr(10)||
'              :APP_PAGE_ID, '||chr(10)||
'              :BRANCH_ID'||chr(10)||
'            ).getClobVal();'||chr(10)||
'  V_LENGTH := DBMS_LOB.getLength(V_HTML);'||chr(10)||
'  if  (V_LENGTH < 4000) then'||chr(10)||
'    htp.prn(V_HTML);'||chr(10)||
'  else'||chr(10)||
'    while ((V_START_OF';

p:=p||'FSET + 4000) < V_LENGTH) loop'||chr(10)||
'      htp.prn(DBMS_LOB.SUBSTR(V_HTML,4000,V_START_OFFSET));'||chr(10)||
'      V_START_OFFSET := V_START_OFFSET + 4000;'||chr(10)||
'    end loop;'||chr(10)||
'    htp.prn(DBMS_LOB.SUBSTR(V_HTML,V_LENGTH - V_START_OFFSET,V_START_OFFSET));'||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 4274289893957231 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'HIDE_CHILDREN',
  p_process_sql_clob=> p,
  p_process_error_message=> 'Failed to Hide Children',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

--application/shared_components/logic/application_processes/make_open
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  V_HTML CLOB;'||chr(10)||
'  V_LENGTH NUMBER;'||chr(10)||
'  V_START_OFFSET NUMBER := 1;'||chr(10)||
'begin'||chr(10)||
'  V_HTML := XFILES_APEX_SERVICES.OPENFOLDER'||chr(10)||
'            ('||chr(10)||
'              :F101_USER_DN,'||chr(10)||
'              :APP_SESSION, '||chr(10)||
'              :APP_PAGE_ID, '||chr(10)||
'              :BRANCH_ID'||chr(10)||
'            ).getClobVal();'||chr(10)||
''||chr(10)||
'  V_LENGTH := DBMS_LOB.getLength(V_HTML);'||chr(10)||
''||chr(10)||
'  if  (V_LENGTH < 4000) then'||chr(10)||
'    htp.prn(V_HTML);'||chr(10)||
'  else'||chr(10)||
'    while ((V_START_OFF';

p:=p||'SET + 4000) < V_LENGTH) loop'||chr(10)||
'      htp.prn(DBMS_LOB.SUBSTR(V_HTML,4000,V_START_OFFSET));'||chr(10)||
'      V_START_OFFSET := V_START_OFFSET + 4000;'||chr(10)||
'    end loop;'||chr(10)||
'    htp.prn(DBMS_LOB.SUBSTR(V_HTML,V_LENGTH - V_START_OFFSET,V_START_OFFSET));'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 4274982442267386 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'MAKE_OPEN',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

--application/shared_components/logic/application_processes/make_closed
 
begin
 
declare
    p varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  V_HTML CLOB;'||chr(10)||
'  V_LENGTH NUMBER;'||chr(10)||
'  V_START_OFFSET NUMBER := 1;'||chr(10)||
'begin'||chr(10)||
'  V_HTML := XFILES_APEX_SERVICES.CLOSEFOLDER'||chr(10)||
'            ('||chr(10)||
'              :F101_USER_DN,'||chr(10)||
'              :APP_SESSION,'||chr(10)||
'              :PAGE_NUMBER'||chr(10)||
'            ).getClobVal();'||chr(10)||
'  V_LENGTH := DBMS_LOB.getLength(V_HTML);'||chr(10)||
'  if  (V_LENGTH < 4000) then'||chr(10)||
'    htp.prn(V_HTML);'||chr(10)||
'  else'||chr(10)||
'    while ((V_START_OFFSET + 4000) < V_LENGTH) loop'||chr(10)||
'';

p:=p||'      htp.prn(DBMS_LOB.SUBSTR(V_HTML,4000,V_START_OFFSET));'||chr(10)||
'      V_START_OFFSET := V_START_OFFSET + 4000;'||chr(10)||
'    end loop;'||chr(10)||
'    htp.prn(DBMS_LOB.SUBSTR(V_HTML,V_LENGTH - V_START_OFFSET,V_START_OFFSET));'||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_flow_process(
  p_id => 4275191100269847 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_process_sequence=> 1,
  p_process_point => 'ON_DEMAND',
  p_process_type=> 'PLSQL',
  p_process_name=> 'MAKE_CLOSED',
  p_process_sql_clob=> p,
  p_process_error_message=> '',
  p_process_when=> '',
  p_process_when_type=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_process_comment=> '');
end;
 
null;
 
end;
/

prompt  ...application items
--
--application/shared_components/logic/application_items/branch_id
 
begin
 
wwv_flow_api.create_flow_item(
  p_id=> 4272586318748034 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'BRANCH_ID',
  p_data_type=> 'VARCHAR',
  p_is_persistent=> 'Y',
  p_protection_level=> 'N',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_item_comment=> '');
 
null;
 
end;
/

--application/shared_components/logic/application_items/doc_id
 
begin
 
wwv_flow_api.create_flow_item(
  p_id=> 4234990788458358 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'DOC_ID',
  p_data_type=> 'VARCHAR',
  p_is_persistent=> 'Y',
  p_protection_level=> 'N',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_item_comment=> '');
 
null;
 
end;
/

--application/shared_components/logic/application_items/f101_timezone_offset
 
begin
 
wwv_flow_api.create_flow_item(
  p_id=> 3210971601608045 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'F101_TIMEZONE_OFFSET',
  p_data_type=> 'VARCHAR',
  p_is_persistent=> 'Y',
  p_protection_level=> 'N',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_item_comment=> 'Timezone offset from Browser. Need to workout how to set it ');
 
null;
 
end;
/

--application/shared_components/logic/application_items/f101_user_dn
 
begin
 
wwv_flow_api.create_flow_item(
  p_id=> 3235045708232996 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'F101_USER_DN',
  p_data_type=> 'VARCHAR',
  p_is_persistent=> 'Y',
  p_protection_level=> 'N',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_item_comment=> '');
 
null;
 
end;
/

--application/shared_components/logic/application_items/fsp_after_login_url
 
begin
 
wwv_flow_api.create_flow_item(
  p_id=> 5194399676809041 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'FSP_AFTER_LOGIN_URL',
  p_data_type=> 'VARCHAR',
  p_is_persistent=> 'Y',
  p_protection_level=> '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_item_comment=> '');
 
null;
 
end;
/

--application/shared_components/logic/application_items/page_number
 
begin
 
wwv_flow_api.create_flow_item(
  p_id=> 3267761324913775 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'PAGE_NUMBER',
  p_data_type=> 'VARCHAR',
  p_is_persistent=> 'Y',
  p_protection_level=> 'N',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_item_comment=> '');
 
null;
 
end;
/

prompt  ...application level computations
--
 
begin
 
null;
 
end;
/

prompt  ...Application Tabs
--
 
begin
 
--application/shared_components/navigation/tabs/standard/t_page_1
wwv_flow_api.create_tab (
  p_id=> 5191593016808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TS1',
  p_tab_sequence=> 10,
  p_tab_name=> 'T_PAGE_1',
  p_tab_text => 'Page 1',
  p_tab_step => 1,
  p_tab_also_current_for_pages => '',
  p_tab_parent_tabset=>'',
  p_required_patch=>null + wwv_flow_api.g_id_offset,
  p_tab_comment  => '');
 
 
end;
/

prompt  ...Application Parent Tabs
--
 
begin
 
null;
 
end;
/

prompt  ...Shared Lists of values
--
--application/shared_components/user_interface/lov/acl_list
 
begin
 
wwv_flow_api.create_list_of_values (
  p_id       => 4308082589965543 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_lov_name => 'ACL_LIST',
  p_lov_query=> 'select path d, path r'||chr(10)||
'  from path_view, ALL_XML_SCHEMAS'||chr(10)||
' where extractValue(res,''/Resource/SchOID'') = SCHEMA_ID '||chr(10)||
'   and OWNER = ''XDB'' '||chr(10)||
'   and SCHEMA_URL = ''http://xmlns.oracle.com/xdb/acl.xsd'''||chr(10)||
' order by 1');
 
null;
 
end;
/

--application/shared_components/user_interface/lov/character_set
 
begin
 
wwv_flow_api.create_list_of_values (
  p_id       => 3257768786341584 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_lov_name => 'CHARACTER_SET',
  p_lov_query=> 'select CHARSET_NAME, CHARSET_ID'||chr(10)||
'  from CHARACTER_SET_LOV'||chr(10)||
' order by 2');
 
null;
 
end;
/

--application/shared_components/user_interface/lov/language
 
begin
 
wwv_flow_api.create_list_of_values (
  p_id       => 3276148981506198 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_lov_name => 'LANGUAGE',
  p_lov_query=> 'select LANGUAGE_NAME, LANGUAGE_ID'||chr(10)||
'from   LANGUAGE_LOV'||chr(10)||
'order by LANGUAGE_NAME');
 
null;
 
end;
/

--application/shared_components/user_interface/lov/report_row_per_page
 
begin
 
wwv_flow_api.create_list_of_values (
  p_id       => 5190315716808443 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_lov_name => 'Report Row Per Page',
  p_lov_query=> '.'||to_char(5190315716808443 + wwv_flow_api.g_id_offset)||'.');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>5190412405808443 + wwv_flow_api.g_id_offset,
  p_lov_id=>5190315716808443 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>10,
  p_lov_disp_value=>'10',
  p_lov_return_value=>'10',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>5190490992808444 + wwv_flow_api.g_id_offset,
  p_lov_id=>5190315716808443 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>20,
  p_lov_disp_value=>'15',
  p_lov_return_value=>'15',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>5190604178808444 + wwv_flow_api.g_id_offset,
  p_lov_id=>5190315716808443 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>30,
  p_lov_disp_value=>'20',
  p_lov_return_value=>'20',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>5190689863808444 + wwv_flow_api.g_id_offset,
  p_lov_id=>5190315716808443 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>40,
  p_lov_disp_value=>'30',
  p_lov_return_value=>'30',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>5190808622808444 + wwv_flow_api.g_id_offset,
  p_lov_id=>5190315716808443 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>50,
  p_lov_disp_value=>'50',
  p_lov_return_value=>'50',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>5190893299808444 + wwv_flow_api.g_id_offset,
  p_lov_id=>5190315716808443 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>60,
  p_lov_disp_value=>'100',
  p_lov_return_value=>'100',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>5191018973808444 + wwv_flow_api.g_id_offset,
  p_lov_id=>5190315716808443 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>70,
  p_lov_disp_value=>'200',
  p_lov_return_value=>'200',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>5191097062808444 + wwv_flow_api.g_id_offset,
  p_lov_id=>5190315716808443 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>80,
  p_lov_disp_value=>'500',
  p_lov_return_value=>'500',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>5191204575808444 + wwv_flow_api.g_id_offset,
  p_lov_id=>5190315716808443 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>90,
  p_lov_disp_value=>'1000',
  p_lov_return_value=>'1000',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>5191290947808444 + wwv_flow_api.g_id_offset,
  p_lov_id=>5190315716808443 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>100,
  p_lov_disp_value=>'5000',
  p_lov_return_value=>'5000',
  p_lov_data_comment=> '');
 
null;
 
end;
/

--application/shared_components/user_interface/lov/true_false
 
begin
 
wwv_flow_api.create_list_of_values (
  p_id       => 3212064065705189 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_lov_name => 'TRUE_FALSE',
  p_lov_query=> '.'||to_char(3212064065705189 + wwv_flow_api.g_id_offset)||'.');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>3212364951705209 + wwv_flow_api.g_id_offset,
  p_lov_id=>3212064065705189 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>1,
  p_lov_disp_value=>'TRUE',
  p_lov_return_value=>'TRUE',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>3212562097705213 + wwv_flow_api.g_id_offset,
  p_lov_id=>3212064065705189 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>2,
  p_lov_disp_value=>'FALSE',
  p_lov_return_value=>'FALSE',
  p_lov_data_comment=> '');
 
null;
 
end;
/

--application/shared_components/user_interface/lov/upload_action
 
begin
 
wwv_flow_api.create_list_of_values (
  p_id       => 3279449784881777 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_lov_name => 'UPLOAD_ACTION',
  p_lov_query=> '.'||to_char(3279449784881777 + wwv_flow_api.g_id_offset)||'.');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>3279749324881819 + wwv_flow_api.g_id_offset,
  p_lov_id=>3279449784881777 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>1,
  p_lov_disp_value=>'Raise Error',
  p_lov_return_value=>'RAISE',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>3279947415881822 + wwv_flow_api.g_id_offset,
  p_lov_id=>3279449784881777 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>2,
  p_lov_disp_value=>'Create New Version',
  p_lov_return_value=>'VERSION',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>3280154300881822 + wwv_flow_api.g_id_offset,
  p_lov_id=>3279449784881777 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>3,
  p_lov_disp_value=>'Overwrite',
  p_lov_return_value=>'OVERWRITE',
  p_lov_data_comment=> '');
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_static_lov_data (
  p_id=>3280345648881822 + wwv_flow_api.g_id_offset,
  p_lov_id=>3279449784881777 + wwv_flow_api.g_id_offset,
  p_lov_disp_sequence=>4,
  p_lov_disp_value=>'Skip',
  p_lov_return_value=>'SKIP',
  p_lov_data_comment=> '');
 
null;
 
end;
/

prompt  ...Application Trees
--
--application/shared_components/navigation/trees
 
begin
 
wwv_flow_api.create_tree (
  p_id=> 4262985497919316 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'FolderTree',
  p_type=>'DYNAMIC',
  p_item=>'P6_TREE_ROOT',
  p_query=>'select "ID" id, '||chr(10)||
'       "PID" pid, '||chr(10)||
'       "NAME" name, '||chr(10)||
'       null link, '||chr(10)||
'       null a1, '||chr(10)||
'       null a2 '||chr(10)||
'from "#OWNER#"."WRITEABLE_FOLDER_VIEW"',
  p_levels=>5,
  p_unexpanded_parent=> '<td><a href="#DRILL_DOWN#"><img src="#IMAGE_PREFIX#Fndtre02.gif" width="16" height="22" border="0"></a></td><td><img src="#IMAGE_PREFIX#Fndtre_tfold.gif" width="16" height="16" border="0"></td>',
  p_unexpanded_parent_last=> '<td><a href="#DRILL_DOWN#"><img src="#IMAGE_PREFIX#Fndtre03.gif" width="16" height="22" border="0"></a></td><td><img src="#IMAGE_PREFIX#Fndtre_tfold.gif" width="16" height="16" border="0"></td>',
  p_expanded_parent=>'<td><a href="#DRILL_DOWN#"><img src="#IMAGE_PREFIX#Fndtre05.gif" width="16" height="22" border="0"></a></td><td><img src="#IMAGE_PREFIX#Fndtre_tfold.gif" width="16" height="16" border="0"></td>',
  p_expanded_parent_last=>'<td><a href="#DRILL_DOWN#"><img src="#IMAGE_PREFIX#Fndtre06.gif" width="16" height="22" border="0"></a></td><td><img src="#IMAGE_PREFIX#Fndtre_tfold.gif" width="16" height="16" border="0"></td>',
  p_leaf_node=>'<td align="left"><img src="#IMAGE_PREFIX#Fndtre07.gif" width="16" height="22" border="0"></td>',
  p_leaf_node_last=>'<td align="left"><img src="#IMAGE_PREFIX#Fndtre08.gif" width="16" height="22" border="0"></td>',
  p_name_link_anchor_tag=>'<a href="#LINK#">#NAME#</a>',
  p_name_link_not_anchor_tag=>'#NAME#',
  p_indent_vertical_line=>'<td><img src="#IMAGE_PREFIX#Fndtre09.gif" width="16" height="22" border="0"></td>',
  p_indent_vertical_line_last=>'<td><img src="#IMAGE_PREFIX#Fndtre10.gif" width="16" height="22" border="0"></td>',
  p_drill_up=>'&nbsp;(up)',
  p_before_tree=>'<table border="0" cellspacing="0" cellpadding="0">',
  p_after_tree=>'</table>',
  p_level_1_template=>'<tr>#INDENT#<td colspan="#COLSPAN#" valign="CENTER" class="tiny">#NAME##A1##A2# #DRILL_UP#</td></tr>',
  p_level_2_template=>'<tr>#INDENT#<td colspan="#COLSPAN#" valign="CENTER" class="tiny">#NAME##A1##A2#</td></tr>');
null;
 
end;
/

--application/pages/page_groups
prompt  ...page groups
--
 
begin
 
null;
 
end;
/

--application/comments
prompt  ...comments: requires application express 2.2 or higher
--
 
--application/pages/page_00000
prompt  ...PAGE 0: Global
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 0,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Global',
  p_alias  => 'GLOBAL',
  p_step_title=> 'Global',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'CARL',
  p_last_upd_yyyymmddhh24miss => '20080917170050',
  p_page_comment  => '');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'<style>'||chr(10)||
'#MENU_HOLDER{position:absolute;border:1px solid black;border-bottom:none;background-color:#fff;width:200px;}'||chr(10)||
'#MENU_HOLDER a{font-size:11px;display:block;border-bottom:1px solid black;padding:2px 6px;text-decoration:none;}'||chr(10)||
'#MENU_HOLDER a:hover{background-color:#ccc;}'||chr(10)||
'#tree_drop img{cursor:pointer;}'||chr(10)||
'</style>';

wwv_flow_api.create_page_plug (
  p_id=> 4235767333508330 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 0,
  p_plug_name=> 'CSS',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_HEADER',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 0
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00001
prompt  ...PAGE 1: Folder Browser
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph:=ph||'<script>'||chr(10)||
'function makeOpen(id) {'||chr(10)||
'  var get = new htmldb_Get'||chr(10)||
'  ('||chr(10)||
'    null,'||chr(10)||
'    $v(''pFlowId''),'||chr(10)||
'    ''APPLICATION_PROCESS=MAKE_OPEN'','||chr(10)||
'    0'||chr(10)||
'  );  '||chr(10)||
'  get.add(''BRANCH_ID'',id) ;'||chr(10)||
'  gReturn = get.get();  '||chr(10)||
'  $s(''targetFolderTree'',gReturn);'||chr(10)||
'  get = null;  '||chr(10)||
'  var targetURL = ''f?p='' + $v(''pFlowId'') + '':FOLDERBROWSER:'' + $v(''pInstance'') + '':'' + $v(''pRequest'') + '':'' + $v('':DEBUG'') + ''::P1_CURRENT_FOLDER:'' + $x(''';

ph:=ph||'currentPath'').value;'||chr(10)||
'  window.location=targetURL ;'||chr(10)||
'}'||chr(10)||
'function makeClosed(id) {'||chr(10)||
'  var get = new htmldb_Get'||chr(10)||
'  ('||chr(10)||
'    null,'||chr(10)||
'    $v(''pFlowId''),'||chr(10)||
'    ''APPLICATION_PROCESS=MAKE_CLOSED'','||chr(10)||
'    0'||chr(10)||
'  );  '||chr(10)||
'  get.add(''BRANCH_ID'',id) ;'||chr(10)||
'  gReturn = get.get();  '||chr(10)||
'  $s(''targetFolderTree'',gReturn);'||chr(10)||
'  get = null;  '||chr(10)||
'}'||chr(10)||
'function showChildren(id) {'||chr(10)||
'  var get = new htmldb_Get'||chr(10)||
'  ('||chr(10)||
'    null,'||chr(10)||
'    $v(''pFlowId''),'||chr(10)||
'    ''APPLICATION';

ph:=ph||'_PROCESS=SHOW_CHILDREN'','||chr(10)||
'    0'||chr(10)||
'  );  '||chr(10)||
'  get.add(''BRANCH_ID'',id) ;'||chr(10)||
'  gReturn = get.get();  '||chr(10)||
'  $s(''targetFolderTree'',gReturn);'||chr(10)||
'  get = null;  '||chr(10)||
'}'||chr(10)||
'function hideChildren(id) {'||chr(10)||
'  var get = new htmldb_Get'||chr(10)||
'  ('||chr(10)||
'    null,'||chr(10)||
'    $v(''pFlowId''),'||chr(10)||
'    ''APPLICATION_PROCESS=HIDE_CHILDREN'','||chr(10)||
'    0'||chr(10)||
'  );  '||chr(10)||
'  get.add(''BRANCH_ID'',id) ;'||chr(10)||
'  gReturn = get.get();  '||chr(10)||
'  $s(''targetFolderTree'',gReturn);'||chr(10)||
'  get = null;  '||chr(10)||
'}'||chr(10)||
'function s';

ph:=ph||'electBranch(id) {'||chr(10)||
'  alert(''select Branch '' + id);'||chr(10)||
'}'||chr(10)||
'function unselectBranch(id) {'||chr(10)||
'  alert(''unselect Branch '' + id);'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'var gRow;'||chr(10)||
'function doc_menu(pThis,pId){'||chr(10)||
'	var lDiv = $x(pThis);'||chr(10)||
'	if(gRow!=lDiv){$x_Hide(gMenu)}'||chr(10)||
'	gRowClick = $x_UpTill(lDiv,''TR'');'||chr(10)||
'	if(!gMenu){'||chr(10)||
'		 gMenu = $x_AddTag(document.body,''div'','''');'||chr(10)||
'		 gMenu.id = ''MENU_HOLDER'';'||chr(10)||
'	}'||chr(10)||
'  gMenu.style.top = parseInt(findPosY(lDiv));'||chr(10)||
'  gMenu.style.';

ph:=ph||'left = parseInt(findPosX(lDiv) + parseInt(lDiv.offsetWidth));'||chr(10)||
'	$x_Show(gMenu);'||chr(10)||
'	var get = new htmldb_Get(null,html_GetElement(''pFlowId'').value,''APPLICATION_PROCESS=DOC_MENU'',0);'||chr(10)||
'	get.add(''DOC_ID'',pId);'||chr(10)||
'	get.GetAsync(doc_menu_click_return);'||chr(10)||
'	return;'||chr(10)||
'}'||chr(10)||
''||chr(10)||
''||chr(10)||
'function doc_menu_off(evt){}'||chr(10)||
''||chr(10)||
'var gMenu = false;'||chr(10)||
''||chr(10)||
'function doc_menu_click_return(){'||chr(10)||
'		if(p.readyState == 1){'||chr(10)||
'					gMenu.innerHTML = ''<a>..loading..';

ph:=ph||'</a>'';'||chr(10)||
'					$x_Show(gMenu);'||chr(10)||
'		}'||chr(10)||
'		else if(p.readyState == 2){}'||chr(10)||
'		else if(p.readyState == 3){}'||chr(10)||
'		else if(p.readyState == 4){'||chr(10)||
'					gMenu.innerHTML = p.responseText;'||chr(10)||
'					$x_Show(gMenu);'||chr(10)||
'					document.onclick = function(evt){doc_menu_click_check(evt);};'||chr(10)||
'		}else{return false;}'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function doc_menu_click_check(evt){'||chr(10)||
'  var tPar = html_GetTarget(evt);'||chr(10)||
'  var l_Test = true;'||chr(10)||
'    while(tPar.nodeName != ''BODY';

ph:=ph||'''){'||chr(10)||
'  	  tPar = tPar.parentNode;'||chr(10)||
'      if(gMenu == tPar){l_Test = !l_Test;}'||chr(10)||
'    }'||chr(10)||
'  if(l_Test){'||chr(10)||
'		$x_Hide(gMenu);'||chr(10)||
'		gMenu.innerHTML = ''<a>..loading..</a>'';'||chr(10)||
'		document.onclick = null;'||chr(10)||
'  }'||chr(10)||
'  else{}'||chr(10)||
'  return;'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 1,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> 'TS1',
  p_name   => 'Folder Browser',
  p_alias  => 'FOLDERBROWSER',
  p_step_title=> 'XFILES Folder Browser',
  p_step_sub_title => 'Page 1',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => 'ON',
  p_help_text => ' ',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'ADMIN',
  p_last_upd_yyyymmddhh24miss => '20091013155834',
  p_page_is_public_y_n=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>1,p_text=>h);
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>1,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'htp.prn'||chr(10)||
'('||chr(10)||
'  XFILES_APEX_SERVICES.GETVISABLEFOLDERSTREE'||chr(10)||
'  ('||chr(10)||
'    :F101_USER_DN,'||chr(10)||
'    :APP_SESSION, '||chr(10)||
'    :APP_PAGE_ID, '||chr(10)||
'    :P1_CURRENT_FOLDER'||chr(10)||
'  ).getClobVal()'||chr(10)||
');'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 3266545240882011 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_plug_name=> 'Folders',
  p_region_name=>'',
  p_plug_template=> 4250378089114043+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 20,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => '',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_header=> '<div id="targetFolderTree">',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'SELECT "NAME",'||chr(10)||
'       "ICON",'||chr(10)||
'       "XFILES_APEX_SERVICES"."URLFROMCONTENTTYPE"'||chr(10)||
'       ('||chr(10)||
'         ''true'','||chr(10)||
'         NULL,'||chr(10)||
'         PAT.PATH,'||chr(10)||
'         :APP_ID,'||chr(10)||
'         ''FOLDERBROWSER'', '||chr(10)||
'         :APP_SESSION, '||chr(10)||
'         :REQUEST,'||chr(10)||
'         :DEBUG'||chr(10)||
'       ) as "LINK"'||chr(10)||
'  FROM TABLE'||chr(10)||
'       ('||chr(10)||
'         XFILES_APEX_SERVICES.PATHASTABLE'||chr(10)||
'         ('||chr(10)||
'           :P1_CURRENT_FOLDER'||chr(10)||
'         )'||chr(10)||
'       ) PAT;';

wwv_flow_api.create_report_region (
  p_id=> 3289974152376505 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_name=> 'Current Path ',
  p_region_name=>'',
  p_template=> 4250378089114043+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 5,
  p_display_column=> 2,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> '#SQLERRM#',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '0',
  p_translate_title=> 'N',
  p_ajax_enabled=> 'Y',
  p_query_row_template=> 3292071765678588+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'NO_HEADINGS',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_show_nulls_as=> ' - ',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'no data found',
  p_query_num_rows_type=> '0',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_sort_null=> 'F',
  p_query_asc_image=> 'arrow_down_gray_dark.gif',
  p_query_asc_image_attr=> 'width="13" height="12" alt=""',
  p_query_desc_image=> 'arrow_up_gray_dark.gif',
  p_query_desc_image_attr=> 'width="13" height="12" alt=""',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3295546549551256 + wwv_flow_api.g_id_offset,
  p_region_id=> 3289974152376505 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'NAME',
  p_column_display_sequence=> 2,
  p_column_heading=> '',
  p_column_link=>'#LINK#',
  p_column_linktext=>'#NAME#',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3295752891551258 + wwv_flow_api.g_id_offset,
  p_region_id=> 3289974152376505 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'ICON',
  p_column_display_sequence=> 1,
  p_column_heading=> '',
  p_column_html_expression=>'<img src="#ICON#" href=#LINK#>',
  p_column_link=>'#LINK#',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3298158248649297 + wwv_flow_api.g_id_offset,
  p_region_id=> 3289974152376505 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'LINK',
  p_column_display_sequence=> 3,
  p_column_heading=> '',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'select nPATH	          "PATH",'||chr(10)||
'       nRESID	          "RESID",'||chr(10)||
'       nIS_FOLDER	  "IS_FOLDER",'||chr(10)||
'       nVERSION_ID	  "VERSION_ID",'||chr(10)||
'       nCHECKED_OUT       "CHECKED_OUT",'||chr(10)||
'       nCREATION_DATE     "CREATION_DATE",'||chr(10)||
'       nMODIFICATION_DATE "MODIFICATION_DATE",'||chr(10)||
'       nAUTHOR	          "AUTHOR",'||chr(10)||
'       nDISPLAY_NAME      "DISPLAY_NAME",'||chr(10)||
'       nCOMMENT	          "COMMENT",'||chr(10)||
'       nLANGUAGE	  "LAN';

s:=s||'GUAGE",'||chr(10)||
'       nCHARACTER_SET     "CHARACTER_SET",'||chr(10)||
'       nCONTENT_TYPE      "CONTENT_TYPE",'||chr(10)||
'       nOWNED_BY	  "OWNED_BY",'||chr(10)||
'       nCREATED_BY	  "CREATED_BY",'||chr(10)||
'       nLAST_MODIFIED_BY  "LAST_MODIFIED_BY",'||chr(10)||
'       nCHECKED_OUT_BY    "CHECKED_OUT_BY",'||chr(10)||
'       nLOCK_BUFFER       "LOCK_BUFFER",'||chr(10)||
'       nVERSION_SERIES_ID "VERSION_SERIES_ID",'||chr(10)||
'       nACL_OID	          "ACL_OID",'||chr(10)||
'       nSCHEMA_OID	  "SCHE';

s:=s||'MA_OID",'||chr(10)||
'       nGLOBAL_ELEMENT_ID "GLOBAL_ELEMENT_ID",'||chr(10)||
'       nLINK_NAME	  "LINK_NAME",'||chr(10)||
'       nCHILD_PATH	  "CHILD_PATH",'||chr(10)||
'       nICON_PATH	  "ICON_PATH",'||chr(10)||
'       nTARGET_URL	  "TARGET_URL",'||chr(10)||
'       nRESOURCE_STATUS   "RESOURCE_STATUS"'||chr(10)||
'  from TABLE'||chr(10)||
'       ('||chr(10)||
'	 "XFILES_APEX_SERVICES"."LISTDIRECTORY"'||chr(10)||
'         ('||chr(10)||
'            :F101_USER_DN,'||chr(10)||
'            :P1_CURRENT_FOLDER,'||chr(10)||
'            :APP_ID, '||chr(10)||
'         ';

s:=s||'   ''FOLDERBROWSER'', '||chr(10)||
'            :APP_SESSION, '||chr(10)||
'            :REQUEST, '||chr(10)||
'            :DEBUG'||chr(10)||
'         )'||chr(10)||
'       )'||chr(10)||
''||chr(10)||
'/*'||chr(10)||
'select * from ('||chr(10)||
'select	 "XFILES_APEX_SERVICES"."ICONFROMCONTENTTYPE"("APEX_PATH_VIEW"."IS_FOLDER","APEX_PATH_VIEW"."CONTENT_TYPE") as "ICON_PATH",'||chr(10)||
'         "XFILES_APEX_SERVICES"."URLFROMCONTENTTYPE"("APEX_PATH_VIEW"."IS_FOLDER","APEX_PATH_VIEW"."CONTENT_TYPE","APEX_PATH_VIEW"."PATH", ';

s:=s||':APP_ID, ''FOLDERBROWSER'', :APP_SESSION, :REQUEST, :DEBUG) as "TARGET_URL",'||chr(10)||
'         "XFILES_APEX_SERVICES"."ICONSFORSTATUS"("APEX_PATH_VIEW"."VERSION_ID","APEX_PATH_VIEW"."CHECKED_OUT","APEX_PATH_VIEW"."LOCK_BUFFER") as "RESOURCE_STATUS",'||chr(10)||
'         "APEX_PATH_VIEW"."IS_FOLDER" as "IS_FOLDER",'||chr(10)||
'	 "APEX_PATH_VIEW"."DISPLAY_NAME" as "DISPLAY_NAME",'||chr(10)||
'	 "APEX_PATH_VIEW"."OWNED_BY" as "OWNED_BY",'||chr(10)||
'	 "APEX_P';

s:=s||'ATH_VIEW"."LAST_MODIFIED_BY" as "LAST_MODIFIED_BY",'||chr(10)||
'	 "APEX_PATH_VIEW"."MODIFICATION_DATE" as "MODIFICATION_DATE",'||chr(10)||
'	 "APEX_PATH_VIEW"."CREATED_BY" as "CREATED_BY", '||chr(10)||
'	 "APEX_PATH_VIEW"."CREATION_DATE" as "CREATION_DATE",'||chr(10)||
'	 "APEX_PATH_VIEW"."AUTHOR" as "AUTHOR",'||chr(10)||
'	 "APEX_PATH_VIEW"."COMMENT" as "COMMENT",'||chr(10)||
'	 "APEX_PATH_VIEW"."LANGUAGE" as "LANGUAGE",'||chr(10)||
'	 "APEX_PATH_VIEW"."CHARACTER_SET" as "CHARACTER_SE';

s:=s||'T",'||chr(10)||
'	 "APEX_PATH_VIEW"."CONTENT_TYPE" as "CONTENT_TYPE",'||chr(10)||
'	 "APEX_PATH_VIEW"."CHECKED_OUT_BY" as "CHECKED_OUT_BY",'||chr(10)||
'         CASE  '||chr(10)||
'            WHEN (:P1_CURRENT_FOLDER = ''/'') THEN ''/'' ||  "APEX_PATH_VIEW"."LINK_NAME" '||chr(10)||
'            ELSE :P1_CURRENT_FOLDER || ''/'' ||  "APEX_PATH_VIEW"."LINK_NAME" '||chr(10)||
'         END as "CHILD_PATH",'||chr(10)||
'         "APEX_PATH_VIEW"."RESID" as "RESID",'||chr(10)||
'         "APEX_PATH_VIEW"."PAT';

s:=s||'H" as "PATH"'||chr(10)||
' from	 "APEX_PATH_VIEW" "APEX_PATH_VIEW"'||chr(10)||
'where under_path(res,1,:P1_CURRENT_FOLDER) = 1)'||chr(10)||
'where ('||chr(10)||
' instr(upper("DISPLAY_NAME"),upper(nvl(:P1_REPORT_SEARCH,"DISPLAY_NAME"))) > 0  or'||chr(10)||
' instr(upper("OWNED_BY"),upper(nvl(:P1_REPORT_SEARCH,"OWNED_BY"))) > 0  or'||chr(10)||
' instr(upper("LAST_MODIFIED_BY"),upper(nvl(:P1_REPORT_SEARCH,"LAST_MODIFIED_BY"))) > 0  or'||chr(10)||
' instr(upper("CREATED_BY"),upper(nvl(:P1_';

s:=s||'REPORT_SEARCH,"CREATED_BY"))) > 0  or'||chr(10)||
' instr(upper("AUTHOR"),upper(nvl(:P1_REPORT_SEARCH,"AUTHOR"))) > 0  or'||chr(10)||
' instr(upper("COMMENT"),upper(nvl(:P1_REPORT_SEARCH,"COMMENT"))) > 0  or'||chr(10)||
' instr(upper("LANGUAGE"),upper(nvl(:P1_REPORT_SEARCH,"LANGUAGE"))) > 0  or'||chr(10)||
' instr(upper("CHARACTER_SET"),upper(nvl(:P1_REPORT_SEARCH,"CHARACTER_SET"))) > 0  or'||chr(10)||
' instr(upper("CONTENT_TYPE"),upper(nvl(:P1_REPORT_SEARCH,"';

s:=s||'CONTENT_TYPE"))) > 0  or'||chr(10)||
' instr(upper("CHECKED_OUT_BY"),upper(nvl(:P1_REPORT_SEARCH,"CHECKED_OUT_BY"))) > 0 '||chr(10)||
')'||chr(10)||
'*/';

wwv_flow_api.create_report_region (
  p_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 1,
  p_name=> 'Folder Contents',
  p_region_name=>'',
  p_template=> 4250378089114043+ wwv_flow_api.g_id_offset,
  p_display_sequence=> 10,
  p_display_column=> 2,
  p_display_point=> 'AFTER_SHOW_ITEMS',
  p_source=> s,
  p_source_type=> 'SQL_QUERY',
  p_display_error_message=> 'Unable to show report.',
  p_plug_caching=> 'NOT_CACHED',
  p_customized=> '1',
  p_translate_title=> 'Y',
  p_ajax_enabled=> 'N',
  p_query_row_template=> 4259062755114060+ wwv_flow_api.g_id_offset,
  p_query_headings_type=> 'COLON_DELMITED_LIST',
  p_query_num_rows=> '15',
  p_query_options=> 'DERIVED_REPORT_COLUMNS',
  p_query_break_cols=> '0',
  p_query_no_data_found=> 'Empty Folder',
  p_query_num_rows_item=> 'P1_ROWS',
  p_query_num_rows_type=> '0',
  p_query_row_count_max=> '500',
  p_pagination_display_position=> 'BOTTOM_RIGHT',
  p_csv_output=> 'N',
  p_prn_output=> 'N',
  p_prn_format=> 'PDF',
  p_prn_output_show_link=> 'Y',
  p_prn_output_link_text=> 'Print',
  p_prn_content_disposition=> 'ATTACHMENT',
  p_prn_document_header=> 'APEX',
  p_prn_units=> 'INCHES',
  p_prn_paper_size=> 'LETTER',
  p_prn_width_units=> 'PERCENTAGE',
  p_prn_width=> 11,
  p_prn_height=> 8.5,
  p_prn_orientation=> 'HORIZONTAL',
  p_prn_page_header_font_color=> '#000000',
  p_prn_page_header_font_family=> 'Helvetica',
  p_prn_page_header_font_weight=> 'normal',
  p_prn_page_header_font_size=> '12',
  p_prn_page_footer_font_color=> '#000000',
  p_prn_page_footer_font_family=> 'Helvetica',
  p_prn_page_footer_font_weight=> 'normal',
  p_prn_page_footer_font_size=> '12',
  p_prn_header_bg_color=> '#9bafde',
  p_prn_header_font_color=> '#ffffff',
  p_prn_header_font_family=> 'Helvetica',
  p_prn_header_font_weight=> 'normal',
  p_prn_header_font_size=> '10',
  p_prn_body_bg_color=> '#efefef',
  p_prn_body_font_color=> '#000000',
  p_prn_body_font_family=> 'Helvetica',
  p_prn_body_font_weight=> 'normal',
  p_prn_body_font_size=> '10',
  p_prn_border_width=> .5,
  p_prn_page_header_alignment=> 'LEFT',
  p_prn_page_footer_alignment=> 'LEFT',
  p_sort_null=> 'F',
  p_query_asc_image=> 'themes/theme_11/sort_arrow_down.gif',
  p_query_asc_image_attr=> 'width="13" height="12"',
  p_query_desc_image=> 'themes/theme_11/sort_arrow_up.gif',
  p_query_desc_image_attr=> 'width="13" height="12"',
  p_plug_query_strip_html=> 'Y',
  p_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4283172838739853 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 1,
  p_form_element_id=> null,
  p_column_alias=> 'PATH',
  p_column_display_sequence=> 19,
  p_column_heading=> 'Path',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'N',
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4239676748091393 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 2,
  p_form_element_id=> null,
  p_column_alias=> 'RESID',
  p_column_display_sequence=> 18,
  p_column_heading=> 'Resid',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'N',
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5318106400307735 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 3,
  p_form_element_id=> null,
  p_column_alias=> 'IS_FOLDER',
  p_column_display_sequence=> 17,
  p_column_heading=> 'Is Folder',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>1,
  p_default_sort_dir=>'desc',
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'N',
  p_print_col_width=> '0',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3312175514726463 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 4,
  p_form_element_id=> null,
  p_column_alias=> 'VERSION_ID',
  p_column_display_sequence=> 21,
  p_column_heading=> 'Version Id',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3312253832726466 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 5,
  p_form_element_id=> null,
  p_column_alias=> 'CHECKED_OUT',
  p_column_display_sequence=> 22,
  p_column_heading=> 'Checked Out',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5192386733808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 6,
  p_form_element_id=> null,
  p_column_alias=> 'CREATION_DATE',
  p_column_display_sequence=> 8,
  p_column_heading=> 'Creation Date',
  p_column_format=> 'DD-MON-YYYY HH24:MI:SS',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_alignment=>'RIGHT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_ref_schema=> 'XFILESDEV',
  p_ref_column_name=> 'CREATION_DATE',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5192191491808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 7,
  p_form_element_id=> null,
  p_column_alias=> 'MODIFICATION_DATE',
  p_column_display_sequence=> 6,
  p_column_heading=> 'Modification Date',
  p_column_format=> 'DD-MON-YYYY HH24:MI:SS',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_alignment=>'RIGHT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_ref_schema=> 'XFILESDEV',
  p_ref_column_name=> 'MODIFICATION_DATE',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5192508659808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 8,
  p_form_element_id=> null,
  p_column_alias=> 'AUTHOR',
  p_column_display_sequence=> 9,
  p_column_heading=> 'Author',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_ref_schema=> 'XFILESDEV',
  p_ref_column_name=> 'AUTHOR',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5191902886808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 9,
  p_form_element_id=> null,
  p_column_alias=> 'DISPLAY_NAME',
  p_column_display_sequence=> 15,
  p_column_heading=> 'Display Name',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_link=>'#TARGET_URL#',
  p_column_linktext=>'#LINK_NAME#',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_when_condition=> '#IS_FOLDER"',
  p_display_when_condition2=> 'true',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'N',
  p_print_col_width=> '2',
  p_ref_column_name=> 'DISPLAY_NAME',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5192589839808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 10,
  p_form_element_id=> null,
  p_column_alias=> 'COMMENT',
  p_column_display_sequence=> 10,
  p_column_heading=> 'Comment',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_ref_schema=> 'XFILESDEV',
  p_ref_column_name=> 'COMMENT',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5192697845808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 11,
  p_form_element_id=> null,
  p_column_alias=> 'LANGUAGE',
  p_column_display_sequence=> 11,
  p_column_heading=> 'Language',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_ref_schema=> 'XFILESDEV',
  p_ref_column_name=> 'LANGUAGE',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5192814335808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 12,
  p_form_element_id=> null,
  p_column_alias=> 'CHARACTER_SET',
  p_column_display_sequence=> 12,
  p_column_heading=> 'Character Set',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_ref_schema=> 'XFILESDEV',
  p_ref_column_name=> 'CHARACTER_SET',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5192898679808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 13,
  p_form_element_id=> null,
  p_column_alias=> 'CONTENT_TYPE',
  p_column_display_sequence=> 13,
  p_column_heading=> 'Content Type',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_ref_schema=> 'XFILESDEV',
  p_ref_column_name=> 'CONTENT_TYPE',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5191988756808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 14,
  p_form_element_id=> null,
  p_column_alias=> 'OWNED_BY',
  p_column_display_sequence=> 4,
  p_column_heading=> 'Owner',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_ref_schema=> 'XFILESDEV',
  p_ref_column_name=> 'OWNED_BY',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5192309494808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 15,
  p_form_element_id=> null,
  p_column_alias=> 'CREATED_BY',
  p_column_display_sequence=> 7,
  p_column_heading=> 'Creator',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_ref_schema=> 'XFILESDEV',
  p_ref_column_name=> 'CREATED_BY',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5192097984808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 16,
  p_form_element_id=> null,
  p_column_alias=> 'LAST_MODIFIED_BY',
  p_column_display_sequence=> 5,
  p_column_heading=> 'Last Modified By',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_ref_schema=> 'XFILESDEV',
  p_ref_column_name=> 'LAST_MODIFIED_BY',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5193016340808447 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 17,
  p_form_element_id=> null,
  p_column_alias=> 'CHECKED_OUT_BY',
  p_column_display_sequence=> 14,
  p_column_heading=> 'Checked Out By',
  p_column_hit_highlight=>'&P1_REPORT_SEARCH.',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_ref_schema=> 'XFILESDEV',
  p_ref_column_name=> 'CHECKED_OUT_BY',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3312374934726466 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 18,
  p_form_element_id=> null,
  p_column_alias=> 'LOCK_BUFFER',
  p_column_display_sequence=> 23,
  p_column_heading=> 'Lock Buffer',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3312458945726466 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 19,
  p_form_element_id=> null,
  p_column_alias=> 'VERSION_SERIES_ID',
  p_column_display_sequence=> 24,
  p_column_heading=> 'Version Series Id',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3312544250726466 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 20,
  p_form_element_id=> null,
  p_column_alias=> 'ACL_OID',
  p_column_display_sequence=> 25,
  p_column_heading=> 'Acl Oid',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3312666049726466 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 21,
  p_form_element_id=> null,
  p_column_alias=> 'SCHEMA_OID',
  p_column_display_sequence=> 26,
  p_column_heading=> 'Schema Oid',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3312757295726466 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 22,
  p_form_element_id=> null,
  p_column_alias=> 'GLOBAL_ELEMENT_ID',
  p_column_display_sequence=> 27,
  p_column_heading=> 'Global Element Id',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 3312862951726466 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 23,
  p_form_element_id=> null,
  p_column_alias=> 'LINK_NAME',
  p_column_display_sequence=> 2,
  p_column_heading=> 'Name',
  p_column_link=>'#TARGET_URL#',
  p_column_linktext=>'#LINK_NAME#',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>2,
  p_disable_sort_column=>'N',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5211514006172727 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 24,
  p_form_element_id=> null,
  p_column_alias=> 'CHILD_PATH',
  p_column_display_sequence=> 16,
  p_column_heading=> 'Child Path',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'N',
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 5315388561264732 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 25,
  p_form_element_id=> null,
  p_column_alias=> 'ICON_PATH',
  p_column_display_sequence=> 1,
  p_column_heading=> 'Type',
  p_column_html_expression=>'<img src="#ICON_PATH#" onclick="doc_menu(this,escape(''#PATH#''))" />',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_lov_show_nulls=> 'NO',
  p_pk_col_source=> s,
  p_lov_display_extra=> 'YES',
  p_include_in_export=> 'Y',
  p_print_col_width=> '0',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4285685052500494 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 26,
  p_form_element_id=> null,
  p_column_alias=> 'TARGET_URL',
  p_column_display_sequence=> 20,
  p_column_heading=> 'Target Url',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'Y',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'N',
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
declare
  s varchar2(32767) := null;
begin
s := null;
wwv_flow_api.create_report_columns (
  p_id=> 4304062837966931 + wwv_flow_api.g_id_offset,
  p_region_id=> 5191691449808444 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_query_column_id=> 27,
  p_form_element_id=> null,
  p_column_alias=> 'RESOURCE_STATUS',
  p_column_display_sequence=> 3,
  p_column_heading=> 'Status',
  p_column_alignment=>'LEFT',
  p_heading_alignment=>'CENTER',
  p_default_sort_column_sequence=>0,
  p_disable_sort_column=>'Y',
  p_sum_column=> 'N',
  p_hidden_column=> 'N',
  p_display_as=>'WITHOUT_MODIFICATION',
  p_pk_col_source=> s,
  p_include_in_export=> 'Y',
  p_print_col_width=> '2',
  p_column_comment=>'');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 5329405847772025 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1,
  p_button_sequence=> 10,
  p_button_plug_id => 5191691449808444+wwv_flow_api.g_id_offset,
  p_button_name    => 'CREATEFOLDER_B',
  p_button_image   => 'template:'||to_char(4245073391114034+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'CreateFolder',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'f?p=&APP_ID.:4:&SESSION.::&DEBUG.:4::',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5344596236903625 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 1,
  p_button_sequence=> 10,
  p_button_plug_id => 5191691449808444+wwv_flow_api.g_id_offset,
  p_button_name    => 'UPLOAD_DOCUMENT_B',
  p_button_image   => 'template:'||to_char(4245073391114034+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Upload Document',
  p_button_position=> 'BOTTOM',
  p_button_alignment=> 'LEFT',
  p_button_redirect_url=> 'f?p=&APP_ID.:7:&SESSION.::&DEBUG.:7::',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>5193708972808450 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_branch_action=> 'f?p=&APP_ID.:1:&SESSION.::&DEBUG.::P1_CURRENT_FOLDER:P1_CURRENT_FOLDER',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5197714398851154 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 1,
  p_name=>'P1_CURRENT_FOLDER',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 5191691449808444+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Current Folder',
  p_source=>'/',
  p_source_type=> 'STATIC',
  p_display_as=> 'HIDDEN_PROTECTED',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'U',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'reset_pagination';

wwv_flow_api.create_page_process(
  p_id     => 5193508372808450 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 1,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'RESET_PAGINATION',
  p_process_name=> 'Reset Pagination',
  p_process_sql_clob => p, 
  p_process_error_message=> 'Unable to reset pagination.',
  p_process_when=>'Go,P1_REPORT_SEARCH',
  p_process_when_type=>'REQUEST_IN_CONDITION',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 1
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00003
prompt  ...PAGE 3: Confirm Action
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph:=ph||'<script language="javascript">'||chr(10)||
''||chr(10)||
'function makeOpen(id) {'||chr(10)||
'  var get = new htmldb_Get'||chr(10)||
'  ('||chr(10)||
'    null,'||chr(10)||
'    $v(''pFlowId''),'||chr(10)||
'    ''APPLICATION_PROCESS=MAKE_OPEN'','||chr(10)||
'    0'||chr(10)||
'  );  '||chr(10)||
'  get.add(''BRANCH_ID'',id);'||chr(10)||
'  gReturn = get.get();  '||chr(10)||
'  $s(''targetFolderTree'',gReturn);'||chr(10)||
'  get = null;  '||chr(10)||
'  $s(''P3_FOLDER_PATH'',$x(''currentPath'').value);'||chr(10)||
'}'||chr(10)||
'function makeClosed(id) {'||chr(10)||
'  var get = new htmldb_Get'||chr(10)||
'  ('||chr(10)||
'    null,'||chr(10)||
'    $v(''pFlowId';

ph:=ph||'''),'||chr(10)||
'    ''APPLICATION_PROCESS=MAKE_CLOSED'','||chr(10)||
'    0'||chr(10)||
'  );  '||chr(10)||
'  get.add(''BRANCH_ID'',id) ;'||chr(10)||
'  gReturn = get.get();  '||chr(10)||
'  $s(''targetFolderTree'',gReturn);'||chr(10)||
'  get = null;  '||chr(10)||
'}'||chr(10)||
'function showChildren(id) {'||chr(10)||
'  var get = new htmldb_Get'||chr(10)||
'  ('||chr(10)||
'    null,'||chr(10)||
'    $v(''pFlowId''),'||chr(10)||
'    ''APPLICATION_PROCESS=SHOW_CHILDREN'','||chr(10)||
'    0'||chr(10)||
'  );  '||chr(10)||
'  get.add(''BRANCH_ID'',id) ;'||chr(10)||
'  gReturn = get.get();  '||chr(10)||
'  $s(''targetFolderTree'',gReturn);'||chr(10)||
'  get = nu';

ph:=ph||'ll;  '||chr(10)||
'}'||chr(10)||
'function hideChildren(id) {'||chr(10)||
'  var get = new htmldb_Get'||chr(10)||
'  ('||chr(10)||
'    null,'||chr(10)||
'    $v(''pFlowId''),'||chr(10)||
'    ''APPLICATION_PROCESS=HIDE_CHILDREN'','||chr(10)||
'    0'||chr(10)||
'  );  '||chr(10)||
'  get.add(''BRANCH_ID'',id) ;'||chr(10)||
'  gReturn = get.get();  '||chr(10)||
'  $s(''targetFolderTree'',gReturn);'||chr(10)||
'  get = null;  '||chr(10)||
'}'||chr(10)||
'function decodeDocumentURL() {'||chr(10)||
'  $s(''P3_DOCUMENT_PATH'',unescape($v(''P3_DOCUMENT_PATH'')));'||chr(10)||
'}'||chr(10)||
''||chr(10)||
'function setACLPath(path) {'||chr(10)||
'  $s(''P3_SELECTED_ACL_PA';

ph:=ph||'TH'',path);'||chr(10)||
'}'||chr(10)||
'</script>';

wwv_flow_api.create_page(
  p_id     => 3,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Confirm Action',
  p_alias  => 'ACTIONS',
  p_step_title=> 'Actions',
  p_html_page_onload=>'onload="decodeDocumentURL()"',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_help_text => '',
  p_html_page_header => ' ',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'ADMIN',
  p_last_upd_yyyymmddhh24miss => '20091010150221',
  p_page_is_public_y_n=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_html_page_header(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>3,p_text=>ph);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s:=s||'htp.prn'||chr(10)||
'('||chr(10)||
'  XFILES_APEX_SERVICES.GETWRITABLEFOLDERSTREE'||chr(10)||
'  ('||chr(10)||
'    :F101_USER_DN,'||chr(10)||
'    :APP_SESSION, '||chr(10)||
'    :APP_PAGE_ID, '||chr(10)||
'    :P1_CURRENT_FOLDER'||chr(10)||
'  ).getClobVal()'||chr(10)||
');'||chr(10)||
'';

wwv_flow_api.create_page_plug (
  p_id=> 4276491593531710 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Select Folder',
  p_region_name=>'',
  p_plug_template=> 4250378089114043+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 50,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'PLSQL_PROCEDURE',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'QUERY_COLUMNS',
  p_plug_query_num_rows => 15,
  p_plug_query_num_rows_type => 'NEXT_PREVIOUS_LINKS',
  p_plug_query_row_count_max => 500,
  p_plug_query_show_nulls_as => ' - ',
  p_plug_display_condition_type => 'REQUEST_IN_CONDITION',
  p_plug_display_when_condition => 'MOVE,COPY,LINK',
  p_pagination_display_position=>'BOTTOM_RIGHT',
  p_plug_header=> '<div id="targetFolderTree">',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 4281188394517307 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 3,
  p_plug_name=> 'Confirm Action',
  p_region_name=>'',
  p_plug_template=> 4250378089114043+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 60,
  p_plug_display_column=> 2,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>4287775794904670 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_branch_action=> 'f?p=&APP_ID.:FOLDERBROWSER:&SESSION.::&DEBUG.::P1_CURRENT_FOLDER:&P3_FOLDER_PATH.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>4282680495694729+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 10,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 18-SEP-2008 13:24 by MARK');
 
wwv_flow_api.create_page_branch(
  p_id=>4292588103021810 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_branch_action=> 'f?p=&APP_ID.:FOLDERBROWSER:&SESSION.::&DEBUG.::P1_CURRENT_FOLDER:&P3_FOLDER_PATH.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>4280682198468140+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 20,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 18-SEP-2008 13:43 by MARK');
 
wwv_flow_api.create_page_branch(
  p_id=>4293885003222719 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_branch_action=> 'f?p=&APP_ID.:FOLDERBROWSER:&SESSION.::&DEBUG.::P1_CURRENT_FOLDER:&P3_FOLDER_PATH.',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>4280378604457651+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 30,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 18-SEP-2008 17:03 by MARK');
 
wwv_flow_api.create_page_branch(
  p_id=>4294985761103036 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_branch_action=> 'f?p=&APP_ID.:FOLDERBROWSER:&SESSION.::&DEBUG.:::',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_sequence=> 40,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> 'Created 18-SEP-2008 19:30 by MARK');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3211866227686917 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DEEP',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1009,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Deep',
  p_source_type=> 'ALWAYS_NULL',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:;TRUE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'COPY DELETE LOCK SETACL CHECKIN CHECKOUT VERSION',
  p_display_when_type=>'REQUEST_IN_CONDITION',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3214760095218002 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_FORCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1019,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Force',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:;TRUE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'YES',
  p_lov_translated=> 'N',
  p_lov_null_text=>'',
  p_lov_null_value=> '',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'DELETE',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3215657025245503 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_COMMENT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1029,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Comment',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'CHECKIN',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3301471249116622 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_NEW_NAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 1039,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'New Name',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'RENAME',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4278578268183170 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DOCUMENT_PATH',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Document Path',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 120,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4278769395190032 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_FOLDER_PATH',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Folder Path',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT_DISABLED_AND_SAVE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 120,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'COPY, MOVE, LINK',
  p_display_when_type=>'REQUEST_IN_CONDITION',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4280378604457651 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DO_COPY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'Copy',
  p_prompt=>'Copy',
  p_source=>'Copy',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'COPY',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4280682198468140 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DO_MOVE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 40,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'Move',
  p_prompt=>'Move',
  p_source=>'Move',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'MOVE',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4282680495694729 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DO_LINK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 50,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'LINK',
  p_prompt=>'Link',
  p_source=>'LINK',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'LINK',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4294778011091291 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_CANCEL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 999,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'CANCEL',
  p_prompt=>'CANCEL',
  p_source=>'CANCEL',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4295185545112411 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DO_LOCK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 70,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'LOCK',
  p_prompt=>'Lock',
  p_source=>'LOCK',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'LOCK',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4295362128115055 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DO_UNLOCK',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 80,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'UNLOCK',
  p_prompt=>'Unlock',
  p_source=>'UNLOCK',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'UNLOCK',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4295878535129256 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DO_DELETE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 90,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'DELETE',
  p_prompt=>'Delete',
  p_source=>'DELETE',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'DELETE',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4296161697133945 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DO_RENAME',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 100,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'RENAME',
  p_prompt=>'Rename',
  p_source=>'RENAME',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'RENAME',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4296374857137687 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DO_SETACL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 110,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'SETACL',
  p_prompt=>'Set ACL',
  p_source=>'SETACL',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'SETACL',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4296586631141053 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DO_VERSION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 120,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'VERSION',
  p_prompt=>'Make Versioned',
  p_source=>'VERSION',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'VERSION',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4296762174143487 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DO_CHECKIN',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 130,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'CHECKIN',
  p_prompt=>'Check-In',
  p_source=>'CHECKIN',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'CHECKIN',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4296970486145885 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_DO_CHECK_OUT',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 140,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => 'CHECKOUT',
  p_prompt=>'Check-Out',
  p_source=>'CHECKOUT',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> 2000,
  p_cHeight=> null,
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'CHECKOUT',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_is_persistent=> 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>4308668999980563 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_name=>'P3_SELECTED_ACL_PATH',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 4281188394517307+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'NO',
  p_item_default => '/sys/acls/bootstrap_acl.xml',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Selected Acl Path',
  p_source_type=> 'ALWAYS_NULL',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'ACL_LIST',
  p_lov => 'select path d, path r'||chr(10)||
'  from path_view, ALL_XML_SCHEMAS'||chr(10)||
' where extractValue(res,''/Resource/SchOID'') = SCHEMA_ID '||chr(10)||
'   and OWNER = ''XDB'' '||chr(10)||
'   and SCHEMA_URL = ''http://xmlns.oracle.com/xdb/acl.xsd'''||chr(10)||
' order by 1',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_display_when=>'SETACL',
  p_display_when_type=>'REQUEST_EQUALS_CONDITION',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_computation(
  p_id=> 4284178913855149 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 3,
  p_computation_sequence => 10,
  p_computation_item=> 'P3_DOCUMENT_PATH',
  p_computation_point=> 'BEFORE_HEADER',
  p_computation_type=> 'ITEM_VALUE',
  p_computation_processed=> 'REPLACE_EXISTING',
  p_computation=> 'DOC_ID',
  p_compute_when => '',
  p_compute_when_type=>'');
 
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.LINKRESOURCE'||chr(10)||
'('||chr(10)||
'  P_APEX_USER     => :F101_USER_DN,'||chr(10)||
'  P_RESOURCE_PATH => :P3_DOCUMENT_PATH,'||chr(10)||
'  P_TARGET_FOLDER => :P3_FOLDER_PATH, '||chr(10)||
'  P_LINK_TYPE     => DBMS_XDB.LINK_TYPE_WEAK'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 4287368391893096 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DO_LINK',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>4282680495694729 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.MOVERESOURCE'||chr(10)||
'('||chr(10)||
'  P_APEX_USER     => :F101_USER_DN,'||chr(10)||
'  P_RESOURCE_PATH => :P3_DOCUMENT_PATH,'||chr(10)||
'  P_TARGET_FOLDER => :P3_FOLDER_PATH'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 4292187972012301 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DO_MOVE',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>4280682198468140 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.COPYRESOURCE'||chr(10)||
'('||chr(10)||
'  P_APEX_USER     => :F101_USER_DN,'||chr(10)||
'  P_RESOURCE_PATH => :P3_DOCUMENT_PATH,'||chr(10)||
'  P_TARGET_FOLDER => :P3_FOLDER_PATH,'||chr(10)||
'  P_DEEP          => (:P3_DEEP = ''TRUE'')'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 4293290497195873 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DO_COPY',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>4280378604457651 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.RENAMERESOURCE'||chr(10)||
'('||chr(10)||
'  P_APEX_USER     => :F101_USER_DN,'||chr(10)||
'  P_RESOURCE_PATH => :P3_DOCUMENT_PATH,'||chr(10)||
'  P_NEW_NAME => :P3_NEW_NAME'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 4297888970160735 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 50,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DO_RENAME',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>4296161697133945 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.DELETERESOURCE'||chr(10)||
'('||chr(10)||
'  P_APEX_USER     => NULL, '||chr(10)||
'  P_RESOURCE_PATH => :P3_DOCUMENT_PATH, '||chr(10)||
'  P_DEEP          => (:P3_DEEP = ''TRUE''), '||chr(10)||
'  P_FORCE         => (:P3_FORCE = ''TRUE'')'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 4298060011161832 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 60,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DO_DELETE',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>4295878535129256 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.LOCKRESOURCE'||chr(10)||
'('||chr(10)||
'   P_APEX_USER     => :F101_USER_DN, '||chr(10)||
'   P_RESOURCE_PATH => :P3_DOCUMENT_PATH, '||chr(10)||
'   P_DEEP          => (:P3_DEEP = ''TRUE'')'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 4298264859163198 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 70,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DO_LOCK',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>4295185545112411 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.UNLOCKRESOURCE'||chr(10)||
'('||chr(10)||
'   P_APEX_USER     => :F101_USER_DN, '||chr(10)||
'   P_RESOURCE_PATH => :P3_DOCUMENT_PATH, '||chr(10)||
'   P_DEEP          => (:P3_DEEP = ''TRUE'')'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 4298469708164557 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 80,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DO_UNLOCK',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>4295362128115055 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.MAKEVERSIONED'||chr(10)||
'('||chr(10)||
'   P_APEX_USER     => :F101_USER_DN, '||chr(10)||
'   P_RESOURCE_PATH => :P3_DOCUMENT_PATH, '||chr(10)||
'   P_DEEP          => (:P3_DEEP = ''TRUE'')'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 4298988408169967 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 100,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DO_VERSION',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>4296586631141053 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.SETACL'||chr(10)||
'('||chr(10)||
'   P_APEX_USER     => :F101_USER_DN, '||chr(10)||
'   P_RESOURCE_PATH => :P3_DOCUMENT_PATH, '||chr(10)||
'   P_ACL_PATH      => :P3_SELECTED_ACL_PATH,'||chr(10)||
'   P_DEEP          => (:P3_DEEP = ''TRUE'')'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 4299160835171476 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 110,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DO_SETACL',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>4296374857137687 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.CHECKIN'||chr(10)||
'('||chr(10)||
'   P_APEX_USER     => :F101_USER_DN, '||chr(10)||
'   P_RESOURCE_PATH => :P3_DOCUMENT_PATH, '||chr(10)||
'   P_COMMENT       => :P3_COMMENT,'||chr(10)||
'   P_DEEP          => (:P3_DEEP = ''TRUE'')'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 4299366029172968 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 120,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DO_CHECK_IN',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>4296762174143487 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.CHECKOUT'||chr(10)||
'('||chr(10)||
'   P_APEX_USER     => :F101_USER_DN, '||chr(10)||
'   P_RESOURCE_PATH => :P3_DOCUMENT_PATH, '||chr(10)||
'   P_DEEP          => (:P3_DEEP = ''TRUE'')'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 4299571917174674 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 3,
  p_process_sequence=> 130,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'DO_CHECK_OUT',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_when_button_id=>4296970486145885 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 3
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00004
prompt  ...PAGE 4: Create Folder
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph := null;
wwv_flow_api.create_page(
  p_id     => 4,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Create Folder',
  p_alias  => 'CREATEFOLDER',
  p_step_title=> 'My Page',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_help_text => ' ',
  p_html_page_header => '',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'ADMIN',
  p_last_upd_yyyymmddhh24miss => '20091004133714',
  p_page_is_public_y_n=> 'N',
  p_page_comment  => '');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>4,p_text=>h);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 5328987329772011 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 4,
  p_plug_name=> 'Create Folder',
  p_region_name=>'',
  p_plug_template=> 4247667412114039+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_translate_title=> 'Y',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_customized=>'0',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 5329287730772025 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 4,
  p_button_sequence=> 20,
  p_button_plug_id => 5328987329772011+wwv_flow_api.g_id_offset,
  p_button_name    => 'SUBMIT',
  p_button_image   => 'template:'||to_char(4245073391114034+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Submit',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_database_action=>'UPDATE',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5329188246772025 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 4,
  p_button_sequence=> 10,
  p_button_plug_id => 5328987329772011+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(4245073391114034+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Cancel',
  p_button_position=> 'REGION_TEMPLATE_CLOSE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>5330102164772080 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 4,
  p_branch_action=> 'f?p=&APP_ID.:1:&SESSION.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>5329287730772025+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 1,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3210650345592442 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 4,
  p_name=>'P4_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 5328987329772011+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Description',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5329712562772043 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 4,
  p_name=>'P4_SPATH',
  p_data_type=> '',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 5328987329772011+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_prompt=>'Abspath',
  p_display_as=> 'TEXT',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> null,
  p_cHeight=> null,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'XFILES_APEX_SERVICES.CREATEFOLDER'||chr(10)||
'('||chr(10)||
'  P_APEX_USER       => :F101_USER_DN,'||chr(10)||
'  P_FOLDER_PATH     => :P1_CURRENT_FOLDER || ''/'' || :P4_SPATH, '||chr(10)||
'  P_DESCRIPTION     => :P4_DESCRIPTION,'||chr(10)||
'  P_TIMEZONE_OFFSET => :F101_TIMEZONE_OFFSET'||chr(10)||
');';

wwv_flow_api.create_page_process(
  p_id     => 5329912043772069 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 4,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Run Stored Procedure',
  p_process_sql_clob => p, 
  p_process_error_message=> '#SQLERRM#',
  p_process_when_button_id=>5329287730772025 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 4
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00007
prompt  ...PAGE 7: Create Resource
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h:=h||'No help is available for this page.';

ph := null;
wwv_flow_api.create_page(
  p_id     => 7,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Create Resource',
  p_step_title=> 'Create Resource',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'NO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_help_text => ' ',
  p_html_page_header => '',
  p_step_template => '',
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'ADMIN',
  p_last_upd_yyyymmddhh24miss => '20091005210843',
  p_page_comment  => '');
 
wwv_flow_api.set_page_help_text(p_flow_id=>wwv_flow.g_flow_id,p_flow_step_id=>7,p_text=>h);
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 5344214315903621 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 7,
  p_plug_name=> 'Form on Stored Procedure',
  p_region_name=>'',
  p_plug_template=> 4247667412114039+ wwv_flow_api.g_id_offset,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_display_error_message=> '#SQLERRM#',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
wwv_flow_api.create_page_button(
  p_id             => 5344498697903625 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 7,
  p_button_sequence=> 20,
  p_button_plug_id => 5344214315903621+wwv_flow_api.g_id_offset,
  p_button_name    => 'SUBMIT',
  p_button_image   => 'template:'||to_char(4245073391114034+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Submit',
  p_button_position=> 'REGION_TEMPLATE_CHANGE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> '',
  p_database_action=>'UPDATE',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
wwv_flow_api.create_page_button(
  p_id             => 5344412358903625 + wwv_flow_api.g_id_offset,
  p_flow_id        => wwv_flow.g_flow_id,
  p_flow_step_id   => 7,
  p_button_sequence=> 10,
  p_button_plug_id => 5344214315903621+wwv_flow_api.g_id_offset,
  p_button_name    => 'CANCEL',
  p_button_image   => 'template:'||to_char(4245073391114034+wwv_flow_api.g_id_offset),
  p_button_image_alt=> 'Cancel',
  p_button_position=> 'REGION_TEMPLATE_CLOSE',
  p_button_alignment=> 'RIGHT',
  p_button_redirect_url=> 'f?p=&APP_ID.:1:&SESSION.::&DEBUG.:::',
  p_required_patch => null + wwv_flow_api.g_id_offset);
 
 
end;
/

 
begin
 
wwv_flow_api.create_page_branch(
  p_id=>5345111693903625 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 7,
  p_branch_action=> 'f?p=&APP_ID.:1:&SESSION.&success_msg=#SUCCESS_MSG#',
  p_branch_point=> 'AFTER_PROCESSING',
  p_branch_type=> 'REDIRECT_URL',
  p_branch_when_button_id=>5344498697903625+ wwv_flow_api.g_id_offset,
  p_branch_sequence=> 1,
  p_save_state_before_branch_yn=>'N',
  p_branch_comment=> '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3257957143347738 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 7,
  p_name=>'P7_CHARSET',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 5344214315903621+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'UTF-8',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Charset',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'CHARACTER_SET',
  p_lov => 'select CHARSET_NAME, CHARSET_ID'||chr(10)||
'  from CHARACTER_SET_LOV'||chr(10)||
' order by 2',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3276358678508978 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 7,
  p_name=>'P7_LANGAUGE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 5344214315903621+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'en-US',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Langauge',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'LANGUAGE',
  p_lov => 'select LANGUAGE_NAME, LANGUAGE_ID'||chr(10)||
'from   LANGUAGE_LOV'||chr(10)||
'order by LANGUAGE_NAME',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3276951171714984 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 7,
  p_name=>'P7_DESCRIPTION',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 5344214315903621+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Description',
  p_source_type=> 'STATIC',
  p_display_as=> 'TEXT',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3280575756889256 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 7,
  p_name=>'P7_DUPLICATE_POLICY',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 17,
  p_item_plug_id => 5344214315903621+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default => 'VERSION',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Duplicate Policy',
  p_source_type=> 'STATIC',
  p_display_as=> 'COMBOBOX',
  p_named_lov=> 'UPLOAD_ACTION',
  p_lov => '.'||to_char(3279449784881777 + wwv_flow_api.g_id_offset)||'.',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5346112229905550 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 7,
  p_name=>'P7_SOURCE',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 5344214315903621+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Source',
  p_source_type=> 'STATIC',
  p_display_as=> 'FILE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'  V_CONTENT  BLOB;'||chr(10)||
'  V_FILENAME VARCHAR2(400);'||chr(10)||
'  V_RESULT   BOOLEAN;'||chr(10)||
'  V_CONTENT_TYPE VARCHAR2(128);'||chr(10)||
''||chr(10)||
'begin '||chr(10)||
'  if (:P7_SOURCE is not null) then'||chr(10)||
''||chr(10)||
'    select BLOB_CONTENT'||chr(10)||
'      into V_CONTENT'||chr(10)||
'      from WWV_FLOW_FILES   '||chr(10)||
'     where NAME = :P7_SOURCE;'||chr(10)||
''||chr(10)||
'     V_FILENAME := substr(:P7_SOURCE,instr(:P7_SOURCE,''/'',-1));'||chr(10)||
''||chr(10)||
'     XFILES_APEX_SERVICES.UPLOADRESOURCE'||chr(10)||
'     ('||chr(10)||
'         P_APEX_USER => :F101';

p:=p||'_DN_NAME, '||chr(10)||
'         P_RESOURCE_PATH =>  :P1_CURRENT_FOLDER || ''/'' || V_FILENAME,'||chr(10)||
'         P_CONTENT => V_CONTENT,'||chr(10)||
'         P_CONTENT_TYPE => V_CONTENT_TYPE,'||chr(10)||
'         P_DESCRIPTION => :P7_DESCRIPTION,'||chr(10)||
'         P_LANGUAGE => :P7_LANGUAGE,'||chr(10)||
'         P_CHARACTER_SET => :P7_CHARSET,'||chr(10)||
'         P_DUPLICATE_POLICY => :P7_DUPLICATE_POLICY'||chr(10)||
'     );'||chr(10)||
''||chr(10)||
'     DELETE FROM WWV_FLOW_FILES'||chr(10)||
'      WHERE NAME = :P7_SOURCE';

p:=p||';'||chr(10)||
''||chr(10)||
'  end if;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5344906200903625 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 7,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Run Stored Procedure',
  p_process_sql_clob => p, 
  p_process_error_message=> '#SQLERRM#',
  p_process_when_button_id=>5344498697903625 + wwv_flow_api.g_id_offset,
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 7
--
 
begin
 
null;
end;
null;
 
end;
/

 
--application/pages/page_00101
prompt  ...PAGE 101: Login
--
 
begin
 
declare
    h varchar2(32767) := null;
    ph varchar2(32767) := null;
begin
h := null;
ph := null;
wwv_flow_api.create_page(
  p_id     => 101,
  p_flow_id=> wwv_flow.g_flow_id,
  p_tab_set=> '',
  p_name   => 'Login',
  p_alias  => 'LOGIN',
  p_step_title=> 'Login',
  p_step_sub_title_type => 'TEXT_WITH_SUBSTITUTIONS',
  p_first_item=> 'AUTO_FIRST_ITEM',
  p_include_apex_css_js_yn=>'Y',
  p_autocomplete_on_off => '',
  p_help_text => '',
  p_html_page_header => '',
  p_step_template => 4240660257114010+ wwv_flow_api.g_id_offset,
  p_required_patch=> null + wwv_flow_api.g_id_offset,
  p_last_updated_by => 'ADMIN',
  p_last_upd_yyyymmddhh24miss => '20091010205517',
  p_page_is_public_y_n=> 'N',
  p_page_comment  => '');
 
end;
 
end;
/

declare
  s varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
s := null;
wwv_flow_api.create_page_plug (
  p_id=> 5189409111808430 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_page_id=> 101,
  p_plug_name=> 'Login',
  p_region_name=>'',
  p_plug_template=> 0,
  p_plug_display_sequence=> 10,
  p_plug_display_column=> 1,
  p_plug_display_point=> 'AFTER_SHOW_ITEMS',
  p_plug_source=> s,
  p_plug_source_type=> 'STATIC_TEXT',
  p_plug_query_row_template=> 1,
  p_plug_query_headings_type=> 'COLON_DELMITED_LIST',
  p_plug_query_row_count_max => 500,
  p_plug_display_condition_type => '',
  p_plug_caching=> 'NOT_CACHED',
  p_plug_comment=> '');
end;
/
 
begin
 
null;
 
end;
/

 
begin
 
null;
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>3285449818962608 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_APPLICATION_PRINCIPAL',
  p_data_type=> 'VARCHAR',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 15,
  p_item_plug_id => 5189409111808430+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> 'YES',
  p_item_default_type => 'STATIC_TEXT_WITH_SUBSTITUTIONS',
  p_prompt=>'Application Principal',
  p_source_type=> 'STATIC',
  p_display_as=> 'CHECKBOX',
  p_lov => 'STATIC2:;TRUE',
  p_lov_columns=> 1,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 30,
  p_cMaxlength=> 2000,
  p_cHeight=> 5,
  p_cAttributes=> 'nowrap="nowrap"',
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_lov_display_extra=>'NO',
  p_protection_level => 'N',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5189503524808433 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_USERNAME',
  p_data_type=> '',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 10,
  p_item_plug_id => 5189409111808430+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_prompt=>'User Name',
  p_display_as=> 'TEXT',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 100,
  p_cHeight=> null,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 2,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5189613265808433 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_PASSWORD',
  p_data_type=> '',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 20,
  p_item_plug_id => 5189409111808430+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_prompt=>'Password',
  p_display_as=> 'PASSWORD_WITH_ENTER_SUBMIT',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> 40,
  p_cMaxlength=> 100,
  p_cHeight=> null,
  p_begin_on_new_line => 'YES',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'RIGHT',
  p_field_alignment  => 'LEFT',
  p_field_template => 4261285833114065+wwv_flow_api.g_id_offset,
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

declare
    h varchar2(32767) := null;
begin
wwv_flow_api.create_page_item(
  p_id=>5189693928808433 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id=> 101,
  p_name=>'P101_LOGIN',
  p_data_type=> '',
  p_accept_processing=> 'REPLACE_EXISTING',
  p_item_sequence=> 30,
  p_item_plug_id => 5189409111808430+wwv_flow_api.g_id_offset,
  p_use_cache_before_default=> '',
  p_item_default => 'Login',
  p_prompt=>'Login',
  p_source=>'LOGIN',
  p_source_type=> 'STATIC',
  p_display_as=> 'BUTTON',
  p_lov_columns=> null,
  p_lov_display_null=> 'NO',
  p_lov_translated=> 'N',
  p_cSize=> null,
  p_cMaxlength=> null,
  p_cHeight=> null,
  p_tag_attributes  => 'template:'||to_char(4245073391114034 + wwv_flow_api.g_id_offset),
  p_begin_on_new_line => 'NO',
  p_begin_on_new_field=> 'YES',
  p_colspan => 1,
  p_rowspan => 1,
  p_label_alignment  => 'LEFT',
  p_field_alignment  => 'LEFT',
  p_is_persistent=> 'Y',
  p_item_comment => '');
 
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'owa_util.mime_header(''text/html'', FALSE);'||chr(10)||
'owa_cookie.send('||chr(10)||
'    name=>''LOGIN_USERNAME_COOKIE'','||chr(10)||
'    value=>lower(:P101_USERNAME));'||chr(10)||
'exception when others then null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5189903903808435 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 10,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Set Username Cookie',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'begin'||chr(10)||
'  wwv_flow_custom_auth_std.login'||chr(10)||
'  ('||chr(10)||
'    P_UNAME       => :P101_USERNAME,'||chr(10)||
'    P_PASSWORD    => :P101_PASSWORD,'||chr(10)||
'    P_SESSION_ID  => v(''APP_SESSION''),'||chr(10)||
'    P_FLOW_PAGE   => :APP_ID||'':1'''||chr(10)||
'  );'||chr(10)||
''||chr(10)||
'  if (:P101_APPLICATION_PRINCIPAL = ''TRUE'') then'||chr(10)||
'    select lower(EMAIL_ADDRESS)'||chr(10)||
'      into :F101_USER_DN '||chr(10)||
'      FROM WWV_FLOW_USERS '||chr(10)||
'      WHERE USER_NAME = V(''APP_USER'');'||chr(10)||
'  else'||chr(10)||
'    :F101_USER_DN := NU';

p:=p||'LL;'||chr(10)||
'  end if;'||chr(10)||
' '||chr(10)||
'  :P1_CURRENT_FOLDER := ''/'';'||chr(10)||
''||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5189810811808433 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 20,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Login',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'101';

wwv_flow_api.create_page_process(
  p_id     => 5190106009808435 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 30,
  p_process_point=> 'AFTER_SUBMIT',
  p_process_type=> 'CLEAR_CACHE_FOR_PAGES',
  p_process_name=> 'Clear Page(s) Cache',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
declare
  p varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
p:=p||'declare'||chr(10)||
'    v varchar2(255) := null;'||chr(10)||
'    c owa_cookie.cookie;'||chr(10)||
'begin'||chr(10)||
'   c := owa_cookie.get(''LOGIN_USERNAME_COOKIE'');'||chr(10)||
'   :P101_USERNAME := c.vals(1);'||chr(10)||
'exception when others then null;'||chr(10)||
'end;';

wwv_flow_api.create_page_process(
  p_id     => 5189998152808435 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_flow_step_id => 101,
  p_process_sequence=> 10,
  p_process_point=> 'BEFORE_HEADER',
  p_process_type=> 'PLSQL',
  p_process_name=> 'Get Username Cookie',
  p_process_sql_clob => p, 
  p_process_error_message=> '',
  p_process_success_message=> '',
  p_process_is_stateful_y_n=>'N',
  p_process_comment=>'');
end;
null;
 
end;
/

 
begin
 
---------------------------------------
-- ...updatable report columns for page 101
--
 
begin
 
null;
end;
null;
 
end;
/

prompt  ...lists
--
--application/shared_components/navigation/breadcrumbs
prompt  ...breadcrumbs
--
 
begin
 
wwv_flow_api.create_menu (
  p_id=> 5190207257808435 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> ' Breadcrumb');
 
wwv_flow_api.create_menu_option (
  p_id=>5193794638808452 + wwv_flow_api.g_id_offset,
  p_menu_id=>5190207257808435 + wwv_flow_api.g_id_offset,
  p_parent_id=>0,
  p_option_sequence=>10,
  p_short_name=>'Page 1',
  p_long_name=>'',
  p_link=>'f?p=&APP_ID.:1:&SESSION.',
  p_page_id=>1,
  p_also_current_for_pages=> '');
 
null;
 
end;
/

prompt  ...page templates for application: 102
--
--application/shared_components/user_interface/templates/page/login
prompt  ......Page template 4240660257114010
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</div>'||chr(10)||
'<div id="t20BreadCrumbsLeft">#REGION_POSITION_01#</div';

c3:=c3||'>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody" height="70%" align="center" width="400">'||chr(10)||
'<td width="100%" valign="top" height="100%" id="t20ContentBody" align="center">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20ContentMiddle">#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" wid';

c3:=c3||'th="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4240660257114010 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Login',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 20,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs
prompt  ......Page template 4240883061114024
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</div>'||chr(10)||
'<div id="t20BreadCrumbsLeft">#REGION_POSITION_01#</div';

c3:=c3||'>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td width="100%" valign="top" height="100%" id="t20ContentBody">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20ContentMiddle">#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t20ContentRight';

c3:=c3||'">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4240883061114024 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" align="left"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 3,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs_with_sidebar
prompt  ......Page template 4241190071114026
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</div>'||chr(10)||
'<div id="t20BreadCrumbsLeft">#REGION_POSITION_01#</div';

c3:=c3||'>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td valign="top" width="200" id="t20ContentLeft">#REGION_POSITION_02#<br /></td>'||chr(10)||
'<td width="100%" valign="top" height="100%" id="t20ContentBody">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20ContentMiddle">#BOX_BODY##REGION_POSITION_04#';

c3:=c3||'</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4241190071114026 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs with Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" align="left"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 17,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs
prompt  ......Page template 4241491426114026
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'<style type="text/css">'||chr(10)||
'<!-- Tyler Commented this'||chr(10)||
'td.t20RegionBody{background:#ffffff;}';

c1:=c1||''||chr(10)||
'-->'||chr(10)||
'</style>'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t20Tabs" class="tablight">#TAB_CELLS#</div>'||chr(10)||
'</div>'||chr(10)||
'<';

c3:=c3||'div id="t20BreadCrumbsLeft">#REGION_POSITION_01#</div>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td width="100%" valign="top" id="t20ContentBody">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20ContentMiddle">#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valig';

c3:=c3||'n="top" width="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4241491426114026 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '<a href="#TAB_LINK#" class="t20CurrentTab">#TAB_LABEL#</a>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_custom_1
prompt  ......Page template 4241790224114029
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table id="t20Tabs" border="0" cellpadding="0" cellspacing="0';

c3:=c3||'" summary=""><tr>#TAB_CELLS#</tr></table>'||chr(10)||
'</div>'||chr(10)||
'<div id="t20BreadCrumbsLeft">#REGION_POSITION_01#</div>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td width="100%" valign="top" id="t20ContentBody">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20ContentMiddle">#BOX_BODY##REGION_POSI';

c3:=c3||'TION_02##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4241790224114029 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs (Custom 1)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_20/topTabL.gif" /></td>'||chr(10)||
'<td class="t20CurrentTab"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/topTabR.gif" /></td>'||chr(10)||
'<td>&nbsp;</td>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_20/topDimTabL.gif" /></td>'||chr(10)||
'<td class="t20Tab"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/topDimTabR.gif" /></td>'||chr(10)||
'<td>&nbsp;</td>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 8,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_custom_5
prompt  ......Page template 4242065981114030
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t20Tabs" class="tablight">#TAB_CELLS#</div>'||chr(10)||
'</div>'||chr(10)||
'#REGION_POSITION_08#'||chr(10)||
'';

c3:=c3||'<div id="t20BreadCrumbsLeft">#REGION_POSITION_01#</div>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td width="100%" valign="top" id="t20ContentBody">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20ContentMiddle">#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td vali';

c3:=c3||'gn="top" width="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4242065981114030 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs (Custom 5)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '<a href="#TAB_LINK#" class="t20CurrentTab">#TAB_LABEL#</a>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 12,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_sidebar
prompt  ......Page template 4242365634114030
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t20Tabs" class="tablight">#TAB_CELLS#</div>'||chr(10)||
'</div>'||chr(10)||
'<';

c3:=c3||'div id="t20BreadCrumbsLeft">#REGION_POSITION_01#</div>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td valign="top" id="t20ContentLeft">#REGION_POSITION_02#<br /></td>'||chr(10)||
'<td valign="top" id="t20ContentBody">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20ContentMiddle">#BOX_BODY##REGIO';

c3:=c3||'N_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4242365634114030 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '<a href="#TAB_LINK#" class="t20CurrentTab">#TAB_LABEL#</a>'||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 16,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_sidebar_custom_2
prompt  ......Page template 4242672759114030
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table id="t20Tabs" border="0" cellpadding="0" cellspacing="0';

c3:=c3||'" summary=""><tr>#TAB_CELLS#</tr></table>'||chr(10)||
'</div>'||chr(10)||
'<div id="t20BreadCrumbsLeft">#REGION_POSITION_01#</div>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td valign="top" width="200" id="t20ContentLeft">#REGION_POSITION_02#<br /></td>'||chr(10)||
'<td width="100%" valign="top" id="t20ContentBody">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSA';

c3:=c3||'GE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20ContentMiddle">#BOX_BODY##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4242672759114030 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs Sidebar  (Custom 2)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_20/topTabL.gif" /></td>'||chr(10)||
'<td class="t20CurrentTab"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/topTabR.gif" /></td>'||chr(10)||
'<td>&nbsp;</td>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_20/topDimTabL.gif" /></td>'||chr(10)||
'<td class="t20Tab"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/topDimTabR.gif" /></td>'||chr(10)||
'<td>&nbsp;</td>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 9,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_sidebar_custom_6
prompt  ......Page template 4242961874114031
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t20Tabs" class="tablight">#TAB_CELLS#</div>'||chr(10)||
'</div>'||chr(10)||
'#REGION_POSITION_08#'||chr(10)||
'';

c3:=c3||'<div id="t20BreadCrumbsLeft">#REGION_POSITION_01#</div>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td valign="top" width="200" id="t20ContentLeft">#REGION_POSITION_02#<br /></td>'||chr(10)||
'<td width="100%" valign="top" id="t20ContentBody">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20Conte';

c3:=c3||'ntMiddle">#BOX_BODY##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4242961874114031 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs Sidebar (Custom 6)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '<a href="#TAB_LINK#" class="t20CurrentTab">#TAB_LABEL#</a>'||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 13,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/popup
prompt  ......Page template 4243287578114032
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top">#LOGO##REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" valign="top">#REGION_POSITION_07#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_08#</td>'||chr(10)||
'</table>'||chr(10)||
'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top">'||chr(10)||
'<div style="border:1px solid black;">#SUCCESS_MESSAG';

c3:=c3||'E##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 4243287578114032 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Popup',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '<div class="t20NavigationBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavigationBar">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 20,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/printer_friendly
prompt  ......Page template 4243590760114032
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table border="0" cellpadding="0" cellspacing="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<t';

c3:=c3||'d width="100%" valign="top"><div class="t20messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4243590760114032 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Printer Friendly',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '<div class="t20NavigationBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavigationBar">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 20,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_template_comment => '3');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs
prompt  ......Page template 4243888145114033
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t20Tabs" class="tablight">#PARENT_TAB_CELLS#</div>'||chr(10)||
'<';

c3:=c3||'/div>'||chr(10)||
'<div id="t20tablist">#TAB_CELLS#</div>'||chr(10)||
'<div id="t20BreadCrumbsLeft">#REGION_POSITION_01#</div>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td width="100%" valign="top" id="t20ContentBody">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20ContentMiddle">#BOX_BODY##REGION_POSITION';

c3:=c3||'_02##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4243888145114033 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '<a href="#TAB_LINK#" class="current">#TAB_LABEL#</a>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<a href="#TAB_LINK#" class="t20CurrentTab">#TAB_LABEL#</a>',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<a href="#TAB_LINK#">#TAB_LABEL#</a>',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs_custom_3
prompt  ......Page template 4244170940114033
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table id="t20Tabs" border="0" cellpadding="0" cellspacing="0';

c3:=c3||'" summary=""><tr>#PARENT_TAB_CELLS#</tr></table>'||chr(10)||
'</div>'||chr(10)||
'<div id="t20ChildTabs">#TAB_CELLS#</div>'||chr(10)||
'<div style="background-color:none;">#REGION_POSITION_01#</div>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td valign="top" id="t20ContentBody">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id';

c3:=c3||'="t20ContentMiddle">#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4244170940114033 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs  (Custom 3)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '<a href="#TAB_LINK#" class="t20CurrentTab">#TAB_LABEL#</a>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#" class="t20Tab">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_20/topTabL.gif" /></td>'||chr(10)||
'<td class="t20CurrentTab"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/topTabR.gif" /></td>'||chr(10)||
'<td>&nbsp;</td>',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_20/topDimTabL.gif" /></td>'||chr(10)||
'<td class="t20Tab"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/topDimTabR.gif" /></td>'||chr(10)||
'<td>&nbsp;</td>',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 10,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs_with_sidebar
prompt  ......Page template 4244460486114034
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<div id="t20Tabs" class="tablight">#PARENT_TAB_CELLS#</div>'||chr(10)||
'<';

c3:=c3||'/div>'||chr(10)||
'<div id="t20tablist">#TAB_CELLS#</div>'||chr(10)||
'<div id="t20BreadCrumbsLeft">#REGION_POSITION_01#</div>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td valign="top" width="200" id="t20ContentLeft">#REGION_POSITION_02#<br /></td>'||chr(10)||
'<td width="100%" valign="top" id="t20ContentBody">'||chr(10)||
'<div id="t20Messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##';

c3:=c3||'NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20ContentMiddle">#BOX_BODY##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4244460486114034 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs with Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '<a href="#TAB_LINK#" class="current">#TAB_LABEL#</a>'||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<a href="#TAB_LINK#" class="t20CurrentTab">#TAB_LABEL#</a>'||chr(10)||
'',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<a href="#TAB_LINK#">#TAB_LABEL#</a>'||chr(10)||
'',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 18,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs_with_sidebar_custom_4
prompt  ......Page template 4244770725114034
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css" />'||chr(10)||
'<!--[if IE]><link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/ie.css" type="text/css" /><![endif]-->'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageFooter" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Left" valign="top"><span id="t20UserPrompt">&APP_USER.</span><br /></td>'||chr(10)||
'<td id="t20Center" valign="top">#REGION_POSITION_05#</td>'||chr(10)||
'<td id="t20Right" valign="top"><span id="t20Customize">#CUSTOMIZE#</span><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<br class="t20Break"/>'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div id="t20PageHeader">'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td id="t20Logo" valign="top">#LOGO#<br />#REGION_POSITION_06#</td>'||chr(10)||
'<td id="t20HeaderMiddle"  valign="top" width="100%">#REGION_POSITION_07#<br /></td>'||chr(10)||
'<td id="t20NavBar" valign="top">#NAVIGATION_BAR#<br />#REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table id="t20Tabs" border="0" cellpadding="0" cellspacing="0';

c3:=c3||'" summary=""><tr>#PARENT_TAB_CELLS#</tr></table>'||chr(10)||
'</div>'||chr(10)||
'<div id="t20ChildTabs">#TAB_CELLS#</div>'||chr(10)||
'<div style="background-color:none;">#REGION_POSITION_01#</div>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0" summary="" id="t20PageBody"  width="100%" height="70%">'||chr(10)||
'<td valign="top" width="200" id="t20ContentLeft">#REGION_POSITION_02#<br /></td>'||chr(10)||
'<td valign="top" id="t20ContentBody">'||chr(10)||
'<div id="t20Mes';

c3:=c3||'sages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<div id="t20ContentMiddle">#BOX_BODY##REGION_POSITION_04#</div>'||chr(10)||
'</td>'||chr(10)||
'<td valign="top" width="200" id="t20ContentRight">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 4244770725114034 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs with Sidebar  (Custom 4)',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td><td class="tM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td></tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#SUCCESS_MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_current_tab=> '<a href="#TAB_LINK#" class="t20CurrentTab">#TAB_LABEL#</a>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#" class="t20Tab">#TAB_LABEL#</a>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_20/topTabL.gif" /></td>'||chr(10)||
'<td class="t20CurrentTab"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/topTabR.gif" /></td>'||chr(10)||
'<td>&nbsp;</td>',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_20/topDimTabL.gif" /></td>'||chr(10)||
'<td class="t20Tab"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/topDimTabR.gif" /></td>'||chr(10)||
'<td>&nbsp;</td>',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<table summary="" border="0" cellpadding="0" cellspacing="0" id="t20Notification">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-L.gif" alt="" /></td>'||chr(10)||
'<td class="tM"></td>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxTop-R.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="L"></td><td width="100%"><img src="#IMAGE_PREFIX#delete.gif" onclick="$x_Remove(''t20Notification'')"  style="float:right;" class="pb" alt="" />#MESSAGE#</td><td class="R"></td></tr>'||chr(10)||
'<tr><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-L.gif" alt="" /></td><td class="bM"></td><td><img src="#IMAGE_PREFIX#themes/theme_20/msgBoxBtm-R.gif" alt="" /></td></tr>'||chr(10)||
'</table>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#" class="t20NavBar">#TEXT#</a> |',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="5" align="left"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 20,
  p_theme_class_id => 11,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/login
prompt  ......Page template 5181813946808413
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_1/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/theme_1/bot_bar_left.png" alt="" /></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><br /></td>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/theme_1/bot_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<br />'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td valign="top" class="t1Logo">#LOGO#</td>'||chr(10)||
'    <td align="right" valign="top"><br /></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_left.png" alt="" /></td>'||chr(10)||
'    <td class="t1topbarMiddle"><br /></td>'||chr(10)||
' ';

c3:=c3||'   <td><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<table class="t1PageBody" cellpadding="0" cellspacing="0" border="0" summary="" width="100%" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1PageCenter" valign="top"><table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top" class="t1PageBody"><div class="t1messages">';

c3:=c3||'#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_02##REGION_POSITION_03##REGION_POSITION_04##REGION_POSITION_05##REGION_POSITION_06##REGION_POSITION_07##REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 5181813946808413 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Login',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t1success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t1notification">#MESSAGE#</div>',
  p_navigation_bar=> '',
  p_navbar_entry=> '',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0"',
  p_theme_id  => 1,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_template_comment => '18');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs
prompt  ......Page template 5181890089808413
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_1/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/theme_1/bot_bar_left.png" alt="" /></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1user">&APP_USER.</div></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1copy"><!-- Copyright Here --><span class="t1Customize">#CUSTOMIZE#</span></div></td>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/th';

c2:=c2||'eme_1/bot_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<br />'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td valign="top" class="t1Logo">#LOGO##REGION_POSITION_06#</td>'||chr(10)||
'	<td valign="top" width="100%">#REGION_POSITION_07#</td>'||chr(10)||
'    <td align="right" valign="top">#NAVIGATION_BAR##REGION_POSITION_08#</td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td><img src=';

c3:=c3||'"#IMAGE_PREFIX#themes/theme_1/top_bar_left.png" alt="" /></td>'||chr(10)||
'    <td class="t1topbarMiddle"><br />#REGION_POSITION_01#</td>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<table class="t1PageBody" cellpadding="0" cellspacing="0" border="0" summary="" width="100%" height="70%">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1PageCenter" valign="top"><table summary="" cellpadd';

c3:=c3||'ing="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top" class="t1PageBody"><div class="t1messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'';

wwv_flow_api.create_template(
  p_id=> 5181890089808413 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t1success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t1Notification">#MESSAGE#</div>',
  p_navigation_bar=> '<div class="t1NavigationBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t1NavigationBar">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 1,
  p_theme_class_id => 3,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs
prompt  ......Page template 5182005196808413
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_1/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/theme_1/bot_bar_left.png" alt="" /></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1user">&APP_USER.</div></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1copy"><!-- Copyright Here --><span class="t1Customize">#CUSTOMIZE#</span></div></td>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/th';

c2:=c2||'eme_1/bot_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<br />'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td valign="top" class="t1Logo">#LOGO##REGION_POSITION_06#</td>'||chr(10)||
'	<td valign="top" width="100%">#REGION_POSITION_07#</td>'||chr(10)||
'    <td align="right" valign="top">#NAVIGATION_BAR##REGION_POSITION_08#</td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="" height="70%">'||chr(10)||
'  <tr>'||chr(10)||
'    ';

c3:=c3||'<td colspan="5" class="t1ParentTabHolder"><table border="0" cellpadding="0" cellspacing="0" summary="" align="right"><tr><td><br /></td>#PARENT_TAB_CELLS#</tr></table></td>'||chr(10)||
'  </tr>'||chr(10)||
'  <tr>'||chr(10)||
'    <td align="right" class="t1topbarLeft"><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_left2.png" alt="" /></td>'||chr(10)||
'    <td class="t1topbarMiddle" valign="top"><table border="0" cellpadding="0" cellspacing="0" su';

c3:=c3||'mmary=""><tr><td height="20">#TAB_CELLS#</td></tr><tr><td height="20">#REGION_POSITION_01#</td></tr></table></td>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'  <tr>'||chr(10)||
'    <td><br /></td>'||chr(10)||
'    <td class="t1PageRight" colspan="2" valign="top" height="100%"><table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign';

c3:=c3||'="top" class="t1PageBody"><div class="t1messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 5182005196808413 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t1success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<span class="t1ChildTab">[&nbsp;#TAB_LABEL#&nbsp;]</span>#TAB_INLINE_EDIT#',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#" class="t1ChildTab">#TAB_LABEL#</a>#TAB_INLINE_EDIT#',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_on_left.png" border="0" alt="" /></td>'||chr(10)||
'<td class="t1ParentTabCenterOn">#TAB_LABEL##TAB_INLINE_EDIT#</td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_on_right.png" border="0" alt="" /></td>',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_off_left.png" border="0" alt="" /></td>'||chr(10)||
'<td class="t1ParentTabCenterOff"><a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#</td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_off_right.png" border="0" alt="" /></td>',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t1notification">#MESSAGE#</div>',
  p_navigation_bar=> '<div class="t1NavigationBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t1NavigationBar">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 1,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs_with_side_bar
prompt  ......Page template 5182109666808413
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_1/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/theme_1/bot_bar_left.png" alt="" /></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1user">&APP_USER.</div></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1copy"><!-- Copyright Here --><span class="t1Customize">#CUSTOMIZE#</span></div></td>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/th';

c2:=c2||'eme_1/bot_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<br />'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td valign="top" class="t1Logo">#LOGO##REGION_POSITION_06#</td>'||chr(10)||
'	<td valign="top" width="100%">#REGION_POSITION_07#</td>'||chr(10)||
'    <td align="right" valign="top">#NAVIGATION_BAR##REGION_POSITION_08#</td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="" height="70%">'||chr(10)||
'  <tr>'||chr(10)||
'    ';

c3:=c3||'<td colspan="5" class="t1ParentTabHolder"><table border="0" cellpadding="0" cellspacing="0" summary="" align="right"><tr><td><br /></td>#PARENT_TAB_CELLS#</tr></table></td>'||chr(10)||
'  </tr>'||chr(10)||
'  <tr>'||chr(10)||
'    <td class="t1topbarLeft" valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_far_left.png" alt="" /></td>'||chr(10)||
'    <td class="t1topbarLeft" colspan="2"  valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/';

c3:=c3||'top_barleft2_1.png" alt="" /></td>'||chr(10)||
'    <td class="t1topbarLeft" valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_barleft2_2.png" alt="" /></td>'||chr(10)||
'    <td class="t1topbarMiddle" valign="top"><table height="100%" cellpadding="0" cellspacing="0" border="0" summary=""><tr><td height="20">#TAB_CELLS#</td></tr><tr><td valign="bottom" height="20">#REGION_POSITION_01#</td></tr></table></td>'||chr(10)||
'    <td v';

c3:=c3||'align="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'  <tr>'||chr(10)||
'    <td class="t1PageLeft" colspan="3" align="left" valign="top">#REGION_POSITION_02#</td>'||chr(10)||
'    <td><br /></td>'||chr(10)||
'    <td class="t1PageRight" colspan="2" valign="top" height="100%"><table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top" class="t1Pag';

c3:=c3||'eBody"><div class="t1messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 5182109666808413 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs with Side Bar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t1success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<span class="t1ChildTab">[&nbsp;#TAB_LABEL#&nbsp;]</span>#TAB_INLINE_EDIT#',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<a href="#TAB_LINK#" class="t1ChildTab">#TAB_LABEL#</a>#TAB_INLINE_EDIT#',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_on_left.png" border="0" alt="" /></td>'||chr(10)||
'<td class="t1ParentTabCenterOn">#TAB_LABEL##TAB_INLINE_EDIT#</td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_on_right.png" border="0" alt="" /></td>',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_off_left.png" border="0" alt="" /></td>'||chr(10)||
'<td class="t1ParentTabCenterOff"><a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#</td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_off_right.png" border="0" alt="" /></td>',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t1notification">#MESSAGE#</div>',
  p_navigation_bar=> '<div class="t1NavigationBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t1NavigationBar">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 1,
  p_theme_class_id => 18,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_with_side_bar
prompt  ......Page template 5182208622808413
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_1/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/theme_1/bot_bar_left.png" alt="" /></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1user">&APP_USER.</div></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1copy"><!-- Copyright Here --><span class="t1Customize">#CUSTOMIZE#</span></div></td>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/th';

c2:=c2||'eme_1/bot_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<br />'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td valign="top" class="t1Logo">#LOGO##REGION_POSITION_06#</td>'||chr(10)||
'	<td valign="top" width="100%">#REGION_POSITION_07#</td>'||chr(10)||
'    <td align="right" valign="top">#NAVIGATION_BAR##REGION_POSITION_08#</td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="" height="70%">'||chr(10)||
'  <tr>'||chr(10)||
'    ';

c3:=c3||'<td colspan="5" class="t1ParentTabHolder"><table border="0" cellpadding="0" cellspacing="0" summary="" align="right"><tr><td><br /></td>#TAB_CELLS#</tr></table></td>'||chr(10)||
'  </tr>'||chr(10)||
'  <tr>'||chr(10)||
'    <td class="t1topbarLeft" valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_far_left.png" alt="" /></td>'||chr(10)||
'    <td align="right" class="t1topbarLeft" colspan="2"  valign="top"><img src="#IMAGE_PREFIX#themes/t';

c3:=c3||'heme_1/top_barleft2_1.png" alt="" /></td>'||chr(10)||
'    <td align="right" class="t1topbarLeft" valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_barleft2_2.png" alt="" /></td>'||chr(10)||
'    <td class="t1topbarMiddle" valign="top"><table height="100%" cellpadding="0" cellspacing="0" border="0" summary=""><tr><td height="20"><br /></td></tr><tr><td valign="bottom" height="20">#REGION_POSITION_01#</td></tr></table';

c3:=c3||'></td>'||chr(10)||
'    <td valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'  <tr>'||chr(10)||
'    <td class="t1PageLeft" colspan="3" align="left" valign="top">#REGION_POSITION_02#</td>'||chr(10)||
'    <td><br /></td>'||chr(10)||
'    <td class="t1PageRight" colspan="2" valign="top" height="100%"><table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="t';

c3:=c3||'op" class="t1PageBody"><div class="t1messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 5182208622808413 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs with Side Bar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t1success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_on_left.png" border="0" alt="" /></td>'||chr(10)||
'<td class="t1ParentTabCenterOn">#TAB_LABEL##TAB_INLINE_EDIT#</td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_on_right.png" border="0" alt="" /></td>'||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_off_left.png" border="0" alt="" /></td>'||chr(10)||
'<td class="t1ParentTabCenterOff"><a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#</td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_off_right.png" border="0" alt="" /></td>'||chr(10)||
'',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t2notification">#MESSAGE#</div>',
  p_navigation_bar=> '<div class="t1NavigationBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t1NavigationBar">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 1,
  p_theme_class_id => 16,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs_with_side_bar
prompt  ......Page template 5182315734808413
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_1/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/theme_1/bot_bar_left.png" alt="" /></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1user">&APP_USER.</div></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1copy"><!-- Copyright Here --><span class="t1Customize">#CUSTOMIZE#</span></div></td>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/th';

c2:=c2||'eme_1/bot_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<br />'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td valign="top" class="t1Logo">#LOGO##REGION_POSITION_06#</td>'||chr(10)||
'	<td valign="top" width="100%">#REGION_POSITION_07#</td>'||chr(10)||
'    <td align="right" valign="top">#NAVIGATION_BAR##REGION_POSITION_08#</td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="" height="70%">'||chr(10)||
'  <tr>'||chr(10)||
'    ';

c3:=c3||'<td class="t1topbarLeft" valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_far_left.png" alt="" /></td>'||chr(10)||
'    <td align="right" class="t1topbarLeft" colspan="2"  valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_barleft2_1.png" alt="" /></td>'||chr(10)||
'    <td align="right" class="t1topbarLeft" valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_barleft2_2.png" alt="" /></td>'||chr(10)||
'    <td class';

c3:=c3||'="t1topbarMiddle" valign="top"><table height="100%" cellpadding="0" cellspacing="0" border="0" summary=""><tr><td height="20"><br /></td></tr><tr><td valign="bottom" height="20">#REGION_POSITION_01#</td></tr></table></td>'||chr(10)||
'    <td valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'  <tr>'||chr(10)||
'    <td class="t1PageLeft" colspan="3" align="left" valign="top">#REG';

c3:=c3||'ION_POSITION_02#</td>'||chr(10)||
'    <td><br /></td>'||chr(10)||
'    <td class="t1PageRight" colspan="2" valign="top" height="100%"><table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top" class="t1PageBody"><div class="t1messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03';

c3:=c3||'#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 5182315734808413 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs with Side Bar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t1success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t1notification">#MESSAGE#</div>',
  p_navigation_bar=> '<div class="t1NavigationBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t1NavigationBar">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> 'summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 1,
  p_theme_class_id => 17,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs
prompt  ......Page template 5182398911808415
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_1/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/theme_1/bot_bar_left.png" alt="" /></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1user">&APP_USER.</div></td>'||chr(10)||
'    <td class="t1BotbarMiddle"><div id="t1copy"><!-- Copyright Here --><span class="t1Customize">#CUSTOMIZE#</span></div></td>'||chr(10)||
'    <td><img src="#IMAGE_PREFIX#themes/th';

c2:=c2||'eme_1/bot_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<br />'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'  <tr>'||chr(10)||
'    <td valign="top" class="t1Logo">#LOGO##REGION_POSITION_06#</td>'||chr(10)||
'	<td valign="top" width="100%">#REGION_POSITION_07#</td>'||chr(10)||
'    <td align="right" valign="top">#NAVIGATION_BAR##REGION_POSITION_08#</td>'||chr(10)||
'  </tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="100%" cellpadding="0" cellspacing="0" border="0" summary="" height="70%">'||chr(10)||
'  <tr>'||chr(10)||
'    ';

c3:=c3||'<td colspan="5" class="t1ParentTabHolder"><table border="0" cellpadding="0" cellspacing="0" summary="" align="right"><tr><td><br /></td>#TAB_CELLS#</tr></table></td>'||chr(10)||
'  </tr>'||chr(10)||
'  <tr>'||chr(10)||
'    <td valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_left.png" alt="" /></td>'||chr(10)||
'    <td class="t1topbarMiddle" valign="bottom"><table cellpadding="0" cellspacing="0" border="0" summary=""><tr><td height="50';

c3:=c3||'%"><br /></td></tr><tr><td height="50%">#REGION_POSITION_01#</td></tr></table></td>'||chr(10)||
'    <td valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/top_bar_right.png" alt="" /></td>'||chr(10)||
'  </tr>'||chr(10)||
'<tr>'||chr(10)||
'<td><br /></td>'||chr(10)||
'<td class="t1PageCenter" colspan="2" valign="top" height="100%"><table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top" class="t1PageBody">';

c3:=c3||'<div class="t1messages">#GLOBAL_NOTIFICATION##SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 5182398911808415 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t1success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_on_left.png" border="0" alt="" /></td>'||chr(10)||
'<td class="t1ParentTabCenterOn">#TAB_LABEL##TAB_INLINE_EDIT#</td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_on_right.png" border="0" alt="" /></td>'||chr(10)||
''||chr(10)||
'',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_off_left.png" border="0" alt="" /></td>'||chr(10)||
'<td class="t1ParentTabCenterOff"><a href="#TAB_LINK#">#TAB_LABEL#</a>#TAB_INLINE_EDIT#</td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_1/tab_off_right.png" border="0" alt="" /></td>'||chr(10)||
'',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t1notification">#MESSAGE#</div>',
  p_navigation_bar=> '<div class="t1NavigationBar">#BAR_BODY#</div>',
  p_navbar_entry=> '<a href="#LINK#" class="t1NavigationBar">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 1,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_template_comment => '12');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/printer_friendly
prompt  ......Page template 5182509498808415
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_1/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top">'||chr(10)||
'<div style="border:1px solid black;">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 5182509498808415 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Printer Friendly',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '',
  p_navigation_bar=> '',
  p_navbar_entry=> '',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 1,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_template_comment => '3');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/popup
prompt  ......Page template 5182593514808415
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_1/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top"><div class="t1messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_01##REGION_POSITION_02##REGION_POSITION_04##REGION_POSITION_05##REGION_POSITION_06##REGION_POSITION_07##REGION_POSITION_08#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 5182593514808415 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Popup',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t1success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t1notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 1,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs_with_sidebar
prompt  ......Page template 5228692131412458
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_11/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<!-- BEGIN FOOTER -->'||chr(10)||
'<div class="t11top"><!-- Copyright --></div>'||chr(10)||
'<!-- END PAGE -->'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div align="right">'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">&USER.#NAVIGATION_BAR##REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">#REGION_POSITION_07#</td>'||chr(10)||
'<td height="35" align="right" valign="top" cl';

c3:=c3||'ass="t11top" style="padding-right:30px;">#LOGO##REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" align="left" valign="top" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4topleftcorner.jpg" width="28" height="28" alt=""/></td>'||chr(10)||
'<td style="background-color:#91C58D"><img src="#IMAGE_PREFIX';

c3:=c3||'#themes/theme_11/1px_trans.gif" height="40" width="1" alt=""  /></td>'||chr(10)||
'<td colspan="2" align="right" valign="top" nowrap="nowrap" style="background-color:#91C58D"><table height="28" border="0" cellpadding="0" cellspacing="0" summary=""><tr>#TAB_CELLS#</tr></table></td>'||chr(10)||
'<td width="35" style="background-color:#91C58D" valign="top"><img src="#IMAGE_PREFIX#themes/theme_11/t4midrightcorner_top.gif"  alt';

c3:=c3||'=""/></td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td height="41" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="31" background="#IMAGE_PREFIX#themes/theme_11/t4top.gif"><img src="#IMAGE_PREFIX#themes/theme_11/t4midleftcorner.gif"';

c3:=c3||' width="31" height="41" alt="" /></td>'||chr(10)||
'<td colspan="2" width="100%" height="41" background="#IMAGE_PREFIX#themes/theme_11/t4top.gif"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'<td width="35" height="41"><img src="#IMAGE_PREFIX#themes/theme_11/t4midrightcorner.gif" width="35" height="41" alt=""/></td>'||chr(10)||
'<td width="30" height="41"><img src="#IMAGE_PREF';

c3:=c3||'IX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td align="center" valign="top" style="background-color:#91C58D">#REGION_POSITION_02#<img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="31"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td align="left" valign="top" co';

c3:=c3||'lspan="2">'||chr(10)||
'<!-- BEGIN BREADCRUMB -->#REGION_POSITION_01#<!-- BREADCRUMB  -->'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" width="100%"><div class="t11messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFI';

c3:=c3||'X#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" height="41" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4bottomcornerleft.gif" width="28" height="45"  alt="" /></td>'||chr(10)||
'<td width="31" align="left" background="#IMAGE_P';

c3:=c3||'REFIX#themes/theme_11/t4bottom.gif"><img src="#IMAGE_PREFIX#themes/theme_11/t4lowleftcorner.gif" width="31" height="45" alt=""/></td>'||chr(10)||
'<td width="31" colspan="4" align="right" background="#IMAGE_PREFIX#themes/theme_11/t4bottom.gif"><span class="t11Customize">#CUSTOMIZE#</span><br/></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<!-- END BODY -->'||chr(10)||
'</div>'||chr(10)||
'<!-- END PAGE -->';

wwv_flow_api.create_template(
  p_id=> 5228692131412458 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs with Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t11success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<td align="right" style="padding-left:5px"><table height="28" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr><td height="8" align="center"><img src="#IMAGE_PREFIX#themes/theme_11/t4toparrow.gif" width="16" height="8" alt=""/></td></tr>'||chr(10)||
'<tr><td height="20" align="center" class="t11StandardTab"><span>#TAB_LABEL#</span></td></tr>'||chr(10)||
'</table>#TAB_INLINE_EDIT#</td>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<td align="right" style="padding-left:5px"><table height="28" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td height="8" align="center"></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td height="20" align="center" class="t11StandardTab"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>#TAB_INLINE_EDIT#</td>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t11notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '&nbsp;:&nbsp;<a href="#LINK#">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 11,
  p_theme_class_id => 16,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/one_level_tabs
prompt  ......Page template 5228897156412463
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_11/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<!-- BEGIN FOOTER -->'||chr(10)||
'<div class="t11top"><!-- Copyright --></div>'||chr(10)||
'<!-- END PAGE -->'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div align="right">'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">&USER.#NAVIGATION_BAR##REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">#REGION_POSITION_07#</td>'||chr(10)||
'<td height="35" align="right" valign="top" cl';

c3:=c3||'ass="t11top" style="padding-right:30px;">#LOGO##REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" align="left" valign="top" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4topleftcorner.jpg" width="28" height="28"   border="0" alt=""/></td>'||chr(10)||
'<td style="background-color:#91C58D"><img src="';

c3:=c3||'#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="40" width="1" alt=""  /></td>'||chr(10)||
'<td colspan="2" align="right" valign="top" nowrap="nowrap" style="background-color:#91C58D"><table height="28" border="0" cellpadding="0" cellspacing="0"><tr>#TAB_CELLS#</tr></table></td>'||chr(10)||
'<td width="35" style="background-color:#91C58D" valign="top"><img src="#IMAGE_PREFIX#themes/theme_11/t4midrightcorner_top.gif" al';

c3:=c3||'t="" /></td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td height="41" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="31" background="#IMAGE_PREFIX#themes/theme_11/t4top.gif"><img src="#IMAGE_PREFIX#themes/theme_11/t4midleftcorner.gi';

c3:=c3||'f" width="31" height="41" alt="" /></td>'||chr(10)||
'<td colspan="2" width="100%" height="41" background="#IMAGE_PREFIX#themes/theme_11/t4top.gif"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'<td width="35" height="41"><img src="#IMAGE_PREFIX#themes/theme_11/t4midrightcorner.gif" width="35" height="41"  alt=""/></td>'||chr(10)||
'<td width="30" height="41"><img src="#IMAGE_P';

c3:=c3||'REFIX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""/></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td align="center" valign="top" style="background-color:#91C58D">#REGION_POSITION_02#<img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="31"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td align="left" valign="top" c';

c3:=c3||'olspan="2">'||chr(10)||
'<!-- BEGIN BREADCRUMB -->#REGION_POSITION_01#<!-- BREADCRUMB  -->'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" width="100%"><div class="t11messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREF';

c3:=c3||'IX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" height="41" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4bottomcornerleft.gif" width="28" height="45"  alt="" /></td>'||chr(10)||
'<td width="31" align="left" background="#IMAGE_';

c3:=c3||'PREFIX#themes/theme_11/t4bottom.gif"><img src="#IMAGE_PREFIX#themes/theme_11/t4lowleftcorner.gif" width="31" height="45" alt=""/></td>'||chr(10)||
'<td width="31" colspan="4" align="right" background="#IMAGE_PREFIX#themes/theme_11/t4bottom.gif"><span class="t11Customize">#CUSTOMIZE#</span><br/></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<!-- END BODY -->'||chr(10)||
'</div>'||chr(10)||
'<!-- END PAGE -->';

wwv_flow_api.create_template(
  p_id=> 5228897156412463 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'One Level Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t11success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<td align="right" style="padding-left:5px"><table height="28" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr><td height="8" align="center"><img src="#IMAGE_PREFIX#themes/theme_11/t4toparrow.gif" width="16" height="8" alt=""/></td></tr>'||chr(10)||
'<tr><td height="20" align="center" class="t11StandardTab"><span>#TAB_LABEL#</span></td></tr>'||chr(10)||
'</table>#TAB_INLINE_EDIT#</td>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<td align="right" style="padding-left:5px"><table height="28" border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'<tr>'||chr(10)||
'<td height="8" align="center"></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td height="20" align="center" class="t11StandardTab"><a href="#TAB_LINK#">#TAB_LABEL#</a></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>#TAB_INLINE_EDIT#</td>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t11notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '&nbsp;:&nbsp;<a href="#LINK#">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 11,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_template_comment => '12');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/login
prompt  ......Page template 5229116427412463
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_11/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>'||chr(10)||
'';

c3:=c3||'<div class="t11messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'<table align="center" border="0" cellpadding="0" cellspacing="0" summary="" class="t11Login">'||chr(10)||
'<tr>'||chr(10)||
'<td><table summary="" class="t11ReportsRegion" border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top"><img src="#IMAGE_PREFIX#themes/theme_11/t11corner-tl.gif" width="15" height="15" /></td>'||chr(10)||
'<td align="righ';

c3:=c3||'t" valign="top"><img src="#IMAGE_PREFIX#themes/theme_11/t11corner-tr.gif" width="15" height="15" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t11RegionBody">#BOX_BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="bottom" class="t11RegionFooter"><img src="#IMAGE_PREFIX#themes/theme_11/t11corner-bl.gif" width="15" height="15" /></td>'||chr(10)||
'<td align="right" valign="bottom" class="t11RegionFooter"><img src="#IMAG';

c3:=c3||'E_PREFIX#themes/theme_11/t11corner-br.gif" width="15" height="15" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 5229116427412463 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Login',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t11success">#MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t11notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 11,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/printer_friendly
prompt  ......Page template 5229403797412463
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_11/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top">#LOGO##REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" valign="top">#REGION_POSITION_07#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_08#</td>'||chr(10)||
'</table>'||chr(10)||
'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top">'||chr(10)||
'<div style="border:1px solid black;">#SUCCESS_MESSAG';

c3:=c3||'E##NOTIFICATION_MESSAGE#</div>'||chr(10)||
'#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'#REGION_POSITION_05#';

wwv_flow_api.create_template(
  p_id=> 5229403797412463 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Printer Friendly',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t4success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t4notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 11,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_template_comment => '3');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs
prompt  ......Page template 5229708256412463
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_11/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<!-- BEGIN FOOTER -->'||chr(10)||
'<div class="t11top"><!-- Copyright --></div>'||chr(10)||
'<!-- END PAGE -->'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div align="right">'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">&USER.#NAVIGATION_BAR##REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">#REGION_POSITION_07#</td>'||chr(10)||
'<td height="35" align="right" valign="top" cl';

c3:=c3||'ass="t11top" style="padding-right:30px;">#LOGO##REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" align="left" valign="top" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4topleftcorner.jpg" width="28" height="28" alt="" /></td>'||chr(10)||
'<td style="background-color:#91C58D"><img src="#IMAGE_PREFI';

c3:=c3||'X#themes/theme_11/1px_trans.gif" height="40" width="1" alt=""  /></td>'||chr(10)||
'<td colspan="2" align="right" valign="top" nowrap="nowrap" style="background-color:#91C58D"><br /></td>'||chr(10)||
'<td width="35" style="background-color:#91C58D" valign="top"><img src="#IMAGE_PREFIX#themes/theme_11/t4midrightcorner_top.gif"  alt=""/></td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" wi';

c3:=c3||'dth="30" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td height="41" style="background-color:#91C58D"><br /></td>'||chr(10)||
'<td width="31" background="#IMAGE_PREFIX#themes/theme_11/t4top.gif"><img src="#IMAGE_PREFIX#themes/theme_11/t4midleftcorner.gif" width="31" height="41" alt="" /></td>'||chr(10)||
'<td colspan="2" width="100%" height="41" background="#IMAGE_PREFIX#themes/theme_11/t4top.gif"><img src="#IMAGE_PREFIX#themes/theme_11/1';

c3:=c3||'px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'<td width="35" height="41"><img src="#IMAGE_PREFIX#themes/theme_11/t4midrightcorner.gif" width="35" height="41"  alt=""/></td>'||chr(10)||
'<td width="30" height="41"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td align="center" valign="top" style="background-color:#91C58D"><br  /></td>'||chr(10)||
'<td width="';

c3:=c3||'31"><br /></td>'||chr(10)||
'<td align="left" valign="top" colspan="2">'||chr(10)||
'#REGION_POSITION_01#'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" width="100%"><div class="t11messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_02##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</td>'||chr(10)||
'<td width="30"';

c3:=c3||'><br  /></td>'||chr(10)||
'<td width="30"><br /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" height="41" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4bottomcornerleft.gif" width="28" height="45"   border="0"  alt=""/></td>'||chr(10)||
'<td width="31" align="left" background="#IMAGE_PREFIX#themes/theme_11/t4bottom.gif"><img src="#IMAGE_PREFIX#themes/theme_11/t4lowleftcorner.gif" width="31" height="45" alt=';

c3:=c3||'""/></td>'||chr(10)||
'<td width="31" colspan="4" align="right" background="#IMAGE_PREFIX#themes/theme_11/t4bottom.gif"><span class="t11Customize">#CUSTOMIZE#</span><br/></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</div>';

wwv_flow_api.create_template(
  p_id=> 5229708256412463 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t11success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t11notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '&nbsp;:&nbsp;<a href="#LINK#">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 11,
  p_theme_class_id => 3,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs
prompt  ......Page template 5230016160412463
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_11/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<!-- BEGIN FOOTER -->'||chr(10)||
'<div class="t11top"><!-- Copyright --></div>'||chr(10)||
'<!-- END PAGE -->'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div align="right">'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">&USER.#NAVIGATION_BAR##REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">#REGION_POSITION_07#</td>'||chr(10)||
'<td height="35" align="right" valign="top" cl';

c3:=c3||'ass="t11top" style="padding-right:30px;">#LOGO##REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" align="left" valign="top" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4topleftcorner.jpg" width="28" height="28" alt="" /></td>'||chr(10)||
'<td style="background-color:#91C58D"><img src="#IMAGE_PREFI';

c3:=c3||'X#themes/theme_11/1px_trans.gif" height="40" width="1" alt=""  /></td>'||chr(10)||
'<td colspan="2" align="right" valign="top" nowrap="nowrap" style="background-color:#91C58D"><table height="28" border="0" cellpadding="0" cellspacing="0" summary="" align="right"><tr><td><br /></td>#PARENT_TAB_CELLS#</tr></table></td>'||chr(10)||
'<td width="35" style="background-color:#91C58D" valign="top"><img src="#IMAGE_PREFIX#themes/th';

c3:=c3||'eme_11/t4midrightcorner_top.gif"  alt=""/></td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td height="41" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="31" background="#IMAGE_PREFIX#themes/theme_11/t4top.gif"><img src="#IMAGE_PREFIX';

c3:=c3||'#themes/theme_11/t4midleftcorner.gif" width="31" height="41" alt="" /></td>'||chr(10)||
'<td colspan="2" width="100%" height="41" background="#IMAGE_PREFIX#themes/theme_11/t4top.gif"><table height="28" border="0" cellpadding="0" cellspacing="0" summary="" align="right"><tr><td><br /></td>#TAB_CELLS#</tr></table></td>'||chr(10)||
'<td width="35" height="41"><img src="#IMAGE_PREFIX#themes/theme_11/t4midrightcorner.gif" width';

c3:=c3||'="35" height="41"  alt="" /></td>'||chr(10)||
'<td width="30" height="41"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td align="center" valign="top" style="background-color:#91C58D">#REGION_POSITION_02#<img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="31"><img src="#IMAGE_PREFIX#themes/theme_11/1p';

c3:=c3||'x_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td align="left" valign="top" colspan="2">'||chr(10)||
'<!-- BEGIN BREADCRUMB -->#REGION_POSITION_01#<!-- BREADCRUMB  -->'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" width="100%"><div class="t11messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_04##REGION_POSITION_05##REGION_POS';

c3:=c3||'ITION_06##REGION_POSITION_07##REGION_POSITION_08#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" height="41" style="background-colo';

c3:=c3||'r:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4bottomcornerleft.gif" width="28" height="45" alt="" /></td>'||chr(10)||
'<td width="31" align="left" background="#IMAGE_PREFIX#themes/theme_11/t4bottom.gif"><img src="#IMAGE_PREFIX#themes/theme_11/t4lowleftcorner.gif" width="31" height="45" alt=""/></td>'||chr(10)||
'<td width="31" colspan="4" align="right" background="#IMAGE_PREFIX#themes/theme_11/t4bottom.gif"><span cl';

c3:=c3||'ass="t11Customize">#CUSTOMIZE#</span><br/></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<!-- END BODY -->'||chr(10)||
'</div>'||chr(10)||
'<!-- END PAGE -->';

wwv_flow_api.create_template(
  p_id=> 5230016160412463 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t11success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<td class="t11SubTab" valign="top"><div class="t11SubTabB"><span>#TAB_LABEL#</span></div><div><img src="#IMAGE_PREFIX#themes/theme_11/t11toparrow2.gif" width="16" height="8" hspace="0" vspace="0" border="0" /></div>#TAB_INLINE_EDIT#</td>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<td class="t11SubTab" valign="top"><div><a href="#TAB_LINK#">#TAB_LABEL#</a></div><div><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" width="16" height="8" /></div>#TAB_INLINE_EDIT#</td>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<td class="t11StandardTab"><div><img src="#IMAGE_PREFIX#themes/theme_11/t4toparrow.gif" width="16" height="8" hspace="0" vspace="0" border="0" /></div>'||chr(10)||
'<div height="20" class="t4topnav"><span>#TAB_LABEL#</span></div>#TAB_INLINE_EDIT#</td>',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<td class="t11StandardTab"><div><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" width="16" height="8" hspace="0" vspace="0" border="0" /></div>'||chr(10)||
'<div height="20" class="t4topnav"><a href="#TAB_LINK#">#TAB_LABEL#</a></div>#TAB_INLINE_EDIT#</td>',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t11notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> ': <a href="#LINK#">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 11,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comment => '8');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/popup
prompt  ......Page template 5230288632412466
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_11/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'#FORM_CLOSE#</body>'||chr(10)||
'</html>';

c3:=c3||'<table summary="" cellpadding="0" width="100%" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td width="100%" valign="top"><div class="t11messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_01##REGION_POSITION_02##REGION_POSITION_04##REGION_POSITION_05##REGION_POSITION_06##REGION_POSITION_07##REGION_POSITION_08#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_template(
  p_id=> 5230288632412466 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Popup',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t11success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t11notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '<a href="#LINK#">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_theme_id  => 11,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/no_tabs_with_sidebar
prompt  ......Page template 5230614887412466
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_11/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<!-- BEGIN FOOTER -->'||chr(10)||
'<div class="t11top"><!-- Copyright --></div>'||chr(10)||
'<!-- END PAGE -->'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div align="right">'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">&USER.#NAVIGATION_BAR##REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">#REGION_POSITION_07#</td>'||chr(10)||
'<td height="35" align="right" valign="top" cl';

c3:=c3||'ass="t11top" style="padding-right:30px;">#LOGO##REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" align="left" valign="top" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4topleftcorner.jpg" width="28" height="28" alt=""/></td>'||chr(10)||
'<td style="background-color:#91C58D"><img src="#IMAGE_PREFIX';

c3:=c3||'#themes/theme_11/1px_trans.gif" height="40" width="1" alt=""  /></td>'||chr(10)||
'<td colspan="2" align="right" valign="top" nowrap="nowrap" style="background-color:#91C58D"><br /></td>'||chr(10)||
'<td width="35" style="background-color:#91C58D" valign="top"><img src="#IMAGE_PREFIX#themes/theme_11/t4midrightcorner_top.gif" alt="" /></td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" wid';

c3:=c3||'th="30" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td height="41" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="31" background="#IMAGE_PREFIX#themes/theme_11/t4top.gif"><img src="#IMAGE_PREFIX#themes/theme_11/t4midleftcorner.gif" width="31" height="41" alt="" /></td>'||chr(10)||
'<td colspan="2" width="100%" height="41" background="#IM';

c3:=c3||'AGE_PREFIX#themes/theme_11/t4top.gif"><br /></td>'||chr(10)||
'<td width="35" height="41"><img src="#IMAGE_PREFIX#themes/theme_11/t4midrightcorner.gif" width="35" height="41"  alt=""/></td>'||chr(10)||
'<td width="30" height="41"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td align="center" valign="top" style="background-color:#91C58D">#REGION_POSITION_02#<img s';

c3:=c3||'rc="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="31"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td align="left" valign="top" colspan="2">'||chr(10)||
'<!-- BEGIN BREADCRUMB -->#REGION_POSITION_01#<!-- BREADCRUMB  -->'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" w';

c3:=c3||'idth="100%"><div class="t11messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_04##REGION_POSITION_05##REGION_POSITION_06##REGION_POSITION_07##REGION_POSITION_08#</td>'||chr(10)||
'<td valign="top">#REGION_POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="30"><img src="';

c3:=c3||'#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" height="41" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4bottomcornerleft.gif" width="28" height="45" alt="" /></td>'||chr(10)||
'<td width="31" align="left" background="#IMAGE_PREFIX#themes/theme_11/t4bottom.gif"><img src="#IMAGE_PREFIX#themes/theme_11/t4lowleftcorner.gif"';

c3:=c3||' width="31" height="45" alt=""/></td>'||chr(10)||
'<td width="31" colspan="4" align="right" background="#IMAGE_PREFIX#themes/theme_11/t4bottom.gif"><span class="t11Customize">#CUSTOMIZE#</span><br/></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<!-- END BODY -->'||chr(10)||
'</div>'||chr(10)||
'<!-- END PAGE -->';

wwv_flow_api.create_template(
  p_id=> 5230614887412466 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'No Tabs with Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t11success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t11notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '&nbsp;:&nbsp;<a href="#LINK#">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 11,
  p_theme_class_id => 17,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

--application/shared_components/user_interface/templates/page/two_level_tabs_with_sidebar
prompt  ......Page template 5230900717412466
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
c1:=c1||'<html lang="&BROWSER_LANGUAGE." xmlns:htmldb="http://htmldb.oracle.com">'||chr(10)||
'<head>'||chr(10)||
'<title>#TITLE#</title>'||chr(10)||
'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_11/theme_V3.css" type="text/css" />'||chr(10)||
'#HEAD#'||chr(10)||
'</head>'||chr(10)||
'<body #ONLOAD#>#FORM_OPEN#';

c2:=c2||'<!-- BEGIN FOOTER -->'||chr(10)||
'<div class="t11top"><!-- Copyright --></div>'||chr(10)||
'<!-- END PAGE -->'||chr(10)||
'#REGION_POSITION_05#'||chr(10)||
'#FORM_CLOSE# '||chr(10)||
'</body>'||chr(10)||
'</html>';

c3:=c3||'<div align="right">'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">&USER.#NAVIGATION_BAR##REGION_POSITION_06#</td>'||chr(10)||
'<td width="100%" height="35" align="left" valign="top" class="t11top" style="padding-left:30px;">#REGION_POSITION_07#</td>'||chr(10)||
'<td height="35" align="right" valign="top" cl';

c3:=c3||'ass="t11top" style="padding-right:30px;">#LOGO##REGION_POSITION_08#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<table width="97%" border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" align="left" valign="top" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4topleftcorner.jpg" width="28" height="28" alt="" /></td>'||chr(10)||
'<td style="background-color:#91C58D"><img src="#IMAGE_PREFI';

c3:=c3||'X#themes/theme_11/1px_trans.gif" height="40" width="1" alt=""  /></td>'||chr(10)||
'<td colspan="2" align="right" valign="top" nowrap="nowrap" style="background-color:#91C58D"><table height="28" border="0" cellpadding="0" cellspacing="0" summary="" align="right"><tr><td><br /></td>#PARENT_TAB_CELLS#</tr></table></td>'||chr(10)||
'<td width="35" style="background-color:#91C58D" valign="top"><img src="#IMAGE_PREFIX#themes/th';

c3:=c3||'eme_11/t4midrightcorner_top.gif" alt="" /></td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td height="41" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="31" background="#IMAGE_PREFIX#themes/theme_11/t4top.gif"><img src="#IMAGE_PREFIX';

c3:=c3||'#themes/theme_11/t4midleftcorner.gif" width="31" height="41" alt="" /></td>'||chr(10)||
'<td colspan="2" width="100%" height="41" background="#IMAGE_PREFIX#themes/theme_11/t4top.gif"><table height="28" border="0" cellpadding="0" cellspacing="0" summary="" align="right"><tr><td><br /></td>#TAB_CELLS#</tr></table></td>'||chr(10)||
'<td width="35" height="41"><img src="#IMAGE_PREFIX#themes/theme_11/t4midrightcorner.gif" width';

c3:=c3||'="35" height="41" alt=""  /></td>'||chr(10)||
'<td width="30" height="41"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="30" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td align="center" valign="top" style="background-color:#91C58D">#REGION_POSITION_02#<img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="31"><img src="#IMAGE_PREFIX#themes/theme_11/1p';

c3:=c3||'x_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td align="left" valign="top" colspan="2">'||chr(10)||
'<!-- BEGIN BREADCRUMB -->#REGION_POSITION_01#<!-- BREADCRUMB  -->'||chr(10)||
'<table summary="" cellpadding="0" cellspacing="0" border="0" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top" width="100%"><div class="t11messages">#SUCCESS_MESSAGE##NOTIFICATION_MESSAGE#</div>#BOX_BODY##REGION_POSITION_04#</td>'||chr(10)||
'<td valign="top">#REGION_';

c3:=c3||'POSITION_03#<br /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'</td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'<td width="30"><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="1" alt=""  /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr> '||chr(10)||
'<td width="28" height="41" style="background-color:#91C58D"><img src="#IMAGE_PREFIX#themes/theme_11/t4bottomcornerleft.gif" width';

c3:=c3||'="28" height="45" alt=""  /></td>'||chr(10)||
'<td width="31" align="left" background="#IMAGE_PREFIX#themes/theme_11/t4bottom.gif"><img src="#IMAGE_PREFIX#themes/theme_11/t4lowleftcorner.gif" width="31" height="45" alt="" /></td>'||chr(10)||
'<td width="31" colspan="4" align="right" background="#IMAGE_PREFIX#themes/theme_11/t4bottom.gif"><span class="t11Customize">#CUSTOMIZE#</span><br/></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'<!-- END BODY -';

c3:=c3||'->'||chr(10)||
'</div>'||chr(10)||
'<!-- END PAGE -->';

wwv_flow_api.create_template(
  p_id=> 5230900717412466 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'Two Level Tabs with Sidebar',
  p_body_title=> '',
  p_header_template=> c1,
  p_box=> c3,
  p_footer_template=> c2,
  p_success_message=> '<div class="t11success">#SUCCESS_MESSAGE#</div>',
  p_current_tab=> '<td class="t11SubTab" valign="top"><div class="t11SubTabB"><span>#TAB_LABEL#</span></div><div><img src="#IMAGE_PREFIX#themes/theme_11/t11toparrow2.gif" width="16" height="8" hspace="0" vspace="0" border="0" /></div>#TAB_INLINE_EDIT#</td>',
  p_current_tab_font_attr=> '',
  p_non_current_tab=> '<td class="t11SubTab" valign="top"><div><a href="#TAB_LINK#">#TAB_LABEL#</a></div><div><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" width="16" height="8" /></div>#TAB_INLINE_EDIT#</td>',
  p_non_current_tab_font_attr => '',
  p_top_current_tab=> '<td class="t11StandardTab"><div><img src="#IMAGE_PREFIX#themes/theme_11/t4toparrow.gif" width="16" height="8" hspace="0" vspace="0" border="0" /></div>'||chr(10)||
'<div height="20" class="t4topnav"><span>#TAB_LABEL#</span></div>#TAB_INLINE_EDIT#</td>',
  p_top_current_tab_font_attr => '',
  p_top_non_curr_tab=> '<td class="t11StandardTab"><div><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" width="16" height="8" hspace="0" vspace="0" border="0" /></div>'||chr(10)||
'<div height="20" class="t4topnav"><a href="#TAB_LINK#">#TAB_LABEL#</a></div>#TAB_INLINE_EDIT#</td>',
  p_top_non_curr_tab_font_attr=> '',
  p_current_image_tab=> '',
  p_non_current_image_tab=> '',
  p_notification_message=> '<div class="t11notification">#MESSAGE#</div>',
  p_navigation_bar=> '#BAR_BODY#',
  p_navbar_entry=> '&nbsp;:&nbsp;<a href="#LINK#">#TEXT#</a>',
  p_app_tab_before_tabs=>'',
  p_app_tab_current_tab=>'',
  p_app_tab_non_current_tab=>'',
  p_app_tab_after_tabs=>'',
  p_region_table_cattributes=> ' summary="" cellpadding="0" border="0" cellspacing="0" width="100%"',
  p_sidebar_def_reg_pos => 'REGION_POSITION_02',
  p_breadcrumb_def_reg_pos => 'REGION_POSITION_01',
  p_theme_id  => 11,
  p_theme_class_id => 18,
  p_translate_this_template => 'N',
  p_template_comment => '');
end;
 
null;
 
end;
/

prompt  ...button templates
--
--application/shared_components/user_interface/templates/button/button
prompt  ......Button Template 4245073391114034
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t20Button">#LABEL#</a>';

wwv_flow_api.create_button_templates (
  p_id=>4245073391114034 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button',
  p_translate_this_template => 'N',
  p_theme_id  => 20,
  p_theme_class_id => 1,
  p_template_comment       => 'Standard Button');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_1
prompt  ......Button Template 4245273423114036
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t20Button2">#LABEL#</a>';

wwv_flow_api.create_button_templates (
  p_id=>4245273423114036 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 1',
  p_translate_this_template => 'N',
  p_theme_id  => 20,
  p_theme_class_id => 4,
  p_template_comment       => 'XP Square FFFFFF');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_2
prompt  ......Button Template 4245459807114036
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t20Button">#LABEL#</a>';

wwv_flow_api.create_button_templates (
  p_id=>4245459807114036 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 2',
  p_translate_this_template => 'N',
  p_theme_id  => 20,
  p_theme_class_id => 5,
  p_template_comment       => 'Standard Button');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_3
prompt  ......Button Template 4245672227114037
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t20Button">#LABEL#</a>';

wwv_flow_api.create_button_templates (
  p_id=>4245672227114037 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 3',
  p_translate_this_template => 'N',
  p_theme_id  => 20,
  p_theme_class_id => 2,
  p_template_comment       => 'Standard Button');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_3
prompt  ......Button Template 5182694796808415
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<table class="t1ButtonAlternative3" cellspacing="0" cellpadding="0" border="0"  summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1L"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/theme_1/button_alt3_left.gif" alt="" width="6" height="25" /></a></td>'||chr(10)||
'<td class="t1C"><a href="#LINK#">#LABEL#</a></td>'||chr(10)||
'<td class="t1R"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/theme_1/button_alt3_right.gif" width="6" height="25" a';

t:=t||'lt="" /></a></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_button_templates (
  p_id=>5182694796808415 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 3',
  p_translate_this_template => 'N',
  p_theme_id  => 1,
  p_theme_class_id => 2,
  p_template_comment       => 'Standard Button');
end;
/
--application/shared_components/user_interface/templates/button/button
prompt  ......Button Template 5182807341808415
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<table class="t1Button" cellspacing="0" cellpadding="0" border="0"  summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1L"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/theme_1/button_left.gif" alt="" width="4" height="24" /></a></td>'||chr(10)||
'<td class="t1C"><a href="#LINK#">#LABEL#</a></td>'||chr(10)||
'<td class="t1R"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/theme_1/button_right.gif" width="4" height="24" alt="" /></a></td>'||chr(10)||
'</tr';

t:=t||'>'||chr(10)||
'</table>';

wwv_flow_api.create_button_templates (
  p_id=>5182807341808415 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button',
  p_translate_this_template => 'N',
  p_theme_id  => 1,
  p_theme_class_id => 1,
  p_template_comment       => '');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_1
prompt  ......Button Template 5182893389808415
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<table class="t1ButtonAlternative1" cellspacing="0" cellpadding="0" border="0"  summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1L"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/theme_1/button_alt1_left.gif" alt="" width="11" height="20" /></a></td>'||chr(10)||
'<td class="t1C"><a href="#LINK#">#LABEL#</a></td>'||chr(10)||
'<td class="t1R"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/theme_1/button_alt1_right.gif" width="11" height="20"';

t:=t||' alt="" /></a></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_button_templates (
  p_id=>5182893389808415 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 1',
  p_translate_this_template => 'N',
  p_theme_id  => 1,
  p_theme_class_id => 4,
  p_template_comment       => '');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_2
prompt  ......Button Template 5183011754808415
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<table class="t1ButtonAlternative2" cellspacing="0" cellpadding="0" border="0"  summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1L"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/theme_1/button_alt2_left.gif" alt="" width="11" height="20" /></a></td>'||chr(10)||
'<td class="t1C"><a href="#LINK#">#LABEL#</a></td>'||chr(10)||
'<td class="t1R"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/theme_1/button_alt2_right.gif" width="11" height="20"';

t:=t||' alt="" /></a></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_button_templates (
  p_id=>5183011754808415 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 2',
  p_translate_this_template => 'N',
  p_theme_id  => 1,
  p_theme_class_id => 5,
  p_template_comment       => 'XP Square FFFFFF');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_3
prompt  ......Button Template 5231210045412466
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t11Button">'||chr(10)||
'<tr>'||chr(10)||
'<td align="right" valign="top" class="t11R"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/theme_11/t11btn1_corner_tl.gif" width="8" height="16"  alt=""/></a></td>'||chr(10)||
'<td class="t11C"><a href="#LINK#" class="t11C">#LABEL#</a></td>'||chr(10)||
'<td align="right" valign="top" class="t11L"><a href="#LINK#"><img src="#IMAGE_PREFIX#t';

t:=t||'hemes/theme_11/t11btn1_corner_tr.gif" width="8" height="16"  alt=""/></a></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_button_templates (
  p_id=>5231210045412466 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 3',
  p_translate_this_template => 'N',
  p_theme_id  => 11,
  p_theme_class_id => 2,
  p_template_comment       => '');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_1
prompt  ......Button Template 5231389014412468
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t11ButtonAlternative1">'||chr(10)||
'<tr>'||chr(10)||
'<td align="right" valign="top" class="t11R"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/theme_11/t11btn2_corner_tl.gif" width="8" height="16"  alt=""/></a></td>'||chr(10)||
'<td class="t11C"><a href="#LINK#" class="t11C">#LABEL#</a></td>'||chr(10)||
'<td align="right" valign="top" class="t11L"><span class="t11R"><a href="#L';

t:=t||'INK#"><img src="#IMAGE_PREFIX#themes/theme_11/t11btn2_corner_tr.gif" width="8" height="16"  alt=""/></a></span></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_button_templates (
  p_id=>5231389014412468 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 1',
  p_translate_this_template => 'N',
  p_theme_id  => 11,
  p_theme_class_id => 4,
  p_template_comment       => '');
end;
/
--application/shared_components/user_interface/templates/button/button
prompt  ......Button Template 5231586883412468
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t11ButtonAlternative3">'||chr(10)||
'<tr>'||chr(10)||
'<td align="right" valign="top" class="t11R"><a href="#LINK#" class="t11C" title=""><img src="#IMAGE_PREFIX#themes/theme_11/t11btn4_corner_tl.gif" width="8" height="16" alt=""/></a></td>'||chr(10)||
'<td class="t11C"><a href="#LINK#" class="t11C" title="">#LABEL#</a></td>'||chr(10)||
'<td align="right" valign="top" class="t11L">';

t:=t||'<span class="t11R"><a href="#LINK#" title="" class="t11C"><img src="#IMAGE_PREFIX#themes/theme_11/t11btn4_corner_tr.gif" width="8" height="16"  alt=""/></a></span></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_button_templates (
  p_id=>5231586883412468 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button',
  p_translate_this_template => 'N',
  p_theme_id  => 11,
  p_theme_class_id => 1,
  p_template_comment       => '');
end;
/
--application/shared_components/user_interface/templates/button/button_alternative_2
prompt  ......Button Template 5231818760412468
declare
  t varchar2(32767) := null;
  l_clob clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t11ButtonAlternative2">'||chr(10)||
'<tr>'||chr(10)||
'<td align="right" valign="top" class="t11R"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/theme_11/t11btn3_corner_tl.gif" width="8" height="16"  alt=""/></a></td>'||chr(10)||
'<td class="t11C"><a href="#LINK#" class="t11C">#LABEL#</a></td>'||chr(10)||
'<td align="right" valign="top" class="t11L"><span class="t11R"><a href="#L';

t:=t||'INK#"><img src="#IMAGE_PREFIX#themes/theme_11/t11btn3_corner_tr.gif" width="8" height="16"  alt=""/></a></span></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

wwv_flow_api.create_button_templates (
  p_id=>5231818760412468 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_template=>t,
  p_template_name=> 'Button, Alternative 2',
  p_translate_this_template => 'N',
  p_theme_id  => 11,
  p_theme_class_id => 5,
  p_template_comment       => '');
end;
/
---------------------------------------
prompt  ...region templates
--
--application/shared_components/user_interface/templates/region/borderless_region
prompt  ......region template 4245873393114037
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20Borderless" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr>';

t:=t||'<td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4245873393114037 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Borderless Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 20,
  p_theme_class_id => 7,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4245873393114037 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/bracketed_region
prompt  ......region template 4246173958114039
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20Bracketed" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr><';

t:=t||'td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4246173958114039 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Bracketed Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 20,
  p_theme_class_id => 18,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4246173958114039 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/breadcrumb_region
prompt  ......region template 4246460268114039
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div id="#REGION_STATIC_ID#" class="t20Breadcrumbs" #REGION_ATTRIBUTES#>#BODY#</div>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4246460268114039 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Breadcrumb Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 20,
  p_theme_class_id => 6,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4246460268114039 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_with_title
prompt  ......region template 4246774911114039
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20ButtonRegionwithTitle" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td';

t:=t||'></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>#BODY#';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4246774911114039 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Button Region with Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 20,
  p_theme_class_id => 4,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4246774911114039 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_without_title
prompt  ......region template 4247076082114039
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20ButtonRegionwithoutTitle" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>#BODY#';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4247076082114039 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Button Region without Title',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 20,
  p_theme_class_id => 17,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4247076082114039 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/chart_region
prompt  ......region template 4247376159114039
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20ChartRegion" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr';

t:=t||'><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4247376159114039 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Chart Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 20,
  p_theme_class_id => 30,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4247376159114039 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/form_region
prompt  ......region template 4247667412114039
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20FormRegion" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr>';

t:=t||'<td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4247667412114039 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Form Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 20,
  p_theme_class_id => 8,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4247667412114039 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/hide_and_show_region
prompt  ......region template 4247961915114040
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20HideShow" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header"><img src="#IMAGE_PREFIX#themes/theme_20/collapse_plus.gif" onclick="htmldb_ToggleWithImage(this,''#REGION_STATIC_ID#_body'')" class="pb" alt="" />#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATI';

t:=t||'C_ID#_body" style="display:none;">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4247961915114040 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Hide and Show Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 20,
  p_theme_class_id => 1,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4247961915114040 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/list_region_with_icon_chart
prompt  ......region template 4248286308114041
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20ListRegionwithIcon" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></';

t:=t||'tr>'||chr(10)||
'<tr><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4248286308114041 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'List Region with Icon (Chart)',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 20,
  p_theme_class_id => 29,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4248286308114041 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region
prompt  ......region template 4248568360114041
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div class="t20Region t20NavRegion" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<div class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</div>'||chr(10)||
'<div id="#REGION_STATIC_ID#_body" class="t20RegionBody">#BODY#</div>'||chr(10)||
'</div>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4248568360114041 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Navigation Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 20,
  p_theme_class_id => 5,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4248568360114041 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region_alternative_1
prompt  ......region template 4248860188114041
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div class="t20Region t20NavRegionAlt" id="#REGION_STATIC_ID#"#REGION_ATTRIBUTES#><div class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</div><div id="#REGION_STATIC_ID#_body" class="t20RegionBody">#BODY#</div></div>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4248860188114041 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Navigation Region, Alternative 1',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 20,
  p_theme_class_id => 16,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4248860188114041 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_buttons_and_title
prompt  ......region template 4249175654114041
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20RegionwithoutButtonsandTitle" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4249175654114041 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Region without Buttons and Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 20,
  p_theme_class_id => 19,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4249175654114041 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_title
prompt  ......region template 4249461806114042
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20RegionwithoutTitle" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4249461806114042 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Region without Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 20,
  p_theme_class_id => 11,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4249461806114042 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/report_filter_single_row
prompt  ......region template 4249772395114042
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="apex_finderbar" cellpadding="0" cellspacing="0" border="0" summary="" id="#REGION_STATIC_ID#" #REGION_ATTRIBUTES#>'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td class="apex_finderbar_left_top" valign="top"><img src="#IMAGE_PREFIX#1px_trans.gif" width="10" height="8" alt=""  class="spacer" alt="" /></td>'||chr(10)||
'<td class="apex_finderbar_middle" rowspan="3" valign="middle"><img src="#IMAGE_PREFIX#htmldb/builder/builder_f';

t:=t||'ind.png" /></td>'||chr(10)||
'<td class="apex_finderbar_middle" rowspan="3" valign="middle" style="">#BODY#</td>'||chr(10)||
'<td class="apex_finderbar_left" rowspan="3" width="10"><br /></td>'||chr(10)||
'<td class="apex_finderbar_buttons" rowspan="3" valign="middle" nowrap="nowrap"><span class="apex_close">#CLOSE#</span><span>#EDIT##CHANGE##DELETE##CREATE##CREATE2##COPY##PREVIOUS##NEXT##EXPAND##HELP#</span></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr><td class="';

t:=t||'apex_finderbar_left_middle"><br /></td></tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="apex_finderbar_left_bottom" valign="bottom"><img src="#IMAGE_PREFIX#1px_trans.gif" width="10" height="8"  class="spacer" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4249772395114042 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Report Filter - Single Row',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 20,
  p_theme_class_id => 31,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4249772395114042 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/report_list
prompt  ......region template 4250063392114042
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20ReportList" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<tr>';

t:=t||'<td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4250063392114042 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Report List',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 20,
  p_theme_class_id => 29,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4250063392114042 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region
prompt  ......region template 4250378089114043
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20ReportRegion" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<t';

t:=t||'r><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4250378089114043 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 20,
  p_theme_class_id => 9,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4250378089114043 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_100_width
prompt  ......region template 4250670658114043
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20ReportsRegion100" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr';

t:=t||'>'||chr(10)||
'<tr><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4250670658114043 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region 100% Width',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 20,
  p_theme_class_id => 13,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4250670658114043 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_alternative_1
prompt  ......region template 4250970077114043
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20ReportsRegionAlt" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr';

t:=t||'>'||chr(10)||
'<tr><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4250970077114043 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region, Alternative 1',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 20,
  p_theme_class_id => 10,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4250970077114043 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region
prompt  ......region template 4251262229114044
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20SidebarRegion" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4251262229114044 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Sidebar Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 20,
  p_theme_class_id => 2,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4251262229114044 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region_alternative_1
prompt  ......region template 4251560916114044
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20SidebarRegionAlt" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4251560916114044 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Sidebar Region, Alternative 1',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 20,
  p_theme_class_id => 3,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4251560916114044 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region
prompt  ......region template 4251863043114044
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20WizardRegion" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr>'||chr(10)||
'<t';

t:=t||'r><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4251863043114044 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Wizard Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 20,
  p_theme_class_id => 12,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4251863043114044 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region_with_icon
prompt  ......region template 4252164387114044
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t20Region t20WizardRegionIcon" id="#REGION_STATIC_ID#" border="0" cellpadding="0" cellspacing="0" summary="" #REGION_ATTRIBUTES#>'||chr(10)||
'<thead><tr><th class="t20RegionHeader" id="#REGION_STATIC_ID#_header">#TITLE#</th></tr></thead>'||chr(10)||
'<tbody id="#REGION_STATIC_ID#_body">'||chr(10)||
'<tr><td class="t20ButtonHolder">#CLOSE##PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td></tr';

t:=t||'>'||chr(10)||
'<tr><td class="t20RegionBody">#BODY#</td></tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 4252164387114044 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Wizard Region with Icon',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 20,
  p_theme_class_id => 20,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 4252164387114044 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/report_list
prompt  ......region template 5183112614808415
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1ListRegionwithIcon" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body" colspan="2"><table cellpadding="0" cellspacing="0" border="0" summary="" ><tr>'||chr(10)||
'<td valign="top"><img src="#';

t:=t||'IMAGE_PREFIX#themes/theme_1/report.gif" alt=""/></td>'||chr(10)||
'<td>#BODY#</td></tr></table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5183112614808415 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Report List',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 1,
  p_theme_class_id => 29,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5183112614808415 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/chart_list
prompt  ......region template 5183200491808415
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1ListRegionwithIcon" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body" colspan="2"><table cellpadding="0" cellspacing="0" border="0" summary="" ><tr><td valign="top"><img src="#I';

t:=t||'MAGE_PREFIX#themes/theme_1/chart.gif" alt=""/></td>'||chr(10)||
'<td>#BODY#</td></tr></table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5183200491808415 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Chart List',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 1,
  p_theme_class_id => 29,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5183200491808415 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_title
prompt  ......region template 5183303139808415
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1RegionwithoutTitle" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5183303139808415 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Region without Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 11,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5183303139808415 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/hide_and_show_region
prompt  ......region template 5183386716808415
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1HideandShowRegion" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td><table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#<a style="margin-left:5px;" href="javascript:hideShow(''region#REGION_SEQUENCE_ID#'',''shIMG#REGION_SEQUENCE_ID#'',''#IMAGE_PREFIX#themes/theme_1/rollup_plus_dgray.gif'',''#IMAG';

t:=t||'E_PREFIX#themes/theme_1/rollup_minus_dgray.gif'');" class="t1HideandShowRegionLink"><img src="#IMAGE_PREFIX#themes/theme_1/rollup_plus_dgray.gif" '||chr(10)||
'  id="shIMG#REGION_SEQUENCE_ID#" alt="" /></a></td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body"><div class="t1Hide" id="region#REGION_SEQU';

t:=t||'ENCE_ID#">#BODY#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5183386716808415 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Hide and Show Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 1,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => 'Gray Head, white body');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5183386716808415 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_without_title
prompt  ......region template 5183495375808415
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1ButtonRegionwithoutTitle" id="#REGION_ID#">'||chr(10)||
'<tr><td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##HELP#<img src="#IMAGE_PREFIX#/themes/theme_1/1px_trans.gif" height="1" width="600" style="display:block;" alt="" /></td></tr>'||chr(10)||
'</table>'||chr(10)||
'#BODY#';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5183495375808415 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Button Region without Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 17,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5183495375808415 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_buttons_and_titles
prompt  ......region template 5183617061808415
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" cellpadding="0" cellspacing="0" border="0" class="t1RegionwithoutButtonsandTitles" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
''||chr(10)||
'';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5183617061808415 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Region without Buttons and Titles',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 19,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5183617061808415 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_alternative_1
prompt  ......region template 5183689547808415
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1ReportsRegionAlternative1" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body" colspan="2">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5183689547808415 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region, Alternative 1',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 1,
  p_theme_class_id => 10,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5183689547808415 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/borderless_region
prompt  ......region template 5183813168808415
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1BorderlessRegion" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##COPY##CREATE##CREATE2##EXPAND##HELP#</td>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body" colspan="2">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5183813168808415 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Borderless Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 7,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => 'Use this region template when you want to contain content without a border.'||chr(10)||
''||chr(10)||
'TITLE=YES'||chr(10)||
'BUTTONS=YES'||chr(10)||
'100% WIDTH=NO');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5183813168808415 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_with_title
prompt  ......region template 5183912384808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1ButtonRegionwithTitle" id="#REGION_ID#">'||chr(10)||
'<tr><td class="t1RegionHeader">#TITLE#</td></tr>'||chr(10)||
'<tr><td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##COPY##EXPAND##HELP#<img src="#IMAGE_PREFIX#/themes/theme_1/1px_trans.gif" height="1" width="600" style="display:block;" alt="" /';

t:=t||'></td></tr>'||chr(10)||
'</table>#BODY#'||chr(10)||
'';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5183912384808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Button Region with Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 4,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5183912384808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region_alternative_1
prompt  ......region template 5184015681808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellspacing="0" cellpadding="0" border="0" class="t1SidebarRegionAlternative1" summary="" id="#REGION_ID#" align="right">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1EndCaps" valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/left_curve.gif" width="10" height="20" alt="" /></td>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1EndCaps" valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/right_curve.gif" width="';

t:=t||'10" height="20" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="3" class="t1Body">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table><br />';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5184015681808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Sidebar Region, Alternative 1',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 1,
  p_theme_class_id => 3,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5184015681808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region
prompt  ......region template 5184115896808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellspacing="0" cellpadding="0" border="0" class="t1SidebarRegion" summary="" id="#REGION_ID#" align="right">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1EndCaps" valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/left_curve.gif" width="10" height="20" alt="" /></td>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1EndCaps" valign="top"><img src="#IMAGE_PREFIX#themes/theme_1/right_curve.gif" width="10" height="';

t:=t||'20" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="3" class="t1Body">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table><br />';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5184115896808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Sidebar Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 1,
  p_theme_class_id => 2,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '<table border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'        <tr>'||chr(10)||
'          <td rowspan="2" valign="top" width="4" bgcolor="#FF0000"><img src="#IMAGE_PREFIX#tl_img.gif" border="0" width="4" height="18" alt="" /></td>'||chr(10)||
'          <td bgcolor="#000000" height="1"><img src="#IMAGE_PREFIX#stretch.gif" width="142" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td rowspan="2" valign="top" width="4" bgcolor="#FF0000"><img src="#IMAGE_PREFIX#tr_img.gif" border="0" width="4" height="18" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#FF0000" height="16">'||chr(10)||
'            <table border="0" cellpadding="0" cellspacing="0" width="100%">'||chr(10)||
'              <tr>'||chr(10)||
'                <td align=middle valign="top">'||chr(10)||
'                  <div align="center">'||chr(10)||
'                     <font color="#ffffff" face="Arial, Helvetica, sans-serif" size="1">'||chr(10)||
'                      <b>#TITLE# </b></font></div>'||chr(10)||
'                </td>'||chr(10)||
'              </tr>'||chr(10)||
'            </table>'||chr(10)||
'          </td>'||chr(10)||
'        </tr>'||chr(10)||
'</table>'||chr(10)||
'<table border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'   <tr>'||chr(10)||
'   <td bgcolor="#000000" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'   <td valign="top" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="146" height="1" border="0" alt="" /><br />'||chr(10)||
'            <table border="0" cellpadding="1" cellspacing="0" width="146" summary="">'||chr(10)||
'              <tr>'||chr(10)||
'                <td colspan="2">'||chr(10)||
'                  <table border="0" cellpadding="2" cellspacing="0" width="124" summary="">'||chr(10)||
'                    <tr>'||chr(10)||
'                      <td>&nbsp;</td>'||chr(10)||
'                      <td valign="top" width="106">'||chr(10)||
'                        <P><FONT face="arial, helvetica" size="1">'||chr(10)||
'                            #BODY#'||chr(10)||
'                           </font>'||chr(10)||
'                        </P>'||chr(10)||
'                      </td>'||chr(10)||
'                    </tr>'||chr(10)||
'                  </table>'||chr(10)||
'            </table>'||chr(10)||
'          </td>'||chr(10)||
'          <td bgcolor="#000000" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td bgcolor="#9a9c9a" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td bgcolor="#b3b4b3" width="1" height="96"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'      </table>'||chr(10)||
'      <table border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'        <tr>'||chr(10)||
'          <td rowspan="4" valign="top" width="4"><img src="#IMAGE_PREFIX#bl_img.gif" border="0" width="4" height="6" alt="" /></td>'||chr(10)||
'          <td bgcolor="#ffffff" height="2"><img src="#IMAGE_PREFIX#stretch.gif" width="142" height="1" border="0" alt="" /></td>'||chr(10)||
'          <td rowspan="4" valign="top" width="4"><img src="#IMAGE_PREFIX#br_img.gif" border="0" width="4" height="6" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#000000" width="1"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#9a9c9a" width="1"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'        <tr>'||chr(10)||
'          <td bgcolor="#b3b4b3" width="1" height="2"><img src="#IMAGE_PREFIX#stretch.gif" width="1" height="1" border="0" alt="" /></td>'||chr(10)||
'        </tr>'||chr(10)||
'</table>'||chr(10)||
'');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5184115896808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/form_region
prompt  ......region template 5184202849808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1FormRegion" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_1/1px_trans.gif" height="1" width="400" alt="" /><table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CH';

t:=t||'ANGE##CREATE##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body">#BODY#<img src="#IMAGE_PREFIX#/themes/theme_1/1px_trans.gif" height="1" width="600" style="display:block;" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5184202849808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Form Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 1,
  p_theme_class_id => 8,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5184202849808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region_alternative_1
prompt  ......region template 5184315966808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1NavigationRegionAlternative1" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5184315966808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Navigation Region, Alternative 1',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 16,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5184315966808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region_with_icon
prompt  ......region template 5184401682808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1WizardRegionwithIcon" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body" colspan="2"><table summary="" cellpadding="0" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src=';

t:=t||'"#IMAGE_PREFIX#themes/theme_1/wizard_icon.gif" alt=""/></td>'||chr(10)||
'<td width="100%" valign="top">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5184401682808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Wizard Region with Icon',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 20,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5184401682808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/chart_region
prompt  ......region template 5184490716808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1ChartRegion" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td><table width="100%" cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body">#BODY#</td';

t:=t||'>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5184490716808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Chart Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 1,
  p_theme_class_id => 30,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5184490716808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/bracketed_region
prompt  ......region template 5184606468808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1BracketedRegion" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##COPY##CREATE##CREATE2##EXPAND##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2"><table cellpadding="0" cellspacing="0" border="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td class=';

t:=t||'"t1bracket"><img src="" height="5" width="1" alt="#IMAGE_PREFIX#themes/theme_1/1px_trans.gif" /></td>'||chr(10)||
'<td rowspan="3" class="t1Body">#BODY#</td>'||chr(10)||
'<td class="t1bracket"><img src="" height="5" width="1" alt="#IMAGE_PREFIX#themes/theme_1/1px_trans.gif" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_1/1px_trans.gif" height="1" width="1" alt="" /></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/the';

t:=t||'me_1/1px_trans.gif" height="1" width="1" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1bracket"><img src="" height="5" width="1" alt="#IMAGE_PREFIX#themes/theme_1/1px_trans.gif" /></td>'||chr(10)||
'<td class="t1bracket"><img src="" height="5" width="1" alt="#IMAGE_PREFIX#themes/theme_1/1px_trans.gif" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5184606468808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Bracketed Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 18,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => 'Use this region template when you want to contain content with a bracket UI.'||chr(10)||
''||chr(10)||
'TITLE=YES'||chr(10)||
'BUTTONS=YES'||chr(10)||
'100% WIDTH=NO');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5184606468808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region
prompt  ......region template 5184709198808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1WizardRegion" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body" colspan="2">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5184709198808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Wizard Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 12,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5184709198808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_100_width
prompt  ......region template 5184790081808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1ReportsRegion100Width" width="100%" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body" colspan="2">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5184790081808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region 100% Width',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 1,
  p_theme_class_id => 13,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5184790081808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region
prompt  ......region template 5184893763808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table cellpadding="0" cellspacing="0" border="0" summary="" class="t1ReportsRegion" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1RegionHeader">#TITLE#</td>'||chr(10)||
'<td class="t1ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1Body" colspan="2">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5184893763808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 1,
  p_theme_class_id => 9,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5184893763808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/breadcrumb_region
prompt  ......region template 5184994576808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div class="t1BreadcrumbRegion" id="#REGION_ID#">#BODY#</div>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5184994576808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Breadcrumb Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 6,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => 'Use this region template to contain breadcrumb menus.  Breadcrumb menus are implemented using breadcrumbs.  Breadcrumb menus are designed to displayed in #REGION_POSITION_01#');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5184994576808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region
prompt  ......region template 5185109691808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div class="t1NavigationRegion" id="#REGION_ID#">#BODY#</div>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5185109691808416 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Navigation Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 1,
  p_theme_class_id => 5,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5185109691808416 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/bracketed_region
prompt  ......region template 5232008615412468
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary=""  class="t11BracketedRegion" id="#REGION_ID#" border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2"><table cellpadding="0" cellspacing="0" border="0" summary="" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11bracket"><img  height="5" width="1" src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" alt="" /></td>';

t:=t||''||chr(10)||
'<td rowspan="3">'||chr(10)||
'<div class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div><div class="t11RegionBody">#BODY#</div></td>'||chr(10)||
'<td class="t11bracket"><img  height="5" width="1" src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif"  alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11bracketspace"><img  height="1" width="1" src="#IMAGE_PREFIX#t';

t:=t||'hemes/theme_11/1px_trans.gif"  alt="" /></td>'||chr(10)||
'<td class="t11bracketspace"><img  height="1" width="1" src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif"  alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11bracket"><img  height="5" width="1" src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif"  alt="" /></td>'||chr(10)||
'<td class="t11bracket"><img  height="5" width="1" src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif"  alt="';

t:=t||'" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5232008615412468 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Bracketed Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 11,
  p_theme_class_id => 18,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5232008615412468 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_without_title
prompt  ......region template 5232302953412469
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11ButtonRegionwithoutTitle" border="0" cellpadding="0" cellspacing="0" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#<img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" style="display:block;" height="1" width="600" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>#BODY#';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5232302953412469 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Button Region without Title',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 11,
  p_theme_class_id => 17,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5232302953412469 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/form_region
prompt  ......region template 5232618431412469
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11FormRegion" border="0" cellpadding="0" cellspacing="0" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#<img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" style="display:block;" height="1"';

t:=t||' width="600" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5232618431412469 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Form Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 11,
  p_theme_class_id => 8,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5232618431412469 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region
prompt  ......region template 5232907392412469
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11SidebarRegion" border="0" cellpadding="0" cellspacing="0" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5232907392412469 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Sidebar Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 11,
  p_theme_class_id => 2,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5232907392412469 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_buttons_and_title
prompt  ......region template 5233191498412469
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11RegionwithoutButtonsandTitle" border="0" cellpadding="0" cellspacing="0" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5233191498412469 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Region without Buttons and Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 11,
  p_theme_class_id => 19,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5233191498412469 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/button_region_with_title
prompt  ......region template 5233508437412469
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11ButtonRegionwithTitle" border="0" cellpadding="0" cellspacing="0" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#<img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" style="display:block;"';

t:=t||' height="1" width="600" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>#BODY#';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5233508437412469 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Button Region with Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 11,
  p_theme_class_id => 4,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5233508437412469 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/breadcrumb_region
prompt  ......region template 5233796153412469
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div class="t11BreadcrumbRegion" id="#REGION_ID#">#BODY#</div>'||chr(10)||
'          ';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5233796153412469 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Breadcrumb Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 11,
  p_theme_class_id => 6,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5233796153412469 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region
prompt  ......region template 5234094764412469
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table border="0" cellpadding="0" cellspacing="0" class="t11WizardRegion" id="#REGION_ID#" summary="">'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader"><img src="#IMAGE_PREFIX#themes/theme_11/t11corner-wiz-tl.gif" width="15" height="15"  alt="" />#TITLE#</td>'||chr(10)||
'<td align="right" valign="top" class="t11RegionHeader"><img src="#IMAGE_PREFIX#themes/theme_11/t11corner-wiz-tr.gif" width';

t:=t||'="15" height="15"  alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder" colspan="2">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t11RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="bottom" class="t11RegionFooter"><img src="#IMAGE_PREFIX#themes/theme_11/t11corner-wiz-bl.gif" width="15" height=';

t:=t||'"15"  alt="" /></td>'||chr(10)||
'<td align="right" valign="bottom" class="t11RegionFooter"><img src="#IMAGE_PREFIX#themes/theme_11/t11corner-wiz-br.gif" width="15" height="15"  alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5234094764412469 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Wizard Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 11,
  p_theme_class_id => 12,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5234094764412469 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/chart_list
prompt  ......region template 5234407742412469
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11ListRegionwithIcon" id="#REGION_ID#" border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody"><table summary="" cellpadding="0" cel';

t:=t||'lspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_11/chart.gif" alt="" /></td>'||chr(10)||
'<td valign="top">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
''||chr(10)||
'';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5234407742412469 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Chart List',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 11,
  p_theme_class_id => 29,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5234407742412469 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region
prompt  ......region template 5234717058412469
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div id="#REGION_ID#" style="clear:both;">#BODY#</div>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5234717058412469 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Navigation Region',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 11,
  p_theme_class_id => 5,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => 'In Round Green Theme Navigation Region and Navigation Region, Alternative 1 are the identical');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5234717058412469 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/navigation_region_alternative_1
prompt  ......region template 5234999592412471
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<div id="#REGION_ID#" style="clear:both;">#BODY#</div>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5234999592412471 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Navigation Region, Alternative 1',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 11,
  p_theme_class_id => 16,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => 'In Round Green Theme Navigation Region and Navigation Region, Alternative 1 are the identical');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5234999592412471 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_100_width
prompt  ......region template 5235302886412471
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t11ReportsRegion100Width" border="0" cellpadding="0" cellspacing="0" summary="" id="#REGION_ID#" width="100%">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</t';

t:=t||'able>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5235302886412471 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region 100% Width',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 11,
  p_theme_class_id => 13,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5235302886412471 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/list_region_with_icon_report
prompt  ......region template 5235616942412471
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11ListRegionwithIcon" id="htmldb#REGION_SEQUENCE_ID#" border="0" cellpadding="0" cellspacing="0" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody"><tabl';

t:=t||'e summary="" cellpadding="0" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_11/report.gif" alt="" /></td>'||chr(10)||
'<td valign="top">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
''||chr(10)||
'';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5235616942412471 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'List Region with Icon (Report)',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 11,
  p_theme_class_id => 29,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5235616942412471 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/hide_and_show_region
prompt  ......region template 5235903696412471
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11HideandShowRegion" border="0" cellpadding="0" cellspacing="0" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#<a style="margin-left:5px;" href="javascript:hideShow(''region#REGION_SEQUENCE_ID#'',''shIMG#REGION_SEQUENCE_ID#'',''#IMAGE_PREFIX#themes/theme_11/t11showhide_hidden.gif'',''#IMAGE_PREFIX#themes/theme_11/t11showhide_show.gif'');" clas';

t:=t||'s="htmldbHideShowMinLink"><img src="#IMAGE_PREFIX#themes/theme_11/t11showhide_hidden.gif" '||chr(10)||
'  id="shIMG#REGION_SEQUENCE_ID#" alt="" /></a></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody"><div class="t11Hide" id="region#REGION_SEQUENCE_ID#"><div class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</div><div style="padding:10px">#BODY#';

t:=t||'</div></div></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5235903696412471 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Hide and Show Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 11,
  p_theme_class_id => 1,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5235903696412471 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/region_without_title
prompt  ......region template 5236217579412471
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11RegionwithoutTitle" border="0" cellpadding="0" cellspacing="0" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">&nbsp;</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5236217579412471 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Region without Title',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 11,
  p_theme_class_id => 11,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5236217579412471 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/chart_region
prompt  ......region template 5236500141412474
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11ChartRegion" border="0" id="#REGION_ID#" cellpadding="0" cellspacing="0">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5236500141412474 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Chart Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 11,
  p_theme_class_id => 30,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5236500141412474 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region
prompt  ......region template 5236812041412474
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table class="t11ReportsRegion" border="0" cellpadding="0" cellspacing="0" summary="" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5236812041412474 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 11,
  p_theme_class_id => 9,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5236812041412474 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/wizard_region_with_icon
prompt  ......region template 5237118808412474
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table border="0" cellpadding="0" cellspacing="0" class="t11WizardRegionwithIcon" id="#REGION_ID#" summary="">'||chr(10)||
'<tbody>'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader"><img src="#IMAGE_PREFIX#themes/theme_11/t11corner-wiz-tl.gif" width="15" height="15"  alt="" />#TITLE#</td>'||chr(10)||
'<td align="right" valign="top" class="t11RegionHeader"><img src="#IMAGE_PREFIX#themes/theme_11/t11corner-wiz-tr.gi';

t:=t||'f" width="15" height="15"  alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td colspan="2" class="t11RegionBody"><table summary="" cellpadding="0" cellspacing="0" border="0">'||chr(10)||
'<tr>'||chr(10)||
'<td valign="top"><img src="#IMAGE_PREFIX#themes/theme_11/t11iconwizard.gif" alt="" />';

t:=t||'</td>'||chr(10)||
'<td width="100%" valign="top">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="bottom" class="t11RegionFooter"><img src="#IMAGE_PREFIX#themes/theme_11/t11corner-wiz-bl.gif" width="15" height="15"  alt="" /></td>'||chr(10)||
'<td align="right" valign="bottom" class="t11RegionFooter"><img src="#IMAGE_PREFIX#themes/theme_11/t11corner-wiz-br.gif" width="15" height="15"  alt="" /></td>'||chr(10)||
'</tr';

t:=t||'>'||chr(10)||
'</tbody>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5237118808412474 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Wizard Region with Icon',
  p_plug_table_bgcolor     => '',
  p_theme_id  => 11,
  p_theme_class_id => 20,
  p_plug_heading_bgcolor => '',
  p_plug_font_size => '',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5237118808412474 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/sidebar_region_alternative_1
prompt  ......region template 5237403084412474
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table border="0" cellpadding="0" cellspacing="0" class="t11SidebarRegionAlternative1" id="#REGION_ID#" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5237403084412474 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Sidebar Region, Alternative 1',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 11,
  p_theme_class_id => 3,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5237403084412474 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/borderless_region
prompt  ......region template 5237701050412474
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11BorderlessRegion" border="0" cellpadding="0" cellspacing="0" id="#REGION_ID#">'||chr(10)||
'<tr>'||chr(10)||
'<td align="left" valign="top" class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5237701050412474 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Borderless Region',
  p_plug_table_bgcolor     => '#f7f7e7',
  p_theme_id  => 11,
  p_theme_class_id => 7,
  p_plug_heading_bgcolor => '#f7f7e7',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => 'Red Theme');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5237701050412474 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/region/reports_region_alternative_1
prompt  ......region template 5238017261412474
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_length number := 1;
begin
t:=t||'<table summary="" class="t11ReportsRegionAlternative1" id="#REGION_ID#" border="0" cellpadding="0" cellspacing="0">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionHeader">#TITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11ButtonHolder">#CLOSE#&nbsp;&nbsp;&nbsp;#PREVIOUS##NEXT##DELETE##EDIT##CHANGE##CREATE##CREATE2##EXPAND##COPY##HELP#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11RegionBody">#BODY#</td>'||chr(10)||
'</tr>'||chr(10)||
'</table>              ';

t2 := null;
wwv_flow_api.create_plug_template (
  p_id       => 5238017261412474 + wwv_flow_api.g_id_offset,
  p_flow_id  => wwv_flow.g_flow_id,
  p_template => t,
  p_page_plug_template_name=> 'Reports Region, Alternative 1',
  p_plug_table_bgcolor     => '#ffffff',
  p_theme_id  => 11,
  p_theme_class_id => 10,
  p_plug_heading_bgcolor => '#ffffff',
  p_plug_font_size => '-1',
  p_translate_this_template => 'N',
  p_template_comment       => '');
end;
null;
 
end;
/

 
begin
 
declare
    t2 varchar2(32767) := null;
begin
t2 := null;
wwv_flow_api.set_plug_template_tab_attr (
  p_id=> 5238017261412474 + wwv_flow_api.g_id_offset,
  p_form_table_attr=> t2 );
exception when others then null;
end;
null;
 
end;
/

prompt  ...List Templates
--
--application/shared_components/user_interface/templates/list/button_list
prompt  ......list template 4252477437114044
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t20Button t20current">#TEXT#</a>';

t2:=t2||'<a href="#LINK#" class="t20Button">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4252477437114044 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Button List',
  p_theme_id  => 20,
  p_theme_class_id => 6,
  p_list_template_before_rows=>'<div class="t20ButtonList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/hierarchical_expanded
prompt  ......list template 4252781063114049
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>4252781063114049 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Hierarchical Expanded',
  p_theme_id  => 20,
  p_theme_class_id => 23,
  p_list_template_before_rows=>'<ul class="htmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/hierarchical_expanding
prompt  ......list template 4253075414114049
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif"  align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>4253075414114049 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Hierarchical Expanding',
  p_theme_id  => 20,
  p_theme_class_id => 22,
  p_list_template_before_rows=>'<ul class="dhtmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" style="display:none;" class="dhtmlTree">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_images_with_label_list
prompt  ......list template 4253390054114049
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<td class="t20current"><img src="#IMAGE_PREFIX##IMAGE#" border="0" #IMAGE_ATTR#/><br />#TEXT#</td>';

t2:=t2||'<td><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" border="0" #IMAGE_ATTR#/></a><br /><a href="#LINK#">#TEXT#</a></td>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4253390054114049 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Images with Label List',
  p_theme_id  => 20,
  p_theme_class_id => 4,
  p_list_template_before_rows=>'<table class="t20HorizontalImageswithLabelList" cellpadding="0" border="0" cellspacing="0" summary=""><tr>',
  p_list_template_after_rows=>'</tr></table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_links_list
prompt  ......list template 4253680491114051
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t20current">#TEXT#</a>';

t2:=t2||'<a href="#LINK#">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4253680491114051 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Links List',
  p_theme_id  => 20,
  p_theme_class_id => 3,
  p_list_template_before_rows=>'<div class="t20HorizontalLinksList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/pull_down_menu
prompt  ......list template 4253977125114051
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li class="dhtmlMenuSep2"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt="" class="dhtmlMenuSep2" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" /></li>';

t6:=t6||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" /></li>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>4253977125114051 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Pull Down Menu',
  p_theme_id  => 20,
  p_theme_class_id => 20,
  p_list_template_before_rows=>'<ul class="dhtmlMenuLG2">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/pull_down_menu_with_image
prompt  ......list template 4254263302114052
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down.png" width="20" height="128" alt="" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t2:=t2||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down.png" width="20" height="128" alt=""  /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t3:=t3||'<li class="dhtmlMenuSep"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt=""  class="dhtmlMenuSep" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down.png" width="20" height="128" alt=""  class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t6:=t6||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#menu/drop_down.png" width="20" height="128" alt=""  class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>4254263302114052 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Pull Down Menu with Image',
  p_theme_id  => 20,
  p_theme_class_id => 21,
  p_list_template_before_rows=>'<div class="dhtmlMenuLG">',
  p_list_template_after_rows=>'</div><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;"><li class="dhtmlSubMenuP" onmouseover="dhtml_CloseAllSubMenusL(this)">#PARENT_TEXT#</li>',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/pull_down_menu_with_image_custom_1
prompt  ......list template 4254570072114053
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_nochild.gif" width="22" height="75" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t2:=t2||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_nochild.gif" width="22" height="75" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t3:=t3||'<li class="dhtmlMenuSep"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt=""  class="dhtmlMenuSep" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_open.gif" width="22" height="75" class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t6:=t6||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_open.gif" width="22" height="75" class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>4254570072114053 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Pull Down Menu with Image (Custom 1)',
  p_theme_id  => 20,
  p_theme_class_id => 9,
  p_list_template_before_rows=>'<div class="dhtmlMenuLG">',
  p_list_template_after_rows=>'</div><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;"><li class="dhtmlSubMenuP" onmouseover="dhtml_CloseAllSubMenusL(this)">#PARENT_TEXT#</li>',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/tab_list_custom_3
prompt  ......list template 4254867321114053
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="current">#TEXT#</a>';

t2:=t2||'<a href="#LINK#">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4254867321114053 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Tab List (Custom 3)',
  p_theme_id  => 20,
  p_theme_class_id => 11,
  p_list_template_before_rows=>'<div id="t20tablist">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'This list matches the child tabs on the Two Level Tab templates.'||chr(10)||
'Use in region position 8 of One Level Tabs (Custom 5) and/or One Level Tabs Sidebar (Custom 6).');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/tabbed_navigation_list
prompt  ......list template 4255159606114054
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<td><img src="#IMAGE_PREFIX#themes/theme_20/topTabL.gif" /></td>'||chr(10)||
'<td class="t20CurrentTab"><a href="#LINK#">#TEXT#</a></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/topTabR.gif" /></td>'||chr(10)||
'<td>&nbsp;</td>';

t2:=t2||'<td><img src="#IMAGE_PREFIX#themes/theme_20/topDimTabL.gif" /></td>'||chr(10)||
'<td class="t20Tab"><a href="#LINK#">#TEXT#</a></td>'||chr(10)||
'<td><img src="#IMAGE_PREFIX#themes/theme_20/topDimTabR.gif" /></td>'||chr(10)||
'<td>&nbsp;</td>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4255159606114054 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Tabbed Navigation List',
  p_theme_id  => 20,
  p_theme_class_id => 7,
  p_list_template_before_rows=>'<table class="t20Tabs t20TabbedNavigationList" border="0" cellpadding="0" cellspacing="0" summary=""><tr>',
  p_list_template_after_rows=>'</tr></table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_images_list
prompt  ......list template 4255482590114054
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<tr><td class="t20current"><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# />#TEXT#</a></td></tr>';

t2:=t2||'<tr><td><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# />#TEXT#</a></td></tr>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4255482590114054 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Images List',
  p_theme_id  => 20,
  p_theme_class_id => 5,
  p_list_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="" class="t20VerticalImagesList">',
  p_list_template_after_rows=>'</table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_images_list_custom_2
prompt  ......list template 4255786503114055
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<tr><td align="left"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# /></td><td align="left"><a href="#LINK#">#TEXT#</a></td></tr>'||chr(10)||
'';

t2:=t2||'<tr><td align="left"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# /></td><td align="left"><a href="#LINK#">#TEXT#</a></td></tr>'||chr(10)||
'';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4255786503114055 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Images List (Custom 2)',
  p_theme_id  => 20,
  p_theme_class_id => 10,
  p_list_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="5" summary="" >',
  p_list_template_after_rows=>'</table>'||chr(10)||
'',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_ordered_list
prompt  ......list template 4256068359114055
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t20current"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4256068359114055 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Ordered List',
  p_theme_id  => 20,
  p_theme_class_id => 2,
  p_list_template_before_rows=>'<ol class="t20VerticalOrderedList">',
  p_list_template_after_rows=>'</ol>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_sidebar_list
prompt  ......list template 4256371867114056
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="current">#TEXT#</a>';

t2:=t2||'<a href="#LINK#">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4256371867114056 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Sidebar List',
  p_theme_id  => 20,
  p_theme_class_id => 19,
  p_list_template_before_rows=>'<div class="t20VerticalSidebarList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_links_without_bullets
prompt  ......list template 4256680961114056
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t20current"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4256680961114056 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered Links without Bullets',
  p_theme_id  => 20,
  p_theme_class_id => 18,
  p_list_template_before_rows=>'<ul class="t20VerticalUnorderedLinkswithoutBullets">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_list_with_bullets
prompt  ......list template 4256977378114056
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t20current"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4256977378114056 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered List with Bullets',
  p_theme_id  => 20,
  p_theme_class_id => 1,
  p_list_template_before_rows=>'<ul class="t20VerticalUnorderedListwithBullets">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/wizard_progress_list
prompt  ......list template 4257285686114056
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="t20current">#TEXT#</div>';

t2:=t2||'<div>#TEXT#</div>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>4257285686114056 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Wizard Progress List',
  p_theme_id  => 20,
  p_theme_class_id => 17,
  p_list_template_before_rows=>'<div class="t20WizardProgressList">',
  p_list_template_after_rows=>'<center>&DONE.</center>'||chr(10)||
'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/dhtml_list_image_with_sublist
prompt  ......list template 5185204473808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# / alt=""></a><img src="#IMAGE_PREFIX#themes/generic_nochild.gif" width="22" height="75" alt="" / ><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t2:=t2||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# alt="" / ></a><img src="#IMAGE_PREFIX#themes/generic_nochild.gif" width="22" height="75" alt="" / ><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t3:=t3||'<li class="dhtmlMenuSep"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt=""  class="dhtmlMenuSep" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# alt="" / ></a><img src="#IMAGE_PREFIX#themes/generic_open.gif" width="22" height="75" class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" alt="" / ><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t6:=t6||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# alt="" / ></a><img src="#IMAGE_PREFIX#themes/generic_open.gif" width="22" height="75" class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" alt="" / ><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif"  alt="" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" alt="" / ></a></li>';

wwv_flow_api.create_list_template (
  p_id=>5185204473808416 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'DHTML List (Image) with Sublist',
  p_theme_id  => 1,
  p_theme_class_id => 21,
  p_list_template_before_rows=>'<div class="dhtmlMenuLG">',
  p_list_template_after_rows=>'</div><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;"><li class="dhtmlSubMenuP" onmouseover="dhtml_CloseAllSubMenusL(this)">#PARENT_TEXT#</li>',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/dhtml_menu_with_sublist
prompt  ......list template 5185314545808416
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li class="dhtmlMenuSep2"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt="" class="dhtmlMenuSep2" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" /></li>';

t6:=t6||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" /></li>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" alt="" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" alt="" / ></a></li>';

wwv_flow_api.create_list_template (
  p_id=>5185314545808416 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'DHTML Menu with Sublist',
  p_theme_id  => 1,
  p_theme_class_id => 20,
  p_list_template_before_rows=>'<ul class="dhtmlMenuLG2">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/dhtml_tree
prompt  ......list template 5185393327808418
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif"  align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" alt="" /><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>5185393327808418 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'DHTML Tree',
  p_theme_id  => 1,
  p_theme_class_id => 22,
  p_list_template_before_rows=>'<ul class="dhtmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" style="display:none;" class="dhtmlTree">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/wizard_progress_list
prompt  ......list template 5185513163808418
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<tr><td><div class="t1current">#TEXT#</div><img src="#IMAGE_PREFIX#themes/theme_1/arrow_down.gif" alt="Down" /></td></tr>';

t2:=t2||'<tr><td><div>#TEXT#</div><img src="#IMAGE_PREFIX#themes/theme_1/arrow_down.gif" alt="Down" /></td></tr>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5185513163808418 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Wizard Progress List',
  p_theme_id  => 1,
  p_theme_class_id => 17,
  p_list_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" class="t1WizardProgressList">',
  p_list_template_after_rows=>'<tr><td>&DONE.</td></tr>'||chr(10)||
'</table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_ordered_list
prompt  ......list template 5185600210808418
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t1current">#TEXT#</li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5185600210808418 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Ordered List',
  p_theme_id  => 1,
  p_theme_class_id => 2,
  p_list_template_before_rows=>'<ol class="t1VerticalOrderedList">',
  p_list_template_after_rows=>'</ol>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/button_list
prompt  ......list template 5185703487808418
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<table class="t1ButtonList" cellspacing="0" cellpadding="0" border="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1L"><img src="#IMAGE_PREFIX#/themes/theme_1/list_button_left_hl.gif" alt="" /></td>'||chr(10)||
'<td class="t1C"><a href="#LINK#" style="color:#FFFFFF;">#TEXT#</a></td>'||chr(10)||
'<td class="t1R"><img src="#IMAGE_PREFIX#/themes/theme_1/list_button_right_hl.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t2:=t2||'<table class="t1ButtonList" cellspacing="0" cellpadding="0" border="0" summary="">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1L"><img src="#IMAGE_PREFIX#/themes/theme_1/list_button_left.gif" alt="" /></td>'||chr(10)||
'<td class="t1NC"><a href="#LINK#">#TEXT#</a></td>'||chr(10)||
'<td class="t1R"><img src="#IMAGE_PREFIX#/themes/theme_1/list_button_right.gif" alt="" /></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5185703487808418 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Button List',
  p_theme_id  => 1,
  p_theme_class_id => 6,
  p_list_template_before_rows=>'<div class="t1ButtonList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_links_list
prompt  ......list template 5185812932808419
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t1current">#TEXT#</a>';

t2:=t2||'<a href="#LINK#">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5185812932808419 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Links List',
  p_theme_id  => 1,
  p_theme_class_id => 3,
  p_list_template_before_rows=>'<div class="t1HorizontalLinksList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_images_list
prompt  ......list template 5185913149808419
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<tr><td class="t1current"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# alt="" / >#TEXT#</td></tr>';

t2:=t2||'<tr><td><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# alt="" / >#TEXT#</a></td></tr>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5185913149808419 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Images List',
  p_theme_id  => 1,
  p_theme_class_id => 5,
  p_list_template_before_rows=>'<table cellpadding="0" cellspacing="0" border="0" summary="0" class="t1VerticalImagesList">',
  p_list_template_after_rows=>'</table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_sidebar_list
prompt  ......list template 5186009857808419
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<a href="#LINK#" class="t1navcurrent">#TEXT#</a>';

t2:=t2||'<a href="#LINK#" class="t1nav">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5186009857808419 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Sidebar List',
  p_theme_id  => 1,
  p_theme_class_id => 19,
  p_list_template_before_rows=>'<div class="t1VerticalSidebarList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_list_without_bullet
prompt  ......list template 5186105331808419
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t1current">#TEXT#</li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5186105331808419 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered List without Bullet',
  p_theme_id  => 1,
  p_theme_class_id => 18,
  p_list_template_before_rows=>'<ul class="t1VerticalUnorderedListwithoutBullet">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_list_with_bullets
prompt  ......list template 5186209469808419
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t1current">#TEXT#</li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5186209469808419 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered List with Bullets',
  p_theme_id  => 1,
  p_theme_class_id => 1,
  p_list_template_before_rows=>'<ul class="t1VerticalUnorderedListwithBullets">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/tabbed_navigation_list
prompt  ......list template 5186318471808419
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><a class="t1current" href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5186318471808419 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Tabbed Navigation List',
  p_theme_id  => 1,
  p_theme_class_id => 7,
  p_list_template_before_rows=>'<ul class="t1TabbedNavigationList">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/hierarchical_expanded
prompt  ......list template 5186406077808419
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>5186406077808419 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Hierarchical Expanded',
  p_theme_id  => 1,
  p_theme_class_id => 23,
  p_list_template_before_rows=>'<ul class="dhtmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_images_with_label_list
prompt  ......list template 5186496927808419
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<td class="t1current"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# alt="" / ><br />#TEXT#</td>';

t2:=t2||'<td><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# alt="" / ></a><br /><a href="#LINK#">#TEXT#</a></td>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5186496927808419 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Images with Label List',
  p_theme_id  => 1,
  p_theme_class_id => 4,
  p_list_template_before_rows=>'<table cellspacing="0" cellpadding="0" border="0" class="t1HorizontalImageswithLabelList" summary=""><tr>',
  p_list_template_after_rows=>'</tr></table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_images_with_label_list
prompt  ......list template 5238307141412474
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<td class="t11current"><img src="#IMAGE_PREFIX##IMAGE#" border="0" #IMAGE_ATTR#/><br />#TEXT#</td>';

t2:=t2||'<td><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" border="0" #IMAGE_ATTR#/></a><br /><a href="#LINK#">#TEXT#</a></td>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5238307141412474 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Images with Label List',
  p_theme_id  => 11,
  p_theme_class_id => 4,
  p_list_template_before_rows=>'<table class="t11HorizontalImageswithLabelList" summary=""><tr>',
  p_list_template_after_rows=>'</tr></table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_ordered_list
prompt  ......list template 5238599316412474
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t11current">#TEXT#</li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5238599316412474 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Ordered List',
  p_theme_id  => 11,
  p_theme_class_id => 2,
  p_list_template_before_rows=>'<ol class="t11VerticalOrderedList">',
  p_list_template_after_rows=>'</ol>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/horizontal_links_list
prompt  ......list template 5238909185412474
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<span class="t11current">#TEXT#</span>';

t2:=t2||'<a href="#LINK#">#TEXT#</a>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5238909185412474 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Horizontal Links List',
  p_theme_id  => 11,
  p_theme_class_id => 3,
  p_list_template_before_rows=>'<div class="t11HorizontalLinksList">',
  p_list_template_after_rows=>'</div>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/dhtml_list_image_with_sublist
prompt  ......list template 5239197008412474
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_nochild.gif" width="22" height="75" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t2:=t2||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_nochild.gif" width="22" height="75" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t3:=t3||'<li class="dhtmlMenuSep"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt=""  class="dhtmlMenuSep" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_open.gif" width="22" height="75" class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t6:=t6||'<div class="dhtmlMenuItem"><a href="#LINK#"><img src="#IMAGE_PREFIX#themes/generic_list.gif" #IMAGE_ATTR# /></a><img src="#IMAGE_PREFIX#themes/generic_open.gif" width="22" height="75" class="dhtmlMenu" onclick="app_AppMenuMultiOpenBottom(this,''#LIST_ITEM_ID#'',false)" /><a href="#LINK#" class="dhtmlBottom">#TEXT#</a></div>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>5239197008412474 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'DHTML List (Image) with Sublist',
  p_theme_id  => 11,
  p_theme_class_id => 21,
  p_list_template_before_rows=>'<div class="dhtmlMenuLG">',
  p_list_template_after_rows=>'</div><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;"><li class="dhtmlSubMenuP" onmouseover="dhtml_CloseAllSubMenusL(this)">#PARENT_TEXT#</li>',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_list_with_bullets
prompt  ......list template 5239487217412475
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t11current">#TEXT#</li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5239487217412475 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered List with Bullets',
  p_theme_id  => 11,
  p_theme_class_id => 1,
  p_list_template_before_rows=>'<ul class="t11VerticalUnorderedListwithBullets">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/tree_list
prompt  ......list template 5239787861412475
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>5239787861412475 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Tree List',
  p_theme_id  => 11,
  p_theme_class_id => 23,
  p_list_template_before_rows=>'<ul class="htmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/wizard_progress_list
prompt  ......list template 5240106987412475
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<tr><td><div class="t11current">#TEXT#</div><img src="#IMAGE_PREFIX#themes/theme_11/t11arrowdown01.gif" alt="Down" /></td></tr>';

t2:=t2||'<tr><td><div>#TEXT#</div><img src="#IMAGE_PREFIX#themes/theme_11/t11arrowdown01.gif" alt="Down" /></td></tr>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5240106987412475 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Wizard Progress List',
  p_theme_id  => 11,
  p_theme_class_id => 17,
  p_list_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="" class="t11WizardProgressList">',
  p_list_template_after_rows=>'<tr><td>&DONE.</td></tr>'||chr(10)||
'</table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_unordered_links_without_bullets
prompt  ......list template 5240390129412475
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="t11current">#TEXT#</li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5240390129412475 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Unordered Links without Bullets',
  p_theme_id  => 11,
  p_theme_class_id => 18,
  p_list_template_before_rows=>'<ul class="t11VerticalUnorderedListwithoutBullets">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/dhtml_tree
prompt  ......list template 5240717123412475
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif" align="middle"  alt="" /><a href="#LINK#">#TEXT#</a></li>';

t4:=t4||'<li><img src="#IMAGE_PREFIX#themes/theme_13/node.gif"  align="middle" alt="" /><a href="#LINK#">#TEXT#</a></li>';

t5:=t5||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t6:=t6||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" align="middle"  onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t7:=t7||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

t8:=t8||'<li><img src="#IMAGE_PREFIX#themes/theme_13/plus.gif" onclick="htmldb_ToggleWithImage(this,''#LIST_ITEM_ID#'')" align="middle" class="pseudoButtonInactive" /><a href="#LINK#">#TEXT#</a></li>';

wwv_flow_api.create_list_template (
  p_id=>5240717123412475 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'DHTML Tree',
  p_theme_id  => 11,
  p_theme_class_id => 22,
  p_list_template_before_rows=>'<ul class="dhtmlTree">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" style="display:none;" class="dhtmlTree">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/dhtml_menu_with_sublist
prompt  ......list template 5241010803412475
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t2:=t2||'<li class="dhtmlMenuItem"><a href="#LINK#">#TEXT#</a></li>';

t3:=t3||'<li class="dhtmlMenuSep2"><img src="#IMAGE_PREFIX#themes/theme_13/1px_trans.gif"  width="1" height="1" alt="" class="dhtmlMenuSep2" /></li>';

t4:=t4||'<li><a href="#LINK#" class="dhtmlSubMenuN" onmouseover="dhtml_CloseAllSubMenusL(this)">#TEXT#</a></li>';

t5:=t5||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" /></li>';

t6:=t6||'<li class="dhtmlMenuItem1"><a href="#LINK#">#TEXT#</a><img src="#IMAGE_PREFIX#themes/theme_13/menu_small.gif" alt="Expand" onclick="app_AppMenuMultiOpenBottom2(this,''#LIST_ITEM_ID#'',false)" /></li>';

t7:=t7||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

t8:=t8||'<li class="dhtmlSubMenuS"><a href="#LINK#" class="dhtmlSubMenuS" onmouseover="dhtml_MenuOpen(this,''#LIST_ITEM_ID#'',true,''Left'')"><span style="float:left;">#TEXT#</span><img class="t13MIMG" src="#IMAGE_PREFIX#menu_open_right2.gif" /></a></li>';

wwv_flow_api.create_list_template (
  p_id=>5241010803412475 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'DHTML Menu with Sublist',
  p_theme_id  => 11,
  p_theme_class_id => 20,
  p_list_template_before_rows=>'<ul class="dhtmlMenuLG2">',
  p_list_template_after_rows=>'</ul><br style="clear:both;"/><br style="clear:both;"/>',
  p_before_sub_list=>'<ul id="#PARENT_LIST_ITEM_ID#" htmldb:listlevel="#LEVEL#" class="dhtmlSubMenu2" style="display:none;">',
  p_after_sub_list=>'</ul>',
  p_sub_list_item_current=> t3,
  p_sub_list_item_noncurrent=> t4,
  p_item_templ_curr_w_child=> t5,
  p_item_templ_noncurr_w_child=> t6,
  p_sub_templ_curr_w_child=> t7,
  p_sub_templ_noncurr_w_child=> t8,
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_sidebar_list
prompt  ......list template 5241316051412475
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<tr><td align="right" valign="middle" class="t11current">#TEXT#</td></tr>';

t2:=t2||'<tr><td align="right" valign="middle"><a href="#LINK#" class="t11nav">#TEXT#</a></td></tr>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5241316051412475 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Sidebar List',
  p_theme_id  => 11,
  p_theme_class_id => 19,
  p_list_template_before_rows=>'<table border="0" cellspacing="0" cellpadding="0" summary="" width="100%" class="t11VerticalSidebarList">',
  p_list_template_after_rows=>'<tr><td><img src="#IMAGE_PREFIX#themes/theme_11/1px_trans.gif" height="1" width="100" alt="" style="display:block;" /></td></tr>'||chr(10)||
'</table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/tabbed_navigation_list
prompt  ......list template 5241613822412477
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<li><a href="#LINK#" class="t11current">#TEXT#</a></li>';

t2:=t2||'<li><a href="#LINK#">#TEXT#</a></li>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5241613822412477 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Tabbed Navigation List',
  p_theme_id  => 11,
  p_theme_class_id => 7,
  p_list_template_before_rows=>'<ul class="t11TabbedNavigationList">',
  p_list_template_after_rows=>'</ul>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/button_list
prompt  ......list template 5241911112412477
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<td><table cellpadding="0" cellspacing="0" border="0" summary="" class="t11Button" align="right">'||chr(10)||
'<tr>'||chr(10)||
'<td align="right" valign="top" class="t11R"><img src="#IMAGE_PREFIX#themes/theme_11/t11btn1_corner_tl.gif" width="8" height="16" /></td>'||chr(10)||
'<td class="t11C"><a href="#LINK#" class="t11C">#TEXT#</a></td>'||chr(10)||
'<td align="right" valign="top" class="t11L"><span class="t11R"><img src="#IMAGE_PREFIX#themes/the';

t:=t||'me_11/t11btn1_corner_tr.gif" width="8" height="16" /></span></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>';

t2:=t2||'<td><table cellpadding="0" cellspacing="0" border="0" summary="" class="t11ButtonAlternative1" align="right">'||chr(10)||
'<tr>'||chr(10)||
'<td align="right" valign="top" class="t11R"><img src="#IMAGE_PREFIX#themes/theme_11/t11btn2_corner_tl.gif" width="8" height="16" /></td>'||chr(10)||
'<td class="t11C"><a href="#LINK#" class="t11C">#TEXT#</a></td>'||chr(10)||
'<td align="right" valign="top" class="t11L"><span class="t11R"><img src="#IMAGE_PREFI';

t2:=t2||'X#themes/theme_11/t11btn2_corner_tr.gif" width="8" height="16" /></span></td>'||chr(10)||
'</tr>'||chr(10)||
'</table></td>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5241911112412477 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Button List',
  p_theme_id  => 11,
  p_theme_class_id => 6,
  p_list_template_before_rows=>'<table border="0" cellspacing="0" cellpadding="0" summary="" class="t11ButtonList"><tr>',
  p_list_template_after_rows=>'</tr></table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/list/vertical_images_list
prompt  ......list template 5242188277412477
 
begin
 
declare
  t varchar2(32767) := null;
  t2 varchar2(32767) := null;
  t3 varchar2(32767) := null;
  t4 varchar2(32767) := null;
  t5 varchar2(32767) := null;
  t6 varchar2(32767) := null;
  t7 varchar2(32767) := null;
  t8 varchar2(32767) := null;
  l_clob clob;
  l_clob2 clob;
  l_clob3 clob;
  l_clob4 clob;
  l_clob5 clob;
  l_clob6 clob;
  l_clob7 clob;
  l_clob8 clob;
  l_length number := 1;
begin
t:=t||'<tr><td class="t11current"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# />#TEXT#</td></tr>';

t2:=t2||'<tr><td><a href="#LINK#"><img src="#IMAGE_PREFIX##IMAGE#" #IMAGE_ATTR# />#TEXT#</a></td></tr>';

t3 := null;
t4 := null;
t5 := null;
t6 := null;
t7 := null;
t8 := null;
wwv_flow_api.create_list_template (
  p_id=>5242188277412477 + wwv_flow_api.g_id_offset,
  p_flow_id=>wwv_flow.g_flow_id,
  p_list_template_current=>t,
  p_list_template_noncurrent=> t2,
  p_list_template_name=>'Vertical Images List',
  p_theme_id  => 11,
  p_theme_class_id => 5,
  p_list_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="" class="t11VerticalImagesList">',
  p_list_template_after_rows=>'</table>',
  p_translate_this_template => 'N',
  p_list_template_comment=>'');
end;
null;
 
end;
/

prompt  ...report templates
--
--application/shared_components/user_interface/templates/report/horizantal_folder_list
prompt  ......report template 3292071765678588
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<TD>#COLUMN_VALUE#</TD>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 3292071765678588 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'HORIZANTAL_FOLDER_LIST',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<TABLE><TR>',
  p_row_template_after_rows =>'</TR></TABLE>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_theme_id  => 20,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 3292071765678588 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>' ',
  p_row_template_after_last =>' ');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/borderless
prompt  ......report template 4257588663114057
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t20data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4257588663114057 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Borderless',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" class="t20Report" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table class="t20Borderless t20Report" cellpadding="0" border="0" cellspacing="0" summary="">',
  p_row_template_after_rows =>'</table><div class="t20CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>'||chr(10)||
'',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t20ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t20pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t20pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 20,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4257588663114057 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/horizontal_border
prompt  ......report template 4258084941114060
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t20data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4258084941114060 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Horizontal Border',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" class="t20Report" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table class="t20HorizontalBorder t20Report" border="0" cellpadding="0" cellspacing="0" summary="">',
  p_row_template_after_rows =>'</table><div class="t20CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t20ReportHeader"  id="#COLUMN_HEADER_NAME#" #ALIGNMENT#>#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t20pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t20pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 20,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4258084941114060 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/one_column_unordered_list
prompt  ......report template 4258585097114060
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'#COLUMN_VALUE#';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4258585097114060 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'One Column Unordered List',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">'||chr(10)||
'#TOP_PAGINATION#<tr><td><ul class="t20OneColumnUnorderedList">',
  p_row_template_after_rows =>'</ul><div class="t20CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t20pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t20pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 20,
  p_theme_class_id => 3,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4258585097114060 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<li>',
  p_row_template_after_last =>'</li>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard
prompt  ......report template 4259062755114060
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td #ALIGNMENT# headers="#COLUMN_HEADER#" class="t20data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4259062755114060 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="" class="t20Report" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table cellpadding="0" border="0" cellspacing="0" summary="" class="t20Report t20Standard">',
  p_row_template_after_rows =>'</table><div class="t20CVS">#CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t20ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t20pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t20pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 20,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4259062755114060 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard_ppr
prompt  ......report template 4259568347114062
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td #ALIGNMENT# headers="#COLUMN_HEADER#" class="t20data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4259568347114062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard (PPR)',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<div id="report#REGION_ID#"><htmldb:#REGION_ID#><table cellpadding="0" border="0" cellspacing="0" summary="" class="t20Report" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table cellpadding="0" border="0" cellspacing="0" summary="" class="t20Standard t20Report">',
  p_row_template_after_rows =>'</table><div class="t20CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table><script language=JavaScript type=text/javascript>'||chr(10)||
'<!--'||chr(10)||
'init_htmlPPRReport(''#REGION_ID#'');'||chr(10)||
''||chr(10)||
'//-->'||chr(10)||
'</script>'||chr(10)||
'</htmldb:#REGION_ID#>'||chr(10)||
'</div>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t20ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t20pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t20pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t20pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t20pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 20,
  p_theme_class_id => 7,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4259568347114062 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard_alternating_row_colors
prompt  ......report template 4260076976114062
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t20data">#COLUMN_VALUE#</td>';

c2:=c2||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t20dataalt">#COLUMN_VALUE#</td>';

c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4260076976114062 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard, Alternating Row Colors',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="" class="t20Report" #REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table border="0" cellpadding="0" cellspacing="0" summary="" class="t20StandardAlternatingRowColors t20Report">',
  p_row_template_after_rows =>'</table><div class="t20CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t20ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'ODD_ROW_NUMBERS',
  p_row_template_display_cond2=>'NOT_CONDITIONAL',
  p_row_template_display_cond3=>'NOT_CONDITIONAL',
  p_row_template_display_cond4=>'ODD_ROW_NUMBERS',
  p_next_page_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t20pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t20pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 20,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4260076976114062 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/value_attribute_pairs
prompt  ......report template 4260568153114063
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<tr>'||chr(10)||
'<th class="t20ReportHeader">#COLUMN_HEADER#</th>'||chr(10)||
'<td class="t20data">#COLUMN_VALUE#</td>'||chr(10)||
'</tr>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 4260568153114063 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Value Attribute Pairs',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" cellspacing="0" border="0" summary=""#REPORT_ATTRIBUTES# id="report_#REGION_STATIC_ID#">#TOP_PAGINATION#<tr><td><table cellpadding="0" cellspacing="0" border="0" summary="" class="t20ValueAttributePairs">',
  p_row_template_after_rows =>'</table><div class="t20CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT# &gt;</a>',
  p_previous_page_template=>'<a href="#LINK#" class="t20pagination">&lt;#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t20pagination">#PAGINATION_NEXT_SET#&gt;&gt;</a>',
  p_previous_set_template=>'<a href="#LINK#" class="t20pagination">&lt;&lt;#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 20,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 4260568153114063 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'',
  p_row_template_after_last =>'<tr><td colspan="2" class="t20seperate"><br /></td></tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/one_column_unordered_list
prompt  ......report template 5186605978808419
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<li>#COLUMN_VALUE#</li>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5186605978808419 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'One Column Unordered List',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'#TOP_PAGINATION#'||chr(10)||
'<tr><td><ul class="t1OneColumnUnorderedList">',
  p_row_template_after_rows =>'</ul><div class="t1CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'NOT_CONDITIONAL',
  p_row_template_display_cond2=>'NOT_CONDITIONAL',
  p_row_template_display_cond3=>'NOT_CONDITIONAL',
  p_row_template_display_cond4=>'NOT_CONDITIONAL',
  p_next_page_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_page_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 1,
  p_theme_class_id => 3,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5186605978808419 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'OMIT',
  p_row_template_after_last =>'OMIT');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard
prompt  ......report template 5186693710808419
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="t1data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5186693710808419 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="">#TOP_PAGINATION#'||chr(10)||
'<tr>'||chr(10)||
'<td><table cellpadding="0" border="0" cellspacing="0" summary="" class="t1standard">',
  p_row_template_after_rows =>'</table><div class="t1CVS">#EXTERNAL_LINK##CSV_LINK#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th#ALIGNMENT# id="#COLUMN_HEADER_NAME#" class="t1header">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_page_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 1,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5186693710808419 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard_alternating_row_colors
prompt  ......report template 5186809332808419
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td class="t1data"#ALIGNMENT#>#COLUMN_VALUE#</td>';

c2:=c2||'<td class="t1dataalt"#ALIGNMENT#>#COLUMN_VALUE#</td>';

c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5186809332808419 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard, Alternating Row Colors',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="">'||chr(10)||
'#TOP_PAGINATION#'||chr(10)||
'<tr><td><table border="0" cellpadding="0" cellspacing="0" summary="" class="t1standardalternatingrowcolors">',
  p_row_template_after_rows =>'</table><div class="t1CVS">#EXTERNAL_LINK##CSV_LINK#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t1header"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'ODD_ROW_NUMBERS',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'ODD_ROW_NUMBERS',
  p_next_page_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>'||chr(10)||
'',
  p_previous_page_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 1,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard_ppr
prompt  ......report template 5186918204808419
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="t1data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5186918204808419 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard (PPR)',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<div id="report#REGION_ID#"><htmldb:#REGION_ID#><table cellpadding="0" border="0" cellspacing="0" summary="">#TOP_PAGINATION#'||chr(10)||
'<tr>'||chr(10)||
'<td><table cellpadding="0" border="0" cellspacing="0" summary="" class="t1standard">',
  p_row_template_after_rows =>'</table><div class="t1CVS">#EXTERNAL_LINK##CSV_LINK#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>'||chr(10)||
'<script language=JavaScript type=text/javascript>'||chr(10)||
'<!--'||chr(10)||
'init_htmlPPRReport(''#REGION_ID#'');'||chr(10)||
''||chr(10)||
'//-->'||chr(10)||
'</script>'||chr(10)||
'</htmldb:#REGION_ID#>'||chr(10)||
'</div>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th#ALIGNMENT# id="#COLUMN_HEADER_NAME#" class="t1header">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')"  class="t1pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')"  class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')"  class="t1pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')"  class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 1,
  p_theme_class_id => 7,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5186918204808419 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/horizontal_border
prompt  ......report template 5186990910808419
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="t1data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5186990910808419 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Horizontal Border',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="">#TOP_PAGINATION#'||chr(10)||
'<tr>'||chr(10)||
'<td><table cellpadding="0" cellspacing="0" border="0" class="t1HorizontalBorder" summary="">',
  p_row_template_after_rows =>'</table><div class="t1CVS">#EXTERNAL_LINK##CSV_LINK#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th#ALIGNMENT# id="#COLUMN_HEADER_NAME#" class="t1header">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>'||chr(10)||
'',
  p_previous_page_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 1,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5186990910808419 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/value_attribute_pairs
prompt  ......report template 5187092005808421
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<tr><th class="t1header">#COLUMN_HEADER#</th><td class="t1data">#COLUMN_VALUE#</td></tr>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5187092005808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Value Attribute Pairs',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="">'||chr(10)||
'#TOP_PAGINATION#'||chr(10)||
'<tr><td><table cellpadding="0" cellspacing="0" border="0" summary="" class="t1ValueAttributePairs">',
  p_row_template_after_rows =>'</table><div class="t1CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_page_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 1,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5187092005808421 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'OMIT',
  p_row_template_after_last =>'<tr><td colspan="2" class="t1seperate"><hr /></td></tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/borderless
prompt  ......report template 5187201071808421
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td#ALIGNMENT# headers="#COLUMN_HEADER_NAME#" class="t1data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5187201071808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Borderless',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="">'||chr(10)||
'#TOP_PAGINATION#'||chr(10)||
'<tr>'||chr(10)||
'<td><table class="t1borderless" cellpadding="0" border="0" cellspacing="0" summary="">',
  p_row_template_after_rows =>'</table><div class="t1CVS">#EXTERNAL_LINK##CSV_LINK#</div></td>'||chr(10)||
'</tr>'||chr(10)||
'#PAGINATION#'||chr(10)||
'</table>',
  p_row_template_table_attr =>'',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t1header"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_page_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t1pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_1/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t1pagination"><img src="#IMAGE_PREFIX#themes/theme_1/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#CCCCCC',
  p_theme_id  => 1,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5187201071808421 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/borderless
prompt  ......report template 5242505663412477
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t11data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5242505663412477 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Borderless',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table class="t11Borderless" cellpadding="0" border="0" cellspacing="0" summary="">',
  p_row_template_after_rows =>'</table><div class="t11CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>'||chr(10)||
'',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t11ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next"></a>',
  p_previous_page_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous">#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#c5d5c5',
  p_theme_id  => 11,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5242505663412477 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard_alternating_row_colors
prompt  ......report template 5243018822412479
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t11data">#COLUMN_VALUE#</td>';

c2:=c2||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t11dataalt">#COLUMN_VALUE#</td>';

c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5243018822412479 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard, Alternating Row Colors',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table border="0" cellpadding="0" cellspacing="0" summary="" class="t11StandardAlternatingRowColors">',
  p_row_template_after_rows =>'</table><div class="t11CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t11ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'ODD_ROW_NUMBERS',
  p_row_template_display_cond2=>'NOT_CONDITIONAL',
  p_row_template_display_cond3=>'NOT_CONDITIONAL',
  p_row_template_display_cond4=>'ODD_ROW_NUMBERS',
  p_next_page_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next"></a>',
  p_previous_page_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#c5d5c5',
  p_theme_id  => 11,
  p_theme_class_id => 5,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5243018822412479 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/horizontal_border
prompt  ......report template 5243512208412479
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td headers="#COLUMN_HEADER_NAME#" #ALIGNMENT# class="t11data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5243512208412479 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Horizontal Border',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table class="t11HorizontalBorder" border="0" cellpadding="0" cellspacing="0" summary="">',
  p_row_template_after_rows =>'</table><div class="t11CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t11ReportHeader"  id="#COLUMN_HEADER_NAME#" #ALIGNMENT#>#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next" /></a>',
  p_previous_page_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next" /></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#c5d5c5',
  p_theme_id  => 11,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5243512208412479 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/value_attribute_pairs
prompt  ......report template 5244012746412479
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<tr>'||chr(10)||
'<th class="t11ReportHeader">#COLUMN_HEADER#</th>'||chr(10)||
'<td class="t11data">#COLUMN_VALUE#</td>'||chr(10)||
'</tr>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5244012746412479 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Value Attribute Pairs',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" cellspacing="0" border="0" summary="">'||chr(10)||
'#TOP_PAGINATION#'||chr(10)||
'<tr>'||chr(10)||
'<td><table cellpadding="0" cellspacing="0" border="0" summary="" class="t11ValueAttributePairs">',
  p_row_template_after_rows =>'</table><div class="t11CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'OMIT',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next"></a>',
  p_previous_page_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 11,
  p_theme_class_id => 6,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5244012746412479 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'OMIT',
  p_row_template_after_last =>'<tr><td colspan="2" class="t11seperate"><hr /></td></tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard
prompt  ......report template 5244500832412479
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td #ALIGNMENT# headers="#COLUMN_HEADER#" class="t11data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5244500832412479 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table cellpadding="0" border="0" cellspacing="0" summary="">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table cellpadding="0" border="0" cellspacing="0" summary="" class="t11Standard">',
  p_row_template_after_rows =>'</table><div class="t11CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t11ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next"></a>',
  p_previous_page_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#c5d5c5',
  p_theme_id  => 11,
  p_theme_class_id => 4,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5244500832412479 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/one_column_unordered_list
prompt  ......report template 5244997218412480
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<li>#COLUMN_VALUE#</li>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5244997218412480 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'One Column Unordered List',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<table border="0" cellpadding="0" cellspacing="0" summary="">'||chr(10)||
'#TOP_PAGINATION#<tr><td><ul class="t11OneColumnUnorderedList">',
  p_row_template_after_rows =>'</ul><div class="t11CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'OMIT',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next" /></a>',
  p_previous_page_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="#LINK#" class="t11pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next" /></a>',
  p_previous_set_template=>'<a href="#LINK#" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS_SET#</a>',
  p_theme_id  => 11,
  p_theme_class_id => 3,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5244997218412480 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'OMIT',
  p_row_template_after_last =>'OMIT');
exception when others then null;
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/report/standard_ppr
prompt  ......report template 5245502283412480
 
begin
 
declare
  c1 varchar2(32767) := null;
  c2 varchar2(32767) := null;
  c3 varchar2(32767) := null;
  c4 varchar2(32767) := null;
begin
c1:=c1||'<td #ALIGNMENT# headers="#COLUMN_HEADER#" class="t11data">#COLUMN_VALUE#</td>';

c2 := null;
c3 := null;
c4 := null;
wwv_flow_api.create_row_template (
  p_id=> 5245502283412480 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_row_template_name=> 'Standard (PPR)',
  p_row_template1=> c1,
  p_row_template_condition1=> '',
  p_row_template2=> c2,
  p_row_template_condition2=> '',
  p_row_template3=> c3,
  p_row_template_condition3=> '',
  p_row_template4=> c4,
  p_row_template_condition4=> '',
  p_row_template_before_rows=>'<div id="report#REGION_ID#"><htmldb:#REGION_ID#><table cellpadding="0" border="0" cellspacing="0" summary="">#TOP_PAGINATION#'||chr(10)||
'<tr><td><table cellpadding="0" border="0" cellspacing="0" summary="" class="t11Standard">',
  p_row_template_after_rows =>'</table><div class="t11CVS">#EXTERNAL_LINK##CSV_LINK#</div></td></tr>#PAGINATION#</table><script language=JavaScript type=text/javascript>'||chr(10)||
'<!--'||chr(10)||
'init_htmlPPRReport(''#REGION_ID#'');'||chr(10)||
''||chr(10)||
'//-->'||chr(10)||
'</script>'||chr(10)||
'</htmldb:#REGION_ID#>'||chr(10)||
'</div>',
  p_row_template_table_attr =>'OMIT',
  p_row_template_type =>'GENERIC_COLUMNS',
  p_column_heading_template=>'<th class="t11ReportHeader"#ALIGNMENT# id="#COLUMN_HEADER_NAME#">#COLUMN_HEADER#</th>',
  p_row_template_display_cond1=>'0',
  p_row_template_display_cond2=>'0',
  p_row_template_display_cond3=>'0',
  p_row_template_display_cond4=>'0',
  p_next_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t11pagination">#PAGINATION_NEXT#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next"></a>',
  p_previous_page_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS#</a>',
  p_next_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t11pagination">#PAGINATION_NEXT_SET#<img src="#IMAGE_PREFIX#themes/theme_11/paginate_next.gif" alt="Next"></a>',
  p_previous_set_template=>'<a href="javascript:html_PPR_Report_Page(this,''#REGION_ID#'',''#LINK#'')" class="t11pagination"><img src="#IMAGE_PREFIX#themes/theme_11/paginate_prev.gif" alt="Previous" />#PAGINATION_PREVIOUS_SET#</a>',
  p_row_style_checked=>'#c5d5c5',
  p_theme_id  => 11,
  p_theme_class_id => 7,
  p_translate_this_template => 'N',
  p_row_template_comment=> '');
end;
null;
 
end;
/

 
begin
 
begin
wwv_flow_api.create_row_template_patch (
  p_id => 5245502283412480 + wwv_flow_api.g_id_offset,
  p_row_template_before_first =>'<tr #HIGHLIGHT_ROW#>',
  p_row_template_after_last =>'</tr>');
exception when others then null;
end;
null;
 
end;
/

prompt  ...label templates
--
--application/shared_components/user_interface/templates/label/no_label
prompt  ......label template 4261074088114064
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 4261074088114064 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'No Label',
  p_template_body1=>'<span class="t20NoLabel">',
  p_template_body2=>'</span>',
  p_on_error_before_label=>'<div class="t20InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 20,
  p_theme_class_id => 13,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional_label
prompt  ......label template 4261163507114065
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 4261163507114065 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional Label',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><span class="t20OptionalLabel">',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'<div class="t20InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 20,
  p_theme_class_id => 3,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional_label_with_help
prompt  ......label template 4261285833114065
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 4261285833114065 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional Label with Help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><a class="t20OptionalLabelwithHelp" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'')" tabindex="999">',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'<div class="t20InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 20,
  p_theme_class_id => 1,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required_label
prompt  ......label template 4261373880114065
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 4261373880114065 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required Label',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><span class="t20Req">*</span><span class="t20RequiredLabel">',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'<div class="t20InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 20,
  p_theme_class_id => 4,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required_label_with_help
prompt  ......label template 4261486737114065
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 4261486737114065 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required Label with Help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><span class="t20Req">*</span><a class="t20RequiredLabelwithHelp" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'')" tabindex="999">',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'<div class="t20InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 20,
  p_theme_class_id => 2,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional_with_help
prompt  ......label template 5187289094808421
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 5187289094808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional with help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><a class="t1OptionalwithHelp" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'')" tabindex="999">',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'<div class="t1InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 1,
  p_theme_class_id => 1,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/no_label
prompt  ......label template 5187414774808421
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 5187414774808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'No Label',
  p_template_body1=>'<span class="t1NoLabel">',
  p_template_body2=>'</span>',
  p_on_error_before_label=>'<div class="t1InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 1,
  p_theme_class_id => 13,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional
prompt  ......label template 5187512202808421
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 5187512202808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><span class="t1Optional">',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'<div class="t1InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 1,
  p_theme_class_id => 3,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required_with_help
prompt  ......label template 5187605955808421
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 5187605955808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required with help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><img src="#IMAGE_PREFIX#themes/theme_1/required.gif" alt="Required Field Icon" tabindex="999" /><a class="t1RequiredwithHelp" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'')" tabindex="999">',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'<div class="t1InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 1,
  p_theme_class_id => 2,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required
prompt  ......label template 5187697818808421
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 5187697818808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#" tabindex="999"><img src="#IMAGE_PREFIX#themes/theme_1/required.gif" alt="Required Field Icon" tabindex="999" /><span class="t1Required">',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'<div class="t1InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 1,
  p_theme_class_id => 4,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional_label
prompt  ......label template 5246017183412480
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 5246017183412480 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional Label',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#"><span class="t11OptionalLabel">',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'<div class="t11InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 11,
  p_theme_class_id => 3,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required_label_with_help
prompt  ......label template 5246103756412480
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 5246103756412480 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required Label with Help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#"><img src="#IMAGE_PREFIX#themes/theme_11/required.gif" alt="Required" style="margin-right:5px;"/><a class="t11RequiredLabelwithHelp" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'')" tabindex="999">',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'<div class="t11InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 11,
  p_theme_class_id => 2,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/optional_label_with_help
prompt  ......label template 5246200224412480
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 5246200224412480 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Optional Label with Help',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#"><a class="t11OptionalLabelwithHelp" href="javascript:popupFieldHelp(''#CURRENT_ITEM_ID#'',''&SESSION.'')" tabindex="999">',
  p_template_body2=>'</a></label>',
  p_on_error_before_label=>'<div class="t11InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 11,
  p_theme_class_id => 1,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/required_label
prompt  ......label template 5246318629412480
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 5246318629412480 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'Required Label',
  p_template_body1=>'<label for="#CURRENT_ITEM_NAME#"><img src="#IMAGE_PREFIX#themes/theme_11/required.gif" alt=""  style="margin-right:5px;"/><span class="t11RequiredLabel">',
  p_template_body2=>'</span></label>',
  p_on_error_before_label=>'<div class="t11InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 11,
  p_theme_class_id => 4,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/label/no_label
prompt  ......label template 5246391648412480
 
begin
 
begin
wwv_flow_api.create_field_template (
  p_id=> 5246391648412480 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_template_name=>'No Label',
  p_template_body1=>'<span class="t11NoLabel">',
  p_template_body2=>'</span>',
  p_on_error_before_label=>'<div class="t11InlineError">',
  p_on_error_after_label=>'<br/>#ERROR_MESSAGE#</div>',
  p_theme_id  => 11,
  p_theme_class_id => 13,
  p_translate_this_template=> 'N',
  p_template_comment=> '');
end;
null;
 
end;
/

prompt  ...breadcrumb templates
--
--application/shared_components/user_interface/templates/breadcrumb/breadcrumb_menu
prompt  ......template 4261581807114066
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 4261581807114066 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Breadcrumb Menu',
  p_before_first=>'',
  p_current_page_option=>'<a href="#LINK#" class="t20Current">#NAME#</a>',
  p_non_current_page_option=>'<a href="#LINK#">#NAME#</a>',
  p_menu_link_attributes=>'',
  p_between_levels=>'<b>&gt;</b>',
  p_after_last=>'',
  p_max_levels=>12,
  p_start_with_node=>'PARENT_TO_LEAF',
  p_theme_id  => 20,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/breadcrumb/hierarchical_menu
prompt  ......template 4261679684114068
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 4261679684114068 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Hierarchical Menu',
  p_before_first=>'<ul class="t20HierarchicalMenu">',
  p_current_page_option=>'<li class="t20current"><a href="#LINK#">#NAME#</a></li>',
  p_non_current_page_option=>'<li><a href="#LINK#">#NAME#</a></li>',
  p_menu_link_attributes=>'',
  p_between_levels=>'',
  p_after_last=>'</ul>',
  p_max_levels=>11,
  p_start_with_node=>'CHILD_MENU',
  p_theme_id  => 20,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/breadcrumb/hierarchical_menu
prompt  ......template 5187804743808421
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 5187804743808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Hierarchical Menu',
  p_before_first=>'<ul class="t1HierarchicalMenu">',
  p_current_page_option=>'<li class="t1current">#NAME#</li>',
  p_non_current_page_option=>'<li><a href="#LINK#">#NAME#</a></li>',
  p_menu_link_attributes=>'',
  p_between_levels=>'',
  p_after_last=>'</ul>',
  p_max_levels=>11,
  p_start_with_node=>'CHILD_MENU',
  p_theme_id  => 1,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/breadcrumb/breadcrumb_menu
prompt  ......template 5187913502808421
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 5187913502808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Breadcrumb Menu',
  p_before_first=>'<div class="t1BreadcrumbMenu">',
  p_current_page_option=>'<span class="t1current">#NAME#</span>',
  p_non_current_page_option=>'<a href="#LINK#">#NAME#</a>',
  p_menu_link_attributes=>'',
  p_between_levels=>'&nbsp;&gt;&nbsp;',
  p_after_last=>'</div>',
  p_max_levels=>12,
  p_start_with_node=>'PARENT_TO_LEAF',
  p_theme_id  => 1,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/breadcrumb/breadcrumb_menu
prompt  ......template 5246514426412480
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 5246514426412480 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Breadcrumb Menu',
  p_before_first=>'<div class="t11BreadcrumbMenu" style="color:#91C58D">',
  p_current_page_option=>'<a href="#LINK#" class="t11current">#NAME#</a>',
  p_non_current_page_option=>'<a href="#LINK#" style="text-decoration:underline;">#NAME#</a>',
  p_menu_link_attributes=>'',
  p_between_levels=>'&nbsp;&gt;&nbsp;',
  p_after_last=>'</div>',
  p_max_levels=>12,
  p_start_with_node=>'PARENT_TO_LEAF',
  p_theme_id  => 11,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/breadcrumb/hierarchical_menu
prompt  ......template 5246603440412482
 
begin
 
begin
wwv_flow_api.create_menu_template (
  p_id=> 5246603440412482 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=>'Hierarchical Menu',
  p_before_first=>'<ul class="t4HierarchicalMenu">',
  p_current_page_option=>'<li class="t4current"><a href="#LINK#">#NAME#</a></li>',
  p_non_current_page_option=>'<li><a href="#LINK#">#NAME#</a></li>',
  p_menu_link_attributes=>'',
  p_between_levels=>'',
  p_after_last=>'</ul>',
  p_max_levels=>11,
  p_start_with_node=>'CHILD_MENU',
  p_theme_id  => 11,
  p_theme_class_id => 2,
  p_translate_this_template => 'N',
  p_template_comments=>'');
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/popuplov
prompt  ...popup list of values templates
--
prompt  ......template 4262372804114072
 
begin
 
begin
wwv_flow_api.create_popup_lov_template (
  p_id=> 4262372804114072 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_popup_icon=>'#IMAGE_PREFIX#lov_16x16.gif',
  p_popup_icon_attr=>'width="16" height="16" alt="Popup Lov"',
  p_popup_icon2=>'',
  p_popup_icon_attr2=>'',
  p_page_name=>'winlov',
  p_page_title=>'Search Dialog',
  p_page_html_head=>'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_20/theme_3_1.css" type="text/css">'||chr(10)||
'',
  p_page_body_attr=>'onload="first_field()" style="background-color:#FFFFFF;margin:0;"',
  p_before_field_text=>'<div class="t20PopupHead">',
  p_page_heading_text=>'',
  p_page_footer_text =>'',
  p_filter_width     =>'20',
  p_filter_max_width =>'100',
  p_filter_text_attr =>'',
  p_find_button_text =>'Search',
  p_find_button_image=>'',
  p_find_button_attr =>'',
  p_close_button_text=>'Close',
  p_close_button_image=>'',
  p_close_button_attr=>'',
  p_next_button_text =>'Next >',
  p_next_button_image=>'',
  p_next_button_attr =>'',
  p_prev_button_text =>'< Previous',
  p_prev_button_image=>'',
  p_prev_button_attr =>'',
  p_after_field_text=>'</div>',
  p_scrollbars=>'1',
  p_resizable=>'1',
  p_width =>'400',
  p_height=>'450',
  p_result_row_x_of_y=>'<br /><div style="padding:2px; font-size:8pt;">Row(s) #FIRST_ROW# - #LAST_ROW#</div>',
  p_result_rows_per_pg=>500,
  p_before_result_set=>'<div class="t20PopupBody">',
  p_theme_id  => 20,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_after_result_set   =>'</div>');
end;
null;
 
end;
/

prompt  ......template 5188592497808422
 
begin
 
begin
wwv_flow_api.create_popup_lov_template (
  p_id=> 5188592497808422 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_popup_icon=>'#IMAGE_PREFIX#list_gray.gif',
  p_popup_icon_attr=>'width="13" height="13" alt="Popup Lov"',
  p_popup_icon2=>'',
  p_popup_icon_attr2=>'',
  p_page_name=>'winlov',
  p_page_title=>'Search Dialog',
  p_page_html_head=>'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_1/theme_V2.css" type="text/css">'||chr(10)||
'',
  p_page_body_attr=>'onload="first_field()" style="margin:0;"',
  p_before_field_text=>'<div class="t1PopupHead">',
  p_page_heading_text=>'',
  p_page_footer_text =>'',
  p_filter_width     =>'20',
  p_filter_max_width =>'100',
  p_filter_text_attr =>'',
  p_find_button_text =>'Search',
  p_find_button_image=>'',
  p_find_button_attr =>'',
  p_close_button_text=>'Close',
  p_close_button_image=>'',
  p_close_button_attr=>'',
  p_next_button_text =>'Next >',
  p_next_button_image=>'',
  p_next_button_attr =>'',
  p_prev_button_text =>'< Previous',
  p_prev_button_image=>'',
  p_prev_button_attr =>'',
  p_after_field_text=>'</div>',
  p_scrollbars=>'1',
  p_resizable=>'1',
  p_width =>'400',
  p_height=>'450',
  p_result_row_x_of_y=>'<br /><div style="padding:2px; font-size:8pt;">Row(s) #FIRST_ROW# - #LAST_ROW#</div>',
  p_result_rows_per_pg=>500,
  p_before_result_set=>'<div class="t1PopupBody">',
  p_theme_id  => 1,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_after_result_set   =>'</div>');
end;
null;
 
end;
/

prompt  ......template 5247288967412483
 
begin
 
begin
wwv_flow_api.create_popup_lov_template (
  p_id=> 5247288967412483 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_popup_icon=>'#IMAGE_PREFIX#list_gray.gif',
  p_popup_icon_attr=>'width="13" height="13" alt="Popup Lov"',
  p_popup_icon2=>'',
  p_popup_icon_attr2=>'',
  p_page_name=>'winlov',
  p_page_title=>'Search Dialog',
  p_page_html_head=>'<link rel="stylesheet" href="#IMAGE_PREFIX#themes/theme_11/theme_V2.css" type="text/css" />'||chr(10)||
'',
  p_page_body_attr=>'onload="first_field()" style="margin:0px;"',
  p_before_field_text=>'<div class="t11PopupHead">',
  p_page_heading_text=>'',
  p_page_footer_text =>'',
  p_filter_width     =>'20',
  p_filter_max_width =>'100',
  p_filter_text_attr =>'',
  p_find_button_text =>'Search',
  p_find_button_image=>'',
  p_find_button_attr =>'',
  p_close_button_text=>'Close',
  p_close_button_image=>'',
  p_close_button_attr=>'',
  p_next_button_text =>'Next >',
  p_next_button_image=>'',
  p_next_button_attr =>'',
  p_prev_button_text =>'< Previous',
  p_prev_button_image=>'',
  p_prev_button_attr =>'',
  p_after_field_text=>'</div>',
  p_scrollbars=>'1',
  p_resizable=>'1',
  p_width =>'400',
  p_height=>'450',
  p_result_row_x_of_y=>'<br /><div style="padding:2px; font-size:8pt;">Row(s) #FIRST_ROW# - #LAST_ROW#</div>',
  p_result_rows_per_pg=>500,
  p_before_result_set=>'<div class="t11PopupBody">',
  p_theme_id  => 11,
  p_theme_class_id => 1,
  p_translate_this_template => 'N',
  p_after_result_set   =>'</div>');
end;
null;
 
end;
/

prompt  ...calendar templates
--
--application/shared_components/user_interface/templates/calendar/calendar
prompt  ......template 4261778973114068
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 4261778973114068 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar',
  p_translate_this_template=> 'Y',
  p_day_of_week_format=> '<th class="t20DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t20CalendarAlternative1Holder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t20MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td class="t20MonthBody">',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t20CalendarAlternative1">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t20DayTitle">#DD#</div><br />',
  p_day_open_format=> '<td class="t20Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t20Today">',
  p_weekend_title_format=> '<div class="t20WeekendDayTitle">#DD#</div><br />',
  p_weekend_open_format => '<td valign="top" class="t20WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t20NonDayTitle">#DD#</div><br />',
  p_nonday_open_format => '<td class="t20NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '',
  p_weekly_day_of_week_format => '',
  p_weekly_month_open_format => '',
  p_weekly_month_close_format => '',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '',
  p_weekly_day_close_format => '',
  p_weekly_today_open_format => '',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '',
  p_weekly_weekend_close_format => '',
  p_weekly_time_open_format => '',
  p_weekly_time_close_format => '',
  p_weekly_time_title_format => '',
  p_weekly_hour_open_format => '',
  p_weekly_hour_close_format => '',
  p_daily_day_of_week_format => '',
  p_daily_month_title_format => '',
  p_daily_month_open_format => '',
  p_daily_month_close_format => '',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '',
  p_daily_day_close_format => '',
  p_daily_today_open_format => '',
  p_daily_time_open_format => '',
  p_daily_time_close_format => '',
  p_daily_time_title_format => '',
  p_daily_hour_open_format => '',
  p_daily_hour_close_format => '',
  p_theme_id  => 20,
  p_theme_class_id => 1,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/calendar_alternative_1
prompt  ......template 4261960564114070
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 4261960564114070 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar, Alternative 1',
  p_translate_this_template=> 'Y',
  p_day_of_week_format=> '<th class="t20DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t20CalendarHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t20MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td class="t20MonthBody">',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t20Calendar">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t20DayTitle">#DD#</div><br />',
  p_day_open_format=> '<td class="t20Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t20Today">',
  p_weekend_title_format=> '<div class="t20WeekendDayTitle">#DD#</div><br />',
  p_weekend_open_format => '<td valign="top" class="t20WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t20NonDayTitle">#DD#</div><br />',
  p_nonday_open_format => '<td class="t20NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '',
  p_weekly_day_of_week_format => '',
  p_weekly_month_open_format => '',
  p_weekly_month_close_format => '',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '',
  p_weekly_day_close_format => '',
  p_weekly_today_open_format => '',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '',
  p_weekly_weekend_close_format => '',
  p_weekly_time_open_format => '',
  p_weekly_time_close_format => '',
  p_weekly_time_title_format => '',
  p_weekly_hour_open_format => '',
  p_weekly_hour_close_format => '',
  p_daily_day_of_week_format => '',
  p_daily_month_title_format => '',
  p_daily_month_open_format => '',
  p_daily_month_close_format => '',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '',
  p_daily_day_close_format => '',
  p_daily_today_open_format => '',
  p_daily_time_open_format => '',
  p_daily_time_close_format => '',
  p_daily_time_title_format => '',
  p_daily_hour_open_format => '',
  p_daily_hour_close_format => '',
  p_theme_id  => 20,
  p_theme_class_id => 2,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/small_calender
prompt  ......template 4262166116114071
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 4262166116114071 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Small Calender',
  p_translate_this_template=> 'Y',
  p_day_of_week_format=> '',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t20SmallCalenderHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t20MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td class="t20MonthBody">',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t20SmallCalender">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t20DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t20Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t20Today">',
  p_weekend_title_format=> '<div class="t20WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t20WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t20NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t20NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '',
  p_weekly_day_of_week_format => '',
  p_weekly_month_open_format => '',
  p_weekly_month_close_format => '',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '',
  p_weekly_day_close_format => '',
  p_weekly_today_open_format => '',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '',
  p_weekly_weekend_close_format => '',
  p_weekly_time_open_format => '',
  p_weekly_time_close_format => '',
  p_weekly_time_title_format => '',
  p_weekly_hour_open_format => '',
  p_weekly_hour_close_format => '',
  p_daily_day_of_week_format => '',
  p_daily_month_title_format => '',
  p_daily_month_open_format => '',
  p_daily_month_close_format => '',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '',
  p_daily_day_close_format => '',
  p_daily_today_open_format => '',
  p_daily_time_open_format => '',
  p_daily_time_close_format => '',
  p_daily_time_title_format => '',
  p_daily_hour_open_format => '',
  p_daily_hour_close_format => '',
  p_theme_id  => 20,
  p_theme_class_id => 3,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/small_calendar
prompt  ......template 5188002105808421
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 5188002105808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Small Calendar',
  p_translate_this_template=> 'Y',
  p_day_of_week_format=> '<th class="t1DayOfWeek">#DY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1SmallCalendarHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t1MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="1" summary="" class="t1SmallCalendar">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>',
  p_day_title_format=> '<div class="t1DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t1Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t1Today">',
  p_weekend_title_format=> '<div class="t1WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t1WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t1NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t1NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1DayCalendarHolder"> <tr> <td class="t1MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr> <tr> <td>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1SmallWeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t1DayOfWeek">#IDAY#<br />#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="1" summary="0" class="t1SmallWeekCalendar">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t1Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t1Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t1NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t1Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t1DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1SmallDayCalendarHolder"> <tr> <td class="t1MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr><tr><td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="1" summary="0" class="t1SmallDayCalendar">',
  p_daily_month_close_format => '</table></td></tr></table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t1Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t1Today">',
  p_daily_time_open_format => '<th class="t1Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 1,
  p_theme_class_id => 3,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/calendar
prompt  ......template 5188212989808421
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 5188212989808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar',
  p_translate_this_template=> 'Y',
  p_day_of_week_format=> '<th class="t1DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1CalendarHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t1MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t1Calendar">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t1DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t1Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t1Today">',
  p_weekend_title_format=> '<div class="t1WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t1WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t1NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t1NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1DayCalendarHolder"> <tr> <td class="t1MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr> <tr> <td>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1WeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t1DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t1WeekCalendar">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t1Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t1Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t1NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t1Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t1DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1DayCalendarHolder"> <tr> <td class="t1MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr> <tr> <td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="0" summary="0" class="t1DayCalendar">',
  p_daily_month_close_format => '</table></td> </tr> </table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t1Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t1Today">',
  p_daily_time_open_format => '<th class="t1Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 1,
  p_theme_class_id => 1,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/calendar_alternative_1
prompt  ......template 5188390144808421
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 5188390144808421 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar, Alternative 1',
  p_translate_this_template=> 'Y',
  p_day_of_week_format=> '<th valign="bottom" class="t1DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1CalendarAlternative1Holder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t1MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="2" summary="0" class="t1CalendarAlternative1">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t1DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t1Day" valign="top" height="100" height="100">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t1Today">',
  p_weekend_title_format=> '<div class="t1WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t1WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t1NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t1NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1DayCalendarHolder"> <tr> <td class="t1MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr> <tr> <td>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1WeekCalendarAlternative1Holder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t1MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t1DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="2" summary="0" class="t1WeekCalendarAlternative1">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t1Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t1Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t1NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t1Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t1DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t1DayCalendarAlternative1Holder"> <tr><td class="t1MonthTitle">#IMONTH# #DD#, #YYYY#</td></tr><tr><td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="2" summary="0" class="t1DayCalendarAlternative1">',
  p_daily_month_close_format => '</table></td> </tr> </table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t1Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t1Today">',
  p_daily_time_open_format => '<th class="t1Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 1,
  p_theme_class_id => 2,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/small_calendar
prompt  ......template 5246718942412482
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 5246718942412482 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Small Calendar',
  p_translate_this_template=> 'Y',
  p_day_of_week_format=> '',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t11SmallCalenderHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t11MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="1" summary="0" class="t11SmallCalender">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t11DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t11Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t11Today">',
  p_weekend_title_format=> '<div class="t11WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t11WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t11NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t11NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t11SmallWeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t11DayOfWeek">#IDAY#<br />#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t11SmallWeekCalendar">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t11Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t11Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t11NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t11Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t11DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t11SmallDayCalendarHolder"> <tr> <td class="t11MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr><tr><td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="0" summary="0" class="t11SmallDayCalendar">',
  p_daily_month_close_format => '</table></td></tr></table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t11Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t11Today">',
  p_daily_time_open_format => '<th class="t11Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 11,
  p_theme_class_id => 3,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/calendar_alternative_1
prompt  ......template 5246893694412483
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 5246893694412483 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar, Alternative 1',
  p_translate_this_template=> 'Y',
  p_day_of_week_format=> '<th class="t11DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t11CalendarAlternative1Holder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t11MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="2" summary="0" class="t11CalendarAlternative1">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t11DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t11Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t11Today">',
  p_weekend_title_format=> '<div class="t11WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t11WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t4NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t11NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t11WeekCalendarAlternative1Holder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t11DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t11WeekCalendarAlternative1">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t11Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t11Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t11NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t11Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t11DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t11DayCalendarAlternative1Holder"> <tr><td class="t11MonthTitle">#IMONTH# #DD#, #YYYY#</td></tr><tr><td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="0" summary="0" class="t11DayCalendarAlternative1">',
  p_daily_month_close_format => '</table></td> </tr> </table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t11Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t11Today">',
  p_daily_time_open_format => '<th class="t11Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 11,
  p_theme_class_id => 2,
  p_reference_id=> null);
end;
null;
 
end;
/

--application/shared_components/user_interface/templates/calendar/calendar
prompt  ......template 5247101614412483
 
begin
 
begin
wwv_flow_api.create_calendar_template(
  p_id=> 5247101614412483 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_cal_template_name=>'Calendar',
  p_translate_this_template=> 'Y',
  p_day_of_week_format=> '<th class="t11DayOfWeek">#IDAY#</th>',
  p_month_title_format=> '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t11CalendarHolder"> '||chr(10)||
' <tr>'||chr(10)||
'   <td class="t11MonthTitle">#IMONTH# #YYYY#</td>'||chr(10)||
' </tr>'||chr(10)||
' <tr>'||chr(10)||
' <td>',
  p_month_open_format=> '<table border="0" cellpadding="0" cellspacing="2" summary="0" class="t11Calendar">',
  p_month_close_format=> '</table></td>'||chr(10)||
'</tr>'||chr(10)||
'</table>'||chr(10)||
'',
  p_day_title_format=> '<div class="t11DayTitle">#DD#</div>',
  p_day_open_format=> '<td class="t11Day" valign="top">',
  p_day_close_format=> '</td>',
  p_today_open_format=> '<td valign="top" class="t11Today">',
  p_weekend_title_format=> '<div class="t11WeekendDayTitle">#DD#</div>',
  p_weekend_open_format => '<td valign="top" class="t11WeekendDay">',
  p_weekend_close_format => '</td>',
  p_nonday_title_format => '<div class="t11NonDayTitle">#DD#</div>',
  p_nonday_open_format => '<td class="t11NonDay" valign="top">',
  p_nonday_close_format => '</td>',
  p_week_title_format => '',
  p_week_open_format => '<tr>',
  p_week_close_format => '</tr> ',
  p_daily_title_format => '<th width="14%" class="calheader">#IDAY#</th>',
  p_daily_open_format => '<tr>',
  p_daily_close_format => '</tr>',
  p_weekly_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t11WeekCalendarHolder">'||chr(10)||
'<tr>'||chr(10)||
'<td class="t11MonthTitle" id="test">#WTITLE#</td>'||chr(10)||
'</tr>'||chr(10)||
'<tr>'||chr(10)||
'<td>',
  p_weekly_day_of_week_format => '<th class="t11DayOfWeek">#IDAY#<br>#MM#/#DD#</th>',
  p_weekly_month_open_format => '<table border="0" cellpadding="0" cellspacing="0" summary="0" class="t11WeekCalendar">',
  p_weekly_month_close_format => '</table></td></tr></table>',
  p_weekly_day_title_format => '',
  p_weekly_day_open_format => '<td class="t11Day" valign="top">',
  p_weekly_day_close_format => '<br /></td>',
  p_weekly_today_open_format => '<td class="t11Today" valign="top">',
  p_weekly_weekend_title_format => '',
  p_weekly_weekend_open_format => '<td valign="top" class="t11NonDay">',
  p_weekly_weekend_close_format => '<br /></td>',
  p_weekly_time_open_format => '<th class="t11Hour">',
  p_weekly_time_close_format => '<br /></th>',
  p_weekly_time_title_format => '#TIME#',
  p_weekly_hour_open_format => '<tr>',
  p_weekly_hour_close_format => '</tr>',
  p_daily_day_of_week_format => '<th class="t11DayOfWeek">#IDAY# #DD#/#MM#</th>',
  p_daily_month_title_format => '<table cellspacing="0" cellpadding="0" border="0" summary="" class="t11DayCalendarHolder"> <tr> <td class="t11MonthTitle">#IMONTH# #DD#, #YYYY#</td> </tr> <tr> <td>'||chr(10)||
'',
  p_daily_month_open_format => '<table border="0" cellpadding="2" cellspacing="0" summary="0" class="t11DayCalendar">',
  p_daily_month_close_format => '</table></td> </tr> </table>',
  p_daily_day_title_format => '',
  p_daily_day_open_format => '<td valign="top" class="t11Day">',
  p_daily_day_close_format => '<br /></td>',
  p_daily_today_open_format => '<td valign="top" class="t11Today">',
  p_daily_time_open_format => '<th class="t11Hour">',
  p_daily_time_close_format => '<br /></th>',
  p_daily_time_title_format => '#TIME#',
  p_daily_hour_open_format => '<tr>',
  p_daily_hour_close_format => '</tr>',
  p_theme_id  => 11,
  p_theme_class_id => 1,
  p_reference_id=> null);
end;
null;
 
end;
/

prompt  ...application themes
--
--application/shared_components/user_interface/themes/modern_blue
prompt  ......theme 4262567937114074
begin
wwv_flow_api.create_theme (
  p_id =>4262567937114074 + wwv_flow_api.g_id_offset,
  p_flow_id =>wwv_flow.g_flow_id,
  p_theme_id  => 20,
  p_theme_name=>'Modern Blue',
  p_default_page_template=>4241491426114026 + wwv_flow_api.g_id_offset,
  p_error_template=>4241491426114026 + wwv_flow_api.g_id_offset,
  p_printer_friendly_template=>4243590760114032 + wwv_flow_api.g_id_offset,
  p_breadcrumb_display_point=>'REGION_POSITION_01',
  p_sidebar_display_point=>'',
  p_login_template=>4240660257114010 + wwv_flow_api.g_id_offset,
  p_default_button_template=>4245073391114034 + wwv_flow_api.g_id_offset,
  p_default_region_template=>4250378089114043 + wwv_flow_api.g_id_offset,
  p_default_chart_template =>4247376159114039 + wwv_flow_api.g_id_offset,
  p_default_form_template  =>4247667412114039 + wwv_flow_api.g_id_offset,
  p_default_reportr_template   =>4250378089114043 + wwv_flow_api.g_id_offset,
  p_default_tabform_template=>4250378089114043 + wwv_flow_api.g_id_offset,
  p_default_wizard_template=>4251863043114044 + wwv_flow_api.g_id_offset,
  p_default_menur_template=>4246460268114039 + wwv_flow_api.g_id_offset,
  p_default_listr_template=>4250378089114043 + wwv_flow_api.g_id_offset,
  p_default_report_template   =>4259062755114060 + wwv_flow_api.g_id_offset,
  p_default_label_template=>4261285833114065 + wwv_flow_api.g_id_offset,
  p_default_menu_template=>4261581807114066 + wwv_flow_api.g_id_offset,
  p_default_calendar_template=>null + wwv_flow_api.g_id_offset,
  p_default_list_template=>4256977378114056 + wwv_flow_api.g_id_offset,
  p_default_option_label=>4261285833114065 + wwv_flow_api.g_id_offset,
  p_default_required_label=>4261486737114065 + wwv_flow_api.g_id_offset);
end;
/
 
--application/shared_components/user_interface/themes/red
prompt  ......theme 5188710206808422
begin
wwv_flow_api.create_theme (
  p_id =>5188710206808422 + wwv_flow_api.g_id_offset,
  p_flow_id =>wwv_flow.g_flow_id,
  p_theme_id  => 1,
  p_theme_name=>'Red',
  p_default_page_template=>5182398911808415 + wwv_flow_api.g_id_offset,
  p_error_template=>5182398911808415 + wwv_flow_api.g_id_offset,
  p_printer_friendly_template=>5182509498808415 + wwv_flow_api.g_id_offset,
  p_breadcrumb_display_point=>'REGION_POSITION_01',
  p_sidebar_display_point=>'REGION_POSITION_02',
  p_login_template=>5181813946808413 + wwv_flow_api.g_id_offset,
  p_default_button_template=>5182807341808415 + wwv_flow_api.g_id_offset,
  p_default_region_template=>5184893763808416 + wwv_flow_api.g_id_offset,
  p_default_chart_template =>5184490716808416 + wwv_flow_api.g_id_offset,
  p_default_form_template  =>5184202849808416 + wwv_flow_api.g_id_offset,
  p_default_reportr_template   =>5184893763808416 + wwv_flow_api.g_id_offset,
  p_default_tabform_template=>5184893763808416 + wwv_flow_api.g_id_offset,
  p_default_wizard_template=>5184709198808416 + wwv_flow_api.g_id_offset,
  p_default_menur_template=>5184994576808416 + wwv_flow_api.g_id_offset,
  p_default_listr_template=>5183200491808415 + wwv_flow_api.g_id_offset,
  p_default_report_template   =>5186693710808419 + wwv_flow_api.g_id_offset,
  p_default_label_template=>5187289094808421 + wwv_flow_api.g_id_offset,
  p_default_menu_template=>5187913502808421 + wwv_flow_api.g_id_offset,
  p_default_calendar_template=>5188212989808421 + wwv_flow_api.g_id_offset,
  p_default_list_template=>5186209469808419 + wwv_flow_api.g_id_offset,
  p_default_option_label=>5187289094808421 + wwv_flow_api.g_id_offset,
  p_default_required_label=>5187605955808421 + wwv_flow_api.g_id_offset);
end;
/
 
--application/shared_components/user_interface/themes/round_green
prompt  ......theme 5247493535412486
begin
wwv_flow_api.create_theme (
  p_id =>5247493535412486 + wwv_flow_api.g_id_offset,
  p_flow_id =>wwv_flow.g_flow_id,
  p_theme_id  => 11,
  p_theme_name=>'Round Green',
  p_default_page_template=>5228897156412463 + wwv_flow_api.g_id_offset,
  p_error_template=>5228897156412463 + wwv_flow_api.g_id_offset,
  p_printer_friendly_template=>5229403797412463 + wwv_flow_api.g_id_offset,
  p_breadcrumb_display_point=>'REGION_POSITION_01',
  p_sidebar_display_point=>'REGION_POSITION_02',
  p_login_template=>5229116427412463 + wwv_flow_api.g_id_offset,
  p_default_button_template=>5231586883412468 + wwv_flow_api.g_id_offset,
  p_default_region_template=>5236812041412474 + wwv_flow_api.g_id_offset,
  p_default_chart_template =>5236500141412474 + wwv_flow_api.g_id_offset,
  p_default_form_template  =>5232618431412469 + wwv_flow_api.g_id_offset,
  p_default_reportr_template   =>5236812041412474 + wwv_flow_api.g_id_offset,
  p_default_tabform_template=>5236812041412474 + wwv_flow_api.g_id_offset,
  p_default_wizard_template=>5234094764412469 + wwv_flow_api.g_id_offset,
  p_default_menur_template=>5233796153412469 + wwv_flow_api.g_id_offset,
  p_default_listr_template=>5236812041412474 + wwv_flow_api.g_id_offset,
  p_default_report_template   =>5244500832412479 + wwv_flow_api.g_id_offset,
  p_default_label_template=>5246200224412480 + wwv_flow_api.g_id_offset,
  p_default_menu_template=>5246514426412480 + wwv_flow_api.g_id_offset,
  p_default_calendar_template=>5247101614412483 + wwv_flow_api.g_id_offset,
  p_default_list_template=>5239487217412475 + wwv_flow_api.g_id_offset,
  p_default_option_label=>5246200224412480 + wwv_flow_api.g_id_offset,
  p_default_required_label=>5246103756412480 + wwv_flow_api.g_id_offset);
end;
/
 
prompt  ...build options used by application 102
--
 
begin
 
null;
 
end;
/

--application/shared_components/globalization/messages
prompt  ...messages used by application: 102
--
--application/shared_components/globalization/dyntranslations
prompt  ...dynamic translations used by application: 102
--
--application/shared_components/globalization/language
prompt  ...Language Maps for Application 102
--
 
begin
 
null;
 
end;
/

prompt  ...Shortcuts
--
prompt  ...web services (9iR2 or better)
--
prompt  ...shared queries
--
prompt  ...report layouts
--
prompt  ...authentication schemes
--
--application/shared_components/security/authentication/html_db
prompt  ......scheme 5188811089808429
 
begin
 
declare
  s1 varchar2(32767) := null;
  s2 varchar2(32767) := null;
  s3 varchar2(32767) := null;
  s4 varchar2(32767) := null;
  s5 varchar2(32767) := null;
begin
s1 := null;
s2 := null;
s3 := null;
s4:=s4||'-BUILTIN-';

s5 := null;
wwv_flow_api.create_auth_setup (
  p_id=> 5188811089808429 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'HTML DB',
  p_description=>'Use internal Application Express account credentials and login page in this application.',
  p_page_sentry_function=> s1,
  p_sess_verify_function=> s2,
  p_pre_auth_process=> s3,
  p_auth_function=> s4,
  p_post_auth_process=> s5,
  p_invalid_session_page=>'101',
  p_invalid_session_url=>'',
  p_cookie_name=>'',
  p_cookie_path=>'',
  p_cookie_domain=>'',
  p_use_secure_cookie_yn=>'',
  p_ldap_host=>'',
  p_ldap_port=>'',
  p_ldap_string=>'',
  p_attribute_01=>'',
  p_attribute_02=>'wwv_flow_custom_auth_std.logout?p_this_flow=&APP_ID.&amp;p_next_flow_page_sess=&APP_ID.:1',
  p_attribute_03=>'',
  p_attribute_04=>'',
  p_attribute_05=>'',
  p_attribute_06=>'',
  p_attribute_07=>'',
  p_attribute_08=>'',
  p_required_patch=>'');
end;
null;
 
end;
/

--application/shared_components/security/authentication/database
prompt  ......scheme 5188916996808429
 
begin
 
declare
  s1 varchar2(32767) := null;
  s2 varchar2(32767) := null;
  s3 varchar2(32767) := null;
  s4 varchar2(32767) := null;
  s5 varchar2(32767) := null;
begin
s1:=s1||'-DATABASE-';

s2 := null;
s3 := null;
s4 := null;
s5 := null;
wwv_flow_api.create_auth_setup (
  p_id=> 5188916996808429 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'DATABASE',
  p_description=>'Use database authentication (user identified by DAD).',
  p_page_sentry_function=> s1,
  p_sess_verify_function=> s2,
  p_pre_auth_process=> s3,
  p_auth_function=> s4,
  p_post_auth_process=> s5,
  p_invalid_session_page=>'',
  p_invalid_session_url=>'',
  p_cookie_name=>'',
  p_cookie_path=>'',
  p_cookie_domain=>'',
  p_use_secure_cookie_yn=>'',
  p_ldap_host=>'',
  p_ldap_port=>'',
  p_ldap_string=>'',
  p_attribute_01=>'',
  p_attribute_02=>'',
  p_attribute_03=>'',
  p_attribute_04=>'',
  p_attribute_05=>'',
  p_attribute_06=>'',
  p_attribute_07=>'',
  p_attribute_08=>'',
  p_required_patch=>'');
end;
null;
 
end;
/

--application/shared_components/security/authentication/database_account
prompt  ......scheme 5189012762808429
 
begin
 
declare
  s1 varchar2(32767) := null;
  s2 varchar2(32767) := null;
  s3 varchar2(32767) := null;
  s4 varchar2(32767) := null;
  s5 varchar2(32767) := null;
begin
s1 := null;
s2 := null;
s3 := null;
s4:=s4||'return false; end;--';

s5 := null;
wwv_flow_api.create_auth_setup (
  p_id=> 5189012762808429 + wwv_flow_api.g_id_offset,
  p_flow_id=> wwv_flow.g_flow_id,
  p_name=> 'DATABASE ACCOUNT',
  p_description=>'Use database account credentials.',
  p_page_sentry_function=> s1,
  p_sess_verify_function=> s2,
  p_pre_auth_process=> s3,
  p_auth_function=> s4,
  p_post_auth_process=> s5,
  p_invalid_session_page=>'101',
  p_invalid_session_url=>'',
  p_cookie_name=>'',
  p_cookie_path=>'',
  p_cookie_domain=>'',
  p_use_secure_cookie_yn=>'',
  p_ldap_host=>'',
  p_ldap_port=>'',
  p_ldap_string=>'',
  p_attribute_01=>'',
  p_attribute_02=>'wwv_flow_custom_auth_std.logout?p_this_flow=&APP_ID.&amp;p_next_flow_page_sess=&APP_ID.:1',
  p_attribute_03=>'',
  p_attribute_04=>'',
  p_attribute_05=>'',
  p_attribute_06=>'',
  p_attribute_07=>'',
  p_attribute_08=>'',
  p_required_patch=>'');
end;
null;
 
end;
/

--application/deployment/definition
prompt  ...application deployment
--
 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
begin
s := null;
wwv_flow_api.create_install (
  p_id => 3230176827249316 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_include_in_export_yn => 'Y',
  p_welcome_message => 'This application installer will guide you through the process of creating your database objects and seed data.',
  p_configuration_message => 'You can configure the following attributes of your application.',
  p_build_options_message => 'You can choose to include the following build options.',
  p_validation_message => 'The following validations will be performed to ensure your system is compatible with this application.',
  p_install_message=> 'Please confirm that you would like to install this application''s supporting objects.',
  p_install_success_message => 'Your application''s supporting objects have been installed. Please enable the logging queue by using SQLPLUS to run installed script 500 XFILE_ENABLE_LOG_QUEUE as the PARSING_SCHEMA',
  p_install_failure_message => 'Installation of database objects and seed data has failed. ',
  p_upgrade_message => 'The application installer has detected that this application''s supporting objects were previously installed.  This wizard will guide you through the process of upgrading these supporting objects.',
  p_upgrade_confirm_message => 'Please confirm that you would like to install this application''s supporting objects.',
  p_upgrade_success_message => 'Your application''s supporting objects have been installed.',
  p_upgrade_failure_message => 'Installation of database objects and seed data has failed.',
  p_deinstall_success_message => 'Deinstallation complete.',
  p_deinstall_script_clob => s,
  p_required_free_kb => 100,
  p_required_sys_privs => 'CREATE PROCEDURE:CREATE SYNONYM:CREATE TABLE:CREATE TRIGGER:CREATE VIEW',
  p_deinstall_message=> '');
end;
 
 
end;
/

--application/deployment/install
prompt  ...application install scripts
--
 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'set echo on'||chr(10)||
'spool dbaTasks.log'||chr(10)||
'--'||chr(10)||
'-- This script must be run in SQL*PLUS by a DBA after deciding which APEX database schema will host the XFILES application.'||chr(10)||
'-- It creates the root of the XFILES folder tree (''/XFILES/APEX'') and makes the APEX parsing schema the owner of the APEX folder'||chr(10)||
'-- It grants AQ_ADMINSTRATION_ROLE to the APEX Parsing Schema and execute on package DBMS_AQ to the APEX parsing ';

s:=s||'schema'||chr(10)||
'--'||chr(10)||
'def XFILES_PARSING_SCHEMA = XFILES'||chr(10)||
'--'||chr(10)||
'call APEX_030200.htmldb_site_admin_privs.unrestrict_schema(p_schema => ''XDB'')'||chr(10)||
'/'||chr(10)||
'grant AQ_ADMINISTRATOR_ROLE to &XFILES_PARSING_SCHEMA'||chr(10)||
'/'||chr(10)||
'grant execute on DBMS_AQ to &XFILES_PARSING_SCHEMA'||chr(10)||
'/'||chr(10)||
'declare '||chr(10)||
'  V_RESULT boolean;'||chr(10)||
'  V_XFILES_FOLDER VARCHAR2(700) := ''/XFILES'';'||chr(10)||
'  V_APEX_FOLDER   VARCHAR2(700) := V_XFILES_FOLDER || ''/APEX'';'||chr(10)||
'begin'||chr(10)||
'  if (not dbms_xdb.';

s:=s||'existsResource(V_XFILES_FOLDER)) then'||chr(10)||
'     V_RESULT := dbms_xdb.createFolder(V_XFILES_FOLDER);'||chr(10)||
'  end if;'||chr(10)||
'  if (not dbms_xdb.existsResource(V_APEX_FOLDER)) then'||chr(10)||
'     V_RESULT := dbms_xdb.createFolder(V_APEX_FOLDER);'||chr(10)||
'  end if;'||chr(10)||
'  dbms_xdb.changeOwner(V_APEX_FOLDER,''&XFILES_PARSING_SCHEMA'');'||chr(10)||
'  commit;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- Enable Custom Authentication'||chr(10)||
'--'||chr(10)||
'alter system set event=''31098 trace name context forever';

s:=s||', level 0x8000'''||chr(10)||
'scope=spfile'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- add a trust scheme for the user that will be calling the dbms_xdbz.(re)set_application_principal APIs:'||chr(10)||
'--'||chr(10)||
'call dbms_xdb.enableCustomTrust()'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- PROCEDURE ADDTRUSTSCHEME'||chr(10)||
'--  Argument Name                  Type                    In/Out Default?'||chr(10)||
'--  ------------------------------ ----------------------- ------ --------'||chr(10)||
'--  NAME                           VARCH';

s:=s||'AR2                IN'||chr(10)||
'--  DESCRIPTION                    VARCHAR2                IN'||chr(10)||
'--  SESSION_USER                   VARCHAR2                IN'||chr(10)||
'--  PARSING_SCHEMA                 VARCHAR2                IN'||chr(10)||
'--  SYSTEM_LEVEL                   BOOLEAN                 IN     DEFAULT'||chr(10)||
'--  REQUIRE_PARSING_SCHEMA         BOOLEAN                 IN     DEFAULT'||chr(10)||
'--  ALLOW_REGISTRATION             BOOLEAN  ';

s:=s||'               IN     DEFAULT'||chr(10)||
'--  WORKGROUP                      VARCHAR2                IN     DEFAULT'||chr(10)||
'--'||chr(10)||
'call dbms_xdb.addTrustScheme( NAME => ''ANONYMOUS_&XFILES_PARSING_SCHEMA._TRUST'', DESCRIPTION => ''XFILES TRUST SCHEME'', SESSION_USER => ''ANONYMOUS'', PARSING_SCHEMA => ''&XFILES_PARSING_SCHEMA'')'||chr(10)||
'/'||chr(10)||
'call dbms_xdb.addTrustScheme( NAME => ''&XFILES_PARSING_SCHEMA.&XFILES_PARSING_SCHEMAMA._TRUST'', DES';

s:=s||'CRIPTION => ''XFILES TRUST SCHEME'', SESSION_USER => ''&XFILES_PARSING_SCHEMA'', PARSING_SCHEMA => ''&XFILES_PARSING_SCHEMA'')'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'call dbms_xdb.enableCustomAuthentication()'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- PROCEDURE ADDAUTHENTICATIONMAPPING'||chr(10)||
'-- Argument Name                  Type                    In/Out Default?'||chr(10)||
'-- ------------------------------ ----------------------- ------ --------'||chr(10)||
'-- PATTERN                        VARCHA';

s:=s||'R2                IN'||chr(10)||
'-- NAME                           VARCHAR2                IN'||chr(10)||
'-- USER_PREFIX                    VARCHAR2                IN     DEFAULT'||chr(10)||
'--'||chr(10)||
''||chr(10)||
'declare'||chr(10)||
'  V_RESULT boolean;'||chr(10)||
'begin'||chr(10)||
'	if (not dbms_xdb.existsResource(''/apexFileSystem'')) then'||chr(10)||
'	  V_RESULT := dbms_xdb.createFolder(''/apexFileSystem'');'||chr(10)||
'	end if;'||chr(10)||
'  dbms_xdb.setACL(''/apexFileSystem'',''/sys/acls/all_all_acl.xml'');'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'commit'||chr(10)||
'/'||chr(10)||
'c';

s:=s||'all dbms_xdb.deleteAuthenticationMapping(pattern => ''/apexDemo'', name=> ''XFILES_WORKSPACE'')'||chr(10)||
'/'||chr(10)||
'call DBMS_XDB.ADDAUTHENTICATIONMAPPING'||chr(10)||
'     ('||chr(10)||
'       PATTERN => ''/apexFileSystem/*'','||chr(10)||
'       NAME =>  ''XFILES_WORKSPACE'''||chr(10)||
'     )'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- PROCEDURE ADDAUTHENTICATIONMETHOD'||chr(10)||
'-- Argument Name                  Type                    In/Out Default?'||chr(10)||
'-- ------------------------------ ----------------------- -----';

s:=s||'- --------'||chr(10)||
'-- NAME                           VARCHAR2                IN'||chr(10)||
'-- DESCRIPTION                    VARCHAR2                IN'||chr(10)||
'-- IMPLEMENT_SCHEMA               VARCHAR2                IN'||chr(10)||
'-- IMPLEMENT_METHOD               VARCHAR2                IN'||chr(10)||
'-- LANGUAGE                       VARCHAR2                IN     DEFAULT'||chr(10)||
'--'||chr(10)||
'call dbms_xdb.DELETEAUTHENTICATIONMETHOD(''XFILES_WORKSPACE'')'||chr(10)||
'/'||chr(10)||
'call d';

s:=s||'bms_xdb.addAuthenticationMethod'||chr(10)||
'     ('||chr(10)||
'        NAME => ''XFILES_WORKSPACE'', '||chr(10)||
'        description => ''Enable HTTP for users from XFILES Workspace'', '||chr(10)||
'        implement_schema =>  ''&XFILES_PARSING_SCHEMA'', '||chr(10)||
'        implement_method => ''authenticateUser'','||chr(10)||
'        language => ''PL/SQL'''||chr(10)||
'     )'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'';

wwv_flow_api.create_install_script(
  p_id => 21365323517859135 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_DBA_TASKS',
  p_sequence=> 10,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'NEVER',
  p_condition=> '',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'declare'||chr(10)||
'  non_existant_table exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( non_existant_table , -942 );'||chr(10)||
'begin'||chr(10)||
'--'||chr(10)||
'  begin'||chr(10)||
'    execute immediate ''DROP TABLE CHARACTER_SET_LOV'';'||chr(10)||
'  exception'||chr(10)||
'    when non_existant_table  then'||chr(10)||
'      null;'||chr(10)||
'  end;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'create table CHARACTER_SET_LOV '||chr(10)||
'('||chr(10)||
'   CHARSET_ID   VARCHAR2(32),'||chr(10)||
'   CHARSET_NAME VARCHAR2(128)'||chr(10)||
')'||chr(10)||
'/'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''ISO-8859-6'',''Arabic (ISO-8';

s:=s||'859-6)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''Windows-1256'',''Arabic (Windows-1256)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''ISO-8859-4'',''Baltic (ISO-8859-4)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''Windows-1257'',''Baltic (Windows-1257)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''IBM852'',''Central European (IBM852)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''ISO-8859-2'',''Central European (ISO-8859-2';

s:=s||')'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''Windows-1250'',''Central European (Windows-1250)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''GB2312'',''Chinese Simplified (GB2312)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''GBK'',''Chinese Simplified (GBK)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''MS950'',''Chinese Traditional (Big5)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''EUC-TW'',''Chinese Traditional (EUC-TW)''';

s:=s||');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''Windows-950'',''Chinese Traditional (Windows-950)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''ISO-2022-CN'',''Chinese (ISO-2022-CN)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''IBM866'',''Cyrillic (IBM866)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''ISO-8859-5'',''Cyrillic (ISO-8859-5)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''KOI8-R'',''Cyrillic (KOI8-R)'');'||chr(10)||
'insert into CH';

s:=s||'ARACTER_SET_LOV VALUES (''Windows-1251'',''Cyrillic Alphabet (Windows-1251)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''ISO-8859-7'',''Greek (ISO-8859-7)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''Windows-1253'',''Greek (Windows-1253)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''ISO-8859-8'',''Hebrew (ISO-8859-8)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''Windows-1255'',''Hebrew (Windows-1255)'');'||chr(10)||
'insert into CHARAC';

s:=s||'TER_SET_LOV VALUES (''ISO-2022-JP'',''Japanese (ISO-2022-JP)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''EUC-JP'',''Japanese (EUC-JP)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''SHIFT_JIS'',''Japanese (SHIFT_JIS)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''EUC_KR'',''Korean (KS_C_5601-1987)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''ISO-2022-KR'',''Korean (ISO-2022-KR)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''Wind';

s:=s||'ows-949'',''Korean (Windows-949)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''ISO-8859-3'',''South European (ISO-8859-3)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''TIS-620'',''Thai (TIS-620)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''IBM857'',''Turkish (IBM857)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''ISO-8859-9'',''Turkish (ISO-8859-9)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''Windows-1254'',''Turkish (Windows-1';

s:=s||'254)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''UTF-8'',''Unicode (UTF-8)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''Windows-1258'',''Vietnamese (Windows-1258)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''ISO-8859-1'',''Western (ISO-8859-1)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''Windows-1252'',''Western (Windows-1252)'');'||chr(10)||
'insert into CHARACTER_SET_LOV VALUES (''IBM850'',''Western (IBM850)'');';

wwv_flow_api.create_install_script(
  p_id => 3230574927286563 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_CHARACTER_SET_TABLE',
  p_sequence=> 100,
  p_script_type=> 'INSTALL',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'declare'||chr(10)||
'  non_existant_table exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( non_existant_table , -942 );'||chr(10)||
'begin'||chr(10)||
'--'||chr(10)||
'  begin'||chr(10)||
'    execute immediate ''DROP TABLE LANGUAGE_LOV'';'||chr(10)||
'  exception'||chr(10)||
'    when non_existant_table  then'||chr(10)||
'      null;'||chr(10)||
'  end;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'create table LANGUAGE_LOV'||chr(10)||
'('||chr(10)||
'  LANGUAGE_ID   VARCHAR2(32),'||chr(10)||
'  LANGUAGE_NAME VARCHAR2(128)'||chr(10)||
')'||chr(10)||
'/'||chr(10)||
'  '||chr(10)||
'insert into LANGUAGE_LOV VALUES (''BENGALI'',''Bengali'');'||chr(10)||
'insert into LANGUA';

s:=s||'GE_LOV VALUES (''BRAZILIAN PORTUGUESE'',''Brazilian Portuguese'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''BULGARIAN'',''Bulgarian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''CANADIAN FRENCH'',''Canadian French'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''CATALAN'',''Catalan'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''CROATIAN'',''Croatian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''CZECH'',''Czech'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''DANISH'',''D';

s:=s||'anish'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''DUTCH'',''Dutch'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''EGYPTIAN'',''Egyptian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''en-US'',''English'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''ESTONIAN'',''Estonian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''FINNISH'',''Finnish'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''FRENCH'',''French'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''GERMAN'',''German'');'||chr(10)||
'insert into ';

s:=s||'LANGUAGE_LOV VALUES (''GREEK'',''Greek'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''HEBREW'',''Hebrew'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''HUNGARIAN'',''Hungarian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''ICELANDIC'',''Icelandic'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''INDONESIAN'',''Indonesian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''ITALIAN'',''Italian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''JAPANESE'',''Japanese'');'||chr(10)||
'insert into LANGU';

s:=s||'AGE_LOV VALUES (''KOREAN'',''Korean'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''LATIN AMERICAN SPANISH'',''Latin American Spanish'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''LATVIAN'',''Latvian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''LITHUANIAN'',''Lithuanian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''MALAY'',''Malay'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''MEXICAN SPANISH'',''Mexican Spanish'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''NORWEGI';

s:=s||'AN'',''Norwegian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''POLISH'',''Polish'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''PORTUGUESE'',''Portuguese'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''ROMANIAN'',''Romanian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''RUSSIAN'',''Russian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''SIMPLIFIED CHINESE'',''Simplified Chinese'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''SLOVAK'',''Slovak'');'||chr(10)||
'insert into LANGUAGE_LOV V';

s:=s||'ALUES (''SLOVENIAN'',''Slovenian'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''SPANISH'',''Spanish'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''SWEDISH'',''Swedish'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''THAI'',''Thai'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''TRADITIONAL CHINESE'',''Traditional Chinese'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''TURKISH'',''Turkish'');'||chr(10)||
'insert into LANGUAGE_LOV VALUES (''UKRAINIAN'',''Ukrainian'');'||chr(10)||
'insert into LAN';

s:=s||'GUAGE_LOV VALUES (''VIETNAMESE'',''Vietnamese'');';

wwv_flow_api.create_install_script(
  p_id => 3258364518482302 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_LANGUAGE_TABLE',
  p_sequence=> 110,
  p_script_type=> 'INSTALL',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'--'||chr(10)||
'-- ************************************************'||chr(10)||
'-- *           Table Creation                   *'||chr(10)||
'-- ************************************************'||chr(10)||
'--'||chr(10)||
'--'||chr(10)||
'declare'||chr(10)||
'  non_existant_table exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( non_existant_table , -942 );'||chr(10)||
'begin'||chr(10)||
'--'||chr(10)||
'  begin'||chr(10)||
'    execute immediate ''DROP TABLE XFILES_LOG_TABLE'';'||chr(10)||
'  exception'||chr(10)||
'    when non_existant_table  then'||chr(10)||
'      null;'||chr(10)||
'  end;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'c';

s:=s||'reate table XFILES_LOG_TABLE of XMLType '||chr(10)||
'XMLTYPE store as SECUREFILE binary xml'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- ************************************************'||chr(10)||
'-- *           Trigger Creation                   *'||chr(10)||
'-- *                                              *'||chr(10)||
'-- *  Cannot use Trigger due to Manifest causing  *'||chr(10)||
'-- *  Mutating Table error in create Resource...  *'||chr(10)||
'-- *                                              *'||chr(10)||
'-- ';

s:=s||'************************************************'||chr(10)||
'--'||chr(10)||
'/*'||chr(10)||
'**'||chr(10)||
'**'||chr(10)||
'** create or replace trigger FOLDER_LOG_RECORDS'||chr(10)||
'** after insert '||chr(10)||
'** on XFILES_LOG_TABLE'||chr(10)||
'** for each row'||chr(10)||
'** declare'||chr(10)||
'**   logRecordName varchar2(256);'||chr(10)||
'**   nextLogRecordId raw(16);'||chr(10)||
'**   result boolean;'||chr(10)||
'**   logFolderName varchar2(256) := ''/home/XFILES/logRecords'';'||chr(10)||
'**   logRecordRef  ref XMLType;'||chr(10)||
'**            '||chr(10)||
'** begin'||chr(10)||
'**   select NEXT_LOG';

s:=s||'_RECORD_ID into nextLogRecordId from NEXT_LOG_RECORD for update;'||chr(10)||
'** '||chr(10)||
'**   select extractValue(:new.sys_nc_rowinfo$,''/XFilesLogRecord/User'') '||chr(10)||
'**          || ''-'' ||'||chr(10)||
'**          extractValue(:new.sys_nc_rowinfo$,''/XFilesLogRecord/Timestamps/Init'') '||chr(10)||
'**          || ''.xml'''||chr(10)||
'**     into logRecordName'||chr(10)||
'**     from dual;'||chr(10)||
'**   '||chr(10)||
'**   select ref(x) '||chr(10)||
'**     into logRecordRef '||chr(10)||
'**     from RECENT_LOG_VIEW x'||chr(10)||
'**    ';

s:=s||'where object_id = NextLogRecordId;'||chr(10)||
'** '||chr(10)||
'**   -- Delete any existing Resource that references the selected Log Record'||chr(10)||
'** '||chr(10)||
'**   delete from path_view'||chr(10)||
'**    where under_path(res,1,logFolderName) = 1'||chr(10)||
'**      and extractValue(res,''/Resource/XMLRef'') = logRecordRef;'||chr(10)||
'** '||chr(10)||
'**   update RECENT_LOG_RECORDS'||chr(10)||
'**      set LOG_RECORD = MAKE_REF(XFILES_LOG_TABLE,:new.SYS_NC_OID$)'||chr(10)||
'**    where OBJECT_ID = NextLogRecor';

s:=s||'dId;'||chr(10)||
'** '||chr(10)||
'**   result := dbms_xdb.createResource(logFolderName || ''/'' || logRecordName,logRecordRef); '||chr(10)||
'** '||chr(10)||
'** end;'||chr(10)||
'** /'||chr(10)||
'** show errors'||chr(10)||
'** --'||chr(10)||
'**'||chr(10)||
'*/'||chr(10)||
'--'||chr(10)||
'-- ************************************************'||chr(10)||
'-- *           Index Creation                   *'||chr(10)||
'-- ************************************************'||chr(10)||
'--'||chr(10)||
'create index LOG_RECORD_INDEX on XFILES_LOG_TABLE(OBJECT_VALUE)'||chr(10)||
'indextype is XDB.xmlIndex'||chr(10)||
'para';

s:=s||'meters (''PATH TABLE LOG_RECORD_PATH_TABLE'')'||chr(10)||
'/'||chr(10)||
'-- '||chr(10)||
'-- Create the Parent Value Index on the PATH Table'||chr(10)||
'--'||chr(10)||
'CREATE INDEX LOG_RECORD_PARENT_INDEX'||chr(10)||
'    ON LOG_RECORD_PATH_TABLE (RID, SYS_ORDERKEY_PARENT(ORDER_KEY))'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- Create Depth Index on the PATH Table'||chr(10)||
'--'||chr(10)||
'CREATE INDEX LOG_RECORD_DEPTH_INDEX'||chr(10)||
'    ON LOG_RECORD_PATH_TABLE (RID, SYS_ORDERKEY_DEPTH(ORDER_KEY),ORDER_KEY)'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- ************************';

s:=s||'************************'||chr(10)||
'-- *           View Creation                      *'||chr(10)||
'-- ************************************************'||chr(10)||
'--'||chr(10)||
'create or replace view RECENT_LOG_ENTRIES'||chr(10)||
'as '||chr(10)||
'select OBJECT_VALUE'||chr(10)||
'  from XFILES_LOG_TABLE'||chr(10)||
' where existsNode(OBJECT_VALUE,''/XFilesLogRecord'') = 1'||chr(10)||
'   and (systimestamp - to_timestamp_tz(extractValue(OBJECT_VALUE,''/XFilesLogRecord/Timestamps/Init/text()''),''YYYY-MM-DD"T"H';

s:=s||'H24:MI:SS.FF-TZH:TZM'')) < TO_DSINTERVAL(''000 00:15:00'')'||chr(10)||
' order by extractValue(OBJECT_VALUE,''/XFilesLogRecord/Timestamps/Init/text()'')'||chr(10)||
'/'||chr(10)||
'create or replace view RECENT_SOAP_REQUESTS'||chr(10)||
'as '||chr(10)||
'select OBJECT_VALUE'||chr(10)||
'  from XFILES_LOG_TABLE'||chr(10)||
' where existsNode(OBJECT_VALUE,''/XFilesLogRecord'') = 1'||chr(10)||
'   and existsNode(OBJECT_VALUE,''/XFilesLogRecord/RequestURL[starts-with(.,"/orawsv")]'') = 1'||chr(10)||
'   and (systimestamp - t';

s:=s||'o_timestamp_tz(extractValue(OBJECT_VALUE,''/XFilesLogRecord/Timestamps/Init/text()''),''YYYY-MM-DD"T"HH24:MI:SS.FF-TZH:TZM'')) < TO_DSINTERVAL(''001 00:00:00'')'||chr(10)||
' order by extractValue(OBJECT_VALUE,''/XFilesLogRecord/Timestamps/Init/text()'')'||chr(10)||
'/'||chr(10)||
'create or replace view CURRENT_SOAP_REQUESTS'||chr(10)||
'as '||chr(10)||
'select OBJECT_VALUE'||chr(10)||
'  from XFILES_LOG_TABLE'||chr(10)||
' where existsNode(OBJECT_VALUE,''/XFilesLogRecord'') = 1'||chr(10)||
'   and existsNod';

s:=s||'e(OBJECT_VALUE,''/XFilesLogRecord/RequestURL[starts-with(.,"/orawsv")]'') = 1'||chr(10)||
'   and (systimestamp - to_timestamp_tz(extractValue(OBJECT_VALUE,''/XFilesLogRecord/Timestamps/Init/text()''),''YYYY-MM-DD"T"HH24:MI:SS.FF-TZH:TZM'')) < TO_DSINTERVAL(''000 01:00:00'')'||chr(10)||
' order by extractValue(OBJECT_VALUE,''/XFilesLogRecord/Timestamps/Init/text()'')'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'create or replace view RECENT_HTTP_REQUESTS'||chr(10)||
'as '||chr(10)||
'select OBJECT';

s:=s||'_VALUE'||chr(10)||
'  from XFILES_LOG_TABLE'||chr(10)||
' where existsNode(OBJECT_VALUE,''/XFilesLogRecord'') = 1'||chr(10)||
'   and (systimestamp - to_timestamp_tz(extractValue(OBJECT_VALUE,''/XFilesLogRecord/Timestamps/Init/text()''),''YYYY-MM-DD"T"HH24:MI:SS.FF-TZH:TZM'')) < TO_DSINTERVAL(''000 00:15:00'')'||chr(10)||
' order by extractValue(OBJECT_VALUE,''/XFilesLogRecord/Timestamps/Init/text()'')'||chr(10)||
'/'||chr(10)||
'create or replace view RECENT_HTTP_REQUESTS'||chr(10)||
'as '||chr(10)||
'select';

s:=s||' OBJECT_VALUE'||chr(10)||
'  from XFILES_LOG_TABLE'||chr(10)||
' where existsNode(OBJECT_VALUE,''/XFilesLogRecord'') = 1'||chr(10)||
'   and (systimestamp - to_timestamp_tz(extractValue(OBJECT_VALUE,''/XFilesLogRecord/Timestamps/Init/text()''),''YYYY-MM-DD"T"HH24:MI:SS.FF-TZH:TZM'')) < TO_DSINTERVAL(''000 00:15:00'')'||chr(10)||
' order by extractValue(OBJECT_VALUE,''/XFilesLogRecord/Timestamps/Init/text()'')'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'create or replace view WIKI_LOG_ENTRIES'||chr(10)||
'as '||chr(10)||
'';

s:=s||'select OBJECT_VALUE'||chr(10)||
'  from XFILES_LOG_TABLE'||chr(10)||
' where existsNode(OBJECT_VALUE,''/XFilesLogRecord/RequestURL[starts-with(.,"/orawsv/XFILES/XFILES_WIKI_SERVICES")]'') = 1'||chr(10)||
'/'||chr(10)||
'create or replace view SOAP_LOG_ENTRIES'||chr(10)||
'as '||chr(10)||
'select OBJECT_VALUE'||chr(10)||
'  from XFILES_LOG_TABLE'||chr(10)||
' where existsNode(OBJECT_VALUE,''/XFilesLogRecord/RequestURL[starts-with(.,"/orawsv")]'') = 1'||chr(10)||
'/'||chr(10)||
'create or replace view ERR_RECORD_VIEW'||chr(10)||
'as '||chr(10)||
'select OB';

s:=s||'JECT_VALUE'||chr(10)||
'  from XFILES_LOG_TABLE'||chr(10)||
' where existsNode(OBJECT_VALUE,''/XFilesErrorRecord'') = 1'||chr(10)||
' order by extractValue(OBJECT_VALUE,''/XFilesErrorRecord/Timestamps/Init/text()'')'||chr(10)||
'/'||chr(10)||
'create or replace view RECENT_ERRORS'||chr(10)||
'as '||chr(10)||
'select OBJECT_VALUE'||chr(10)||
'  from XFILES_LOG_TABLE'||chr(10)||
' where existsNode(OBJECT_VALUE,''/XFilesErrorRecord'') = 1'||chr(10)||
'   -- and (systimestamp - to_timestamp_tz(extractValue(OBJECT_VALUE,''/XFilesErrorRe';

s:=s||'cord/Timestamps/Init/text()''),''YYYY-MM-DD"T"HH24:MI:SS.FF-TZH:TZM'')) < TO_DSINTERVAL(''000 01:00:00'')'||chr(10)||
' order by extractValue(OBJECT_VALUE,''/XFilesErrorRecord/Timestamps/Init/text()'')'||chr(10)||
'/'||chr(10)||
'--';

wwv_flow_api.create_install_script(
  p_id => 3592228510584843 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_LOG_TABLE',
  p_sequence=> 120,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'NOT_EXISTS',
  p_condition=> 'select 1 from '||chr(10)||
'   all_synonyms '||chr(10)||
' where owner = ''PUBLIC'' '||chr(10)||
'   and SYNONYM_NAME = ''XFILES_LOGGING''',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'--'||chr(10)||
'declare'||chr(10)||
'  V_RESULT BOOLEAN;'||chr(10)||
'  V_FOLDER               VARCHAR2(1024);'||chr(10)||
'  V_APEX_FOLDER          VARCHAR2(1024)  := ''/XFILES/APEX'';'||chr(10)||
'  V_APEX_LIBRARY_FOLDER  VARCHAR2(1024)  := V_APEX_FOLDER || ''/lib'';'||chr(10)||
'  V_APEX_GRAPHICS_FOLDER VARCHAR2(1024)  := V_APEX_LIBRARY_FOLDER || ''/graphics'';'||chr(10)||
'  V_APEX_ICONS_FOLDER    VARCHAR2(1024)  := V_APEX_LIBRARY_FOLDER || ''/icons'';'||chr(10)||
'  V_APEX_XSL_FOLDER      VARCHAR2(1024';

s:=s||')  := V_APEX_LIBRARY_FOLDER || ''/xsl'';'||chr(10)||
'begin'||chr(10)||
'  V_FOLDER := V_APEX_LIBRARY_FOLDER;'||chr(10)||
'  if (not DBMS_XDB.EXISTSRESOURCE(V_FOLDER)) then'||chr(10)||
'    V_RESULT := DBMS_XDB.CREATEFOLDER(V_FOLDER);'||chr(10)||
'  end if;'||chr(10)||
'  DBMS_XDB.setACL(V_FOLDER,''/sys/acls/bootstrap_acl.xml'');'||chr(10)||
' '||chr(10)||
'  V_FOLDER := V_APEX_GRAPHICS_FOLDER;'||chr(10)||
'  if (not DBMS_XDB.EXISTSRESOURCE(V_FOLDER)) then'||chr(10)||
'    V_RESULT := DBMS_XDB.CREATEFOLDER(V_FOLDER);'||chr(10)||
'  end if;'||chr(10)||
' ';

s:=s||' DBMS_XDB.setACL(V_FOLDER,''/sys/acls/bootstrap_acl.xml'');'||chr(10)||
' '||chr(10)||
'  V_FOLDER := V_APEX_ICONS_FOLDER;'||chr(10)||
'  if (not DBMS_XDB.EXISTSRESOURCE(V_FOLDER)) then'||chr(10)||
'    V_RESULT := DBMS_XDB.CREATEFOLDER(V_FOLDER);'||chr(10)||
'  end if;'||chr(10)||
'  DBMS_XDB.setACL(V_FOLDER,''/sys/acls/bootstrap_acl.xml'');'||chr(10)||
'  '||chr(10)||
'  V_FOLDER := V_APEX_XSL_FOLDER;'||chr(10)||
'  if (not DBMS_XDB.EXISTSRESOURCE(V_FOLDER)) then'||chr(10)||
'    V_RESULT := DBMS_XDB.CREATEFOLDER(V_FOLDER);'||chr(10)||
'  ';

s:=s||'end if;'||chr(10)||
'  DBMS_XDB.setACL(V_FOLDER,''/sys/acls/bootstrap_acl.xml'');'||chr(10)||
''||chr(10)||
'  commit; '||chr(10)||
'end;'||chr(10)||
'/';

wwv_flow_api.create_install_script(
  p_id => 13579750919502108 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_CREATE_FOLDERS',
  p_sequence=> 200,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'EXISTS',
  p_condition=> 'select 1 '||chr(10)||
'  from RESOURCE_VIEW'||chr(10)||
' where equals_path(RES,''/XFILES/APEX'') = 1',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'-- SCRIPT GENEREATED BY XDB_BINARY_EXPORT on 18-OCT-09 12.51.43.328000000 PM -07:00'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''47494638396101000100B30000FF80FF000000000000000000000000000000000000000000000000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''00000000000000000000000000000';

s:=s||'000000000000021F90401000000002C00000000010001004004''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''021044003B''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/graphics/t.gif'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEA';

s:=s||'N;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C0000';

s:=s||'01F74944415438CB8D934F6B1A5114C5D37E8E04FA1D52F219B2EDB2741BE8BA''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''D040A0D905DA22A55AAB0B6DA655C248430D0E5653A9D11A124CAC948A38B3D046E3220E633228FE''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF979EBCFB5287D1D836038759BC777EEFDEF3DE9D03304762DF3CD322D3D27F748FE9AEE1330116''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7BBD5E7D381C5E8E4623CC125B87C3E178638698014B646';

s:=s||'EB55A68B7DBC8E5721045118220201E8F''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''43D3340E5155154EA7D3808CCD7708401BBADD2E6AB51A7C3E1FCAE532B2D92C42A110AAD52A0774''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3A1DD0212E97EB1A320DE8F7FBC8E7F30887C3A8542A70BBDD902409814000B1586CA2259EC93480''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''B58142A1806030084551E0F17860B7DB91482460B158782504FE27C0EFF7239D4EF3F253A914FF';

s:=s||'27''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''934958AD56DE9EAEEBB30149A50EDB4E115B8143C8B28C6834CAB3A02A6C361B87359B4D341A8D9B''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''8027AF76ED2FB74F211D9D63DD7B02A7B8C72BC96432FC46E864CA8742244D009E7F2CAD6D88A5DF''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''9F8F75447EE8D88A6B5879AD4C0446AD118044EFC10030E3EA336FA92F1D5D20FC5DC7A703AAA088''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONT';

s:=s||'ENT,HEXTORAW(''0F5F556E1A6B301870917902B02A9C74770ECF113CBEC0F67E156BEF8BF04655E354B3D92C03F0F8''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6DA1B619A940FCA6E1E9BB5F102267374A9F2503F0F085FCE8C1865C5F5EFFD9717F3963F421FE36''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0B53BA3442FC7313F759406D5AB88D99ED6DF2E935011608728B711E8B467FE10AD54FC5BA5818AD''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''A50000000049454E4';

s:=s||'4AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/pageProperties.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CO';

s:=s||'NTENT,HEXTORAW(''89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C000001F64944415438CB95D3CB4B1B511406F09BBA285217AE4A7DA242A1ED2E4653''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''146B174A10372D8';

s:=s||'522D85251F155A1BA10BA88501F8846511348D450D0C634A555C482544A71A3E0''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''03C54217FD0F4A425ECD73F2D6AFF70C898C8F68BDF0310373CF6FEE19E630008CAF7C1E058FF28A''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''14F1DCA09A545812504422116F3C1E3F4A2412B828FC39F47ABDEE2C920294541C0C062108C2497C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3E1F3C1E0FEC76BB88D86C36180C8653082D1901B4211C';

s:=s||'0E231A8D8A574A201080D7EB85C3E11081''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''5028047A89D1681491730015A7420015F8FD7E389DCE732D25BF89EC14C0DB38D940F7D477AA1597''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CB259EC46AB5A607CE468AD049E87BB8DDEEFF07A448EFA76AB42DC8E1F638AF075062B118BACC15''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''185C6B44C3DC3D8422C1AB811ECB23BCF95881CEC572B4CCCBD1BFFA1C4B073AF42D3F814A9B8';

s:=s||'3AC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''BC8CC79702DDE687F8FA73062B877AB1F0F38116DA8D3E9876C7D16951A17CF4E6D103B52C3B2DD0''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CAFBA5E2A91F3DD07CEFC6C87A3B06D69A31F4AD03735BC378F9A10A77DFB1445AE0C5FBFBF8B2AF''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''85656F12A69D71CC6F8F71E43566B786D06EA943919AFDCD7DCBE452E0580A3C9B2D41BD2E1FB5D3''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CON';

s:=s||'TENT,HEXTORAW(''B75135918D570B9598D91C408B598532CD1D6455B206E92C94F1BF4FE08569874931760B4DA61A28''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3579F8FDE797400328050A08B96C948BFB59B8509D81CC52F63439FA0554FB0FE5F77DE576739998''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0000000049454E44AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/checkedOutDocument.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) th';

s:=s||'en'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37EA0';

s:=s||'000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C000000CF4944415428CF75914D0AC2301046473D8752CF50DA1EC333B8F33A45171E''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''C123B871A3D0DEC0432822B4DA9FB4F03999B4690A950F868479BC3019A2150514DA783407B9210A''));'||chr(10)||
'  DBMS_LOB.AP';

s:=s||'PEND(V_CONTENT,HEXTORAW(''54DD42A741897D4C6B5A8C81B0E5C61D179C91E28ADD8936AE47800A37284C7B04500CFCF308D020''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''C1D8A36F8758231D9062F0E478E3C1A702478D0C40EF2990E1D97978701730B5C2979197582C9058''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''C020853C34693048CDC8A7033C2E116D7B8F8962A434004F3AE36122D7A0CF4A461640FECB7A74B3''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''8F030C';

s:=s||'1E37754EFE78B59EB3781D9F963F2C3F58EAC92E59770000000049454E44AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/versionedDocument.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  ';

s:=s||'V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C0000027F4944415438CB6D52416';

s:=s||'B1341187D9BA449139B18B535344A4D9B684141C4''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''5B3D08823D88E241BD79535084404EEDB10773ECAFF090221E7AF6078805A95AD046139B96342894''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''149326A6497676667DB36BDAB53AF03133DF7CDF9BF7DE8C61DB36BC6369696944293527A59C619C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6480F193B16259D6622E97FBE5AD37BC008542E10A9B9793C9E4642C1683CFE703F7E8';

s:=s||'F57AA8D7EB''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''D8E220D0BDF9F9F9B57F00D83CC2C38FE9743A639A266AB51A3A9D8EBE1D8140008944C2A92B168B''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''1BCC5D5E5858E8EABD6F80C4E4B3F1F1F18C1002E57279B3DD6EA7B80EEAD0EB52A9F44303935D86''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''52B283BEC060C1E44C241241A552019BEE64B3D9AA476A359FCFDFAC56ABC5542AE5D4FE0F604C6B''));'||chr(10)||
'  DBMS_LOB.APPEN';

s:=s||'D(V_CONTENT,HEXTORAW(''E66D7ABD852343E7343B5D43B6637F79B0FDE691BD5299C6CE5ED8D17CF7D22AFCB6802D2DD8961B''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''4248BC58BBEA989A186EE0F699554C3FF960B80C08F2E0FE0D18B4C4F08739DF0294417EC3FA9006''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0948AB8DE7B31DE685D3B2F1F2EDA1047D932EB4765F21101A85618CB0700808C79956C0FE1E64EB''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''1BCCEE772';

s:=s||'86B1FE1C92C6CB3EF012045287D9389E6FA7BEA3C86F8C56BA8BD5E64FF694C5C9F45F3''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''EB3A011A88A64E90B0842D4C2F807064D8A41A9FBE005F7094EE28C8BEC4A7DD302660229E9E44AF''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''1362EDBEC36A00E0FC039BEE6A54ADB5F1798D2CDEF1C482EA29F4BBA46A9359E90B9AE56D57AE52''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''4ECF2103BDD1A894103F9F823F728A0026A61E3E';

s:=s||'C59460436B07C7D349045B432E03CA3D02603AA8''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CAD21EAC13200A0CD3C84090790DD044B75187E8B4119D88D16EE5CAF6026809A1B38F113EE78711''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0CB94FE8E34B284A33BB8876DB54D82751E9FAA58D3F00E0936C2ECFB95E381F47FC09EB60E60F73''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3F9694EE5A0371FC0672B2B2CD876FC1450000000049454E44AE426082''));'||chr(10)||
'  V_RESO';

s:=s||'URCE := ''/XFILES/APEX/lib/icons/lockedDocument.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_';

s:=s||'LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37EA0000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C0000011849444154181905C1CF8A8E611807E0EBFDBE47DF3493AC26260B09E54FD9''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''';

s:=s||'380A9B49CD869D73B0520EC111280B51E210D464A32C59CCC2C2861A0D6AC494663CCF7BFF5CD714''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''00000040037657D9CEBDBA9A2BA9DACBE77A5ABB77669882DDEB79B979F39C0DEBE2B7235FFD7C97''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''BB3BFB8878F3F64B2A49922449D2F321AF9E452C2037CE020038AF6E438312DFAD593925FE3AB4EF''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''92020D4A34BF1C8BE18F134D146810B';

s:=s||'1B4A669BA212833685062E886C96CE816A2408312B361589A''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''75DD52CCA04189AE9B2DCD862EA28306A50C43891233CA3FB080D9A14D2BC064CB2DDF74D0A0EEBF''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7F7D6DE38295496C39B2E7E3C1D88629E0C5C57A543B8B33EB8643C707E3F9FCF8E10F98028027A7''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''C7E551FDD3831300FE0374FB9EA6F1C1FD470000000049454E44AE426082'')';

s:=s||');'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/sql.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_';

s:=s||'LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F5300000009704859''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''73000005B10000038A01AAE1374B0000000467414D410000B18E7CFB5193000000206348524D0000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7A25000080830000F9FF000080E9000075300000EA6000003A980000176F925FC54600000300504C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''';

s:=s||'5445FFFFFFFFFFCCFFFF99FFFF66FFFF33FFFF00FFCCFFFFCCCCFFCC99FFCC66FFCC33FFCC00FF99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FFFF99CCFF9999FF9966FF9933FF9900FF66FFFF66CCFF6699FF6666FF6633FF6600FF33FFFF33CC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF3399FF3366FF3333FF3300FF00FFFF00CCFF0099FF0066FF0033FF0000CCFFFFCCFFCCCCFF99CC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF66CCFF33CCFF00CCCCFFCCCCCCCCC';

s:=s||'C99CCCC66CCCC33CCCC00CC99FFCC99CCCC9999CC9966CC99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''33CC9900CC66FFCC66CCCC6699CC6666CC6633CC6600CC33FFCC33CCCC3399CC3366CC3333CC3300''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CC00FFCC00CCCC0099CC0066CC0033CC000099FFFF99FFCC99FF9999FF6699FF3399FF0099CCFF99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CCCC99CC9999CC6699CC3399CC009999FF9999CC9999999999669999339999';

s:=s||'009966FF9966CC9966''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''999966669966339966009933FF9933CC9933999933669933339933009900FF9900CC990099990066''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99003399000066FFFF66FFCC66FF9966FF6666FF3366FF0066CCFF66CCCC66CC9966CC6666CC3366''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CC006699FF6699CC6699996699666699336699006666FF6666CC6666996666666666336666006633''));'||chr(10)||
'  DBMS_L';

s:=s||'OB.APPEND(V_CONTENT,HEXTORAW(''FF6633CC6633996633666633336633006600FF6600CC66009966006666003366000033FFFF33FFCC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''33FF9933FF6633FF3333FF0033CCFF33CCCC33CC9933CC6633CC3333CC003399FF3399CC33999933''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99663399333399003366FF3366CC3366993366663366333366003333FF3333CC3333993333663333''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3';

s:=s||'33333003300FF3300CC33009933006633003333000000FFFF00FFCC00FF9900FF6600FF3300FF00''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''00CCFF00CCCC00CC9900CC6600CC3300CC000099FF0099CC0099990099660099330099000066FF00''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''66CC0066990066660066330066000033FF0033CC0033990033660033330033000000FF0000CC0000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99000066000033000000C6C629C6C652';

s:=s||'FFFF84FFFFC6FFFFF7FFC629FFC652C68429FFC684C68452''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FFC6C6FFFFFF00000000000000000000000000000000000000000000000000000000000000000000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''00000000000000000000000000000000000000000000000000000000000000000000000000000000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''00000000000000000000017896FC0000000174524E530040E6D8660000006F4';

s:=s||'944415478DA94CFB1''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0DC3301043D127E1202FE200D97F1D0B19C490EF5218499DB0212BF293BFD5BCEE906017CE27CC8E''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''EE788436739C4D22F7975086913ACCF376AE5C6BADB513ECA6268D745C8259A5887BA7DB50465065''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''BB3BCA480A847E6D49FFB08516D7973ADA0FE7DE0300F12729C5AD62E9EA0000000049454E44AE42''));'||chr(10)||
'  DBMS_LO';

s:=s||'B.APPEND(V_CONTENT,HEXTORAW(''6082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/readOnlyFolderClosed.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin';

s:=s||''||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C00000196494441541819A5C13F6B536118C6E1DFF39E379E9C2AAD83A7A';

s:=s||'02808E2A6''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''938B829FC0CDC9C10E2288E296BD936817D1CD59C4490477073F85143A16036223B6446A9A9C9CF7''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''B93DA9897F21057B5D2689C3883456565F3F49B5DDDC1EA4F6EE887F397F2872582C78FEE6F18D4E''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''A491DC561EDEBD542E97A59945040870260C0924702644AA2B6E3F787B0BE8441ADBBB292F4F9476''));'||chr(10)||
'  DBMS_LOB.APPEND';

s:=s||'(V_CONTENT,HEXTORAW(''FFE94B4E9D394E9E394939842582413008C1C882F161E33D8F3AF71827331A91C660042144CE9F3B''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CB85CB57C9428694C0229811CC300B8410686501777E8A4C3990E76DDAC531909847081013912907''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''C6D590F1700FCC901C57C23D608024324BD4D500C999894C49F0B9FF912FBD3E63AF7125BE8EB6A8''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''D2698C1F96';

s:=s||'F31DF6BEF5418199C894049FB616687587EC934025D290991D0ABA5DF1BB48C3010942''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''768490E5CC93B5DA885F025312FF25D2903B06F436D739486F731D740D77F6451AC68478B6B60A18''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''F35D072A66228DC522F4BD1E2E9D5C3030434C0804E26F465D57E42D138D48E3681E5EDD597B7765''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''30D645770E94B7A088BCA06192388CEFD3F2AB561';

s:=s||'49AD90A0000000049454E44AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/imageJPEG.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.C';

s:=s||'REATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C00000196494441541819A5C13F6B536118C6E1DFF39E379E9C2AAD83A7A02808E2A6''));';

s:=s||''||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''938B829FC0CDC9C10E2288E296BD936817D1CD59C4490477073F85143A16036223B6446A9A9C9CF7''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''B93DA9897F21057B5D2689C3883456565F3F49B5DDDC1EA4F6EE887F397F2872582C78FEE6F18D4E''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''A491DC561EDEBD542E97A59945040870260C0924702644AA2B6E3F787B0BE8441ADBBB292F4F9476''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HE';

s:=s||'XTORAW(''FFE94B4E9D394E9E394939842582413008C1C882F161E33D8F3AF71827331A91C660042144CE9F3B''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CB85CB57C9428694C0229811CC300B8410686501777E8A4C3990E76DDAC531909847081013912907''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''C6D590F1700FCC901C57C23D608024324BD4D500C999894C49F0B9FF912FBD3E63AF7125BE8EB6A8''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''D2698C1F96F31DF6BEF5418';

s:=s||'199C894049FB616687587EC934025D290991D0ABA5DF1BB48C3010942''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''768490E5CC93B5DA885F025312FF25D2903B06F436D739486F731D740D77F6451AC68478B6B60A18''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''F35D072A66228DC522F4BD1E2E9D5C3030434C0804E26F465D57E42D138D48E3681E5EDD597B7765''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''30D645770E94B7A088BCA06192388CEFD3F2AB56149AD90A000000';

s:=s||'0049454E44AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/imageGIF.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY';

s:=s||'(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C000001174944415438CB63F8FFFF3F03259861981A60D8F3909F6C030C3A1FF07BCE''));'||chr(10)||
'  DBMS_LOB.AP';

s:=s||'PEND(V_CONTENT,HEXTORAW(''7B7A2C62D5F30F30B1B8CDAF3F782F7E7E0C2487D700FDB67B421EB39F1E2BDAF6FABFFFDCA7F760''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''E221AB5EDE2BDBFDE63F484EBBF68E105603F45AEE4544AF7EF9BD70EBABFF7EB39EDE532FB8218D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''24271DB0E8D93D905CC4D2E7DF8172112806E836DC650B5FFEFC63E58E374005CF7EABE65C334677''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''AA66F9';

s:=s||'2D63905CE9A697FF03673EFEA89074850DC505EAC5372342E73FFD9EB5EAC57F8FBE07F7E4''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''E32E4923C9497B4F7D740F241734F3D177A05C04D630504CB92264DB70E758EAE2A7FF5D5BEEC2C3''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''C06BD2A37B192B9EFF07C9C9455F14C21B0B321117F82DCB6F1EF3EEBC078F05FF290F3FD8D4DE39''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''06921B294999140C004779D6DF69D4AD8D000';

s:=s||'0000049454E44AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/xmlDocument.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEM';

s:=s||'PORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C000001174944415438CB63F8FFFF3F03259861981A60D8F3909F6C030C3A1FF07BCE''));'||chr(10)||
'  DBMS_';

s:=s||'LOB.APPEND(V_CONTENT,HEXTORAW(''7B7A2C62D5F30F30B1B8CDAF3F782F7E7E0C2487D700FDB67B421EB39F1E2BDAF6FABFFFDCA7F760''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''E221AB5EDE2BDBFDE63F484EBBF68E105603F45AEE4544AF7EF9BD70EBABFF7EB39EDE532FB8218D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''24271DB0E8D93D905CC4D2E7DF8172112806E836DC650B5FFEFC63E58E374005CF7EABE65C334677''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''';

s:=s||'AA66F92D63905CE9A697FF03673EFEA89074850DC505EAC5372342E73FFD9EB5EAC57F8FBE07F7E4''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''E32E4923C9497B4F7D740F241734F3D177A05C04D630504CB92264DB70E758EAE2A7FF5D5BEEC2C3''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''C06BD2A37B192B9EFF07C9C9455F14C21B0B321117F82DCB6F1EF3EEBC078F05FF290F3FD8D4DE39''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''06921B294999140C004779D6DF69D4A';

s:=s||'D8D0000000049454E44AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/xmlDocument.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CRE';

s:=s||'ATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF610000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C0000020D49444154181905C1BFAF9E731807E0EBFE3ECF7BDAD3534795883311F13B''));'||chr(10)||
' ';

s:=s||' DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''31D088188485812E0693C56263233631D96C928E0649FF03A3414B442224821858240DDA541B44CF''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''79CFF3DC1FD75549BCF0DEA5D777F74FBC36CA399C4481428AB4A5FBD79BD7F359FD7DE39DCB17CE''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6F012A89973EF8F2F2276F9D7B748C3A1326012081B8F6EFB18BDFDCF4C76F47FFFDF4C3CF67BFB8''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXT';

s:=s||'ORAW(''70FE086618533DBC334F677EBC6A1A551469D6B465895BC7ABE71FBCCDD30FCDBEEE6BA7D28FDC78''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''EECD4FEFF8FCA3978F0654D5E924D3CE346C0673310DA6A28AA1D00EF6779C7FEAC07D0F9CD89DF7''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''F73E8601A1606014A3CAA832AA8C2A632ABFFF75CBBDA78F3D76B6BCF1CC9DA6CDF42ACC0009F344''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''29A9D26B18659ED8C9F0CBF5D';

s:=s||'8F6A27BEBD9FB4FA8792C30434230D71011D428853499063B8C2EDD''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''9318D40033048D2A4A0982349B095043AD25231A0930432F24340A49C018E8324F214588B2366B03''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3374471242048000A55498078D931BD6256086B559439A0610D0616D820E2936D3B06C1730432FD1''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89F7BFDB2AD1455234A98084065CBC67E3F8A8C10CCBB25A570EF637';

s:=s||'9EBC7BE8B086B5E81024247C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7F75918EE3C305CCB01C752FDDD9AEEAAB2BABAE88021D4A74C828A3CB3C572F6B2F30C3F1E1FAE7''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''DECE74D7BB8F6FF7920CA101B7EFCE20617753AAF466AA7FD6A5AFC00C55F9F0C5B72FBD52554F44''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''4E010841040838ECEE6FE7E122FC0F44381E5635836A120000000049454E44AE426082''));'||chr(10)||
'  V_RESOURCE';

s:=s||' := ''/XFILES/APEX/lib/icons/textDocument.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(700);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APP';

s:=s||'END(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F5300000009704859''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7300000EC400000EC401952B0E1B0000000467414D410000B18E7CFB5193000000206348524D0000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7A25000080830000F9FF000080E9000075300000EA6000003A980000176F925FC54600000300504C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''5445FFF';

s:=s||'FFFFFFFCCFFFF99FFFF66FFFF33FFFF00FFCCFFFFCCCCFFCC99FFCC66FFCC33FFCC00FF99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FFFF99CCFF9999FF9966FF9933FF9900FF66FFFF66CCFF6699FF6666FF6633FF6600FF33FFFF33CC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF3399FF3366FF3333FF3300FF00FFFF00CCFF0099FF0066FF0033FF0000CCFFFFCCFFCCCCFF99CC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF66CCFF33CCFF00CCCCFFCCCCCCCCCC99CCCC';

s:=s||'66CCCC33CCCC00CC99FFCC99CCCC9999CC9966CC99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''33CC9900CC66FFCC66CCCC6699CC6666CC6633CC6600CC33FFCC33CCCC3399CC3366CC3333CC3300''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CC00FFCC00CCCC0099CC0066CC0033CC000099FFFF99FFCC99FF9999FF6699FF3399FF0099CCFF99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CCCC99CC9999CC6699CC3399CC009999FF9999CC9999999999669999339999009966F';

s:=s||'F9966CC9966''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''999966669966339966009933FF9933CC9933999933669933339933009900FF9900CC990099990066''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99003399000066FFFF66FFCC66FF9966FF6666FF3366FF0066CCFF66CCCC66CC9966CC6666CC3366''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CC006699FF6699CC6699996699666699336699006666FF6666CC6666996666666666336666006633''));'||chr(10)||
'  DBMS_LOB.APPE';

s:=s||'ND(V_CONTENT,HEXTORAW(''FF6633CC6633996633666633336633006600FF6600CC66009966006666003366000033FFFF33FFCC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''33FF9933FF6633FF3333FF0033CCFF33CCCC33CC9933CC6633CC3333CC003399FF3399CC33999933''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99663399333399003366FF3366CC3366993366663366333366003333FF3333CC3333993333663333''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''33333300';

s:=s||'3300FF3300CC33009933006633003333000000FFFF00FFCC00FF9900FF6600FF3300FF00''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''00CCFF00CCCC00CC9900CC6600CC3300CC000099FF0099CC0099990099660099330099000066FF00''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''66CC0066990066660066330066000033FF0033CC0033990033660033330033000000FF0000CC0000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99000066000033000000FCFCFCD98B33C9C9C9F';

s:=s||'FFFFEF1CD2EF4D650F5DA63EBD36AF8E590F9EAAB''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FCF8E6E5C85EF4DA7AC7C4B9AF9643F1D06CFAF1D5F2D88FFDFAF1DBAE3CECC773F3D8A1FFFCF6DF''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''AA4EDB9B3CDB8F3BE6B176E9B985ECEBEAFEFEFEFDFDFDFBFBFBF8F8F8F6F6F6F2F2F2E0E0E0CACA''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CAC8C8C8C3C3C3FFFFFF4AA8AD600000000174524E530040E6D866000000BB49444154';

s:=s||'78DA3CCF41''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''4AC3501485E1FFBEDE97C608A2047452688BB802D7E0FEDD80D5D00A620696D690262FCD7110E9F4''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''1BFC9C6300906CC3E31BEB54D80443AA8055764E3EC1665C05FA8F75E41F0019BC132E20C816ECF0''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''2D00B343B5840C087953966529A8240902F7DFC7B606A824C06A8931B729ABECD339CD89DDDD9CC6''));'||chr(10)||
'  DBMS_LOB.APPEN';

s:=s||'D(V_CONTENT,HEXTORAW(''0A7EB6C1EAA21B7CF805E0A1BF7AF6D88C1D3207D04BFB6AFBBE458C208837F59303727AA169A0ED''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''4F91011233B0FC163F17FABAFCB986BF0100C10B4C9E4F396F380000000049454E44AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/readOnlyFolderOpen.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT';

s:=s||' := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(700);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F5300000009704859''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''73000005B';

s:=s||'10000038A01AAE1374B0000000467414D410000B18E7CFB5193000000206348524D0000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7A25000080830000F9FF000080E9000075300000EA6000003A980000176F925FC54600000300504C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''5445FFFFFFFFFFCCFFFF99FFFF66FFFF33FFFF00FFCCFFFFCCCCFFCC99FFCC66FFCC33FFCC00FF99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FFFF99CCFF9999FF9966FF9933FF9900FF66FFFF';

s:=s||'66CCFF6699FF6666FF6633FF6600FF33FFFF33CC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF3399FF3366FF3333FF3300FF00FFFF00CCFF0099FF0066FF0033FF0000CCFFFFCCFFCCCCFF99CC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF66CCFF33CCFF00CCCCFFCCCCCCCCCC99CCCC66CCCC33CCCC00CC99FFCC99CCCC9999CC9966CC99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''33CC9900CC66FFCC66CCCC6699CC6666CC6633CC6600CC33FFCC33CCCC3399CC3366CC3';

s:=s||'333CC3300''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CC00FFCC00CCCC0099CC0066CC0033CC000099FFFF99FFCC99FF9999FF6699FF3399FF0099CCFF99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CCCC99CC9999CC6699CC3399CC009999FF9999CC9999999999669999339999009966FF9966CC9966''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''999966669966339966009933FF9933CC9933999933669933339933009900FF9900CC990099990066''));'||chr(10)||
'  DBMS_LOB.APPEND';

s:=s||'(V_CONTENT,HEXTORAW(''99003399000066FFFF66FFCC66FF9966FF6666FF3366FF0066CCFF66CCCC66CC9966CC6666CC3366''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CC006699FF6699CC6699996699666699336699006666FF6666CC6666996666666666336666006633''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF6633CC6633996633666633336633006600FF6600CC66009966006666003366000033FFFF33FFCC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''33FF9933FF';

wwv_flow_api.create_install_script(
  p_id => 11661343713329760 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_INSTALL_ICONS',
  p_sequence=> 210,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'EXISTS',
  p_condition=> 'select 1 '||chr(10)||
'  from RESOURCE_VIEW'||chr(10)||
' where equals_path(RES,''/XFILES/APEX'') = 1',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
begin
s:=s||'6633FF3333FF0033CCFF33CCCC33CC9933CC6633CC3333CC003399FF3399CC33999933''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99663399333399003366FF3366CC3366993366663366333366003333FF3333CC3333993333663333''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''333333003300FF3300CC33009933006633003333000000FFFF00FFCC00FF9900FF6600FF3300FF00''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''00CCFF00CCCC00CC9900CC6600CC3300CC000099F';

s:=s||'F0099CC0099990099660099330099000066FF00''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''66CC0066990066660066330066000033FF0033CC0033990033660033330033000000FF0000CC0000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99000066000033000000C6C629C6C652FFFF84FFFFC6FFFFF7FFC629FFC652C68429FFC684C68452''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FFC6C6FFFFFF000000000000000000000000000000000000000000000000000000000000';

s:=s||'00000000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''00000000000000000000000000000000000000000000000000000000000000000000000000000000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''00000000000000000000017896FC0000000174524E530040E6D8660000006F4944415478DA94CFB1''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0DC3301043D127E1202FE200D97F1D0B19C490EF5218499DB0212BF293BFD5BCEE906017CE27CC8E''));'||chr(10)||
'  DBMS_LOB.APPEND(';

s:=s||'V_CONTENT,HEXTORAW(''EE788436739C4D22F7975086913ACCF376AE5C6BADB513ECA6268D745C8259A5887BA7DB50465065''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''BB3BCA480A847E6D49FFB08516D7973ADA0FE7DE0300F12729C5AD62E9EA0000000049454E44AE42''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/readOnlyFolderClosed.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_X';

s:=s||'DB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(700);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F5300000009704859''';

s:=s||'));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7300000EC400000EC401952B0E1B0000000467414D410000B18E7CFB5193000000206348524D0000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7A25000080830000F9FF000080E9000075300000EA6000003A980000176F925FC54600000300504C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''5445FFFFFFFFFFCCFFFF99FFFF66FFFF33FFFF00FFCCFFFFCCCCFFCC99FFCC66FFCC33FFCC00FF99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT';

s:=s||',HEXTORAW(''FFFF99CCFF9999FF9966FF9933FF9900FF66FFFF66CCFF6699FF6666FF6633FF6600FF33FFFF33CC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF3399FF3366FF3333FF3300FF00FFFF00CCFF0099FF0066FF0033FF0000CCFFFFCCFFCCCCFF99CC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF66CCFF33CCFF00CCCCFFCCCCCCCCCC99CCCC66CCCC33CCCC00CC99FFCC99CCCC9999CC9966CC99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''33CC9900CC66FFCC66CC';

s:=s||'CC6699CC6666CC6633CC6600CC33FFCC33CCCC3399CC3366CC3333CC3300''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CC00FFCC00CCCC0099CC0066CC0033CC000099FFFF99FFCC99FF9999FF6699FF3399FF0099CCFF99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CCCC99CC9999CC6699CC3399CC009999FF9999CC9999999999669999339999009966FF9966CC9966''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''999966669966339966009933FF9933CC9933999933669933339';

s:=s||'933009900FF9900CC990099990066''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99003399000066FFFF66FFCC66FF9966FF6666FF3366FF0066CCFF66CCCC66CC9966CC6666CC3366''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CC006699FF6699CC6699996699666699336699006666FF6666CC6666996666666666336666006633''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF6633CC6633996633666633336633006600FF6600CC66009966006666003366000033FFFF33FFCC'')';

s:=s||');'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''33FF9933FF6633FF3333FF0033CCFF33CCCC33CC9933CC6633CC3333CC003399FF3399CC33999933''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99663399333399003366FF3366CC3366993366663366333366003333FF3333CC3333993333663333''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''333333003300FF3300CC33009933006633003333000000FFFF00FFCC00FF9900FF6600FF3300FF00''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,';

s:=s||'HEXTORAW(''00CCFF00CCCC00CC9900CC6600CC3300CC000099FF0099CC0099990099660099330099000066FF00''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''66CC0066990066660066330066000033FF0033CC0033990033660033330033000000FF0000CC0000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''9900006600003300000032CD3280FF80C5C2B7C8C5BBCACACAC9C9C9C8C8C8C4C4C4C2C2C2FFFFFF''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''000000000000000000000';

s:=s||'00000000000000000000000000000000000000000000000000000000000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''00000000000000000000000000000000000000000000000000000000000000000000000000000000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0000000000000000000070DFA1650000000174524E530040E6D866000000694944415478DA5CCF41''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0EC2301043D137550E02EA22DCFF340415D17B201416431AC01B';

s:=s||'8FBF254B13525B886E35B4A5ED2C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7945DAE931C0D0F9FE07280D3C27E817B84D10DA1C45E9E0754D5A15503F75A3646A83AFCB6840A7''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7CC51C3D723F809F77A28D0AA27A0F0027CD16692CF941C10000000049454E44AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/writeFolderOpen.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETE';

s:=s||'RESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(700);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D4948445200000010000000100803000000282D0F5300000009704859''));'||chr(10)||
'  DBM';

s:=s||'S_LOB.APPEND(V_CONTENT,HEXTORAW(''7300000EC400000EC401952B0E1B0000000467414D410000B18E7CFB5193000000206348524D0000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7A25000080830000F9FF000080E9000075300000EA6000003A980000176F925FC54600000300504C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''5445FFFFFFFFFFCCFFFF99FFFF66FFFF33FFFF00FFCCFFFFCCCCFFCC99FFCC66FFCC33FFCC00FF99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW';

s:=s||'(''FFFF99CCFF9999FF9966FF9933FF9900FF66FFFF66CCFF6699FF6666FF6633FF6600FF33FFFF33CC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF3399FF3366FF3333FF3300FF00FFFF00CCFF0099FF0066FF0033FF0000CCFFFFCCFFCCCCFF99CC''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF66CCFF33CCFF00CCCCFFCCCCCCCCCC99CCCC66CCCC33CCCC00CC99FFCC99CCCC9999CC9966CC99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''33CC9900CC66FFCC66CCCC6699CC6';

s:=s||'666CC6633CC6600CC33FFCC33CCCC3399CC3366CC3333CC3300''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CC00FFCC00CCCC0099CC0066CC0033CC000099FFFF99FFCC99FF9999FF6699FF3399FF0099CCFF99''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CCCC99CC9999CC6699CC3399CC009999FF9999CC9999999999669999339999009966FF9966CC9966''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''999966669966339966009933FF9933CC9933999933669933339933009900';

s:=s||'FF9900CC990099990066''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99003399000066FFFF66FFCC66FF9966FF6666FF3366FF0066CCFF66CCCC66CC9966CC6666CC3366''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''CC006699FF6699CC6699996699666699336699006666FF6666CC6666996666666666336666006633''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''FF6633CC6633996633666633336633006600FF6600CC66009966006666003366000033FFFF33FFCC''));'||chr(10)||
'  DBMS';

s:=s||'_LOB.APPEND(V_CONTENT,HEXTORAW(''33FF9933FF6633FF3333FF0033CCFF33CCCC33CC9933CC6633CC3333CC003399FF3399CC33999933''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''99663399333399003366FF3366CC3366993366663366333366003333FF3333CC3333993333663333''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''333333003300FF3300CC33009933006633003333000000FFFF00FFCC00FF9900FF6600FF3300FF00''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(';

s:=s||'''00CCFF00CCCC00CC9900CC6600CC3300CC000099FF0099CC0099990099660099330099000066FF00''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''66CC0066990066660066330066000033FF0033CC0033990033660033330033000000FF0000CC0000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''9900006600003300000032CD3280FF80FFFFFF000000000000000000000000000000000000000000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''000000000000000000000000000000';

s:=s||'00000000000000000000000000000000000000000000000000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''00000000000000000000000000000000000000000000000000000000000000000000000000000000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0000000000000000000045A7D7640000000174524E530040E6D8660000004C4944415478DA948FC9''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0D00210C0387557A71FFE5A41A78E400ED0791973DB22C079E6FE02194C04';

s:=s||'A7A63AF4C6003D44860''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''9156678CB32413BB13F87E3E41FAD940B512063873EFD6FDB93500162E0DCFDFE6CACB0000000049''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''454E44AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/writeFolderClosed.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESO';

s:=s||'URCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(700);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37EA0000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE900000019744558';

s:=s||'74536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C000000634944415428CF63F8CF801F32D051C191BDFBFFEFFABFE5FFFAFF2BFF2FDE''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''8B45C1DEFF87E070D67F2C0AB60025D6FEFF0FC487FE4FC0A6600D5002020EFD6FC7A660319209F5''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''D814CC42724319360513D675FD6F01EAADFC5FF23F7FDDC08424D90A007D4A2';

s:=s||'01EC6A60667000000''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0049454E44AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/showChildren.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'declare'||chr(10)||
'  V_RESULT  BOOLEAN;'||chr(10)||
'  V_CONTENT BLO';

s:=s||'B;'||chr(10)||
'  V_RESOURCE VARCHAR2(700);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''89504E470D0A1A0A0000000D4948445200000010000000100804000000B5FA37EA0000000467414D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''410000AFC837058AE90000001974455874536F6674776172650041646F626520496D616765526561''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''647971C9653C000000614944415428CF63F';

s:=s||'8CF801F32D051C191BDFBFFEFFABFE5FFFAFF2BFF2FDE''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''8B45C1DEFF87E070D67F2C0AB60025D682E1A1FF13B029580394808043FFDBB129588C64423D3605''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''B390DC50864DC184755DFF5B807A2BFF97FCCF5F37302149B60200C8931F7A5335AF850000000049''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''454E44AE426082''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/icons/hideChi';

s:=s||'ldren.png'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) then'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
''||chr(10)||
'';

wwv_flow_api.append_to_install_script(
  p_id => 11661343713329760 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_script_clob => s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'declare'||chr(10)||
'  V_RESULT   BOOLEAN;'||chr(10)||
'  V_CONTENT  BLOB;'||chr(10)||
'  V_RESOURCE VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  DBMS_LOB.CREATETEMPORARY(V_CONTENT,TRUE);'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3C3F786D6C2076657273696F6E3D22312E302220656E636F64696E673D225554462D38223F3E0D0A''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3C78736C3A7374796C6573686565742076657273696F6E3D22312E302220786D6C6E733A78736C3D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTEN';

s:=s||'T,HEXTORAW(''22687474703A2F2F7777772E77332E6F72672F313939392F58534C2F5472616E73666F726D222078''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6D6C6E733A666F3D22687474703A2F2F7777772E77332E6F72672F313939392F58534C2F466F726D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''61742220786D6C6E733A783D22687474703A2F2F786D6C6E732E6F7261636C652E636F6D2F786462''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''2F706D2F64656D6F2F7';

s:=s||'36561726368223E0D0A093C78736C3A74656D706C617465206D617463683D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''222F223E0D0A09093C78736C3A6170706C792D74656D706C617465732F3E0D0A093C2F78736C3A74''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''656D706C6174653E0D0A093C78736C3A74656D706C617465206D617463683D222A223E0D0A09093C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''646976207374796C653D226D617267696E2D6C6566743A3165';

s:=s||'6D3B746578742D696E64656E743A2D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''32656D3B77686974652D73706163653A206E6F777261703B223E0D0A0909093C78736C3A69662074''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6573743D224063757272656E7450617468223E0D0A090909202020203C696E70757420747970653D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''2268696464656E222069643D2263757272656E7450617468223E0D0A090909093C78736C3A617474''';

s:=s||'));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''726962757465206E616D653D2276616C7565223E3C78736C3A76616C75652D6F662073656C656374''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3D224063757272656E7450617468223E3C2F78736C3A76616C75652D6F663E3C2F78736C3A617474''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7269627574653E0D0A090909202020203C2F696E7075743E0D0A0909093C2F78736C3A69663E0D0A''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT';

s:=s||',HEXTORAW(''0909093C78736C3A696620746573743D2240697353656C65637465643D277472756527223E0D0A09''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0909093C696D6720616C743D2253656C6563746564204974656D22207372633D222F5846494C4553''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''2F69636F6E732F697353656C65637465642E706E67222077696474683D2231362220686569676874''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3D223136223E0D0A0909';

s:=s||'09093C78736C3A617474726962757465206E616D653D226F6E636C69636B''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''223E3C78736C3A746578743E6A6176617363726970743A756E73656C6563744272616E6368283C2F''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''78736C3A746578743E3C78736C3A76616C75652D6F662073656C6563743D22406964223E3C2F7873''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6C3A76616C75652D6F663E3C78736C3A746578743E293B3C2F7';

s:=s||'8736C3A746578743E3C2F78736C3A''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6174747269627574653E3C2F696D673E0D0A0909093C2F78736C3A69663E0D0A0909093C78736C3A''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''696620746573743D2240697353656C65637465643D2766616C736527223E0D0A090909093C696D67''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''20616C743D22556E73656C6563746564204974656D22207372633D222F5846494C45532F69636F6E'')';

s:=s||');'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''732F69734E6F7453656C65637465642E706E67222077696474683D22313622206865696768743D22''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3136223E0D0A090909093C78736C3A617474726962757465206E616D653D226F6E636C69636B223E''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3C78736C3A746578743E6A6176617363726970743A73656C6563744272616E6368283C2F78736C3A''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,';

s:=s||'HEXTORAW(''746578743E3C78736C3A76616C75652D6F662073656C6563743D22406964223E3C2F78736C3A7661''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6C75652D6F663E3C78736C3A746578743E293B3C2F78736C3A746578743E3C2F78736C3A61747472''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''69627574653E3C2F696D673E0D0A0909093C2F78736C3A69663E0D0A0909093C78736C3A69662074''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6573743D2240697353656';

s:=s||'C65637465643D276E756C6C27223E0D0A090909093C696D6720616C743D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''22222077696474683D22313622206865696768743D223136223E0D0A09090909093C78736C3A6174''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''74726962757465206E616D653D22737263223E3C78736C3A76616C75652D6F662073656C6563743D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''222F726F6F742F4066696C6C657249636F6E222F3E3C2F78736C';

s:=s||'3A6174747269627574653E0D0A09''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0909093C2F696D673E0D0A0909093C2F78736C3A69663E0D0A0909093C78736C3A69662074657374''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3D22406368696C6472656E3D2768696464656E27223E0D0A090909093C696D6720616C743D224578''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''70616E64204974656D222077696474683D22313622206865696768743D223136223E0D0A09090909''))';

s:=s||';'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''093C78736C3A617474726962757465206E616D653D22737263223E3C78736C3A76616C75652D6F66''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''2073656C6563743D224073686F774368696C6472656E222F3E3C2F78736C3A617474726962757465''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3E0D0A09090909093C78736C3A617474726962757465206E616D653D226F6E636C69636B223E3C78''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,H';

s:=s||'EXTORAW(''736C3A746578743E6A6176617363726970743A73686F774368696C6472656E283C2F78736C3A7465''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''78743E3C78736C3A76616C75652D6F662073656C6563743D22406964223E3C2F78736C3A76616C75''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''652D6F663E3C78736C3A746578743E293B3C2F78736C3A746578743E3C2F78736C3A617474726962''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''7574653E0D0A090909093C';

s:=s||'2F696D673E0D0A0909093C2F78736C3A69663E0D0A0909093C78736C3A''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''696620746573743D22406368696C6472656E3D2776697369626C6527223E0D0A090909093C696D67''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''20616C743D22556E73656C6563746564204974656D222077696474683D2231362220686569676874''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3D223136223E0D0A09090909093C78736C3A61747472696275746';

s:=s||'5206E616D653D22737263223E3C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''78736C3A76616C75652D6F662073656C6563743D2240686964654368696C6472656E222F3E3C2F78''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''736C3A6174747269627574653E0D0A09090909093C78736C3A617474726962757465206E616D653D''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''226F6E636C69636B223E3C78736C3A746578743E6A6176617363726970743A686964654368696C64''));';

s:=s||''||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''72656E283C2F78736C3A746578743E3C78736C3A76616C75652D6F662073656C6563743D22406964''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''223E3C2F78736C3A76616C75652D6F663E3C78736C3A746578743E293B3C2F78736C3A746578743E''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3C2F78736C3A6174747269627574653E0D0A090909093C2F696D673E0D0A0909093C2F78736C3A69''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HE';

s:=s||'XTORAW(''663E0D0A0909093C78736C3A696620746573743D22406368696C6472656E3D27756E6B6E6F776E27''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''223E0D0A090909093C696D6720616C743D22222077696474683D22313622206865696768743D2231''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''36223E0D0A09090909093C78736C3A617474726962757465206E616D653D22737263223E3C78736C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3A76616C75652D6F6620736';

s:=s||'56C6563743D222F726F6F742F4066696C6C657249636F6E222F3E3C2F''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''78736C3A6174747269627574653E0D0A090909093C2F696D673E0D0A0909093C2F78736C3A69663E''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0D0A0909093C78736C3A696620746573743D224069734F70656E3D276F70656E27223E0D0A090909''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''093C696D673E0D0A09090909093C78736C3A617474726962757465';

s:=s||'206E616D653D22737263223E3C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''78736C3A76616C75652D6F662073656C6563743D22406F70656E49636F6E222F3E3C2F78736C3A61''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''74747269627574653E0D0A09090909093C78736C3A617474726962757465206E616D653D226F6E63''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6C69636B223E3C78736C3A746578743E6A6176617363726970743A6D616B65436C6F736564283C2F''));'||chr(10)||
'';

s:=s||'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''78736C3A746578743E3C78736C3A76616C75652D6F662073656C6563743D22406964223E3C2F7873''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6C3A76616C75652D6F663E3C78736C3A746578743E293B3C2F78736C3A746578743E3C2F78736C3A''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6174747269627574653E0D0A090909093C2F696D673E0D0A0909093C2F78736C3A69663E0D0A0909''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEX';

s:=s||'TORAW(''093C78736C3A696620746573743D224069734F70656E3D27636C6F73656427223E0D0A090909093C''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''696D673E0D0A09090909093C78736C3A617474726962757465206E616D653D22737263223E3C7873''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6C3A76616C75652D6F662073656C6563743D2240636C6F73656449636F6E222F3E3C2F78736C3A61''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''74747269627574653E0D0A09';

s:=s||'090909093C78736C3A617474726962757465206E616D653D226F6E63''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6C69636B223E3C78736C3A746578743E6A6176617363726970743A6D616B654F70656E283C2F7873''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''6C3A746578743E3C78736C3A76616C75652D6F662073656C6563743D22406964223E3C2F78736C3A''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''76616C75652D6F663E3C78736C3A746578743E293B3C2F78736C3A7';

s:=s||'46578743E3C2F78736C3A6174''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''747269627574653E0D0A090909093C2F696D673E0D0A0909093C2F78736C3A69663E0D0A09090909''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''3C696D6720616C743D22222077696474683D223422206865696768743D223136223E0D0A09090909''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''093C78736C3A617474726962757465206E616D653D22737263223E3C78736C3A76616C75652D6F66''));'||chr(10)||
' ';

s:=s||' DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''2073656C6563743D222F726F6F742F4066696C6C657249636F6E222F3E3C2F78736C3A6174747269''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''627574653E0D0A090909093C2F696D673E0D0A0909093C78736C3A76616C75652D6F662073656C65''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''63743D22406E616D65222F3E0D0A0909093C78736C3A696620746573743D22406368696C6472656E''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXT';

s:=s||'ORAW(''3D2776697369626C6527223E0D0A090909093C78736C3A6170706C792D74656D706C617465732F3E''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''0D0A0909093C2F78736C3A69663E0D0A09093C2F6469763E0D0A093C2F78736C3A74656D706C6174''));'||chr(10)||
'  DBMS_LOB.APPEND(V_CONTENT,HEXTORAW(''653E0D0A3C2F78736C3A7374796C6573686565743E0D0A''));'||chr(10)||
'  V_RESOURCE := ''/XFILES/APEX/lib/xsl/showTree.xsl'';'||chr(10)||
'  if (DBMS_XDB.EXISTSRESOURCE(V_RESOURCE)) t';

s:=s||'hen'||chr(10)||
'    DBMS_XDB.DELETERESOURCE(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(V_RESOURCE,V_CONTENT);'||chr(10)||
'  DBMS_LOB.FREETEMPORARY(V_CONTENT);'||chr(10)||
'  COMMIT;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'';

wwv_flow_api.create_install_script(
  p_id => 13579428410495573 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_INSTALL_XSL',
  p_sequence=> 220,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'EXISTS',
  p_condition=> 'select 1 '||chr(10)||
'  from RESOURCE_VIEW'||chr(10)||
' where equals_path(RES,''/XFILES/APEX'') = 1',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'--'||chr(10)||
'create or replace package XFILES_RENDERING'||chr(10)||
'authid definer'||chr(10)||
'as'||chr(10)||
'  function renderAsHTML(P_SOURCE_DOC BLOB) return CLOB;'||chr(10)||
'  function renderAsText(P_SOURCE_DOC BLOB) return CLOB;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--'||chr(10)||
'create or replace synonym XFILES_RENDERING for XFILES_RENDERING'||chr(10)||
'/'||chr(10)||
'create or replace package body XFILES_RENDERING'||chr(10)||
'as'||chr(10)||
'--'||chr(10)||
'function renderAsHTML(P_SOURCE_DOC BLOB) '||chr(10)||
'return CLOB'||chr(10)||
'as'||chr(10)||
'  V_HTM';

s:=s||'L_CONTENT CLOB;'||chr(10)||
'begin'||chr(10)||
'  dbms_lob.createTemporary(V_HTML_CONTENT,true,DBMS_LOB.SESSION);'||chr(10)||
'  ctx_doc.policy_filter(policy_name => ''XFILES_HTML_GENERATION'','||chr(10)||
'                        document => P_SOURCE_DOC,'||chr(10)||
'                        restab => V_HTML_CONTENT,'||chr(10)||
'                        plaintext => false);'||chr(10)||
'  return V_HTML_CONTENT;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function renderAsText(P_SOURCE_DOC BLOB) '||chr(10)||
'return CLOB'||chr(10)||
'as'||chr(10)||
'  V_CONTENT ';

s:=s||'CLOB;'||chr(10)||
'begin'||chr(10)||
'  dbms_lob.createTemporary(V_CONTENT,true,DBMS_LOB.SESSION);'||chr(10)||
'  ctx_doc.policy_filter(policy_name => ''XFILES_HTML_GENERATION'','||chr(10)||
'                        document => P_SOURCE_DOC,'||chr(10)||
'                        restab => V_CONTENT,'||chr(10)||
'                        plaintext => true);'||chr(10)||
'  return V_CONTENT;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--';

wwv_flow_api.create_install_script(
  p_id => 7140650110950617 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => ' XFILES_RENDERING',
  p_sequence=> 310,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'ALWAYS',
  p_condition=> 'select 1 from '||chr(10)||
'   all_synonyms '||chr(10)||
' where owner = ''PUBLIC'' '||chr(10)||
'   and SYNONYM_NAME = ''XFILES_UTILITIES''',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'--'||chr(10)||
'create or replace package XFILES_UTILITIES'||chr(10)||
'authid current_user'||chr(10)||
'as'||chr(10)||
'  C_XFILES_NAMESPACE              constant VARCHAR2(128) := XDB_NAMESPACES.ORACLE_XDB_NAMESPACE || ''/xfiles'';'||chr(10)||
'  C_XFILES_RSS_NAMESPACE          constant VARCHAR2(128) := C_XFILES_NAMESPACE || ''/rss'';'||chr(10)||
'   '||chr(10)||
'  C_XFILES_PREFIX_XFILES          constant VARCHAR2(128) := ''xmlns:xfiles="'' || C_XFILES_NAMESPACE || ''"'';'||chr(10)||
'  C_XFILES_RSS';

s:=s||'_PREFIX_RSS         constant VARCHAR2(128) := ''xmlns:rss="'' || C_XFILES_RSS_NAMESPACE || ''"'';'||chr(10)||
''||chr(10)||
'  C_RSS_ELEMENT                   constant VARCHAR2(256) := ''enableRSS'';'||chr(10)||
''||chr(10)||
'  '||chr(10)||
'  function XFILES_NAMESPACE       return varchar2 deterministic;'||chr(10)||
'  function XFILES_RSS_NAMESPACE   return varchar2 deterministic;'||chr(10)||
'  function XFILES_PREFIX_XFILES   return varchar2 deterministic;'||chr(10)||
'  function XFILES_RSS_PREFIX_RSS ';

s:=s||' return varchar2 deterministic;'||chr(10)||
'  function RSS_ELEMENT            return varchar2 deterministic;'||chr(10)||
'  '||chr(10)||
'  function renderAsHTML(P_SOURCE_FILE VARCHAR2) return CLOB;'||chr(10)||
'  function renderAsText(P_SOURCE_FILE VARCHAR2) return CLOB;'||chr(10)||
'  function renderAsXHTML(P_SOURCE_FILE VARCHAR2) return XMLType;'||chr(10)||
'  function preview(P_SOURCE_FILE VARCHAR2, P_LINES NUMBER DEFAULT 10, P_LINE_SIZE NUMBER DEFAULT 132) return XMLT';

s:=s||'ype;'||chr(10)||
'  function transformToHTML(P_XMLDOC XMLType, P_XSL_PATH VARCHAR2) return CLOB;'||chr(10)||
'  function xmlTransform(P_XMLDOC XMLType, P_XSLDOC XMLType) return XMLType;'||chr(10)||
'  function xmlTransform2(P_XMLDOC XMLType, P_XSLDOC XMLType) return XMLType;'||chr(10)||
'  procedure enableRSSFeed(P_FOLDER_PATH VARCHAR2, P_ITEMS_CHANGED_IN VARCHAR2);'||chr(10)||
'  procedure disableRSSFeed(P_FOLDER_PATH VARCHAR2);'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--'||chr(10)||
'create or';

s:=s||' replace synonym XFILES_UTILITIES for XFILES_UTILITIES'||chr(10)||
'/'||chr(10)||
'create or replace package body XFILES_UTILITIES'||chr(10)||
'as'||chr(10)||
'--'||chr(10)||
'function XFILES_NAMESPACE       '||chr(10)||
'return varchar2 deterministic'||chr(10)||
'as '||chr(10)||
'begin'||chr(10)||
'  return C_XFILES_NAMESPACE;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function XFILES_RSS_NAMESPACE    '||chr(10)||
'return varchar2 deterministic'||chr(10)||
'as '||chr(10)||
'begin'||chr(10)||
'  return C_XFILES_RSS_NAMESPACE;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function XFILES_PREFIX_XFILES   '||chr(10)||
'return varchar2 det';

s:=s||'erministic'||chr(10)||
'as '||chr(10)||
'begin'||chr(10)||
'  return C_XFILES_PREFIX_XFILES;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function XFILES_RSS_PREFIX_RSS  '||chr(10)||
'return varchar2 deterministic'||chr(10)||
'as '||chr(10)||
'begin'||chr(10)||
'  return C_XFILES_RSS_PREFIX_RSS;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function RSS_ELEMENT            '||chr(10)||
'return varchar2 deterministic'||chr(10)||
'as '||chr(10)||
'begin'||chr(10)||
'  return C_RSS_ELEMENT;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function renderAsHTML(P_SOURCE_FILE VARCHAR2) '||chr(10)||
'return CLOB'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  return XFILES_RENDERING.renderAsHTML(xdburitype(';

s:=s||'P_SOURCE_FILE).getBLOB());'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function renderAsText(P_SOURCE_FILE VARCHAR2) '||chr(10)||
'return CLOB'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  return XFILES_RENDERING.renderAsText(xdburitype(P_SOURCE_FILE).getBLOB());'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function renderAsXHTML(P_SOURCE_FILE VARCHAR2) '||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'  V_DOCUMENT CLOB;'||chr(10)||
'  V_CONTENT CLOB;'||chr(10)||
'  V_OFFSET  NUMBER;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  -- xdb_debug.writeDebug(P_SOURCE_FILE);'||chr(10)||
''||chr(10)||
'  dbms_lob.createTemporary(V_DOCUMENT,t';

s:=s||'rue);'||chr(10)||
'  dbms_lob.open(V_DOCUMENT,dbms_lob.lob_readwrite);'||chr(10)||
''||chr(10)||
'  V_CONTENT := ''<documentContent><![CDATA['';'||chr(10)||
'  dbms_lob.append(V_DOCUMENT,V_CONTENT);'||chr(10)||
'  dbms_lob.freeTemporary(V_CONTENT);'||chr(10)||
'  '||chr(10)||
'  V_CONTENT := XFILES_RENDERING.renderAsHTML(xdburitype(P_SOURCE_FILE).getBLOB());'||chr(10)||
'  dbms_lob.append(V_DOCUMENT,V_CONTENT);'||chr(10)||
'  dbms_lob.freeTemporary(V_CONTENT);'||chr(10)||
''||chr(10)||
'  V_CONTENT := '']]></documentContent>'';'||chr(10)||
'  dbms_lob.ap';

s:=s||'pend(V_DOCUMENT,V_CONTENT);'||chr(10)||
'  dbms_lob.freeTemporary(V_CONTENT);'||chr(10)||
''||chr(10)||
'  return xmlType(V_DOCUMENT);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function preview(P_SOURCE_FILE VARCHAR2, P_LINES NUMBER DEFAULT 10, P_LINE_SIZE NUMBER DEFAULT 132) '||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'  V_DOCUMENT  CLOB;'||chr(10)||
'  V_CONTENT   CLOB;'||chr(10)||
'  V_OFFSET    NUMBER := 0;'||chr(10)||
'  V_MAX_CHARS NUMBER := (P_LINES * P_LINE_SIZE);'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  -- xdb_debug.writeDebug(P_SOURCE_FILE);'||chr(10)||
''||chr(10)||
'  dbms_lob.';

s:=s||'createTemporary(V_DOCUMENT,true);'||chr(10)||
'  dbms_lob.open(V_DOCUMENT,dbms_lob.lob_readwrite);'||chr(10)||
''||chr(10)||
'  V_CONTENT := ''<documentContent><![CDATA['';'||chr(10)||
'  dbms_lob.append(V_DOCUMENT,V_CONTENT);'||chr(10)||
'  dbms_lob.freeTemporary(V_CONTENT);'||chr(10)||
' '||chr(10)||
'  V_CONTENT := XFILES_RENDERING.renderAsText(xdburitype(P_SOURCE_FILE).getBLOB());'||chr(10)||
'  if (P_LINES > 0) then'||chr(10)||
'    V_OFFSET  := dbms_lob.instr(V_CONTENT,chr(10),1,P_LINES);'||chr(10)||
'    if (V_OFFSET > ';

s:=s||'0) then'||chr(10)||
'      DBMS_LOB.trim(V_CONTENT,V_OFFSET);'||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if (DBMS_LOB.getLength(V_CONTENT) > V_MAX_CHARS) then'||chr(10)||
'    DBMS_LOB.trim(V_CONTENT,V_MAX_CHARS);'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  dbms_lob.append(V_DOCUMENT,V_CONTENT);'||chr(10)||
'  dbms_lob.freeTemporary(V_CONTENT);'||chr(10)||
''||chr(10)||
'  V_CONTENT := '']]></documentContent>'';'||chr(10)||
'  dbms_lob.append(V_DOCUMENT,V_CONTENT);'||chr(10)||
'  dbms_lob.freeTemporary(V_CONTENT);'||chr(10)||
''||chr(10)||
'  return xmlType(V_DO';

s:=s||'CUMENT);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function transformToHTML(P_XMLDOC XMLType, P_XSL_PATH VARCHAR2) '||chr(10)||
'return CLOB'||chr(10)||
'as'||chr(10)||
'  V_HTML clob;'||chr(10)||
'begin'||chr(10)||
'  select P_XMLDOC.transform(xdburitype(P_XSL_PATH).getXML()).getClobVal()'||chr(10)||
'    into V_HTML'||chr(10)||
'    from dual;'||chr(10)||
'  return V_HTML;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function xmlTransform(P_XMLDOC XMLType, P_XSLDOC XMLType) '||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  return P_XMLDOC.transform(P_XSLDOC);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function xmlTransform2';

s:=s||'(P_XMLDOC XMLType, P_XSLDOC XMLType) '||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'  V_DOCUMENT CLOB;'||chr(10)||
'  V_CONTENT CLOB;'||chr(10)||
'begin'||chr(10)||
'  dbms_lob.createTemporary(V_DOCUMENT,true);'||chr(10)||
'  dbms_lob.open(V_DOCUMENT,dbms_lob.lob_readwrite);'||chr(10)||
''||chr(10)||
'  V_CONTENT := ''<documentContent><![CDATA['';'||chr(10)||
'  dbms_lob.append(V_DOCUMENT,V_CONTENT);'||chr(10)||
'  dbms_lob.freeTemporary(V_CONTENT);'||chr(10)||
''||chr(10)||
'  select P_XMLDOC.transform(P_XSLDOC).getClobVal()'||chr(10)||
'    into V_CONTENT'||chr(10)||
'    from ';

s:=s||'dual;'||chr(10)||
'  dbms_lob.append(V_DOCUMENT,V_CONTENT);'||chr(10)||
'  dbms_lob.freeTemporary(V_CONTENT);'||chr(10)||
''||chr(10)||
'  V_CONTENT := '']]></documentContent>'';'||chr(10)||
'  dbms_lob.append(V_DOCUMENT,V_CONTENT);'||chr(10)||
'  dbms_lob.freeTemporary(V_CONTENT);'||chr(10)||
'    '||chr(10)||
'    '||chr(10)||
'  return xmlType(V_DOCUMENT);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function transformToHTML(P_XMLDOC XMLType, P_XSLDOC XMLType) '||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  return P_XMLDOC.transform(P_XSLDOC);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure enable';

s:=s||'RSSFeed(P_FOLDER_PATH VARCHAR2, P_ITEMS_CHANGED_IN VARCHAR2)'||chr(10)||
'as '||chr(10)||
'  V_RSS_METADATA  XMLType;'||chr(10)||
'  V_TEMP           NUMBER(1);'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  select xmlElement'||chr(10)||
'         ('||chr(10)||
'           evalname(XFILES_UTILITIES.RSS_ELEMENT),'||chr(10)||
'           xmlAttributes(XFILES_UTILITIES.XFILES_RSS_NAMESPACE as "xmlns"),'||chr(10)||
'           xmlElement("ItemsChangedIn", P_ITEMS_CHANGED_IN)'||chr(10)||
'         )'||chr(10)||
'    into V_RSS_METADATA'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  ';

s:=s||'begin'||chr(10)||
'    select 1 '||chr(10)||
'      into V_TEMP'||chr(10)||
'      from RESOURCE_VIEW'||chr(10)||
'     where equals_path(RES,P_FOLDER_PATH) = 1'||chr(10)||
'       and existsNode(RES,''/r:Resource/rss:'' || XFILES_UTILITIES.RSS_ELEMENT, XDB_NAMESPACES.RESOURCE_PREFIX_R || '' '' || XFILES_UTILITIES.XFILES_RSS_PREFIX_RSS) = 1;'||chr(10)||
'     dbms_xdb.updateResourceMetadata(P_FOLDER_PATH, XFILES_UTILITIES.XFILES_RSS_NAMESPACE, XFILES_UTILITIES.RSS_ELEMENT, V_RS';

s:=s||'S_METADATA);'||chr(10)||
'  exception'||chr(10)||
'    when no_data_found then'||chr(10)||
'      dbms_xdb.appendResourceMetadata(P_FOLDER_PATH, V_RSS_METADATA);'||chr(10)||
'    when others then'||chr(10)||
'      raise;'||chr(10)||
'  end;'||chr(10)||
''||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure disableRSSFeed(P_FOLDER_PATH VARCHAR2)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  dbms_xdb.deleteResourceMetadata(P_FOLDER_PATH, XFILES_UTILITIES.XFILES_RSS_NAMESPACE, XFILES_UTILITIES.RSS_ELEMENT);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--';

wwv_flow_api.create_install_script(
  p_id => 6766938205937716 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_UTILITIES',
  p_sequence=> 320,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'NOT_EXISTS',
  p_condition=> 'select 1 from '||chr(10)||
'   all_synonyms '||chr(10)||
' where owner = ''PUBLIC'' '||chr(10)||
'   and SYNONYM_NAME = ''XFILES_UTILITIES''',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'--'||chr(10)||
'-- *******************************************************************'||chr(10)||
'-- *    AQ to PACKAGE to manage queing and dequeing of log records   *'||chr(10)||
'-- *           and inserting data into XFILES_LOG_TABLE              *'||chr(10)||
'-- *******************************************************************'||chr(10)||
'--'||chr(10)||
'-- Create the Package that will provide enqueue and dequeue functionality'||chr(10)||
'--'||chr(10)||
'create or replace package XFILES_';

s:=s||'LOGWRITER'||chr(10)||
'AUTHID DEFINER'||chr(10)||
'as'||chr(10)||
'  procedure ENQUEUE_LOG_RECORD(LOG_RECORD CLOB);'||chr(10)||
'  procedure ENQUEUE_LOG_RECORD(LOG_RECORD XMLTYPE);'||chr(10)||
'  procedure DEQUEUE_LOG_RECORD(context raw, reginfo sys.aq$_reg_info, descr sys.aq$_descriptor, payload raw, payloadl number);    '||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--'||chr(10)||
'create or replace synonym XFILES_LOGWRITER for XFILES_LOGWRITER'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- Package Body must be created using';

s:=s||' PL/SQL due to use of substition strings'||chr(10)||
'--'||chr(10)||
'create or replace package body XFILES_LOGWRITER'||chr(10)||
'as'||chr(10)||
'--'||chr(10)||
'procedure ENQUEUE_LOG_RECORD(LOG_RECORD CLOB)'||chr(10)||
'as'||chr(10)||
'  PRAGMA AUTONOMOUS_TRANSACTION;'||chr(10)||
''||chr(10)||
'  enq_ct             dbms_aq.enqueue_options_t;'||chr(10)||
'  msg_prop           dbms_aq.message_properties_t;'||chr(10)||
'  enq_msgid          raw(16); '||chr(10)||
'  '||chr(10)||
'  V_QUEUE_NAME       VARCHAR2(128) := sys_context(''USERENV'',''CURRENT_SCHEMA'') ||';

s:=s||' ''.LOG_RECORD_Q'';'||chr(10)||
'  '||chr(10)||
'begin'||chr(10)||
'  DBMS_AQ.ENQUEUE(V_QUEUE_NAME, enq_ct, msg_prop, xmltype(LOG_RECORD), enq_msgid);'||chr(10)||
'  commit;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure ENQUEUE_LOG_RECORD(LOG_RECORD XMLTYPE)'||chr(10)||
'as'||chr(10)||
'  PRAGMA AUTONOMOUS_TRANSACTION;'||chr(10)||
''||chr(10)||
'  enq_ct             dbms_aq.enqueue_options_t;'||chr(10)||
'  msg_prop           dbms_aq.message_properties_t;'||chr(10)||
'  enq_msgid          raw(16); '||chr(10)||
'  '||chr(10)||
'  V_QUEUE_NAME       VARCHAR2(128) := sys_context(''US';

s:=s||'ERENV'',''CURRENT_SCHEMA'') || ''.LOG_RECORD_Q'';'||chr(10)||
'      '||chr(10)||
'begin'||chr(10)||
'  DBMS_AQ.ENQUEUE(V_QUEUE_NAME, enq_ct, msg_prop, LOG_RECORD, enq_msgid);'||chr(10)||
'  commit;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure DEQUEUE_LOG_RECORD( context raw, '||chr(10)||
'                              reginfo sys.aq$_reg_info, '||chr(10)||
'                              descr sys.aq$_descriptor,'||chr(10)||
'                              payload raw, '||chr(10)||
'                              payloadl number )'||chr(10)||
'a';

s:=s||'s'||chr(10)||
'  deq_ct                dbms_aq.dequeue_options_t;'||chr(10)||
'  msg_prop              dbms_aq.message_properties_t;'||chr(10)||
'  enq_msgid             raw(16); '||chr(10)||
''||chr(10)||
'  LOG_RECORD            XMLType;'||chr(10)||
'  V_QUEUE_NAME          VARCHAR2(128) := sys_context(''USERENV'',''CURRENT_SCHEMA'') || ''.LOG_RECORD_Q'';'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  DBMS_AQ.DEQUEUE(V_QUEUE_NAME, deq_ct, msg_prop, LOG_RECORD, enq_msgid);'||chr(10)||
'  insert into XFILES_LOG_TABLE values(LOG_R';

s:=s||'ECORD);'||chr(10)||
'  commit;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--';

wwv_flow_api.create_install_script(
  p_id => 2157443801376668 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_LOGWRITER',
  p_sequence=> 330,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'NOT_EXISTS',
  p_condition=> 'select 1 from '||chr(10)||
'   all_synonyms '||chr(10)||
' where owner = ''PUBLIC'' '||chr(10)||
'   and SYNONYM_NAME = ''XFILES_LOGGING''',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'--'||chr(10)||
'create or replace package XFILES_LOGGING'||chr(10)||
'as'||chr(10)||
'  procedure writeLogRecord(P_PACKAGE_URL VARCHAR2, P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType);'||chr(10)||
'  procedure writeErrorRecord(P_PACKAGE_URL VARCHAR2, P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, V_STACK_TRACE XMLType);'||chr(10)||
'  function captureStackTrace return XMLType;'||chr(10)||
'end;  '||chr(10)||
'/'||chr(10)||
'show error';

s:=s||'s'||chr(10)||
'--'||chr(10)||
'create or replace synonym XFILES_LOGGING for XFILES_LOGGING'||chr(10)||
'/'||chr(10)||
'create or replace package body XFILES_LOGGING'||chr(10)||
'as'||chr(10)||
'procedure writeLogRecord(P_PACKAGE_URL VARCHAR2, P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)'||chr(10)||
'as'||chr(10)||
'  PRAGMA AUTONOMOUS_TRANSACTION;'||chr(10)||
'  V_LOG_RECORD XMLType;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  select XMLElement'||chr(10)||
'         ('||chr(10)||
'           "XFilesLogRecord",'||chr(10)||
'           xmlElem';

s:=s||'ent("RequestURL", P_PACKAGE_URL || P_NAME || + ''()''),'||chr(10)||
'           xmlElement("User",USER),'||chr(10)||
'           xmlElement'||chr(10)||
'           ('||chr(10)||
'             "Timestamps",'||chr(10)||
'             xmlElement("Init",P_INIT_TIME),'||chr(10)||
'             xmlElement("Complete",SYSTIMESTAMP)'||chr(10)||
'           ),'||chr(10)||
'           xmlElement'||chr(10)||
'           ('||chr(10)||
'             "Parameters",'||chr(10)||
'             P_PARAMETERS'||chr(10)||
'           )'||chr(10)||
'         )'||chr(10)||
'    into V_LOG_RECORD'||chr(10)||
'    fr';

s:=s||'om dual;'||chr(10)||
''||chr(10)||
'  XFILES_LOGWRITER.ENQUEUE_LOG_RECORD(V_LOG_RECORD);'||chr(10)||
'  commit;'||chr(10)||
''||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure writeErrorRecord(P_PACKAGE_URL VARCHAR2, P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, V_STACK_TRACE XMLType)'||chr(10)||
'as'||chr(10)||
'  PRAGMA AUTONOMOUS_TRANSACTION;'||chr(10)||
'  V_LOG_RECORD XMLType;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  select XMLElement'||chr(10)||
'         ('||chr(10)||
'           "XFilesErrorRecord",'||chr(10)||
'           xmlElement("RequestURL",P_';

s:=s||'PACKAGE_URL || P_NAME || + ''()''),'||chr(10)||
'           xmlElement("User",USER),'||chr(10)||
'           xmlElement'||chr(10)||
'           ('||chr(10)||
'             "Timestamps",'||chr(10)||
'             xmlElement("Init",P_INIT_TIME),'||chr(10)||
'             xmlElement("Complete",SYSTIMESTAMP)'||chr(10)||
'           ),'||chr(10)||
'           xmlElement'||chr(10)||
'           ('||chr(10)||
'             "Parameters",'||chr(10)||
'             P_PARAMETERS'||chr(10)||
'           ),'||chr(10)||
'           V_STACK_TRACE'||chr(10)||
'         )'||chr(10)||
'    into V_LOG_RECORD'||chr(10)||
'';

s:=s||'    from dual;'||chr(10)||
'    '||chr(10)||
'  XFILES_LOGWRITER.ENQUEUE_LOG_RECORD(V_LOG_RECORD);'||chr(10)||
'  commit;'||chr(10)||
''||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function captureStackTrace'||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'  V_STACK_TRACE XMLType;'||chr(10)||
'begin'||chr(10)||
'  select xmlElement'||chr(10)||
'         ('||chr(10)||
'           "Error",'||chr(10)||
'           xmlElement'||chr(10)||
'           ('||chr(10)||
'             "Stack",'||chr(10)||
'             xmlCDATA(DBMS_UTILITY.FORMAT_ERROR_STACK())'||chr(10)||
'           ),'||chr(10)||
'           xmlElement'||chr(10)||
'           ('||chr(10)||
'             "Back';

s:=s||'Trace",'||chr(10)||
'             xmlCDATA(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE())'||chr(10)||
'           )'||chr(10)||
'         )'||chr(10)||
'    into V_STACK_TRACE'||chr(10)||
'    from DUAL;'||chr(10)||
'   '||chr(10)||
'    return V_STACK_TRACE;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--'||chr(10)||
'';

wwv_flow_api.create_install_script(
  p_id => 2394244599475946 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_LOGGING',
  p_sequence=> 340,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'NOT_EXISTS',
  p_condition=> 'select 1 from '||chr(10)||
'   all_synonyms '||chr(10)||
' where owner = ''PUBLIC'' '||chr(10)||
'   and SYNONYM_NAME = ''XFILES_LOGGING''',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'declare'||chr(10)||
'  non_existant_table exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( non_existant_table , -942 );'||chr(10)||
'begin'||chr(10)||
'--'||chr(10)||
'  begin'||chr(10)||
'    execute immediate ''DROP TABLE XDB_WIKI_TABLE'';'||chr(10)||
'  exception'||chr(10)||
'    when non_existant_table  then'||chr(10)||
'      null;'||chr(10)||
'  end;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'create table XDB_WIKI_TABLE of XMLType '||chr(10)||
'XMLTYPE store as SECUREFILE binary xml'||chr(10)||
'/'||chr(10)||
'create index XDB_WIKI_INDEX on XDB_WIKI_TABLE(OBJECT_VALUE)'||chr(10)||
'indextype is XDB.xmlIndex';

s:=s||''||chr(10)||
'parameters (''PATH TABLE XDB_WIKI_PATH_TABLE'')'||chr(10)||
'/'||chr(10)||
'-- '||chr(10)||
'-- Create the Parent Value Index on the PATH Table'||chr(10)||
'--'||chr(10)||
'CREATE INDEX XDB_WIKI_PARENT_INDEX'||chr(10)||
'    ON XDB_WIKI_PATH_TABLE (RID, SYS_ORDERKEY_PARENT(ORDER_KEY))'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- Create Depth Index on the PATH Table'||chr(10)||
'--'||chr(10)||
'CREATE INDEX XDB_WIKI_DEPTH_INDEX'||chr(10)||
'    ON XDB_WIKI_PATH_TABLE (RID, SYS_ORDERKEY_DEPTH(ORDER_KEY),ORDER_KEY)'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'create or replace package XFILES';

s:=s||'_WIKI_SERVICES '||chr(10)||
'AUTHID CURRENT_USER'||chr(10)||
'as'||chr(10)||
'  C_XDBWIKI_NAMESPACE   constant VARCHAR2(128) := XFILES_UTILITIES.XFILES_NAMESPACE || ''/wiki'';'||chr(10)||
'  C_XDBWIKI_PREFIX_WIKI constant VARCHAR2(128) := ''xmlns:wiki="'' || C_XDBWIKI_NAMESPACE || ''"'';'||chr(10)||
'  C_XDBWIKI_SCHEMA_URL  constant VARCHAR2(128) := XFILES_UTILITIES.XFILES_NAMESPACE || ''/XDBWiki.xsd'';'||chr(10)||
'  C_XHTML_NAMESPACE     constant VARCHAR2(128) := ''http://ww';

s:=s||'w.w3.org/1999/xhtml'';'||chr(10)||
'  C_XHMTL_NO_PREFIX     constant VARCHAR2(128) := ''xmlns="'' || C_XHTML_NAMESPACE || ''"'';'||chr(10)||
'  C_WIKI_ELEMENT        constant VARCHAR2(256) := ''XDBWikiPage'';'||chr(10)||
''||chr(10)||
'  function  XDBWIKI_NAMESPACE   return VARCHAR2 deterministic;'||chr(10)||
'  function  XDBWIKI_PREFIX_WIKI return VARCHAR2 deterministic;'||chr(10)||
'  function  XDBWIKI_SCHEMA_URL  return VARCHAR2 deterministic;'||chr(10)||
'  function  XHTML_NAMESPACE     re';

s:=s||'turn VARCHAR2 deterministic;'||chr(10)||
'  function  XHTML_NO_PREFIX     return VARCHAR2 deterministic;'||chr(10)||
'  function  WIKI_ELEMENT        return VARCHAR2 deterministic;'||chr(10)||
''||chr(10)||
'  procedure CREATEWIKIPAGE(P_RESOURCE_PATH VARCHAR);'||chr(10)||
'  procedure UPDATEWIKIPAGE(P_RESOURCE_PATH VARCHAR, P_CONTENTS XMLTYPE);'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--'||chr(10)||
'create or replace synonym XFILES_WIKI_SERVICES for XFILES_WIKI_SERVICES'||chr(10)||
'/'||chr(10)||
'create or rep';

s:=s||'lace package body XFILES_WIKI_SERVICES'||chr(10)||
'as'||chr(10)||
'function XDBWIKI_NAMESPACE return VARCHAR2 deterministic as begin return C_XDBWIKI_NAMESPACE; end;'||chr(10)||
'--'||chr(10)||
'function XDBWIKI_PREFIX_WIKI return VARCHAR2 deterministic as begin return C_XDBWIKI_PREFIX_WIKI; end;'||chr(10)||
'--'||chr(10)||
'function XDBWIKI_SCHEMA_URL return VARCHAR2 deterministic as begin return C_XDBWIKI_SCHEMA_URL; end;'||chr(10)||
'--'||chr(10)||
'function XHTML_NAMESPACE return VARCHAR2';

s:=s||' deterministic as begin return C_XHTML_NAMESPACE; end;'||chr(10)||
'--'||chr(10)||
'function XHTML_NO_PREFIX return VARCHAR2 deterministic as begin return C_XHMTL_NO_PREFIX; end;'||chr(10)||
'--'||chr(10)||
'function WIKI_ELEMENT return VARCHAR2 deterministic as begin return C_WIKI_ELEMENT; end;'||chr(10)||
'--'||chr(10)||
'procedure writeLogRecord(P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  XFILES_LOGGING.writeLogRecord(''/orawsv/';

s:=s||'XFILES/XFILES_WIKI_SERVICES/'',P_NAME, P_INIT_TIME, P_PARAMETERS);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure writeErrorRecord(P_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  XFILES_LOGGING.writeErrorRecord(''/orawsv/XFILES/XFILES_WIKI_SERVICES/'',P_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure handleException(P_MODULE_NAME VARCHA';

s:=s||'R2, P_INIT_TIME TIMESTAMP WITH TIME ZONE,P_PARAMETERS XMLTYPE)'||chr(10)||
'as'||chr(10)||
'  V_STACK_TRACE XMLType;'||chr(10)||
'  V_RESULT      boolean;'||chr(10)||
'begin'||chr(10)||
'  V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();'||chr(10)||
'  rollback; '||chr(10)||
'  writeErrorRecord(P_MODULE_NAME,P_INIT_TIME,P_PARAMETERS,V_STACK_TRACE);'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function createEmptyWikiPage '||chr(10)||
'return XMLType deterministic'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  ret';

s:=s||'urn XMLType(''<wiki:'' || WIKI_ELEMENT || '' '' || XDBWIKI_PREFIX_WIKI || '' '' || XHTML_NO_PREFIX || '' '' || XDB_NAMESPACES.XMLINSTANCE_PREFIX_XSI || '' xsi:schemaLocation="'' || XDBWIKI_NAMESPACE || '' '' || XDBWIKI_SCHEMA_URL || ''"/>'');'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CREATEWIKIPAGE(P_RESOURCE_PATH VARCHAR)'||chr(10)||
'as'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_STACK_TRACE       XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE :';

s:=s||'= SYSTIMESTAMP;'||chr(10)||
'  V_RESULT            BOOLEAN;'||chr(10)||
'  V_RESID             RAW(16);'||chr(10)||
'begin'||chr(10)||
'  select xmlElement("ResourcePath",P_RESOURCE_PATH)'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
'  dbms_output.put_line(createEmptyWikiPage().getClobVal());    '||chr(10)||
'  V_RESULT := DBMS_XDB.CREATERESOURCE(P_RESOURCE_PATH,createEmptyWikiPage());'||chr(10)||
'  V_RESID := DBMS_XDB_VERSION.MAKEVERSIONED(P_RESOURCE_PATH);'||chr(10)||
'  writeLogRecord(''CREAT';

s:=s||'EWIKIPAGE'',V_INIT,V_PARAMETERS);'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''CREATEWIKIPAGE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure UPDATEWIKIPAGE(P_RESOURCE_PATH VARCHAR, P_CONTENTS XMLTYPE)'||chr(10)||
'as'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_STACK_TRACE       XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_RESULT BOOLEAN;'||chr(10)||
'  V_NEW_WIKI_PAGE     XMLTYPE;'||chr(10)||
'  V_NEW_';

s:=s||'WIKI_DOC      DBMS_XMLDOM.DOMDocument;'||chr(10)||
'  V_NEW_WIKI_ROOT     DBMS_XMLDOM.DOMNode;'||chr(10)||
'  V_CONTENTS_ROOT     DBMS_XMLDOM.DOMElement;'||chr(10)||
'  V_NODE_LIST	      DBMS_XMLDOM.DOMNodeList;'||chr(10)||
'  V_NODE              DBMS_XMLDOM.DOMNode;'||chr(10)||
'  V_NEW_NODE          DBMS_XMLDOM.DOMNode;'||chr(10)||
'  '||chr(10)||
'  V_RESID             RAW(16); '||chr(10)||
'begin'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlE';

s:=s||'lement("UpdatedContent",P_CONTENTS)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  V_NEW_WIKI_PAGE := createEmptyWikiPage();'||chr(10)||
'  V_NEW_WIKI_DOC  := DBMS_XMLDOM.newDOMDocument(V_NEW_WIKI_PAGE);'||chr(10)||
'  V_NEW_WIKI_ROOT := DBMS_XMLDOM.makeNode(DBMS_XMLDOM.getDocumentElement(V_NEW_WIKI_DOC));'||chr(10)||
'  V_CONTENTS_ROOT := DBMS_XMLDOM.getDocumentElement(DBMS_XMLDOM.newDOMDocument(P_CONTENTS));'||chr(10)||
'  V_NODE          := ';

s:=s||'DBMS_XMLDOM.adoptNode(V_NEW_WIKI_DOC,DBMS_XMLDOM.makeNode(V_CONTENTS_ROOT));'||chr(10)||
'  V_NODE_LIST     := DBMS_XMLDOM.getChildNodes(V_NODE);'||chr(10)||
'  for i in 0..DBMS_XMLDOM.getLength(V_NODE_LIST) -1 loop'||chr(10)||
'    V_NODE := DBMS_XMLDOM.item(V_NODE_LIST,i);'||chr(10)||
'    V_NEW_NODE := DBMS_XMLDOM.appendChild(V_NEW_WIKI_ROOT,V_NODE);    '||chr(10)||
'  end loop;'||chr(10)||
'  '||chr(10)||
'  DBMS_XDB_VERSION.CheckOut(P_RESOURCE_PATH);  '||chr(10)||
''||chr(10)||
'  update RESOURCE_VIEW '||chr(10)||
'    ';

s:=s||'  set res = updateXML'||chr(10)||
'                ('||chr(10)||
'                  res,'||chr(10)||
'                  ''/Resource/DisplayName/text()'','||chr(10)||
'                  extractValue(res,''/Resource/DisplayName'')'||chr(10)||
'                ) '||chr(10)||
'    where equals_path(res,P_RESOURCE_PATH) = 1;'||chr(10)||
'  '||chr(10)||
'  update XDB_WIKI_TABLE w     '||chr(10)||
'     set object_value = V_NEW_WIKI_PAGE'||chr(10)||
'   where ref(w) = ( '||chr(10)||
'                    select extractValue(res,''/Resource/XMLRef'') '||chr(10)||
'';

s:=s||'                      from RESOURCE_VIEW'||chr(10)||
'                     where equals_path(res,P_RESOURCE_PATH) = 1'||chr(10)||
'                  );'||chr(10)||
''||chr(10)||
'  V_RESID := DBMS_XDB_VERSION.CheckIn(P_RESOURCE_PATH);'||chr(10)||
'  writeLogRecord(''UPDATEWIKIPAGE'',V_INIT,V_PARAMETERS);'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''UPDATEWIKIPAGE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--'||chr(10)||
'';

wwv_flow_api.create_install_script(
  p_id => 6417739311767711 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => ' XFILES_WIKI_SERVICES ',
  p_sequence=> 350,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'NOT_EXISTS',
  p_condition=> 'select 1 from '||chr(10)||
'   all_synonyms '||chr(10)||
' where owner = ''PUBLIC'' '||chr(10)||
'   and SYNONYM_NAME =  ''XFILES_WIKI_SERVICES''',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'--'||chr(10)||
'create or replace package XDB_REPOSITORY_SERVICES'||chr(10)||
'AUTHID CURRENT_USER'||chr(10)||
'as'||chr(10)||
'  procedure CHANGEOWNER(P_RESOURCE_PATH VARCHAR2, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure CHECKIN(P_RESOURCE_PATH VARCHAR2,P_COMMENT VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure CHECKOUT(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure COPYRESOURCE(P_RESOURCE_PATH ';

s:=s||'VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure CREATEFOLDER(P_FOLDER_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0);'||chr(10)||
'  procedure CREATEWIKIPAGE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0);'||chr(10)||
'  procedure CREATEZIPFILE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_RESOURCE_LIST XMLType,  P_TIMEZO';

s:=s||'NE_OFFSET NUMBER DEFAULT 0);'||chr(10)||
'  procedure DELETERESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE, P_FORCE BOOLEAN DEFAULT FALSE);  '||chr(10)||
'  procedure LINKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2, P_LINK_TYPE NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK);  '||chr(10)||
'  procedure LOCKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure MAKEVERSIONED(P_RESOURCE_PAT';

s:=s||'H VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure MOVERESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2);'||chr(10)||
'  procedure PUBLISHRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure RENAMERESOURCE(P_RESOURCE_PATH VARCHAR2, P_NEW_NAME VARCHAR2);'||chr(10)||
'  procedure SETACL(P_RESOURCE_PATH VARCHAR2, P_ACL_PATH VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure SETRSSFEED(';

s:=s||'P_FOLDER_PATH VARCHAR2, P_ENABLE BOOLEAN, P_ITEMS_CHANGED_IN VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure UNLOCKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure UNZIP(P_FOLDER_PATH VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DUPLICATE_ACTION VARCHAR2);'||chr(10)||
'  procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2';

s:=s||', P_LANGUAGE VARCHAR2, P_CHARACTER_SET VARCHAR2, P_DUPLICATE_POLICY VARCHAR2);'||chr(10)||
'  function  UPDATEPROPERTIES(P_RESOURCE_PATH VARCHAR2, P_NEW_VALUES XMLType, P_TIMEZONE_OFFSET NUMBER DEFAULT 0) return VARCHAR2;'||chr(10)||
'  end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--'||chr(10)||
'create or replace SYNONYM XDB_REPOSITORY_SERVICES for XDB_REPOSITORY_SERVICES'||chr(10)||
'/'||chr(10)||
'create or replace package body XDB_REPOSITORY_SERVICES'||chr(10)||
'as'||chr(10)||
'--'||chr(10)||
'function isFol';

s:=s||'der(P_RESOURCE_PATH VARCHAR2) '||chr(10)||
'return boolean'||chr(10)||
'as'||chr(10)||
'  V_IS_FOLDER BINARY_INTEGER := 0;'||chr(10)||
'begin'||chr(10)||
'  select count(*)'||chr(10)||
'    into V_IS_FOLDER'||chr(10)||
'    from RESOURCE_VIEW'||chr(10)||
'   where equals_path(RES, P_RESOURCE_PATH) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="true"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $r/R';

s:=s||'esource[@Container=xs:boolean("true")]'' passing RES as "r");'||chr(10)||
'  '||chr(10)||
'  return V_IS_FOLDER = 1;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure setContent(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB) '||chr(10)||
'as'||chr(10)||
'  V_LOB_LOCATOR BLOB;'||chr(10)||
'  V_XMLREF      REF XMLTYPE;'||chr(10)||
'begin'||chr(10)||
'  select extractValue(RES,''/Resource/XMLLob''), extractValue(RES,''/Resource/XMLRef'') '||chr(10)||
'    into V_LOB_LOCATOR, V_XMLREF'||chr(10)||
'    from RESOURCE_VIEW'||chr(10)||
'   where equals_path(RES,P_RESOURCE_P';

s:=s||'ATH) = 1'||chr(10)||
'     for update;'||chr(10)||
''||chr(10)||
'  if (V_LOB_LOCATOR is not null) then'||chr(10)||
'    DBMS_LOB.TRIM(V_LOB_LOCATOR,0);'||chr(10)||
'    DBMS_LOB.COPY(V_LOB_LOCATOR,P_CONTENT,DBMS_LOB.getLength(P_CONTENT),1,1);'||chr(10)||
'    return;'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'  if (V_XMLREF is not null) then'||chr(10)||
'    update RESOURCE_VIEW'||chr(10)||
'       set RES = updateXML(RES,''/Resource/Contents'',xmltype(P_CONTENT,nls_charset_id(''AL32UTF8'')))'||chr(10)||
'     where equals_path(RES,P_RESOURCE_P';

s:=s||'ATH) = 1;'||chr(10)||
'   return;'||chr(10)||
' end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure updateResourceMetadata(P_RESOURCE in out DBMS_XDBRESOURCE.XDBResource, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2, P_LANGUAGE VARCHAR2, P_CHARACTER_SET VARCHAR2)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  DBMS_XDBRESOURCE.setContentType(P_RESOURCE, P_CONTENT_TYPE);'||chr(10)||
'  DBMS_XDBRESOURCE.setComment(P_RESOURCE, P_DESCRIPTION);'||chr(10)||
'  DBMS_XDBRESOURCE.setLanguage(P_RESOURCE, P_LANGUAGE);';

s:=s||''||chr(10)||
'  DBMS_XDBRESOURCE.setCharacterSet(P_RESOURCE, P_CHARACTER_SET);'||chr(10)||
'  DBMS_XDBRESOURCE.save(P_RESOURCE);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CREATEFOLDER(P_FOLDER_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            BOOLEAN;'||chr(10)||
'  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;'||chr(10)||
'  V_RESID             RAW(16);'||chr(10)||
'begin'||chr(10)||
'  V_RESULT := DBMS_XDB.createFolder(P_FOLDER_PATH);'||chr(10)||
'    '||chr(10)||
'  ';

s:=s||'if (P_DESCRIPTION is not NULL) then'||chr(10)||
'    V_RESOURCE := DBMS_XDB.getResource(P_FOLDER_PATH);'||chr(10)||
'    DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_DESCRIPTION);'||chr(10)||
'    DBMS_XDBRESOURCE.save(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CREATEWIKIPAGE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            BOOLEAN;'||chr(10)||
'  V_RESOURCE          DBMS_XDBRESOURCE.XDBResour';

s:=s||'ce;'||chr(10)||
'  V_PARENT_FOLDER     VARCHAR2(1024) := SUBSTR(P_RESOURCE_PATH,1,INSTR(P_RESOURCE_PATH,''/'',-1) -1);'||chr(10)||
'  V_RESID             RAW(16);'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  XFILES_WIKI_SERVICES.createWikiPage(P_RESOURCE_PATH);'||chr(10)||
'    '||chr(10)||
'  if (P_DESCRIPTION is not NULL) then'||chr(10)||
'    V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);'||chr(10)||
'    DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_DESCRIPTION);'||chr(10)||
'    DBMS_XDBRESOURCE.save(V_RESOURCE);'||chr(10)||
'  en';

s:=s||'d if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure setFolderACLInternal(P_FOLDER_PATH VARCHAR2, P_ACL_PATH VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  cursor getDocumentListing'||chr(10)||
'  is'||chr(10)||
'  select path'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_path(res,1,P_FOLDER_PATH) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="false"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"';

s:=s||'; $res/Resource[@Container=xs:boolean("false")]'' passing RES as "res");'||chr(10)||
'begin'||chr(10)||
' '||chr(10)||
'  DBMS_XDB.setACL(P_FOLDER_PATH,P_ACL_PATH);'||chr(10)||
'  '||chr(10)||
'  for d in getDocumentListing loop'||chr(10)||
'    DBMS_XDB.setACL(d.PATH,P_ACL_PATH);'||chr(10)||
'  end loop;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure SETACL(P_RESOURCE_PATH VARCHAR2, P_ACL_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  cursor getFolderListing'||chr(10)||
'  is'||chr(10)||
'  select PATH'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_p';

s:=s||'ath(res,P_RESOURCE_PATH,1) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="true"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]'' passing RES as "res");'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  if (not P_DEEP) then'||chr(10)||
'    DBMS_XDB.setACL(P_RESOURCE_PATH,P_ACL_PATH);'||chr(10)||
'  else'||chr(10)||
'    if (isFolder(';

s:=s||'P_RESOURCE_PATH)) then    '||chr(10)||
'      -- Set the ACL for the folder and all documents'||chr(10)||
'      setFolderACLInternal(P_RESOURCE_PATH,P_ACL_PATH);'||chr(10)||
'      -- Set the ACL for all subfolders'||chr(10)||
'      for f in getFolderListing loop'||chr(10)||
'        setFolderACLInternal(f.PATH,P_ACL_PATH);'||chr(10)||
'      end loop;'||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CHANGEOWNER(P_RESOURCE_PATH VARCHAR2, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEF';

s:=s||'AULT FALSE)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  DBMS_XDB.CHANGEOWNER(P_RESOURCE_PATH,P_NEW_OWNER,P_DEEP);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure makeFolderVersionedInternal(P_FOLDER_PATH VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_RESID             RAW(16);'||chr(10)||
''||chr(10)||
'  cursor getDocumentListing'||chr(10)||
'  is'||chr(10)||
'  select path'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_path(res,1,P_FOLDER_PATH) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="false" and @IsVersioned="false"]'',XDB_NAMESPACES.RESOU';

s:=s||'RCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]'' passing RES as "res");'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'    '||chr(10)||
'  for d in getDocumentListing loop'||chr(10)||
'    V_RESID := DBMS_XDB_VERSION.makeVersioned(d.PATH);'||chr(10)||
'  end loop;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure MAKEVERSIONED(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  ';

s:=s||'V_RESID             RAW(16);'||chr(10)||
''||chr(10)||
'  cursor getFolderListing'||chr(10)||
'  is'||chr(10)||
'  select PATH'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_path(res,P_RESOURCE_PATH,1) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="true"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]'' passing RES as "';

s:=s||'res");'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  if (not isFolder(P_RESOURCE_PATH)) then    '||chr(10)||
'    V_RESID := DBMS_XDB_VERSION.makeVersioned(P_RESOURCE_PATH);'||chr(10)||
'  else'||chr(10)||
'    -- Version all documents in the current folder'||chr(10)||
'    makeFolderVersionedInternal(P_RESOURCE_PATH);'||chr(10)||
'    if (P_DEEP) then'||chr(10)||
'      for f in getFolderListing loop'||chr(10)||
'        makeFolderVersionedInternal(f.PATH);'||chr(10)||
'      end loop;'||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure checkOut';

s:=s||'FolderInternal(P_FOLDER_PATH VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_RESID             RAW(16);'||chr(10)||
''||chr(10)||
'  cursor getDocumentListing'||chr(10)||
'  is'||chr(10)||
'  select path'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_path(res,1,P_FOLDER_PATH) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="false" and @IsVersioned="true" and IsCheckedOut="false"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.o';

s:=s||'racle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]'' passing RES as "res");'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'    '||chr(10)||
'  for d in getDocumentListing loop'||chr(10)||
'    DBMS_XDB_VERSION.checkOut(d.PATH);'||chr(10)||
'  end loop;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CHECKOUT(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  cursor getFolderListing'||chr(10)||
'  is'||chr(10)||
'  select PATH'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_path(res,P_RESOURCE_PATH,1) = 1'||chr(10)||
'';

s:=s||'     and existsNode(res,''/r:Resource[@Container="true"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]'' passing RES as "res");'||chr(10)||
'begin'||chr(10)||
'  if (not isFolder(P_RESOURCE_PATH)) then    '||chr(10)||
'    DBMS_XDB_VERSION.checkOut(P_RESOURCE_PATH);'||chr(10)||
'  else'||chr(10)||
'    -- Check Out all docume';

s:=s||'nts in the current folder'||chr(10)||
'    checkOutFolderInternal(P_RESOURCE_PATH);'||chr(10)||
'    if (P_DEEP) then'||chr(10)||
'      for f in getFolderListing loop'||chr(10)||
'        checkOutFolderInternal(f.PATH);'||chr(10)||
'      end loop;'||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure checkInFolderInternal(P_FOLDER_PATH VARCHAR2, P_COMMENT VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;'||chr(10)||
'  V_RESID             RAW(16);'||chr(10)||
''||chr(10)||
'  cursor getDocumentLi';

s:=s||'sting'||chr(10)||
'  is'||chr(10)||
'  select path'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_path(res,1,P_FOLDER_PATH) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="false" and @IsVersioned="true" and IsCheckedOut="false"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]'' passing RES as "r';

s:=s||'es");'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'    '||chr(10)||
'  for d in getDocumentListing loop'||chr(10)||
'    if (P_COMMENT is not NULL) then'||chr(10)||
'      V_RESOURCE := DBMS_XDB.getResource(d.PATH);'||chr(10)||
'      DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_COMMENT);'||chr(10)||
'      DBMS_XDBRESOURCE.save(V_RESOURCE);'||chr(10)||
'     end if;'||chr(10)||
'    V_RESID := DBMS_XDB_VERSION.checkIn(d.PATH);'||chr(10)||
'  end loop;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CHECKIN(P_RESOURCE_PATH VARCHAR2, P_COMMENT VARCHAR2, P_DEEP BOOLEAN';

s:=s||' DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;'||chr(10)||
'  V_RESID             RAW(16);'||chr(10)||
''||chr(10)||
'  cursor getFolderListing'||chr(10)||
'  is'||chr(10)||
'  select PATH'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_path(res,P_RESOURCE_PATH,1) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="true"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBReso';

s:=s||'urce.xsd"; $res/Resource[@Container=xs:boolean("true")]'' passing RES as "res");'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  if (not isFolder(P_RESOURCE_PATH)) then    '||chr(10)||
'    if (P_COMMENT is not NULL) then'||chr(10)||
'      V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);'||chr(10)||
'      DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_COMMENT);'||chr(10)||
'      DBMS_XDBRESOURCE.save(V_RESOURCE);'||chr(10)||
'     end if;'||chr(10)||
'    V_RESID := DBMS_XDB_VERSION.checkIn(P_RESOURCE_PATH);'||chr(10)||
'  e';

s:=s||'lse'||chr(10)||
'    -- Check In all documents in the current folder'||chr(10)||
'    checkInFolderInternal(P_RESOURCE_PATH,P_COMMENT);'||chr(10)||
'    if (P_DEEP) then'||chr(10)||
'      for f in getFolderListing loop'||chr(10)||
'        checkInFolderInternal(f.PATH,P_COMMENT);'||chr(10)||
'      end loop;'||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure lockFolderInternal(P_FOLDER_PATH VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            BOOLEAN;'||chr(10)||
''||chr(10)||
'  cursor getDocumentListing'||chr(10)||
'  is'||chr(10)||
'  select path'||chr(10)||
'  ';

s:=s||'  from PATH_VIEW'||chr(10)||
'   where under_path(res,1,P_FOLDER_PATH) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="false" and @IsVersioned="true" and IsCheckedOut="false"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]'' passing RES as "res");'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'   '||chr(10)||
'  V_RESULT';

s:=s||' := DBMS_XDB.lockResource(P_FOLDER_PATH,FALSE,FALSE);'||chr(10)||
''||chr(10)||
'  for d in getDocumentListing loop'||chr(10)||
'    V_RESULT := DBMS_XDB.lockResource(d.PATH,FALSE,FALSE);'||chr(10)||
'  end loop;'||chr(10)||
''||chr(10)||
'  V_RESULT := DBMS_XDB.lockResource(P_FOLDER_PATH,FALSE,FALSE);'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure LOCKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            BOOLEAN;'||chr(10)||
''||chr(10)||
'  cursor getFolderListing'||chr(10)||
'  is'||chr(10)||
'  select PATH'||chr(10)||
'    from PATH_VIEW';

s:=s||''||chr(10)||
'   where under_path(res,P_RESOURCE_PATH,1) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="true"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]'' passing RES as "res");'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  if (not isFolder(P_RESOURCE_PATH)) then    '||chr(10)||
'    V_RESULT := DBMS_XDB.lockReso';

s:=s||'urce(P_RESOURCE_PATH,FALSE,FALSE);'||chr(10)||
'  else'||chr(10)||
'    lockFolderInternal(P_RESOURCE_PATH);'||chr(10)||
'    if (P_DEEP) then'||chr(10)||
'      for f in getFolderListing loop'||chr(10)||
'        lockFolderInternal(f.PATH);'||chr(10)||
'      end loop;'||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure unlockFolderInternal(P_FOLDER_PATH VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_TOKEN             VARCHAR2(64);'||chr(10)||
'  V_RESULT            BOOLEAN;'||chr(10)||
''||chr(10)||
'  cursor getDocumentListing'||chr(10)||
'  is'||chr(10)||
'  select path'||chr(10)||
'    ';

s:=s||'from PATH_VIEW'||chr(10)||
'   where under_path(res,1,P_FOLDER_PATH) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="false" and @IsVersioned="true" and IsCheckedOut="false"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]'' passing RES as "res");'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'    '||chr(10)||
'  DBMS_XDB.';

s:=s||'getlocktoken(P_FOLDER_PATH,V_TOKEN); '||chr(10)||
'  V_RESULT := DBMS_XDB.unlockresource(P_FOLDER_PATH,V_TOKEN);'||chr(10)||
''||chr(10)||
'  for d in getDocumentListing loop'||chr(10)||
'    DBMS_XDB.getlocktoken(d.PATH,V_TOKEN); '||chr(10)||
'    V_RESULT := DBMS_XDB.unlockresource(d.PATH,V_TOKEN);'||chr(10)||
'  end loop;'||chr(10)||
''||chr(10)||
'    DBMS_XDB.getlocktoken(P_FOLDER_PATH,V_TOKEN); '||chr(10)||
'  V_RESULT := DBMS_XDB.lockResource(P_FOLDER_PATH,FALSE,FALSE);'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure UNLOCKRESOURCE';

s:=s||'(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN)'||chr(10)||
'as'||chr(10)||
'  V_TOKEN             VARCHAR2(64);'||chr(10)||
'  V_RESULT            BOOLEAN;'||chr(10)||
''||chr(10)||
'  cursor getFolderListing'||chr(10)||
'  is'||chr(10)||
'  select PATH'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_path(res,P_RESOURCE_PATH,1) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="true"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/';

s:=s||'xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]'' passing RES as "res");'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'   if (not isFolder(P_RESOURCE_PATH)) then    '||chr(10)||
'    DBMS_XDB.getlocktoken(P_RESOURCE_PATH,V_TOKEN); '||chr(10)||
'    V_RESULT := DBMS_XDB.unlockresource(P_RESOURCE_PATH,V_TOKEN);'||chr(10)||
'  else'||chr(10)||
'    unlockFolderInternal(P_RESOURCE_PATH);'||chr(10)||
'    if (P_DEEP) then'||chr(10)||
'      for f in getFolderListing loop'||chr(10)||
'        unlockFolderInternal';

s:=s||'(f.PATH);'||chr(10)||
'      end loop;'||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure DELETERESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN, P_FORCE BOOLEAN)'||chr(10)||
'as'||chr(10)||
'  V_RESID             RAW(16);'||chr(10)||
'begin'||chr(10)||
'  if (P_DEEP) then'||chr(10)||
'    if (P_FORCE) then'||chr(10)||
'      DBMS_XDB.deleteResource(P_RESOURCE_PATH, DBMS_XDB.DELETE_RECURSIVE_FORCE);'||chr(10)||
'    else'||chr(10)||
'      DBMS_XDB.deleteResource(P_RESOURCE_PATH, DBMS_XDB.DELETE_RECURSIVE);'||chr(10)||
'    end if;'||chr(10)||
'  ';

s:=s||'else'||chr(10)||
'    if (P_FORCE) then'||chr(10)||
'      DBMS_XDB.deleteResource(P_RESOURCE_PATH, DBMS_XDB.DELETE_FORCE);'||chr(10)||
'    else'||chr(10)||
'      DBMS_XDB.deleteResource(P_RESOURCE_PATH, DBMS_XDB.DELETE_RESOURCE);'||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure SETRSSFEED(P_FOLDER_PATH VARCHAR2, P_ENABLE BOOLEAN, P_ITEMS_CHANGED_IN VARCHAR2, P_DEEP BOOLEAN)'||chr(10)||
'as  '||chr(10)||
'  cursor getFolderListing'||chr(10)||
'  is'||chr(10)||
'  select PATH'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where und';

s:=s||'er_path(res,P_FOLDER_PATH,1) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="true"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]'' passing RES as "res");'||chr(10)||
'  '||chr(10)||
'begin'||chr(10)||
'  if (P_ENABLE) THEN'||chr(10)||
'    XFILES_UTILITIES.enableRSSFeed(P_FOLDER_PATH,P_ITEMS_CHANGED_IN);'||chr(10)||
' ';

s:=s||' ELSE'||chr(10)||
'    XFILES_UTILITIES.disableRSSFeed(P_FOLDER_PATH);'||chr(10)||
'  END IF;'||chr(10)||
''||chr(10)||
'  if (P_DEEP) then'||chr(10)||
'    if (P_ENABLE) THEN'||chr(10)||
'      XFILES_UTILITIES.enableRSSFeed(P_FOLDER_PATH,P_ITEMS_CHANGED_IN);'||chr(10)||
'      for f in getFolderListing loop'||chr(10)||
'        XFILES_UTILITIES.enableRSSFeed(f.PATH,P_ITEMS_CHANGED_IN);'||chr(10)||
'      end loop;'||chr(10)||
'    ELSE'||chr(10)||
'      XFILES_UTILITIES.disableRSSFeed(P_FOLDER_PATH);'||chr(10)||
'      for f in getFolderListing lo';

s:=s||'op'||chr(10)||
'        XFILES_UTILITIES.disableRSSFeed(f.PATH);'||chr(10)||
'      end loop;'||chr(10)||
'    END IF;'||chr(10)||
'  end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure LINKRESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_LINK_TYPE NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  DBMS_XDB.link(P_RESOURCE_PATH,P_TARGET_FOLDER,substr(P_RESOURCE_PATH,instr(P_RESOURCE_PATH,''/'',-1)+1),P_LINK_TYPE);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure MOVERESOURCE(P_RESOURCE_PATH VA';

s:=s||'RCHAR2, P_TARGET_FOLDER VARCHAR2)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  DBMS_XDB.renameResource(P_RESOURCE_PATH,P_TARGET_FOLDER,substr(P_RESOURCE_PATH,instr(P_RESOURCE_PATH,''/'',-1)+1));'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure RENAMERESOURCE(P_RESOURCE_PATH VARCHAR2, P_NEW_NAME VARCHAR2)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  DBMS_XDB.renameResource(P_RESOURCE_PATH,substr(P_RESOURCE_PATH,1,instr(P_RESOURCE_PATH,''/'',-1)-1),P_NEW_NAME);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure copyResourceInternal(';

s:=s||'P_SOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_TARGET_NAME VARCHAR2(256);'||chr(10)||
'  V_TARGET_PATH VARCHAR2(1024);'||chr(10)||
'  V_RESULT      BOOLEAN;'||chr(10)||
'begin'||chr(10)||
'  V_TARGET_NAME := substr(P_SOURCE_PATH,instr(P_SOURCE_PATH,''/'',-1)+1);'||chr(10)||
'  V_TARGET_PATH := P_TARGET_FOLDER || ''/'' || V_TARGET_NAME;      '||chr(10)||
'  if (not DBMS_XDB.existsResource(V_TARGET_PATH)) then'||chr(10)||
'    V_RESULT := DBMS_XDB.createResource(V_TARGET_PATH,xdburi';

s:=s||'type(P_SOURCE_PATH).getBlob());'||chr(10)||
'  end if;'||chr(10)||
'end;    '||chr(10)||
'--'||chr(10)||
'procedure copyFolderInternal(P_FOLDER_PATH VARCHAR2,P_TARGET_FOLDER VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_TARGET_NAME VARCHAR2(256);'||chr(10)||
'  V_TARGET_PATH VARCHAR2(1024);'||chr(10)||
'  V_RESOURCE    DBMS_XDBRESOURCE.XDBResource;'||chr(10)||
'  V_RESULT      BOOLEAN;'||chr(10)||
'  '||chr(10)||
'  cursor getDocumentListing'||chr(10)||
'  is'||chr(10)||
'  select path'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_path(res,1,P_FOLDER_PATH) = 1'||chr(10)||
'     and existsNo';

s:=s||'de(res,''/r:Resource[@Container="false"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]'' passing RES as "res");'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  V_TARGET_NAME := substr(P_FOLDER_PATH,instr(P_FOLDER_PATH,''/'',-1)+1);'||chr(10)||
'  V_TARGET_PATH := P_TARGET_FOLDER || ''/'' || V_TARGET_NAME;      '||chr(10)||
''||chr(10)||
'  i';

s:=s||'f (not DBMS_XDB.existsResource(V_TARGET_PATH)) then'||chr(10)||
'    V_RESULT := DBMS_XDB.createFolder(V_TARGET_PATH);'||chr(10)||
'    V_RESOURCE := DBMS_XDB.getResource(V_TARGET_PATH);'||chr(10)||
'    DBMS_XDBRESOURCE.setComment(V_RESOURCE,''Copy of '' || P_FOLDER_PATH);'||chr(10)||
'    DBMS_XDBRESOURCE.save(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'  for d in getDocumentListing loop'||chr(10)||
'    copyResourceInternal(d.PATH,V_TARGET_PATH);'||chr(10)||
'  end loop;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedur';

s:=s||'e COPYRESOURCE(P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  V_TARGET_FOLDER     VARCHAR2(1024);'||chr(10)||
'  V_TARGET_NAME       VARCHAR2(256);'||chr(10)||
'  V_RELATIVE_PATH     VARCHAR2(1024);'||chr(10)||
''||chr(10)||
'  cursor getFolderListing'||chr(10)||
'  is'||chr(10)||
'  select PATH'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_path(res,P_RESOURCE_PATH,1) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="true"]'',XDB_NAMESPACES.RESO';

s:=s||'URCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]'' passing RES as "res");'||chr(10)||
'  '||chr(10)||
'begin'||chr(10)||
'  if (not isFolder(P_RESOURCE_PATH)) then    '||chr(10)||
'    copyResourceInternal(P_RESOURCE_PATH,XDB_CONSTANTS.USER_PUBLIC_FOLDER);'||chr(10)||
'  else'||chr(10)||
'    V_TARGET_NAME   := substr(P_RESOURCE_PATH,instr(P_RESOURCE_PATH,''/'',';

s:=s||'-1)+1);'||chr(10)||
'    V_TARGET_FOLDER := XDB_CONSTANTS.USER_PUBLIC_FOLDER || ''/'' || V_TARGET_NAME;'||chr(10)||
'    if (not P_DEEP) then'||chr(10)||
'      copyFolderInternal(V_TARGET_FOLDER,XDB_CONSTANTS.USER_PUBLIC_FOLDER);'||chr(10)||
'    else'||chr(10)||
'      for f in getFolderListing loop'||chr(10)||
'        V_RELATIVE_PATH := substr(f.PATH,length(P_RESOURCE_PATH) + 1);'||chr(10)||
'        V_RELATIVE_PATH := substr(V_RELATIVE_PATH,1,instr(V_RELATIVE_PATH,''/'',-1)-1);'||chr(10)||
'       ';

s:=s||' copyFolderInternal(f.PATH,XDB_CONSTANTS.USER_PUBLIC_FOLDER || V_RELATIVE_PATH);'||chr(10)||
'      end loop;'||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure publishResourceInternal(P_SOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_TARGET_NAME VARCHAR2(256);'||chr(10)||
'  V_TARGET_PATH VARCHAR2(1024);'||chr(10)||
'begin'||chr(10)||
'  V_TARGET_NAME := substr(P_SOURCE_PATH,instr(P_SOURCE_PATH,''/'',-1)+1);'||chr(10)||
'  V_TARGET_PATH := P_TARGET_FOLDER || ''/'' || ';

s:=s||'V_TARGET_NAME;      '||chr(10)||
'  if (not DBMS_XDB.existsResource(V_TARGET_PATH)) then'||chr(10)||
'    DBMS_XDB.link(P_SOURCE_PATH,P_TARGET_FOLDER,V_TARGET_NAME,DBMS_XDB.LINK_TYPE_WEAK);'||chr(10)||
'  end if;'||chr(10)||
'end;    '||chr(10)||
'--'||chr(10)||
'procedure publishFolderInternal(P_FOLDER_PATH VARCHAR2,P_TARGET_FOLDER VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_TARGET_NAME VARCHAR2(256);'||chr(10)||
'  V_TARGET_PATH VARCHAR2(1024);'||chr(10)||
'  V_RESOURCE    DBMS_XDBRESOURCE.XDBResource;'||chr(10)||
'  V_RESULT      BOOLE';

s:=s||'AN;'||chr(10)||
''||chr(10)||
'  cursor getDocumentListing'||chr(10)||
'  is'||chr(10)||
'  select path'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   where under_path(res,1,P_FOLDER_PATH) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="false"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("false")]'' passing RES as "res");'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  V_TARGE';

s:=s||'T_NAME := substr(P_FOLDER_PATH,instr(P_FOLDER_PATH,''/'',-1)+1);'||chr(10)||
'  V_TARGET_PATH := P_TARGET_FOLDER || ''/'' || V_TARGET_NAME;      '||chr(10)||
''||chr(10)||
'  if (not DBMS_XDB.existsResource(V_TARGET_PATH)) then'||chr(10)||
'    V_RESULT := DBMS_XDB.createFolder(V_TARGET_PATH);'||chr(10)||
'    V_RESOURCE := DBMS_XDB.getResource(V_TARGET_PATH);'||chr(10)||
'    DBMS_XDBRESOURCE.setComment(V_RESOURCE,''Published version of '' || P_FOLDER_PATH);'||chr(10)||
'    DBMS_XDBRESOURCE';

s:=s||'.save(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'  for d in getDocumentListing loop'||chr(10)||
'    publishResourceInternal(d.PATH,V_TARGET_PATH);'||chr(10)||
'  end loop;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure PUBLISHRESOURCE(P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  V_TARGET_FOLDER     VARCHAR2(1024);'||chr(10)||
'  V_TARGET_NAME       VARCHAR2(256);'||chr(10)||
'  V_RELATIVE_PATH     VARCHAR2(1024);'||chr(10)||
''||chr(10)||
'  cursor getFolderListing'||chr(10)||
'  is'||chr(10)||
'  select PATH'||chr(10)||
'    from PATH_V';

s:=s||'IEW'||chr(10)||
'   where under_path(res,P_RESOURCE_PATH,1) = 1'||chr(10)||
'     and existsNode(res,''/r:Resource[@Container="true"]'',XDB_NAMESPACES.RESOURCE_PREFIX_R) = 1;'||chr(10)||
'  -- and xmlExists(''declare default element namespace "http://xmlns.oracle.com/xdb/XDBResource.xsd"; $res/Resource[@Container=xs:boolean("true")]'' passing RES as "res");'||chr(10)||
'  '||chr(10)||
'begin'||chr(10)||
'  if (not DBMS_XDB.existsResource(XDB_CONSTANTS.USER_PUBLIC_FOLDER)) then'||chr(10)||
'';

s:=s||'    XDB_UTILITIES.createPublicFolder();'||chr(10)||
'  else'||chr(10)||
'    XDB_UTILITIES.setPublicIndexPageContent();'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'  if (not isFolder(P_RESOURCE_PATH)) then    '||chr(10)||
'    publishResourceInternal(P_RESOURCE_PATH,XDB_CONSTANTS.USER_PUBLIC_FOLDER);'||chr(10)||
'  else'||chr(10)||
'    V_TARGET_NAME   := substr(P_RESOURCE_PATH,instr(P_RESOURCE_PATH,''/'',-1)+1);'||chr(10)||
'    V_TARGET_FOLDER := XDB_CONSTANTS.USER_PUBLIC_FOLDER || ''/'' || V_TARGET_NAME;'||chr(10)||
'';

s:=s||'    if (not P_DEEP) then'||chr(10)||
'      publishFolderInternal(V_TARGET_FOLDER,XDB_CONSTANTS.USER_PUBLIC_FOLDER);'||chr(10)||
'    else'||chr(10)||
'      for f in getFolderListing loop'||chr(10)||
'        V_RELATIVE_PATH := substr(f.PATH,length(P_RESOURCE_PATH) + 1);'||chr(10)||
'        V_RELATIVE_PATH := substr(V_RELATIVE_PATH,1,instr(V_RELATIVE_PATH,''/'',-1)-1);'||chr(10)||
'        publishFolderInternal(f.PATH,XDB_CONSTANTS.USER_PUBLIC_FOLDER || V_RELATIVE_PATH);'||chr(10)||
'  ';

s:=s||'    end loop;'||chr(10)||
'    end if;'||chr(10)||
'  end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure UPLOADRESOURCE(P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2, P_LANGUAGE VARCHAR2, P_CHARACTER_SET VARCHAR2, P_DUPLICATE_POLICY VARCHAR2)'||chr(10)||
'as'||chr(10)||
'/*'||chr(10)||
'    Positibilites'||chr(10)||
'       1. Item does not exist or Item Exists and duplicate policy is RAISE;'||chr(10)||
''||chr(10)||
'       2 . Item is not versioned'||chr(10)||
'    //     - Version it'||chr(10)||
'    //';

s:=s||'     - Check it out'||chr(10)||
'    //     - Update it'||chr(10)||
'    //     - Check it back in'||chr(10)||
'    // 2. Item is versioned but is not checked out'||chr(10)||
'    //    - Check it out'||chr(10)||
'    //    - Update it'||chr(10)||
'    //    - Check it back in'||chr(10)||
'    // 3. Item exists and is checked out'||chr(10)||
'    //    - Update it. '||chr(10)||
'    //    - Do not check it back in.'||chr(10)||
'*/'||chr(10)||
''||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_STACK_TRACE       XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP ';

s:=s||'WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_RESULT            BOOLEAN;'||chr(10)||
'  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;'||chr(10)||
'  V_RESOURCE_ELEMENT  DBMS_XMLDOM.DOMElement;'||chr(10)||
'  V_RESID             RAW(16);'||chr(10)||
'begin'||chr(10)||
'  if (not DBMS_XDB.existsResource(P_RESOURCE_PATH)) then'||chr(10)||
'    V_RESULT := DBMS_XDB.createResource(P_RESOURCE_PATH,P_CONTENT);'||chr(10)||
'    DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);'||chr(10)||
'    V_RESOURCE := DBMS_XDB.';

s:=s||'getResource(P_RESOURCE_PATH);'||chr(10)||
'    updateResourceMetadata(V_RESOURCE, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET);'||chr(10)||
'    return;'||chr(10)||
'  end if;      '||chr(10)||
''||chr(10)||
'  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.RAISE_ERROR) then'||chr(10)||
'    -- Error will be thrown if item exists'||chr(10)||
'    V_RESULT := DBMS_XDB.createResource(P_RESOURCE_PATH,P_CONTENT);'||chr(10)||
'    V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);'||chr(10)||
'    updateReso';

s:=s||'urceMetadata(V_RESOURCE, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET);'||chr(10)||
'    return;'||chr(10)||
'  end if;'||chr(10)||
'    '||chr(10)||
'  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.OVERWRITE) then'||chr(10)||
'    V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);'||chr(10)||
'    updateResourceMetadata(V_RESOURCE, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET);'||chr(10)||
'    setContent(P_RESOURCE_PATH,P_CONTENT);'||chr(10)||
'    -- DBMS_XDBRESOURCE.setCon';

s:=s||'tent(V_RESOURCE,P_CONTENT);'||chr(10)||
'    DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  if (P_DUPLICATE_POLICY = XDB_CONSTANTS.VERSION) then'||chr(10)||
'    V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);'||chr(10)||
'    V_RESOURCE_ELEMENT := DBMS_XMLDOM.getDocumentElement(DBMS_XDBRESOURCE.makeDocument(V_RESOURCE));'||chr(10)||
'    if (DBMS_XMLDOM.getAttribute(V_RESOURCE_ELEMENT,''IsVersion'') = ''false'') then'||chr(10)||
'      V_RESID := ';

s:=s||'DBMS_XDB_VERSION.makeVersioned(P_RESOURCE_PATH);'||chr(10)||
'    end if;'||chr(10)||
'    if (DBMS_XMLDOM.getAttribute(V_RESOURCE_ELEMENT,''IsCheckedOut'') = ''true'') then'||chr(10)||
'      updateResourceMetadata(V_RESOURCE, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET);'||chr(10)||
'      setContent(P_RESOURCE_PATH,P_CONTENT);'||chr(10)||
'      DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);'||chr(10)||
'      -- DBMS_XDBRESOURCE.setContent(V_RESOURCE,P_CONTENT';

s:=s||');'||chr(10)||
'    else'||chr(10)||
'      DBMS_XDB_VERSION.checkOut(P_RESOURCE_PATH);'||chr(10)||
'      updateResourceMetadata(V_RESOURCE, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET);'||chr(10)||
'      setContent(P_RESOURCE_PATH,P_CONTENT);'||chr(10)||
'      -- DBMS_XDBRESOURCE.setContent(V_RESOURCE,P_CONTENT);'||chr(10)||
'      V_RESID := DBMS_XDB_VERSION.checkIn(P_RESOURCE_PATH);'||chr(10)||
'      DBMS_XDB.refreshContentSize(P_RESOURCE_PATH);'||chr(10)||
'    end if;	       ';

s:=s||'  '||chr(10)||
'    return;'||chr(10)||
'  end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CREATEZIPFILE(P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_RESOURCE_LIST XMLType,  P_TIMEZONE_OFFSET NUMBER DEFAULT 0)'||chr(10)||
'as'||chr(10)||
'  V_ZIP_PARAMETERS    XMLtype;'||chr(10)||
'  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;'||chr(10)||
'  V_PARENT_FOLDER     VARCHAR2(1024) := SUBSTR(P_RESOURCE_PATH,1,INSTR(P_RESOURCE_PATH,''/'',-1) -1);'||chr(10)||
'  V_RESID             RAW(16);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  selec';

s:=s||'t xmlElement'||chr(10)||
'         ('||chr(10)||
'           "Parameters",'||chr(10)||
'           xmlElement("ZipFileName",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),'||chr(10)||
'           xmlElement("LogFileName",null),'||chr(10)||
'           P_RESOURCE_LIST,'||chr(10)||
'           xmlElement("RecursiveOperation",''TRUE'')'||chr(10)||
'         )'||chr(10)||
'    into V_ZIP_PARAMETERS '||chr(10)||
'    from DUAL;'||chr(10)||
'    '||chr(10)||
'  XDB_IMPORT_UTILITIES.zip(V_ZIP_PARAMETERS);'||chr(10)||
'    '||chr(10)||
'  if (P';

s:=s||'_DESCRIPTION is not NULL) then'||chr(10)||
'    V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);'||chr(10)||
'    DBMS_XDBRESOURCE.setComment(V_RESOURCE,P_DESCRIPTION);'||chr(10)||
'    DBMS_XDBRESOURCE.save(V_RESOURCE);'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure UNZIP(P_FOLDER_PATH VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DUPLICATE_ACTION VARCHAR2)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  XDB_IMPORT_UTILITIES.unzip(P_RESOURCE_PATH,P_FOLDER_PATH,NULL,P_DUPLICATE_ACTION);'||chr(10)||
'end;';

s:=s||''||chr(10)||
'--'||chr(10)||
'function UPDATEPROPERTIES(P_RESOURCE_PATH  VARCHAR2, P_NEW_VALUES XMLType, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)'||chr(10)||
'return VARCHAR2'||chr(10)||
'as'||chr(10)||
'  V_RESOURCE          DBMS_XDBRESOURCE.XDBResource;'||chr(10)||
'  V_RESOURCE_DOCUMENT DBMS_XMLDOM.DOMDocument;'||chr(10)||
'  V_UPDATE_DOCUMENT   DBMS_XMLDOM.DOMDocument;'||chr(10)||
''||chr(10)||
'  V_DISPLAY_NAME  VARCHAR2(128);'||chr(10)||
''||chr(10)||
'  V_RESOURCE_ELEMENT  DBMS_XMLDOM.DOMElement;'||chr(10)||
'  V_UPDATE_ELEMENT    DBMS_XMLDOM.DOMEl';

s:=s||'ement;'||chr(10)||
''||chr(10)||
'  V_NODE_LIST         DBMS_XMLDOM.DOMNodeList;'||chr(10)||
'  V_SOURCE_NODE       DBMS_XMLDOM.DOMNode;'||chr(10)||
'  V_TARGET_NODE       DBMS_XMLDOM.DOMNode;'||chr(10)||
'  '||chr(10)||
'  V_NODE_MAP          DBMS_XMLDOM.DOMNamedNodeMap;'||chr(10)||
'  '||chr(10)||
'  V_NODE_NAME         VARCHAR2(512);'||chr(10)||
'  '||chr(10)||
'  V_TARGET_FOLDER     VARCHAR2(1024); '||chr(10)||
'  V_LINK_NAME         VARCHAR2(256); '||chr(10)||
'  V_NEW_VALUE         VARCHAR2(1024);'||chr(10)||
'  V_RESOURCE_PATH     VARCHAR2(1024) := P_RESOU';

s:=s||'RCE_PATH;'||chr(10)||
''||chr(10)||
'begin  '||chr(10)||
'  V_RESOURCE := DBMS_XDB.getResource(P_RESOURCE_PATH);'||chr(10)||
'  V_RESOURCE_DOCUMENT := DBMS_XDBRESOURCE.makeDocument(V_RESOURCE);'||chr(10)||
'  V_RESOURCE_ELEMENT  := DBMS_XMLDOM.getDocumentElement(V_RESOURCE_DOCUMENT);'||chr(10)||
''||chr(10)||
'  V_UPDATE_DOCUMENT   := DBMS_XMLDOM.newDOMDocument(P_NEW_VALUES);'||chr(10)||
'  V_UPDATE_ELEMENT    := DBMS_XMLDOM.getDocumentElement(V_UPDATE_DOCUMENT);'||chr(10)||
'  '||chr(10)||
'  V_NODE_LIST := DBMS_XMLDOM.getC';

s:=s||'hildNodes(dbms_xmldom.makeNode(V_UPDATE_ELEMENT));'||chr(10)||
'  for i in 0..DBMS_XMLDOM.getLength(V_NODE_LIST) -1 loop'||chr(10)||
'    V_SOURCE_NODE := DBMS_XMLDOM.item(V_NODE_LIST,i);'||chr(10)||
'    V_NODE_NAME := DBMS_XMLDOM.getNodeName(V_SOURCE_NODE);'||chr(10)||
'    V_NEW_VALUE := DBMS_XMLDOM.getNodeValue(DBMS_XMLDOM.getFirstChild(V_SOURCE_NODE));'||chr(10)||
'    if (V_NODE_NAME = ''DisplayName'') then'||chr(10)||
'      DBMS_XDBRESOURCE.setDisplayName(V_RESOURCE,V';

s:=s||'_NEW_VALUE);'||chr(10)||
'      if (DBMS_XMLDOM.getAttribute(DBMS_XMLDOM.makeElement(V_SOURCE_NODE),''renameLinks'') = ''true'') then'||chr(10)||
'        V_LINK_NAME := V_NEW_VALUE;'||chr(10)||
'      end if;'||chr(10)||
'    end if;'||chr(10)||
'    if (V_NODE_NAME = ''Author'') then'||chr(10)||
'      DBMS_XDBRESOURCE.setAuthor(V_RESOURCE,V_NEW_VALUE);'||chr(10)||
'    end if;'||chr(10)||
'    if (V_NODE_NAME = ''Comment'') then'||chr(10)||
'      DBMS_XDBRESOURCE.setComment(V_RESOURCE,V_NEW_VALUE);'||chr(10)||
'    end if;'||chr(10)||
'    i';

wwv_flow_api.create_install_script(
  p_id => 2393829100452592 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XDB_REPOSITORY_SERVICES',
  p_sequence=> 360,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'NOT_EXISTS',
  p_condition=> 'select 1 from '||chr(10)||
'   all_synonyms '||chr(10)||
' where owner = ''PUBLIC'' '||chr(10)||
'   and SYNONYM_NAME =  ''XDB_REPOSITORY_SERVICES''',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
begin
s:=s||'f (V_NODE_NAME = ''Language'') then'||chr(10)||
'      DBMS_XDBRESOURCE.setLanguage(V_RESOURCE,V_NEW_VALUE);'||chr(10)||
'    end if;'||chr(10)||
'    if (V_NODE_NAME = ''CharacterSet'') then'||chr(10)||
'      DBMS_XDBRESOURCE.setCharacterSet(V_RESOURCE,V_NEW_VALUE);'||chr(10)||
'    end if;'||chr(10)||
'  end loop;  '||chr(10)||
'  '||chr(10)||
'  DBMS_XDBRESOURCE.save(V_RESOURCE);'||chr(10)||
'  '||chr(10)||
'  if (V_LINK_NAME is not null) then'||chr(10)||
'    V_TARGET_FOLDER := substr(P_RESOURCE_PATH,1,instr(P_RESOURCE_PATH,''/'',-1)-1);'||chr(10)||
'';

s:=s||'    if (V_TARGET_FOLDER is NULL) then'||chr(10)||
'      V_TARGET_FOLDER := ''/'';'||chr(10)||
'    end if;'||chr(10)||
'    V_RESOURCE_PATH := V_TARGET_FOLDER || ''/'' || V_LINK_NAME;'||chr(10)||
'    DBMS_XDB.renameResource(P_RESOURCE_PATH,V_TARGET_FOLDER,V_LINK_NAME);'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'  return V_RESOURCE_PATH;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--'||chr(10)||
'';

wwv_flow_api.append_to_install_script(
  p_id => 2393829100452592 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_script_clob => s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'declare'||chr(10)||
'  non_existant_table exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( non_existant_table , -942 );'||chr(10)||
'begin'||chr(10)||
'--'||chr(10)||
'  begin'||chr(10)||
'    execute immediate ''DROP TABLE TREE_STATE_TABLE'';'||chr(10)||
'  exception'||chr(10)||
'    when non_existant_table  then'||chr(10)||
'      null;'||chr(10)||
'  end;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'create table TREE_STATE_TABLE'||chr(10)||
'('||chr(10)||
'  SESSION_ID    number(38),'||chr(10)||
'  PAGE_NUMBER   number(38),'||chr(10)||
'  TREE_STATE    XMLTYPE'||chr(10)||
')'||chr(10)||
'XMLTYPE column TREE_STATE store as SECUREFILE BINA';

s:=s||'RY XML'||chr(10)||
'/'||chr(10)||
'create or replace package XFILES_APEX_SERVICES'||chr(10)||
'AUTHID CURRENT_USER'||chr(10)||
'as'||chr(10)||
'  FILLER_ICON                  constant VARCHAR2(700) := ''/XFILES/APEX/lib/graphics/t.gif'';'||chr(10)||
''||chr(10)||
'  FILE_PROPERTIES_ICON         constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/pageProperties.png'';'||chr(10)||
'  FILE_CHECKED_OUT_ICON        constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/checkedOutDocument.png'';'||chr(10)||
'  FILE_VERSION';

s:=s||'ED_ICON          constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/versionedDocument.png'';'||chr(10)||
'  FILE_LOCKED_ICON             constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/lockedDocument.png'';'||chr(10)||
''||chr(10)||
'  REPOSITORY_ICON              constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/sql.png'';'||chr(10)||
'  FOLDER_ICON                  constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/readOnlyFolderClosed.png'';'||chr(10)||
'  IMAGE';

s:=s||'_JPEG_ICON              constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/imageJPEG.png'';'||chr(10)||
'  IMAGE_GIF_ICON               constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/imageGIF.png'';'||chr(10)||
'  XML_ICON                     constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/xmlDocument.png'';'||chr(10)||
'  TEXT_ICON                    constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/xmlDocument.png'';'||chr(10)||
'  DEFAULT_ICON  ';

s:=s||'               constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/textDocument.png'';  '||chr(10)||
'  '||chr(10)||
'  READONLY_FOLDER_OPEN_ICON    constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/readOnlyFolderOpen.png'';'||chr(10)||
'  READONLY_FOLDER_CLOSED_ICON  constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/readOnlyFolderClosed.png'';'||chr(10)||
'  WRITE_FOLDER_OPEN_ICON       constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/writeFolderOpen.';

s:=s||'png'';'||chr(10)||
'  WRITE_FOLDER_CLOSED_ICON     constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/writeFolderClosed.png'';'||chr(10)||
'  SHOW_CHILDREN_ICON           constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/showChildren.png'' ;'||chr(10)||
'  HIDE_CHILDREN_ICON           constant VARCHAR2(700) := ''/XFILES/APEX/lib/icons/hideChildren.png'' ;'||chr(10)||
''||chr(10)||
'  FOLDER_TREE_STYLESHEET constant VARCHAR2(700) := ''/XFILES/APEX/lib/xsl/showTree.xsl''';

s:=s||';  '||chr(10)||
'  '||chr(10)||
'  CONTENT_TYPE_JPEG      constant VARCHAR2(32) := ''image/jpeg'';'||chr(10)||
'  CONTENT_TYPE_GIF       constant VARCHAR2(32) := ''image/gif'';'||chr(10)||
'  CONTENT_TYPE_XML_CSX   constant VARCHAR2(32) := ''application/vnd.oracle-csx'';'||chr(10)||
'  CONTENT_TYPE_XML_TEXT  constant VARCHAR2(32) := ''text/xml'';'||chr(10)||
''||chr(10)||
'  TYPE FOLDER_INFO IS RECORD'||chr(10)||
'  ('||chr(10)||
'    NAME VARCHAR2(700),'||chr(10)||
'    PATH VARCHAR2(700),'||chr(10)||
'    ICON VARCHAR2(700)'||chr(10)||
'  );'||chr(10)||
''||chr(10)||
'  TYPE FOLDER';

s:=s||'_INFO_TABLE IS TABLE OF FOLDER_INFO;'||chr(10)||
'   '||chr(10)||
'  TYPE DIRECTORY_ITEM is RECORD'||chr(10)||
'  (  '||chr(10)||
'    nPATH                                               VARCHAR2(1024 CHAR),'||chr(10)||
'    nRESID                                              RAW(16),'||chr(10)||
'    nIS_FOLDER                                          VARCHAR2(5),'||chr(10)||
'    nVERSION_ID                                         NUMBER(38),'||chr(10)||
'    nCHECKED_OUT                          ';

s:=s||'              VARCHAR2(5),'||chr(10)||
'    nCREATION_DATE                                      TIMESTAMP(6),'||chr(10)||
'    nMODIFICATION_DATE                                  TIMESTAMP(6),'||chr(10)||
'    nAUTHOR                                             VARCHAR2(128),'||chr(10)||
'    nDISPLAY_NAME                                       VARCHAR2(128),'||chr(10)||
'    nCOMMENT                                            VARCHAR2(128),'||chr(10)||
'    nLANGUAGE       ';

s:=s||'                                    VARCHAR2(128),'||chr(10)||
'    nCHARACTER_SET                                      VARCHAR2(128),'||chr(10)||
'    nCONTENT_TYPE                                       VARCHAR2(128),'||chr(10)||
'    nOWNED_BY                                           VARCHAR2(64),'||chr(10)||
'    nCREATED_BY                                         VARCHAR2(64),'||chr(10)||
'    nLAST_MODIFIED_BY                                   VARCHAR2(64';

s:=s||'),'||chr(10)||
'    nCHECKED_OUT_BY                                     VARCHAR2(700),'||chr(10)||
'    nLOCK_BUFFER                                        VARCHAR2(128),'||chr(10)||
'    nVERSION_SERIES_ID                                  RAW(16),'||chr(10)||
'    nACL_OID                                            RAW(16),'||chr(10)||
'    nSCHEMA_OID                                         RAW(16),'||chr(10)||
'    nGLOBAL_ELEMENT_ID                                  NUMB';

s:=s||'ER(38),'||chr(10)||
'    nLINK_NAME                                          VARCHAR2(128),'||chr(10)||
'    nCHILD_PATH                                         VARCHAR2(1024 CHAR),'||chr(10)||
'    nICON_PATH                                          VARCHAR2(1024 CHAR),'||chr(10)||
'    nTARGET_URL                                         VARCHAR2(1024 CHAR),'||chr(10)||
'    nRESOURCE_STATUS                                    VARCHAR2(1024 CHAR)'||chr(10)||
'  );'||chr(10)||
'  '||chr(10)||
'  TYPE';

s:=s||' DIRECTORY_LISTING IS TABLE OF DIRECTORY_ITEM;'||chr(10)||
'   '||chr(10)||
'  procedure CHANGEOWNER(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure CHECKIN(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2,P_COMMENT VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure CHECKOUT(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  proc';

s:=s||'edure COPYRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure CREATEFOLDER(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0);'||chr(10)||
'  procedure CREATEWIKIPAGE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0);'||chr(10)||
'  procedu';

s:=s||'re CREATEZIPFILE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_RESOURCE_LIST XMLType,  P_TIMEZONE_OFFSET NUMBER DEFAULT 0);'||chr(10)||
'  procedure DELETERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE, P_FORCE BOOLEAN DEFAULT FALSE);  '||chr(10)||
'  procedure LINKRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2, P_LINK_TYP';

s:=s||'E NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK);  '||chr(10)||
'  procedure LOCKRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure MAKEVERSIONED(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure MOVERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2);'||chr(10)||
'  procedure PUBLISHRESOURCE(P_APEX_USER VARCHA';

s:=s||'R2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure RENAMERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_NEW_NAME VARCHAR2);'||chr(10)||
'  procedure SETACL(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_ACL_PATH VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure SETRSSFEED(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2, P_ENABLE BOOLEAN, P_ITEMS_CHANGED_IN VARCHAR2, P_DEEP B';

s:=s||'OOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure UNLOCKRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE);'||chr(10)||
'  procedure UNZIP(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DUPLICATE_ACTION VARCHAR2);'||chr(10)||
'  procedure UPLOADRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2, P_LANGUAGE ';

s:=s||'VARCHAR2, P_CHARACTER_SET VARCHAR2, P_DUPLICATE_POLICY VARCHAR2);'||chr(10)||
'  procedure UPDATEPROPERTIES(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_NEW_VALUES XMLType, P_TIMEZONE_OFFSET NUMBER DEFAULT 0);'||chr(10)||
''||chr(10)||
'  function ICONFROMCONTENTTYPE(P_IS_FOLDER VARCHAR2, P_CONTENT_TYPE VARCHAR2) return VARCHAR2;'||chr(10)||
'  function URLFROMCONTENTTYPE(P_IS_FOLDER VARCHAR2, P_CONTENT_TYPE VARCHAR2, P_PATH VARCHAR2, P_APEX_A';

s:=s||'PPLICATION_ID VARCHAR2, P_APEX_TARGET_PAGE VARCHAR2, P_APEX_APP_SESSION_ID VARCHAR2, P_APEX_REQUEST VARCHAR2 DEFAULT NULL, P_APEX_DEBUG VARCHAR2 DEFAULT ''NO'', P_APEX_CACHE_OPTIONS VARCHAR2 DEFAULT NULL ) return VARCHAR2;'||chr(10)||
'  function ICONSFORSTATUS(P_VERSION_ID NUMBER, P_IS_CHECKED_OUT VARCHAR2, P_LOCK_BUFFER VARCHAR2) return varchar2;'||chr(10)||
'  '||chr(10)||
'  '||chr(10)||
'  function GETVISABLEFOLDERSTREE(P_APEX_USER VARCHAR2, P_S';

s:=s||'ESSION_ID NUMBER, P_PAGE_NUMBER NUMBER,P_CURRENT_FOLDER VARCHAR2 DEFAULT ''/'') return XMLType;'||chr(10)||
'  function GETWRITABLEFOLDERSTREE(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER,P_CURRENT_FOLDER VARCHAR2 DEFAULT ''/'') return XMLType;'||chr(10)||
'  function SHOWCHILDREN(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2) return XMLType;'||chr(10)||
'  function HIDECHILDREN(P_APEX_US';

s:=s||'ER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2) return XMLType;'||chr(10)||
'  function OPENFOLDER(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER,P_PAGE_NUMBER NUMBER ,P_ID VARCHAR2) return XMLType;'||chr(10)||
'  function CLOSEFOLDER(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER) return XMLType; '||chr(10)||
''||chr(10)||
'  function pathAsTable(P_CURRENT_FOLDER VARCHAR2) return FOLDER_INFO_TABLE PIPELINED;'||chr(10)||
'  fu';

s:=s||'nction LISTDIRECTORY(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2,P_APEX_APPLICATION_ID VARCHAR2, P_APEX_TARGET_PAGE VARCHAR2, P_APEX_APP_SESSION_ID VARCHAR2, P_APEX_REQUEST VARCHAR2 DEFAULT NULL, P_APEX_DEBUG VARCHAR2 DEFAULT ''NO'', P_APEX_CACHE_OPTIONS VARCHAR2 DEFAULT NULL) return DIRECTORY_LISTING PIPELINED;'||chr(10)||
''||chr(10)||
'  function GETIMAGELIST return  XDB.XDB$STRING_LIST_T;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'create or replace syn';

s:=s||'onym XFILES_APEX_SERVICES for XFILES_APEX_SERVICES'||chr(10)||
'/'||chr(10)||
'create or replace package body XFILES_APEX_SERVICES'||chr(10)||
'as'||chr(10)||
'  G_TREE          XMLType;'||chr(10)||
'  G_TREE_DOM      DBMS_XMLDOM.DOMDOCUMENT;'||chr(10)||
'  G_NODE_COUNT    number(38) := 1;  '||chr(10)||
'  G_REPOSITORY_ID VARCHAR2(50);'||chr(10)||
'--'||chr(10)||
'procedure writeLogRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  XFILES_LOGGING.wri';

s:=s||'teLogRecord(''XFILES.XFILES_APEX_SERVICES.'',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure writeErrorRecord(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE, P_PARAMETERS XMLType, P_STACK_TRACE XMLType)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  XFILES_LOGGING.writeErrorRecord(''XFILES.XFILES_APEX_SERVICES.'',P_MODULE_NAME, P_INIT_TIME, P_PARAMETERS, P_STACK_TRACE);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure handleExce';

s:=s||'ption(P_MODULE_NAME VARCHAR2, P_INIT_TIME TIMESTAMP WITH TIME ZONE,P_PARAMETERS XMLTYPE)'||chr(10)||
'as'||chr(10)||
'  V_STACK_TRACE XMLType;'||chr(10)||
'  V_RESULT      boolean;'||chr(10)||
'begin'||chr(10)||
'  V_STACK_TRACE := XFILES_LOGGING.captureStackTrace();'||chr(10)||
'  rollback; '||chr(10)||
'  writeErrorRecord(P_MODULE_NAME,P_INIT_TIME,P_PARAMETERS,V_STACK_TRACE);'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure addChildToTree(P_PATH VARCHAR2, P_PAR';

s:=s||'ENT_FOLDER DBMS_XMLDOM.DOMElement)'||chr(10)||
'as'||chr(10)||
'  V_CHILD_FOLDER_NAME VARCHAR2(256);'||chr(10)||
'  V_DESCENDANT_PATH   VARCHAR2(700);'||chr(10)||
'  '||chr(10)||
'  V_NODE_LIST         DBMS_XMLDOM.DOMNodeList;'||chr(10)||
'  V_CHILD_FOLDER      DBMS_XMLDOM.DOMElement;'||chr(10)||
''||chr(10)||
'  V_CHILD_FOLDER_XML  XMLType;'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'   '||chr(10)||
'  if (INSTR(P_PATH,''/'',2) > 0) then'||chr(10)||
'    V_CHILD_FOLDER_NAME := SUBSTR(P_PATH,2,INSTR(P_PATH,''/'',2)-2);'||chr(10)||
'    V_DESCENDANT_PATH   := SUBSTR(P_PATH,INSTR';

s:=s||'(P_PATH,''/'',2));'||chr(10)||
'  else'||chr(10)||
'    V_CHILD_FOLDER_NAME := SUBSTR(P_PATH,2);'||chr(10)||
'    V_DESCENDANT_PATH   := NULL;'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'  V_NODE_LIST         := DBMS_XSLPROCESSOR.selectNodes(DBMS_XMLDOM.makeNode(P_PARENT_FOLDER),''folder[@name="'' || V_CHILD_FOLDER_NAME || ''"]'');'||chr(10)||
''||chr(10)||
'  if (DBMS_XMLDOM.getLength(V_NODE_LIST) = 0) then'||chr(10)||
''||chr(10)||
'    -- Target is not already in the tree - add it..'||chr(10)||
''||chr(10)||
'    G_NODE_COUNT := G_NODE_COUNT + 1';

s:=s||';'||chr(10)||
''||chr(10)||
'    if (V_DESCENDANT_PATH is not NULL) then'||chr(10)||
'      -- We are not at the bottom of the path so assume this is a read-only folder for now'||chr(10)||
'      select xmlElement'||chr(10)||
'             ('||chr(10)||
'               "folder",'||chr(10)||
'               xmlAttributes'||chr(10)||
'               ('||chr(10)||
'                 V_CHILD_FOLDER_NAME as "name",'||chr(10)||
'                 G_NODE_COUNT as "id",'||chr(10)||
'                 ''null'' as "isSelected",'||chr(10)||
'                 ''closed';

s:=s||''' as "isOpen",'||chr(10)||
'                 READONLY_FOLDER_OPEN_ICON as "openIcon",'||chr(10)||
'                 READONLY_FOLDER_CLOSED_ICON as "closedIcon",'||chr(10)||
'                 ''hidden'' as "children",'||chr(10)||
'                 HIDE_CHILDREN_ICON as "hideChildren",'||chr(10)||
'                 SHOW_CHILDREN_ICON as "showChildren"'||chr(10)||
'               )'||chr(10)||
'             )'||chr(10)||
'        into V_CHILD_FOLDER_XML'||chr(10)||
'        from dual;'||chr(10)||
'    else'||chr(10)||
'      -- We are at the ';

s:=s||'bottom of the path so we can link items into this folder.'||chr(10)||
'      select xmlElement'||chr(10)||
'             ('||chr(10)||
'               "folder",'||chr(10)||
'               xmlAttributes'||chr(10)||
'               ('||chr(10)||
'                 V_CHILD_FOLDER_NAME as "name",'||chr(10)||
'                 G_NODE_COUNT as "id",'||chr(10)||
'                 ''null'' as  "isSelected",'||chr(10)||
'                 ''closed'' as "isOpen",'||chr(10)||
'                 WRITE_FOLDER_OPEN_ICON as "openIcon",'||chr(10)||
'         ';

s:=s||'        WRITE_FOLDER_CLOSED_ICON as "closedIcon",'||chr(10)||
'                 ''hidden'' as "children",'||chr(10)||
'                 HIDE_CHILDREN_ICON as "hideChildren",'||chr(10)||
'                 SHOW_CHILDREN_ICON as "showChildren"'||chr(10)||
'               )'||chr(10)||
'             )'||chr(10)||
'        into V_CHILD_FOLDER_XML'||chr(10)||
'        from dual;'||chr(10)||
'    end if;'||chr(10)||
'    '||chr(10)||
'    V_CHILD_FOLDER := DBMS_XMLDOM.getDocumentElement(DBMS_XMLDOM.newDOMDocument(V_CHILD_FOLDER_XML))';

s:=s||';'||chr(10)||
'    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.importNode(G_TREE_DOM, DBMS_XMLDOM.makeNode(V_CHILD_FOLDER), true));    '||chr(10)||
'    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.appendChild(DBMS_XMLDOM.makeNode(P_PARENT_FOLDER),DBMS_XMLDOM.makeNode(V_CHILD_FOLDER)));'||chr(10)||
''||chr(10)||
'  else'||chr(10)||
'    --  Target is already in the tree. '||chr(10)||
'    '||chr(10)||
'    V_CHILD_FOLDER := DBMS_XMLDOM.makeElement(DBMS_XMLDOM.item(V_N';

s:=s||'ODE_LIST,0));'||chr(10)||
''||chr(10)||
'    if (V_DESCENDANT_PATH is NULL) then      '||chr(10)||
'       -- We are at the bottom of the path, Make sure folder is shown as writeable'||chr(10)||
'       DBMS_XMLDOM.setAttribute(V_CHILD_FOLDER,''openIcon'',WRITE_FOLDER_OPEN_ICON);'||chr(10)||
'       DBMS_XMLDOM.setAttribute(V_CHILD_FOLDER,''closedIcon'',WRITE_FOLDER_CLOSED_ICON);'||chr(10)||
'     end if;'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'  -- Process remainder of path'||chr(10)||
''||chr(10)||
'  if (V_DESCENDANT_PATH is n';

s:=s||'ot null) then'||chr(10)||
'    addChildToTree(V_DESCENDANT_PATH, V_CHILD_FOLDER);'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure addPathToTree(P_PATH  VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_PARENT_FOLDER DBMS_XMLDOM.DOMElement;'||chr(10)||
'begin'||chr(10)||
'  V_PARENT_FOLDER := DBMS_XMLDOM.getDocumentElement(G_TREE_DOM);'||chr(10)||
'  addChildToTree(P_PATH, V_PARENT_FOLDER);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure addWriteableFolders'||chr(10)||
'as'||chr(10)||
'  cursor getFolderList'||chr(10)||
'  is'||chr(10)||
'  select path'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'   wher';

s:=s||'e existsNode(res,''/Resource[@Container="true"]'') = 1'||chr(10)||
'     and sys_checkacl'||chr(10)||
'         ('||chr(10)||
'           extractValue(res,''/Resource/ACLOID/text()''),'||chr(10)||
'           extractValue(res,''/Resource/OwnerID/text()''),'||chr(10)||
'           XMLTYPE'||chr(10)||
'           ('||chr(10)||
'             ''<privilege xmlns="http://xmlns.oracle.com/xdb/acl.xsd" '||chr(10)||
'                         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"'||chr(10)||
'                    ';

s:=s||'     xsi:schemaLocation="http://xmlns.oracle.com/xdb/acl.xsd http://xmlns.oracle.com/xdb/acl.xsd">'||chr(10)||
'              <link/>'||chr(10)||
'             </privilege>'''||chr(10)||
'           )'||chr(10)||
'         ) = 1    ;'||chr(10)||
'     '||chr(10)||
'  V_FOLDER DBMS_XMLDOM.DOMElement;'||chr(10)||
'begin'||chr(10)||
'  for f in getFolderList() loop  '||chr(10)||
'    addPathToTree(F.PATH);   '||chr(10)||
'  end loop;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure addAllFolders'||chr(10)||
'as'||chr(10)||
'  cursor getFolderList'||chr(10)||
'  is'||chr(10)||
'  select path'||chr(10)||
'    from PATH_VIEW'||chr(10)||
'';

s:=s||'   where existsNode(res,''/Resource[@Container="true"]'') = 1;'||chr(10)||
'     '||chr(10)||
'  V_FOLDER DBMS_XMLDOM.DOMElement;'||chr(10)||
'begin'||chr(10)||
'  for f in getFolderList() loop  '||chr(10)||
'    addPathToTree(F.PATH);   '||chr(10)||
'  end loop;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure initTree'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  '||chr(10)||
'  select xmlElement'||chr(10)||
'           ('||chr(10)||
'             "root",'||chr(10)||
'             xmlAttributes'||chr(10)||
'             ('||chr(10)||
'               ''/'' as "name",'||chr(10)||
'               G_NODE_COUNT as "id",'||chr(10)||
'              ';

s:=s||' ''/'' as "currentPath",'||chr(10)||
'               ''null'' as "isSelected",'||chr(10)||
'               ''open'' as "isOpen",'||chr(10)||
'               READONLY_FOLDER_OPEN_ICON as "openIcon",'||chr(10)||
'               READONLY_FOLDER_CLOSED_ICON as "closedIcon",'||chr(10)||
'               ''visible'' as "children",'||chr(10)||
'               HIDE_CHILDREN_ICON as "hideChildren",'||chr(10)||
'               SHOW_CHILDREN_ICON as "showChildren",'||chr(10)||
'               FILLER_ICON as "fillerIcon';

s:=s||'"'||chr(10)||
'             )'||chr(10)||
'           )'||chr(10)||
'    into G_TREE'||chr(10)||
'    from DUAL;'||chr(10)||
''||chr(10)||
'  G_TREE_DOM := DBMS_XMLDOM.newDOMDocument(G_TREE);'||chr(10)||
''||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure cacheTree(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_TREE_STATE XMLType)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  insert into TREE_STATE_TABLE values (P_SESSION_ID, P_PAGE_NUMBER, G_TREE);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure preserveTree(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_TREE_STATE XMLType)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
' ';

s:=s||' update TREE_STATE_TABLE'||chr(10)||
'     set TREE_STATE = P_TREE_STATE'||chr(10)||
'   where SESSION_ID = P_SESSION_ID;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure restoreTree(P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  select TREE_STATE '||chr(10)||
'    into G_TREE'||chr(10)||
'    from TREE_STATE_TABLE'||chr(10)||
'   where SESSION_ID = P_SESSION_ID;'||chr(10)||
''||chr(10)||
'  G_TREE_DOM := DBMS_XMLDOM.newDOMDocument(G_TREE);'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure deleteTree(P_SESSION_ID NUMBER)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'  delete fr';

s:=s||'om TREE_STATE_TABLE '||chr(10)||
'   where SESSION_ID = P_SESSION_ID;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure openFolderInternal(P_ID NUMBER)'||chr(10)||
'as'||chr(10)||
'  V_NODE DBMS_XMLDOM.DOMNode;'||chr(10)||
'  V_PATH VARCHAR2(700);'||chr(10)||
'begin'||chr(10)||
'  select updateXML'||chr(10)||
'         ('||chr(10)||
'           G_TREE,'||chr(10)||
'           ''//*[@isOpen="open"]/@children'','||chr(10)||
'           ''hidden'''||chr(10)||
'         )'||chr(10)||
'    into G_TREE'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  select updateXML'||chr(10)||
'         ('||chr(10)||
'           G_TREE,'||chr(10)||
'           ''//*[@isOpen="';

s:=s||'open"]/@isOpen'','||chr(10)||
'           ''closed'''||chr(10)||
'         )'||chr(10)||
'    into G_TREE'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  select updateXML'||chr(10)||
'         ('||chr(10)||
'           G_TREE,'||chr(10)||
'           ''//*[@id="'' || P_ID || ''"]/@isOpen'','||chr(10)||
'           ''open'''||chr(10)||
'         )'||chr(10)||
'    into G_TREE'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  select updateXML'||chr(10)||
'         ('||chr(10)||
'           G_TREE,'||chr(10)||
'           ''//*[@id="'' || P_ID || ''"]/@children'','||chr(10)||
'           ''visible'''||chr(10)||
'         )'||chr(10)||
'    into G_TREE'||chr(10)||
'    from dual;'||chr(10)||
'';

s:=s||''||chr(10)||
'  G_TREE_DOM := DBMS_XMLDOM.newDOMDocument(G_TREE);'||chr(10)||
'   '||chr(10)||
'  V_NODE := DBMS_XMLDOM.item(DBMS_XSLPROCESSOR.selectNodes(DBMS_XMLDOM.makeNode(G_TREE_DOM),''//*[@id="'' || P_ID || ''"]''),0);   '||chr(10)||
'  V_PATH := DBMS_XMLDOM.getAttribute(DBMS_XMLDOM.makeElement(V_NODE),''name'');'||chr(10)||
'  V_NODE := DBMS_XMLDOM.getParentNode(V_NODE);'||chr(10)||
'  while (DBMS_XMLDOM.getNodeType(V_NODE) <> DBMS_XMLDOM.DOCUMENT_NODE) loop'||chr(10)||
'    V_PATH := ';

s:=s||'DBMS_XMLDOM.getAttribute(DBMS_XMLDOM.makeElement(V_NODE),''name'') || ''/'' || V_PATH;'||chr(10)||
'    DBMS_XMLDOM.setAttribute(DBMS_XMLDOM.makeElement(V_NODE),''children'',''visible'');'||chr(10)||
'    V_NODE := DBMS_XMLDOM.getParentNode(V_NODE);'||chr(10)||
'  end loop;'||chr(10)||
'  '||chr(10)||
'  -- Remove extra ''/'' from currentPath'||chr(10)||
'  V_PATH := substr(V_PATH,2);'||chr(10)||
'  DBMS_XMLDOM.setAttribute(DBMS_XMLDOM.getDocumentElement(DBMS_XMLDOM.makeDocument(V_NODE)),''current';

s:=s||'Path'',V_PATH);  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure showChildrenInternal(P_ID NUMBER)'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'	  select updateXML'||chr(10)||
'         ('||chr(10)||
'           G_TREE,'||chr(10)||
'           ''//*[@id="'' || P_ID || ''"]/@children'','||chr(10)||
'           ''visible'''||chr(10)||
'         )'||chr(10)||
'    into G_TREE'||chr(10)||
'    from dual;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure openBranch(P_CURRENT_FOLDER VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_BRANCH_ID      NUMBER;'||chr(10)||
'  V_CURRENT_FOLDER VARCHAR2(700) := P_CURRENT_FOLDER;'||chr(10)||
'  V_FOLDER_NAME    ';

s:=s||'VARCHAR2(700);'||chr(10)||
'  V_BRANCH         XMLTYPE       := G_TREE;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'	if (P_CURRENT_FOLDER = ''/'') then'||chr(10)||
'	  V_BRANCH_ID := 1;'||chr(10)||
'	else'||chr(10)||
'	  V_BRANCH := V_BRANCH.EXTRACT(''/root/folder'');'||chr(10)||
'	  while INSTR(V_CURRENT_FOLDER,''/'') > 0 loop'||chr(10)||
'	    V_CURRENT_FOLDER := SUBSTR(V_CURRENT_FOLDER,2);'||chr(10)||
'	    if INSTR(V_CURRENT_FOLDER,''/'') > 0 THEN'||chr(10)||
' 	       V_FOLDER_NAME := SUBSTR(V_CURRENT_FOLDER,1,INSTR(V_CURRENT_FOLDER,''/'')-';

s:=s||'1);'||chr(10)||
'	       V_BRANCH := V_BRANCH.EXTRACT(''/folder[@name="'' || V_FOLDER_NAME || ''"]/folder'');'||chr(10)||
'	       V_CURRENT_FOLDER := SUBSTR(V_CURRENT_FOLDER,INSTR(V_CURRENT_FOLDER,''/''));'||chr(10)||
'	    else'||chr(10)||
'	      V_FOLDER_NAME := V_CURRENT_FOLDER;'||chr(10)||
'	      V_BRANCH_ID := V_BRANCH.extract(''/folder[@name="'' || V_FOLDER_NAME || ''"]/@id'').getNumberVal();'||chr(10)||
'	    end if;'||chr(10)||
'	  end loop;'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  openFolderInternal(V_BRANCH_ID)';

s:=s||';'||chr(10)||
'  showChildrenInternal(V_BRANCH_ID);'||chr(10)||
''||chr(10)||
'end;'||chr(10)||
''||chr(10)||
'procedure UPDATEPROPERTIES(P_APEX_USER VARCHAR2, P_RESOURCE_PATH  VARCHAR2, P_NEW_VALUES XMLType, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_RESOURCE_PATH     VARCHAR2(1024);'||chr(10)||
'begin  '||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRI';

s:=s||'NCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),'||chr(10)||
'           P_NEW_VALUES          '||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  V_RESOURCE_PATH := XDB_REPOSITORY_SERVICES.UPDATEPROPERTIES(P_RESOURCE_PATH,P_NEW_VALUES,P_TIMEZ';

s:=s||'ONE_OFFSET);'||chr(10)||
'      '||chr(10)||
'  writeLogRecord(''UPDATEPROPERTIES'',V_INIT,V_PARAMETERS);'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''UPDATEPROPERTIES'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CREATEWIKIPAGE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)'||chr(10)||
'as'||chr(10)||
'  V_RESULT        ';

s:=s||'    boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select XMLConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),'||chr(10)||
'           xmlElement(';

s:=s||'"Description",P_DESCRIPTION)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.CREATEWIKIPAGE(P_RESOURCE_PATH, P_DESCRIPTION, P_TIMEZONE_OFFSET);'||chr(10)||
'  writeLogRecord(''CREATENEWWIKIPAGE'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''CREATEWIKIPAGE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'proce';

s:=s||'dure CREATEFOLDER(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_TIMEZONE_OFFSET NUMBER DEFAULT 0)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select XMLConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APE';

s:=s||'X_USER),'||chr(10)||
'           xmlElement("FolderPath",P_FOLDER_PATH),'||chr(10)||
'           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),'||chr(10)||
'           xmlElement("Description",P_DESCRIPTION)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.CREATEFOLDER(P_FOLDER_PATH, P_DESCRIPTION, P_TIMEZONE_OFFSET);'||chr(10)||
'  writeLogRecord(''CREATENEWFOLDER'',V_INIT,V_PARAMETERS);'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLI';

s:=s||'CATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''CREATENEWFOLDER'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure SETACL(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_ACL_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_DEEP              VAR';

s:=s||'CHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("ACL",P_ACL_PATH),'||chr(10)||
'           xmlElement("Deep",V_DEEP)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XD';

s:=s||'B_REPOSITORY_SERVICES.SETACL(P_RESOURCE_PATH, P_ACL_PATH, P_DEEP);'||chr(10)||
'  writeLogRecord(''SETACL'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''SETACL'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CHANGEOWNER(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_NEW_OWNER VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'';

s:=s||'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath';

s:=s||'",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("NewOwner",P_NEW_OWNER),'||chr(10)||
'           xmlElement("Deep",V_DEEP)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.CHANGEOWNER(P_RESOURCE_PATH,P_NEW_OWNER,P_DEEP);  '||chr(10)||
'  writeLogRecord(''CHANGEOWNER'',V_INIT,V_PARAMETERS);'||chr(10)||
'	V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''CHANGEOWNER';

s:=s||''',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure MAKEVERSIONED(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPL';

s:=s||'ICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("Deep",V_DEEP)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.MAKEVERSIONED(P_RESOURCE_PATH, P_DEEP);'||chr(10)||
'  writeLogRecord(''MAKEVERSIONED'',V_INIT,V_PARAMETERS);'||chr(10)||
'	V_RESULT := DBMS_XDBZ';

s:=s||'.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''MAKEVERSIONED'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CHECKOUT(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_DEEP              VARCHAR2(';

s:=s||'5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("Deep",V_DEEP)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
' '||chr(10)||
'  XDB_REPOSITORY_SERVICES.CHECKOUT(P_RESOURCE_PATH';

s:=s||', P_DEEP);'||chr(10)||
'  writeLogRecord(''CHECKOUT'',V_INIT,V_PARAMETERS);'||chr(10)||
'	V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''CHECKOUT'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CHECKIN(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_COMMENT VARCHAR2, P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType';

s:=s||';'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("Deep",V_DEEP),'||chr(10)||
'  ';

s:=s||'         xmlElement("Comment",P_COMMENT)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.CHECKIN(P_RESOURCE_PATH, P_COMMENT, P_DEEP);'||chr(10)||
'  writeLogRecord(''CHECKIN'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''CHECKIN'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure LOCKRESOURCE(P_APEX';

s:=s||'_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement';

s:=s||'("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("Deep",V_DEEP)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
'    '||chr(10)||
'  XDB_REPOSITORY_SERVICES.LOCKRESOURCE(P_RESOURCE_PATH, P_DEEP);'||chr(10)||
'  writeLogRecord(''LOCKRESOURCE'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''L';

s:=s||'OCKRESOURCE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure UNLOCKRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLIC';

s:=s||'ATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("Deep",V_DEEP)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
'  '||chr(10)||
'  XDB_REPOSITORY_SERVICES.UNLOCKRESOURCE(P_RESOURCE_PATH, P_DEEP);'||chr(10)||
'  writeLogRecord(''UNLOCKRESOURCE'',V_INIT,V_PARAMETERS);'||chr(10)||
'	V_RESULT := DBMS_XD';

s:=s||'BZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''UNLOCKRESOURCE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure DELETERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DEEP BOOLEAN, P_FORCE BOOLEAN)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_RESID          ';

s:=s||'   RAW(16);'||chr(10)||
'  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);'||chr(10)||
'  V_FORCE             VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_FORCE);'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'          ';

s:=s||' xmlElement("Deep",V_DEEP),'||chr(10)||
'           xmlElement("Force",V_FORCE)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.DELETERESOURCE(P_RESOURCE_PATH, P_DEEP, P_FORCE);  '||chr(10)||
'  writeLogRecord(''DELETERESOURCE'',V_INIT,V_PARAMETERS);'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''DELETERESOURCE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    r';

s:=s||'aise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure SETRSSFEED(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2, P_ENABLE BOOLEAN, P_ITEMS_CHANGED_IN VARCHAR2, P_DEEP BOOLEAN)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);'||chr(10)||
'  V_ENABLE            VARCHAR2(5) := XDB_';

wwv_flow_api.create_install_script(
  p_id => 2394031308462677 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_APEX_SERVICES',
  p_sequence=> 370,
  p_script_type=> 'INSTALL',
  p_condition_type=> 'NOT_EXISTS',
  p_condition=> 'select 1 from '||chr(10)||
'   all_synonyms '||chr(10)||
' where owner = ''PUBLIC'' '||chr(10)||
'   and SYNONYM_NAME =  ''XFILES_APEX_SERVICES''',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
begin
s:=s||'DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_ENABLE);'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("FolderPath",P_FOLDER_PATH),'||chr(10)||
'           xmlElement("Deep",V_DEEP),'||chr(10)||
'           xmlElement("Enable",V_ENABLE),'||chr(10)||
'           xmlElement("ItemsChanged",P_ITEMS_CHANGED_IN)'||chr(10)||
'         )'||chr(10)||
' ';

s:=s||'   into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.SETRSSFEED(P_FOLDER_PATH, P_ENABLE, P_ITEMS_CHANGED_IN, P_DEEP);'||chr(10)||
'  writeLogRecord(''SETRSSFEED'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
''||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''SETRSSFEED'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure LINKRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH';

s:=s||' VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_LINK_TYPE NUMBER DEFAULT DBMS_XDB.LINK_TYPE_WEAK)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("Reso';

s:=s||'urcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("TargetFolder",P_TARGET_FOLDER),'||chr(10)||
'           xmlElement("LinkType",P_LINK_TYPE)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.LINKRESOURCE(P_RESOURCE_PATH, P_TARGET_FOLDER,P_LINK_TYPE);  '||chr(10)||
'  writeLogRecord(''LINKRESOURCE'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when other';

s:=s||'s then'||chr(10)||
'    handleException(''LINKRESOURCE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure MOVERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select ';

s:=s||'xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("TargetFolder",P_TARGET_FOLDER)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.MOVERESOURCE(P_RESOURCE_PATH, P_TARGET_FOLDER);'||chr(10)||
'  writeLogRecord(''MOVERESOURCE'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRI';

s:=s||'NCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''MOVERESOURCE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure RENAMERESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_NEW_NAME VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL';

s:=s||'(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("NewName",P_NEW_NAME)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.RENAMERESOURCE(P_RESOURCE_PATH, P_NEW_NAME);'||chr(10)||
'  writeLogRecord(''RENAMERESOURCE'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.R';

s:=s||'ESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''RENAMERESOURCE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure COPYRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_TARGET_FOLDER VARCHAR2,P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V';

s:=s||'_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("TargetFolder",P_TARGET_FOLDER),'||chr(10)||
'           xmlElement("Deep",V_DEEP)'||chr(10)||
'         )'||chr(10)||
'    in';

s:=s||'to V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
'   '||chr(10)||
'  XDB_REPOSITORY_SERVICES.COPYRESOURCE(P_RESOURCE_PATH, P_TARGET_FOLDER);'||chr(10)||
'  writeLogRecord(''COPYRESOURCE'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''COPYRESOURCE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure PUBLISHRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR';

s:=s||'2, P_DEEP BOOLEAN DEFAULT FALSE)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_DEEP              VARCHAR2(5) := XDB_DOM_UTILITIES.BOOLEAN_TO_VARCHAR(P_DEEP);  '||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER';

s:=s||'),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("Deep",V_DEEP)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.PUBLISHRESOURCE(P_RESOURCE_PATH, P_DEEP);'||chr(10)||
'  writeLogRecord(''PUBLISHESOURCE'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''PUBLISHESOURCE'',V_INIT,V';

s:=s||'_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure UPLOADRESOURCE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_CONTENT BLOB, P_CONTENT_TYPE VARCHAR2, P_DESCRIPTION VARCHAR2, P_LANGUAGE VARCHAR2, P_CHARACTER_SET VARCHAR2, P_DUPLICATE_POLICY VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT :=';

s:=s||' DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("ContentLength",DBMS_LOB.GETLENGTH(P_CONTENT)),'||chr(10)||
'           xmlElement("ContentType",P_CONTENT_TYPE),'||chr(10)||
'           xmlElement("Description",P_DESCRIPTION),'||chr(10)||
'           xmlElement("Language",P_';

s:=s||'LANGUAGE),'||chr(10)||
'           xmlElement("CharacterSet",P_CHARACTER_SET),'||chr(10)||
'           xmlElement("DuplicatePolicy",P_DUPLICATE_POLICY)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
'      '||chr(10)||
'  XDB_REPOSITORY_SERVICES.UPLOADRESOURCE(P_RESOURCE_PATH, P_CONTENT, P_CONTENT_TYPE, P_DESCRIPTION, P_LANGUAGE, P_CHARACTER_SET, P_DUPLICATE_POLICY);'||chr(10)||
'  writeLogRecord(''UPLOADRESOURCE'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT :';

s:=s||'= DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''UPLOADRESOURCE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure CREATEZIPFILE(P_APEX_USER VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DESCRIPTION VARCHAR2, P_RESOURCE_LIST XMLType,  P_TIMEZONE_OFFSET NUMBER DEFAULT 0)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIM';

s:=s||'ESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("TimezoneOffset",P_TIMEZONE_OFFSET),'||chr(10)||
'           xmlElement("Description",P_DESCRIPTION),'||chr(10)||
'           P_RESOURCE_LIST'||chr(10)||
'         )'||chr(10)||
' ';

s:=s||'   into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.CREATEZIPFILE(P_RESOURCE_PATH, P_DESCRIPTION, P_RESOURCE_LIST,  P_TIMEZONE_OFFSET);'||chr(10)||
'  writeLogRecord(''CREATEZIPFILE'',V_INIT,V_PARAMETERS);'||chr(10)||
'	V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''CREATEZIPFILE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'procedure UNZIP(P_APEX_USER VARCHAR2';

s:=s||', P_FOLDER_PATH VARCHAR2, P_RESOURCE_PATH VARCHAR2, P_DUPLICATE_ACTION VARCHAR2)'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("FolderPath"';

s:=s||',P_FOLDER_PATH),'||chr(10)||
'           xmlElement("ResourcePath",P_RESOURCE_PATH),'||chr(10)||
'           xmlElement("DuplicateAction",P_DUPLICATE_ACTION)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XDB_REPOSITORY_SERVICES.unzip(P_FOLDER_PATH, P_RESOURCE_PATH, P_DUPLICATE_ACTION);'||chr(10)||
'  writeLogRecord(''UNZIP'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'';

s:=s||'    handleException(''UNZIP'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function ICONFROMCONTENTTYPE(P_IS_FOLDER VARCHAR2, P_CONTENT_TYPE VARCHAR2)  '||chr(10)||
'return VARCHAR2'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
' if (P_IS_FOLDER = ''true'') then'||chr(10)||
'     return FOLDER_ICON;'||chr(10)||
'   end if;'||chr(10)||
' '||chr(10)||
'   if P_CONTENT_TYPE in (CONTENT_TYPE_JPEG) then'||chr(10)||
'     return IMAGE_JPEG_ICON;'||chr(10)||
'   end if;'||chr(10)||
'   '||chr(10)||
'   if P_CONTENT_TYPE in (CONTENT_TYPE_GIF) then'||chr(10)||
'     return IMA';

s:=s||'GE_GIF_ICON;'||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   if P_CONTENT_TYPE in (CONTENT_TYPE_XML_CSX) then'||chr(10)||
'     return XML_ICON;'||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   if P_CONTENT_TYPE in (CONTENT_TYPE_XML_TEXT) then'||chr(10)||
'     return XML_ICON;'||chr(10)||
'   end if;'||chr(10)||
''||chr(10)||
'   return DEFAULT_ICON;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function URLFROMCONTENTTYPE(P_IS_FOLDER VARCHAR2, P_CONTENT_TYPE VARCHAR2, P_PATH VARCHAR2, P_APEX_APPLICATION_ID VARCHAR2, P_APEX_TARGET_PAGE VARCHAR2, P_APEX_APP_SESSIO';

s:=s||'N_ID VARCHAR2, P_APEX_REQUEST VARCHAR2 DEFAULT NULL, P_APEX_DEBUG VARCHAR2 DEFAULT ''NO'', P_APEX_CACHE_OPTIONS VARCHAR2 DEFAULT NULL )'||chr(10)||
'return VARCHAR2'||chr(10)||
'as'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  if (P_IS_FOLDER = ''true'') then'||chr(10)||
'    return ''f?p='' || P_APEX_APPLICATION_ID || '':'' || P_APEX_TARGET_PAGE || '':''  || P_APEX_APP_SESSION_ID || '':'' || P_APEX_REQUEST || '':'' || P_APEX_DEBUG || '':'' || P_APEX_CACHE_OPTIONS || '':P1_CURRENT_FOLDER:';

s:=s||''' || P_PATH;'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  return P_PATH;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function ICONSFORSTATUS(P_VERSION_ID NUMBER, P_IS_CHECKED_OUT VARCHAR2, P_LOCK_BUFFER VARCHAR2)'||chr(10)||
'return VARCHAR2'||chr(10)||
'as'||chr(10)||
'  V_PROPERTIES_ICON VARCHAR2(128);'||chr(10)||
'  V_VERSIONED_ICON VARCHAR2(128);'||chr(10)||
'  V_LOCKED_ICON VARCHAR2(128);'||chr(10)||
'begin'||chr(10)||
'  V_PROPERTIES_ICON := ''<span width="18"><img src="'' || FILE_PROPERTIES_ICON || ''" alt="View Properties" width="16" height="16"/><';

s:=s||'/span>'';'||chr(10)||
'   '||chr(10)||
'  if (P_VERSION_ID is not NULL) then'||chr(10)||
'    if (P_IS_CHECKED_OUT = ''false'') then'||chr(10)||
'      V_VERSIONED_ICON := ''<span width="18"><img src="'' || FILE_VERSIONED_ICON || ''" alt="View Properties" width="16" height="16"/></span>'';'||chr(10)||
'    else'||chr(10)||
'      V_VERSIONED_ICON := ''<span width="18"><img src="'' || FILE_CHECKED_OUT_ICON || ''" alt="View Properties" width="16" height="16"/></span>'';'||chr(10)||
'    end if;'||chr(10)||
'  el';

s:=s||'se'||chr(10)||
'    V_VERSIONED_ICON := ''<span width="18"><img src="'' || FILLER_ICON || ''" alt="View Properties" width="16" height="16"/></span>'';'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'  if (length(P_LOCK_BUFFER) > 44) then'||chr(10)||
'    V_LOCKED_ICON :=  ''<span width="18"><img src="'' || FILE_LOCKED_ICON || ''" alt="View Properties" width="16" height="16"/></span>'';'||chr(10)||
'  else'||chr(10)||
'    V_LOCKED_ICON := ''<span width="18"><img src="'' || FILLER_ICON || ''" a';

s:=s||'lt="View Properties" width="16" height="16"/></span>'';'||chr(10)||
'  end if;'||chr(10)||
'  '||chr(10)||
'  return V_PROPERTIES_ICON || V_VERSIONED_ICON || V_LOCKED_ICON;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function GETWRITABLEFOLDERSTREE(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_CURRENT_FOLDER VARCHAR2 DEFAULT ''/'')'||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME Z';

s:=s||'ONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("SessionId",P_SESSION_ID),'||chr(10)||
'           xmlElement("PageNumber",P_PAGE_NUMBER),'||chr(10)||
'           xmlElement("CurrentFolder",P_CURRENT_FOLDER)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  deleteTree(P_SESS';

s:=s||'ION_ID);'||chr(10)||
'  initTree();'||chr(10)||
'  addWriteableFolders();'||chr(10)||
'  openBranch(P_CURRENT_FOLDER);'||chr(10)||
'  cacheTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);'||chr(10)||
'  writeLogRecord(''GETWRITABLEFOLDERSTREE'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'  return G_TREE.transform(xdburitype(FOLDER_TREE_STYLESHEET).getXML());'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''GETWRITABLEFOLDERSTREE'',V_';

s:=s||'INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function GETVISABLEFOLDERSTREE(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_CURRENT_FOLDER VARCHAR2 DEFAULT ''/'')'||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  se';

s:=s||'lect xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("SessionId",P_SESSION_ID),'||chr(10)||
'           xmlElement("PageNumber",P_PAGE_NUMBER),'||chr(10)||
'           xmlElement("CurrentFolder",P_CURRENT_FOLDER)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  deleteTree(P_SESSION_ID);'||chr(10)||
'  initTree();'||chr(10)||
'  addAllFolders();'||chr(10)||
'  openBranch(P_CURRENT_FOLDER);'||chr(10)||
'  cacheTree(P_SESSION_ID, P_P';

s:=s||'AGE_NUMBER, G_TREE);'||chr(10)||
'  writeLogRecord(''GETVISABLEFOLDERSTREE'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'  return G_TREE.transform(xdburitype(FOLDER_TREE_STYLESHEET).getXML());'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''GETVISABLEFOLDERSTREE'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function SHOWCHILDREN(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_';

s:=s||'NUMBER NUMBER, P_ID VARCHAR2) '||chr(10)||
'return XMLType'||chr(10)||
'as '||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
'  '||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("SessionId",P_SESSION_ID),'||chr(10)||
'           xmlElem';

s:=s||'ent("PageNumber",P_PAGE_NUMBER),'||chr(10)||
'           xmlElement("Id",P_ID)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  restoreTree(P_SESSION_ID, P_PAGE_NUMBER);'||chr(10)||
'  showChildrenInternal(P_ID);'||chr(10)||
'  preserveTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);  '||chr(10)||
''||chr(10)||
'  writeLogRecord(''SHOWCHILDREN'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'  return G_TREE.transform(xdburitype(FOLDER_T';

s:=s||'REE_STYLESHEET).getXML());'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''SHOWCHILDREN'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function HIDECHILDREN(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2) '||chr(10)||
'return XMLType'||chr(10)||
'as '||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  V_RESULT ';

s:=s||':= DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("SessionId",P_SESSION_ID),'||chr(10)||
'           xmlElement("PageNumber",P_PAGE_NUMBER),'||chr(10)||
'           xmlElement("Id",P_ID)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  restoreTree(P_SESSION_ID, P_PAGE_NUMBER);'||chr(10)||
''||chr(10)||
'  select updateXML'||chr(10)||
'         ('||chr(10)||
'      ';

s:=s||'     G_TREE,'||chr(10)||
'           ''//*[@id="'' || P_ID || ''"]/@children'','||chr(10)||
'           ''hidden'''||chr(10)||
'         )'||chr(10)||
'    into G_TREE'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  preserveTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);'||chr(10)||
''||chr(10)||
'  writeLogRecord(''HIDECHILDREN'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'  return G_TREE.transform(xdburitype(FOLDER_TREE_STYLESHEET).getXML());'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    han';

s:=s||'dleException(''HIDECHILDREN'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function OPENFOLDER(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER, P_ID VARCHAR2)'||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
''||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select ';

s:=s||'xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("SessionId",P_SESSION_ID),'||chr(10)||
'           xmlElement("PageNumber",P_PAGE_NUMBER),'||chr(10)||
'           xmlElement("Id",P_ID)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
'      '||chr(10)||
'  restoreTree(P_SESSION_ID, P_PAGE_NUMBER);'||chr(10)||
'  openFolderInternal(P_ID);'||chr(10)||
'  preserveTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);'||chr(10)||
''||chr(10)||
'  writeLogRecord(''';

s:=s||'OPENFOLDER'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'  return G_TREE.transform(xdburitype(FOLDER_TREE_STYLESHEET).getXML());'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''OPENFOLDER'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function CLOSEFOLDER(P_APEX_USER VARCHAR2, P_SESSION_ID NUMBER, P_PAGE_NUMBER NUMBER)'||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'  V_RESULT            boolean';

s:=s||';'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement("SessionId",P_SESSION_ID),'||chr(10)||
'           xmlElement("PageNumber",P_PAGE_NUMBER)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
'';

s:=s||'      '||chr(10)||
'  restoreTree(P_SESSION_ID, P_PAGE_NUMBER);'||chr(10)||
''||chr(10)||
'  select updateXML'||chr(10)||
'         ('||chr(10)||
'           G_TREE,'||chr(10)||
'           ''//*[@isOpen="open"]/@isOpen'','||chr(10)||
'           ''closed'''||chr(10)||
'         )'||chr(10)||
'    into G_TREE'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  preserveTree(P_SESSION_ID, P_PAGE_NUMBER, G_TREE);'||chr(10)||
''||chr(10)||
'  writeLogRecord(''CLOSEFOLDER'',V_INIT,V_PARAMETERS);	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'  return G_TREE.transform(xdbur';

s:=s||'itype(FOLDER_TREE_STYLESHEET).getXML());'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''CLOSEFOLDER'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function pathAsTable(P_CURRENT_FOLDER VARCHAR2)'||chr(10)||
'return FOLDER_INFO_TABLE PIPELINED'||chr(10)||
'as'||chr(10)||
'  V_CURRENT_FOLDER VARCHAR2(700) := P_CURRENT_FOLDER;'||chr(10)||
'  V_FOLDER_INFO    FOLDER_INFO;'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_FOLDER_INFO.NAME := G_REPOSITORY_ID;'||chr(10)||
'  V_FOLDER_INFO.PATH := ''/'';'||chr(10)||
'  V';

s:=s||'_FOLDER_INFO.ICON := REPOSITORY_ICON;'||chr(10)||
''||chr(10)||
'	pipe row (V_FOLDER_INFO);'||chr(10)||
''||chr(10)||
'  V_FOLDER_INFO.ICON := FOLDER_ICON;'||chr(10)||
'  V_FOLDER_INFO.PATH := '''';'||chr(10)||
''||chr(10)||
'	if (P_CURRENT_FOLDER = ''/'') then'||chr(10)||
'	  return;'||chr(10)||
'	else'||chr(10)||
'	  while INSTR(V_CURRENT_FOLDER,''/'') > 0 loop'||chr(10)||
'	    V_CURRENT_FOLDER := SUBSTR(V_CURRENT_FOLDER,2);'||chr(10)||
'	    if INSTR(V_CURRENT_FOLDER,''/'') > 0 THEN'||chr(10)||
'         V_FOLDER_INFO.NAME := SUBSTR(V_CURRENT_FOLDER,1,INSTR(V_CURRENT';

s:=s||'_FOLDER,''/'')-1);'||chr(10)||
'         V_FOLDER_INFO.PATH := V_FOLDER_INFO.PATH || ''/'' || V_FOLDER_INFO.NAME; 	       '||chr(10)||
'         pipe row (V_FOLDER_INFO);'||chr(10)||
'	       V_CURRENT_FOLDER := SUBSTR(V_CURRENT_FOLDER,INSTR(V_CURRENT_FOLDER,''/''));'||chr(10)||
'	    else'||chr(10)||
'        V_FOLDER_INFO.NAME := V_CURRENT_FOLDER;'||chr(10)||
'        V_FOLDER_INFO.PATH := V_FOLDER_INFO.PATH || ''/'' || V_FOLDER_INFO.NAME; 	       '||chr(10)||
'       	pipe row (V_FOLDER_INFO';

s:=s||');'||chr(10)||
'	    end if;'||chr(10)||
'	  end loop;'||chr(10)||
'	  return;'||chr(10)||
'  end if;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function LISTDIRECTORY(P_APEX_USER VARCHAR2, P_FOLDER_PATH VARCHAR2,P_APEX_APPLICATION_ID VARCHAR2, P_APEX_TARGET_PAGE VARCHAR2, P_APEX_APP_SESSION_ID VARCHAR2, P_APEX_REQUEST VARCHAR2 DEFAULT NULL, P_APEX_DEBUG VARCHAR2 DEFAULT ''NO'', P_APEX_CACHE_OPTIONS VARCHAR2 DEFAULT NULL)'||chr(10)||
'return DIRECTORY_LISTING PIPELINED'||chr(10)||
'as'||chr(10)||
'  V_EMPTY_FOLDER      boo';

s:=s||'lean := TRUE;'||chr(10)||
'  V_RESULT            boolean;'||chr(10)||
'  V_PARAMETERS        XMLType;'||chr(10)||
'  V_INIT              TIMESTAMP WITH TIME ZONE := SYSTIMESTAMP;'||chr(10)||
'  V_PARENT_PATH       VARCHAR2(700) := P_FOLDER_PATH;'||chr(10)||
''||chr(10)||
'  V_DIRECTORY_ITEM    DIRECTORY_ITEM ;'||chr(10)||
''||chr(10)||
'  cursor getFolderListing is'||chr(10)||
'  select PATH, RESID, RES, R.*, L.*'||chr(10)||
'    from PATH_VIEW,'||chr(10)||
'         XMLTable '||chr(10)||
'         ('||chr(10)||
'           xmlNamespaces'||chr(10)||
'           ('||chr(10)||
'            ';

s:=s||' default ''http://xmlns.oracle.com/xdb/XDBResource.xsd'''||chr(10)||
'           ),'||chr(10)||
'           ''$RES/Resource'' passing RES as "RES"'||chr(10)||
'           columns'||chr(10)||
'           IS_FOLDER           VARCHAR2(5)      PATH  ''@Container'','||chr(10)||
'           VERSION_ID          NUMBER(38)       PATH  ''@VersionID'','||chr(10)||
'           CHECKED_OUT         VARCHAR2(5)      PATH  ''@IsCheckedOut'','||chr(10)||
'           CREATION_DATE       TIMESTAMP(6)     PATH  ''Cr';

s:=s||'eationDate'','||chr(10)||
'           MODIFICATION_DATE   TIMESTAMP(6)     PATH  ''ModificationDate'','||chr(10)||
'           AUTHOR              VARCHAR2(128)    PATH  ''Author'','||chr(10)||
'           DISPLAY_NAME        VARCHAR2(128)    PATH  ''DisplayName'','||chr(10)||
'           "COMMENT"           VARCHAR2(128)    PATH  ''Comment'','||chr(10)||
'           LANGUAGE            VARCHAR2(128)    PATH  ''Language'','||chr(10)||
'           CHARACTER_SET       VARCHAR2(128)    P';

s:=s||'ATH  ''CharacterSet'','||chr(10)||
'           CONTENT_TYPE        VARCHAR2(128)    PATH  ''ContentType'','||chr(10)||
'           OWNED_BY            VARCHAR2(64)     PATH  ''Owner'',      '||chr(10)||
'           CREATED_BY          VARCHAR2(64)     PATH  ''Creator'','||chr(10)||
'           LAST_MODIFIED_BY    VARCHAR2(64)     PATH  ''LastModifier'','||chr(10)||
'           CHECKED_OUT_BY      VARCHAR2(700)    PATH  ''CheckedOutBy'','||chr(10)||
'           LOCK_BUFFER         VARCH';

s:=s||'AR2(128)    PATH  ''LockBuf'','||chr(10)||
'           VERSION_SERIES_ID   RAW(16)          PATH  ''VCRUID'','||chr(10)||
'           ACL_OID             RAW(16)          PATH  ''ACLOID'','||chr(10)||
'           SCHEMA_OID          RAW(16)          PATH  ''SchOID'','||chr(10)||
'           GLOBAL_ELEMENT_ID   NUMBER(38)       PATH  ''ElNum'''||chr(10)||
'        ) R,'||chr(10)||
'        XMLTable'||chr(10)||
'        ('||chr(10)||
'           xmlNamespaces'||chr(10)||
'           ('||chr(10)||
'             default ''http://xmlns.orac';

s:=s||'le.com/xdb/XDBStandard'''||chr(10)||
'           ),'||chr(10)||
'           ''$LINK/LINK'' passing LINK as "LINK"'||chr(10)||
'           columns'||chr(10)||
'           LINK_NAME          VARCHAR2(128)    PATH ''Name'''||chr(10)||
'        ) L'||chr(10)||
'  where under_path(RES,1,P_FOLDER_PATH) = 1;'||chr(10)||
' '||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  V_RESULT := DBMS_XDBZ.SET_APPLICATION_PRINCIPAL(P_APEX_USER,TRUE);'||chr(10)||
'	'||chr(10)||
'  select xmlConcat'||chr(10)||
'         ('||chr(10)||
'           xmlElement("ApexUser",P_APEX_USER),'||chr(10)||
'           xmlElement(';

s:=s||'"FolderPath",P_FOLDER_PATH),'||chr(10)||
'           xmlElement("ApplicationId",P_APEX_APPLICATION_ID),'||chr(10)||
'           xmlElement("Page",P_APEX_TARGET_PAGE),'||chr(10)||
'           xmlElement("SessionId",P_APEX_APP_SESSION_ID),'||chr(10)||
'           xmlElement("Request",P_APEX_REQUEST),'||chr(10)||
'           xmlElement("Debug",P_APEX_DEBUG),'||chr(10)||
'           xmlElement("CacheOptions",P_APEX_CACHE_OPTIONS)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
'';

s:=s||'    '||chr(10)||
'  if (P_FOLDER_PATH != ''/'') then'||chr(10)||
'    V_PARENT_PATH := V_PARENT_PATH || ''/'';'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
'  for r in getFolderListing() loop'||chr(10)||
'   '||chr(10)||
'    V_EMPTY_FOLDER := FALSE;'||chr(10)||
'  '||chr(10)||
'    V_DIRECTORY_ITEM.nPATH               := R.PATH;'||chr(10)||
'    V_DIRECTORY_ITEM.nRESID              := R.RESID;                                       '||chr(10)||
'    V_DIRECTORY_ITEM.nIS_FOLDER          := R.IS_FOLDER;                                   '||chr(10)||
' ';

s:=s||'   V_DIRECTORY_ITEM.nVERSION_ID         := R.VERSION_ID;                                  '||chr(10)||
'    V_DIRECTORY_ITEM.nCHECKED_OUT        := R.CHECKED_OUT;                                 '||chr(10)||
'    V_DIRECTORY_ITEM.nCREATION_DATE      := R.CREATION_DATE;                               '||chr(10)||
'    V_DIRECTORY_ITEM.nMODIFICATION_DATE  := R.MODIFICATION_DATE;                           '||chr(10)||
'    V_DIRECTORY_ITEM.nAUTHOR     ';

s:=s||'        := R.AUTHOR;                                      '||chr(10)||
'    V_DIRECTORY_ITEM.nDISPLAY_NAME       := R.DISPLAY_NAME;                                '||chr(10)||
'    V_DIRECTORY_ITEM.nCOMMENT            := R.COMMENT;                                     '||chr(10)||
'    V_DIRECTORY_ITEM.nLANGUAGE           := R.LANGUAGE;                                    '||chr(10)||
'    V_DIRECTORY_ITEM.nCHARACTER_SET      := R.CHARACTER_SET;     ';

s:=s||'                          '||chr(10)||
'    V_DIRECTORY_ITEM.nCONTENT_TYPE       := R.CONTENT_TYPE;                                '||chr(10)||
'    V_DIRECTORY_ITEM.nOWNED_BY           := R.OWNED_BY;                                    '||chr(10)||
'    V_DIRECTORY_ITEM.nCREATED_BY         := R.CREATED_BY;                                  '||chr(10)||
'    V_DIRECTORY_ITEM.nLAST_MODIFIED_BY   := R.LAST_MODIFIED_BY;                            '||chr(10)||
'    V';

s:=s||'_DIRECTORY_ITEM.nCHECKED_OUT_BY     := R.CHECKED_OUT_BY;                             '||chr(10)||
'    V_DIRECTORY_ITEM.nLOCK_BUFFER        := R.LOCK_BUFFER;                                 '||chr(10)||
'    V_DIRECTORY_ITEM.nVERSION_SERIES_ID  := R.VERSION_SERIES_ID;                           '||chr(10)||
'    V_DIRECTORY_ITEM.nACL_OID            := R.ACL_OID;                                     '||chr(10)||
'    V_DIRECTORY_ITEM.nSCHEMA_OID      ';

s:=s||'   := R.SCHEMA_OID;                                  '||chr(10)||
'    V_DIRECTORY_ITEM.nGLOBAL_ELEMENT_ID  := R.GLOBAL_ELEMENT_ID;                           '||chr(10)||
'    V_DIRECTORY_ITEM.nLINK_NAME          := R.LINK_NAME;    '||chr(10)||
'    V_DIRECTORY_ITEM.nCHILD_PATH         := V_PARENT_PATH || R.LINK_NAME;'||chr(10)||
'    V_DIRECTORY_ITEM.nICON_PATH          := ICONFROMCONTENTTYPE(R.IS_FOLDER, R.CONTENT_TYPE);'||chr(10)||
'    V_DIRECTORY_ITEM.nTAR';

s:=s||'GET_URL         := URLFROMCONTENTTYPE(R.IS_FOLDER, R.CONTENT_TYPE,R.PATH, P_APEX_APPLICATION_ID, P_APEX_TARGET_PAGE, P_APEX_APP_SESSION_ID, P_APEX_REQUEST, P_APEX_DEBUG,P_APEX_CACHE_OPTIONS);'||chr(10)||
'    V_DIRECTORY_ITEM.nRESOURCE_STATUS    := ICONSFORSTATUS(R.VERSION_ID, R.CHECKED_OUT, R.LOCK_BUFFER);'||chr(10)||
'  '||chr(10)||
'   	pipe row (V_DIRECTORY_ITEM);'||chr(10)||
'	end loop; '||chr(10)||
'	'||chr(10)||
'	if (V_EMPTY_FOLDER) then'||chr(10)||
'    V_DIRECTORY_ITEM.nICON_P';

s:=s||'ATH          := FILLER_ICON;'||chr(10)||
'	  pipe row (V_DIRECTORY_ITEM);'||chr(10)||
'	end if;'||chr(10)||
'	'||chr(10)||
'  writeLogRecord(''LISTDIRECTORY'',V_INIT,V_PARAMETERS);'||chr(10)||
'	V_RESULT := DBMS_XDBZ.RESET_APPLICATION_PRINCIPAL();'||chr(10)||
'	'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    handleException(''LISTDIRECTORY'',V_INIT,V_PARAMETERS);'||chr(10)||
'    raise;'||chr(10)||
'  '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function GETIMAGELIST'||chr(10)||
'return XDB.XDB$STRING_LIST_T'||chr(10)||
'as'||chr(10)||
'  RESOURCE_LIST XDB.XDB$STRING_LIST_T;'||chr(10)||
'begin'||chr(10)||
'	RESOURCE';

s:=s||'_LIST := XDB.XDB$STRING_LIST_T();'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'	RESOURCE_LIST(RESOURCE_LIST.count) := FILLER_ICON;'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := FILE_PROPERTIES_ICON;'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := FILE_CHECKED_OUT_ICON;'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := FILE_VERSIONED_ICON;'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  R';

s:=s||'ESOURCE_LIST(RESOURCE_LIST.count) := FILE_LOCKED_ICON;'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := REPOSITORY_ICON;'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := FOLDER_ICON;'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := IMAGE_JPEG_ICON;'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := IMAGE_GIF_ICON;'||chr(10)||
'	RESOURCE_LIST.extend(';

s:=s||');'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := XML_ICON;'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := TEXT_ICON;'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := DEFAULT_ICON;'||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := READONLY_FOLDER_OPEN_ICON;   '||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := READONLY_FOLDER_CLOSED_ICON; '||chr(10)||
'	R';

s:=s||'ESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := WRITE_FOLDER_OPEN_ICON;      '||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := WRITE_FOLDER_CLOSED_ICON;    '||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := SHOW_CHILDREN_ICON;          '||chr(10)||
'	RESOURCE_LIST.extend();'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := HIDE_CHILDREN_ICON;          '||chr(10)||
'	RESOURCE_LIST.extend(';

s:=s||');'||chr(10)||
'  RESOURCE_LIST(RESOURCE_LIST.count) := FOLDER_TREE_STYLESHEET;'||chr(10)||
'  return RESOURCE_LIST;'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'begin'||chr(10)||
'	select SUBSTR(GLOBAL_NAME,1,INSTR(GLOBAL_NAME,''.'')-1)'||chr(10)||
'	  into G_REPOSITORY_ID'||chr(10)||
'	  from GLOBAL_NAME;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--';

wwv_flow_api.append_to_install_script(
  p_id => 2394031308462677 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_script_clob => s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'create or replace package APEX_AUTHENTICATION'||chr(10)||
'AUTHID DEFINER'||chr(10)||
'as'||chr(10)||
'  function doAuthentication(P_USERNAME VARCHAR2, P_PASSWORD VARCHAR2, P_WORKSPACE VARCHAR2) return XMLType;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--'||chr(10)||
'create or replace package body APEX_AUTHENTICATION'||chr(10)||
'as'||chr(10)||
'--'||chr(10)||
'function doAuthentication(P_USERNAME VARCHAR2, P_PASSWORD VARCHAR2, P_WORKSPACE VARCHAR2)'||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'  V_VALID_PASSWORD boolean := FALSE;'||chr(10)||
'begi';

s:=s||'n'||chr(10)||
'  for c1 in '||chr(10)||
'  ('||chr(10)||
'    select workspace_id '||chr(10)||
'      from apex_workspaces'||chr(10)||
'     where workspace = P_WORKSPACE'||chr(10)||
'  ) loop'||chr(10)||
'    -- Set the context of your session so APEX know which wokspace to authenticate against.'||chr(10)||
'    wwv_flow_api.set_security_group_id(c1.workspace_id);'||chr(10)||
'    V_VALID_PASSWORD := APEX_UTIL.IS_LOGIN_PASSWORD_VALID(P_USERNAME,P_PASSWORD);'||chr(10)||
'    if (V_VALID_PASSWORD) then'||chr(10)||
'  	  return XMLType(''<c';

s:=s||'ustom_authenticate><user>'' || P_USERNAME || ''</user></custom_authenticate>'');'||chr(10)||
'    else'||chr(10)||
'      return XMLType(''<custom_authenticate><error>Invalid Password</error></custom_authenticate>'');              '||chr(10)||
'    end if;'||chr(10)||
'  end loop;'||chr(10)||
'  return XMLType(''<custom_authenticate><error>Invalid Workspace.'' || ''User = "'' || USER || ''". CURRENT_SCHEMA = "'' || sys_context(''USERENV'',''CURRENT_SCHEMA'') || ''".'' || ''</err';

s:=s||'or></custom_authenticate>'');              '||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'function doAuthenticationDummy(P_USERNAME VARCHAR2, P_PASSWORD VARCHAR2, P_WORKSPACE VARCHAR2)'||chr(10)||
'return XMLType'||chr(10)||
'as'||chr(10)||
'  V_VALID_PASSWORD boolean := FALSE;'||chr(10)||
'begin'||chr(10)||
'	if P_PASSWORD = ''oracle'' then'||chr(10)||
'	  return XMLType(''<custom_authenticate><user>'' || P_USERNAME || ''</user></custom_authenticate>'');'||chr(10)||
'	else'||chr(10)||
'    return XMLType(''<custom_authenticate><error>Invalid P';

s:=s||'assword</error></custom_authenticate>'');              '||chr(10)||
'  end if;	'||chr(10)||
'end;'||chr(10)||
'--'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--'||chr(10)||
'create or replace function authenticateUser(URL IN VARCHAR2, AuthInfo IN VARCHAR2)'||chr(10)||
'return varchar2'||chr(10)||
'as'||chr(10)||
'  V_WORKSPACE                    varchar2(300) := null;'||chr(10)||
'  V_USERNAME                     varchar2(300) := null;'||chr(10)||
'  V_PASSWORD                     varchar2(300) := null;'||chr(10)||
''||chr(10)||
'  V_BASIC_AUTHENTICATION_STRING  ';

s:=s||'varchar2(2048) := NULL;'||chr(10)||
'  V_AUTHENTICATION_STRING        varchar2(2048) := NULL;'||chr(10)||
''||chr(10)||
'  V_OFFSET                       number := 0;'||chr(10)||
'  V_VALID_PASSWORD               BOOLEAN := FALSE;'||chr(10)||
''||chr(10)||
'  V_ERROR_MSG                    VARCHAR2(3000);'||chr(10)||
'  V_PARAMETERS                   XMLType;'||chr(10)||
'  V_RESULT                       XMLType;'||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'  if (AuthInfo is not NULL) then'||chr(10)||
'    if (instr(AuthInfo, ''Basic'') = 1) then'||chr(10)||
'   ';

s:=s||'   -- ''Basic <wkspc/user:passwd>'''||chr(10)||
'      V_BASIC_AUTHENTICATION_STRING := substr(AuthInfo, 7);'||chr(10)||
'      V_AUTHENTICATION_STRING := utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(V_BASIC_AUTHENTICATION_STRING)));  '||chr(10)||
'      V_OFFSET := instr(V_AUTHENTICATION_STRING, '':'', 1,1);'||chr(10)||
'      if ((V_OFFSET> 1) and (V_OFFSET + 1 < length(V_AUTHENTICATION_STRING))) then'||chr(10)||
'        V_USERNAME := su';

s:=s||'bstr(V_AUTHENTICATION_STRING, 1, V_OFFSET-1);'||chr(10)||
'        V_PASSWORD := substr(V_AUTHENTICATION_STRING, V_OFFSET+1);'||chr(10)||
'        V_OFFSET := instr(V_USERNAME, ''/'', 1,1);'||chr(10)||
'        if ((V_OFFSET> 1) and (V_OFFSET + 1 < length(V_USERNAME))) then'||chr(10)||
'          V_WORKSPACE := substr(V_USERNAME,1, V_OFFSET-1);'||chr(10)||
'          V_USERNAME  := substr(V_USERNAME,V_OFFSET+1);'||chr(10)||
'          V_RESULT := APEX_AUTHENTICATION.doAuthent';

s:=s||'ication(P_USERNAME => V_USERNAME, P_PASSWORD => V_PASSWORD, P_WORKSPACE => V_WORKSPACE);          '||chr(10)||
'          if (V_RESULT.existsNode(''/custom_authenticate/user'') = 1) then'||chr(10)||
'            return V_RESULT.getStringVal();'||chr(10)||
'          else '||chr(10)||
'            V_ERROR_MSG := V_RESULT.extract(''/custom_authenticate/error/text()'').getStringVal();'||chr(10)||
'          end if;'||chr(10)||
'        else '||chr(10)||
'          V_ERROR_MSG := ''Unable to loc';

s:=s||'ate Workspace.'';'||chr(10)||
'        end if;'||chr(10)||
'      else'||chr(10)||
'        V_ERROR_MSG := ''Unable to locate Password.'';    '||chr(10)||
'      end if;'||chr(10)||
'    else'||chr(10)||
'      V_ERROR_MSG := ''Invalid Authentication Scheme.'';'||chr(10)||
'    end if;'||chr(10)||
'  else'||chr(10)||
'   return XMLType(''<custom_authenticate><user>ANONYMOUS</user></custom_authenticate>'').getStringVal();'||chr(10)||
'   -- V_ERROR_MSG := ''Invalid HTTP Authentication Header (NULL).'';'||chr(10)||
'  end if;'||chr(10)||
''||chr(10)||
' select xmlConcat'||chr(10)||
'   ';

s:=s||'      ('||chr(10)||
'           xmlElement("URL",URL),'||chr(10)||
'           xmlElement("Auth",AuthInfo),'||chr(10)||
'           xmlElement("Workspace",V_WORKSPACE),'||chr(10)||
'           xmlElement("User",V_USERNAME),'||chr(10)||
'           xmlElement("Password",NULL),'||chr(10)||
'           xmlElement("Error",V_ERROR_MSG)'||chr(10)||
'         )'||chr(10)||
'    into V_PARAMETERS'||chr(10)||
'    from dual;'||chr(10)||
''||chr(10)||
'  XFILES_LOGGING.writeLogRecord(sys_context(''USERENV'',''CURRENT_SCHEMA''),''.AUTHENTICATEUSER'', SYS';

s:=s||'TIMESTAMP, V_PARAMETERS);'||chr(10)||
'  return V_ERROR_MSG;'||chr(10)||
'exception'||chr(10)||
'  when others then'||chr(10)||
'    XFILES_LOGGING.writeErrorRecord(sys_context(''USERENV'',''CURRENT_SCHEMA''),''.AUTHENTICATEUSER'',SYSTIMESTAMP, V_PARAMETERS, XFILES_LOGGING.captureStackTrace()); '||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'show errors'||chr(10)||
'--'||chr(10)||
'grant execute on authenticateUser to ANONYMOUS'||chr(10)||
'/';

wwv_flow_api.create_install_script(
  p_id => 3315649665320133 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'WEBDAV_AUTHENTICATION',
  p_sequence=> 380,
  p_script_type=> 'INSTALL',
  p_script_clob=> s);
end;
 
 
end;
/

 
begin
 
declare
    s varchar2(32767) := null;
    l_clob clob;
    l_length number := 1;
begin
s:=s||'--'||chr(10)||
'-- Drop and Recreate the XFiles Log Writer Queue, Queue Table and Package.'||chr(10)||
'--'||chr(10)||
'-- ************************************************'||chr(10)||
'-- *           STOP the Queue                     *'||chr(10)||
'-- ************************************************'||chr(10)||
'--'||chr(10)||
'DECLARE'||chr(10)||
'  non_existant_queue exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( non_existant_queue , -24010 );'||chr(10)||
''||chr(10)||
'  V_QUEUE_NAME       VARCHAR2(128) := sys_context(''USERENV'',''CU';

s:=s||'RRENT_SCHEMA'') || ''.LOG_RECORD_Q'';'||chr(10)||
'  '||chr(10)||
'BEGIN'||chr(10)||
'  begin'||chr(10)||
'    dbms_aqadm.stop_queue( V_QUEUE_NAME );'||chr(10)||
'  exception'||chr(10)||
'    when non_existant_queue then'||chr(10)||
'        null;'||chr(10)||
'  end;'||chr(10)||
'END;'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- ************************************************'||chr(10)||
'-- *      DE-REGISTER the Event Handler           *'||chr(10)||
'-- ************************************************'||chr(10)||
'--'||chr(10)||
'DECLARE '||chr(10)||
'  non_existant_queue exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( non_';

s:=s||'existant_queue , -25205 );'||chr(10)||
'  not_registered exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( not_registered , -24950 );'||chr(10)||
''||chr(10)||
'  reginfo             sys.aq$_reg_info; '||chr(10)||
'  reginfolist         sys.aq$_reg_info_list; '||chr(10)||
'  '||chr(10)||
'   V_QUEUE_NAME       VARCHAR2(128) := sys_context(''USERENV'',''CURRENT_SCHEMA'') || ''.LOG_RECORD_Q'';'||chr(10)||
'   V_EVENT_URL        VARCHAR2(128) := ''plsql://'' || sys_context(''USERENV'',''CURRENT_SCHEMA'') || ''.XFILE';

s:=s||'S_LOGWRITER.DEQUEUE_LOG_RECORD'';'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  begin'||chr(10)||
'    reginfo := sys.aq$_reg_info(V_QUEUE_NAME, '||chr(10)||
'                                DBMS_AQ.NAMESPACE_AQ, '||chr(10)||
'                                V_EVENT_URL, '||chr(10)||
'                                HEXTORAW(''FF'')); '||chr(10)||
''||chr(10)||
'    reginfolist := sys.aq$_reg_info_list(reginfo); '||chr(10)||
'    dbms_aq.unregister(reginfolist, 1); '||chr(10)||
'  exception'||chr(10)||
'    when non_existant_queue then'||chr(10)||
'        null;'||chr(10)||
' ';

s:=s||'   when not_registered then'||chr(10)||
'        null;'||chr(10)||
'  end;END;'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- ************************************************'||chr(10)||
'-- *           Delete the Queue                   *'||chr(10)||
'-- ************************************************'||chr(10)||
'--'||chr(10)||
'DECLARE'||chr(10)||
'  non_existant_queue exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( non_existant_queue , -24010 );'||chr(10)||
''||chr(10)||
'  V_QUEUE_NAME       VARCHAR2(128) := sys_context(''USERENV'',''CURRENT_SCHEMA'') || ''.LOG';

s:=s||'_RECORD_Q'';'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  begin'||chr(10)||
'    DBMS_AQADM.DROP_QUEUE (V_QUEUE_NAME);'||chr(10)||
'  exception'||chr(10)||
'    when non_existant_queue then'||chr(10)||
'        null;'||chr(10)||
'  end;'||chr(10)||
'end;'||chr(10)||
'/ '||chr(10)||
'--'||chr(10)||
'-- ************************************************'||chr(10)||
'-- *           Drop the Queue Table               *'||chr(10)||
'-- ************************************************'||chr(10)||
'--'||chr(10)||
'DECLARE'||chr(10)||
'  non_existant_queue_table exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( non_existant_queue_table';

s:=s||' , -24002 );'||chr(10)||
''||chr(10)||
'  V_QUEUE_TABLE   VARCHAR2(128) := sys_context(''USERENV'',''CURRENT_SCHEMA'') || ''.LOG_RECORD_QUEUE_TABLE'';'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  begin'||chr(10)||
'    DBMS_AQADM.DROP_QUEUE_TABLE (V_QUEUE_TABLE);'||chr(10)||
'  exception'||chr(10)||
'    when non_existant_queue_table then'||chr(10)||
'        null;'||chr(10)||
'  end;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- ************************************************'||chr(10)||
'-- *          Create the Queue Table              *'||chr(10)||
'-- ****************************';

s:=s||'********************'||chr(10)||
'--'||chr(10)||
'declare'||chr(10)||
'  queue_table_exists exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( queue_table_exists , -24001 );'||chr(10)||
''||chr(10)||
'  V_QUEUE_TABLE   VARCHAR2(128) := sys_context(''USERENV'',''CURRENT_SCHEMA'') || ''.LOG_RECORD_QUEUE_TABLE'';'||chr(10)||
'  V_COMMENT       VARCHAR2(128) := sys_context(''USERENV'',''CURRENT_SCHEMA'') || '' Asynchronous Logging'';'||chr(10)||
'  V_STORAGE       VARCHAR2(128);'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'	'||chr(10)||
'	select ''TABLESPACE "'' || TAB';

s:=s||'LESPACE_NAME || ''"'' '||chr(10)||
'	  into V_STORAGE'||chr(10)||
'	  from USER_TABLESPACES'||chr(10)||
'	 where rownum = 1;'||chr(10)||
'	'||chr(10)||
'  dbms_aqadm.create_queue_table'||chr(10)||
'  (                          '||chr(10)||
'    queue_table        => V_QUEUE_TABLE,            '||chr(10)||
'    comment            => V_COMMENT,'||chr(10)||
'    multiple_consumers => FALSE,                             '||chr(10)||
'    queue_payload_type => ''SYS.XMLType'',                       '||chr(10)||
'    compatible         => ''8.1'','||chr(10)||
'   ';

s:=s||' storage_clause     => V_STORAGE'||chr(10)||
'   );'||chr(10)||
'exception'||chr(10)||
'  when queue_table_exists then'||chr(10)||
'    null;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- ************************************************'||chr(10)||
'-- *             Create the Queue                 *'||chr(10)||
'-- ************************************************'||chr(10)||
'--'||chr(10)||
'declare'||chr(10)||
'  queue_exists exception;'||chr(10)||
'  PRAGMA EXCEPTION_INIT( queue_exists , -24006 );'||chr(10)||
''||chr(10)||
'  V_QUEUE_NAME    VARCHAR2(128) := sys_context(''USERENV''';

s:=s||',''CURRENT_SCHEMA'') || ''.LOG_RECORD_Q'';'||chr(10)||
'  V_QUEUE_TABLE   VARCHAR2(128) := sys_context(''USERENV'',''CURRENT_SCHEMA'') || ''.LOG_RECORD_QUEUE_TABLE'';'||chr(10)||
''||chr(10)||
'begin'||chr(10)||
'  dbms_aqadm.create_queue'||chr(10)||
'  (                                   '||chr(10)||
'    queue_name   =>  V_QUEUE_NAME,        '||chr(10)||
'    queue_table  =>  V_QUEUE_TABLE'||chr(10)||
'  );'||chr(10)||
'exception'||chr(10)||
'  when queue_exists then'||chr(10)||
'    null;'||chr(10)||
'end;'||chr(10)||
'/'||chr(10)||
'--'||chr(10)||
'-- *******************************************';

s:=s||'*****'||chr(10)||
'-- *         REGISTER the Event Handler           *'||chr(10)||
'-- ************************************************'||chr(10)||
'--'||chr(10)||
'DECLARE '||chr(10)||
'  reginfo            sys.aq$_reg_info; '||chr(10)||
'  reginfolist        sys.aq$_reg_info_list; '||chr(10)||
''||chr(10)||
'  V_QUEUE_NAME       VARCHAR2(128) := sys_context(''USERENV'',''CURRENT_SCHEMA'') || ''.LOG_RECORD_Q'';'||chr(10)||
'  V_EVENT_URL        VARCHAR2(128) := ''plsql://'' || sys_context(''USERENV'',''CURRENT_SCHEMA'') ||';

s:=s||' ''.XFILES_LOGWRITER.DEQUEUE_LOG_RECORD'';'||chr(10)||
''||chr(10)||
'BEGIN '||chr(10)||
'  reginfo := sys.aq$_reg_info( V_QUEUE_NAME, '||chr(10)||
'                               DBMS_AQ.NAMESPACE_AQ, '||chr(10)||
'                               V_EVENT_URL, '||chr(10)||
'                               HEXTORAW(''FF'')); '||chr(10)||
''||chr(10)||
'  reginfolist := sys.aq$_reg_info_list(reginfo); '||chr(10)||
'  sys.dbms_aq.register(reginfolist, 1); '||chr(10)||
'END;'||chr(10)||
'/ '||chr(10)||
'--'||chr(10)||
'-- ************************************************'||chr(10)||
'--';

s:=s||' *           Start the Queue                    *'||chr(10)||
'-- ************************************************'||chr(10)||
'--'||chr(10)||
'declare'||chr(10)||
'  V_QUEUE_NAME       VARCHAR2(128) := sys_context(''USERENV'',''CURRENT_SCHEMA'') || ''.LOG_RECORD_Q'';'||chr(10)||
'BEGIN'||chr(10)||
'  dbms_aqadm.start_queue'||chr(10)||
'  (                                   '||chr(10)||
'    queue_name   =>  V_QUEUE_NAME        '||chr(10)||
'  );'||chr(10)||
'END;'||chr(10)||
'/';

wwv_flow_api.create_install_script(
  p_id => 8674710145209998 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_ENABLE_LOG_QUEUE',
  p_sequence=> 500,
  p_script_type=> 'INSTALL',
  p_script_clob=> s);
end;
 
 
end;
/

--application/deployment/checks
prompt  ...application deployment checks
--
 
begin
 
wwv_flow_api.create_install_check(
  p_id => 7909223726119277 + wwv_flow_api.g_id_offset,
  p_flow_id => wwv_flow.g_flow_id,
  p_install_id=> 3230176827249316 + wwv_flow_api.g_id_offset,
  p_name => 'XFILES_FOLDER_EXISTS',
  p_sequence=> 10,
  p_check_type=> 'EXISTS',
  p_check_condition=> 'select 1 '||chr(10)||
'  from RESOURCE_VIEW'||chr(10)||
' where equals_path(res,''/XFILES/APEX'') = 1',
  p_failure_message=> 'Unable to find XFILES Installation Folder. Please manually run installation scripts 10 XFILES_DBA_TASKS as a DBA before installed this application.');
 
 
end;
/

--application/deployment/buildoptions
prompt  ...application deployment build options
--
 
begin
 
null;
 
end;
/

--application/end_environment
commit;
commit;
begin 
execute immediate 'alter session set nls_numeric_characters='''||wwv_flow_api.g_nls_numeric_chars||'''';
end;
/
set verify on
set feedback on
prompt  ...done
