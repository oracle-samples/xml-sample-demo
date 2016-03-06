<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:n1="http://www.w3.org/2001/XMLSchema" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles" xmlns:xr="http://xmlns.oracle.com/xdb/xfiles">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:include href="/XFILES/lite/xsl/common.xsl"/>
	<xsl:template name="uploadArchive">
		<div class="modal fade" id="uploadArchive" tabindex="-1" role="dialog" aria-labelledby="uploadArchiveTitle" aria-hidden="true">
			<div class="modal-dialog" style="width:300px;">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button class="close"  type="button" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="uploadArchiveTitle">Select Archive</h4>
						</div>
					</div>
					<div class="modal-body">
						<input id="FILE" name="FILE" title="FILE" type="file"/>
					</div>
					<div class="modal-footer">
						<button class="btn btn-default btn-med" id="btnDoUploadFiles" type="button"  onclick="uploadSchemaArchive();">
							<span class="glyphicon glyphicon-save"/>
						</button>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="wizard">
		<div class="modal fade" id="registrationWizard" tabindex="-1" role="dialog" aria-labelledby="registrationWizardTitle" aria-hidden="true">
			<div class="modal-dialog" style="width:1024px;">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="registrationWizardTitle">XML Schema Registration Wizard</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="well well-med">
							<xsl:text>This wizard assists you with registering a complex set of XML schemas.</xsl:text>
						</div>
						<div class="tab-pane" id="Steps">
							<ul class="nav nav-tabs" role="tablist" id="wizardSteps">
								<li>
									<a href="#wizardSelectSchemas" role="tab" data-toggle="tab">Select Schemas</a>
								</li>
								<li>
									<a href="#wizardConfigureSchemas" role="tab" data-toggle="tab">Configure Schemas</a>
								</li>
								<li>
									<a href="#wizardConfigureSchemas" role="tab" data-toggle="tab">Configure Schemas</a>
								</li>
								<li>
									<a href="#wizardScriptOptions" role="tab" data-toggle="tab">Script Options Scripts</a>
								</li>
								<li>
									<a href="#wizardShowScript" role="tab" data-toggle="tab">Review Scripts</a>
								</li>
								<li style="display:none" id="tab_compileTypes">
									<a href="#step_compileTypes" role="tab" data-toggle="tab">Compile Types</a>
								</li>
								<li style="display:none" id="tab_analyzeTypes">
									<a href="#step_analyzeTypes" role="tab" data-toggle="tab">Analyze Types</a>
								</li>
								<li style="display:none" id="tab_locateSchema">
									<a href="#step_locateSchema" role="tab" data-toggle="tab">Locate Schema</a>
								</li>
							</ul>
						</div>
						<br/>
						<!-- Tab panes -->
						<div class="tab-content" style="width:1000px;">
							<div class="tab-pane active" id="wizardSelectSchemas">
								<div class="row">
									<div class="well well-sm" style="width:980px">
										<p>
											<xsl:text>Click a folder to see the avabilable XML Schemas or upload a Zip Archive containing the XML schemas to be processed.</xsl:text>
										</p>
										<div class="pull-right">
											<button class="btn btn-default btn-med" onclick="chooseSchemaArchive()">Upload</button>
										</div>
										<div class="pull-left" style="white-space:nowrap; text-align:center;font-family:Arial,Helvetica,Geneva,sans-serif;font-size:10pt;color:#000000;font-weight:normal;" id="treeLoading">
											<div>
												<img alt="Loading" src="/XFILES/lib/images/AjaxLoading.gif"/>
											</div>
											<div>
												<xsl:text>Loading Folder Tree</xsl:text>
											</div>
										</div>
										<div id="treeContainer" onclick="searchCurrentFolder()">
											<div style="white-space:nowrap; text-align:left;font-family:Arial,Helvetica,Geneva,sans-serif;font-size:10pt;color:#000000;font-weight:normal;" id="treeControl"/>
											<br/>
										</div>
									</div>
								</div>
								<div class="row" id="schemaListContainer">
									<div class="well well-sm collapse in" id="schemaListDiv" style="width:980px">
										<div class="pull-left">
											<p>
												<xsl:text>Choose XML Schema(s)</xsl:text>
											</p>
										</div>
										<div class="pull-right">
											<button class="btn btn-default btn-med" data-target="#elementListDiv,#schemaListDiv" data-toggle="collapse" onclick="listGlobalElements()">Elements</button>
										</div>
										<div>
											<select class="form-control" id="schemaList" size="10" multiple="multiple"/>
										</div>
									</div>
									<div class="well well-sm collapse" id="elementListDiv" style="width:980px">
										<div class="pull-left">
											<p>
												<xsl:text>Choose Global Elements(s)</xsl:text>
												<input type="hidden" id="globalElementListFolder"/>
											</p>
										</div>
										<div class="pull-right">
											<button class="btn btn-default btn-med" data-target="#elementListDiv,#schemaListDiv" data-toggle="collapse">Schemas</button>
										</div>
										<div class="container" id="globalElementList" style="width:980px; height:200px; overflow:auto"/>
									</div>
								</div>
							</div>
							<div class="tab-pane" id="wizardConfigureSchemas">
								<div class="row">
									<div class="well well-sm" style="width:980px">
										<div class="form-group">
											<label for="repositoryFolderPath">Repository Folder </label>
											<input class="form-control" id="repositoryFolderPath" type="text" size="40" disabled="disabled"/>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="well well-sm" style="width:980px">
										<div class="form-group">
											<label for="orderedSchemaList">Schema List (Ordered) </label>
											<select class="form-control" id="orderedSchemaList" size="8" onclick="showSchemaDetails();return false"/>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="well well-sm" style="width:980px">
										<div class="form-group">
											<label for="targetNamespace">Target Namespace </label>
											<input class="form-control" id="targetNamespace" type="text" size="40" disabled="disabled"/>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="well well-sm collapse" id="schemaLocationInfo">
										<label for="schemaLocationPrefix">Schema Location Prefix </label>
										<div class="input-group">
											<input class="form-control" id="schemaLocationPrefix" type="text" size="80" oninput="setSchemaLocationHint()"/>
											<span class="input-group-btn">
												<button class="btn btn-default btn-med" onclick="updateSchemaLocationPrefix()" type="button">
													<span class="glyphicon glyphicon-cog"/>
												</button>
											</span>
										</div>
										<label for="schemaLocationHint">Schema Location Hint </label>
										<input class="form-control" id="schemaLocationHint" type="text" size="80" disabled="disabled"/>
									</div>
								</div>
							</div>
							<div class="tab-pane" id="wizardScriptOptions">
								<div class="row well well-sm">
									<p>
										<xsl:text>Schema Registration Options: Generate and run scripts to register XML Schema</xsl:text>
									</p>
								</div>
								<div class="row">
									<div class="well well-sm" style="width:980px">
										<div class="checkbox">
											<label for="timestampWithTimezone">
												<input type="checkbox" id="timestampWithTimezone" checked="checked"/>Use Timestamp With Time zone</label>
										</div>
										<div class="form-group">
											<span>Storage Model: </span>
											<label class="radio-inline">
												<input name="xmlStorageModel" id="xmlStorageModelCSX" type="radio" value="CSX" checked="checked" onclick="changeStorageModel()"/>Binary XML</label>
											<label class="radio-inline">
												<input name="xmlStorageModel" id="xmlStorageModelOR" type="radio" value="OR" onclick="changeStorageModel()"/>Object Relational</label>
										</div>
										<div class="checkbox" id="domFidelityOption" style="display:none">
											<label for="disableDOMFidelity">
												<input type="checkbox" id="disableDOMFidelity"/>Disable DOM Fidelity</label>
										</div>
										<div class="form-group">
											<span>Repository usage: </span>
											<label class="radio-inline">
												<input name="repositoryUsage" id="repositoryUsageNone" type="radio" value="DBMS_XMLSCHEMA.ENABLE_HIERARCHY_NONE" checked="checked"/>None</label>
											<label class="radio-inline">
												<input name="repositoryUsage" id="repositoryUsageContent" type="radio" value="DBMS_XMLSCHEMA.ENABLE_HIERARCHY_CONTENTS"/>Resource Content</label>
											<label class="radio-inline">
												<input name="repositoryUsage" id="repositoryUsageMetadata" type="radio" value="DBMS_XMLSCHEMA.ENABLE_HIERARCHY_RESMETADATA"/>Resource Metadata</label>
										</div>
										<div class="form-group">
											<span>Schema scope: </span>
											<label class="radio-inline">
												<input name="schemaScope" id="schemaScopeLocal" type="radio" value="LOCAL" checked="checked"/>Local</label>
											<label class="radio-inline">
												<input name="schemaScope" id="schemaScopeGlobal" type="radio" value="GLOBAL"/>Global</label>
										</div>
									</div>
									<div class="well well-sm" style="width:980px">
										<div class="form-group">
											<input type="checkbox-inline" id="deleteSchemas" checked="checked"/>Delete Schemas
											<input type="checkbox-inline" id="createTables" checked="checked"/>Create Tables
											<input type="checkbox-inline" id="loadInstances" checked="checked"/>Load Instances
										</div>
										<div class="form-group">
											<label for="generatedTableList">Tables</label>
											<select class="form-control" id="generatedTableList" size="10" onclick="return false"/>
										</div>
									</div>
								</div>
							</div>
							<div class="tab-pane" id="wizardShowScript">
								<div class="row">
									<div class="well well-sm" style="width:980px">
										<span>
											<pre class="pre-scrollable" id="registrationScript"/>
										</span>
									</div>
								</div>
								<div class="row">
									<div class="btn-grp">
										<button class="btn btn-default btn-med btn-primary" id="runScript" type="button" onclick="executeScript();false">Run Script</button>
									</div>
								</div>
							</div>
							<div class="tab-pane" id="step_locateSchema">
								<div class="row">
									<div class="well well-sm" style="width:980px">
										<p>
											<xsl:text>Locate Missing Schema</xsl:text>
										</p>
									</div>
								</div>
								<div class="row">
									<div class="well well-sm" style="width:980px">
										<label for="missingSchemaLocation">Resolve URL</label>
										<div class="input-group">
											<input class="form-control" id="missingSchemaLocation" type="text" size="80"  disabled="disabled"/>
											<span class="input-group-btn">
												<button class="btn btn-default btn-med" onclick="loadSchemaLocationHint()" type="button">
													<span class="glyphicon glyphicon-cog"/>
												</button>
											</span>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="well well-sm" style="width:980px">
										<label for="localFile">Load local file</label>
										<div class="input-group">
											<input class="form-control"  id="localFile" name="LOCAL_FILE" title="FILE" type="file"/>
											<span class="input-group-btn">
												<button class="btn btn-default btn-med" onclick="viewLocalFile()" type="button">
													<span class="glyphicon glyphicon-cog"/>
												</button>
											</span>
										</div>
									</div>
								</div>
								<div class="row">
									<div class="well well-sm" style="width:980px" id="xmlSchema">
										<div style="height:200px; overflow:auto;white-space:nowrap; text-align:left;font-family:Arial,Helvetica,Geneva,sans-serif;font-size:10pt;color:#000000;font-weight:normal;" id="viewXMLSchema"/>
										<br/>
										<button class="btn btn-default btn-med" onclick="saveXMLSchema()">Save Schema</button>
									</div>
								</div>
							</div>
							<div class="tab-pane" id="step_compileTypes">
								<div class="form-group">
									<label for="unregisteredSchemaList">Unregistered XML Schemas</label>
									<select class="form-control" id="unregisteredSchemaList" size="10" onclick="return false"/>
								</div>
								<div class="form-group">
									<span style="width:30%">
										<label for="currentSchema">Current XML Schema</label>
									</span>
									<input class="form-control" id="currentSchema" type="text" size="80" disabled="disabled"/>
								</div>
								<div class="form-group">
									<label for="registeredSchemaList">Registered XML Schemas</label>
									<select class="form-control" id="registeredSchemaList" size="10" onclick="return false"/>
								</div>
							</div>
							<div class="tab-pane" id="step_analyzeTypes">
								<span>
									<pre class="pre-scrollable" id="typeAnalysisLog"/>
								</span>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<button style="display: none;" id="btnNext" type="button" class="btn btn-default btn-med pull-right" onclick="doNext();false">
							<span class="glyphicon glyphicon-forward"/>
						</button>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="/">
		<div id="localScriptList" style="display:none;">
			<span>/XFILES/Applications/XMLSchemaWizard/js/registrationWizard.js</span>
		</div>
		<div id="localScripts" style="display:none;"/>
		<xsl:call-template name="XFilesHeader">
			<xsl:with-param name="action" select="'XML Schema Registration Wizard'"/>
		</xsl:call-template>
		<xsl:call-template name="XFilesSeperator">
			<xsl:with-param name="height" select="'12px'"/>
		</xsl:call-template>
		<xsl:call-template name="wizard"/>
		<xsl:call-template name="uploadArchive"/>
		<xsl:call-template name="XFilesFooter"/>
	</xsl:template>
</xsl:stylesheet>
