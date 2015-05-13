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
	<xsl:template match="/">
		<xsl:for-each select="/soap:Envelope/soap:Body/orawsv:queryOut">
			<xsl:choose>
				<xsl:when test="count(orawsv:ROWSET/orawsv:ROW) > 0">
					<table class="withBorder defaultFont fullWidth">
						<tbody>
							<xsl:call-template name="generateColumnHeadings"/>
							<xsl:call-template name="generateColumnValues"/>
						</tbody>
					</table>
					<BR/>
					<BR/>
					<B>
						<xsl:text>Result : </xsl:text>
						<xsl:value-of select="count(orawsv:ROWSET/orawsv:ROW)"/>
						<xsl:text> </xsl:text>
						<xsl:text>Rows Selected.</xsl:text>
					</B>
				</xsl:when>
				<xsl:otherwise>
					<B>
						<xsl:text>Result : No Rows Selected.</xsl:text>
					</B>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
		<xsl:for-each select="/soap:Envelope/soap:Body/soap:Fault/detail/oraerr:OracleErrors[oraerr:OracleError]">
			<xsl:for-each select="oraerr:OracleError">
				<B>
					<xsl:value-of select="oraerr:ErrorNumber"/>
					<xsl:text>:</xsl:text>
					<xsl:value-of select="oraerr:Message"/>
				</B>
				<xsl:if test="position() != last()">
					<BR/>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="/soap:Envelope/soap:Body/soap:Fault/detail/oraerr:OracleErrors[ not(oraerr:OracleError)]">
			<B>
				<xsl:text>Soap Error : </xsl:text>
				<xsl:value-of select="."/>
			</B>
			<xsl:if test="position() != last()">
				<BR/>
			</xsl:if>
		</xsl:for-each>
		<xsl:for-each select="/soap:Envelope/soap:Body/xdbpm:EXECSQLSTATEMENT_2Output/xdbpm:RETURN">
			<BR/>
			<B>
				<xsl:text>Result : Success</xsl:text>
				<xsl:value-of select="."/>
				<xsl:text> </xsl:text>
				<xsl:text>Rows Updated</xsl:text>
			</B>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="generateColumnHeadings">
		<tr class="tableHeader">
			<xsl:for-each select="orawsv:ROWSET/orawsv:ROW[1]/*">
				<th class="alignLeft blueGradient">
					<xsl:choose>
						<xsl:when test="name()='COUNT_x0028__x002A__x0029_'">
							<xsl:text>COUNT(*)</xsl:text>
						</xsl:when>
						<xsl:when test="name()='SYS_NC_ROWINFO_x0024_'">
							<xsl:text>OBJECT_VALUE</xsl:text>
						</xsl:when>
						<xsl:when test="name()='SYS_NC_OID_x0024_'">
							<xsl:text>OBJECT_ID</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name()"/>
						</xsl:otherwise>
					</xsl:choose>
				</th>
			</xsl:for-each>
		</tr>
	</xsl:template>
	<xsl:template name="generateColumnValues">
		<xsl:for-each select="orawsv:ROWSET/orawsv:ROW">
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
			<xsl:for-each select="*">
				<xsl:variable name="uniqueId">	
					<xsl:choose>
						<xsl:when test="/soap:Envelope/@statementId">
							<xsl:value-of select="/soap:Envelope/@statementId"/><xsl:text>.</xsl:text><xsl:value-of select="$rowNumber"/><xsl:text>.</xsl:text><xsl:value-of select="position()"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$rowNumber"/><xsl:text>.</xsl:text><xsl:value-of select="position()"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<td class="withBorder">
					<xsl:choose>
						<!-- For scalar values each child of ROW will consist of a single text() node -->
						<xsl:when test="count(child::text()) = 1">
							<xsl:choose>
								<!-- For JSON assume text node starts with [ or { -->
								<xsl:when test="starts-with(.,'[')">
									<xsl:attribute name="style">overflow-x:auto; overflow-y:auto;</xsl:attribute>
									<xsl:attribute name="id"><xsl:text>jsonValue.</xsl:text><xsl:value-of select="$uniqueId"/></xsl:attribute>
								</xsl:when>
								<xsl:when test="starts-with(.,'{')">
									<xsl:attribute name="style">overflow-x:auto; overflow-y:auto;</xsl:attribute>
									<xsl:attribute name="id"><xsl:text>jsonValue.</xsl:text><xsl:value-of select="$uniqueId"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:when>
						<!-- For XML values each child of ROW will contain the root element of the document -->
						<xsl:otherwise>
						<!--
							<div style="">
								<xsl:attribute name="id"><xsl:text>xmlValue.</xsl:text><xsl:value-of select="$uniqueId"/></xsl:attribute>
							</div>
                        -->
							<xsl:attribute name="style">overflow-x:auto; overflow-y:auto;</xsl:attribute>
							<xsl:attribute name="id"><xsl:text>xmlValue.</xsl:text><xsl:value-of select="$uniqueId"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</td>
			</xsl:for-each>
		</tr>
	</xsl:template>
</xsl:stylesheet>
