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
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:r="http://xmlns.oracle.com/xdb/XDBResource.xsd" xmlns:xfiles="http://xmlns.oracle.com/xdb/xfiles">
	<xsl:variable name="XFilesMappings" select="document('/XFILES/lite/xsl/XFilesMappings.xml')"/>
	<xsl:variable name="XFilesIconMappings" select="document('/XFILES/lite/xsl/XFilesIconMappings.xml')"/>
	<xsl:template name="formatDate">
		<xsl:param name="date"/>
		<!-- Day -->
		<xsl:value-of select="substring($date, 9, 2)"/>
		<xsl:text> </xsl:text>
		<!-- Month -->
		<xsl:variable name="month" select="number(substring($date, 6, 2))"/>
		<xsl:choose>
			<xsl:when test="$month=1">Jan</xsl:when>
			<xsl:when test="$month=2">Feb</xsl:when>
			<xsl:when test="$month=3">Mar</xsl:when>
			<xsl:when test="$month=4">Apr</xsl:when>
			<xsl:when test="$month=5">May</xsl:when>
			<xsl:when test="$month=6">Jun</xsl:when>
			<xsl:when test="$month=7">Jul</xsl:when>
			<xsl:when test="$month=8">Aug</xsl:when>
			<xsl:when test="$month=9">Sep</xsl:when>
			<xsl:when test="$month=10">Oct</xsl:when>
			<xsl:when test="$month=11">Nov</xsl:when>
			<xsl:when test="$month=12">Dec</xsl:when>
			<xsl:otherwise>INV</xsl:otherwise>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<!-- Year -->
		<xsl:value-of select="substring($date, 1, 4)"/>
		<xsl:text> </xsl:text>
		<xsl:value-of select="substring($date, 12, 5)"/>
	</xsl:template>
	<xsl:template name="isoCountryCodes">
		<option value="AF" id="AF">AFGHANISTAN</option>
		<option value="AX" id="AX">ÅLAND ISLANDS</option>
		<option value="AL" id="AL">ALBANIA</option>
		<option value="DZ" id="DZ">ALGERIA</option>
		<option value="AS" id="AS">AMERICAN SAMOA</option>
		<option value="AD" id="AD">ANDORRA</option>
		<option value="AO" id="AO">ANGOLA</option>
		<option value="AI" id="AI">ANGUILLA</option>
		<option value="AQ" id="AQ">ANTARCTICA</option>
		<option value="AG" id="AG">ANTIGUA AND BARBUDA</option>
		<option value="AR" id="AR">ARGENTINA</option>
		<option value="AM" id="AM">ARMENIA</option>
		<option value="AW" id="AW">ARUBA</option>
		<option value="AR" id="AR">AUSTRALIA  AU</option>
		<option value="AT" id="AT">AUSTRIA</option>
		<option value="AZ" id="AZ">AZERBAIJAN</option>
		<option value="BS" id="BS">BAHAMAS</option>
		<option value="BH" id="BH">BAHRAIN</option>
		<option value="BD" id="BD">BANGLADESH</option>
		<option value="BB" id="BB">BARBADOS</option>
		<option value="BY" id="BY">BELARUS</option>
		<option value="BE" id="BE">BELGIUM</option>
		<option value="BZ" id="BZ">BELIZE</option>
		<option value="BJ" id="BJ">BENIN</option>
		<option value="BM" id="BM">BERMUDA</option>
		<option value="BT" id="BT">BHUTAN</option>
		<option value="BO" id="BO">BOLIVIA, PLURINATIONAL STATE OF</option>
		<option value="BA" id="BA">BOSNIA AND HERZEGOVINA</option>
		<option value="BW" id="BW">BOTSWANA</option>
		<option value="BV" id="BV">BOUVET ISLAND</option>
		<option value="BR" id="BR">BRAZIL</option>
		<option value="IO" id="IO">BRITISH INDIAN OCEAN TERRITORY</option>
		<option value="BN" id="BN">BRUNEI RUSSALAM</option>
		<option value="DA" id="DA">BULGARIA  BG</option>
		<option value="BF" id="BF">BURKINA FASO</option>
		<option value="BI" id="BI">BURUNDI</option>
		<option value="KH" id="KH">CAMBODIA</option>
		<option value="CM" id="CM">CAMEROON</option>
		<option value="CA" id="CA">CANADA</option>
		<option value="CV" id="CV">CAPE VERDE</option>
		<option value="KY" id="KY">CAYMAN ISLANDS</option>
		<option value="CF" id="CF">CENTRAL AFRICAN PUBLIC</option>
		<option value="TD" id="TD">CHAD</option>
		<option value="CL" id="CL">CHILE</option>
		<option value="CN" id="CN">CHINA</option>
		<option value="CX" id="CX">CHRISTMAS ISLAND</option>
		<option value="CC" id="CC">COCOS (KEELING) ISLANDS</option>
		<option value="CO" id="CO">COLOMBIA</option>
		<option value="KM" id="KM">COMOROS</option>
		<option value="CG" id="CG">CONGO</option>
		<option value="CD" id="CD">CONGO, THE DEMOCRATIC REPUBLIC OF THE</option>
		<option value="CK" id="CK">COOK ISLANDS</option>
		<option value="CR" id="CR">COSTA RICA</option>
		<option value="CI" id="CI">CÔTE D'IVOIRE</option>
		<option value="HR" id="HR">CROATIA</option>
		<option value="CU" id="CU">CUBA</option>
		<option value="CY" id="CY">CYPRUS</option>
		<option value="CZ" id="CZ">CZECH REPUBLIC</option>
		<option value="DK" id="DK">DENMARK</option>
		<option value="DJ" id="DJ">DJIBOUTI</option>
		<option value="DM" id="DM">DOMINICA</option>
		<option value="DO" id="DO">DOMINICAN REPUBLIC</option>
		<option value="EC" id="EC">ECUADOR</option>
		<option value="EG" id="EG">EGYPT</option>
		<option value="SV" id="SV">EL SALVADOR</option>
		<option value="GQ" id="GQ">EQUATORIAL GUINEA</option>
		<option value="ER" id="ER">ERITREA</option>
		<option value="EE" id="EE">ESTONIA</option>
		<option value="ET" id="ET">ETHIOPIA</option>
		<option value="FK" id="FK">FALKLAND ISLANDS (MALVINAS)</option>
		<option value="FO" id="FO">FAROE ISLANDS</option>
		<option value="FJ" id="FJ">FIJI</option>
		<option value="FI" id="FI">FINLAND</option>
		<option value="FR" id="FR">FRANCE</option>
		<option value="GF" id="GF">FRENCH GUIANA</option>
		<option value="PF" id="PF">FRENCH POLYNESIA</option>
		<option value="TF" id="TF">FRENCH SOUTHERN TERRITORIES</option>
		<option value="GA" id="GA">GABON</option>
		<option value="GM" id="GM">GAMBIA</option>
		<option value="GE" id="GE">GEORGIA</option>
		<option value="DE" id="DE">GERMANY</option>
		<option value="GH" id="GH">GHANA</option>
		<option value="GI" id="GI">GIBRALTAR</option>
		<option value="GR" id="GR">GREECE</option>
		<option value="GL" id="GL">GREENLAND</option>
		<option value="GD" id="GD">GRENADA</option>
		<option value="GP" id="GP">GUADELOUPE</option>
		<option value="GU" id="GU">GUAM</option>
		<option value="GT" id="GT">GUATEMALA</option>
		<option value="GG" id="GG">GUERNSEY</option>
		<option value="GN" id="GN">GUINEA</option>
		<option value="GW" id="GW">GUINEA-BISSAU</option>
		<option value="GY" id="GY">GUYANA</option>
		<option value="HT" id="HT">HAITI</option>
		<option value="HM" id="HM">HEARD ISLAND AND MCDONALD ISLANDS</option>
		<option value="VA" id="VA">HOLY SEE (VATICAN CITY STATE)</option>
		<option value="HN" id="HN">HONDURAS</option>
		<option value="HK" id="HK">HONG KONG</option>
		<option value="HU" id="HU">HUNGARY</option>
		<option value="IS" id="IS">ICELAND</option>
		<option value="IN" id="IN">INDIA</option>
		<option value="ID" id="ID">INDONESIA</option>
		<option value="IR" id="IR">IRAN, ISLAMIC REPUBLIC OF</option>
		<option value="IQ" id="IQ">IRAQ</option>
		<option value="IE" id="IE">IRELAND</option>
		<option value="IM" id="IM">ISLE OF MAN</option>
		<option value="IL" id="IL">ISRAEL</option>
		<option value="IT" id="IT">ITALY</option>
		<option value="JM" id="JM">JAMAICA</option>
		<option value="JP" id="JP">JAPAN</option>
		<option value="JE" id="JE">JERSEY</option>
		<option value="JO" id="JO">JORDAN</option>
		<option value="KZ" id="KZ">KAZAKHSTAN</option>
		<option value="KE" id="KE">KENYA</option>
		<option value="KI" id="KI">KIRIBATI</option>
		<option value="KP" id="KP">KOREA, DEMOCRATIC PEOPLE'S REPUBLIC OF</option>
		<option value="KR" id="KR">KOREA, REPUBLIC OF</option>
		<option value="KW" id="KW">KUWAIT</option>
		<option value="KG" id="KG">KYRGYZSTAN</option>
		<option value="LA" id="LA">LAO PEOPLE'S DEMOCRATIC REPUBLIC</option>
		<option value="LV" id="LV">LATVIA</option>
		<option value="LB" id="LB">LEBANON</option>
		<option value="LS" id="LS">LESOTHO</option>
		<option value="LR" id="LR">LIBERIA</option>
		<option value="LY" id="LY">LIBYAN ARAB JAMAHIRIYA</option>
		<option value="LI" id="LI">LIECHTENSTEIN</option>
		<option value="LT" id="LT">LITHUANIA</option>
		<option value="LU" id="LU">LUXEMBOURG</option>
		<option value="MO" id="MO">MACAO</option>
		<option value="MK" id="MK">MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF</option>
		<option value="MG" id="MG">MADAGASCAR</option>
		<option value="MW" id="MW">MALAWI</option>
		<option value="MY" id="MY">MALAYSIA</option>
		<option value="MV" id="MV">MALDIVES</option>
		<option value="ML" id="ML">MALI</option>
		<option value="MT" id="MT">MALTA</option>
		<option value="MH" id="MH">MARSHALL ISLANDS</option>
		<option value="MQ" id="MQ">MARTINIQUE</option>
		<option value="MR" id="MR">MAURITANIA</option>
		<option value="MU" id="MU">MAURITIUS</option>
		<option value="YT" id="YT">MAYOTTE</option>
		<option value="MX" id="MX">MEXICO</option>
		<option value="FM" id="FM">MICRONESIA, FEDERATED STATES OF</option>
		<option value="MD" id="MD">MOLDOVA, REPUBLIC OF</option>
		<option value="MC" id="MC">MONACO</option>
		<option value="MN" id="MN">MONGOLIA</option>
		<option value="ME" id="ME">MONTENEGRO</option>
		<option value="MS" id="MS">MONTSERRAT</option>
		<option value="MA" id="MA">MOROCCO</option>
		<option value="MZ" id="MZ">MOZAMBIQUE</option>
		<option value="MM" id="MM">MYANMAR</option>
		<option value="NA" id="NA">NAMIBIA</option>
		<option value="NR" id="NR">NAURU</option>
		<option value="NP" id="NP">NEPAL</option>
		<option value="NL" id="NL">NETHERLANDS</option>
		<option value="AN" id="AN">NETHERLANDS ANTILLES</option>
		<option value="NC" id="NC">NEW CALEDONIA</option>
		<option value="NZ" id="NZ">NEW ZEALAND</option>
		<option value="NI" id="NI">NICARAGUA</option>
		<option value="NE" id="NE">NIGER</option>
		<option value="NG" id="NG">NIGERIA</option>
		<option value="NU" id="NU">NIUE</option>
		<option value="NF" id="NF">NORFOLK ISLAND</option>
		<option value="MP" id="MP">NORTHERN MARIANA ISLANDS</option>
		<option value="NO" id="NO">NORWAY</option>
		<option value="OM" id="OM">OMAN</option>
		<option value="PK" id="PK">PAKISTAN</option>
		<option value="PW" id="PW">PALAU</option>
		<option value="PS" id="PS">PALESTINIAN TERRITORY, OCCUPIED</option>
		<option value="PA" id="PA">PANAMA</option>
		<option value="PG" id="PG">PAPUA NEW GUINEA</option>
		<option value="PY" id="PY">PARAGUAY</option>
		<option value="PE" id="PE">PERU</option>
		<option value="PH" id="PH">PHILIPPINES</option>
		<option value="PN" id="PN">PITCAIRN</option>
		<option value="PL" id="PL">POLAND</option>
		<option value="PT" id="PT">PORTUGAL</option>
		<option value="PR" id="PR">PUERTO RICO</option>
		<option value="QA" id="QA">QATAR</option>
		<option value="RE" id="RE">RÉUNION</option>
		<option value="RO" id="RO">ROMANIA</option>
		<option value="RU" id="RU">RUSSIAN FEDERATION</option>
		<option value="RW" id="RW">RWANDA</option>
		<option value="BL" id="BL">SAINT BARTHÉLEMY</option>
		<option value="SH" id="SH">SAINT HELENA</option>
		<option value="KN" id="KN">SAINT KITTS AND NEVIS</option>
		<option value="LC" id="LC">SAINT LUCIA</option>
		<option value="MF" id="MF">SAINT MARTIN</option>
		<option value="PM" id="PM">SAINT PIERRE AND MIQUELON</option>
		<option value="VC" id="VC">SAINT VINCENT AND THE GRENADINES</option>
		<option value="WS" id="WS">SAMOA</option>
		<option value="SM" id="SM">SAN MARINO</option>
		<option value="ST" id="ST">SAO TOME AND PRINCIPE</option>
		<option value="SA" id="SA">SAUDI ARABIA</option>
		<option value="SN" id="SN">SENEGAL</option>
		<option value="RS" id="RS">SERBIA</option>
		<option value="SC" id="SC">SEYCHELLES</option>
		<option value="SL" id="SL">SIERRA LEONE</option>
		<option value="SG" id="SG">SINGAPORE</option>
		<option value="SK" id="SK">SLOVAKIA</option>
		<option value="SI" id="SI">SLOVENIA</option>
		<option value="SB" id="SB">SOLOMON ISLANDS</option>
		<option value="SO" id="SO">SOMALIA</option>
		<option value="ZA" id="ZA">SOUTH AFRICA</option>
		<option value="GS" id="GS">SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS</option>
		<option value="ES" id="ES">SPAIN</option>
		<option value="LK" id="LK">SRI LANKA</option>
		<option value="SD" id="SD">SUDAN</option>
		<option value="SR" id="SR">SURINAME</option>
		<option value="SJ" id="SJ">SVALBARD AND JAN MAYEN</option>
		<option value="SZ" id="SZ">SWAZILAND</option>
		<option value="SE" id="SE">SWEDEN</option>
		<option value="CH" id="CH">SWITZERLAND</option>
		<option value="SY" id="SY">SYRIAN ARAB REPUBLIC</option>
		<option value="TW" id="TW">TAIWAN, PROVINCE OF CHINA</option>
		<option value="TJ" id="TJ">TAJIKISTAN</option>
		<option value="TZ" id="TZ">TANZANIA, UNITED REPUBLIC</option>
		<option value="OF" id="OF">THAILAND  TH</option>
		<option value="TL" id="TL">TIMOR-LESTE</option>
		<option value="TG" id="TG">TOGO</option>
		<option value="TK" id="TK">TOKELAU</option>
		<option value="TO" id="TO">TONGA</option>
		<option value="TT" id="TT">TRINIDAD AND TOBAGO</option>
		<option value="TN" id="TN">TUNISIA</option>
		<option value="TR" id="TR">TURKEY</option>
		<option value="TM" id="TM">TURKMENISTAN</option>
		<option value="TC" id="TC">TURKS AND CAICOS ISLANDS</option>
		<option value="TV" id="TV">TUVALU</option>
		<option value="UG" id="UG">UGANDA</option>
		<option value="UA" id="UA">UKRAINE</option>
		<option value="AE" id="AE">UNITED ARAB EMIRATES</option>
		<option value="GB" id="GB">UNITED KINGDOM</option>
		<option value="US" id="US">UNITED STATES</option>
		<option value="UM" id="UM">UNITED STATES MINOR OUTLYING ISLANDS</option>
		<option value="UY" id="UY">URUGUAY</option>
		<option value="UZ" id="UZ">UZBEKISTAN</option>
		<option value="VU" id="VU">VANUATU</option>
		<option value="SE" id="SE">VATICAN CITY STATE  see HOLY SEE</option>
		<option value="VE" id="VE">VENEZUELA, BOLIVARIAN REPUBLIC</option>
		<option value="VN" id="VN">VIET NAM</option>
		<option value="OF" id="OD">VIRGIN ISLANDS, BRITISH  VG</option>
		<option value="VI" id="VI">VIRGIN ISLANDS, U.S.</option>
		<option value="WF" id="WF">WALLIS AND FUTUNA</option>
		<option value="EH" id="EH">WESTERN SAHARA</option>
		<option value="YE" id="YE">YEMEN</option>
		<option value="ZM" id="ZM">ZAMBIA</option>
		<option value="ZW" id="ZW">ZIMBABWE</option>
	</xsl:template>
	<xsl:template name="XFilesCharacterSetOptions">
		<option value="ISO-8859-6" id="ISO-8859-6">Arabic (ISO-8859-6)</option>
		<option value="Windows-1256" id="Windows-1256">Arabic (Windows-1256)</option>
		<option value="ISO-8859-4" id="ISO-8859-4">Baltic (ISO-8859-4)</option>
		<option value="Windows-1257" id="Windows-1257">Baltic (Windows-1257)</option>
		<option value="IBM852" id="IBM852">Central European (IBM852)</option>
		<option value="ISO-8859-2" id="ISO-8859-2">Central European (ISO-8859-2)</option>
		<option value="Windows-1250" id="Windows-1250">Central European (Windows-1250)</option>
		<option value="GB2312" id="GB2312">Chinese Simplified (GB2312)</option>
		<option value="GBK" id="GBK">Chinese Simplified (GBK)</option>
		<option value="MS950" id="MS950">Chinese Traditional (Big5)</option>
		<option value="EUC-TW" id="EUC-TW">Chinese Traditional (EUC-TW)</option>
		<option value="Windows-950" id="Windows-950">Chinese Traditional (Windows-950)</option>
		<option value="ISO-2022-CN" id="ISO-2022-CN">Chinese (ISO-2022-CN)</option>
		<option value="IBM866" id="IBM866">Cyrillic (IBM866)</option>
		<option value="ISO-8859-5" id="ISO-8859-5">Cyrillic (ISO-8859-5)</option>
		<option value="KOI8-R" id="KOI8-R">Cyrillic (KOI8-R)</option>
		<option value="Windows-1251" id="Windows-1251">Cyrillic Alphabet (Windows-1251)</option>
		<option value="ISO-8859-7" id="ISO-8859-7">Greek (ISO-8859-7)</option>
		<option value="Windows-1253" id="Windows-1253">Greek (Windows-1253)</option>
		<option value="ISO-8859-8" id="ISO-8859-8">Hebrew (ISO-8859-8)</option>
		<option value="Windows-1255" id="Windows-1255">Hebrew (Windows-1255)</option>
		<option value="ISO-2022-JP" id="ISO-2022-JP">Japanese (ISO-2022-JP)</option>
		<option value="EUC-JP" id="EUC-JP">Japanese (EUC-JP)</option>
		<option value="SHIFT_JIS" id="SHIFT_JIS">Japanese (SHIFT_JIS)</option>
		<option value="EUC_KR" id="EUC_KR">Korean (KS_C_5601-1987)</option>
		<option value="ISO-2022-KR" id="ISO-2022-KR">Korean (ISO-2022-KR)</option>
		<option value="Windows-949" id="Windows-949">Korean (Windows-949)</option>
		<option value="ISO-8859-3" id="ISO-8859-3">South European (ISO-8859-3)</option>
		<option value="TIS-620" id="TIS-620">Thai (TIS-620)</option>
		<option value="IBM857" id="IBM857">Turkish (IBM857)</option>
		<option value="ISO-8859-9" id="ISO-8859-9">Turkish (ISO-8859-9)</option>
		<option value="Windows-1254" id="Windows-1254">Turkish (Windows-1254)</option>
		<option value="UTF-8" id="UTF-8">Unicode (UTF-8)</option>
		<option value="Windows-1258" id="Windows-1258">Vietnamese (Windows-1258)</option>
		<option value="ISO-8859-1" id="ISO-8859-1">Western (ISO-8859-1)</option>
		<option value="Windows-1252" id="Windows-1252">Western (Windows-1252)</option>
		<option value="IBM850" id="IBM850">Western (IBM850)</option>
	</xsl:template>
	<xsl:template name="XFilesLanguageOptions">
		<option value="ARABIC" id="ARABIC">Arabic</option>
		<option value="BENGALI" id="BENGALI">Bengali</option>
		<option value="BRAZILIAN PORTUGUESE" id="BRAZILIAN PORTUGUESE">Brazilian Portuguese</option>
		<option value="BULGARIAN" id="BULGARIAN">Bulgarian</option>
		<option value="CANADIAN FRENCH" id="CANADIAN FRENCH">Canadian French</option>
		<option value="CATALAN" id="CATALAN">Catalan</option>
		<option value="CROATIAN" id="CROATIAN">Croatian</option>
		<option value="CZECH" id="CZECH">Czech</option>
		<option value="DANISH" id="DANISH">Danish</option>
		<option value="DUTCH" id="DUTCH">Dutch</option>
		<option value="EGYPTIAN" id="EGYPTIAN">Egyptian</option>
		<option value="en-US" id="en-US">English</option>
		<option value="ESTONIAN" id="ESTONIAN">Estonian</option>
		<option value="FINNISH" id="FINNISH">Finnish</option>
		<option value="FRENCH" id="FRENCH">French</option>
		<option value="GERMAN" id="GERMAN">German</option>
		<option value="GREEK" id="GREEK">Greek</option>
		<option value="HEBREW" id="HEBREW">Hebrew</option>
		<option value="HUNGARIAN" id="HUNGARIAN">Hungarian</option>
		<option value="ICELANDIC" id="ICELANDIC">Icelandic</option>
		<option value="INDONESIAN" id="INDONESIAN">Indonesian</option>
		<option value="ITALIAN" id="ITALIAN">Italian</option>
		<option value="JAPANESE" id="JAPANESE">Japanese</option>
		<option value="KOREAN" id="KOREAN">Korean</option>
		<option value="LATIN AMERICAN SPANISH" id="LATIN AMERICAN SPANISH">Latin American Spanish</option>
		<option value="LATVIAN" id="LATVIAN">Latvian</option>
		<option value="LITHUANIAN" id="LITHUANIAN">Lithuanian</option>
		<option value="MALAY" id="MALAY">Malay</option>
		<option value="MEXICAN SPANISH" id="MEXICAN SPANISH">Mexican Spanish</option>
		<option value="NORWEGIAN" id="NORWEGIAN">Norwegian</option>
		<option value="POLISH" id="POLISH">Polish</option>
		<option value="PORTUGUESE" id="PORTUGUESE">Portuguese</option>
		<option value="ROMANIAN" id="ROMANIAN">Romanian</option>
		<option value="RUSSIAN" id="RUSSIAN">Russian</option>
		<option value="SIMPLIFIED CHINESE" id="SIMPLIFIED CHINESE">Simplified Chinese</option>
		<option value="SLOVAK" id="SLOVAK">Slovak</option>
		<option value="SLOVENIAN" id="SLOVENIAN">Slovenian</option>
		<option value="SPANISH" id="SPANISH">Spanish</option>
		<option value="SWEDISH" id="SWEDISH">Swedish</option>
		<option value="THAI" id="THAI">Thai</option>
		<option value="TRADITIONAL CHINESE" id="TRADITIONAL CHINESE">Traditional Chinese</option>
		<option value="TURKISH" id="TURKISH">Turkish</option>
		<option value="UKRAINIAN" id="UKRAINIAN">Ukrainian</option>
		<option value="VIETNAMESE" id="VIETNAMESE">Vietnamese</option>
	</xsl:template>
	<xsl:template name="genericErrorDialog">
	</xsl:template>
	<xsl:template name="documentPreview">
		<div class="modal fade" id="documentPreviewDialog" tabindex="-1" role="dialog" aria-labelledby="documentPreviewDialogTitle" aria-hidden="true">
			<div class="modal-dialog:" style="width:775px;">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="documentPreviewDialogTitle">Document Preview</h4>
						</div>
					</div>
					<div class="modal-body">
						<div style="text-align:left;white-space: pre;color: #000000; background-color: #FFFFFF; width: 100%; overflow:scroll;width:640px;height:480px">
							<iframe id="documentPreview" frameborder="0" style="width:100%;height:100%">
								<xsl:attribute name="src"><xsl:value-of select="concat('/sys/servlets/XFILES/Protected/XFILES.XFILES_REST_SERVICES.RENDERDOCUMENT?P_RESOURCE_PATH=',/r:Resource/xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath,'&amp;P_CONTENT_TYPE=text/html')"/></xsl:attribute>
							</iframe>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="bntCancelPreview" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="viewCurrentXML">
		<div class="modal fade" id="currentXML" tabindex="-1" role="dialog" aria-labelledby="currentXMLTitle" aria-hidden="true">
			<div class="modal-dialog:" style="width:775px;">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="currentXMLTitle">XML Viewer</h4>
						</div>
					</div>
					<div class="modal-body">
						<div style="text-align:left;white-space: pre;color: #000000; background-color: #FFFFFF; width: 100%; overflow:scroll;width:750px;height:500px">
							<pre id="xmlWindow"/>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="bntCancelXML" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="viewCurrentSQL">
		<div class="modal fade" id="currentSQL" tabindex="-1" role="dialog" aria-labelledby="currentSQLTitle" aria-hidden="true">
			<div class="modal-dialog:" style="width:775px;">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="currentSQLTitle">Current SQL</h4>
						</div>
					</div>
					<div class="modal-body">
						<div style="white-space: pre;color: #000000; background-color: #E0E0E0; width: 100%; overflow-X: auto; overflow-Y:auto;" width="100%">
							<pre id="queryWindow"/>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelSQL" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="manageUsersDialog">
		<div class="modal fade" id="manageUsersDialog" tabindex="-1" role="dialog" aria-labelledby="manageUsersDialogTitle" aria-hidden="true">
			<div class="modal-dialog:" style="width:775px;">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="manageUsersDialogTitle">XFiles System Administration</h4>
						</div>
					</div>
					<div id="dbaOnly" style="display: none;">
						<div class="modal-body">
							<div class="form-horizontal">
								<div class="form-group">
									<xsl:text>Users and Passwords</xsl:text>
								`</div>
								<div class="form-group">
									<label class="col-sm-2 control-label" for="username">User Name</label>
									<div class="col-sm-10">
										<input class="form-control" type="username" id="username" name="username" size="30" maxlength="32"/>
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label" for="newUserPassword1">Enter new Password</label>
									<div class="col-sm-10">
										<input class="form-control" type="newPassword1" id="newUserPassword1" name="newUserPassword1" size="30" maxlength="32"/>
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label" for="newUserPassword2">Re-Enter new Password</label>
									<div class="col-sm-10">
										<input class="form-control" type="newUserPassword2" id="newUserPassword2" name="newPassword2" size="30" maxlength="32"/>
									</div>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<div>
								<button id="btnCancelUserDialog" type="button" class="btn btn-default btn-med" data-dismiss="modal">
									<span class="glyphicon glyphicon-ban-circle"/>
								</button>
								<button id="btnSubmitForm" type="button" class="btn btn-default btn-med" onclick="manageUser(document.getElementById('username').value,document.getElementById('newUserPassword1').value,document.getElementById('newUserPassword2').value);false;">
									<span class="glyphicon glyphicon-save"/>
								</button>
							</div>
						</div>
					</div>
					<div id="xfilesAdmin" style="display: none;">
						<div class="modal-body">
							<div class="form-horizontal">
								<div class="form-group">
									<xsl:text>Users Roles</xsl:text>
							`	</div>
								<div class="form-group">
									<label class="col-sm-2 control-label" for="userList">Select User(s)</label>
									<div class="col-sm-10">
										<select id="userList" multiple="multiple"/>
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label" for="Roles">Set Role(s)</label>
									<input type="radio" id="disableOption" name="roleSelector" value="disabled"/>
									<label for="disableOption">None</label>
									<input type="radio" id="userOption" name="roleSelector" value="user"/>
									<label for="userOption">User</label>
									<span id="adminOptionButton">
										<input type="radio" id="adminOption" name="roleSelector" value="administrator"/>
										<label for="adminOption">Administrator</label>
									</span>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<div>
								<button id="btnCancelUserDialog" type="button" class="btn btn-default btn-med" data-dismiss="modal">
									<span class="glyphicon glyphicon-ban-circle"/>
								</button>
								<button id="btnSubmitForm" type="button" class="btn btn-default btn-med" onclick="setUserRole();false;">
									<span class="glyphicon glyphicon-save"/>
								</button>
							</div>
						</div>
					</div>
					<div id="noAdminRights" style="display: block;">
						<div class="modal-body">
							<h4 class="danger">You have no user management rights</h4>
						</div>
						<div class="modal-footer"/>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="setPasswordDialog">
		<div class="modal fade" id="setPasswordDialog" tabindex="-1" role="dialog" aria-labelledby="setPasswordDialogTitle" aria-hidden="true">
			<div class="modal-dialog:" style="width:775px;">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="setPasswordDialogTitle">XFiles User Options</h4>
						</div>
					</div>
					<div class="modal-body">
						<div class="form-horizontal">
							<div class="form-group">
								<label class="col-sm-2 control-label" for="newPassword1">Enter new Password</label>
								<div class="col-sm-10">
									<input class="form-control" type="newPassword1" id="newPassword1" name="newPassword1" size="30" maxlength="32"/>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label" for="newPassword2">Re-Enter new Password</label>
								<div class="col-sm-10">
									<input class="form-control" type="newPassword2" id="newPassword2" name="newPassword2" size="30" maxlength="32"/>
								</div>
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label">Actions</label>
								<label>
									<input type="checkbox" id="resetHomeFolder"/>Reset Home Folder</label>
								<label>
									<input type="checkbox" id="resetPublicFolder"/>Reset Public Folder</label>
								<label>
									<input type="checkbox" id="recreateHomePage"/>Recreate Home Page</label>
								<label>
									<input type="checkbox" id="recreatePublicPage"/>Reset Public Page</label>
							</div>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="btnCancelPasswordDialog" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
							<button id="btnSubmitPasswordDialog" type="button" class="btn btn-default btn-med" onclick="setUserOptions();false;">
								<span class="glyphicon glyphicon-save"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="XFilesUserActions">
		<span style="vertical-align:middle;">
			<span style="display:block">
				<span id="closeForm">
					<img id="btnCancelCurrentForm" src="/XFILES/lib/icons/cancel.png" alt="Close" border="0" width="16" height="16" data-toggle="tooltip" data-placement="top" title="Close form and return to folder Browser.">
						<xsl:attribute name="onclick"><xsl:value-of select="concat('closeCurrentWindow(&quot;',//xfiles:ResourceStatus/xfiles:CurrentPath,'&quot;)')"/></xsl:attribute>
					</img>
				</span>
			</span>
			<span style="display:block;height:16px;">
			</span>
			<span style="display:block">
				<xsl:choose>
					<xsl:when test="/*/xfiles:xfilesParameters/xfiles:user='ANONYMOUS'">
						<img id="btnLogin" src="/XFILES/lib/icons/login.png" alt="logon" border="0" width="16" height="16" onclick="xfilesDoLogon(event);false" data-toggle="tooltip" data-placement="top" title="Login"/>
					</xsl:when>
					<xsl:otherwise>
						<img id="btnLogout" src="/XFILES/lib/icons/logout.png" alt="logout" border="0" width="16" height="16" onclick="xfilesDoLogoff(event);false" data-toggle="tooltip" data-placement="top" title="Logout"/>
					</xsl:otherwise>
				</xsl:choose>
				<span style="width:10px; display: inline-block; "/>
				<xsl:choose>
					<xsl:when test="/*/xfiles:xfilesParameters/xfiles:user!='ANONYMOUS'">
						<img id="btnHomeFolder" src="/XFILES/lib/icons/homeFolder.png" alt="homeFolder" border="0" width="16" height="16" data-toggle="tooltip" data-placement="top" title="Open Home Folder">
							<xsl:attribute name="onclick"><xsl:value-of select="concat('doShowHomeFolder(event,&quot;',/*/xfiles:xfilesParameters/xfiles:user,'&quot;);false;')"/></xsl:attribute>
						</img>
						<span style="width:10px; display: inline-block;"/>
						<img id="btnSetPassword" src="/XFILES/lib/icons/setPassword.png" alt="set password" border="0" width="16" height="16" onclick="doSetPassword(event);false" data-toggle="tooltip" data-placement="top" title="User Options"/>
						<span style="width:10px; display: inline-block;"/>
						<img id="btnAddUser" src="/XFILES/lib/icons/addUser.png" alt="add user" border="0" width="16" height="16" onclick="doManageUsers(event);false" data-toggle="tooltip" data-placement="top" title="Administrator Options"/>
						<span style="width:10px; display: inline-block;"/>
					</xsl:when>
				</xsl:choose>
				<img id="btnHelp" src="/XFILES/lib/icons/help.png" alt="help" border="0" width="16" height="16" onclick="xfilesHelpMenu(event)" data-toggle="tooltip" data-placement="top" title="Help"/>
			</span>
			<xsl:call-template name="setPasswordDialog"/>
			<xsl:call-template name="manageUsersDialog"/>
			<xsl:call-template name="genericErrorDialog"/>
			<xsl:call-template name="viewCurrentXML"/>
			<xsl:call-template name="XFilesHelpMenu"/>
			<xsl:call-template name="aboutXFilesDialog"/>
		</span>
	</xsl:template>
	<xsl:template name="XFilesLogo">
		<span style="vertical-align:middle;">
			<img id="primaryLogo" src="/XFILES/logo.png" width="420px" height="80px" alt="X-Files" border="0"/>
		</span>
		<span id="logoSpacer" style="vertical-align:middle; width:10px"/>
		<span id="secondaryLogo" style="vertical-align:middle;"/>
	</xsl:template>
	<xsl:template name="XFilesUser">
		<span style="vertical-align:middle;">
			<xsl:choose>
				<xsl:when test="/*/xfiles:xfilesParameters/xfiles:user='ANONYMOUS'">
					<span id="authenticatedUser" class="headerText"/>
				</xsl:when>
				<xsl:otherwise>
					<span class="headerText">
						<xsl:text>Current User  : </xsl:text>
					</span>
					<span id="authenticatedUser" class="headerText">
						<xsl:value-of select="/*/xfiles:xfilesParameters/xfiles:user"/>
					</span>
				</xsl:otherwise>
			</xsl:choose>
			<span style="width:10px; display:inline-block;"/>
		</span>
	</xsl:template>
	<xsl:template name="loggingDialog">
		<div class="modal fade" id="logWindow" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal">
							<span aria-hidden="true">&#215;</span>
							<span class="sr-only">Close</span>
						</button>
						<h4 class="modal-title" id="myModalLabel">SOAP Call Log</h4>
					</div>
					<div class="modal-body">
						<div>
							<ul class="nav nav-tabs" role="tablist" id="sd.options">
								<li>
									<a href="#lw_OverviewTab" role="tab" data-toggle="tab">Overview</a>
								</li>
								<li>
									<a href="#lw_RequestTab" role="tab" data-toggle="tab">Request</a>
								</li>
								<li>
									<a href="#lw_ResponseTab" role="tab" data-toggle="tab">Response</a>
								</li>
								<li>
									<a href="#lw_JavascriptTab" role="tab" data-toggle="tab">JavaScript</a>
								</li>
							</ul>
						</div>
						<br/>
						<!-- Tab panes -->
						<div class="tab-content">
							<div class="tab-pane active" id="lw_OverviewTab">
								<div class="form-horizontal">
									<div>
										<label class="control-label" for="lw.StartTime">Time&#160;</label>
										<span id="lw.StartTime" class="uneditable-input"/>
										<label class="control-label" for="lw.RecordNumber">&#160;Log&#160;Record&#160;</label>
										<span id="lw.RecordNumber" class="uneditable-input"/>
										<label class="control-label" for="lw.RecordCount">&#160;of&#160;</label>
										<span id="lw.RecordCount" class="uneditable-input"/>
									</div>
									<div>
										<label class="control-label" for="lw.Method">Method&#160;</label>
										<span id="lw.Method" class="uneditable-input"/>
									</div>
									<div>
										<label class="control-label" for="lw.URL">URL&#160;</label>
										<span id="lw.URL" class="uneditable-input"/>
									</div>
									<div>
										<label class="control-label" for="lw.HttpStatus">Status&#160;</label>
										<span id="lw.HttpStatus" class="uneditable-input"/>
									</div>
									<div>
										<label class="control-label" for="lw.ElapsedTime">Timing&#160;</label>
										<span id="lw.ElapsedTime" class="uneditable-input"/>
									</div>
									<div>
										<br/>
										<button id="lw.FirstRecord" type="button" class="btn btn-default btn-med" onclick="restAPI.loadLogEntry(1);return false;">
											<span class="glyphicon glyphicon glyphicon glyphicon-fast-backward"/>
										</button>
										<button id="lw.PrevRecord" type="button" class="btn btn-default btn-med">
											<span class="glyphicon glyphicon glyphicon-step-backward"/>
										</button>
										<button id="lw.NextRecord" type="button" class="btn btn-default btn-med">
											<span class="glyphicon glyphicon glyphicon-step-forward"/>
										</button>
										<button id="lw.LastRecord" type="button" class="btn btn-default btn-med" onclick="restAPI.loadLogEntry(restAPI.getLogRecordCount());return false;">
											<span class="glyphicon glyphicon glyphicon glyphicon-fast-forward"/>
										</button>
									</div>
								</div>
							</div>
							<div class="tab-pane" id="lw_RequestTab">
								<div>
									<label for="lw.RequestBody">Request</label>
									<span>
										<pre id="lw.RequestBody" class="pre-scrollable"/>
									</span>
								</div>
							</div>
							<div class="tab-pane" id="lw_ResponseTab">
								<div>
									<label for="lw.ResponseText">Response</label>
									<span>
										<pre id="lw.ResponseText" class="pre-scrollable"/>
									</span>
								</div>
							</div>
							<div class="tab-pane" id="lw_JavascriptTab">
								<div>
									<label for="lw.ResponseText">Javascript</label>
									<span>
										<pre id="lw.JavascriptCode" class="pre-scrollable"/>
									</span>
								</div>
							</div>
						</div>
					</div>
					<div class="modal-footer">
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
	<xsl:template name="SearchDialog">
		<span id="SearchDialog" style="display:block;">
			<span style="text-align:left;white-space:nowrap;width:100%">
				<span class="headerText">Search</span>
				<span style="width:5px; display: inline-block;"/>
				<select id="searchType" name="searchType" value="FOLDER" onchange="toggleSearchTerms(document.getElementById('searchType'),document.getElementById('searchTerms'))">
					<option id="FOLDER" selected="selected" value="FOLDER">Current folder</option>
					<option id="TREE" value="TREE">Current tree</option>
					<option id="ROOT" value="ROOT">Repository</option>
					<option id="ADV" value="ADV">Advanced search</option>
					<option id="XSD" value="XSD">XML Schemas</option>
					<option id="XIDX" value="XIDX">XML Indexes</option>
				</select>
				<span style="width:5px; display: inline-block;"/>
				<label>for</label>
				<span style="width:5px; display: inline-block;"/>
				<input id="searchTerms" class="xg" name="searchTerms" size="16" type="text" maxlength="128"/>
				<span style="width:5px; display: inline-block;"/>
					<img src="/XFILES/lib/icons/search.png" alt="Search" border="0" align="absmiddle" width="16" height="16" onclick="doSearch(document.getElementById('searchType'),document.getElementById('searchTerms'));" data-toggle="tooltip" data-placement="top" title="Open Search Dialog"/>
			</span>
		</span>
	</xsl:template>
	<xsl:template name="parentPath">
		<xsl:param name="remainingPath"/>
		<xsl:param name="currentFolder"/>
		<xsl:choose>
			<xsl:when test="contains($remainingPath,'/')">
				<xsl:call-template name="parentPath">
					<xsl:with-param name="remainingPath" select="substring-after($remainingPath,'/')"/>
					<xsl:with-param name="currentFolder" select="concat($currentFolder,'/',substring-before($remainingPath,'/'))"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$currentFolder"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="printFolderLink">
		<xsl:param name="folderURL"/>
		<xsl:param name="stylesheetURL"/>
		<xsl:param name="fastPath"/>
		<xsl:param name="method"/>
		<xsl:attribute name="href"><xsl:choose><xsl:when test="$stylesheetURL != ''"><xsl:value-of select="concat('/XFILES/lite/Folder.html?target=',$folderURL,'&amp;stylesheet=',$stylesheetURL)"></xsl:value-of></xsl:when><xsl:otherwise><xsl:value-of select="concat('/XFILES/lite/Folder.html?target=',$folderURL)"></xsl:value-of></xsl:otherwise></xsl:choose></xsl:attribute>
		<xsl:if test="$fastPath='true'">
			<xsl:attribute name="onclick"><xsl:choose><xsl:when test="$method != ''"><xsl:value-of select="$method"/></xsl:when><xsl:otherwise><xsl:text>doFolderJump</xsl:text></xsl:otherwise></xsl:choose><xsl:text>('</xsl:text><xsl:value-of select="$folderURL"/><xsl:if test="$stylesheetURL != ''"><xsl:text>','</xsl:text><xsl:value-of select="$stylesheetURL"/></xsl:if><xsl:text>');return false;</xsl:text></xsl:attribute>
		</xsl:if>
	</xsl:template>
	<xsl:template name="printResourceLink">
		<xsl:param name="LinkName"/>
		<xsl:param name="IsContainer"/>
		<xsl:param name="ContentType"/>
		<xsl:param name="SchemaElement"/>
		<xsl:param name="EncodedPath"/>
		<xsl:param name="stylesheetURL"/>
		<xsl:param name="fastPath"/>
		<xsl:param name="method"/>
		<xsl:choose>
			<xsl:when test="$IsContainer='true'">
				<a>
					<xsl:call-template name="printFolderLink">
						<xsl:with-param name="folderURL" select="$EncodedPath"/>
						<xsl:with-param name="stylesheetURL" select="$stylesheetURL"/>
						<xsl:with-param name="fastPath" select="$fastPath"/>
						<xsl:with-param name="method" select="$method"/>
					</xsl:call-template>
					<xsl:value-of select="$LinkName"/>
				</a>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="printDocumentLink">
					<xsl:with-param name="LinkName" select="$LinkName"/>
					<xsl:with-param name="SchemaElement" select="$SchemaElement"/>
					<xsl:with-param name="ContentType" select="$ContentType"/>
					<xsl:with-param name="EncodedPath" select="$EncodedPath"/>
					<xsl:with-param name="CustomViewer" select="$stylesheetURL"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="printFolderShortcut">
		<xsl:param name="folderName"/>
		<xsl:param name="folderURL"/>
		<xsl:param name="stylesheetURL"/>
		<xsl:param name="fastPath"/>
		<span>
			<a>
				<xsl:call-template name="printFolderLink">
					<xsl:with-param name="folderURL" select="$folderURL"/>
					<xsl:with-param name="stylesheetURL" select="$stylesheetURL"/>
					<xsl:with-param name="fastPath" select="$fastPath"/>
				</xsl:call-template>
				<span style="width:2px;display:inline-block;"/>
				<img alt="Folder" src="/XFILES/lib/icons/repositoryFolder.png" width="16" height="16" border="0"/>
				<span style="width:2px;display:inline-block;"/>
				<xsl:value-of select="$folderName"/>
			</a>
		</span>
	</xsl:template>
	<xsl:template name="processFolderPath">
		<xsl:param name="remainingPath"/>
		<xsl:param name="currentFolder"/>
		<xsl:param name="fastPath"/>
		<xsl:choose>
			<!-- Print the current Folder -->
			<xsl:when test="contains($remainingPath,'/')">
				<xsl:call-template name="printFolderShortcut">
					<xsl:with-param name="folderName" select="substring-before($remainingPath,'/')"/>
					<xsl:with-param name="folderURL" select="concat($currentFolder,'/',substring-before($remainingPath,'/'))"/>
					<xsl:with-param name="fastPath" select="$fastPath"/>
				</xsl:call-template>
				<!-- Process the rest of the Path -->
				<xsl:call-template name="processFolderPath">
					<xsl:with-param name="remainingPath" select="substring-after($remainingPath,'/')"/>
					<xsl:with-param name="currentFolder" select="concat($currentFolder,'/',substring-before($remainingPath,'/'))"/>
					<xsl:with-param name="fastPath" select="$fastPath"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="/r:Resource[@Container='true']">
						<a>
							<!-- Viewing a folder -->
							<xsl:call-template name="printFolderShortcut">
								<xsl:with-param name="folderName" select="$remainingPath"/>
								<xsl:with-param name="folderURL" select="concat($currentFolder,'/',$remainingPath)"/>
								<xsl:with-param name="fastPath" select="$fastPath"/>
							</xsl:call-template>
						</a>
					</xsl:when>
					<xsl:otherwise>
						<span style="width:2px;display:inline-block;"/>
						<img alt="File" src="/XFILES/lib/icons/repositoryFile.png" height="16" width="16" border="0"/>
						<span style="width:2px;display:inline-block;"/>
						<xsl:value-of select="$remainingPath"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="folderShortcuts">
		<xsl:param name="resourcePath"/>
		<xsl:param name="fastPath"/>
		<span class="standardBackground" style="white-space:nowrap">
			<span>
				<a>
					<xsl:choose>
						<xsl:when test="$fastPath='true'">
							<xsl:attribute name="href"><xsl:text>#</xsl:text></xsl:attribute>
							<xsl:attribute name="onclick"><xsl:text>doFolderJump(&quot;/&quot;);return false;</xsl:text></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="href"><xsl:text>/XFILES/lite/Folder.html?target=/</xsl:text></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
					<img alt="root" src="/XFILES/lib/icons/repositoryRoot.png" width="16" height="16" border="0" data-toggle="tooltip" data-placement="top" title="Open Root folder"/>
				</a>
			</span>
		</span>
		<xsl:if test="string-length(substring-after($resourcePath,'/')) > 0">
			<xsl:call-template name="processFolderPath">
				<xsl:with-param name="remainingPath" select="substring-after($resourcePath,'/')"/>
				<xsl:with-param name="currentFolder" select="''"/>
				<xsl:with-param name="fastPath" select="$fastPath"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template name="XFilesHeader">
		<xsl:param name="action"/>
		<xsl:param name="fastPath"/>
		<noscript>This product requires use of a browser that supports JavaScript 1.2, and that you run with scripting enabled.</noscript>
		<xsl:call-template name="loggingDialog"/>
		<table style="border-width:0px; padding:0px; margin:0px; width:100%;">
			<tbody>
				<tr>
					<td colspan="2">
						<div style="font-size:1px; border:0px; padding: 0px: margin: 0px; height:1px; width:1000px; clear:both"/>
					</td>
				</tr>
				<tr valign="middle">
					<td>
						<xsl:call-template name="XFilesLogo"/>
					</td>
					<td align="right">
						<span style="display:inline-block;">
							<xsl:call-template name="XFilesUser"/>
						</span>
						<span style="display:inline-block;">
							<xsl:call-template name="XFilesUserActions"/>
						</span>
					</td>
				</tr>
				<tr valign="middle">
					<td>
						<span class="headerText">
							<xsl:value-of select="$action"/>
							<xsl:text> : </xsl:text>
						</span>
						<xsl:call-template name="folderShortcuts">
							<xsl:with-param name="fastPath" select="$fastPath"/>
							<xsl:with-param name="resourcePath" select="/r:Resource/xfiles:ResourceStatus/xfiles:CurrentPath/@xfiles:EncodedPath"/>
						</xsl:call-template>
					</td>
					<td align="right">
						<xsl:call-template name="SearchDialog"/>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<xsl:template name="CopyRight">
		<span style="float:left" class="copyright">Copyright © 2015 Oracle Corporation. All rights reserved.</span>
	</xsl:template>
	<xsl:template name="XFilesFooter">
		<div>
			<xsl:call-template name="CopyRight"/>
		</div>
		<div style="width=100%; height=5px;clear:both;"/>
	</xsl:template>
	<xsl:template name="XFilesSaveAndCloseOptions">
		<xsl:param name="saveButton"/>
		<xsl:param name="saveAndCloseButton"/>
		<span style="float:right;" id="saveAndCloseButtons">
			<span style="float:right;">
				<xsl:if test="$saveButton='true'">
					<span id="saveOption" style="display:inline-block;width:21px;">
						<img id="btnAcceptForm" src="/XFILES/lib/icons/saveChanges.png" alt="Save" border="0" height="16" width="16" onclick="doSave();false" data-toggle="tooltip" data-placement="top" title="Save changes to current form."/>
					</span>
				</xsl:if>
				<xsl:if test="$saveAndCloseButton='true'">
					<span id="saveAndCloseOption" style="display:inline-block;width:21px;">
						<img id="btnSaveForm" src="/XFILES/lib/icons/saveChangesAndClose.png" alt="Save" border="0" height="16" width="16" onclick="doSaveAndClose();false" data-toggle="tooltip" data-placement="top" title="Save changes and close current form."/>
					</span>
				</xsl:if>
				<span style="display:inline-block;width:5px"/>
			</span>
		</span>
	</xsl:template>
	<xsl:template name="XFilesShowApplicationPath">
		<tr>
			<td>
				<table class="standardBackground" width="100%" summary="" border="0" cellspacing="0" cellpadding="0">
					<tbody>
						<tr>
							<td align="left" valign="bottom" nowrap="nowrap">
								<span class="x2s">Current Folder:
								</span>
							</td>
							<td align="left" valign="bottom" width="5">
								<span style="width:5px; display: inline-block;"/>
							</td>
							<td align="left" valign="bottom" width="99%">
								<nobr/>
								<span class="x2t">
									<xsl:for-each select="/*/xfiles:xfilesParameters/xfiles:ParentList">
										<xsl:for-each select="xfiles:Folder">
											<xsl:if test="position() > 1">
												<span class="x2t">&#160;&gt;&#160;</span>
											</xsl:if>
											<a>
												<xsl:attribute name="href"><xsl:value-of select="@Path"/></xsl:attribute>
												<span class="standardBackground">
													<xsl:value-of select="@Name"/>
												</span>
											</a>
										</xsl:for-each>
									</xsl:for-each>
								</span>
							</td>
							<td>
								<span style="width:5px; display: inline-block;"/>
							</td>
						</tr>
					</tbody>
				</table>
			</td>
		</tr>
	</xsl:template>
	<xsl:template name="XFilesTableBottom">
		<tr>
			<table width="100%" nowrap="nowrap">
				<tr>
					<td colspan="3">
						<span style="width:10px; display: inline-block;"/>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<span style="width:14x; display: inline-block;"/>
					</td>
					<td rowspan="2">
						<img src="/XFILES/lib/graphics/c-skir.gif" alt="" width="14" height="15"/>
					</td>
				</tr>
				<tr>
					<td width="100%" colspan="2" class="x9"/>
				</tr>
			</table>
		</tr>
	</xsl:template>
	<xsl:template name="XFilesSeperator">
		<xsl:param name="height"/>
		<xsl:choose>
			<xsl:when test="$height">
				<div style="height:50px; vertical-align:middle; width:100%" class="blueGradient">
					<xsl:attribute name="style"><xsl:text>height:</xsl:text><xsl:value-of select="$height"/><xsl:text>; vertical-align:middle; width:100%" class="blueGradient"</xsl:text></xsl:attribute>
				</div>
			</xsl:when>
			<xsl:otherwise>
				<div style="height:50px; vertical-align:middle; width:100%" class="blueGradient"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="IconFromFileExtension">
		<xsl:param name="FileExtension"/>
		<xsl:choose>
			<xsl:when test="contains($FileExtension,'.')">
				<xsl:call-template name="IconFromFileExtension">
					<xsl:with-param name="FileExtension" select="substring-after($FileExtension, '.')"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<img alt="" style="vertical-align: middle; border: 0;" width="16px" height="16px">
					<xsl:attribute name="src"><xsl:choose><xsl:when test="$XFilesIconMappings/mapping/fileExtension[extension=$FileExtension]"><xsl:value-of select="$XFilesIconMappings/mapping/fileExtension[extension=$FileExtension]/icon"/></xsl:when><xsl:otherwise><xsl:value-of select="$XFilesIconMappings/mapping/default/icon"/></xsl:otherwise></xsl:choose></xsl:attribute>
				</img>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="printXFilesLink">
		<xsl:param name="LinkName"/>
		<xsl:param name="EncodedPath"/>
		<xsl:param name="stylesheet"/>
		<xsl:param name="includeContent"/>
		<xsl:param name="customViewer"/>
		<a>
			<xsl:attribute name="href"><xsl:choose><xsl:when test="$customViewer"><xsl:value-of select="$customViewer"/></xsl:when><xsl:otherwise><xsl:text>/XFILES/lite/Resource.html</xsl:text></xsl:otherwise></xsl:choose><xsl:text>?target=</xsl:text><xsl:value-of select="$EncodedPath"/><xsl:text disable-output-escaping="yes">&amp;stylesheet=</xsl:text><xsl:value-of select="$stylesheet"/><xsl:if test="$includeContent='true'"><xsl:text disable-output-escaping="yes">&amp;includeContent=true</xsl:text></xsl:if></xsl:attribute>
			<xsl:value-of select="$LinkName"/>
		</a>
	</xsl:template>
	<xsl:template name="PrintLinkByExtension">
		<xsl:param name="LinkName"/>
		<xsl:param name="FileExtension"/>
		<xsl:param name="EncodedPath"/>
		<xsl:choose>
			<xsl:when test="contains($FileExtension,'.')">
				<xsl:call-template name="PrintLinkByExtension">
					<xsl:with-param name="LinkName" select="$LinkName"/>
					<xsl:with-param name="FileExtension" select="substring-after($FileExtension, '.')"/>
					<xsl:with-param name="EncodedPath" select="$EncodedPath"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:choose>
					<xsl:when test="$XFilesMappings/mapping/fileExtension[extension=$FileExtension]">
						<xsl:call-template name="printXFilesLink">
							<xsl:with-param name="LinkName" select="$LinkName"/>
							<xsl:with-param name="EncodedPath" select="$EncodedPath"/>
							<xsl:with-param name="stylesheet" select="$XFilesMappings/mapping/fileExtension[extension=$FileExtension]/stylesheet"/>
							<xsl:with-param name="includeContent" select="$XFilesMappings/mapping/fileExtension[extension=$FileExtension]/includeContent"/>
							<xsl:with-param name="customViewer" select="$XFilesMappings/mapping/fileExtension[extension=$FileExtension]/htmlPage"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<a target="_blank">
							<xsl:attribute name="href"><xsl:value-of select="$EncodedPath"/></xsl:attribute>
							<xsl:value-of select="$LinkName"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="printDocumentLink">
		<xsl:param name="LinkName"/>
		<xsl:param name="EncodedPath"/>
		<xsl:param name="SchemaElement"/>
		<xsl:param name="ContentType"/>
		<xsl:param name="CustomViewer"/>
		<xsl:choose>
			<xsl:when test="$CustomViewer != ''">
				<xsl:call-template name="printXFilesLink">
					<xsl:with-param name="LinkName" select="$LinkName"/>
					<xsl:with-param name="EncodedPath" select="$EncodedPath"/>
					<xsl:with-param name="stylesheet" select="$CustomViewer"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$XFilesMappings/mapping/xmlSchema[schema=$SchemaElement]">
				<xsl:call-template name="printXFilesLink">
					<xsl:with-param name="LinkName" select="$LinkName"/>
					<xsl:with-param name="EncodedPath" select="$EncodedPath"/>
					<xsl:with-param name="stylesheet" select="$XFilesMappings/mapping/xmlSchema[schema=$SchemaElement]/stylesheet"/>
					<xsl:with-param name="includeContent" select="$XFilesMappings/mapping/xmlSchema[schema=$SchemaElement]/includeContent"/>
					<xsl:with-param name="customViewer" select="$XFilesMappings/mapping/xmlSchema[schema=$SchemaElement]/htmlPage"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$XFilesMappings/mapping/contentType[contentType=$ContentType]">
				<xsl:call-template name="printXFilesLink">
					<xsl:with-param name="LinkName" select="$LinkName"/>
					<xsl:with-param name="EncodedPath" select="$EncodedPath"/>
					<xsl:with-param name="stylesheet" select="$XFilesMappings/mapping/contentType[contentType=$ContentType]/stylesheet"/>
					<xsl:with-param name="includeContent" select="$XFilesMappings/mapping/contentType[contentType=$ContentType]/includeContent"/>
					<xsl:with-param name="customViewer" select="$XFilesMappings/mapping/contentType[contentType=$ContentType]/htmlPage"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="contains($LinkName,'.')">
				<xsl:call-template name="PrintLinkByExtension">
					<xsl:with-param name="LinkName" select="$LinkName"/>
					<xsl:with-param name="FileExtension" select="substring-after($LinkName, '.')"/>
					<xsl:with-param name="EncodedPath" select="$EncodedPath"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<a target="_blank">
					<xsl:attribute name="href"><xsl:value-of select="$EncodedPath"/></xsl:attribute>
					<xsl:value-of select="$LinkName"/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="XFilesHelpMenu">
		<span style="display: none;" id="xfilesHelpMenu" onclick="stopBubble(event)">
			<div style="position:relative; top: 0px;">
				<div style="position: absolute; top: -10px; right: 10px; z-index: 1000;">
					<ul class="Menu">
						<li>
							<a class="MenuItem" href="#" onclick="soapManager.showSoapLog('logWindow');return false;">Show Log</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="viewXML()">Show XML</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="viewXSL()">Show XSL</a>
						</li>
						<li>
							<a class="MenuItem" href="#" onclick="showAboutXFiles()">Help</a>
						</li>
						<!--
						<li>
						<a class="MenuItem" href="#" onclick="doTest()">Test</a>
						</li>
						-->
					</ul>
				</div>
			</div>
		</span>
	</xsl:template>
	<xsl:template name="aboutXFilesDialog">
		<div class="modal fade" id="aboutXFilesDialog" tabindex="-1" role="dialog" aria-labelledby="aboutXFilesDialogTitle" aria-hidden="true">
			<div class="modal-dialog:" style="width:775px;">
				<div class="modal-content">
					<div class="modal-header">
						<div>
							<button type="button" class="close" data-dismiss="modal">
								<span aria-hidden="true">&#215;</span>
								<span class="sr-only">Close</span>
							</button>
							<h4 class="modal-title text-left" id="aboutXFilesDialogTitle">About XFILES</h4>
						</div>
					</div>
					<div class="modal-body">
						<div style="text-align:left;white-space: pre;color: #000000; background-color: #FFFFFF; width: 100%; overflow:scroll;width:320;height:380px">
							<iframe id="aboutXFiles" src="/XFILES/aboutXFiles.html" frameborder="0" style="width:100%;height:100%"/>
						</div>
					</div>
					<div class="modal-footer">
						<div>
							<button id="bntCancelAbout" type="button" class="btn btn-default btn-med" data-dismiss="modal">
								<span class="glyphicon glyphicon-ban-circle"/>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
