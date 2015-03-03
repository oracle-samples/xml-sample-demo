<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:rss="http://xmlns.oracle.com/xdb/xfiles/rss">
	<xsl:output version="1.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:include href="/XFILES/lite/xsl/FolderFileListing.xsl"/>
	<xsl:include href="/XFILES/Applications/imageMetadata/xsl/EXIFCommon.xsl"/>
	<xsl:template name="actionBar"/>
	<xsl:template name="imageListEntry">
		<tr class="noBorder">
			<td class="withBorder" style="width:24px;">
				<input type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="xfiles:ResourceStatus/xfiles:CurrentPath"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('currentPath.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="xfiles:ResourceStatus/xfiles:LinkName"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('DisplayName.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="xfiles:ResourceStatus/xfiles:Resid"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('RESID.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="@Container"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('isContainer.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:choose><xsl:when test="count(r:VCRUID) = 0"><xsl:text>false</xsl:text></xsl:when><xsl:otherwise><xsl:text>true</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('isVersioned.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:value-of select="@IsCheckedOut"/></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('isCheckedOut.',position())"/></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="value"><xsl:choose><xsl:when test="string-length(r:LockBuf)>64"><xsl:text>true</xsl:text></xsl:when><xsl:otherwise><xsl:text>false</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="id"><xsl:value-of select="concat('isLocked.',position())"/></xsl:attribute>
				</input>
				<a>
					<xsl:attribute name="href"><xsl:text>/XFILES/lite/Resource.html?target=</xsl:text><xsl:value-of select="xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath"/></xsl:attribute>
					<img width="16px" depth="16px" src="/XFILES/lib/icons/pageProperties.png" alt="Select to access File Properties" border="0" aalign="absmiddle"/>
				</a>
			</td>
			<td class="withBorder" style="width:24px;">
				<xsl:call-template name="printIcon"/>
			</td>
			<td class="withBorder" style="width:280px;">
				<xsl:call-template name="printName"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="imagesByLinkName">
		<xsl:param name="sortOrder"/>
		<xsl:for-each select="xfiles:DirectoryContents/r:Resource">
			<xsl:sort order="descending" select="@Container"/>
			<xsl:sort order="{$sortOrder}" select="xfiles:ResourceStatus/xfiles:LinkName"/>
			<xsl:call-template name="imageListEntry"/>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="imageListEntries">
		<xsl:param name="sortKey"/>
		<xsl:param name="sortOrder"/>
		<xsl:choose>
			<xsl:when test="xfiles:DirectoryContents[r:Resource]">
				<xsl:call-template name="imagesByLinkName">
					<xsl:with-param name="sortOrder" select="$sortOrder"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<tr>
					<td colspan="10" width="100%">
						<div style="width:100%;text-align:center">
							<div class="inputFormBorder">
								<xsl:text>Empty Directory</xsl:text>
							</div>
						</div>
					</td>
				</tr>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="imageListHeadings">
		<th title="File Properties" class="alignCenter blueGradient" style="width:29px;">
		</th>
		<th title="File Type" class="alignCenter blueGradient" style="width:29px;">
		</th>
		<xsl:call-template name="printColumnHeading">
			<xsl:with-param name="columnName" select="'xfiles:LinkName'"/>
			<xsl:with-param name="columnWidth" select="'285'"/>
			<xsl:with-param name="sortOrder" select="xfiles:xfilesParameters/xfiles:sortOrder"/>
			<xsl:with-param name="sortKey" select="xfiles:xfilesParameters/xfiles:sortKey"/>
			<xsl:with-param name="class" select="'alignLeft blueGradient'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="showImageList">
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'29px'"/>
		</xsl:call-template>
		<div id="imageList" class="imageList" style="margin:10px;">
			<div class="formAreaBackground" id="folderListing">
				<table class="withBorder defaultFont" summary="" style="width:100%">
					<tbody>
						<tr class="tableHeader withBorder">
							<xsl:call-template name="imageListHeadings"/>
						</tr>
					</tbody>
				</table>
				<table class="withBorder defaultFont" summary="" style="width:100%">
					<tbody>
						<xsl:call-template name="imageListEntries">
							<xsl:with-param name="sortKey" select="xfiles:xfilesParameters/xfiles:sortKey"/>
							<xsl:with-param name="sortOrder" select="xfiles:xfilesParameters/xfiles:sortOrder"/>
						</xsl:call-template>
					</tbody>
				</table>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="addThumbnail">
		<xsl:param name="Name"/>
		<xsl:param name="RESID"/>
		<span style="padding-left:10;">
			<img style="height:150px;">
				<xsl:attribute name="src"><xsl:value-of select="concat('/sys/oid/',xfiles:ResourceStatus/xfiles:Resid)"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:value-of select="$Name"/></xsl:attribute>
			</img>
		</span>
	</xsl:template>
	<xsl:template name="showImages">
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'29px'"/>
		</xsl:call-template>
		<div id="imagePreviews" class="imagePreviews" style="margin:10px;">
			<xsl:for-each select="xfiles:DirectoryContents/r:Resource[substring-before(r:ContentType,'/')='image']">
				<div class="imagePreview">
					<xsl:attribute name="id"><xsl:value-of select="concat('imagePreview.',position())"/></xsl:attribute>
					<xsl:attribute name="style"><xsl:text>vertical-align: middle; text-align: center;display:</xsl:text><xsl:choose><xsl:when test="position()=1">block;</xsl:when><xsl:otherwise><xsl:text>none;</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
					<!--
						<xsl:attribute name="style">
                             <xsl:text>height:400px;background:url(</xsl:text>
                              <xsl:value-of select="concat('http://localhost/sys/oid/',xfiles:ResourceStatus/xfiles:Resid)"/>
                              <xsl:text>) no-repeat center center; margin 20; display:</xsl:text>
                              <xsl:choose><xsl:when test="position() = 1">
                                   <xsl:text>block</xsl:text></xsl:when>
                                   <xsl:otherwise><xsl:text>none</xsl:text></xsl:otherwise>
                              </xsl:choose>
                              <xsl:text>;</xsl:text>
                        </xsl:attribute>
                    -->
					<img style="height:400px;margin:auto;">
						<xsl:attribute name="src"><xsl:value-of select="concat('/sys/oid/',xfiles:ResourceStatus/xfiles:Resid)"/></xsl:attribute>
						<xsl:attribute name="alt"><xsl:value-of select="r:DisplayName"/></xsl:attribute>
					</img>
				</div>
			</xsl:for-each>
		</div>
		<div style="clear:both;"/>
		<xsl:if test="count(xfiles:DirectoryContents/r:Resource[substring-before(r:ContentType,'/')='image']) > 1">
			<div style="display:table">
				<span style="display:table-cell; padding-right:10px; vertical-align: middle;" onclick="rotateCarouselLeft()">
					<img src="/XFILES/Applications/imageMetadata/xsl/left-arrow-circle.png" alt=""/>
				</span>
				<span id="thumbnailCarousel" class="thumbnailCarousel" style="height:100px;position:relative;left:0px; top:0px;overflow:hidden;display:inline-block;">
					<xsl:for-each select="xfiles:DirectoryContents/r:Resource[substring-before(r:ContentType,'/')='image']">
						<span class="thumbnail" style="margin-right:10px;height:100px;display=inline-block;">
							<xsl:attribute name="id"><xsl:value-of select="concat('thumbnail.',position())"/></xsl:attribute>
							<img style="height:100px;">
								<xsl:attribute name="src"><xsl:value-of select="concat('/sys/oid/',xfiles:ResourceStatus/xfiles:Resid)"/></xsl:attribute>
								<xsl:attribute name="onclick"><xsl:value-of select="concat('syncPanels(',position(),');return false;')"/></xsl:attribute>
								<xsl:attribute name="alt"><xsl:value-of select="r:DisplayName"/></xsl:attribute>
							</img>
						</span>
					</xsl:for-each>
				</span>
				<span style="display:table-cell;vertical-align: middle;" onclick="rotateCarouselRight()">
					<img src="/XFILES/Applications/imageMetadata/xsl/right-arrow-circle.png/" alt=""/>
				</span>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="imageBrowser">
		<div id="folderListing" style="width:350px; left:10px; position:fixed;">
			<xsl:call-template name="showImageList"/>
		</div>
		<div id="fileProperties" style="width:300px;right:10px; position:fixed;">
			<xsl:call-template name="XFilesSeperator">
				<xsl:with-param name="height" select="'29px'"/>
			</xsl:call-template>
			<xsl:for-each select="xfiles:DirectoryContents/r:Resource[substring-before(r:ContentType,'/')='image']">
				<div>
					<xsl:attribute name="id"><xsl:value-of select="concat('imageProperties.',position())"/></xsl:attribute>
					<xsl:attribute name="style"><xsl:text>display:</xsl:text><xsl:choose><xsl:when test="position()=1">block;</xsl:when><xsl:otherwise><xsl:text>none;</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:call-template name="Properties"/>
				</div>
			</xsl:for-each>
		</div>
		<div id="images" style="padding:0px 300px 0px 350px;">
			<xsl:call-template name="showImages"/>
		</div>
	</xsl:template>
	<xsl:template match="/">
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'Browse Files'"/>
			<xsl:with-param name="fastPath" select="'true'"/>
		</xsl:call-template>
		<div class="XFilesBody">
			<xsl:for-each select="/r:Resource">
				<xsl:choose>
					<xsl:when test="xfiles:DirectoryContents/r:Resource[substring-before(r:ContentType,'/')='image']">
						<div id="localScriptList" style="display:none;">
							<span>/XFILES/lite/js/FolderBrowser.js</span>
							<span>/XFILES/Applications/imageMetadata/js/ImageBrowser.js</span>
						</div>
						<xsl:call-template name="imageBrowser"/>
					</xsl:when>
					<xsl:otherwise>
						<div id="localScriptList" style="display:none;">
							<span>/XFILES/lite/js/FolderBrowser.js</span>
						</div>
						<xsl:call-template name="listFolderContents"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</div>
		<div style="clear:both"/>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesFooter"/>
	</xsl:template>
</xsl:stylesheet>
