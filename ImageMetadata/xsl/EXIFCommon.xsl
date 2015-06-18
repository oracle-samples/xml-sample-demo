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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/xfiles" xmlns:img="http://xmlns.oracle.com/xdb/metadata/ImageMetadata" xmlns:exif="http://xmlns.oracle.com/ord/meta/exif" xmlns:ord="http://xmlns.oracle.com/ord/meta/ordimage" xmlns:xhtml="http://www.w3.org/1999/xhtml">
	<xsl:template name="disabledInputCell">
		<xsl:param name="id"/>
		<xsl:param name="labelText"/>
		<xsl:param name="value"/>
		<xsl:param name="length"/>
		<xsl:param name="maxLength"/>
		<tr>
			<td class="tdLabel">
				<label>
					<xsl:attribute name="for"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:value-of select="$labelText"/>
				</label>
			</td>
			<td class="tdValue">
				<input maxLength="128" disabled="disabled">
					<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="$value"/></xsl:attribute>
					<xsl:attribute name="size"><xsl:value-of select="$length"/></xsl:attribute>
					<xsl:attribute name="maxLength"><xsl:value-of select="$maxLength"/></xsl:attribute>
				</input>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="disabledInputCellDate">
		<xsl:param name="id"/>
		<xsl:param name="labelText"/>
		<xsl:param name="value"/>
		<xsl:param name="length"/>
		<xsl:param name="maxLength"/>
		<tr>
			<td class="tdLabel">
				<label>
					<xsl:attribute name="for"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:value-of select="$labelText"/>
				</label>
			</td>
			<td class="tdValue">
				<input maxLength="128" disabled="disabled">
					<xsl:attribute name="id"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="name"><xsl:value-of select="$id"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:call-template name="formatDate"><xsl:with-param name="date" select="$value"/></xsl:call-template></xsl:attribute>
					<xsl:attribute name="size"><xsl:value-of select="$length"/></xsl:attribute>
					<xsl:attribute name="maxLength"><xsl:value-of select="$maxLength"/></xsl:attribute>
				</input>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="CameraMake">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Manufacturer'"/>
			<xsl:with-param name="labelText" select="'Manufacturer'"/>
			<xsl:with-param name="value" select="exif:Make"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="CameraModel">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Model'"/>
			<xsl:with-param name="labelText" select="'Model'"/>
			<xsl:with-param name="value" select="exif:Model"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="SubjectDistance">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Distance'"/>
			<xsl:with-param name="labelText" select="'Subject Distance'"/>
			<xsl:with-param name="value" select="exif:SubjectDistance"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="MeteringMode">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Metering'"/>
			<xsl:with-param name="labelText" select="'Metering Mode'"/>
			<xsl:with-param name="value" select="exif:MeteringMode"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="FocalLength">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Focal'"/>
			<xsl:with-param name="labelText" select="'Focal Length'"/>
			<xsl:with-param name="value" select="exif:FocalLength"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Author">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Author'"/>
			<xsl:with-param name="labelText" select="'Author'"/>
			<xsl:with-param name="value" select="r:Author"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Version">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Version'"/>
			<xsl:with-param name="labelText" select="'Version'"/>
			<xsl:with-param name="value" select="r:Version"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Comment">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Comment'"/>
			<xsl:with-param name="labelText" select="'Comments'"/>
			<xsl:with-param name="value" select="r:Comment"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Creator">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Created'"/>
			<xsl:with-param name="labelText" select="'Created By'"/>
			<xsl:with-param name="value" select="r:Creator/@derivedValue"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Modifier">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'ModifiedBy'"/>
			<xsl:with-param name="labelText" select="'Last Modified By'"/>
			<xsl:with-param name="value" select="r:LastModifier/@derivedValue"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="ContentType">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'ContentType'"/>
			<xsl:with-param name="labelText" select="'ContentType'"/>
			<xsl:with-param name="value" select="r:ContentType"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Resolution">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Resolution'"/>
			<xsl:with-param name="labelText" select="'Resolution'"/>
			<xsl:with-param name="value" select="concat(exif:PixelXDimension,' X ',exif:PixelYDimension)"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Exposure">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Exposure'"/>
			<xsl:with-param name="labelText" select="'Exposure'"/>
			<xsl:with-param name="value" select="concat(exif:ExposureTime,' @ ',exif:FNumber)"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="DateTaken">
		<xsl:call-template name="disabledInputCellDate">
			<xsl:with-param name="id" select="'Taken'"/>
			<xsl:with-param name="labelText" select="'Date Taken'"/>
			<xsl:with-param name="value" select="exif:DateTimeDigitized"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="DateCreated">
		<xsl:call-template name="disabledInputCellDate">
			<xsl:with-param name="id" select="'Created'"/>
			<xsl:with-param name="labelText" select="'Created'"/>
			<xsl:with-param name="value" select="r:CreationDate"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="DateModified">
		<xsl:call-template name="disabledInputCellDate">
			<xsl:with-param name="id" select="'Modified'"/>
			<xsl:with-param name="labelText" select="'Last Modified'"/>
			<xsl:with-param name="value" select="r:ModificationDate"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Latitude">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Latitude'"/>
			<xsl:with-param name="labelText" select="'GPSLatitude '"/>
			<xsl:with-param name="value" select="exif:GPSLatitude"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Longitude">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Longitude'"/>
			<xsl:with-param name="labelText" select="'Longitude'"/>
			<xsl:with-param name="value" select="exif:GPSLongitude"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Altitude">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'Longitude'"/>
			<xsl:with-param name="labelText" select="'Altitude'"/>
			<xsl:with-param name="value" select="exif:GPSAltitude"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="GPSDate">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'GPSDate'"/>
			<xsl:with-param name="labelText" select="'GPS Date'"/>
			<xsl:with-param name="value" select="exif:GPSDateStamp"/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="GPSTime">
		<xsl:call-template name="disabledInputCell">
			<xsl:with-param name="id" select="'GPSTimeStamp '"/>
			<xsl:with-param name="labelText" select="'GPS Time'"/>
			<xsl:with-param name="value" select="exif:GPSTimeStamp "/>
			<xsl:with-param name="length" select="'16'"/>
			<xsl:with-param name="maxLength" select="'128'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="Resource">
		<xsl:if test="count(r:Author/text())>0">
			<xsl:call-template name="Author"/>
		</xsl:if>
		<xsl:if test="count(r:Version/text())>0">
			<xsl:call-template name="Version"/>
		</xsl:if>
		<xsl:if test="count(r:Comment)>0">
			<xsl:call-template name="Comment"/>
		</xsl:if>
		<xsl:call-template name="Creator"/>
		<xsl:call-template name="DateCreated"/>
		<xsl:call-template name="Modifier"/>
		<xsl:call-template name="DateModified"/>
		<xsl:call-template name="ContentType"/>
	</xsl:template>
	<xsl:template name="Metadata">
		<xsl:for-each select="img:imageMetadata">
			<xsl:for-each select="ord:ordImageAttributes">
				<input id="imageWidth" type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="ord:width"/></xsl:attribute>
				</input>
				<input id="imageHeight" type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="ord:height"/></xsl:attribute>
				</input>
			</xsl:for-each>
			<xsl:for-each select="exif:exifMetadata">
				<xsl:for-each select="exif:TiffIfd">
					<xsl:call-template name="CameraMake"/>
					<xsl:call-template name="CameraModel"/>
				</xsl:for-each>
				<xsl:for-each select="exif:ExifIfd">
					<xsl:call-template name="Resolution"/>
					<xsl:call-template name="Exposure"/>
					<xsl:call-template name="DateTaken"/>
					<xsl:call-template name="SubjectDistance"/>
					<xsl:call-template name="MeteringMode"/>
					<xsl:call-template name="FocalLength"/>
				</xsl:for-each>
				<xsl:for-each select="exif:GpsIfd ">
					<xsl:call-template name="Latitude"/>
					<xsl:call-template name="Longitude"/>
					<xsl:call-template name="Altitude"/>
					<xsl:call-template name="GPSDate"/>
					<xsl:call-template name="GPSTime"/>
				</xsl:for-each>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="Properties">
		<div style="display:table-cell">
			<table cellpadding="0" cellspacing="0" border="0">
				<tbody>
					<xsl:call-template name="Resource"/>
					<xsl:call-template name="Metadata"/>
				</tbody>
			</table>
		</div>
	</xsl:template>
</xsl:stylesheet>
