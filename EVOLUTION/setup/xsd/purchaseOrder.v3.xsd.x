<!-- edited with XMLSpy v2010 rel. 2 (x64) (http://www.altova.com) by Mark D Drake (Oracle XML DB) -->
<!-- edited with XMLSPY v2004 rel. 2 U (http://www.xmlspy.com) by Mark D. Drake (Oracle XML DB) -->
<!-- edited with XML Spy v4.0 U (http://www.xmlspy.com) by Mark (Drake) -->
<xs:schema xmlns:xs="http://www.w3.org/2001/XMLSchema" version="1.0">
	<xs:element name="PurchaseOrder" type="PurchaseOrderType"/>
	<xs:complexType name="PurchaseOrderType">
		<xs:sequence>
			<xs:element name="Reference" type="ReferenceType"/>
			<xs:element name="Actions" type="ActionsType"/>
			<xs:element name="Rejection" type="RejectionType" minOccurs="0"/>
			<xs:element name="Requestor" type="RequestorType"/>
			<xs:element name="User" type="UserType"/>
			<xs:element name="CostCenter" type="CostCenterType"/>
			<xs:element name="ShippingInstructions" type="AbstractShippingInstructionsType"/>
			<xs:element name="SpecialInstructions" type="SpecialInstructionsType"/>
			<xs:element name="LineItems" type="LineItemsType"/>
			<xs:element name="Notes" type="xs:string" minOccurs="0"/>
		</xs:sequence>
		<xs:attribute name="DateCreated" type="xs:dateTime" use="optional"/>
		<xs:attribute name="DateFulfilled" type="xs:dateTime" use="optional"/>
	</xs:complexType>
	<xs:complexType name="LineItemsType">
		<xs:sequence>
			<xs:element name="LineItem" type="LineItemType" maxOccurs="unbounded"/>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="LineItemType">
		<xs:sequence>
			<xs:element name="Part" type="PartType"/>
			<xs:element name="Quantity" type="quantityType"/>
		</xs:sequence>
		<xs:attribute name="ItemNumber" type="xs:integer"/>
	</xs:complexType>
	<xs:complexType name="PartType">
		<xs:simpleContent>
			<xs:extension base="UPCCodeType">
				<xs:attribute name="Description" type="DescriptionType" use="required"/>
				<xs:attribute name="UnitPrice" type="moneyType" use="required"/>
			</xs:extension>
		</xs:simpleContent>
	</xs:complexType>
	<xs:simpleType name="ReferenceType">
		<xs:restriction base="xs:string">
			<xs:minLength value="18"/>
			<xs:maxLength value="30"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:complexType name="ActionsType">
		<xs:sequence>
			<xs:element name="Action" maxOccurs="4">
				<xs:complexType>
					<xs:sequence>
						<xs:element name="User" type="UserType"/>
						<xs:element name="Date" type="DateType" minOccurs="0"/>
					</xs:sequence>
				</xs:complexType>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
	<xs:complexType name="RejectionType">
		<xs:all>
			<xs:element name="User" type="UserType" minOccurs="0"/>
			<xs:element name="Date" type="DateType" minOccurs="0"/>
			<xs:element name="Comments" type="CommentsType" minOccurs="0"/>
		</xs:all>
	</xs:complexType>
	<xs:complexType name="AbstractShippingInstructionsType"/>
	<xs:complexType name="BasicShippingInstructionsType">
		<xs:complexContent>
			<xs:extension base="AbstractShippingInstructionsType">
				<xs:sequence>
					<xs:element name="name" type="NameType" minOccurs="0"/>
					<xs:element name="shippingAddress" type="UnstructuredAddressType" minOccurs="0"/>
					<xs:element name="telephone" type="TelephoneType" minOccurs="0"/>
					<xs:element name="billingAddress" type="StructuredAddressType" minOccurs="0"/>
				</xs:sequence>
			</xs:extension>
		</xs:complexContent>
	</xs:complexType>
	<xs:complexType name="AdvancedShippingInstructionsType">
		<xs:complexContent>
			<xs:extension base="AbstractShippingInstructionsType">
				<xs:sequence>
					<xs:element name="name" type="NameType" minOccurs="0"/>
					<xs:element name="shippingAddress" type="StructuredAddressType" minOccurs="0"/>
					<xs:element name="telephone" type="TelephoneType" minOccurs="0"/>
					<xs:element name="billingAddress" type="StructuredAddressType" minOccurs="0"/>
				</xs:sequence>
			</xs:extension>
		</xs:complexContent>
	</xs:complexType>
	<xs:simpleType name="moneyType">
		<xs:restriction base="xs:decimal">
			<xs:fractionDigits value="2"/>
			<xs:totalDigits value="12"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="quantityType">
		<xs:restriction base="xs:decimal">
			<xs:fractionDigits value="4"/>
			<xs:totalDigits value="8"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="UserType">
		<xs:restriction base="xs:string">
			<xs:minLength value="1"/>
			<xs:maxLength value="10"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="RequestorType">
		<xs:restriction base="xs:string">
			<xs:minLength value="0"/>
			<xs:maxLength value="128"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="CostCenterType">
		<xs:restriction base="xs:string">
			<xs:minLength value="1"/>
			<xs:maxLength value="4"/>
			<xs:enumeration value=""/>
			<xs:enumeration value="A0"/>
			<xs:enumeration value="A10"/>
			<xs:enumeration value="A20"/>
			<xs:enumeration value="A30"/>
			<xs:enumeration value="A40"/>
			<xs:enumeration value="A50"/>
			<xs:enumeration value="A60"/>
			<xs:enumeration value="A70"/>
			<xs:enumeration value="A80"/>
			<xs:enumeration value="A90"/>
			<xs:enumeration value="A100"/>
			<xs:enumeration value="A110"/>
			<xs:enumeration value="B0"/>
			<xs:enumeration value="B10"/>
			<xs:enumeration value="B20"/>
			<xs:enumeration value="B30"/>
			<xs:enumeration value="B40"/>
			<xs:enumeration value="B50"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="SpecialInstructionsType">
		<xs:restriction base="xs:string">
			<xs:minLength value="0"/>
			<xs:maxLength value="4000"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="NameType">
		<xs:restriction base="xs:string">
			<xs:minLength value="1"/>
			<xs:maxLength value="20"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="UnstructuredAddressType">
		<xs:restriction base="xs:string">
			<xs:minLength value="0"/>
			<xs:maxLength value="256"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="TelephoneType">
		<xs:restriction base="xs:string">
			<xs:minLength value="1"/>
			<xs:maxLength value="24"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="DateType">
		<xs:restriction base="xs:date"/>
	</xs:simpleType>
	<xs:simpleType name="CommentsType">
		<xs:restriction base="xs:string">
			<xs:minLength value="1"/>
			<xs:maxLength value="4000"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="DescriptionType">
		<xs:restriction base="xs:string">
			<xs:minLength value="1"/>
			<xs:maxLength value="256"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:simpleType name="UPCCodeType">
		<xs:restriction base="xs:string">
			<xs:minLength value="11"/>
			<xs:maxLength value="14"/>
			<xs:pattern value="\d{11}"/>
			<xs:pattern value="\d{12}"/>
			<xs:pattern value="\d{13}"/>
			<xs:pattern value="\d{14}"/>
		</xs:restriction>
	</xs:simpleType>
	<xs:complexType name="StructuredAddressType">
		<xs:sequence>
			<xs:element name="StreetLine1">
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:minLength value="1"/>
						<xs:maxLength value="128"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="StreetLine2" minOccurs="0">
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:minLength value="1"/>
						<xs:maxLength value="128"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:element name="City">
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:minLength value="1"/>
						<xs:maxLength value="64"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
			<xs:choice>
				<xs:sequence>
					<xs:element name="State">
						<xs:simpleType>
							<xs:restriction base="xs:string">
								<xs:minLength value="2"/>
								<xs:maxLength value="2"/>
								<xs:enumeration value="AK"/>
								<xs:enumeration value="AL"/>
								<xs:enumeration value="AR"/>
								<xs:enumeration value="AS"/>
								<xs:enumeration value="AZ"/>
								<xs:enumeration value="CA"/>
								<xs:enumeration value="CO"/>
								<xs:enumeration value="CT"/>
								<xs:enumeration value="DC"/>
								<xs:enumeration value="DE"/>
								<xs:enumeration value="FL"/>
								<xs:enumeration value="FM"/>
								<xs:enumeration value="GA"/>
								<xs:enumeration value="GU"/>
								<xs:enumeration value="HI"/>
								<xs:enumeration value="IA"/>
								<xs:enumeration value="ID"/>
								<xs:enumeration value="IL"/>
								<xs:enumeration value="IN"/>
								<xs:enumeration value="KS"/>
								<xs:enumeration value="KY"/>
								<xs:enumeration value="LA"/>
								<xs:enumeration value="MA"/>
								<xs:enumeration value="MD"/>
								<xs:enumeration value="ME"/>
								<xs:enumeration value="MH"/>
								<xs:enumeration value="MI"/>
								<xs:enumeration value="MN"/>
								<xs:enumeration value="MO"/>
								<xs:enumeration value="MP"/>
								<xs:enumeration value="MQ"/>
								<xs:enumeration value="MS"/>
								<xs:enumeration value="MT"/>
								<xs:enumeration value="NC"/>
								<xs:enumeration value="ND"/>
								<xs:enumeration value="NE"/>
								<xs:enumeration value="NH"/>
								<xs:enumeration value="NJ"/>
								<xs:enumeration value="NM"/>
								<xs:enumeration value="NV"/>
								<xs:enumeration value="NY"/>
								<xs:enumeration value="OH"/>
								<xs:enumeration value="OK"/>
								<xs:enumeration value="OR"/>
								<xs:enumeration value="PA"/>
								<xs:enumeration value="PR"/>
								<xs:enumeration value="PW"/>
								<xs:enumeration value="RI"/>
								<xs:enumeration value="SC"/>
								<xs:enumeration value="SD"/>
								<xs:enumeration value="TN"/>
								<xs:enumeration value="TX"/>
								<xs:enumeration value="UM"/>
								<xs:enumeration value="UT"/>
								<xs:enumeration value="VA"/>
								<xs:enumeration value="VI"/>
								<xs:enumeration value="VT"/>
								<xs:enumeration value="WA"/>
								<xs:enumeration value="WI"/>
								<xs:enumeration value="WV"/>
								<xs:enumeration value="WY"/>
							</xs:restriction>
						</xs:simpleType>
					</xs:element>
					<xs:element name="ZipCode">
						<xs:simpleType>
							<xs:restriction base="xs:string">
								<xs:pattern value="\d{5}"/>
								<xs:pattern value="\d{5}-\d{4}"/>
							</xs:restriction>
						</xs:simpleType>
					</xs:element>
				</xs:sequence>
				<xs:sequence>
					<xs:element name="Province">
						<xs:simpleType>
							<xs:restriction base="xs:string">
								<xs:minLength value="2"/>
								<xs:maxLength value="2"/>
							</xs:restriction>
						</xs:simpleType>
					</xs:element>
					<xs:element name="PostalCode">
						<xs:simpleType>
							<xs:restriction base="xs:string">
								<xs:minLength value="1"/>
								<xs:maxLength value="12"/>
							</xs:restriction>
						</xs:simpleType>
					</xs:element>
				</xs:sequence>
				<xs:sequence>
					<xs:element name="County">
						<xs:simpleType>
							<xs:restriction base="xs:string">
								<xs:minLength value="1"/>
								<xs:maxLength value="32"/>
							</xs:restriction>
						</xs:simpleType>
					</xs:element>
					<xs:element name="PostCode">
						<xs:simpleType>
							<xs:restriction base="xs:string">
								<xs:minLength value="1"/>
								<xs:maxLength value="12"/>
							</xs:restriction>
						</xs:simpleType>
					</xs:element>
				</xs:sequence>
			</xs:choice>
			<xs:element name="Country">
				<xs:simpleType>
					<xs:restriction base="xs:string">
						<xs:minLength value="1"/>
						<xs:maxLength value="64"/>
					</xs:restriction>
				</xs:simpleType>
			</xs:element>
		</xs:sequence>
	</xs:complexType>
</xs:schema>
