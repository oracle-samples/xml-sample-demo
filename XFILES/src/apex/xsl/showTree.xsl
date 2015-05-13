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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:x="http://xmlns.oracle.com/xdb/pm/demo/search">
	<xsl:template match="/">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="*">
		<div style="margin-left:1em;text-indent:-2em">
			<xsl:if test="@currentPath">
			    <input type="hidden" id="currentPath">
				<xsl:attribute name="value"><xsl:value-of select="@currentPath"></xsl:value-of></xsl:attribute>
			    </input>
			</xsl:if>
			<xsl:if test="@isSelected='true'">
				<img alt="Selected Item" src="/XFILES/icons/isSelected.png" width="16" height="16">
				<xsl:attribute name="onclick"><xsl:text>javascript:unselectBranch(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);</xsl:text></xsl:attribute></img>
			</xsl:if>
			<xsl:if test="@isSelected='false'">
				<img alt="Unselected Item" src="/XFILES/icons/isNotSelected.png" width="16" height="16">
				<xsl:attribute name="onclick"><xsl:text>javascript:selectBranch(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);</xsl:text></xsl:attribute></img>
			</xsl:if>
			<xsl:if test="@isSelected='null'">
				<img alt="" src="/XFILES/lib/graphics/t.gif" width="16" height="16"/>
			</xsl:if>
			<xsl:if test="@children='hidden'">
				<img alt="Expand Item" width="16" height="16">
					<xsl:attribute name="src"><xsl:value-of select="@showChildren"/></xsl:attribute>
					<xsl:attribute name="onclick"><xsl:text>javascript:showChildren(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);</xsl:text></xsl:attribute>
				</img>
			</xsl:if>
			<xsl:if test="@children='visible'">
				<img alt="Unselected Item" width="16" height="16">
					<xsl:attribute name="src"><xsl:value-of select="@hideChildren"/></xsl:attribute>
					<xsl:attribute name="onclick"><xsl:text>javascript:hideChildren(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);</xsl:text></xsl:attribute>
				</img>
			</xsl:if>
			<xsl:if test="@children='unknown'">
				<img alt="" src="/XFILES/lib/graphics/t.gif" width="16" height="16"/>
			</xsl:if>
			<xsl:if test="@isOpen='open'">
				<img>
					<xsl:attribute name="src"><xsl:value-of select="@openIcon"/></xsl:attribute>
					<xsl:attribute name="onclick"><xsl:text>javascript:makeClosed(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);</xsl:text></xsl:attribute>
				</img>
			</xsl:if>
			<xsl:if test="@isOpen='closed'">
				<img>
					<xsl:attribute name="src"><xsl:value-of select="@closedIcon"/></xsl:attribute>
					<xsl:attribute name="onclick"><xsl:text>javascript:makeOpen(</xsl:text><xsl:value-of select="@id"></xsl:value-of><xsl:text>);</xsl:text></xsl:attribute>
				</img>
			</xsl:if>
			<img alt="" src="/XFILES/lib/graphics/t.gif" width="4" height="16"/>
			<xsl:value-of select="@name"/>
			<xsl:if test="@children='visible'">
				<xsl:apply-templates/>
			</xsl:if>
		</div>
	</xsl:template>
</xsl:stylesheet>
