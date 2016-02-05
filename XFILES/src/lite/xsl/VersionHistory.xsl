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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/xfiles" xmlns:img="http://xmlns.oracle.com/xdb/metadata/ImageMetadata" xmlns:exif="http://xmlns.oracle.com/ord/meta/exif">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:template name="showVersion">
		<tr class="noBorder">
			<td class="withBorder">
				<xsl:value-of select="@VersionID"/>
			</td>
			<td class="withBorder alignRight">
				<xsl:value-of select="r:ContentSize/@derivedValue"/>
			</td>
			<td class="withBorder alignRight">
				<xsl:call-template name="formatDate">
					<xsl:with-param name="date" select="r:ModificationDate"/>
				</xsl:call-template>
			</td>
			<td class="withBorder">
				<xsl:value-of select="r:LastModifier/@derivedValue"/>
			</td>
			<td class="withBorder alignRight">
				<xsl:call-template name="formatDate">
					<xsl:with-param name="date" select="r:CreationDate"/>
				</xsl:call-template>
			</td>
			<td class="withBorder">
				<xsl:value-of select="r:Creator/@derivedValue"/>
			</td>
			<td class="withBorder">
				<xsl:value-of select="r:Owner/@derivedValue"/>
			</td>
			<td class="withBorder alignRight">
				<xsl:value-of select="r:ContentType"/>
			</td>
			<td colspan="2" class="withBorder">
				<xsl:value-of select="r:Comment"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="showVersions">
		<table class="withBorder defaultFont" summary="">
			<tbody>
				<tr class="tableHeader">
					<th title="Index Name" class="alignLeft blueGradient">Version</th>
					<th title="Size" class="alignLeft blueGradient">Size</th>
					<th title="Date Modified" class="alignLeft blueGradient">Modified</th>
					<th title="Modified By" class="alignLeft blueGradient">Modified By</th>
					<th title="Date Created" class="alignLeft blueGradient">Created</th>
					<th title="Created By" class="alignLeft blueGradient">Creator</th>
					<th title="Current Owner" class="alignLeft blueGradient">Owner</th>
					<th title="Content Type" class="alignLeft blueGradient">Content Type</th>
					<th title="Description" class="alignLeft blueGradient">Description</th>
				</tr>
				<xsl:call-template name="showVersion"/>
				<xsl:for-each select="xfiles:VersionHistory/r:Resource">
					<xsl:call-template name="showVersion"/>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="previewVersion">
		<xsl:param name="versionNumber"/>
		<div class="hscrollItem">
			<xsl:attribute name="id"><xsl:value-of select="$versionNumber"></xsl:value-of></xsl:attribute>
			<div>
				<xsl:attribute name="style"><xsl:text>width:150px;</xsl:text></xsl:attribute>
				<xsl:attribute name="class"><xsl:text>inactiveTab</xsl:text></xsl:attribute>
				<xsl:value-of select="concat('Version ',$versionNumber)"/>
				<xsl:choose>
					<xsl:when test="substring-before(r:ContentType,'/')='image'">
					</xsl:when>
					<xsl:otherwise>
						<a>
							<xsl:attribute name="onclick"><xsl:text>renderDocument(event,'</xsl:text><xsl:value-of select="xfiles:ResourceStatus/xfiles:Resid"/><xsl:text>');false;</xsl:text></xsl:attribute>
							<img src="/XFILES/lib/icons/preview.png" alt="Preview" border="0" align="absmiddle" width="16" height="16"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
				<span style="height:20px;width:5px;display:inline-block;"/>
				<span style="height:20px;width:5px;display:inline-block;"/>
				<a>
					<xsl:attribute name="href"><xsl:text>/sys/oid/</xsl:text><xsl:value-of select="xfiles:ResourceStatus/xfiles:Resid"/></xsl:attribute>
					<img src="/XFILES/lib/icons/download.png" alt="Download" border="0" align="absmiddle" width="16" height="16"/>
				</a>
				<span style="height:20px;width:5px;display:inline-block;"/>
			</div>
			<div class="tabBar"/>
			<div style="padding:5px">
				<xsl:choose>
					<xsl:when test="substring-before(r:ContentType,'/')='image'">
						<img alt="Preview" style="width:90%">
							<xsl:attribute name="src"><xsl:value-of select="concat('/sys/oid/',xfiles:ResourceStatus/xfiles:Resid)"/></xsl:attribute>
						</img>
					</xsl:when>
					<xsl:otherwise>
						<pre style="background-color:#FFFFFF;width:99%;height:20em; overflow-x: hidden; white-space: pre-wrap; 
 white-space: -moz-pre-wrap !important;  white-space: -o-pre-wrap; word-wrap: break-word">
							<xsl:attribute name="id"><xsl:value-of select="xfiles:ResourceStatus/xfiles:Resid"></xsl:value-of></xsl:attribute>
						</pre>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="previewVersions">
		<div class="inputFormBorder" style="position:relative;height:415px;width:100%;padding:5px;overlow-y:hidden;overflow-x:auto">
			<div style="position:absolute;width:100%">
				<div onclick="showNext();" class="hscrollNext">
					<img alt="nextStep" height="16" width="16" style="top:192px;">
						<xsl:attribute name="src"><xsl:text>/XFILES/lib/icons/prevEnabled.png</xsl:text></xsl:attribute>
					</img>
				</div>
				<div class="hscrollContainer">
					<xsl:call-template name="previewVersion">
						<xsl:with-param name="versionNumber" select="@VersionID"/>
					</xsl:call-template>
					<xsl:for-each select="xfiles:VersionHistory/r:Resource">
						<xsl:call-template name="previewVersion">
							<xsl:with-param name="versionNumber" select="@VersionID"/>
						</xsl:call-template>
					</xsl:for-each>
				</div>
				<div onclick="showPrev();" class="hscrollPrev">
					<img alt="prevStep" height="16" width="16" style="top:192px;">
						<xsl:attribute name="src"><xsl:text>/XFILES/lib/icons/nextEnabled.png</xsl:text></xsl:attribute>
					</img>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="/">
		<div id="localScriptList" style="display:none;">
			<span>/XFILES/lite/js/VersionHistory.js</span>
		</div>
		<div id="localScripts" style="display:none;"/>
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'Version History for'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'25px'"/>
		</xsl:call-template>
		<xsl:call-template name="documentPreview"/>
		<div class="formAreaBackground">
			<div class="xfilesIndent">
				<div style="height:5px"/>
				<xsl:for-each select="r:Resource">
					<div>
						<xsl:call-template name="showVersions"/>
					</div>
					<div style="height:5px"/>
					<div>
						<xsl:call-template name="previewVersions"/>
					</div>
					<div style="clear:both"/>
				</xsl:for-each>
				<div style="height:5px"/>
			</div>
		</div>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesFooter"/>
	</xsl:template>
</xsl:stylesheet>
