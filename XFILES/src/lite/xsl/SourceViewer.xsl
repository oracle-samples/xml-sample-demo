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
	<xsl:template name="viewerActions">
		<div id="editTitleControls" class="blueGradient barWithIcons">
			<span style="float:right;display:none;" id="executeQuery">
				<span style="display:inline-block;width:21px;">
					<a>
						<xsl:attribute name="href"><xsl:value-of select="concat('/XFILES/WebDemo/runtime.html?target=',/r:Resource/xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath,'&amp;stylesheet=/XFILES/WebDemo/xsl/runtime.xsl&amp;includeContent=true')"/></xsl:attribute>
						<img id="btnExecuteQuery" src="/XFILES/lib/icons/executeSQL.png" alt="Execute Query" border="0" width="16" height="16" data-toggle="tooltip" data-placement="top" title="Execute SQL Script."/>
					</a>
				</span>
			</span>
		</div>
	</xsl:template>
	<xsl:template name="ViewSource">
		<xsl:choose>
			<xsl:when test="r:ContentType='application/vnd.oracle-csx'">
				<input type="hidden" name="contentType" id="targetContentType" value="text/XML"/>
				<div id="sourcearea" style="width:100%; height:40em overflow:auto;"/>
			</xsl:when>
			<xsl:when test="r:ContentType='text/xml'">
				<input type="hidden" name="contentType" id="targetContentType" value="text/XML"/>
				<div id="sourcearea" style="width:100%; height:40em overflow:auto;"/>
			</xsl:when>
			<xsl:otherwise>
				<input type="hidden" name="contentType" id="targetContentType" value="text/plain"/>
				<textarea name="sourcearea" id="sourcearea" readonly="true" wrap="off" style="width:100%;height:40em"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="/">
		<div id="localScriptList" style="display:none;">
			<span>/XFILES/lite/js/SourceViewer.js</span>
		</div>
		<div id="localScripts" style="display:none;"/>
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'View Source'"/>
		</xsl:call-template>
		<xsl:call-template name="viewerActions">
		</xsl:call-template>
		<div class="formAreaBackground">
			<div class="xfilesIndent">
				<xsl:for-each select="r:Resource">
					<xsl:call-template name="ViewSource"/>
				</xsl:for-each>
			</div>
		</div>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesFooter"/>
	</xsl:template>
</xsl:stylesheet>
