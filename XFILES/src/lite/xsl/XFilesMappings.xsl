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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
	<xsl:variable name="mappings" select="document(Mappings.xml)"/>
	<xsl:template name="targetFromFileExtension">
		<xsl:param name="string"/>
		<xsl:param name="path"/>
		<xsl:param name="delimiter"/>
		<xsl:choose>
			<xsl:when test="$mapping/mapping/xmlSchema[schema=$xmlSchema]">
				<xsl:call-template name="generateLink">
					<xsl:with-param name="path" select="$path"/>
					<xsl:with-param name="stylesheet" select="$mapping/mapping/xmlSchema[schema=$xmlSchema]/stylesheet"/>
					<xsl:with-param name="includeContent" select="$mapping/mapping/xmlSchema[schema=$xmlSchema]/includeContent"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($string, $delimiter)">
				<xsl:call-template name="targetFromFileExtension">
					<xsl:with-param name="string" select="substring-after($string, $delimiter)"/>
					<xsl:with-param name="string" select="$path"/>
					<xsl:with-param name="delimiter" select="$delimiter"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$mappings/mapping/fileExtension[extension=$string]">
				<xsl:call-template name="generateLink">
					<xsl:with-param name="path" select="$path"/>
					<xsl:with-param name="stylesheet" select="$mappings/mapping/fileExtension[extension=$string]/stylesheet"/>
					<xsl:with-param name="includeContent" select="$mappings/mapping/fileExtension[extension=$string]/includeContent"/>
				</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$path"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="generateLink">
		<xsl:param name="path"/>
		<xsl:param name="stylesheet"/>
		<xsl:param name="includeContent"/>
		<xsl:text>/XFILES/lite/xsl/Resource.html?target=</xsl:text><xsl:value-of select="$path"/>
		<xsl:text disable-output-escaping="yes">&amp;stylesheet=</xsl:text><xsl:value-of select="$stylesheet"></xsl:value-of>
		<xsl:if test="$includeContent='true'">
			<xsl:text disable-output-escaping="yes">&amp;includeContent=true</xsl:text>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
