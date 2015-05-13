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

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:SOAP-ENC="http://schemas.xmlsoap.org/soap/encoding/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:wsdl="http://schemas.xmlsoap.org/wsdl/">
	<xsl:output method="xml" indent="yes"/>
	<xsl:variable name="BINDING_QNAME" select="/wsdl:definitions/wsdl:service/wsdl:port/@binding"/>
	<xsl:variable name="BINDING" select="substring-after($BINDING_QNAME,':')"/>
	<xsl:variable name="TYPE_QNAME" select="/wsdl:definitions/wsdl:binding[@name=$BINDING]/@type"/>
	<xsl:variable name="TYPE" select="substring-after($TYPE_QNAME,':')"/>
	<xsl:variable name="PORTTYPE_QNAME" select="/wsdl:definitions/wsdl:portType[@name=$TYPE]/wsdl:operation/wsdl:input/@message"/>
	<xsl:variable name="PORTTYPE" select="substring-after($PORTTYPE_QNAME,':')"/>
	<xsl:variable name="TARGETNAMESPACE" select="/wsdl:definitions/@targetNamespace"/>
	<xsl:variable name="INPUTMESSAGE_QNAME" select="/wsdl:definitions/wsdl:message[@name=$PORTTYPE]/wsdl:part/@element"/>
	<xsl:variable name="INPUTMESSAGE" select="substring-after($INPUTMESSAGE_QNAME,':')"/>
	<xsl:template match="/">
		<xsl:element name="Envelope" namespace="http://schemas.xmlsoap.org/soap/envelope/">
			<xsl:element name="Body" namespace="http://schemas.xmlsoap.org/soap/envelope/">
				<xsl:element name="{$INPUTMESSAGE}" namespace="{$TARGETNAMESPACE}">
					<xsl:choose>
						<xsl:when test="$TARGETNAMESPACE='http://xmlns.oracle.com/orawsv'">
							<!-- Special Processing for the SQL/XQuery Service WSDL -->
							<xsl:for-each select="/wsdl:definitions/wsdl:types/xsd:schema/xsd:element[@name=$INPUTMESSAGE]/xsd:complexType/xsd:sequence/xsd:element[not(@name = 'DDL_text')]">
								<xsl:element name="{@name}" namespace="{$TARGETNAMESPACE}">
									<xsl:if test="@name='query_text'">
										<xsl:attribute name="type"><xsl:text>SQL</xsl:text></xsl:attribute>
									</xsl:if>
									<xsl:for-each select="xsd:complexType/xsd:sequence/xsd:any">
										<xsl:element name="P_XMLTYPE-EMPTY"/>
									</xsl:for-each>
								</xsl:element>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<xsl:for-each select="/wsdl:definitions/wsdl:types/xsd:schema/xsd:element[@name=$INPUTMESSAGE]/xsd:complexType/xsd:sequence/xsd:element">
								<xsl:element name="{@name}" namespace="{$TARGETNAMESPACE}">
									<xsl:for-each select="xsd:complexType/xsd:sequence/xsd:any">
										<xsl:element name="P_XMLTYPE-EMPTY"/>
									</xsl:for-each>
								</xsl:element>
							</xsl:for-each>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:element>
			</xsl:element>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet>
