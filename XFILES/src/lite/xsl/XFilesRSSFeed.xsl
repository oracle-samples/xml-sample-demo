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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:pm="http://xmlns.oracle.com/xdb/pmTeam" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/xfiles">
	<xsl:output version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="yes" media-type="text/xml" method="xml"/>
	<xsl:template name="rss">
		<rss version="2.0">
		    <xfiles:Resid>
				<xsl:value-of select="xfiles:ResourceStatus/xfiles:Resid"></xsl:value-of>
		    </xfiles:Resid>
			<channel>
				<title>
					<xsl:value-of select="r:DisplayName"/>
				</title>
				<description>
					<xsl:value-of select="r:Comments"/>
				</description>
				<xsl:for-each select="xfiles:DirectoryContents/r:Resource">
					<xsl:call-template name="item"/>
				</xsl:for-each>
			</channel>
		</rss>
	</xsl:template>
	<xsl:template name="item">
		<item>
			<title>
				<xsl:value-of select="r:DisplayName"/>
			</title>
			<description>
				<xsl:value-of select="r:Comment"/>
			</description>
			<link>
				<xsl:value-of select="r:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath"/>
			</link>
			<author>
				<xsl:value-of select="r:Author"/>
			</author>
			<pubDate>
				<xsl:value-of select="r:ModificationDate"/>
			</pubDate>
		</item>
	</xsl:template>
	<xsl:template match="/RSS">
		<xsl:for-each select="r:Resource">
			<xsl:call-template name="rss"/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
