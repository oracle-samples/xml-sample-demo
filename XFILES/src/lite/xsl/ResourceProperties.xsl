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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/xfiles" xmlns:img="http://xmlns.oracle.com/xdb/metadata/ImageMetadata" xmlns:exif="http://xmlns.oracle.com/ord/meta/exif">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:template name="resourceProperties">
		<div style="float:right;">
			<table style="border:0px; margin:0px; padding :0px">
				<tbody>
					<tr>
						<td class="tdLabel">
							<label for="Path">Path</label>
						</td>
						<td class="tdValue" colspan="3">
							<input size="113" id="Path" name="Path" type="text" maxLength="700" disabled="disabled">
								<xsl:attribute name="value"><xsl:value-of select="xfiles:ResourceStatus/xfiles:CurrentPath"/></xsl:attribute>
							</input>
						</td>
					</tr>
					<tr>
						<td class="tdLabel">
							<label for="DisplayName">DisplayName</label>
						</td>
						<td class="tdValue">
							<input size="30" id="DisplayName" name="DisplayName" type="text" maxLength="128">
								<xsl:attribute name="value"><xsl:value-of select="r:DisplayName"/></xsl:attribute>
							</input>
							<span style="display:inline-block;width:10px;height:1px;"/>
							<label for="RenameLink">Rename Link</label>
							<span style="display:inline-block;width:10px;height:1px;"/>
							<input id="RenameLink" name="RenameLink" type="checkbox"/>
						</td>
						<td class="tdLabel">
							<label for="Owner">Owner</label>
						</td>
						<td class="tdValue">
							<input size="30" id="Owner" name="Owner" type="text" maxLength="30" disabled="disabled">
								<xsl:attribute name="value"><xsl:value-of select="r:Owner/@derivedValue"/></xsl:attribute>
							</input>
						</td>
					</tr>
					<tr>
						<td class="tdLabel">
							<label for="Comment">Description</label>
						</td>
						<td class="tdValue" colspan="3">
							<textarea id="Comment" cols="86" rows="5" name="Comment" maxLength="4000">
								<xsl:value-of select="r:Comment"/>
							</textarea>
						</td>
					</tr>
					<xsl:choose>
						<xsl:when test="@Container='false'">
							<tr>
								<td class="tdLabel">
									<label for="ContentType">Content Type</label>
								</td>
								<td class="tdValue">
									<input size="30" id="ContentType" type="text" name="ContentType" maxLength="128">
										<xsl:attribute name="value"><xsl:value-of select="r:ContentType"/></xsl:attribute>
									</input>
								</td>
								<td class="tdLabel">
									<label for="Size">Size</label>
								</td>
								<td class="tdValue">
									<input size="30" id="Size" name="Size" type="text" maxLength="128" disabled="disabled">
										<xsl:attribute name="value"><xsl:value-of select="xfiles:ContentSize"/></xsl:attribute>
									</input>
								</td>
							</tr>
							<tr>
								<td/>
								<td/>
								<td class="tdLabel">
									<label for="Author">Author</label>
								</td>
								<td class="tdValue">
									<input size="30" id="Author" type="text" name="Author" maxLength="128">
										<xsl:attribute name="value"><xsl:value-of select="r:Author"/></xsl:attribute>
									</input>
								</td>
							</tr>
							<tr>
								<td class="tdLabel">
									<label for="Language">Language</label>
								</td>
								<td class="tdValue">
									<select id="Language" name="Language">
										<xsl:call-template name="XFilesLanguageOptions"/>
									</select>
								</td>
								<td class="tdLabel">
									<label for="CharacterSet">Character Set</label>
								</td>
								<td class="tdValue">
									<select id="CharacterSet" name="CharacterSet">
										<xsl:attribute name="value"><xsl:value-of select="r:CharacterSet"/></xsl:attribute>
										<xsl:call-template name="XFilesCharacterSetOptions"/>
									</select>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td/>
							</tr>
							<tr>
								<td/>
							</tr>
							<tr>
								<td/>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
					<tr>
						<td class="tdLabel">
							<label for="Creator">Creator</label>
						</td>
						<td class="tdValue">
							<input size="30" id="Creator" name="Creator" type="text" maxLength="128" disabled="disabled">
								<xsl:attribute name="value"><xsl:value-of select="r:Creator/@derivedValue"/></xsl:attribute>
							</input>
						</td>
						<td class="tdLabel">
							<label for="CreationDate">Created</label>
						</td>
						<td class="tdValue">
							<input size="30" id="CreationDate" name="CreationDate" type="text" maxLength="48" disabled="disabled">
								<xsl:attribute name="value"><xsl:call-template name="formatDate"><xsl:with-param name="date" select="r:CreationDate"/></xsl:call-template></xsl:attribute>
							</input>
						</td>
					</tr>
					<tr>
						<td class="tdLabel">
							<label for="LastModifier">Modified By</label>
						</td>
						<td class="tdValue">
							<input size="30" id="LastModifier" name="LastModifier" type="text" maxLength="128" disabled="disabled">
								<xsl:attribute name="value"><xsl:value-of select="r:LastModifier/@derivedValue"/></xsl:attribute>
							</input>
						</td>
						<td class="tdLabel">
							<label for="ModificationDate">Last Modified</label>
						</td>
						<td class="tdValue">
							<input size="30" id="ModificationDate" name="ModificationDate" type="text" maxLength="128" disabled="disabled">
								<xsl:attribute name="value"><xsl:call-template name="formatDate"><xsl:with-param name="date" select="r:ModificationDate"/></xsl:call-template></xsl:attribute>
							</input>
						</td>
					</tr>
					<tr>
						<td class="tdLabel">
							<label for="ACLPath">ACL Path</label>
						</td>
						<td class="tdValue" colspan="3">
							<input size="113" id="ACLPath" name="ACLPath" type="text" maxLength="700" disabled="disabled">
								<xsl:attribute name="value"><xsl:value-of select="r:ACLOID/@derivedValue"/></xsl:attribute>
							</input>
						</td>
					</tr>
					<xsl:if test="@Container='false'">
						<xsl:for-each select="r:ContentType">
							<xsl:choose>
								<xsl:when test="count(../img:imageMetadata) > 0">
									<xsl:call-template name="printEXIFContent"/>
								</xsl:when>
							</xsl:choose>
						</xsl:for-each>
					</xsl:if>
				</tbody>
			</table>
		</div>
	</xsl:template>
	<xsl:template name="printEXIFContent">
		<xsl:for-each select="../img:imageMetadata/exif:exifMetadata">
			<xsl:for-each select="exif:TiffIfd">
				<tr>
					<td class="tdLabel">
						<label for="exifMake">Camera Manufacturer</label>
					</td>
					<td class="tdValue">
						<input size="30" id="exifMake" name="exifMake" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:Make"/></xsl:attribute>
						</input>
					</td>
					<td class="tdLabel">
						<label for="exifModel">Model</label>
					</td>
					<td class="tdValue">
						<input size="30" id="exifModel" name="exifModel" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:Model"/></xsl:attribute>
						</input>
					</td>
				</tr>
			</xsl:for-each>
			<xsl:for-each select="exif:ExifIfd">
				<tr>
					<td class="tdLabel">
						<label for="Resolution">Resolution</label>
					</td>
					<td class="tdValue">
						<input size="30" id="Resolution" name="Resolution" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:Make"/></xsl:attribute>
						</input>
					</td>
					<td class="tdLabel">
						<label for="ImageSize1">Image Size</label>
					</td>
					<td class="tdValue">
						<input size="10" id="ImageSize1" name="ImageSize1" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:PixelXDimension"/></xsl:attribute>
						</input>
						<xsl:text> X </xsl:text>
						<input size="10" id="ImageSize2" name="ImageSize2" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:PixelYDimension"/></xsl:attribute>
						</input>
					</td>
				</tr>
				<tr>
					<td class="tdLabel">
						<label for="Exposure1">Exposure</label>
					</td>
					<td class="tdValue">
						<input size="10" id="Exposure1" name="Exposure1" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:ExposureTime"/></xsl:attribute>
						</input>
						<xsl:text> @ </xsl:text>
						<input size="10" id="Exposure2" name="Exposure2" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:FNumber"/></xsl:attribute>
						</input>
					</td>
					<td class="tdLabel">
						<label for="Metering">Metering Mode</label>
					</td>
					<td class="tdValue">
						<input size="10" id="Metering" name="Metering" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:MeteringMode"/></xsl:attribute>
						</input>
					</td>
				</tr>
				<tr>
					<td class="tdLabel">
						<label for="Metering">Metering Mode</label>
					</td>
					<td class="tdValue">
						<input size="10" id="Metering" name="Metering" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:MeteringMode"/></xsl:attribute>
						</input>
						<xsl:text> @ </xsl:text>
						<input size="10" id="Exposure2" name="Exposure2" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:PixelYDimension"/></xsl:attribute>
						</input>
					</td>
					<td class="tdLabel">
						<label for="FocalLength">Lens Focal Length</label>
					</td>
					<td class="tdValue">
						<input size="10" id="FocalLength" name="FocalLength" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:FocalLength"/></xsl:attribute>
						</input>
					</td>
				</tr>
				<tr>
					<td class="tdLabel">
						<label for="Distance">Distance from Subject</label>
					</td>
					<td class="tdValue">
						<input size="10" id="Distance" name="Distance" type="text" maxLength="128" disabled="disabled">
							<xsl:attribute name="value"><xsl:value-of select="exif:SubjectDistance"/></xsl:attribute>
						</input>
					</td>
				</tr>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="leftSideBar">
		<div style="width:100px;float:left;">
			<div style="height:10px;"/>
			<xsl:if test="substring-before(r:ContentType,'/')='image'">
				<div>
					<img alt="Unavailable" width="90">
						<xsl:attribute name="src"><xsl:text>/sys/oid/</xsl:text><xsl:value-of select="xfiles:ResourceStatus/xfiles:Resid"/></xsl:attribute>
					</img>
				</div>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="parameters">
		<input type="hidden" name="xmldoc">
			<xsl:attribute name="value"><xsl:value-of select="xfiles:ResourceStatus/xfiles:CurrentPath"/></xsl:attribute>
		</input>
		<input type="hidden" name="listDir" value="true"/>
		<input type="hidden" name="xsldoc" value="/XFILES/xsl/FolderBrowser.xsl"/>
		<input type="hidden" name="contentType" value="text/html"/>
		<input type="hidden" name="task" value=""/>
	</xsl:template>
	<xsl:template match="/">
		<div id="localScriptList" style="display:none;">
			<span>/XFILES/lite/js/ResourceProperties.js</span>
		</div>
		<div id="localScripts" style="display:none;"/>
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'General Properties'"/>
		</xsl:call-template>
		<div class="blueGradient barWithIcons">
			<xsl:call-template name="XFilesSaveAndCloseOptions">
				<xsl:with-param name="saveButton" select="'true'"/>
				<xsl:with-param name="saveAndCloseButton" select="'true'"/>
			</xsl:call-template>
			<span style="float:right;">
				<span id="openDocument" style="display:inline-block;width:21px;">
					<a target="XFilesViewContent" data-toggle="tooltip" data-placement="top" title="Open document in new browser window.">
						<xsl:attribute name="href"><xsl:text>/sys/oid/</xsl:text><xsl:value-of select="/r:Resource/xfiles:ResourceStatus/xfiles:Resid"/></xsl:attribute>
						<xsl:call-template name="IconFromFileExtension">
							<xsl:with-param name="FileExtension" select="/r:Resource/r:DisplayName"/>
						</xsl:call-template>
					</a>
				</span>
			</span>
			<xsl:if test="/*/xfiles:xfilesParameters/xfiles:user!='ANONYMOUS'">
				<span style="float:right;">
					<span id="previewDocument" style="display:inline-block;width:21px;">
						<img id="btnPreviewDocument" src="/XFILES/lib/icons/preview.png" alt="Preview" border="0" height="16" width="16" data-toggle="tooltip" data-placement="top" title="Preview document." onclick="javascript:doPreviewDocument(event);return false;"/>
					</span>
				</span>
				<xsl:call-template name="documentPreview"/>
			</xsl:if>
		</div>
		<div class="formAreaBackground">
			<div class="xfilesIndent">
				<xsl:for-each select="r:Resource">
					<xsl:call-template name="parameters"/>
					<xsl:call-template name="leftSideBar"/>
					<xsl:call-template name="resourceProperties"/>
					<div style="clear:both;"/>
				</xsl:for-each>
			</div>
		</div>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesFooter"/>
	</xsl:template>
</xsl:stylesheet>
