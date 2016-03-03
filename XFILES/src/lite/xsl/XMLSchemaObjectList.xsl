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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/xfiles">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:template name="printObject">
		<xsl:param name="local"/>
		<tr class="noBorder">
			<xsl:if test="$local='false'">
				<td>
					<xsl:value-of select="owner"/>
				</td>
			</xsl:if>
			<td>
				<xsl:value-of select="tableName"/>
			</td>
			<td>
				<xsl:value-of select="column"/>
			</td>
			<td>
				<xsl:value-of select="schemaType"/>
			</td>
			<td>
				<xsl:value-of select="schemaOwner"/>
			</td>
			<td>
				<xsl:value-of select="schemaLocationHint"/>
			</td>
			<td>
				<xsl:value-of select="elementName"/>
			</td>
			<td>
				<a href="#" class="undecoratedLink">
					<xsl:attribute name="title"><xsl:text>Query </xsl:text><xsl:value-of select="concat('&quot;',owner,'&quot;.&quot;',tableName,'&quot;.&quot;',elementName,'&quot;')"/><xsl:text>.</xsl:text></xsl:attribute>
					<xsl:attribute name="onclick"><xsl:text>xmlSchemaObjectSearch('</xsl:text><xsl:value-of select="owner"/><xsl:text>','</xsl:text><xsl:value-of select="tableName"/><xsl:text>','</xsl:text><xsl:value-of select="column"/><xsl:text>','</xsl:text><xsl:value-of select="schemaOwner"/><xsl:text>','</xsl:text><xsl:value-of select="schemaLocationHint"/><xsl:text>','</xsl:text><xsl:value-of select="elementName"/><xsl:text>');return false</xsl:text></xsl:attribute>
					<img src="/XFILES/lib/icons/guidedSearch.png" alt="Search" border="0" align="absmiddle" width="16" height="16"/>
					<span style="display:inline-block;width:5px"/>
					<xsl:value-of select="URL"/>
				</a>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="printTableHeader">
		<xsl:param name="local"/>
		<thead>
			<tr>
				<xsl:if test="$local='false'">
					<th title="Table Owner" class="alignLeft blueGradient">Table Owner</th>
				</xsl:if>
				<th title="Table Name" class="alignLeft blueGradient">Table Name</th>
				<th title="Column Name" class="alignLeft blueGradient">Column Name</th>
				<th title="Schema Type" class="alignLeft blueGradient">Schema Type</th>
				<th title="Schema Owner" class="alignLeft blueGradient">Schema Owner</th>
				<th title="Schema Location Hint" class="alignLeft blueGradient">Schema Location Hint</th>
				<th title="Element" class="alignLeft blueGradient">Element</th>
				<th title="Search" class="alignCenter blueGradient">Search</th>
			</tr>
		</thead>
	</xsl:template>
	<xsl:template name="localObjects">
		<xsl:call-template name="printTableHeader">
			<xsl:with-param name="local" select="'true'"/>
		</xsl:call-template>
		<tbody>
			<xsl:for-each select="xmlObject[owner=../@currentUser]">
				<xsl:sort order="descending" select="tableName"/>
				<xsl:sort order="descending" select="column"/>
				<xsl:call-template name="printObject">
					<xsl:with-param name="local" select="'true'"/>
				</xsl:call-template>
			</xsl:for-each>
		</tbody>
	</xsl:template>
	<xsl:template name="globalObjects">
		<xsl:call-template name="printTableHeader">
			<xsl:with-param name="local" select="'false'"/>
		</xsl:call-template>
		<tbody>
			<xsl:for-each select="xmlObject[owner!=../@currentUser]">
				<xsl:sort order="descending" select="tableOwner"/>
				<xsl:sort order="descending" select="tableName"/>
				<xsl:sort order="descending" select="column"/>
				<xsl:call-template name="printObject">
					<xsl:with-param name="local" select="'false'"/>
				</xsl:call-template>
			</xsl:for-each>
		</tbody>
	</xsl:template>
	<xsl:template name="printTabs">
		<div class="tab-pane active" id="localObjects">
			<div class="container">
				<table class="table table-condensed table-bordered table-striped" summary="">
					<xsl:call-template name="localObjects"/>
				</table>
			</div>
		</div>
		<div class="tab-pane" id="globalObjects">
			<div class="container">
				<table class="table table-condensed table-bordered table-striped" summary="">
					<xsl:call-template name="globalObjects"/>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="/">
		<div id="localScriptList" style="display:none;">
			<span>/XFILES/lite/js/XMLSchemaList.js</span>
		</div>
		<div id="localScripts" style="display:none;"/>
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'Schema Based XML Objects'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'25px'"/>
		</xsl:call-template>
		<div class="formAreaBackground">
			<div class="xfilesIndent">
				<xsl:for-each select="r:Resource/r:Contents/xmlObjectList">
					<div>
						<ul class="nav nav-tabs" role="tablist" id="sc.options">
							<li>
								<a href="#localObjects" role="tab" data-toggle="tab">Local XML Objects</a>
							</li>
							<li>
								<a href="#globalObjects" role="tab" data-toggle="tab">Public XML Objects</a>
							</li>
						</ul>
					</div>
					<!-- Tab panes -->
					<div class="tab-content">
						<br/>
						<xsl:call-template name="printTabs"/>
					</div>
				</xsl:for-each>
			</div>
		</div>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesFooter"/>
	</xsl:template>
</xsl:stylesheet>
