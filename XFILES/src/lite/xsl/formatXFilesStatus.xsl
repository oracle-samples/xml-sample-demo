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

<xsl:stylesheet version="1.0" xmlns:orawsv="http://xmlns.oracle.com/orawsv" xmlns:oraerr="http://xmlns.oracle.com/orawsv/faults" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xdbpm="http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_HELPER">
	<xsl:output indent="yes" method="html"/>
	<xsl:variable name="statementId" select="/soap:Envelope/@statementId"/>
	<xsl:template match="/">
		<table class="withBorder defaultFont fullWidth">
			<tbody>
				<xsl:call-template name="generateColumnHeadings"/>
				<xsl:call-template name="generateColumnValues"/>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="generateColumnHeadings">
		<tr class="tableHeader">
				<th class="alignLeft blueGradient">Metric</th>
				<th class="alignLeft blueGradient">Value</th>
		</tr>
	</xsl:template>
	<xsl:template name="generateColumnValues">
		<xsl:for-each select="xfilesStatus/Result">
			<xsl:call-template name="printColumns">
				<xsl:with-param name="rowNumber" select="position()"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="printColumns">
		<xsl:param name="rowNumber"/>
		<tr>
			<xsl:attribute name="class"><xsl:choose><xsl:when test="$rowNumber mod 2 = 1"><xsl:value-of select="'noBorder oddBackground'"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="'noBorder evenBackground'"/></xsl:otherwise></xsl:choose></xsl:attribute>
				<td class="withBorder">
					<xsl:value-of select="@title"/>
				</td>
				<td class="withBorder" style="text-align:right;">
					<xsl:value-of select="."/>
				</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
