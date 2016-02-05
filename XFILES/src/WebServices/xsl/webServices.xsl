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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/XDBResource.xsd">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:template match="/">
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'Web Services Demonstration'"/>
		</xsl:call-template>
		<div class="blueGradient barWithIcons">
			<div style="float:right;">
				<span style="display:none" id="d_execute">
					<img id="btnExecuteSQL" src="/XFILES/lib/icons/executeSQL.png" alt="Execute SQL" border="0" width="16" height="16" onclick="invokeQuery( document.getElementById('queryArea'))"/>
				</span>
				<span style="display:inline-block;width:5px"/>
			</div>
			<div style="height:0px;clear:both;"/>
		</div>
		<div class="formAreaBackground">
			<div class="xfilesIndent">
				<xsl:for-each select="r:Resource">
					<div style="display:-inline-block;height:14px;"/>
					<div>
						<span class="activeTab" id="tab_query" onclick="showQuery();false;">Query</span>
						<span class="inactiveTab" id="tab_procedure" onclick="showProcedure();false;">Procedure</span>
						<span class="inactiveTab" id="tab_results" onclick="showResults();false;">Results</span>
						<span class="inactiveTab" id="tab_wsdl" onclick="showWSDL();false;">WSDL</span>
						<span class="inactiveTab" id="tab_request" onclick="showRequest();false;">Request</span>
						<span class="inactiveTab" id="tab_response" onclick="showResponse();false;">Response</span>
						<div class="tabBar"/>
						<div style="display:-inline-block;height:14px;"/>
					</div>
					<div class="formAreaBackground" style="min-height:500px; display: block;" id="d_query" width="100%">
						<textarea id="queryArea" rows="20" cols="120"/>
					</div>
					<div style="min-height:500px; display: block;" id="d_procedure" width="100%">
						<div>
							<span>
								<span>Owner</span>
								<span style="display:inline-block;width:5px;"/>
								<span>
									<select id="ownerList" disabled="disabled" onchange="loadObjectLists()">
									</select>
								</span>
							</span>
							<span style="display:inline-block;width:20px;"/>
							<span>
								<span>Function or Procedure</span>
								<span style="display:inline-block;width:5px;"/>
								<span>
									<select id="procedureList" disabled="disabled" onchange="getProcedureWSDL()">
									</select>
								</span>
							</span>
							<span style="display:inline-block;width:20px;"/>
							<span>
								<span>Package</span>
								<span style="display:inline-block;width:5px;"/>
								<span>
									<select id="packageList" disabled="disabled" onchange="loadMethodList() ">
									</select>
								</span>
							</span>
							<span style="display:inline-block;width:20px;"/>
							<span>
								<span>Method</span>
								<span style="display:inline-block;width:5px;"/>
								<span>
									<select id="methodList" disabled="disabled" onchange="getMethodWSDL()">
									</select>
								</span>
							</span>
						</div>
						<div>
							<form name="wsInputForm" id="wsInputForm" action="" method="GET">
								<div id="d_inputForm"/>
							</form>
						</div>
					</div>
					<div class="standardBackground" style="min-height:500px; display: block;" id="d_results" width="100%"/>
					<div class="standardBackground" style="min-height:500px; display: block;" id="d_wsdl" width="100%"/>
					<div class="standardBackground" style="min-height:500px; display: block;" id="d_request" width="100%"/>
					<div class="standardBackground" style="min-height:500px; display: block;" id="d_response" width="100%"/>
					<div style="display:-inline-block;height:14px;"/>
				</xsl:for-each>
			</div>
		</div>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<xsl:call-template name="CopyRight"/>
	</xsl:template>
</xsl:stylesheet>
