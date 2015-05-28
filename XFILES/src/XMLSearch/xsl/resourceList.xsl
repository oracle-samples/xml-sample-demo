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

<xsl:stylesheet version="1.0" xmlns:orawsv="http://xmlns.oracle.com/orawsv" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" exclude-result-prefixes="orawsv xsl fo soap">
	<xsl:output version="1.0" encoding="utf-8" omit-xml-declaration="yes" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:variable name="NodeMapName" select="/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/@nodeMapName"/>
	<xsl:template name="PrintParentPath">
		<xsl:param name="Path"/>
		<xsl:value-of select="substring-before($Path,'/')"/>
		<xsl:if test="contains(substring-after($Path, '/' ),'/')">
			<xsl:text>/</xsl:text>
			<xsl:call-template name="PrintParentPath">
				<xsl:with-param name="Path" select="substring-after($Path,'/')"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="printSearchMatch">
		<xsl:if test="orawsv:RANK">
			<td class="withBorder">
				<span>
					<xsl:value-of select="orawsv:RANK"/>
				</span>
			</td>
		</xsl:if>
		<td class="withBorder">
			<a>
				<xsl:attribute name="href"><xsl:text>/XFILES/lite/Resource.html?target=</xsl:text><xsl:value-of select="orawsv:resourcePath"/></xsl:attribute>
				<img width="16px" height="16px" src="/XFILES/lib/icons/pageProperties.png" alt="Select to access File Properties"  style="vertical-align: middle; border: 0;"/>
				<!-- border: none; } a:link -->
			</a>
		</td>
		<td class="withBorder">
		<!--
				<img src="/XFILES/lib/icons/xmlDocument.png" alt="Resource XML" border="0" align="top">
					<xsl:attribute name="onclick"><xsl:text>fetchDocument(</xsl:text><xsl:value-of select="$NodeMapName"/><xsl:text>,'RESPATH','</xsl:text><xsl:value-of select="orawsv:resourcePath"/><xsl:text>');return false;</xsl:text></xsl:attribute>
				</img>
        -->
        <a>
			<xsl:choose>
				<xsl:when test="orawsv:CONTAINER='true'">
					<xsl:attribute name="href"><xsl:text>/XFILES/lite/Folder.html?target=</xsl:text><xsl:value-of select="orawsv:resourcePath"/></xsl:attribute> 
					<img alt="" style="vertical-align: middle; border: 0;" width="16px" height="16px" src="/XFILES/lib/icons/readOnlyFolderClosed.png">
						<xsl:attribute name="alt"><xsl:text>Select to browse </xsl:text><xsl:value-of select="orawsv:resourcePath"/></xsl:attribute>
					</img>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="href"><xsl:value-of select="orawsv:resourcePath"/></xsl:attribute>
					<xsl:call-template name="IconFromFileExtension">
						<xsl:with-param name="FileExtension" select="orawsv:resourcePath"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</a>
		</td>
		<td class="withBorder">
				<xsl:call-template name="printResourceLink">
					<xsl:with-param name="IsContainer" select="orawsv:CONTAINER"/>
					<xsl:with-param name="LinkName" select="orawsv:DISPLAY_NAME"/>
					<xsl:with-param name="EncodedPath" select="orawsv:resourcePath"/>
					<xsl:with-param name="SchemaElement" select="orawsv:SCHEMA_ELEMENT"/>
					<xsl:with-param name="ContentType" select="orawsv:CONTENT_TYPE"/>
				</xsl:call-template>
		</td>
		<td class="withBorder">
			<span>
				<xsl:value-of select="orawsv:OWNER"/>
			</span>
		</td>
		<td class="withBorder">
			<span>
				<xsl:value-of select="orawsv:LAST_MODIFIED"/>
			</span>
		</td>
		<td class="withBorder">
			<span>
				<xsl:value-of select="orawsv:CONTENT_TYPE"/>
			</span>
		</td>
		<td class="withBorder">
			<span>
				<xsl:value-of select="orawsv:CONTENT_SIZE"/>
			</span>
		</td>
		<td class="withBorder">
			<a style="text-decoration: none; border: none;">
				<xsl:attribute name="href"><xsl:text>/XFILES/lite/Folder.html?target=</xsl:text><xsl:call-template name="PrintParentPath"><xsl:with-param name="Path" select="orawsv:resourcePath"/></xsl:call-template></xsl:attribute>
				<img alt="" style="vertical-align: middle; border: 0;" width="16px" height="16px" src="/XFILES/lib/icons/readOnlyFolderClosed.png"/>
				<xsl:call-template name="PrintParentPath">
					<xsl:with-param name="Path" select="orawsv:resourcePath"/>
				</xsl:call-template>
			</a>
		</td>
	</xsl:template>
	<xsl:template match="/">
		<xsl:for-each select="/soap:Envelope/soap:Body/orawsv:queryOut">
			<table class="withBorder defaultFont" summary="">
				<tbody>
					<tr class="tableHeader">
						<xsl:if test="orawsv:ROWSET/orawsv:ROW/orawsv:RANK">
							<th title="Rank" class="alignLeft blueGradient">Rank</th>
						</xsl:if>
						<th title="Properties" class="alignLeft blueGradient"/>
						<th title="Preview" class="alignLeft blueGradient"/>
						<th title="Name" class="alignLeft blueGradient">Name</th>
						<th title="Owner" class="alignLeft blueGradient">Owner</th>
						<th title="Last Modified" class="alignLeft blueGradient">Last Modified</th>
						<th title="Content Size" class="alignLeft blueGradient">Content Type</th>
						<th title="Content Type" class="alignLeft blueGradient">Content Size</th>
						<th title="Location" class="alignLeft blueGradient">Location</th>
					</tr>
					<xsl:for-each select="orawsv:ROWSET/orawsv:ROW">
						<tr>
							<xsl:call-template name="printSearchMatch"/>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
