
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
-- XDBPM_NAMESPACES should be created under XDBPM
--
alter session set current_schema = XDBPM
/
create or replace package XDBPM_NAMESPACES
as   
    -- 10.2.x Intermedia Schema Namespaces
    
    C_EXIF_NAMESPACE             constant VARCHAR2(128) := DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE || '/meta/exif';
    C_IPTC_NAMESPACE             constant VARCHAR2(128) := DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE || '/ord/meta/iptc';
    C_DICOM_NAMESPACE            constant VARCHAR2(128) := DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE || '/ord/meta/dicomImage';
    C_ORDIMAGE_NAMESPACE         constant VARCHAR2(128) := DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE || '/ord/meta/ordimage';
    C_XMP_NAMESPACE              constant VARCHAR2(128) := DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE || '/ord/meta/xmp';

    C_EXIF_PREFIX_EXIF           constant VARCHAR2(128) := 'xmlns:exif="'  || C_EXIF_NAMESPACE     || '"';
    C_IPTC_PREFIX_IPTC           constant VARCHAR2(128) := 'xmlns:iptc="'  || C_IPTC_NAMESPACE     || '"';
    C_DICOM_PREFIX_DICOM         constant VARCHAR2(128) := 'xmlns:dicom="' || C_DICOM_NAMESPACE    || '"';
    C_ORDIMAGE_PREFIX_ORD        constant VARCHAR2(128) := 'xmlns:ord="'   || C_ORDIMAGE_NAMESPACE || '"';
    C_XMP_PREFIX_XMP             constant VARCHAR2(128) := 'xmlns:xmp="'   || C_XMP_NAMESPACE      || '"';

    -- PM Defined Namespaces
    C_ORACLE_XDBPM_NAMESPACE    constant VARCHAR2(128) := DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE_XDB || '/pm';
    C_METADATA_NAMESPACE        constant VARCHAR2(128) := DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE_XDB || '/userMetaData';

    C_RESOURCE_EVENT_NAMESPACE  constant VARCHAR2(128) := C_ORACLE_XDBPM_NAMESPACE || '/resourceEvent';
    C_RESOURCE_EVENT_PREFIX_RE  constant VARCHAR2(128) := 'xmlns:re="' || C_RESOURCE_EVENT_NAMESPACE || '"';

    function ORACLE_XDB_NAMESPACE        return varchar2 deterministic;
    function RESOURCE_NAMESPACE          return varchar2 deterministic;
    function ACL_NAMESPACE               return varchar2 deterministic;
    function XDBSCHEMA_NAMESPACE         return varchar2 deterministic;
    function XDBCONFIG_NAMESPACE         return varchar2 deterministic;

    function XMLSCHEMA_NAMESPACE         return varchar2 deterministic;
    function XMLINSTANCE_NAMESPACE       return varchar2 deterministic;

    function RESOURCE_PREFIX_R           return varchar2 deterministic;
    function ACL_PREFIX_ACL              return varchar2 deterministic;
    function XDBSCHEMA_PREFIX_XDB        return varchar2 deterministic;
    function XDBCONFIG_PREFIX_CFG        return varchar2 deterministic;

    function XMLSCHEMA_PREFIX_XSD        return varchar2 deterministic;
    function XMLINSTANCE_PREFIX_XSI      return varchar2 deterministic;

    function XDBSCHEMA_PREFIXES          return varchar2 deterministic;

    function XDBSCHEMA_LOCATION          return varchar2 deterministic;
    function XDBCONFIG_LOCATION          return varchar2 deterministic;
    function ACL_LOCATION                return varchar2 deterministic;
    function RESOURCE_LOCATION           return varchar2 deterministic;

    function BINARY_CONTENT              return varchar2 deterministic;
    function TEXT_CONTENT                return varchar2 deterministic;
    function ACL_CONTENT                 return varchar2 deterministic;

    function EXIF_NAMESPACE              return varchar2 deterministic;
    function IPTC_NAMESPACE              return varchar2 deterministic;
    function DICOM_NAMESPACE             return varchar2 deterministic;
    function ORDIMAGE_NAMESPACE          return varchar2 deterministic;
    function XMP_NAMESPACE               return varchar2 deterministic;

    function EXIF_PREFIX_EXIF            return varchar2 deterministic;
    function IPTC_PREFIX_IPTC            return varchar2 deterministic;
    function DICOM_PREFIX_DICOM          return varchar2 deterministic;
    function ORDIMAGE_PREFIX_ORD         return varchar2 deterministic;
    function XMP_PREFIX_XMP              return varchar2 deterministic; 

    function METADATA_NAMESPACE          return varchar2 deterministic;

    function RESOURCE_EVENT_NAMESPACE    return varchar2 deterministic;
    function RESOURCE_CONFIG_NAMESPACE   return varchar2 deterministic;
    function XMLDIFF_NAMESPACE           return varchar2 deterministic;

    function RESOURCE_EVENT_PREFIX_RE    return varchar2 deterministic;
    function RESOURCE_CONFIG_PREFIX_RC   return varchar2 deterministic;
    function XMLDIFF_PREFIX_XD           return varchar2 deterministic;
end;
/
show errors
--
create or replace synonym XDB_NAMESPACES for XDBPM_NAMESPACES
/
grant execute on XDBPM_NAMESPACES to public
/
create or replace package body XDBPM_NAMESPACES
as
--
function ORACLE_XDB_NAMESPACE        return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NAMESPACE_ORACLE_XDB; end;
--
function ACL_NAMESPACE               return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NAMESPACE_ACL; end;
--
function RESOURCE_NAMESPACE          return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NAMESPACE_RESOURCE; end;
--
function RESOURCE_CONFIG_NAMESPACE   return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NAMESPACE_RESOURCE_CONFIG; end;
--
function XDBCONFIG_NAMESPACE         return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NAMESPACE_XDBCONFIG; end;
--
function XDBSCHEMA_NAMESPACE         return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NAMESPACE_XDBSCHEMA; end;
--
function XMLDIFF_NAMESPACE           return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NAMESPACE_XMLDIFF; end;
-- 
function XMLINSTANCE_NAMESPACE       return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NAMESPACE_XMLINSTANCE; end;
--
function XMLSCHEMA_NAMESPACE         return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NAMESPACE_XMLSCHEMA; end;
--
function ACL_PREFIX_ACL              return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NSPREFIX_ACL_ACL; end;
--
function RESOURCE_PREFIX_R           return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NSPREFIX_RESOURCE_R; end;
--
function RESOURCE_CONFIG_PREFIX_RC   return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NSPREFIX_RESCONFIG_RC; end;
-- 
function XDBCONFIG_PREFIX_CFG        return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NSPREFIX_XDBCONFIG_CFG; end;
--
function XDBSCHEMA_PREFIX_XDB        return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NSPREFIX_XDB_XDB; end;
--
function XMLDIFF_PREFIX_XD           return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NSPREFIX_XMLDIFF_XD; end;
--
function XMLINSTANCE_PREFIX_XSI      return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NSPREFIX_XMLINSTANCE_XSI; end;
--
function XMLSCHEMA_PREFIX_XSD        return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD; end;
--
function XDBSCHEMA_PREFIXES          return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.NSPREFIX_XDB_XDB || ' ' || DBMS_XDB_CONSTANTS.NSPREFIX_XMLSCHEMA_XSD; end;
--
function ACL_LOCATION                return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.SCHEMAURL_ACL; end;
-- 
function RESOURCE_LOCATION           return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.SCHEMAURL_RESOURCE; end;
-- 
function XDBCONFIG_LOCATION          return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.SCHEMAURL_XDBCONFIG; end;
--
function XDBSCHEMA_LOCATION          return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.SCHEMAURL_XDBSCHEMA; end;
--
function BINARY_CONTENT              return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.SCHEMAELEM_RESCONTENT_BINARY; end;
--
function TEXT_CONTENT                return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.SCHEMAELEM_RESCONTENT_TEXT; end;
--
function ACL_CONTENT                 return varchar2 deterministic as begin return DBMS_XDB_CONSTANTS.SCHEMAELEM_RES_ACL; end;
--
-- Intermedia Namespaces
--
function EXIF_NAMESPACE              return varchar2 deterministic as begin return C_EXIF_NAMESPACE; end;
-- 
function IPTC_NAMESPACE              return varchar2 deterministic as begin return C_IPTC_NAMESPACE; end;
--
function DICOM_NAMESPACE             return varchar2 deterministic as begin return C_DICOM_NAMESPACE; end;
--
function ORDIMAGE_NAMESPACE          return varchar2 deterministic as begin return C_ORDIMAGE_NAMESPACE; end;
--
function XMP_NAMESPACE               return varchar2 deterministic as begin return C_XMP_NAMESPACE; end;
--
function EXIF_PREFIX_EXIF            return varchar2 deterministic as begin return C_EXIF_PREFIX_EXIF; end;
--    
function IPTC_PREFIX_IPTC            return varchar2 deterministic as begin return C_IPTC_PREFIX_IPTC; end;
--    
function DICOM_PREFIX_DICOM          return varchar2 deterministic as begin return C_DICOM_PREFIX_DICOM; end;
--
function ORDIMAGE_PREFIX_ORD         return varchar2 deterministic as begin return C_ORDIMAGE_PREFIX_ORD; end;
--
function XMP_PREFIX_XMP              return varchar2 deterministic as begin return C_XMP_PREFIX_XMP; end; 
--
-- PM Defined Namespaces
--
function METADATA_NAMESPACE          return varchar2 deterministic as begin return C_METADATA_NAMESPACE; end;
--
function RESOURCE_EVENT_NAMESPACE    return varchar2 deterministic as begin return C_RESOURCE_EVENT_NAMESPACE; end;
--
function RESOURCE_EVENT_PREFIX_RE    return varchar2 deterministic as begin return C_RESOURCE_EVENT_PREFIX_RE; end;
--
end;
/
show errors
--
alter session set current_schema = SYS
/
