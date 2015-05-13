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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xdbc="http://xmlns.oracle.com/xdb/xdbconfig.xsd" xmlns:s="http://xmlns.oracle.com/xdb/pm/demo/search" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html"/>
	<xsl:variable name="NodeMapName" select="/s:NodeMap/@nodeMapName"/>
	<xsl:include href="/XFILES/XMLSearch/xsl/common.xsl"/>
	<xsl:template name="SetLabelColor">
		<xsl:choose>
			<xsl:when test="@isSelected='true'">
				<xsl:attribute name="style">color: #0000FF;</xsl:attribute>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="style">color: #000000;</xsl:attribute>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="SetStatus">
		<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
		<xsl:attribute name="onchange"><xsl:value-of select="concat('setFieldValue(',$NodeMapName,',this);return false;')"/></xsl:attribute>
		<xsl:if test="@valueVisible='visible'">
			<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
		</xsl:if>
		<xsl:if test="not(@isSelected='true')">
			<xsl:attribute name="disabled">disabled</xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="GenericTextField">
		<xsl:param name="width"/>
		<xsl:param name="id"/>
		<xsl:param name="labelText"/>
		<xsl:param name="size"/>
		<xsl:param name="maxLength"/>
		<td>
			<xsl:attribute name="style"><xsl:value-of select="concat('width:',$width,'px;')"/></xsl:attribute>
			<span class="labelAndValue" style="width:100%;">
				<span class="labelCol" style="float:left;padding-left:4px;">
					<label>
						<xsl:attribute name="for"><xsl:value-of select="$id"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
						<xsl:call-template name="SetLabelColor"/>
						<xsl:value-of select="$labelText"/>
					</label>
				</span>
				<span class="labelVal" style="float:right;padding-right:4px;">
					<input type="text">
						<xsl:attribute name="size"><xsl:value-of select="$size"/></xsl:attribute>
						<xsl:attribute name="maxLength"><xsl:value-of select="$maxLength"/></xsl:attribute>
						<xsl:call-template name="SetStatus"/>
					</input>
				</span>
			</span>
		</td>
	</xsl:template>
	<xsl:template name="UserSelectionField">
		<xsl:param name="width"/>
		<xsl:param name="id"/>
		<xsl:param name="labelText"/>
		<td>
			<span class="labelAndValue" style="width:100%">
				<span class="labelCol" style="float:left;padding-left:4px;">
					<label>
						<xsl:attribute name="for"><xsl:value-of select="$id"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
						<xsl:call-template name="SetLabelColor"/>
						<xsl:value-of select="$labelText"/>
					</label>
				</span>
				<span class="labelVal" style="float:right;padding-right:4px;">
					<select>
						<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
						<xsl:call-template name="SetStatus"/>
						<xsl:call-template name="UserOptions"/>
					</select>
				</span>
			</span>
		</td>
	</xsl:template>
	<xsl:template name="UserOptions">
		<xsl:variable name="targetValue" select="@value"/>
		<xsl:for-each select="/s:NodeMap/s:Users/s:User">
			<xsl:sort order="ascending" select="."/>
			<option>
				<xsl:if test="$targetValue=.">
					<xsl:attribute name="selected">true</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
				<xsl:value-of select="."/>
			</option>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="MimeTypeOptions">
		<xsl:for-each select="/s:NodeMap/s:MimeTypes/xdbc:mime-type">
			<xsl:sort order="ascending" select="."/>
			<option>
				<xsl:if test="'text/plain'=.">
					<xsl:attribute name="selected">true</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
				<xsl:value-of select="."/>
			</option>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ACLList">
		<xsl:variable name="targetValue" select="@value"/>
		<xsl:for-each select="/s:NodeMap/s:ACLS/s:Path">
			<xsl:sort order="ascending" select="."/>
			<option>
				<xsl:if test="$targetValue=@ACLOID">
					<xsl:attribute name="selected">true</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="value"><xsl:value-of select="@ACLOID"/></xsl:attribute>
				<xsl:value-of select="."/>
			</option>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="ResConfigList">
		<xsl:variable name="targetValue" select="@value"/>
		<xsl:for-each select="/s:NodeMap/s:ResConfigDocuments/s:Path">
			<xsl:sort order="ascending" select="."/>
			<option>
				<xsl:if test="$targetValue=@RCID">
					<xsl:attribute name="selected">true</xsl:attribute>
				</xsl:if>
				<xsl:attribute name="value"><xsl:value-of select="@RCID"/></xsl:attribute>
				<xsl:value-of select="."/>
			</option>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="DisplayName">
		<xsl:call-template name="GenericTextField">
			<xsl:with-param name="width" select="'50%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Display Name'"/>
			<xsl:with-param name="size" select="'32'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="FolderRestriction">
		<td>
			<span class="labelAndValue" style="width:100%;">
				<span class="labelCol" style="float:left;padding-left:4px;">
					<label>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
						<xsl:attribute name="for"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:call-template name="SetLabelColor"/>
						<xsl:text>Folder Constraint</xsl:text>
					</label>
				</span>
				<span class="labelVal" style="float:right;padding-right:4px;">
					<input type="radio" value="REPOSITORY">
						<xsl:if test="not(@isSelected='true')">
							<xsl:attribute name="disabled">disabled</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('setFieldValue(',$NodeMapName,',this);return false')"/></xsl:attribute>
						<xsl:if test="@value='REPOSITORY'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>Repository</input>
					<input type="radio" value="TREE">
						<xsl:if test="not(@isSelected='true')">
							<xsl:attribute name="disabled">disabled</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('setFieldValue(',$NodeMapName,',this);return false')"/></xsl:attribute>
						<xsl:if test="@value='TREE'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>Tree</input>
					<input type="radio" value="FOLDER">
						<xsl:if test="not(@isSelected='true')">
							<xsl:attribute name="disabled">disabled</xsl:attribute>
						</xsl:if>
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('setFieldValue(',$NodeMapName,',this);return false')"/></xsl:attribute>
						<xsl:if test="@value='FOLDER'">
							<xsl:attribute name="checked">true</xsl:attribute>
						</xsl:if>Folder</input>
				</span>
			</span>
		</td>
	</xsl:template>
	<xsl:template name="CreationDate">
		<xsl:call-template name="GenericTextField">
			<xsl:with-param name="width" select="'50%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Date Created'"/>
			<xsl:with-param name="size" select="'32'"/>
			<xsl:with-param name="maxLength" select="'32'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="ModificationDate">
		<xsl:call-template name="GenericTextField">
			<xsl:with-param name="width" select="'50%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Date Modified'"/>
			<xsl:with-param name="size" select="'32'"/>
			<xsl:with-param name="maxLength" select="'32'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Creator">
		<xsl:call-template name="UserSelectionField">
			<xsl:with-param name="width" select="'50%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Created By'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Owner">
		<xsl:call-template name="UserSelectionField">
			<xsl:with-param name="width" select="'50%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Current Owner'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="LastModifier">
		<xsl:call-template name="UserSelectionField">
			<xsl:with-param name="width" select="'50%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Last Modified By'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="CheckedOutBy">
		<xsl:call-template name="UserSelectionField">
			<xsl:with-param name="width" select="'50%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Checked Out By'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Author">
		<xsl:call-template name="GenericTextField">
			<xsl:with-param name="width" select="'50%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Author'"/>
			<xsl:with-param name="size" select="'32'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Comment">
		<xsl:call-template name="GenericTextField">
			<xsl:with-param name="width" select="'50%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Description'"/>
			<xsl:with-param name="size" select="'32'"/>
			<xsl:with-param name="maxLength" select="'256'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Language">
		<td>
			<span class="labelAndValue" style="width:100%;">
				<span class="labelCol" style="float:left;padding-left:4px;">
					<label>
						<xsl:attribute name="for"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
						<xsl:call-template name="SetLabelColor"/>
						<xsl:text>Language</xsl:text>
					</label>
				</span>
				<span class="labelVal" style="float:right;padding-right:4px;">
					<select name="Language">
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:call-template name="SetStatus"/>
						<xsl:call-template name="XFilesLanguageOptions"/>
					</select>
				</span>
			</span>
		</td>
	</xsl:template>
	<xsl:template name="CharacterSet">
		<td>
			<span class="labelAndValue" style="width:100%;">
				<span class="labelCol" style="float:left;padding-left:4px;">
					<label for="@ID">
						<xsl:attribute name="for"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
						<xsl:call-template name="SetLabelColor"/>
						<xsl:text>Character Set</xsl:text>
					</label>
				</span>
				<span class="labelVal" style="float:right;padding-right:4px;">
					<select name="CharacterSet">
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:call-template name="SetStatus"/>
						<xsl:call-template name="XFilesCharacterSetOptions"/>
					</select>
				</span>
			</span>
		</td>
	</xsl:template>
	<xsl:template name="ContentType">
		<td>
			<span class="labelAndValue" style="width:100%;">
				<span class="labelCol" style="float:left;padding-left:4px;">
					<label for="@ID">
						<xsl:attribute name="for"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
						<xsl:call-template name="SetLabelColor"/>
						<xsl:text>Content Type</xsl:text>
					</label>
				</span>
				<span class="labelVal" style="float:right;padding-right:4px;">
					<select name="ContentType">
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:call-template name="SetStatus"/>
						<xsl:call-template name="MimeTypeOptions"/>
					</select>
				</span>
			</span>
		</td>
	</xsl:template>
	<xsl:template name="LockOwner">
		<xsl:call-template name="UserSelectionField">
			<xsl:with-param name="width" select="'35%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Lock Owner'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="LockMode">
		<td width="35%">
			<span class="labelAndValue" style="width:100%;">
				<span class="labelCol" style="float:left;padding-left:4px;">
					<label>
						<xsl:attribute name="for"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
						<xsl:call-template name="SetLabelColor"/>
						<xsl:text>Lock Mode</xsl:text>
					</label>
				</span>
				<span class="labelVal" style="float:right;padding-right:4px;">
					<select name="LockMode">
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:call-template name="SetStatus"/>
						<option selected="selected" value="exclusive">Exclusive</option>
						<option value="shared">Shared</option>
					</select>
				</span>
			</span>
		</td>
	</xsl:template>
	<xsl:template name="LockType">
		<td width="35%">
			<span class="labelAndValue" style="width:100%;">
				<span class="labelCol" style="float:left;padding-left:4px;">
					<label>
						<xsl:attribute name="for"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
						<xsl:call-template name="SetLabelColor"/>
						<xsl:text>Lock Type</xsl:text>
					</label>
				</span>
				<span class="labelVal" style="float:right;padding-right:4px;">
					<select name="LockType">
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:call-template name="SetStatus"/>
						<option selected="selected" value="read">Read</option>
						<option value="read-write">Read-Write</option>
						<option value="write">Write</option>
					</select>
				</span>
			</span>
		</td>
	</xsl:template>
	<xsl:template name="LockDepth">
		<td width="35%">
			<span class="labelAndValue" style="width:100%;">
				<span class="labelCol" style="float:left;padding-left:4px;">
					<label>
						<xsl:attribute name="for"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
						<xsl:call-template name="SetLabelColor"/>
						<xsl:text>Depth</xsl:text>
					</label>
				</span>
				<span class="labelVal" style="float:right;padding-right:4px;">
					<select name="LockDepth">
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:call-template name="SetStatus"/>
						<option value="0">0</option>
						<option selected="selected" value="infinity">Infinity</option>
					</select>
				</span>
			</span>
		</td>
	</xsl:template>
	<xsl:template name="LockExpiry">
		<xsl:call-template name="GenericTextField">
			<xsl:with-param name="width" select="'35%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Expires'"/>
			<xsl:with-param name="size" select="'32'"/>
			<xsl:with-param name="maxLength" select="'256'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="TextSearch">
		<xsl:call-template name="GenericTextField">
			<xsl:with-param name="width" select="'100%'"/>
			<xsl:with-param name="id" select="@ID"/>
			<xsl:with-param name="labelText" select="'Text Search'"/>
			<xsl:with-param name="size" select="'128'"/>
			<xsl:with-param name="maxLength" select="'512'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="ACL">
		<td width="50%">
			<span class="labelAndValue" style="width:100%;">
				<span class="labelCol" style="float:left;padding-left:4px;">
					<label>
						<xsl:attribute name="for"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
						<xsl:call-template name="SetLabelColor"/>
						<xsl:text>ACL</xsl:text>
					</label>
				</span>
				<span class="labelVal" style="float:right;padding-right:4px;">
					<select name="ACL">
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:call-template name="SetStatus"/>
						<xsl:call-template name="ACLList"/>
					</select>
				</span>
			</span>
		</td>
	</xsl:template>
	<xsl:template name="ResConfig">
		<td width="50%">
			<span class="labelAndValue" style="width:100%;">
				<span class="labelCol" style="float:left;padding-left:4px;">
					<label>
						<xsl:attribute name="for"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
						<xsl:call-template name="SetLabelColor"/>
						<xsl:text>Resource Configuration</xsl:text>
					</label>
				</span>
				<span class="labelVal" style="float:right;padding-right:4px;">
					<select name="ResConfig">
						<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:call-template name="SetStatus"/>
						<xsl:call-template name="ResConfigList"/>
					</select>
				</span>
			</span>
		</td>
	</xsl:template>
	<xsl:template name="globalElementList">
		<xsl:param name="parent"/>
		<xsl:param name="schoid"/>
		<xsl:param name="elname"/>
		<xsl:param name="isSelected"/>
		<xsl:variable name="id" select="concat($parent,'.CHILD')"/>
		<xsl:for-each select="/s:NodeMap/s:Schemas/s:Schema[@SCHOID=$schoid]">
			<div>
				<select>
					<xsl:attribute name="name"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="onchange"><xsl:value-of select="concat('setChildValue(',$NodeMapName,',document.getElementById(&quot;',$parent,'&quot;));return false;')"/></xsl:attribute>
					<xsl:if test="not($isSelected='true') or count(s:GlobalElementList/s:GlobalElement) = 1">
						<xsl:attribute name="disabled">disabled</xsl:attribute>
					</xsl:if>
					<xsl:for-each select="s:GlobalElementList/s:GlobalElement">
						<option>
							<xsl:attribute name="id"><xsl:value-of select="concat($schoid,'.',.)"/></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
							<xsl:if test="$elname=.">
								<xsl:attribute name="selected">selected</xsl:attribute>
							</xsl:if>
							<xsl:value-of select="."/>
						</option>
					</xsl:for-each>
				</select>
			</div>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="schemaList">
		<xsl:param name="id"/>
		<xsl:param name="schoid"/>
		<xsl:param name="isSelected"/>
		<xsl:param name="schemaType"/>
		<select>
			<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
			<xsl:attribute name="name"><xsl:value-of select="$id"/></xsl:attribute>
			<xsl:attribute name="onchange"><xsl:value-of select="concat('setParentValue(',$NodeMapName,',this);return false;')"/></xsl:attribute>
			<xsl:if test="not($isSelected='true') or count(/s:NodeMap/s:Schemas/s:Schema[@Type=$schemaType]) = 1">
				<xsl:attribute name="disabled">disabled</xsl:attribute>
			</xsl:if>
			<xsl:for-each select="/s:NodeMap/s:Schemas/s:Schema[@Type=$schemaType]">
				<xsl:sort order="ascending" select="@Location"/>
				<option>
					<xsl:attribute name="id"><xsl:value-of select="@SCHOID"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="@SCHOID"/></xsl:attribute>
					<xsl:if test="$schoid=@SCHOID">
						<xsl:attribute name="selected">selected</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="@Location"/>
				</option>
			</xsl:for-each>
		</select>
		<span style="display:block;width:10px;height:1px;"/>
	</xsl:template>
	<xsl:template name="xmlSchemaBasedContent">
		<!-- 
			Current Element is the NODELIST is named SCHOID. It identifies the CONTENT Schema
			The value is the SCHOID from the list of availalbe XML Schemas
			Find the ID and value of the associated Global Element which is named 'ElNum'.
			The value is the propNum of the selected global element.
		-->
		<!-- Display the available content schemas as a drop down list box. -->
		<td width="75%">
			<xsl:if test="count(/s:NodeMap/s:Schemas/s:Schema[@Type='CONTENTS']) > 0">
				<table width="100%" cellpadding="0" border="0" cellspacing="0">
					<tbody>
						<tr>
							<td nowrap="nowrap" width="100%">
								<span class="labelCol">
									<label>
										<xsl:attribute name="for"><xsl:value-of select="@ID"/></xsl:attribute>
										<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
										<xsl:call-template name="SetLabelColor"/>Schema URL</label>
								</span>
							</td>
							<td align="left">
								<xsl:call-template name="schemaList">
									<xsl:with-param name="id" select="@ID"/>
									<xsl:with-param name="schoid" select="@value"/>
									<xsl:with-param name="isSelected" select="@isSelected"/>
									<xsl:with-param name="schemaType" select="'CONTENTS'"/>
								</xsl:call-template>
							</td>
							<td align="right">
								<xsl:call-template name="globalElementList">
									<xsl:with-param name="parent" select="@ID"/>
									<xsl:with-param name="schoid" select="@value"/>
									<xsl:with-param name="elname" select="@childValue"/>
									<xsl:with-param name="isSelected" select="@isSelected"/>
								</xsl:call-template>
							</td>
						</tr>
					</tbody>
				</table>
			</xsl:if>
		</td>
	</xsl:template>
	<xsl:template name="extendedMetadata">
		<td width="75%">
			<xsl:if test="count(/s:NodeMap/s:Schemas/s:Schema[@Type='RESMETADATA']) > 0">
				<xsl:for-each select="/s:NodeMap/s:ExtraData/s:Element[@ID='MetadataSchema']">
					<table width="100%" cellpadding="0" border="0" cellspacing="0">
						<tbody>
							<tr>
								<td nowrap="nowrap" width="100%">
									<span class="labelCol">
										<label>
											<xsl:attribute name="for"><xsl:value-of select="@ID"/></xsl:attribute>
											<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleFieldStateByLabel(',$NodeMapName,',this);return false;')"/></xsl:attribute>
											<xsl:call-template name="SetLabelColor"/>Metadata Schema URL</label>
									</span>
								</td>
								<td align="left">
									<xsl:call-template name="schemaList">
										<xsl:with-param name="id" select="@ID"/>
										<xsl:with-param name="schoid" select="@value"/>
										<xsl:with-param name="isSelected" select="@isSelected"/>
										<xsl:with-param name="schemaType" select="'RESMETADATA'"/>
									</xsl:call-template>
								</td>
								<td align="right">
									<xsl:call-template name="globalElementList">
										<xsl:with-param name="parent" select="@ID"/>
										<xsl:with-param name="schoid" select="@value"/>
										<xsl:with-param name="elname" select="@childValue"/>
										<xsl:with-param name="isSelected" select="@isSelected"/>
									</xsl:call-template>
								</td>
							</tr>
						</tbody>
					</table>
				</xsl:for-each>
			</xsl:if>
		</td>
	</xsl:template>
	<xsl:template name="emptyProperty">
		<xsl:param name="width"/>
		<td>
			<xsl:attribute name="width"><xsl:value-of select="$width"></xsl:value-of></xsl:attribute>
		</td>
	</xsl:template>
	<xsl:template name="addStandardProperties">
		<table style="width:100%;padding:0px;border0px;margin:0px;">
			<tbody>
				<tr>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='DisplayName']">
						<xsl:call-template name="DisplayName"/>
					</xsl:for-each>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='Author']">
						<xsl:call-template name="Author"/>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:for-each select="/s:NodeMap/s:ExtraData/s:Element[@ID='FolderRestriction']">
						<xsl:call-template name="FolderRestriction"/>
					</xsl:for-each>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='Comment']">
						<xsl:call-template name="Comment"/>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='Creator']">
						<xsl:call-template name="Creator"/>
					</xsl:for-each>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='Language']">
						<xsl:call-template name="Language"/>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='Owner']">
						<xsl:call-template name="Owner"/>
					</xsl:for-each>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='CharacterSet']">
						<xsl:call-template name="CharacterSet"/>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='LastModifier']">
						<xsl:call-template name="LastModifier"/>
					</xsl:for-each>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='ContentType']">
						<xsl:call-template name="ContentType"/>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='CheckedOutBy']">
						<xsl:call-template name="CheckedOutBy"/>
					</xsl:for-each>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='ACLOID']">
						<xsl:call-template name="ACL"/>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='CreationDate']">
						<xsl:call-template name="CreationDate"/>
					</xsl:for-each>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='RCList']/s:Elements/s:Element[substring-after(s:Name,':')='OID']">
						<xsl:call-template name="ResConfig"/>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='ModificationDate']">
						<xsl:call-template name="ModificationDate"/>
					</xsl:for-each>
					<xsl:call-template name="emptyProperty">
						<xsl:with-param name="width" select="'50%'"/>
					</xsl:call-template>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="addExtendedProperties">
		<table width="100%" cellpadding="0" border="0" cellspacing="0">
			<tbody>
				<tr>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='SchOID']">
						<xsl:call-template name="xmlSchemaBasedContent"/>
					</xsl:for-each>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='LockOwner']">
						<xsl:call-template name="LockOwner"/>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:call-template name="emptyProperty">
						<xsl:with-param name="width" select="'65%'"/>
					</xsl:call-template>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='Mode']">
						<xsl:call-template name="LockMode"/>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='SBResExtra']">
						<xsl:call-template name="extendedMetadata"/>
					</xsl:for-each>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='Type']">
						<xsl:call-template name="LockType"/>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:call-template name="emptyProperty">
						<xsl:with-param name="width" select="'65%'"/>
					</xsl:call-template>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='Depth']">
						<xsl:call-template name="LockDepth"/>
					</xsl:for-each>
				</tr>
				<tr>
					<xsl:for-each select="/s:NodeMap/s:ExtraData/s:Element[@ID='FullTextSearch']">
						<xsl:call-template name="TextSearch"/>
					</xsl:for-each>
					<xsl:for-each select="//s:Element[substring-after(s:Name,':')='Expiry']">
						<xsl:call-template name="LockExpiry"/>
					</xsl:for-each>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template match="/">
		<div class="inputFormBorder tableBackground">
			<div style="padding-top:5px;">
				<xsl:call-template name="addStandardProperties"/>
			</div>
			<div style="padding-top:5px;">
				<xsl:call-template name="addExtendedProperties"/>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
