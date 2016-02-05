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
	<xsl:variable name="reverseSort">
		<xsl:choose>
			<xsl:when test="/r:Resource/xfiles:xfilesParameters/xfiles:sortOrder='descending'">
				<xsl:value-of select="'ascending'"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="'descending'"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<xsl:template name="addColumnHeader">
		<xsl:param name="columnName"/>
		<xsl:param name="sortOrder"/>
		<xsl:call-template name="addTitleAndOnClick">
			<xsl:with-param name="columnName" select="$columnName"/>
			<xsl:with-param name="sortOrder" select="$sortOrder"/>
		</xsl:call-template>
		<!--  Print Column Headng based on Sort Key  -->
		<xsl:choose>
			<xsl:when test="$columnName='xfiles:LinkName'">
				<xsl:text>Name </xsl:text>
			</xsl:when>
			<xsl:when test="$columnName='r:ModificationDate'">
				<xsl:text>Last Modified </xsl:text>
			</xsl:when>
			<xsl:when test="$columnName='r:ContentSize'">
				<xsl:text>Size </xsl:text>
			</xsl:when>
			<xsl:when test="$columnName='r:Owner'">
				<xsl:text>Owner </xsl:text>
			</xsl:when>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="addTitleAndOnClick">
		<xsl:param name="columnName"/>
		<xsl:param name="sortOrder"/>
		<!-- Generate TITTLE attribute based on Sort Key -->
		<xsl:attribute name="title"><xsl:choose><xsl:when test="$columnName='xfiles:LinkName'"><xsl:text>Sort by Name</xsl:text></xsl:when><xsl:when test="$columnName='r:ModificationDate'"><xsl:text>Sort by Last Modified</xsl:text></xsl:when><xsl:when test="$columnName='r:ContentSize'"><xsl:text>Sort by Size</xsl:text></xsl:when><xsl:when test="$columnName='r:Owner'"><xsl:text>Sort by Owner</xsl:text></xsl:when></xsl:choose><xsl:text> (</xsl:text><xsl:value-of select="$sortOrder"/><xsl:text>)</xsl:text></xsl:attribute>
		<!-- Generated OnClick Attriubte based on Sort Key -->
		<xsl:attribute name="onclick"><xsl:text>javascript:doLocalSort('</xsl:text><xsl:value-of select="$columnName"/><xsl:text>','</xsl:text><xsl:value-of select="$sortOrder"/><xsl:text>');</xsl:text></xsl:attribute>
	</xsl:template>
	<xsl:template name="printColumnHeading">
		<xsl:param name="columnName"/>
		<xsl:param name="columnWidth"/>
		<xsl:param name="sortKey"/>
		<xsl:param name="sortOrder"/>
		<xsl:param name="class"/>
		<!-- Genarate Column Header with Direction Indicator Icon  -->
		<th>
			<xsl:attribute name="class"><xsl:value-of select="$class"/></xsl:attribute>
			<xsl:attribute name="width"><xsl:value-of select="$columnWidth"/></xsl:attribute>
			<xsl:choose>
				<xsl:when test="($columnName=$sortKey)">
					<xsl:call-template name="addColumnHeader">
						<xsl:with-param name="columnName" select="$columnName"/>
						<xsl:with-param name="sortOrder" select="$reverseSort"/>
					</xsl:call-template>
					<a>
						<xsl:call-template name="addTitleAndOnClick">
							<xsl:with-param name="columnName" select="$columnName"/>
							<xsl:with-param name="sortOrder" select="$reverseSort"/>
						</xsl:call-template>
						<!-- style="border:2px outset #f7f7e7" -->
						<xsl:choose>
							<xsl:when test="$sortOrder='ascending'">
								<img alt="Sort Ascending" align="top" src="/XFILES/lib/icons/asort.png" width="12px" depth="12px" border="0" style="vertical-align:top"/>
							</xsl:when>
							<xsl:otherwise>
								<img alt="Sort Descending" align="top" src="/XFILES/lib/icons/dsort.png" width="12px" depth="12px" border="0" style="vertical-align:top"/>
							</xsl:otherwise>
						</xsl:choose>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="addColumnHeader">
						<xsl:with-param name="columnName" select="$columnName"/>
						<xsl:with-param name="sortOrder" select="$sortOrder"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</th>
	</xsl:template>
	<xsl:template name="printColumnHeadings">
		<th title="Toggle Select All" class="alignCenter blueGradient" style="width:29px;">
			<input id="selectAll" title="Select Item" type="checkbox" value="0" onclick="toggleSelect(this.checked)"/>
		</th>
		<th title="File Properties" class="alignCenter blueGradient" style="width:29px;">
		</th>
		<th title="File Type" class="alignCenter blueGradient" style="width:29px;">
		</th>
		<xsl:call-template name="printColumnHeading">
			<xsl:with-param name="columnName" select="'xfiles:LinkName'"/>
			<xsl:with-param name="columnWidth" select="'285'"/>
			<xsl:with-param name="sortOrder" select="xfiles:xfilesParameters/xfiles:sortOrder"/>
			<xsl:with-param name="sortKey" select="xfiles:xfilesParameters/xfiles:sortKey"/>
			<xsl:with-param name="class" select="'alignLeft blueGradient'"/>
		</xsl:call-template>
		<th title="Status" class="alignLeft blueGradient" scope="col" width="80">
			<span title="Status">Status</span>
		</th>
		<xsl:call-template name="printColumnHeading">
			<xsl:with-param name="columnName" select="'r:ContentSize'"/>
			<xsl:with-param name="columnWidth" select="'85'"/>
			<xsl:with-param name="sortOrder" select="xfiles:xfilesParameters/xfiles:sortOrder"/>
			<xsl:with-param name="sortKey" select="xfiles:xfilesParameters/xfiles:sortKey"/>
			<xsl:with-param name="class" select="'alignRight blueGradient'"/>
		</xsl:call-template>
		<xsl:call-template name="printColumnHeading">
			<xsl:with-param name="columnName" select="'r:Owner'"/>
			<xsl:with-param name="columnWidth" select="'85'"/>
			<xsl:with-param name="sortOrder" select="xfiles:xfilesParameters/xfiles:sortOrder"/>
			<xsl:with-param name="sortKey" select="xfiles:xfilesParameters/xfiles:sortKey"/>
			<xsl:with-param name="class" select="'alignLeft blueGradient'"/>
		</xsl:call-template>
		<xsl:call-template name="printColumnHeading">
			<xsl:with-param name="columnName" select="'r:ModificationDate'"/>
			<xsl:with-param name="columnWidth" select="'125'"/>
			<xsl:with-param name="sortOrder" select="xfiles:xfilesParameters/xfiles:sortOrder"/>
			<xsl:with-param name="sortKey" select="xfiles:xfilesParameters/xfiles:sortKey"/>
			<xsl:with-param name="class" select="'alignLeft blueGradient'"/>
		</xsl:call-template>
		<th title="Description" class="alignLeft blueGradient">
			<xsl:text>Description</xsl:text>
		</th>
		<th class="alignRight blueGradient">
			<xsl:call-template name="actionBar"/>
		</th>
	</xsl:template>
	<xsl:template name="printChildren">
		<xsl:param name="sortKey"/>
		<xsl:param name="sortOrder"/>
		<xsl:choose>
			<xsl:when test="xfiles:DirectoryContents[r:Resource]">
				<xsl:choose>
					<xsl:when test="($sortKey='xfiles:LinkName')">
						<xsl:call-template name="sortByLinkName">
							<xsl:with-param name="sortOrder" select="$sortOrder"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="($sortKey='r:ModificationDate')">
						<xsl:call-template name="sortByModificationDate">
							<xsl:with-param name="sortOrder" select="$sortOrder"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="($sortKey='r:ContentSize')">
						<xsl:call-template name="sortByContentSize">
							<xsl:with-param name="sortOrder" select="$sortOrder"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:when test="($sortKey='r:Owner')">
						<xsl:call-template name="sortByOwner">
							<xsl:with-param name="sortOrder" select="$sortOrder"/>
						</xsl:call-template>
					</xsl:when>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td colspan="10" width="100%">
						<div style="width:100%;text-align:center">
							<div class="inputFormBorder">
								<xsl:text>Empty Directory</xsl:text>
							</div>
						</div>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="sortByLinkName">
		<xsl:param name="sortOrder"/>
		<xsl:for-each select="xfiles:DirectoryContents/r:Resource">
			<xsl:sort order="descending" select="@Container"/>
			<xsl:sort order="{$sortOrder}" select="xfiles:ResourceStatus/xfiles:LinkName"/>
			<xsl:call-template name="printChild"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="sortByModificationDate">
		<xsl:param name="sortOrder"/>
		<xsl:for-each select="xfiles:DirectoryContents/r:Resource">
			<xsl:sort order="descending" select="@Container"/>
			<xsl:sort order="{$sortOrder}" select="r:ModificationDate"/>
			<xsl:call-template name="printChild"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="sortByContentSize">
		<xsl:param name="sortOrder"/>
		<xsl:for-each select="xfiles:DirectoryContents/r:Resource">
			<xsl:sort order="descending" select="@Container"/>
			<xsl:sort order="{$sortOrder}" select="r:ContentSize/@derivedValue" data-type="number"/>
			<xsl:call-template name="printChild"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="sortByOwner">
		<xsl:param name="sortOrder"/>
		<xsl:for-each select="xfiles:DirectoryContents/r:Resource">
			<xsl:sort order="descending" select="@Container"/>
			<xsl:sort order="{$sortOrder}" select="r:Owner/@derivedValue"/>
			<xsl:call-template name="printChild"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="printIcon">
		<a>
			<xsl:choose>
				<xsl:when test="@Container='true'">
					<!--					<xsl:attribute name="href"><xsl:text>/XFILES/lite/Folder.html?target=</xsl:text><xsl:value-of select="xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath"/></xsl:attribute> -->
					<xsl:attribute name="href"><xsl:text>#</xsl:text></xsl:attribute>
					<xsl:attribute name="onclick">
					<xsl:choose>
						<xsl:when test="xfiles:ResourceStatus/xfiles:CustomViewer/@method">
							<xsl:value-of select="concat(xfiles:ResourceStatus/xfiles:CustomViewer/@method,'(&quot;',xfiles:ResourceStatus/xfiles:CurrentPath,'&quot;,&quot;',xfiles:ResourceStatus/xfiles:CustomViewer,'&quot;);return false;')"/>
						</xsl:when>
						<xsl:when test="xfiles:ResourceStatus/xfiles:CustomViewer">
							<xsl:value-of select="concat('doFolderJump(&quot;',xfiles:ResourceStatus/xfiles:CurrentPath,'&quot;,&quot;',xfiles:ResourceStatus/xfiles:CustomViewer,'&quot;);return false;')"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat('doFolderJump(&quot;',xfiles:ResourceStatus/xfiles:CurrentPath,'&quot;);return false;')"/>
						</xsl:otherwise>
					</xsl:choose>
					</xsl:attribute>
					<img border="0" align="absmiddle" width="16px" depth="16px" src="/XFILES/lib/icons/readOnlyFolderClosed.png">
						<xsl:attribute name="alt"><xsl:text>Select to browse the </xsl:text><xsl:value-of select="xfiles:ResourceStatus/xfiles:LinkName"/><xsl:text>&#160;Folder</xsl:text></xsl:attribute>
					</img>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="target"><xsl:value-of select="'XFilesViewContent'"/></xsl:attribute>
					<xsl:attribute name="href"><xsl:value-of select="xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath"/></xsl:attribute>
					<xsl:call-template name="IconFromFileExtension">
						<xsl:with-param name="FileExtension" select="xfiles:ResourceStatus/xfiles:LinkName"/>
					</xsl:call-template>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>
	<xsl:template name="printName">
		<xsl:call-template name="printResourceLink">
			<xsl:with-param name="IsContainer" select="@Container"/>
			<xsl:with-param name="LinkName" select="xfiles:ResourceStatus/xfiles:LinkName"/>
			<xsl:with-param name="EncodedPath" select="xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath"/>
			<xsl:with-param name="stylesheetURL" select="xfiles:ResourceStatus/xfiles:CustomViewer/text()"/>
			<xsl:with-param name="SchemaElement" select="r:SchemaElement/@derivedValue"/>
			<xsl:with-param name="ContentType" select="r:ContentType"/>
			<xsl:with-param name="fastPath" select="'true'"/>
			<xsl:with-param name="method" select="xfiles:ResourceStatus/xfiles:CustomViewer/@method"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="printChild">
		<tr class="noBorder">
			<td class="withBorder"  style="width:24px;">
				<input type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="xfiles:ResourceStatus/xfiles:CurrentPath"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('currentPath.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="xfiles:ResourceStatus/xfiles:LinkName"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('DisplayName.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="xfiles:ResourceStatus/xfiles:Resid"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('RESID.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="@Container"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('isContainer.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:choose><xsl:when test="count(r:VCRUID) = 0"><xsl:text>false</xsl:text></xsl:when><xsl:otherwise><xsl:text>true</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('isVersioned.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="@IsCheckedOut"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('isCheckedOut.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:choose><xsl:when test="string-length(r:LockBuf)>64"><xsl:text>true</xsl:text></xsl:when><xsl:otherwise><xsl:text>false</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('isLocked.',position())"/></xsl:attribute>
				</input>
				<input title="Select Item" type="checkbox" value="0">
					<xsl:attribute name="id"><xsl:value-of select="concat('itemSelected.',position())"/></xsl:attribute>
				</input>
				<label class="tableCell">
					<xsl:attribute name="for"><xsl:value-of select="concat('itemSelected.',position())"/></xsl:attribute>
				</label>
			</td>
			<td class="withBorder"  style="width:24px;">
				<table align="left">
					<tr>
						<td>
							<a>
								<xsl:attribute name="href"><xsl:text>/XFILES/lite/Resource.html?target=</xsl:text><xsl:value-of select="xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath"/></xsl:attribute>
								<img width="16px" depth="16px" src="/XFILES/lib/icons/pageProperties.png" alt="Select to access File Properties" border="0" aalign="absmiddle"/>
							</a>
						</td>
					</tr>
				</table>
			</td>
			<td class="withBorder" style="width:24px;">
				<xsl:call-template name="printIcon"/>
			</td>
			<td class="withBorder" style="width:280px;">
				<xsl:call-template name="printName"/>
			</td>
			<td class="withBorder" style="width:75px;">
				<table>
					<tr>
						<td>
							<xsl:if test="count(r:VCRUID) > 0">
								<a>
									<xsl:attribute name="href"><xsl:text>/XFILES/lite/Version.html?target=</xsl:text><xsl:value-of select="xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath"/></xsl:attribute>
									<img width="16px" depth="16px" alt="Select to access Version History" border="0" align="absmiddle">
										<xsl:attribute name="src"><xsl:choose><xsl:when test="@IsCheckedOut='true'"><xsl:text>/XFILES/lib/icons/checkedOutDocument.png</xsl:text></xsl:when><xsl:otherwise><xsl:text>/XFILES/lib/icons/versionedDocument.png</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
									</img>
								</a>
							</xsl:if>
							<xsl:if test="string-length(r:LockBuf)>64">
								<img width="16px" depth="16px" alt="Is Locked" border="0" align="absmiddle">
									<xsl:attribute name="src"><xsl:text>/XFILES/lib/icons/lockedDocument.png</xsl:text></xsl:attribute>
								</img>
							</xsl:if>
						</td>
					</tr>
				</table>
			</td>
			<td class="withBorder alignRight" style="width:80px;">
				<xsl:value-of select="r:ContentSize/@derivedValue"/>
			</td>
			<td class="withBorder" style="width:80px;">
				<xsl:value-of select="r:Owner/@derivedValue"/>
			</td>
			<td class="withBorder alignRight" style="width:120px;">
				<xsl:call-template name="formatDate">
					<xsl:with-param name="date" select="r:ModificationDate"/>
				</xsl:call-template>
			</td>
			<td colspan="2" class="withBorder">
				<xsl:value-of select="r:Comment"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="listFolderContents">
		<div class="formAreaBackground" id="folderListing">
			<table class="withBorder defaultFont" summary="" style="width:100%">
				<tbody>
					<tr class="tableHeader withBorder">
						<xsl:call-template name="printColumnHeadings"/>
					</tr>
				</tbody>
			</table>
			<table class="withBorder defaultFont" summary="" style="width:100%">
				<tbody>
					<xsl:call-template name="printChildren">
						<xsl:with-param name="sortKey" select="xfiles:xfilesParameters/xfiles:sortKey"/>
						<xsl:with-param name="sortOrder" select="xfiles:xfilesParameters/xfiles:sortOrder"/>
					</xsl:call-template>
				</tbody>
			</table>
		</div>
	</xsl:template>
</xsl:stylesheet>
