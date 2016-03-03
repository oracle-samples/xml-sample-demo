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
	<xsl:template name="printGlobalElements">
		<xsl:param name="index"/>
		<xsl:for-each select="globalElements/globalElement">
			<option>
				<xsl:attribute name="value"><xsl:value-of select="concat('&quot;',@defaultTableOwner,'&quot;.&quot;',@defaultTable,'&quot;.&quot;',.,'&quot;')"/></xsl:attribute>
				<xsl:value-of select="."/>
			</option>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="printSchema">
		<xsl:param name="schemaType"/>
		<table class="withBorder defaultFont" summary="">
			<tbody>
				<tr class="tableHeader">
					<th title="Owner" class="alignLeft blueGradient">Owner</th>
					<th title="SchemaType" class="alignLeft blueGradient">Type</th>
					<th title="Schema" class="alignLeft blueGradient">Schema Location Hint</th>
					<th title="Global Elements" class="alignLeft blueGradient">Global Element(s)</th>
				</tr>
				<xsl:for-each select="globalSchema">
					<xsl:sort order="descending" select="OWNER"/>
					<xsl:sort order="descending" select="schemaType"/>
					<xsl:sort order="descending" select="URL"/>
					<tr class="noBorder">
						<td class="withBorder">
							<xsl:value-of select="OWNER"/>
						</td>
						<td class="withBorder">
							<xsl:value-of select="schemaType"/>
						</td>
						<td class="withBorder">
							<a href="#" class="undecoratedLink">
								<xsl:attribute name="title"><xsl:text>Query XML Schema "</xsl:text><xsl:value-of select="URL"/><xsl:text>".</xsl:text></xsl:attribute>
								<xsl:attribute name="onclick"><xsl:text>xmlSchemaSearch('</xsl:text><xsl:value-of select="OWNER"/><xsl:text>','</xsl:text><xsl:value-of select="URL"/><xsl:text>',document.getElementById('</xsl:text><xsl:value-of select="concat($schemaType,'ElementList.',position())"/><xsl:text>'.value);return false</xsl:text></xsl:attribute>
								<span style="display:inline-block;width:5px"/>
								<img src="/XFILES/lib/icons/guidedSearch.png" alt="Search" border="0" align="absmiddle" width="16" height="16"/>
								<span style="display:inline-block;width:5px"/>
								<xsl:value-of select="URL"/>
							</a>
						</td>
						<td class="withBorder">
							<xsl:choose>
								<xsl:when test="count(globalElements/globalElement) > 1">
									<select>
										<xsl:attribute name="id"><xsl:value-of select="concat($schemaType,'ElementList.',position())"/></xsl:attribute>
										<xsl:call-template name="printGlobalElements">
											<xsl:with-param name="index" select="position()"/>
										</xsl:call-template>
									</select>
								</xsl:when>
								<xsl:otherwise>
									<input type="hidden">
										<xsl:attribute name="id"><xsl:value-of select="concat($schemaType,'ElementList.',position())"/></xsl:attribute>
										<xsl:attribute name="value"><xsl:value-of select="concat('&quot;',globalElements/globalElement/@defaultTableOwner,'&quot;.&quot;',globalElements/globalElement/@defaultTable,'&quot;.&quot;',globalElements/globalElement,'&quot;')"/></xsl:attribute>
									</input>
									<input id="globalSchemaElement" size="32" type="text" maxlength="32" disabled="disabled">
										<xsl:attribute name="value"><xsl:value-of select="globalElements/globalElement"/></xsl:attribute>
									</input>
								</xsl:otherwise>
							</xsl:choose>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		<div style="height:14px;"/>
	</xsl:template>
	<xsl:template match="/">
		<div id="localScriptList" style="display:none;">
			<span>/XFILES/lite/js/XMLSchemaList.js</span>
		</div>
		<div id="localScripts" style="display:none;"/>
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'Local and Global XML Schemas'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'25px'"/>
		</xsl:call-template>
		<div class="formAreaBackground">
			<div class="xfilesIndent">
				<xsl:for-each select="r:Resource/r:Contents/schemaList">
					<div class="formText14">
						<xsl:text>Local XML Schemas</xsl:text>
					</div>
					<xsl:for-each select="localSchemas[locallSchema]">
						<xsl:call-template name="printSchema">
							<xsl:with-param name="schemaType" select="'local'"/>
						</xsl:call-template>
					</xsl:for-each>
					<div class="formText14">
						<xsl:text>Global XML Schemas</xsl:text>
					</div>
					<xsl:for-each select="globalSchemas[globalSchema]">
						<xsl:call-template name="printSchema">
							<xsl:with-param name="schemaType" select="'global'"/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:for-each>
			</div>
		</div>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesFooter"/>
	</xsl:template>
</xsl:stylesheet>
