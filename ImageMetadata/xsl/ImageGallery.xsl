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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:rss="http://xmlns.oracle.com/xdb/xfiles/rss">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:include href="/XFILES/lite/xsl/FolderFileListing.xsl"/>
	<xsl:include href="/XFILES/Applications/imageMetadata/xsl/EXIFCommon.xsl"/>
	<xsl:template name="actionBar"/>
	<xsl:template name="showGallery">
        <style>
            /* jssor slider arrow navigator skin 05 css */
            /*
            .jssora05l              (normal)
            .jssora05r              (normal)
            .jssora05l:hover        (normal mouseover)
            .jssora05r:hover        (normal mouseover)
            .jssora05ldn            (mousedown)
            .jssora05rdn            (mousedown)
            */
            .jssora05l, .jssora05r, .jssora05ldn, .jssora05rdn
            {
            	position: absolute;
            	cursor: pointer;
            	display: block;
                background: url(../img/a17.png) no-repeat;
                overflow:hidden;
            }
            .jssora05l { background-position: -10px -40px; }
            .jssora05r { background-position: -70px -40px; }
            .jssora05l:hover { background-position: -130px -40px; }
            .jssora05r:hover { background-position: -190px -40px; }
            .jssora05ldn { background-position: -250px -40px; }
            .jssora05rdn { background-position: -310px -40px; }

            /* jssor slider thumbnail navigator skin 01 css */

            /*
                .jssort01 .p           (normal)
                .jssort01 .p:hover     (normal mouseover)
                .jssort01 .pav           (active)
                .jssort01 .pav:hover     (active mouseover)
                .jssort01 .pdn           (mousedown)
            */
                .jssort01 .w {
                    position: absolute;
                    top: 0px;
                    left: 0px;
                    width: 100%;
                    height: 100%;
                }

                .jssort01 .c {
                    position: absolute;
                    top: 0px;
                    left: 0px;
                    width: 68px;
                    height: 68px;
                    border: #000 2px solid;
                }

                .jssort01 .p:hover .c, .jssort01 .pav:hover .c, .jssort01 .pav .c {
                    background: url(../img/t01.png) center center;
                    border-width: 0px;
                    top: 2px;
                    left: 2px;
                    width: 68px;
                    height: 68px;
                }

                .jssort01 .p:hover .c, .jssort01 .pav:hover .c {
                    top: 0px;
                    left: 0px;
                    width: 70px;
                    height: 70px;
                    border: #fff 1px solid;
                }
        </style>

		<div id="slider1_container" style="position: relative; top: 0px; left: 0px; width: 800px;height: 456px; background: #191919; overflow: hidden;display:inline-block;">

        <!-- Loading Screen
			<div u="loading" style="position: absolute; top: 0px; left: 0px;">
				<div style="filter: alpha(opacity=70); opacity:0.7; position: absolute; display: block;background-color: #000000; top: 0px; left: 0px;width: 100%;height:100%;">
				</div>
				<div style="position: absolute; display: block; background: url(../img/loading.gif) no-repeat center center; top: 0px; left: 0px;width: 100%;height:100%;">
				</div>
			</div>
        -->
			<!-- Slides Container -->
			<div u="slides" style="cursor: move; position: absolute; left: 0px; top: 0px; width: 800px; height: 356px; overflow: hidden;">
				<xsl:for-each select="xfiles:DirectoryContents/r:Resource[substring-before(r:ContentType,'/')='image']">  
		            <div>
						<img u="image">
							<xsl:attribute name="src"><xsl:value-of select="concat('/sys/oid/',xfiles:ResourceStatus/xfiles:Resid)"/></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="r:DisplayName"/></xsl:attribute>
						</img>
						<img u="thumb">
							<xsl:attribute name="src"><xsl:value-of select="concat('/sys/oid/',xfiles:ResourceStatus/xfiles:Resid)"/></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="r:DisplayName"/></xsl:attribute>
						</img>
						<div u="caption" t="B-T" style="position: absolute; top: 30px; left: 30px; width: 50px;height: 50px; color:white">
							<xsl:value-of select="r:DisplayName"/>
						</div>
					</div>
				</xsl:for-each>
			</div>
			<!-- <script>jssor_slider1_starter('slider1_container');</script> -->
        <!-- Arrow Left -->
        <span u="arrowleft" class="jssora05l" style="width: 40px; height: 40px; top: 158px; left: 8px;">
        </span>
        <!-- Arrow Right -->
        <span u="arrowright" class="jssora05r" style="width: 40px; height: 40px; top: 158px; right: 8px">
        </span>
        <!-- Arrow Navigator Skin End -->
        
        <!-- Thumbnail Navigator Skin Begin -->
        <div u="thumbnavigator" class="jssort01" style="position: absolute; width: 800px; height: 100px; left:0px; bottom: 0px;">
            <!-- Thumbnail Item Skin Begin -->
            <div u="slides" style="cursor: move;">
                <div u="prototype" class="p" style="position: absolute; width: 72px; height: 72px; top: 0; left: 0;">
                    <div class="w"><div u="thumbnailtemplate" style=" width: 100%; height: 100%; border: none;position:absolute; top: 0; left: 0;"></div></div>
                    <div class="c">
                    </div>
                </div>
            </div>
            <!-- Thumbnail Item Skin End -->
        </div>
        <!-- Thumbnail Navigator Skin End -->
        <a style="display: none" href="http://www.jssor.com">Image Slider</a>
	</div>
	</xsl:template>
	<xsl:template name="showProperties">
		<div id="imageProperties" style="width:300px;right:10px; position:fixed;display:inline-block">
			<xsl:for-each select="xfiles:DirectoryContents/r:Resource[substring-before(r:ContentType,'/')='image']">
				<div>
					<xsl:attribute name="id"><xsl:value-of select="concat('imageProperties.',position()-1)"/></xsl:attribute>
					<xsl:attribute name="style"><xsl:text>display:</xsl:text><xsl:choose><xsl:when test="position()=1">block;</xsl:when><xsl:otherwise><xsl:text>none;</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:call-template name="Properties"/>
				</div>
			</xsl:for-each>
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
							<span>/XFILES/Applications/imageMetadata/js/ImageGallery.js</span>
							<!-- use jssor.slider.min.js instead for release -->
							<!-- jssor.slider.min.js = (jssor.js + jssor.slider.js) -->
					    <span>/XFILES/Frameworks/jssor/js/jssor.js</span>
							<span>/XFILES/Frameworks/jssor/js/jssor.slider.js</span>
						</div>
						<div>
							<xsl:call-template name="XFilesSeperator">
								<xsl:with-param name="height" select="'29px'"/>
							</xsl:call-template>
							<xsl:call-template name="showGallery"></xsl:call-template>
							<xsl:call-template name="showProperties"></xsl:call-template>
						</div>
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
