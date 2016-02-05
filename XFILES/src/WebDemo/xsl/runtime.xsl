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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/XDBResource.xsd">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<!--<xsl:include href="c:/xdb/demo//XFILES.6/src/lite/xsl/common.xsl"/>-->
	<xsl:variable name="demonstrationRoot" select="/r:Resource/r:Contents/Configuration/rootFolder"/>
	<xsl:variable name="lowercase" select="'abcdefghijklmnopqrstuvwxyz'"/>
	<xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'"/>
	<xsl:template name="sqlAuthentication">
		<span style="display: none;" id="sqlAuthentication" onclick="stopBubble(event)">
			<div style="position:relative; top:0ex">
				<div class="popupOuterEdge" style="top: 10px; right: 25em;">
					<div class="popupBackground">
						<div class="popupInnerEdge">
							<div class="row popupTitle">
								<xsl:text>SQL Authentication Required</xsl:text>
							</div>
							<div class="row">
								<span class="labelCol">
									<label for="sqlUsername">Username</label>
								</span>
								<span class="inputCol">
									<input id="sqlUsername" name="sqlUsername" size="32" type="text" maxlength="32"/>
								</span>
							</div>
							<div class="row">
								<span class="labelCol">
									<label for="sqlPassword">Password</label>
								</span>
								<span class="inputCol">
									<input id="sqlPassword" name="sqlPassword" size="32" type="password" maxlength="32"/>
								</span>
							</div>
							<div class="row textRight10">
								<img id="btnCancelAuthentication" src="/XFILES/lib/icons/cancel.png" alt="Cancel" border="0" width="16" height="16" onclick="closePopupDialog();false"/>
								<span style="width:10px; display:inline-block;"/>
								<img id="btnDoAuthentication" src="/XFILES/lib/icons/accept.png" alt="Accept" border="0" width="16" height="16" onclick="validateCredentials(document.getElementById('sqlUsername'),document.getElementById('sqlPassword'));"/>
							</div>
						</div>
					</div>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="processSQLFile">
		<!-- Execute a single SQL Script -->
		<div style="vertical-align:top; margin-left:10px;margin-right:10px; width:100%; display:none;" id="1.Step">
			<div style="display: none;" id="1.stepDisplay">
				<input type="hidden" id="1.action" value="SQL"/>
				<input type="hidden" id="1.sqlScript">
					<xsl:attribute name="value"><xsl:value-of select="/r:Resource/xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath"/></xsl:attribute>
				</input>
				<div style="display:block;" id="1.tabSet"/>
				<div class="tabBar barWithIcons" style="display:inline-block;padding-left:0px;width:100%;height:24px;">
					<div style="float:left;vertical-align:middle;padding-left:5px;">
						<span style="display:inline-block" id="1.actions"/>
					</div>
					<div style="float:right;font-size:7pt;font-weight:bold;vertical-align:middle;">
						<span style="display:inline-block;" id="1.doExplainPlan">
							<span>
								<input type="checkbox" onclick="setAutoTrace(this.checked)" id="1.toggleExplainPlan"/>
								<span>
									<label for="1.toggleExplainPlan">Explain Plan</label>
								</span>
							</span>
						</span>
						<span style="display:inline-block;width:5px;"/>
						<span style="display:inline-block;" id="1.doTiming">
							<span>
								<input type="checkbox" onclick="setTiming(this.checked)" id="1.toggleTiming"/>
								<span>
									<label for="1.toggleTiming">Timing</label>
								</span>
							</span>
						</span>
						<span style="display:inline-block;width:5px;"/>
						<span style="display:none;" id="1.timing"/>
						<span style="display:inline-block;width:5px;"/>
					</div>
				</div>
				<div style="display:block;vertical-align:top;margin:0px;padding:0px;border-width:0px;" id="1.statement"/>
				<div style="display:none;vertical-align:top;margin:0px;padding:0px;border-width:0px;" id="1.result"/>
				<div style="display:none;vertical-align:top;margin:0px;padding:0px;border-width:0px;" id="1.explainPlan"/>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="shellActions">
		<xsl:choose>
			<xsl:when test="simulation[@type='Folder']">
				<xsl:value-of select="concat('demoPlayer.showFolderContent(&quot;',position(),'.Screenshot','&quot;,&quot;',position(),'.Folder','&quot;,&quot;',simulation/@URL,'&quot;);return false;')"/>
			</xsl:when>
			<xsl:when test="simulation[@type='Document']">
				<xsl:text>return true;</xsl:text>
			</xsl:when>
			<xsl:when test="simulation[@type='SQLLDR']">
				 <xsl:value-of select="concat('demoPlayer.simulateStep(',position(),',&quot;',simulation/@SQL,'&quot;);return false;')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>window.open('</xsl:text>
				<xsl:value-of select="simulation/@lnkPath"/>
				<xsl:text>','_lnk','width=30,height=30,resizable=no,scrollbars=no,toolbar=no,location=no,directories=no,status=no,menubar=no,copyhistory=no');</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="processConfigurationFile">
		<xsl:for-each select="r:Contents/Configuration/Step">
			<xsl:sort select="name"/>
			<div style="margin:0px; display:none;">
				<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.Step')"/></xsl:attribute>
				<input type="hidden">
					<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.description')"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="name"></xsl:value-of></xsl:attribute>
				</input>
				<input type="hidden">
					<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.targetUser')"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="username"></xsl:value-of></xsl:attribute>
				</input>
				<xsl:choose>
					<xsl:when test="stepType='SQL'">
						<input type="hidden">
							<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.action')"/></xsl:attribute>
							<xsl:attribute name="value"><xsl:text>SQL</xsl:text></xsl:attribute>
						</input>
						<input type="hidden">
							<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.sqlScript')"/></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="link"/></xsl:attribute>
						</input>
					</xsl:when>
					<xsl:when test="stepType='HTTP'">
						<input type="hidden">
							<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.action')"/></xsl:attribute>
							<xsl:attribute name="value"><xsl:text>HTTP</xsl:text></xsl:attribute>
						</input>
						<input type="hidden">
							<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.link')"/></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="link"/></xsl:attribute>
						</input>
						<input type="hidden">
							<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.WindowName')"/></xsl:attribute>
							<xsl:choose>
								<xsl:when test="link[@windowName]">
									<xsl:attribute name="value"><xsl:value-of select="link/@windowName"/></xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="value"><xsl:value-of select="concat(position(),'.iFrame')"/></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</input>
					</xsl:when>
					<xsl:when test="stepType='VIEW'">
						<input type="hidden">
							<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.action')"/></xsl:attribute>
							<xsl:attribute name="value"><xsl:text>VIEW</xsl:text></xsl:attribute>
						</input>
						<input type="hidden">
							<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.contentType')"/></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="link/@contentType"/></xsl:attribute>
						</input>
					</xsl:when>
					<xsl:when test="stepType='SHELL'">
						<input type="hidden">
							<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.action')"/></xsl:attribute>
							<xsl:attribute name="value"><xsl:text>SHELL</xsl:text></xsl:attribute>
						</input>
						<input type="hidden">
							<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.shortCut')"/></xsl:attribute>
							<xsl:attribute name="value"><xsl:value-of select="link"></xsl:value-of></xsl:attribute>
						</input>
					</xsl:when>
				</xsl:choose>
				<div style="width:80px; vertical-align:top; text-align:center; float:left;">
					<div style="display:inline-block;height:5px;"/>
					<!--- Next, Reload and Prev Icons -->
					<div style="white-space:nowrap;">
						<span style="width:8px; display:inline-block;"/>
						<img alt="previousStep" height="16" width="16">
							<xsl:choose>
								<xsl:when test="position() = 1">
									<xsl:attribute name="src"><xsl:text>/XFILES/lib/icons/prevDisabled.png</xsl:text></xsl:attribute>
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="onclick"><xsl:value-of select="concat('demoPlayer.showPreviousStep(',position(),');return false;')"/></xsl:attribute>
									<xsl:attribute name="src"><xsl:text>/XFILES/lib/icons/prevEnabled.png</xsl:text></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</img>
						<span style="width:8px; display:inline-block;"/>
						<xsl:choose>
							<xsl:when test="link[@rerunnable='true']">
								<img height="16" width="16">
									<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.isRerunnable')"/></xsl:attribute>
									<xsl:attribute name="alt"><xsl:text>re-runnable</xsl:text></xsl:attribute>
									<xsl:attribute name="src"><xsl:text>/XFILES/lib/icons/reloadScript.png</xsl:text></xsl:attribute>
									<xsl:attribute name="onclick"><xsl:value-of select="concat('demoPlayer.resetStep(',position(),');return false;')"/></xsl:attribute>
								</img>
							</xsl:when>
							<xsl:otherwise>
								<span style="width:16px; display:inline-block;"/>
							</xsl:otherwise>
						</xsl:choose>
						<span style="width:8px; display:inline-block;"/>
						<img alt="nextStep" height="16" width="16">
							<xsl:choose>
								<xsl:when test="position() = last()">
									<xsl:attribute name="src"><xsl:text>/XFILES/lib/icons/nextDisabled.png</xsl:text></xsl:attribute>
									<xsl:attribute name="disabled">disabled</xsl:attribute>
								</xsl:when>
								<xsl:otherwise>
									<xsl:attribute name="onclick"><xsl:value-of select="concat('demoPlayer.showNextStep(',position(),');return false;')"/></xsl:attribute>
									<xsl:attribute name="src"><xsl:text>/XFILES/lib/icons/nextEnabled.png</xsl:text></xsl:attribute>
								</xsl:otherwise>
							</xsl:choose>
						</img>
						<span style="width:8px; display:inline-block;"/>
					</div>
					<div style="display:inline-block;height:5px;"/>
					<!-- Launch Icon -->
					<div>
						<a>
							<xsl:attribute name="href">
								<xsl:choose>
									<xsl:when test="simulation/@URL">
										<xsl:value-of select="simulation/@URL"/>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>#</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>
							<xsl:choose>
								<xsl:when test="stepType='SHELL'">
									<xsl:attribute name="onclick"><xsl:call-template name="shellActions"/></xsl:attribute>
								</xsl:when>
							</xsl:choose>
							<img style="border:none;" width="32" height="32">
								<xsl:attribute name="src"><xsl:text>/XFILES/lib/icons/</xsl:text><xsl:value-of select="icon"></xsl:value-of></xsl:attribute>
								<xsl:attribute name="alt"><xsl:value-of select="stepType"></xsl:value-of></xsl:attribute>
							</img>
						</a>
					</div>
					<div>
						<xsl:choose>
							<xsl:when test="stepType='SHELL'">
								<div>
									<a>
										<xsl:attribute name="href">
											<xsl:choose>
												<xsl:when test="simulation/@URL">
													<xsl:value-of select="simulation/@URL"/>
												</xsl:when>
												<xsl:otherwise>
													<xsl:text>#</xsl:text>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:attribute>
										<xsl:choose>
											<xsl:when test="stepType='SHELL'">
												<xsl:attribute name="onclick"><xsl:call-template name="shellActions"/></xsl:attribute>
											</xsl:when>
										</xsl:choose>
										<xsl:value-of select="name"/>
									</a>
								</div>
								<xsl:if test="simulation/@SQL">
									<img style="padding:10px" src="/XFILES/lib/icons/simulationStart.png" height="16" width="16" alt="Simulate Step">
										<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.simulate')"/></xsl:attribute>
									</img>
								</xsl:if>
							</xsl:when>
							<xsl:when test="stepType='HTTP'">
								<a href="#">
									<xsl:attribute name="onclick"><xsl:text>demoPlayer.openLink('</xsl:text><xsl:value-of select="position()"/><xsl:text>');return false</xsl:text></xsl:attribute>
									<xsl:value-of select="name"/>
								</a>
							</xsl:when>
							<xsl:when test="stepType='VIEW'">
								<a>
									<xsl:attribute name="href"><xsl:value-of select="link"></xsl:value-of></xsl:attribute>
									<xsl:attribute name="onclick"><xsl:text>demoPlayer.reloadIFrame('</xsl:text><xsl:value-of select="position()"/><xsl:text>');return false</xsl:text></xsl:attribute>
									<xsl:value-of select="name"/>
								</a>
							</xsl:when>
							<xsl:when test="stepType='SQL'">
								<xsl:value-of select="name"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="name"/>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</div>
				<div style="vertical-align:top; margin-left:90px;margin-right:10px;">
					<div style="display:inline-block;height:5px;"/>
					<div style="display: none;">
						<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.stepDisplay')"/></xsl:attribute>
						<xsl:choose>
							<xsl:when test="stepType='VIEW'">
								<div>
									<input type="text" disabled="true" style="width:100%">
										<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.target')"/></xsl:attribute>
										<xsl:attribute name="value"><xsl:value-of select="link"></xsl:value-of></xsl:attribute>
									</input>
									<iframe style="width:100%; height:100%; background-color:white;" onload="demoPlayer.resizeIFrame(this)">
										<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.iFrame')"/></xsl:attribute>
									</iframe>
								</div>
							</xsl:when>
							<xsl:when test="stepType='HTTP'">
								<xsl:choose>
									<xsl:when test="link[@windowName]">
										<xsl:if test="screenshot">
											<div style="display:table-cell; vertical-align:middle;text-align:center">
												<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.Screenshot')"/></xsl:attribute>
												<img style="border:none;">
													<xsl:attribute name="onclick"><xsl:text>demoPlayer.openLink('</xsl:text><xsl:value-of select="position()"/><xsl:text>');return false</xsl:text></xsl:attribute>
													<xsl:attribute name="src"><xsl:value-of select="screenshot"></xsl:value-of></xsl:attribute>
													<xsl:attribute name="alt"><xsl:value-of select="stepType"></xsl:value-of></xsl:attribute>
												</img>
											</div>
										</xsl:if>
									</xsl:when>
									<xsl:otherwise>
										<div>
											<input type="text" disabled="true" style="width:100%">
												<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.target')"/></xsl:attribute>
												<xsl:attribute name="value"><xsl:value-of select="link"></xsl:value-of></xsl:attribute>
											</input>
											<iframe style="width:100%; height:100%;">
												<xsl:attribute name="name"><xsl:value-of select="concat(position(),'.iFrame')"/></xsl:attribute>
											</iframe>
										</div>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:when>
							<xsl:when test="stepType='SHELL'">
								<div style="display:table-cell; vertical-align:middle;text-align:center">
									<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.Screenshot')"/></xsl:attribute>
									<img style="border:none;">
										<xsl:attribute name="onclick"><xsl:text>window.open('</xsl:text><xsl:value-of select="simulation/@lnkPath"/><xsl:text>','lnk_launcher','width=30,height=30,resizable=no,scrollbars=no,toolbar=no,location=no,directories=no,status=no,menubar=no,copyhistory=no');</xsl:text></xsl:attribute>
										<xsl:attribute name="src"><xsl:value-of select="simulation/@screenshotPath"></xsl:value-of></xsl:attribute>
										<xsl:attribute name="alt"><xsl:value-of select="stepType"></xsl:value-of></xsl:attribute>
									</img>
								</div>
								<div style="width:100%; height:100%; background-color:white; display:none; border:1px;">
									<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.Folder')"/></xsl:attribute>
								</div>
							</xsl:when>
							<xsl:when test="stepType='SQL'">
								<div style="display:block;">
									<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.tabSet')"/></xsl:attribute>
								</div>
								<div class="tabBar barWithIcons" style="display:inline-block;padding-left:0px;width:100%;height:24px;">
									<div style="float:left;vertical-align:middle;padding-left:5px;">
										<span style="display:inline-block">
											<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.actions')"/></xsl:attribute>
										</span>
									</div>
									<div style="float:right;font-size:7pt;font-weight:bold;vertical-align:middle;">
										<span style="display:inline-block;">
											<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.doExplainPlan')"/></xsl:attribute>
											<span>
												<input type="checkbox">
													<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.toggleExplainPlan')"/></xsl:attribute>
													<xsl:attribute name="onclick"><xsl:text>demoPlayer.setAutoTrace(this.checked,</xsl:text><xsl:value-of select="position()"/><xsl:text>)</xsl:text></xsl:attribute>
												</input>
												<span>
													<label>
														<xsl:attribute name="for"><xsl:value-of select="concat(position(),'.toggleExplainPlan')"/></xsl:attribute>Explain Plan</label>
												</span>
											</span>
										</span>
										<span style="display:inline-block;width:5px;"/>
										<span style="display:inline-block;">
											<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.doTiming')"/></xsl:attribute>
											<span>
												<input type="checkbox">
													<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.toggleTiming')"/></xsl:attribute>
													<xsl:attribute name="onclick"><xsl:text>demoPlayer.setTiming(this.checked,</xsl:text><xsl:value-of select="position()"/><xsl:text>)</xsl:text></xsl:attribute>
												</input>
												<span>
													<label>
														<xsl:attribute name="for"><xsl:value-of select="concat(position(),'.toggleTiming')"/></xsl:attribute>Timing</label>
												</span>
											</span>
										</span>
										<span style="display:inline-block;width:5px;"/>
										<span style="display:none;">
											<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.timing')"/></xsl:attribute>
										</span>
										<span style="display:inline-block;width:5px;"/>
									</div>
								</div>
								<div style="display:block;vertical-align:top;margin:0px;padding:0px;border-width:0px;">
									<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.statement')"/></xsl:attribute>
								</div>
								<div style="display:none;vertical-align:top;margin:0px;padding:0px;border-width:0px;">
									<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.result')"/></xsl:attribute>
								</div>
								<div style="display:none;vertical-align:top;margin:0px;padding:0px;border-width:0px;">
									<xsl:attribute name="id"><xsl:value-of select="concat(position(),'.explainPlan')"/></xsl:attribute>
								</div>
							</xsl:when>
						</xsl:choose>
					</div>
				</div>
			</div>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="processFile">
		<xsl:param name="filename"/>
		<xsl:choose>
			<xsl:when test="contains($filename,'.')">
				<xsl:call-template name="processFile">
					<xsl:with-param name="filename" select="substring-after($filename,'.')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="translate($filename,$lowercase,$uppercase) = 'SQL' ">
						<xsl:call-template name="processSQLFile"/>
					</xsl:when>
					<xsl:when test="translate($filename,$lowercase,$uppercase) = 'XML' ">
						<xsl:call-template name="processConfigurationFile"/>
					</xsl:when>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template match="/">
		<div id="localScriptList" style="display:none;"/>
		<div id="localScripts" style="display:none;"/>
		<xsl:call-template name="sqlAuthentication"/>
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'Run Demonstration'"/>
		</xsl:call-template>
		<div style="height:32px; vertical-align:middle;" class="blueGradient">
			<div style="float:left; vertical-align:middle; margin-top:5px;">
				<span class="titleLeft10" id="stepDescription"/>
				<span style="width:10px; display:inline-block;"/>
			</div>
			<div style="float:right; vertical-align:middle; margin-top:5px;">
				<span class="headerText">Username</span>
				<span style="width:10px; display:inline-block;"/>
				<input id="demonstrationUsername" disabled="disabled" name="demonstrationUsername" size="32" type="text" maxlength="32"/>
				<span style="width:10px; display:inline-block;"/>
				<span class="headerText">Passsword</span>
				<span style="width:10px; display:inline-block;"/>
				<input id="demonstrationPassword" disabled="disabled" name="demonstrationPassword" size="32" type="password" maxlength="32"/>
				<span style="width:5px; display:inline-block;"/>
			</div>
			<div style="clear:both;display:inline-block;"/>
		</div>
		<xsl:for-each select="r:Resource">
			<div class="formAreaBackground">
				<xsl:call-template name="processFile">
					<xsl:with-param name="filename" select="r:DisplayName"/>
				</xsl:call-template>
			</div>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
