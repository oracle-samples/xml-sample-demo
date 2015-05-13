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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:orawsv="http://xmlns.oracle.com/orawsv" xmlns:oraerr="http://xmlns.oracle.com/orawsv/faults" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xdbpm="http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_SERVICES/EXPLAINPLAN">
	<xsl:output method="html"/>
	<xsl:template name="indent">
		<xsl:param name="size"/>
		<xsl:if test="$size>0">
			<xsl:text>&#160;&#160;</xsl:text>
			<xsl:call-template name="indent">
				<xsl:with-param name="size" select="$size - 1"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="explainPlan">
		<xsl:variable name="showPartitionInfo">
			<xsl:choose>
				<xsl:when test="/soap:Envelope/soap:Body/xdbpm:EXPLAINPLANOutput/xdbpm:RETURN/xdbpm:plan/xdbpm:operation/xdbpm:partition">
					<xsl:value-of select="1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="0"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<pre>
			<table class="withBorder defaultFont">
				<tbody>
					<tr class="tableHeader">
						<th class="alignLeft blueGradient">Id</th>
						<th class="alignLeft blueGradient">Operation</th>
						<th class="alignLeft blueGradient">Name</th>
						<th class="alignLeft blueGradient">Rows</th>
						<th class="alignLeft blueGradient">Bytes</th>
						<xsl:if test="$showPartitionInfo=1">
							<th class="alignLeft blueGradient">Pstart</th>
							<th class="alignLeft blueGradient">Pstop</th>
						</xsl:if>
						<th class="alignLeft blueGradient">Cost (%CPU)</th>
						<th class="alignLeft blueGradient">Time</th>
						<th class="alignLeft blueGradient">Access</th>
						<th class="alignLeft blueGradient">Filter</th>
					</tr>
					<xsl:for-each select="xdbpm:operation">
						<tr valign="top">
							<xsl:attribute name="class"><xsl:choose><xsl:when test="position() mod 2 = 1"><xsl:value-of select="'noBorder oddBackground'"/></xsl:when><xsl:otherwise><xsl:value-of select="'noBorder evenBackground'"/></xsl:otherwise></xsl:choose></xsl:attribute>
							<td class="withBorder">
								<xsl:value-of select="@id"/>
							</td>
							<td class="withBorder">
								<xsl:call-template name="indent">
									<xsl:with-param name="size" select="@depth"/>
								</xsl:call-template>
								<xsl:value-of select="@name"/>
								<xsl:text>&#160;</xsl:text>
								<xsl:value-of select="@options"/>
							</td>
							<td class="withBorder">
								<xsl:value-of select="xdbpm:object"/>
							</td>
							<td class="withBorder" align="right">
								<xsl:value-of select="xdbpm:card"/>
							</td>
							<td class="withBorder" align="right">
								<xsl:value-of select="xdbpm:bytes"/>
							</td>
							<xsl:if test="$showPartitionInfo=1">
								<td class="withBorder" align="right">
									<xsl:value-of select="xdbpm:partition/@start"/>
								</td>
								<td class="withBorder" align="right">
									<xsl:value-of select="xdbpm:partition/@stop"/>
								</td>
							</xsl:if>
							<td class="withBorder" align="right">
								<xsl:value-of select="xdbpm:cost"/>
							</td>
							<td class="withBorder">
								<xsl:value-of select="xdbpm:time"/>
							</td>
							<td class="withBorder">
								<xsl:value-of select="xdbpm:predicates[@type='access']"/>
							</td>
							<td class="withBorder" width="250px">
								<xsl:value-of select="xdbpm:predicates[@type='filter']"/>
							</td>
						</tr>
					</xsl:for-each>
				</tbody>
			</table>
		</pre>
	</xsl:template>
	<xsl:template match="/">
		<xsl:for-each select="/soap:Envelope/soap:Body/xdbpm:EXPLAINPLANOutput/xdbpm:RETURN/xdbpm:plan">
			<xsl:call-template name="explainPlan"/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
