<?xml version="1.0" encoding="UTF-8"?>
<!--

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

-->

<!-- edited with XMLSpy v2008 rel. 2 sp2 (http://www.altova.com) by Mark Drake (Oracle XML DB) -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/XDBResource.xsd">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/XMLSearch/xsl/common.xsl"/>
	<xsl:template name="schemaSummary">
		<div class="inputFormBorder" style="width:100%">
			<span class="labelAndValue">
				<span class="labelRight">Table Owner</span>
				<span style="display:inline-block;width:5px"/>
				<input id="tableOwner" name="tableOwner" size="28" type="text" maxlength="32" disabled="disabled"/>
			</span>
			<span style="display:inline-block;width:5px"/>
			<span class="labelAndValue">
				<span class="labelRight">Table Name</span>
				<span style="display:inline-block;width:5px"/>
				<input id="tableName" name="tableName" size="28" type="text" maxlength="32" disabled="disabled"/>
			</span>
			<span style="display:inline-block;width:5px"/>
			<span class="labelAndValue">
				<span class="labelRight">Column Name</span>
				<span style="display:inline-block;width:5px"/>
				<input id="columnName" name="columnName" size="28" type="text" maxlength="32" disabled="disabled"/>
			</span>
		</div>
		<div class="inputFormBorder" style="width:100%">
			<span class="labelAndValue">
				<span class="labelRight">Schema Owner</span>
				<span style="display:inline-block;width:5px"/>
				<input id="schemaOwner" class="xg" name="schemaOwner" size="28" type="text" maxlength="32" disabled="disabled"/>
			</span>
			<span style="display:inline-block;width:5px"/>
			<div class="labelAndValue">
				<span class="labelRight">Schema Location Hint</span>
				<span style="display:inline-block;width:5px"/>
				<input id="schemaLocationHint" name="schemaLocationHint" size="76" maxlength="700" type="text" disabled="disabled"/>
			</div>
			<span class="labelAndValue">
				<span class="labelRight">Element</span>
				<span style="display:inline-block;width:5px"/>
				<input id="elementName" name="elementName" size="32" type="text" maxlength="256" disabled="disabled"/>
			</span>
		</div>
	</xsl:template>
	<xsl:template match="/">
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'Oracle XML DB XML Schema Data Guide'"/>
		</xsl:call-template>
		<xsl:call-template name="viewCurrentSQL"/>
		<xsl:call-template name="searchActions"/>
		<xsl:for-each select="r:Resource">
			<div class="formAreaBackground">
				<div class="xfilesIndent">
					<div style="height:5px;"/>
					<xsl:call-template name="schemaSummary"/>
					<div style="height:5px;"/>
					<div id="treeView" class="searchTree"/>
					<xsl:call-template name="searchRegions"/>
				</div>
			</div>
		</xsl:for-each>
		<xsl:call-template name="searchFooter"/>
	</xsl:template>
</xsl:stylesheet>
