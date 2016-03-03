<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:tns="http://xmlns.oracle.com/orawsv/XFILES/XFILES_XMLSCHEMA_WIZARD/GET_GLOBAL_ELEMENT_LIST">
	<xsl:output version="5.0" encoding="utf-8" omit-xml-declaration="no" indent="no" media-type="text/html" method="html"/>
	<xsl:template match="/">
		<table id="globalElementList" class="table table-condensed table-bordered table-striped table-fixed .table-responsive" summary=""  style="width:970px">
			<thead>
				<tr>
					<th title="Element">Root Element</th>
					<th title="Namespace">Namespace</th>
					<th title="Schema">Repository Path</th>
					<th title="Generate Table">Generate Table</th>
				</tr>
			</thead>
			<tbody>
				<xsl:for-each select="/soap:Envelope/soap:Body/tns:GET_GLOBAL_ELEMENT_LISTOutput/tns:RETURN/tns:GlobalElementList/tns:GlobalElement">
					<tr>
						<td>
							<xsl:value-of select="tns:name"/>
						</td>
						<td>
							<xsl:value-of select="tns:namespace"/>
						</td>
						<td>
							<xsl:value-of select="tns:repositoryPath"/>
						</td>
						<td>
							<input type="checkbox"/>
						</td>
					</tr>
				</xsl:for-each>
			</tbody>
		</table>
	</xsl:template>
</xsl:stylesheet>
