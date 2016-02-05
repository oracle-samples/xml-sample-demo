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
	<xsl:template name="newIndexedTable">
		<div style="display: none;" id="newTableDialog" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div class="popupOuterEdge" style="top: -7px; right: 15px;">
					<div class="popupBackground" style="width:340px;">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>Create XML Table and Index</xsl:text>
							</div>
							<div style="height:5px"/>
							<div style="display:table-row">
								<input id="Owner" name="owner" type="hidden">
									<xsl:attribute name="value"><xsl:value-of select="/*/xfiles:xfilesParameters/xfiles:user"/></xsl:attribute>
								</input>
								<span style="display:table-cell;text-align:right;padding-right:5px;">
									<label for="TableName">Table Name</label>
								</span>
								<span style="display:table-cell;width:50%;">
									<input id="TableName" name="tableName" size="32" type="text" maxlength="32" onblur="setDefaultValues(document.getElementById('Owner'),document.getElementById('TableName'),document.getElementById('IndexName'),document.getElementById('UploadFolder'))"/>
								</span>
							</div>
							<div style="height:5px;"/>
							<div style="display:table-row">
								<span style="display:table-cell;text-align:right;padding-right:5px;">
									<label for="IndexName">Index Name</label>
								</span>
								<span style="display:table-cell;width:50%;">
									<input id="IndexName" name="indexName" size="32" type="text" maxlength="32" onblur="setDefaultValues(document.getElementById('Owner'),document.getElementById('TableName'),document.getElementById('IndexName'),document.getElementById('UploadFolder'))"/>
								</span>
							</div>
							<div style="height:5px;"/>
							<div style="display:table-row">
								<span style="display:table-cell;text-align:right;padding-right:5px;">
									<label for="UploadFolder">Upload Folder</label>
								</span>
								<span style="display:table-cell;width:50%;">
									<input id="UploadFolder" name="uploadFolderPath" size="32" type="text" maxlength="700" onblur="setDefaultValues(document.getElementById('Owner'),document.getElementById('TableName'),document.getElementById('IndexName'),document.getElementById('UploadFolder'))"/>
								</span>
							</div>
							<div style="height:5px;"/>
							<div style="text-align:right;">
								<img id="btnCancelNewTable" src="/XFILES/lib/icons/cancel.png" alt="Cancel Operation" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnDoNewTable" src="/XFILES/lib/icons/saveChangesAndClose.png" alt="Create XML Table" border="0" width="16" height="16" onclick="createXMLIndexedTable(document.getElementById('TableName').value,document.getElementById('IndexName').value,document.getElementById('UploadFolder').value);"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="printLocalIndexes">
		<div class="formText14">
			<xsl:text>User XML Indexes</xsl:text>
			<span style="width:10px; display:inline-block;"/>
		</div>
		<table class="withBorder defaultFont" summary="">
			<tbody>
				<tr class="tableHeader">
					<th title="Table Name" class="alignLeft blueGradient">Table</th>
					<th title="Index Name" class="alignLeft blueGradient">IndexName</th>
					<th title="Path Table Name" class="alignLeft blueGradient">Path Table Name</th>
					<th title="Upload Folder" class="alignLeft blueGradient">Upload Folder</th>
				</tr>
				<xsl:for-each select="localIndexes/index">
					<tr class="noBorder">
						<td class="withBorder">
							<a class="undecoratedLink">
								<xsl:attribute name="href"><xsl:value-of select="concat('/XFILES/XMLSearch/xmlIndex.html?table=',tableName,'&amp;owner=',owner,'&amp;pathTable=',pathTableName,'&amp;indexName=',indexName,'&amp;uploadFolder=',uploadFolder,'&amp;targetColumn=object_value&amp;stylesheet=/XFILES/XMLSearch/xsl/xmlIndex.xsl')"/></xsl:attribute>
								<xsl:attribute name="title"><xsl:text>Cliick to explore table </xsl:text><xsl:value-of select="tableName"/></xsl:attribute>
								<span style="display:inline-block;width:5px"/>
								<img src="/XFILES/lib/icons/search.png" alt="Search" border="0" align="absmiddle" width="16" height="16"/>
								<xsl:value-of select="tableName"/>
							</a>
						</td>
						<td class="withBorder">
							<xsl:value-of select="indexName"/>
						</td>
						<td class="withBorder">
							<xsl:value-of select="pathTableName"/>
						</td>
						<td class="withBorder">
							<xsl:if test="uploadFolder/text()">
								<a class="undecoratedLink">
									<xsl:attribute name="href"><xsl:text>/XFILES/lite/Folder.html?target=</xsl:text><xsl:value-of select="uploadFolder"/><xsl:text disable-output-escaping="yes">&amp;stylesheet=/XFILES//lite/xsl/FolderBrowser.xsl</xsl:text></xsl:attribute>
									<img src="/XFILES/lib/icons/newFolder.png" alt="Upload Content" border="0" align="absmiddle" width="16" height="16"/>
									<span style="display:inline-block;width:5px"/>
									<xsl:value-of select="uploadFolder"/>
								</a>
							</xsl:if>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
		<div style="height:14px;"/>
	</xsl:template>
	<xsl:template name="printGlobalIndexes">
		<xsl:for-each select="globalIndexes[index]">
			<div class="formText14">
				<xsl:text>All XML Indexes</xsl:text>
			</div>
			<table class="withBorder defaultFont" summary="">
				<tbody>
					<tr class="tableHeader">
						<th title="Table Name" class="alignLeft blueGradient">Table</th>
						<th title="Table Owner" class="alignLeft blueGradient">Owner</th>
						<th title="Index Name" class="alignLeft blueGradient">IndexName</th>
						<th title="Path Table Name" class="alignLeft blueGradient">Path Table Name</th>
						<th title="Upload Folder" class="alignLeft blueGradient">Upload Folder</th>
					</tr>
					<xsl:for-each select="index">
						<tr class="noBorder">
							<td class="withBorder">
								<a class="undecoratedLink">
									<xsl:attribute name="href"><xsl:value-of select="concat('/XFILES/XMLSearch/xmlIndex.html?table=',tableName,'&amp;owner=',owner,'&amp;pathTable=',pathTableName,'&amp;indexName=',indexName,'&amp;uploadFolder=',uploadFolder,'&amp;targetColumn=object_value&amp;stylesheet=/XFILES/XMLSearch/xsl/xmlIndex.xsl')"/></xsl:attribute>
									<xsl:attribute name="title"><xsl:text>Cliick to explore table </xsl:text><xsl:value-of select="tableName"/></xsl:attribute>
									<img src="/XFILES/lib/icons/search.png" alt="Search" border="0" align="absmiddle" width="16" height="16"/>
									<span style="display:inline-block;width:5px"/>
									<xsl:value-of select="tableName"/>
								</a>
							</td>
							<td class="withBorder">
								<xsl:value-of select="owner"/>
							</td>
							<td class="withBorder">
								<xsl:value-of select="indexName"/>
							</td>
							<td class="withBorder">
								<xsl:value-of select="pathTableName"/>
							</td>
							<td class="withBorder">
								<xsl:if test="uploadFolder/text()">
									<a class="undecoratedLink">
										<xsl:attribute name="href"><xsl:text>/XFILES/lite/Folder.html?target=</xsl:text><xsl:value-of select="uploadFolder"/><xsl:text disable-output-escaping="yes">&amp;stylesheet=/XFILES//lite/xsl/FolderBrowser.xsl</xsl:text></xsl:attribute>
										<img src="/XFILES/lib/icons/newFolder.png" alt="Upload Content" border="0" align="absmiddle" width="16" height="16"/>
										<span style="display:inline-block;width:5px"/>
										<xsl:value-of select="uploadFolder"/>
									</a>
								</xsl:if>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
			<div style="height:14px;"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="/">
		<div id="localScriptList" style="display:none;">
			<span>/XFILES/lite/js/XMLIndexList.js</span>
		</div>
		<div id="localScripts" style="display:none;"/>
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'Local and Global XML Indexes'"/>
		</xsl:call-template>
		<div class="blueGradient barWithIcons">
			<div style="float:right;">
				<span style="display:inline-block;width:5px"/>
				<img id="btnDoNewTable" src="/XFILES/lib/icons/addTable.png" alt="New Table Dialog" border="0" width="16" height="16" onclick="openPopupDialog(event, document.getElementById('newTableDialog'));return false" data-toggle="tooltip" data-placement="top" title="Create Indexed Table"/>
				<span style="display:inline-block;width:5px"/>
			</div>
			<div style="height:0px;clear:both;"/>
		</div>
		<xsl:call-template name="newIndexedTable"/>
		<div class="formAreaBackground">
			<div class="xfilesIndent">
				<xsl:for-each select="r:Resource/r:Contents/indexList">
					<xsl:call-template name="printLocalIndexes"/>
					<xsl:call-template name="printGlobalIndexes"/>
				</xsl:for-each>
			</div>
		</div>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesFooter"/>
	</xsl:template>
</xsl:stylesheet>
