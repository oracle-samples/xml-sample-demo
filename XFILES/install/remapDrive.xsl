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
 * ================================================ */

-->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:output method="html"/>
	<xsl:template match="/">
		<xsl:for-each select="/installationParameters">
			<table style="background-color:#ECE9D8;">
				<tbody>
					<xsl:call-template name="oracleUser"/>
					<xsl:call-template name="hostName"/>
					<xsl:call-template name="options"/>
				</tbody>
			</table>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="oracleUser">
		<xsl:for-each select="oracleUser">
			<tr>
				<td>User</td>
				<td>
					<input name="oracleUsername" id="oracleUsername">
						<xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
					</input>
				</td>
				<td>Password</td>
				<td align="right">
					<input type="password" name="oraclePassword" id="oraclePassword"/>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="hostName">
		<xsl:for-each select="hostName">
			<tr>
				<td>Host name</td>
				<td>
					<input name="hostName" id="hostName">
						<xsl:attribute name="value"><xsl:value-of select="."/></xsl:attribute>
					</input>
				</td>
				<td>HTTP Port </td>
				<td>
					<input name="httpPort" id="httpPort">
						<xsl:attribute name="value"><xsl:value-of select="../httpPort"/></xsl:attribute>
					</input>
				</td>
				<td>Drive Letter</td>
				<td align="right">
					<input name="driveLetter" id="driveLetter" size="2" maxlength="2">
						<xsl:attribute name="value"><xsl:value-of select="../driveLetter"/></xsl:attribute>
					</input>
				</td>
			</tr>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="options">
		<tr align="right">
			<td colspan="5"/>
			<td align="right">
				<input type="button" value="Cancel" onclick="cancelRemapDrive"/>
				<xsl:text>&#160;</xsl:text>
				<input type="button" value="Verfiy" onclick="verifyDrive"/>
				<xsl:text>&#160;</xsl:text>
				<input type="button" value="Map" onclick="remapDrive()"/>
			</td>
		</tr>
	</xsl:template>
</xsl:stylesheet>
