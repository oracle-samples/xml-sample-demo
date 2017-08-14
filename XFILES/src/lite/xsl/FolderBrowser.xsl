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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:rss="http://xmlns.oracle.com/xdb/xfiles/rss">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:include href="/XFILES/lite/xsl/FolderBrowserDialogs.xsl"/>
	<xsl:include href="/XFILES/lite/xsl/FolderFileListing.xsl"/>
	<xsl:template name="actionBar">
		<xsl:if test="xfiles:xfilesParameters/xfiles:user!='ANONYMOUS'">
			<span style="float:right;">
				<img id="btnDoAction" src="/XFILES/lib/icons/doAction.png" alt="doAction" border="0" align="absmiddle" width="16" height="16" onclick="openActionMenu(event,document.getElementById('btnDoAction'));return false;" data-toggle="tooltip" data-placement="top" title="Actions"/>
				<span style="width:10px; display: inline-block;"/>
				<xsl:if test="xfiles:ResourceStatus[xfiles:folderPermissions='link']">
					<xsl:call-template name="newResources"/>
					<span style="width:10px; display: inline-block;"/>
				</xsl:if>
				<xsl:if test="xfiles:ResourceStatus[xfiles:folderPermissions='update']">
					<xsl:choose>
						<xsl:when test="rss:enableRSS">
							<img src="/XFILES/lib/icons/disableFeed.png" alt="Remove RSS Feed" border="0" align="absmiddle" width="16" height="16" data-toggle="tooltip" data-placement="top" title="Disable RSS Feed" onclick="disableRSS(resourceURL);return false;"/>
						</xsl:when>
						<xsl:otherwise>
							<img src="/XFILES/lib/icons/enableFeed.png" alt="Add RSS Feed" border="0" align="absmiddle" width="16" height="16" onclick="enableRSS(resourceURL);return false;" data-toggle="tooltip" data-placement="top" title="Disable RSS Feed"/>
						</xsl:otherwise>
					</xsl:choose>
					<span style="width:10px; height:15px; display: inline-block;"/>
				</xsl:if>
				<xsl:call-template name="resourceActionMenu"/>
			</span>
		</xsl:if>
	</xsl:template>
	<xsl:template name="newResources">
		<img src="/XFILES/lib/icons/newFolder.png" alt="New Folder" border="0" align="absmiddle" width="16" height="16" onclick="openNewFolderDialog(event);return false" data-toggle="tooltip" data-placement="top" title="New Folder"/>
		<span style="width:10px; display: inline-block;"/>
		<img src="/XFILES/lib/icons/uploadFile.png" alt="Upload" border="0" align="absmiddle" width="16" height="16" onclick="openUploadFilesDialog(event);return false;" data-toggle="tooltip" data-placement="top" title="Upload Files"/>
		<span style="width:10px; display: inline-block;"/>
		<img src="/XFILES/lib/icons/newWikiPage.png" alt="New Wiki Page" border="0" align="absmiddle" width="16" height="16" onclick="openNewWikiPageDialog(event);return false" data-toggle="tooltip" data-placement="top" title="Create Wiki Page"/>
		<span style="width:10px; display: inline-block;"/>
		<img src="/XFILES/lib/icons/addIndexPage.png" alt="Create index.html Page" border="0" align="absmiddle" width="16" height="16" onclick="createIndexPage(event);return false" data-toggle="tooltip" data-placement="top" title="Create &quot;index.html&quot; page"/>
		<span style="width:10px; display: inline-block;"/>
	</xsl:template>
	<xsl:template match="/">
		<div id="localScriptList" style="display:none;">
			<span>/XFILES/lite/js/FolderBrowser.js</span>
		</div>
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'Browse Files'"/>
			<xsl:with-param name="fastPath" select="'true'"/>
		</xsl:call-template>
		<div class="XFilesBody">
			<xsl:for-each select="r:Resource">
				<xsl:call-template name="listFolderContents"/>
			</xsl:for-each>
		</div>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesFooter"/>
		<xsl:call-template name="manualLoginDialog"/>
		<xsl:call-template name="newFolderDialog"/>
		<xsl:call-template name="uploadFilesDialog"/>
		<xsl:call-template name="newWikiPageDialog"/>
		<xsl:call-template name="newZipFileDialog"/>
		<xsl:call-template name="setACLDialog"/>
		<xsl:call-template name="setViewerDialog"/>
		<xsl:call-template name="setPrincipleDialog"/>
		<xsl:call-template name="deepOperationDialog"/>
		<xsl:call-template name="publishDialog"/>
		<xsl:call-template name="deleteDialog"/>
		<xsl:call-template name="checkInDialog"/>
		<xsl:call-template name="folderPickerDialog"/>
	</xsl:template>
</xsl:stylesheet>
