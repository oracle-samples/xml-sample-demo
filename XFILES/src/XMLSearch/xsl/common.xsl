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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/XDBResource.xsd">
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:template name="searchActions">
		<div id="searchControls" class="blueGradient barWithIcons">
			<span style="float:right;display:block;" id="xmlIndexOptions">
				<span style="display:inline-block;width:21px;">
					<img id="btnUploadFiles" src="/XFILES/lib/icons/uploadFile.png" alt="Upload Files" border="0" width="16" height="16" data-toggle="tooltip" data-placement="top" title="Upload Content" onclick="openUploadFilesDialog(event);return false;"/>
				</span>
				<span style="display:inline-block;width:21px;">
					<img id="btnRefreshPage" src="/XFILES/lib/icons/reloadTree.png" alt="Refresh Tree" border="0" width="16" height="16" onclick="refreshPage();return false;" data-toggle="tooltip" data-placement="top" title="Reload Tree"/>
				</span>
			</span>
			<span style="float:right;display:block;">
				<span style="display:inline-block;width:21px;">
					<img id="btnShowQuery" src="/XFILES/lib/icons/showQuery.png" alt="Show Query" border="0" width="16" height="16" onclick="openModalDialog('currentSQL');false" data-toggle="tooltip" data-placement="top" title="Show XQuery"/>
				</span>
			</span>
			<span style="float:right;display:block;" id="btnShowNodeMap">
				<span style="display:inline-block;width:21px;">
					<img id="btnShowNodeMap" src="/XFILES/lib/icons/showNodeList.png" alt="Show Node Map" border="0" width="16" height="16" onclick="showSourceCode(documentNodeMap.nodeMap);return false;" data-toggle="tooltip" data-placement="top" title="Show Node Map"/>
				</span>
			</span>
			<span style="float:right;display:none;" id="executeQuery">
				<span style="display:inline-block;width:21px;">
					<img id="btnExecuteQuery" src="/XFILES/lib/icons/executeSQL.png" alt="Execute Query" border="0" width="16" height="16" onclick="executeQuery(documentNodeMap);return false;" data-toggle="tooltip" data-placement="top" title="Execute Query"/>
				</span>
			</span>
		</div>
	</xsl:template>
	<xsl:template name="searchRegions">
		<div style="height:5px;"/>
		<div id="searching" style="display:block;width:100%;text-align:center">
			<div class="inputFormBorder">
				<div>
					<img alt="Searching" src="/XFILES/lib/images/AjaxLoading.gif"/>
				</div>
				<div>
					<xsl:text>Searching</xsl:text>
				</div>
			</div>
		</div>
		<div class="inputFormBorder" id="searchResults" style="display:none;white-space:pre;">
			<pre id="resultWindow"/>
		</div>
		<div style="height:5px;"/>
	</xsl:template>
	<xsl:template name="searchFooter">
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<div>
			<xsl:call-template name="CopyRight"/>
			<div style="width=100%; height=5px;clear:both;"/>
		</div>
	</xsl:template>
</xsl:stylesheet>
