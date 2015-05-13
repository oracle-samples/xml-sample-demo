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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:ns="http://schemas.xmlsoap.org/wsdl/" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
	<xsl:output indent="yes" method="html"/>
	<xsl:template match="/ns:definitions">
		<table>
			<xsl:for-each select="ns:message">
				<tr>
					<td>
						<xsl:call-template name="msg"/>
					</td>
				</tr>
			</xsl:for-each>
		</table>
	</xsl:template>
	<xsl:template name="msg">
		<xsl:if test="contains(@name,'Input')">
			<xsl:variable name="typename" select="ns:part/@element"/>
			<xsl:variable name="namespace" select="/ns:definitions/ns:types/xsd:schema/@targetNamespace"/>
			<xsl:variable name="servicename" select="/ns:definitions/ns:service/@name"/>
			<xsl:variable name="location" select="/ns:definitions/ns:service/ns:port//@location"/>
			<xsl:for-each select="/ns:definitions/ns:types/xsd:schema/xsd:element">
				<xsl:variable name="typename2" select="@name"/>
				<xsl:if test="(contains($typename, $typename2)) or (contains($typename2, $typename))">
					<input type="hidden" id="msgpart" name="msgpart" value="{$typename2}"/>
					<input type="hidden" id="namespace" name="namespace" value="{$namespace}"/>
					<input type="hidden" id="servicename" name="servicename" value="{$servicename}"/>
					<input type="hidden" id="location" name="location" value="{$location}"/> 
					Servicename: <xsl:value-of select="$servicename"/>
					<br/>
					Message   <xsl:value-of select="$typename"/>
					<table border="1">
						<tbody>
							<tr>
								<td>
									<b>Parameter</b>
								</td>
								<td>
									<b>Type</b>
								</td>
								<td>
									<b>Your value</b>
								</td>
							</tr>
							<xsl:for-each select="xsd:complexType/xsd:sequence/xsd:element">
								<xsl:variable name="paramname" select="@name"/>
								<tr>
									<td>
										<xsl:value-of select="substring-before(@name,'-')"/>
									</td>
									<xsl:if test="@type">
										<td>
											<xsl:value-of select="@type"/>
										</td>
										<td>
											<xsl:choose>
												<xsl:when test="@type='xsd:boolean'">
													<input type="checkbox" name="{$paramname}"/>
												</xsl:when>
												<xsl:otherwise>
													<input type="text" name="{$paramname}"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</xsl:if>
									<xsl:if test="not(@type)">
										<td>No scalar type</td>
										<input type="hidden" name="{$paramname}" value=""/>
									</xsl:if>
								</tr>
							</xsl:for-each>
						</tbody>
					</table>
					<p>
						<input type="button" value="Call Web Service" onclick="callWS(document.getElementById('wsInputForm'))"/>
					</p>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
