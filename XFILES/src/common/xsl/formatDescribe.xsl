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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:oraerr="http://xmlns.oracle.com/orawsv/faults" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:x="http://xmlns.oracle.com/orawsv/XFILES/XFILES_WEBDEMO_SERVICES/DESCRIBE">
	<xsl:output method="html"/>
	<xsl:variable name="statementId" select="/soap:Envelope/soap:Body/x:DESCRIBEOutput/x:RETURN/x:ROWSET/@statementId"/>
	<xsl:template name="describeXMLTable">
		<table border="1">
			<tbody>
				<tr>
					<td>
						<table>
							<tbody>
								<tr>
									<td>
										<xsl:text>Table</xsl:text>
									</td>
									<td>
										<xsl:text>:</xsl:text>
									</td>
									<td>
										<xsl:value-of select="x:SCHEMA_OBJ/NAME"/>
									</td>
									<td>of XMLType</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table>
							<tbody>
								<xsl:for-each select="x:COL_LIST/x:COL_LIST_ITEM[x:NAME='SYS_NC_ROWINFO$' and x:TYPEMD/x:SCHEMA_OBJ[x:OWNER_NAME='SYS' and x:NAME='XMLTYPE']]/x:OPQMD/x:SCHEMA_ELMT">
									<tr>
										<td>
											<xsl:text>XML Schema</xsl:text>
										</td>
										<td>
											<xsl:text>:</xsl:text>
										</td>
										<td>
											<xsl:value-of select="x:XMLSCHEMA"/>
										</td>
										<td/>
										<td/>
									</tr>
									<tr>
										<td>
											<xsl:text>Element</xsl:text>
										</td>
										<td>
											<xsl:text>:</xsl:text>
										</td>
										<td>
											<xsl:value-of select="x:ELEMENT_NAME"/>
										</td>
										<td/>
										<td/>
									</tr>
								</xsl:for-each>
								<xsl:for-each select="x:COL_LIST/x:COL_LIST_ITEM[x:NAME='XMLDATA']/x:TYPEMD/x:SUBTYPE_LIST/x:SUBTYPE_LIST_ITEM/x:SCHEMA_OBJ">
									<tr>
										<td>
											<xsl:text>Storage</xsl:text>
										</td>
										<td>
											<xsl:text>:</xsl:text>
										</td>
										<td>
											<xsl:text>Object-Relational</xsl:text>
										</td>
										<td>
											<xsl:text>Type</xsl:text>
										</td>
										<td>
											<xsl:text>:</xsl:text>
										</td>
										<td>
											<xsl:value-of select="x:NAME"/>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="describeType">
		<table border="1">
			<tbody>
				<tr>
					<td>
						<table>
							<tbody>
								<tr>
									<td>
										<table witdth="100%">
											<tbody>
												<tr>
													<td align="left">
														<xsl:text>Type</xsl:text>
													</td>
													<td align="left">
														<xsl:text>:</xsl:text>
													</td>
													<td align="left">
														<xsl:value-of select="x:TYPE_T/x:SCHEMA_OBJ/x:NAME"/>
													</td>
													<td width="100%"/>
												</tr>
											</tbody>
										</table>
									</td>
								</tr>
								<xsl:for-each select="x:TYPE_T/x:ROWSET/x:ROW[x:COLL_TYPE]">
									<tr>
										<td>
											<table witdth="100%">
												<tbody>
													<tr>
														<td>
															<xsl:text>VARRRY</xsl:text>
														</td>
														<td>
															<xsl:text>(</xsl:text>
															<xsl:value-of select="x:UPPER_BOUND"/>
															<xsl:text>)</xsl:text>
														</td>
														<td>
															<xsl:text> of </xsl:text>
														</td>
														<td>
															<xsl:value-of select="x:ELEM_TYPE_NAME"/>
														</td>
													</tr>
												</tbody>
											</table>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</td>
					<td>
						<table>
							<tbody>
								<tr>
									<td>XML Schema definition</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table cellpadding="1" cellspacing="1" border="1">
							<tbody>
								<tr>
									<th>Attribute</th>
									<th>Type</th>
									<th>Inherited</th>
								</tr>
								<!--							<xsl:sort data-type="number" select="x:TYPE_T/x:ROWSET/x:ROW/ATTR_NUMBER"/> -->
								<xsl:for-each select="x:TYPE_T/x:ROWSET/x:ROW">
									<tr>
										<td>
											<xsl:value-of select="x:ATTR_NAME"/>
										</td>
										<td align="LEFT">
											<xsl:value-of select="x:ATTR_TYPE_NAME"/>
											<xsl:if test="x:LENGTH">
												<xsl:text>(</xsl:text>
												<xsl:value-of select="x:LENGTH"/>
												<xsl:if test="x:CHARACTER_SET_NAME[.='CHAR_CS']">
													<xsl:text> CHAR</xsl:text>
												</xsl:if>
												<xsl:text>)</xsl:text>
											</xsl:if>
											<xsl:if test="x:PRECISION">
												<xsl:text>(</xsl:text>
												<xsl:value-of select="x:PRECISION"/>
												<xsl:if test="x:SCALE">
													<xsl:text>,</xsl:text>
													<xsl:value-of select="x:SCALE"/>
												</xsl:if>
												<xsl:text>)</xsl:text>
											</xsl:if>
										</td>
										<td align="RIGHT">
											<xsl:if test="x:INHERITED[.='YES']">
												<xsl:value-of select="x:INHERITED"/>
											</xsl:if>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</td>
					<td>
						<xsl:for-each select="x:TYPE_T/x:SCHEMA_DEFINITION">
							<div>
								<xsl:attribute name="id"><xsl:text>xmlValue.</xsl:text><xsl:value-of select="$statementId"/></xsl:attribute>
							</div>
						</xsl:for-each>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="describeView">
		<table border="1">
			<tbody>
				<tr>
					<td>
						<table>
							<tbody>
								<tr>
									<td>
										<xsl:text>View</xsl:text>
									</td>
									<td>
										<xsl:text>:</xsl:text>
									</td>
									<td>
										<xsl:value-of select="x:SCHEMA_OBJ/x:NAME"/>
									</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table cellpadding="1" cellspacing="1" border="1">
							<tbody>
								<tr>
									<th>Column</th>
									<th>Type</th>
								</tr>
								<!--							
                                      				<xsl:sort data-type="number" select="x:ROWSET/x:ROW/ATTR_NUMBER"/>
                                				-->
								<xsl:for-each select="x:ROWSET/x:ROW">
									<tr>
										<td>
											<xsl:value-of select="x:COLUMN_NAME"/>
										</td>
										<td align="LEFT">
											<xsl:value-of select="x:DATA_TYPE"/>
											<xsl:if test="not(x:CHAR_LENGTH='0')">
												<xsl:text>(</xsl:text>
												<xsl:value-of select="x:CHAR_LENGTH"/>
												<xsl:if test="x:CHARACTER_SET_NAME[.='CHAR_CS']">
													<xsl:text> CHAR</xsl:text>
												</xsl:if>
												<xsl:text>)</xsl:text>
											</xsl:if>
											<xsl:if test="x:DATA_PRECISION">
												<xsl:text>(</xsl:text>
												<xsl:value-of select="x:DATA_PRECISION"/>
												<xsl:if test="x:DATA_SCALE">
													<xsl:text>,</xsl:text>
													<xsl:value-of select="x:DATA_SCALE"/>
												</xsl:if>
												<xsl:text>)</xsl:text>
											</xsl:if>
										</td>
									</tr>
								</xsl:for-each>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="describeRelationalTable">
		<table border="1">
			<tbody>
				<tr>
					<td>
						<table>
							<tbody>
								<tr>
									<td>
										<xsl:text>Table</xsl:text>
									</td>
									<td>
										<xsl:text>:</xsl:text>
									</td>
									<td>
										<xsl:value-of select="x:SCHEMA_OBJ/x:NAME"/>
									</td>
								</tr>
							</tbody>
						</table>
					</td>
				</tr>
				<tr>
					<td>
						<table cellpadding="1" cellspacing="1" border="1">
							<tbody>
								<tr>
									<th>Column</th>
									<th>Type</th>
								</tr>
								<xsl:for-each select="x:COL_LIST/x:COL_LIST_ITEM">
									<!--
										<xsl:if test="((position() = 1) or (x:COL_NUM != COL_LIST_ITEM[position()-1]/x:COL_NUM))">
										-->
									<tr>
										<td>
											<xsl:value-of select="x:NAME"/>
										</td>
										<td align="LEFT">
											<xsl:choose>
												<xsl:when test="x:TYPEMD/x:SCHEMA_OBJ[x:NAME='XMLTYPE']">
													<xsl:value-of select="x:TYPEMD/x:SCHEMA_OBJ/x:NAME"/>
												</xsl:when>
												<xsl:when test="x:TYPE_NUM=1">
													<xsl:text>VARCHAR2</xsl:text>
													<xsl:text>(</xsl:text>
													<xsl:value-of select="x:LENGTH"/>
													<xsl:if test="x:CHARACTER_SET_NAME[.='CHAR_CS']">
														<xsl:text> CHAR</xsl:text>
													</xsl:if>
													<xsl:text>)</xsl:text>
												</xsl:when>
												<xsl:when test="x:TYPE_NUM=180">
													<xsl:text>TIMESTAMP</xsl:text>
													<xsl:text>(</xsl:text>
													<xsl:value-of select="x:SCALE"/>
													<xsl:if test="x:CHARACTER_SET_NAME[.='CHAR_CS']">
														<xsl:text> CHAR</xsl:text>
													</xsl:if>
													<xsl:text>)</xsl:text>
												</xsl:when>
												<xsl:when test="x:TYPE_NUM=112">
													<xsl:text>CLOB</xsl:text>
												</xsl:when>
												<xsl:when test="x:TYPE_NUM=113">
													<xsl:text>BLOB</xsl:text>
												</xsl:when>
												<xsl:otherwise>
													<xsl:if test="x:LENGTH">
														<xsl:text>(</xsl:text>
														<xsl:value-of select="x:LENGTH"/>
														<xsl:if test="x:CHARACTER_SET_NAME[.='CHAR_CS']">
															<xsl:text> CHAR</xsl:text>
														</xsl:if>
														<xsl:text>)</xsl:text>
													</xsl:if>
													<xsl:if test="x:PRECISION">
														<xsl:text>(</xsl:text>
														<xsl:value-of select="x:PRECISION"/>
														<xsl:if test="x:SCALE">
															<xsl:text>,</xsl:text>
															<xsl:value-of select="x:SCALE"/>
														</xsl:if>
														<xsl:text>)</xsl:text>
													</xsl:if>
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
									<!--
									</xsl:if>
									-->
								</xsl:for-each>
							</tbody>
						</table>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template match="/">
		<xsl:for-each select="/soap:Envelope/soap:Body/x:DESCRIBEOutput/x:RETURN">
			<xsl:for-each select="x:ROWSET/x:ROW/x:TABLE_T[x:COLS='1' and x:COL_LIST/x:COL_LIST_ITEM[x:NAME='SYS_NC_ROWINFO$' and x:TYPEMD/x:SCHEMA_OBJ[x:OWNER_NAME='SYS' and x:NAME='XMLTYPE']]]">
				<xsl:call-template name="describeXMLTable"/>
			</xsl:for-each>
			<xsl:for-each select="x:ROWSET/x:ROW/x:VIEW_T">
				<xsl:call-template name="describeView"/>
			</xsl:for-each>
			<xsl:for-each select="x:ROWSET/x:ROW/x:TABLE_T">
				<xsl:call-template name="describeRelationalTable"/>
			</xsl:for-each>
			<xsl:for-each select="x:ROWSET/x:ROW/x:FULL_TYPE_T">
				<xsl:call-template name="describeType"/>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>
