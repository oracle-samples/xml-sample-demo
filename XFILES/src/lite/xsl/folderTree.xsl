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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:x="http://xmlns.oracle.com/xdb/pm/demo/search" xmlns:lite="http://xmlns.oracle.com/orawsv/XFILES/XFILES_SOAP_SERVICES/GETTARGETFOLDERTREE">
	<xsl:variable name="controlName" select="/lite:root/@controlName"/>
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template name="expandTreeIcon">
		<span style="">
			<img alt="Expand Item" width="16" height="16" border="0" data-toggle="tooltip" data-placement="top" title="Show Children">
				<xsl:attribute name="onclick"><xsl:text>javascript:</xsl:text><xsl:value-of select="$controlName"></xsl:value-of><xsl:text>.showChildren(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);return false;</xsl:text></xsl:attribute>
				<xsl:attribute name="src"><xsl:value-of select="@showChildren"/></xsl:attribute>
			</img>
		</span>
	</xsl:template>
	<xsl:template name="collapseTreeIcon">
		<span style="">
			<img alt="Unselected Item" width="16" height="16" border="0" data-toggle="tooltip" data-placement="top" title="Hide Children">
				<xsl:attribute name="src"><xsl:value-of select="@hideChildren"/></xsl:attribute>
				<xsl:attribute name="onclick"><xsl:text>javascript:</xsl:text><xsl:value-of select="$controlName"></xsl:value-of><xsl:text>.hideChildren(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);return false;</xsl:text></xsl:attribute>
			</img>
		</span>
	</xsl:template>
	<xsl:template name="selectedFolderIcon">
		<span style="">
			<img alt="Selected Item" src="/XFILES/icons/isSelected.png" width="16" height="16" border="0" data-toggle="tooltip" data-placement="top" title="Selected Folder">
				<xsl:attribute name="onclick"><xsl:text>javascript:</xsl:text><xsl:value-of select="$controlName"></xsl:value-of><xsl:text>.unselectBranch(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);return false;</xsl:text></xsl:attribute>
			</img>
		</span>
	</xsl:template>
	<xsl:template name="unselectedFolderIcon">
		<span style="">
			<img alt="Unselected Item" src="/XFILES/icons/isNotSelected.png" width="16" height="16" border="0" data-toggle="tooltip" data-placement="top" title="Folder">
				<xsl:attribute name="onclick"><xsl:text>javascript:</xsl:text><xsl:value-of select="$controlName"></xsl:value-of><xsl:text>.selectBranch(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);return false;</xsl:text></xsl:attribute>
			</img>
		</span>
	</xsl:template>
	<xsl:template name="openFolderIcon">
		<span style="">
			<img alt="Close Folder" width="16" height="16" border="0" title="Close Folder">
				<xsl:attribute name="src"><xsl:value-of select="@openIcon"/></xsl:attribute>
				<xsl:attribute name="onclick"><xsl:text>javascript:</xsl:text><xsl:value-of select="$controlName"></xsl:value-of><xsl:text>.makeClosed(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);</xsl:text></xsl:attribute>
			</img>
		</span>
	</xsl:template>
	<xsl:template name="closedFolderIcon">
		<span style="">
			<img alt="Open Folder" width="16" height="16" border="0" title="Open Folder">
				<xsl:attribute name="onclick"><xsl:text>javascript:</xsl:text><xsl:value-of select="$controlName"></xsl:value-of><xsl:text>.makeOpen(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);</xsl:text></xsl:attribute>
				<xsl:attribute name="src"><xsl:value-of select="@closedIcon"/></xsl:attribute>
			</img>
		</span>
	</xsl:template>
	<xsl:template match="*">
		<span style="display:block">
			<xsl:attribute name="id"><xsl:value-of select="concat($controlName,'.',@id)"></xsl:value-of></xsl:attribute>
			<xsl:if test="@currentPath">
				<input type="hidden" id="currentPath">
					<xsl:attribute name="value"><xsl:value-of select="@currentPath"></xsl:value-of></xsl:attribute>
				</input>
			</xsl:if>
			<xsl:if test="@children='hidden'">
				<xsl:call-template name="expandTreeIcon"/>
			</xsl:if>
			<xsl:if test="@children='visible'">
				<xsl:call-template name="collapseTreeIcon"/>
			</xsl:if>
			<!--
			<xsl:if test="@children='unknown'">
				<span style="display:inline-block;width:16px;height:16px;"/>
			</xsl:if>
            -->
			<xsl:if test="@isSelected='true'">
				<xsl:call-template name="selectedFolderIcon"/>
			</xsl:if>
			<xsl:if test="@isSelected='false'">
				<xsl:call-template name="unselectedFolderIcon"/>
			</xsl:if>
			<!--
			<xsl:if test="@isSelected='null'">
				<span style="display:inline-block;width:16px;height:16px;"/>
			</xsl:if>
            -->
			<xsl:if test="@isOpen='open'">
				<xsl:call-template name="openFolderIcon"/>
			</xsl:if>
			<xsl:if test="@isOpen='closed'">
				<xsl:call-template name="closedFolderIcon"/>
			</xsl:if>
			<span style="height:16px; padding-left=10px;">
				<xsl:value-of select="@name"/>
			</span>
			<xsl:if test="@children='visible'">
				<span style="display:block;padding-left:16px;">
					<xsl:apply-templates/>
				</span>
			</xsl:if>
		</span>
	</xsl:template>
</xsl:stylesheet>
