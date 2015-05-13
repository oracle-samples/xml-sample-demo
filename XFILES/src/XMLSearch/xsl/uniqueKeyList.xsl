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

<xsl:stylesheet version="1.0" xmlns:orawsv="http://xmlns.oracle.com/orawsv" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
	<xsl:variable name="NodeMapName" select="/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/@nodeMapName"/>
	<xsl:variable name="ParentPath" select="/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/@ParentPath"/>
	<xsl:variable name="TargetNode" select="/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/@TargetNode"/>
	<xsl:variable name="BaseType" select="/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/@BaseType"/>	
	<xsl:variable name="TableName" select="/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/@TableName"/>
	<xsl:variable name="TableOwner" select="/soap:Envelope/soap:Body/orawsv:queryOut/orawsv:ROWSET/@TableOwner"/>
	<xsl:template match="/">
		<xsl:for-each select="soap:Envelope/soap:Body/orawsv:queryOut">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tbody>
					<tr>
						<td>
							<table width="100%" border="0" cellpadding="0" cellspacing="0">
								<tbody>
									<xsl:for-each select="orawsv:ROWSET/orawsv:ROW/orawsv:uniqueId/*">
										<xsl:sort  order="descending" select="."/>
										<tr>
											<td>
												<a href="#">
													<xsl:attribute name="onclick"><xsl:text>fetchDocument(</xsl:text><xsl:value-of select="$NodeMapName"/><xsl:text>,'UNIQUE','</xsl:text><xsl:value-of select="."/><xsl:text>');return false;</xsl:text></xsl:attribute>
													<xsl:text>fn:doc("oradb:/</xsl:text>
													<xsl:value-of select="$TableOwner"/>
													<xsl:text>/</xsl:text>
													<xsl:value-of select="$TableName"/>
													<xsl:text>")</xsl:text>
													<xsl:value-of select="$ParentPath"/>
													<xsl:text>[</xsl:text>
													<xsl:value-of select="$TargetNode"/>
													<xsl:text>=</xsl:text>
													<xsl:if test="$BaseType">
														<xsl:value-of select="$BaseType"></xsl:value-of>
														<xsl:text>(</xsl:text>
													</xsl:if>
													<xsl:text>"</xsl:text>
													<xsl:value-of select="."/>
													<xsl:text>"</xsl:text>
													<xsl:if test="$BaseType">
														<xsl:text>)</xsl:text>
													</xsl:if>
													<xsl:text>]</xsl:text>
												</a>
											</td>
										</tr>
									</xsl:for-each>
								</tbody>
							</table>
						</td>
						<td valign="top">
							<pre style="padding-left:5pt; padding-bottom:5pt; padding-top:5pt; white-space:pre; color:#000000; background-color:#E0FFFF; width:100%; overflow-X:auto; overflow-Y:auto;" id="documentWindow"/>
						</td>
					</tr>
				</tbody>
			</table>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
