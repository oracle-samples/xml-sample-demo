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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:x="http://xmlns.oracle.com/xdb/pm/demo/search">
	<xsl:variable name="NodeMapName" select="/x:NodeMap/@nodeMapName"/>
	<xsl:variable name="searchIconsEnabled" select="not(/x:NodeMap[@isChildNodeMap='true'])"/>
	<xsl:template name="includeNodeControl">
		<xsl:param name="function"/>
		<span style="padding-right:3px">
			<input type="checkbox">
				<xsl:attribute name="onclick"><xsl:value-of select="concat($function,'(',$NodeMapName,',&quot;',@ID,'&quot;);return true;')"></xsl:value-of></xsl:attribute>
				<xsl:choose>
					<xsl:when test="@isSelected='true'">
						<xsl:attribute name="checked"/>
					</xsl:when>
				</xsl:choose>
			</input>
		</span>
	</xsl:template>
	<xsl:template name="toggleChildrenControl">
		<span style="padding-right:3px">
			<img alt="" border="0" data-toggle="tooltip" data-placement="top">
				<xsl:attribute name="src"><xsl:choose><xsl:when test="@childrenVisible='block'"><xsl:text>/XFILES/lib/icons/elementHideChildren.png</xsl:text></xsl:when><xsl:otherwise><xsl:text>/XFILES/lib/icons/elementShowChildren.png</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleChildren(',$NodeMapName,',&quot;',@ID,'&quot;);return false;')"></xsl:value-of></xsl:attribute>
				<xsl:attribute name="title"><xsl:choose><xsl:when test="@childrenVisible='block'"><xsl:text>Hide Children</xsl:text></xsl:when><xsl:otherwise><xsl:text>Show Childen</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
			</img>
		</span>
	</xsl:template>
	<xsl:template name="toggleAttributesControl">
		<span style="padding-right:3px">
			<img alt="" border="0" data-toggle="tooltip" data-placement="top">
				<xsl:attribute name="src"><xsl:choose><xsl:when test="@attributesVisible='block'"><xsl:text>/XFILES/lib/icons/elementHideAttrs.png</xsl:text></xsl:when><xsl:otherwise><xsl:text>/XFILES/lib//icons/elementShowAttrs.png</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="title"><xsl:choose><xsl:when test="@attributesVisible='block'"><xsl:text>Hide Attributes</xsl:text></xsl:when><xsl:otherwise><xsl:text>Show Attributes</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleAttrs(',$NodeMapName,',&quot;',@ID,'&quot;);return false;')"></xsl:value-of></xsl:attribute>
			</img>
		</span>
	</xsl:template>
	<xsl:template name="toggleSubstitutionGroupControl">
		<span style="padding-right:3px">
			<xsl:choose>
				<xsl:when test="x:SubGroup">
					<img alt="" border="0" data-toggle="tooltip" data-placement="top">
						<xsl:attribute name="title"><xsl:choose><xsl:when test="@subGroupVisible='block'"><xsl:text>Show Substitution Group</xsl:text></xsl:when><xsl:otherwise><xsl:text>Hide Substitution Group</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleSubGroup(',$NodeMapName,',&quot;',@ID,'&quot;);return false;')"></xsl:value-of></xsl:attribute>
						<xsl:attribute name="src"><xsl:choose><xsl:when test="@subGroupVisible='block'"><xsl:text>/XFILES/lib/icons/hideSubGroup.png</xsl:text></xsl:when><xsl:otherwise><xsl:text>/XFILES/lib/icons/showSubGroup.png</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
					</img>
				</xsl:when>
				<xsl:otherwise>
					<img alt="" border="0" data-toggle="tooltip" data-placement="top" title="Show Substitution Group">
						<xsl:attribute name="onclick"><xsl:value-of select="concat('expandSubstitutionGroup(',$NodeMapName,',&quot;',@subGroupHead,'&quot;,&quot;',@ID,'&quot;);return false;')"></xsl:value-of></xsl:attribute>
						<xsl:attribute name="src"><xsl:text>/XFILES/lib/icons/showSubGroup.png</xsl:text></xsl:attribute>
					</img>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template name="toggleNodeValueControl">
		<xsl:param name="toggleValueImplementation"/>
		<xsl:param name="iconName"/>
		<span style="padding-right:3px;" data-toggle="tooltip" data-placement="top">
			<img border="0">
				<xsl:attribute name="onclick"><xsl:value-of select="concat($toggleValueImplementation,'(',$NodeMapName,',&quot;',@ID,'&quot;);return false;')"></xsl:value-of></xsl:attribute>
				<xsl:attribute name="title"><xsl:choose><xsl:when test="@valueVisible='hidden'"><xsl:text>Enable Input</xsl:text></xsl:when><xsl:otherwise><xsl:text>Disable Input</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:attribute name="src"><xsl:value-of select="concat('/XFILES/lib/icons/',$iconName)"/></xsl:attribute>
				<xsl:attribute name="alt"><xsl:choose><xsl:when test="@valueVisible='hidden'"><xsl:text>Enable Input</xsl:text></xsl:when><xsl:otherwise><xsl:text>Disable Input</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
			</img>
		</span>
	</xsl:template>
	<xsl:template name="isUniqueKeyIcon">
		<xsl:param name="setUniqueKeyImplementation"/>
		<xsl:if test="$searchIconsEnabled">
			<span style="padding-right:3px">
				<img alt="" border="0" data-toggle="tooltip" data-placement="top">
					<xsl:attribute name="title"><xsl:choose><xsl:when test="@uniqueKey='true'"><xsl:text>Define Unique Key</xsl:text></xsl:when><xsl:otherwise><xsl:text>Undefine Unique Key</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="onclick"><xsl:value-of select="concat($setUniqueKeyImplementation,'(',$NodeMapName,',&quot;',@ID,'&quot;);return false;')"></xsl:value-of></xsl:attribute>
					<xsl:attribute name="src"><xsl:choose><xsl:when test="@uniqueKey='true'"><xsl:text>/XFILES/lib/icons/notUniqueKey.png</xsl:text></xsl:when><xsl:otherwise><xsl:text>/XFILES/lib/icons/uniqueKey.png</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
				</img>
			</span>
		</xsl:if>
	</xsl:template>
	<xsl:template name="isOIDKeyIcon">
		<xsl:if test="parent::x:NodeMap">
			<xsl:call-template name="isUniqueKeyIcon">
				<xsl:with-param name="setUniqueKeyImplementation" select="'setElementUniqueKey'"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="doPathSearchIcon">
		<xsl:if test="$searchIconsEnabled and parent::x:NodeMap/@schemaType">
			<span style="padding-right:3px">
				<img alt="" border="0">
					<xsl:attribute name="onclick"><xsl:value-of select="concat('setPathSearch(',$NodeMapName,',&quot;',@ID,'&quot;);return false;')"></xsl:value-of></xsl:attribute>
					<xsl:attribute name="src"><xsl:choose><xsl:when test="@pathSearch='true'"><xsl:text>/XFILES/lib/icons/notPathSearch.png</xsl:text></xsl:when><xsl:otherwise><xsl:text>/XFILES/lib/icons/pathSearch.png</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
				</img>
			</span>
		</xsl:if>
	</xsl:template>
	<xsl:template name="toggleNodeValue">
		<img alt="" border="0">
			<xsl:attribute name="onclick"><xsl:value-of select="concat('toggleValue(',$NodeMapName,',&quot;',@ID,'&quot;);return false;')"></xsl:value-of></xsl:attribute>
			<xsl:attribute name="src"><xsl:choose><xsl:when test="@valueVisible='hidden'"><xsl:text>/XFILES/lib/icons/showNodeValue.png</xsl:text></xsl:when><xsl:otherwise><xsl:text>/XFILES/lib/icons/hideNodeValue.png</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
		</img>
	</xsl:template>
	<xsl:template name="addNodeValueDialog">
		<xsl:param name="toggleValueImplementation"/>
		<xsl:param name="setValueImplementation"/>
		<xsl:param name="setUniqueKeyImplementation"/>
		<span>
			<span style="padding-right:3px">
				<img border="0">
					<xsl:attribute name="onclick"><xsl:value-of select="concat($toggleValueImplementation,'(',$NodeMapName,',&quot;',@ID,'&quot;);')"></xsl:value-of></xsl:attribute>
					<xsl:attribute name="src"><xsl:choose><xsl:when test="@valueVisible='hidden'"><xsl:text>/XFILES/lib/icons/showNodeValue.png</xsl:text></xsl:when><xsl:otherwise><xsl:text>/XFILES/lib/icons/hideNodeValue.png</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
					<xsl:attribute name="alt"><xsl:choose><xsl:when test="@valueVisible='hidden'"><xsl:text>Enable Input</xsl:text></xsl:when><xsl:otherwise><xsl:text>Display Input</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
				</img>
			</span>
			<xsl:if test="@valueVisible='visible'">
				<span style="padding-right:3px">
					<input type="text" border="0" size="32" style="color: #000000; background-color: efefff;">
						<xsl:attribute name="onchange"><xsl:value-of select="concat($setValueImplementation,'(',$NodeMapName,',&quot;',@ID,'&quot;,this.value);')"></xsl:value-of></xsl:attribute>
						<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
					</input>
				</span>
			</xsl:if>
			<xsl:call-template name="isUniqueKeyIcon">
				<xsl:with-param name="setUniqueKeyImplementation" select="$setUniqueKeyImplementation"/>
			</xsl:call-template>
		</span>
	</xsl:template>
	<xsl:template name="printElementName">
		<span style="padding-right:3px;">
			<xsl:choose>
				<xsl:when test="parent::x:Elements or parent::x:NodeMap or parent::x:SubGroup">
					<xsl:choose>
						<xsl:when test="x:Name">
							<xsl:value-of select="x:Name"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="."/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
			</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template name="processSimpleContent">
		<xsl:call-template name="toggleNodeValueControl">
			<xsl:with-param name="iconName" select="'element.png'"/>
			<xsl:with-param name="toggleValueImplementation" select="'toggleValue'"/>
		</xsl:call-template>
		<xsl:call-template name="printElementName"/>
		<xsl:call-template name="addNodeValueDialog">
			<xsl:with-param name="setValueImplementation" select="'setElementValue'"/>
			<xsl:with-param name="setUniqueKeyImplementation" select="'setElementUniqueKey'"/>
			<xsl:with-param name="toggleValueImplementation" select="'toggleValue'"/>
		</xsl:call-template>
	</xsl:template>
	<xsl:template name="processAttribute">
		<div>
			<span style="white-space:nowrap">
				<xsl:call-template name="includeNodeControl">
					<xsl:with-param name="function" select="'toggleAttrState'"/>
				</xsl:call-template>
				<xsl:call-template name="toggleNodeValueControl">
					<xsl:with-param name="iconName" select="'attribute.png'"/>
					<xsl:with-param name="toggleValueImplementation" select="'toggleAttrValue'"/>
				</xsl:call-template>
				<span style="padding-right:3px;">
					<xsl:value-of select="."/>
				</span>
				<xsl:call-template name="addNodeValueDialog">
					<xsl:with-param name="setValueImplementation" select="'setAttrValue'"/>
					<xsl:with-param name="setUniqueKeyImplementation" select="'setAttrUniqueKey'"/>
					<xsl:with-param name="toggleValueImplementation" select="'toggleAttrValue'"/>
				</xsl:call-template>
			</span>
		</div>
	</xsl:template>
	<xsl:template name="processAttributes">
		<xsl:if test="@attributesVisible='block'">
			<div>
				<xsl:attribute name="id"><xsl:value-of select="@ID"/><xsl:text>-ATTRS</xsl:text></xsl:attribute>
				<xsl:for-each select="x:Attrs/x:Attr">
					<xsl:call-template name="processAttribute"/>
				</xsl:for-each>
			</div>
		</xsl:if>
	</xsl:template>
	<xsl:template name="processSubstitutionGroup">
		<div style="margin-left:19px">
			<input type="radio">
				<xsl:attribute name="value"><xsl:value-of select="@ID"/></xsl:attribute>
				<xsl:attribute name="name"><xsl:value-of select="@subGroupHead"></xsl:value-of></xsl:attribute>
				<xsl:attribute name="onclick"><xsl:value-of select="concat('setSubtitutableItem(',$NodeMapName,',&quot;',@ID,'&quot;,this);return false;')"></xsl:value-of></xsl:attribute>
				<xsl:if test="x:SubGroup/@SelectedMember=@ID">
					<xsl:attribute name="checked"/>
				</xsl:if>
			</input>
			<label>
				<xsl:call-template name="printElementName"/>
			</label>
			<xsl:for-each select="x:SubGroup/x:Element">
				<span style="padding-right:3px;white-space:nowrap;display:block">
					<input type="radio">
						<xsl:attribute name="value"><xsl:value-of select="@ID"/></xsl:attribute>
						<xsl:attribute name="name"><xsl:value-of select="../../@subGroupHead"></xsl:value-of></xsl:attribute>
						<xsl:attribute name="onclick"><xsl:value-of select="concat('setSubtitutableItem(',$NodeMapName,',&quot;',../@ID,'&quot;,this);return false;')"></xsl:value-of></xsl:attribute>
						<xsl:if test="../@SelectedMember=@ID">
							<xsl:attribute name="checked"/>
						</xsl:if>
					</input>
					<label>
						<xsl:call-template name="printElementName"/>
					</label>
				</span>
			</xsl:for-each>
		</div>
	</xsl:template>
	<xsl:template name="processChildren">
		<div>
			<xsl:attribute name="id"><xsl:value-of select="@ID"/></xsl:attribute>
			<xsl:attribute name="style"><xsl:choose><xsl:when test="@childrenVisible='block'"><xsl:text>display: block;</xsl:text></xsl:when><xsl:otherwise><xsl:text>display: none;</xsl:text></xsl:otherwise></xsl:choose></xsl:attribute>
			<xsl:if test="@childrenVisible='block'">
				<xsl:for-each select="x:Elements/x:Element">
					<xsl:call-template name="processElement"/>
				</xsl:for-each>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template name="printContentModel">
		<xsl:if test="x:Elements/x:Element">
			<xsl:call-template name="toggleChildrenControl"/>
		</xsl:if>
		<xsl:if test="x:Attrs/x:Attr">
			<xsl:call-template name="toggleAttributesControl"/>
		</xsl:if>
		<xsl:choose>
			<xsl:when test="x:Name and not(x:Elements)">
				<xsl:call-template name="processSimpleContent"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Complex Content -->
				<xsl:call-template name="printElementName"/>
				<xsl:call-template name="isOIDKeyIcon"/>
				<xsl:call-template name="doPathSearchIcon"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="expandElement">
		<div style="margin-left:19px">
			<xsl:call-template name="processAttributes"/>
			<xsl:call-template name="processChildren"/>
		</div>
	</xsl:template>
	<xsl:template name="unknownContentModel">
		<span style="padding-right:3px;">
			<img alt="Expand" src="/XFILES/lib/icons/elementExpand.png" border="0" data-toggle="tooltip" data-placement="top" title="Expand Element">
				<xsl:attribute name="onclick"><xsl:text>findContentModel(</xsl:text><xsl:value-of select="$NodeMapName"/><xsl:text>,'</xsl:text><xsl:choose><xsl:when test="parent::x:Elements or parent::x:NodeMap"><xsl:value-of select="@ID"/></xsl:when><xsl:otherwise><xsl:value-of select="parent::x:SubGroup/@SelectedMember"/></xsl:otherwise></xsl:choose><xsl:text>');return false;</xsl:text></xsl:attribute>
			</img>
		</span>
		<xsl:call-template name="printElementName"/>
	</xsl:template>
	<xsl:template name="subGroupContentModel">
		<xsl:variable name="SelectedMember" select="x:SubGroup/@SelectedMember"/>
		<span style="white-space:nowrap">
			<!-- Print the Include Control -->
			<xsl:call-template name="includeNodeControl">
				<xsl:with-param name="function" select="'toggleElementState'"/>
			</xsl:call-template>
			<xsl:call-template name="toggleSubstitutionGroupControl"/>
			<xsl:call-template name="printElementName"/>
			<!-- User can choose to view substition group members or the definition of the selected member -->
			<xsl:choose>
				<xsl:when test="@subGroupVisible='block'">
					<xsl:call-template name="processSubstitutionGroup"/>
				</xsl:when>
				<xsl:otherwise>
					<div style="margin-left:19px">
						<xsl:choose>
							<xsl:when test="(not(x:SubGroup) or (x:SubGroup[@ID = @SelectedMember]))">
								<xsl:call-template name="printContentModel"/>
								<xsl:call-template name="expandElement"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="x:SubGroup/x:Element[@ID = $SelectedMember]">
									<xsl:choose>
										<xsl:when test="not(x:Name)">
											<!-- Unknown Content Model : Add expand element control -->
											<xsl:call-template name="unknownContentModel"/>
										</xsl:when>
										<xsl:otherwise>
											<!-- Known Content Model Add approriate controls for Content Model -->
											<xsl:call-template name="processElement"/>
											<!--
											<xsl:call-template name="printContentModel"/>
											<xsl:call-template name="expandElement"/>
											-->
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template name="elementName">
		<span style="white-space:nowrap">
			<!-- Print the Include Control -->
			<xsl:call-template name="includeNodeControl">
				<xsl:with-param name="function" select="'toggleElementState'"/>
			</xsl:call-template>
			<xsl:choose>
				<xsl:when test="not(x:Name)">
					<!-- Unknown Content Model : Add expand element control -->
					<xsl:call-template name="unknownContentModel"/>
				</xsl:when>
				<xsl:otherwise>
					<!-- Known Content Model Add approriate controls for Content Model -->
					<xsl:call-template name="printContentModel"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
	<xsl:template name="processElement">
		<div>
			<xsl:choose>
				<xsl:when test="@subGroupHead">
					<xsl:call-template name="subGroupContentModel"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:call-template name="elementName"/>
					<xsl:call-template name="expandElement"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template match="/">
		<xsl:for-each select="x:NodeMap">
			<xsl:choose>
				<xsl:when test="count(x:Element) > 0">
					<xsl:for-each select="x:Element">
						<xsl:call-template name="processElement"/>
					</xsl:for-each>
				</xsl:when>
				<xsl:otherwise>
					<div id="notFound" style="width:100%;text-align:center">
						<div class="inputFormBorder formText14">
							<xsl:text>Empty Table</xsl:text>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
