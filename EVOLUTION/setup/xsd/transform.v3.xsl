<xsl:stylesheet version="1.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" indent="yes"/>
<xsl:template match="@*|node()">
   <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
   </xsl:copy>
</xsl:template>
	<xsl:template match="ShippingInstructions[not(xsi:Type)]">
		<ShippingInstructions>
			<xsl:attribute name="xsi:type">BasicShippingInstructionsType</xsl:attribute>
			<xsl:copy-of select="name"/>
			<shippingAddress>
				<xsl:copy-of select="address/text()"/>
			</shippingAddress>
			<xsl:copy-of select="telephone"/>
			<xsl:copy-of select="billingAddress"/>
		</ShippingInstructions>
	</xsl:template>
</xsl:stylesheet>
