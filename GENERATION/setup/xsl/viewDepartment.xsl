<?xml version="1.0"?>
<?xmlspysamplexml http://localhost:8080/oradb/SCOTT/DEPARTMENT_XML?>
<html xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xsl:version="1.0">
	<!-- This is an example of a single-template stylesheet -->
	<head>
		<link rel="stylesheet" type="text/css" href="coolcolors.css"/>
	</head>
	<body class="page" BGCOLOR="#000000" TEXT="#FFFFCC" LINK="#CCCC00" VLINK="#33FF33">
		<center>
			<P>
				<FONT FACE="Arial, Helvetica, sans-serif">
					<B>
						<FONT COLOR="#FF0033" SIZE="5">DEPARTMENTS</FONT>
					</B>
				</FONT>
			</P>
			<HR/>
			<P/>
			<TABLE BORDER="0" CLASS="title" BGCOLOR="#CCCCCC" BORDERCOLOR="#CCCC00" WIDTH="80%">
				<FONT color="#FF0033">
					<B>
						<tr>
							<td>
								<center>
									<font color="#FF0033">
										<b>DEPARTMENT</b>
									</font>
								</center>
							</td>
							<td>
								<center>
									<font color="#FF0033">
										<b>LOCATION </b>
									</font>
								</center>
							</td>
							<td>
								<center>
									<font color="#FF0033">
										<b> EMPLOYEES</b>
									</font>
								</center>
							</td>
						</tr>
					</B>
				</FONT>
				<xsl:for-each select="/ROWSET/ROW/Department">
					<TR>
						<TD WIDTH="15%" valign="top">
							<FONT COLOR="#000000">
								<B>
									<xsl:value-of select="Name"/>
								</B>
							</FONT>
						</TD>
						<TD WIDTH="25%" valign="top">
							<FONT COLOR="#000000">
								<B>
									<xsl:value-of select="Location/Address"/>
									<br/>
									<xsl:value-of select="Location/City"/>
									<br/>
									<xsl:if test="string(Location/State)">
										<xsl:value-of select="Location/State"/>
										<br/>
									</xsl:if>
									<xsl:if test="string(Location/Zip)">
										<xsl:value-of select="Location/Zip"/>
										<br/>
									</xsl:if> 
									<xsl:if test="string(Location/Country)">
										<xsl:value-of select="Location/Country"/>
										<br/>
									</xsl:if> 
								</B>
							</FONT>
						</TD>
						<xsl:choose>
							<xsl:when test="not(EmployeeList/Employee)">
								<TD COLSPAN="3" valign="top">
									<TABLE BORDER="0" WIDTH="100%" CLASS="bl">
										<TR>
											<TD ALIGN="center" WIDTH="100%">
												<I>
													<B>
														<FONT COLOR="#000000">No Employees</FONT>
													</B>
												</I>
											</TD>
										</TR>
									</TABLE>
								</TD>
							</xsl:when>
							<xsl:otherwise>
								<TD WIDTH="65%" valign="top">
									<TABLE BORDER="0" WIDTH="100%" CLASS="b1" BGCOLOR="#9999FF">
										<xsl:for-each select="EmployeeList/Employee">
											<TR>
												<TD WIDTH="26%" ALIGN="left">
													<xsl:value-of select="concat(FirstName, ' ', LastName)"/>
												</TD>
												<TD WIDTH="40%" ALIGN="left">
													<xsl:value-of select="JobTitle"/>
												</TD>
												<TD WIDTH="14%" ALIGN="right">
													<xsl:value-of select="Salary"/>
												</TD>
												<TD WIDTH="20%" ALIGN="right">
													<xsl:value-of select="StartDate"/>
												</TD>
											</TR>
										</xsl:for-each>
									</TABLE>
								</TD>
							</xsl:otherwise>
						</xsl:choose>
					</TR>
				</xsl:for-each>
			</TABLE>
		</center>
	</body>
</html>
