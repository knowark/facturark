<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:oxy="http://www.oxygenxml.com/schematron/validation"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
                xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
                xmlns:dn="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2"
                xmlns:app="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"
                xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
                xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
                xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
                xmlns:qdt="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"
                xmlns:udt="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"
                xmlns:sts="dian:gov:co:facturaelectronica:Structures-2-1"
                xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
                xmlns:xades="http://uri.etsi.org/01903/v1.3.2#"
                xmlns:xades141="http://uri.etsi.org/01903/v1.4.1#"
                version="3.0"
                xml:base="file:/Users/vbxeric/Library/Mobile%20Documents/com%7Eapple%7ECloudDocs/01_Signature/01_Clientes/Colombia/DIAN/Segundo%20Pliego/Validaciones/Schematron%20DIAN%20UBL21%20v2/sch/DIAN-UBL21-model.sch_xslt_cascade"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>

   <!--PHASES-->


   <!--PROLOG-->
   <xsl:output xmlns:iso="http://purl.oclc.org/dsdl/schematron" method="xml"/>

   <!--XSD TYPES FOR XSLT2-->


   <!--KEYS AND FUNCTIONS-->


   <!--DEFAULT RULES-->


   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:variable name="sameUri">
         <xsl:value-of select="saxon:system-id() = parent::node()/saxon:system-id()"
                       use-when="function-available('saxon:system-id')"/>
         <xsl:value-of select="oxy:system-id(.) = oxy:system-id(parent::node())"
                       use-when="not(function-available('saxon:system-id')) and function-available('oxy:system-id')"/>
         <xsl:value-of select="true()"
                       use-when="not(function-available('saxon:system-id')) and not(function-available('oxy:system-id'))"/>
      </xsl:variable>
      <xsl:if test="$sameUri = 'true'">
         <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      </xsl:if>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$sameUri = 'true'">
         <xsl:variable name="preceding"
                       select="count(preceding-sibling::*[local-name()=local-name(current())       and namespace-uri() = namespace-uri(current())])"/>
         <xsl:text>[</xsl:text>
         <xsl:value-of select="1+ $preceding"/>
         <xsl:text>]</xsl:text>
      </xsl:if>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>

   <xsl:template match="text()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>text()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::text())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="comment()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>comment()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::comment())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>processing-instruction()</xsl:text>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::processing-instruction())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>

   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->

   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>

   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>

   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>

   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <xsl:apply-templates select="/" mode="M18"/>
      <xsl:apply-templates select="/" mode="M19"/>
      <xsl:apply-templates select="/" mode="M20"/>
      <xsl:apply-templates select="/" mode="M21"/>
      <xsl:apply-templates select="/" mode="M22"/>
   </xsl:template>

   <!--SCHEMATRON PATTERNS-->


   <!--PATTERN UBL21-structure1-->


	  <!--RULE -->
   <xsl:template match="ext:*[* except ext:*]//*" priority="1001" mode="M18">
      <xsl:apply-templates select="@*|node()" mode="M18"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="*[not(*)]" priority="1000" mode="M18">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text>La regla UBL [IND5] indica que un elemento no puede estar vacío de contenido. </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M18"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M18"/>
   <xsl:template match="@*|node()" priority="-2" mode="M18">
      <xsl:apply-templates select="@*|node()" mode="M18"/>
   </xsl:template>

   <!--PATTERN UBL21-structure2-->


	  <!--RULE -->
   <xsl:template match="@*[normalize-space(.) = ''] except //*[namespace-uri()='http://www.w3.org/2000/09/xmldsig#' and local-name()='SignedInfo'][1]/*[namespace-uri()='http://www.w3.org/2000/09/xmldsig#' and local-name()='Reference']/@URI"
                 priority="1000"
                 mode="M19">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="normalize-space(.)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text>La regla UBL [IND5] indica que un atributo UBL no puede estar vacio. </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M19"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M19"/>
   <xsl:template match="@*|node()" priority="-2" mode="M19">
      <xsl:apply-templates select="@*|node()" mode="M19"/>
   </xsl:template>

   <!--PATTERN UBL21-structure3-->


	  <!--RULE -->
   <xsl:template match="*[@languageID]" priority="1001" mode="M20">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../(* except current())[name(.) = name(current())][string(@languageID) = string(current()/@languageID)])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text>La regla UBL [IND7] indica que dos elemento hermanos no pueden llevar en el atributo languageID= el mismo valor </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M20"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:AcceptedVariantsDescription | cbc:AccountingCost | cbc:ActivityType | cbc:AdditionalConditions | cbc:AdditionalInformation | cbc:AgencyName | cbc:ApprovalStatus | cbc:AwardingCriterionDescription | cbc:BackorderReason | cbc:BirthplaceName | cbc:BuildingNumber | cbc:CalculationExpression | cbc:CandidateStatement | cbc:CanonicalizationMethod | cbc:CarrierServiceInstructions | cbc:CertificateType | cbc:ChangeConditions | cbc:Channel | cbc:Characteristics | cbc:CodeValue | cbc:Comment | cbc:CompanyLegalForm | cbc:Condition | cbc:Conditions | cbc:ConditionsDescription | cbc:ConsumersEnergyLevel | cbc:ConsumptionLevel | cbc:ConsumptionType | cbc:Content | cbc:ContractSubdivision | cbc:ContractType | cbc:CorrectionType | cbc:CountrySubentity | cbc:CurrentChargeType | cbc:CustomerReference | cbc:CustomsClearanceServiceInstructions | cbc:DamageRemarks | cbc:DataSendingCapability | cbc:DeliveryInstructions | cbc:DemurrageInstructions | cbc:Department | cbc:Description | cbc:District | cbc:DocumentDescription | cbc:DocumentHash | cbc:DocumentType | cbc:Duty | cbc:ElectronicDeviceDescription | cbc:ElectronicMail | cbc:ExclusionReason | cbc:ExemptionReason | cbc:Expression | cbc:Extension | cbc:FeeDescription | cbc:Floor | cbc:ForwarderServiceInstructions | cbc:Frequency | cbc:FundingProgram | cbc:HandlingInstructions | cbc:HashAlgorithmMethod | cbc:HaulageInstructions | cbc:HeatingType | cbc:Information | cbc:InhouseMail | cbc:InstructionNote | cbc:Instructions | cbc:InvoicingPartyReference | cbc:JobTitle | cbc:Justification | cbc:JustificationDescription | cbc:Keyword | cbc:LatestMeterReadingMethod | cbc:LegalReference | cbc:LimitationDescription | cbc:ListValue | cbc:Location | cbc:Login | cbc:LossRisk | cbc:LowTendersDescription | cbc:MarkAttention | cbc:MarkCare | cbc:MaximumValue | cbc:MeterConstant | cbc:MeterName | cbc:MeterNumber | cbc:MeterReadingComments | cbc:MeterReadingType | cbc:MinimumImprovementBid | cbc:MinimumValue | cbc:MonetaryScope | cbc:MovieTitle | cbc:NameSuffix | cbc:NegotiationDescription | cbc:OneTimeChargeType | cbc:OptionsDescription | cbc:OrderableUnit | cbc:OrganizationDepartment | cbc:OutstandingReason | cbc:PackingMaterial | cbc:PartyType | cbc:Password | cbc:PayPerView | cbc:PaymentDescription | cbc:PaymentNote | cbc:PersonalSituation | cbc:PhoneNumber | cbc:PlacardEndorsement | cbc:PlacardNotation | cbc:PlotIdentification | cbc:PostalZone | cbc:Postbox | cbc:PreviousMeterReadingMethod | cbc:PriceChangeReason | cbc:PriceRevisionFormulaDescription | cbc:PriceType | cbc:PrintQualifier | cbc:Priority | cbc:PrizeDescription | cbc:ProcessDescription | cbc:ProcessReason | cbc:Rank | cbc:Reference | cbc:Region | cbc:RegistrationNationality | cbc:RejectReason | cbc:Remarks | cbc:ReplenishmentOwnerDescription | cbc:ResidenceType | cbc:Resolution | cbc:RoleDescription | cbc:Room | cbc:SealingPartyType | cbc:ServiceNumberCalled | cbc:ServiceType | cbc:ShippingMarks | cbc:ShipsRequirements | cbc:SignatureMethod | cbc:SpecialInstructions | cbc:SpecialServiceInstructions | cbc:SpecialTerms | cbc:SpecialTransportRequirements | cbc:StatusReason | cbc:SubscriberType | cbc:SummaryDescription | cbc:TariffDescription | cbc:TaxExemptionReason | cbc:TechnicalCommitteeDescription | cbc:TelecommunicationsServiceCall | cbc:TelecommunicationsServiceCategory | cbc:TelecommunicationsSupplyType | cbc:Telefax | cbc:Telephone | cbc:TestMethod | cbc:Text | cbc:TierRange | cbc:TimeAmount | cbc:TimezoneOffset | cbc:TimingComplaint | cbc:Title | cbc:TradingRestrictions | cbc:TransportServiceProviderSpecialTerms | cbc:TransportUserSpecialTerms | cbc:TransportationServiceDescription | cbc:ValidateProcess | cbc:ValidateTool | cbc:ValidateToolVersion | cbc:Value | cbc:ValueQualifier | cbc:WarrantyInformation | cbc:Weight | cbc:WorkPhase | cbc:XPath"
                 priority="1000"
                 mode="M20">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(../(* except current())[name(.) = name(current())][not(@languageID)])"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> &gt;La regla UBL [IND8] indica que dos elementos hermanos no pueden omitir informar el atributo languageID= </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M20"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M20"/>
   <xsl:template match="@*|node()" priority="-2" mode="M20">
      <xsl:apply-templates select="@*|node()" mode="M20"/>
   </xsl:template>

   <!--PATTERN UBL-model-->


	  <!--RULE -->
   <xsl:template match="ext:UBLExtensions" priority="1040" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(../ext:UBLExtensions)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAA02]' else if (boolean(/cn:CreditNote)) then '[CAA02]' else if (boolean(/dn:DebitNote)) then '[DAA02]' else if (boolean(/app:ApplicationResponse)) then '[AAA02]' else ''"/>
               <xsl:text/>
               <xsl:text>-XML no cumple con las personalizaciones de UBL-DIAN</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(count(//sts:DianExtensions) &gt; 1)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB03]' else if (boolean(/cn:CreditNote)) then '[CAB03]' else if (boolean(/dn:DebitNote)) then '[DAB03]' else ''"/>
               <xsl:text/>
               <xsl:text>-Solamente puede haber una ocurrencia de un grupo UBLExtension conteniendo el grupo sts:DianExtensions</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(count(//ds:Signature) &gt; 1)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAC03]' else if (boolean(/cn:CreditNote)) then '[CAC03]' else if (boolean(/dn:DebitNote)) then '[DAC03]' else if (boolean(/app:ApplicationResponse)) then '[AAC03]' else ''"/>
               <xsl:text/>
               <xsl:text>-Solamente puede haber una ocurrencia de un grupo UBLExtension conteniendo el grupo ds:Signature</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ext:UBLExtension/ext:ExtensionContent/sts:DianExtensions) = 1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB03]' else if (boolean(/cn:CreditNote)) then '[CAB03]' else if (boolean(/dn:DebitNote)) then '[DAB03]' else if (boolean(/app:ApplicationResponse)) then '[AAB03]' else ''"/>
               <xsl:text/>
               <xsl:text>-XML no cumple con las personalizaciones de UBL-DIAN</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ext:UBLExtension/ext:ExtensionContent/ds:Signature) = 1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAC03]' else if (boolean(/cn:CreditNote)) then '[CAC03]' else if (boolean(/dn:DebitNote)) then '[DAC03]' else if (boolean(/app:ApplicationResponse)) then '[AAC03]' else ''"/>
               <xsl:text/>
               <xsl:text>-No se encuentra el grupo ds:Signature</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="sts:DianExtensions" priority="1039" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then exists(sts:InvoiceControl/sts:InvoiceAuthorization) and sts:InvoiceControl/sts:InvoiceAuthorization != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAB05a]- (R) No se encuentra el numero de resolucion del rango de numeracion otorgado</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then exists(sts:InvoiceControl/sts:AuthorizationPeriod/cbc:StartDate) and sts:InvoiceControl/sts:AuthorizationPeriod/cbc:StartDate != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAB07]- (R) No se encuentra la fecha de inicio del rango otorgado</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then exists(sts:InvoiceControl/sts:AuthorizationPeriod/cbc:EndDate) and sts:InvoiceControl/sts:AuthorizationPeriod/cbc:EndDate != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAB08]- (R) No se encuentra la fecha de fin del rango otorgado</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then exists(sts:InvoiceControl/sts:AuthorizedInvoices/sts:From) and sts:InvoiceControl/sts:AuthorizedInvoices/sts:From != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAB11a]- (R) No se encuentra el numero inicial del rango otorgado</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then exists(sts:InvoiceControl/sts:AuthorizedInvoices/sts:To) and sts:InvoiceControl/sts:AuthorizedInvoices/sts:To != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAB12a]- (R) No se encuentra el numero final del rango otorgado</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(sts:SoftwareProvider/sts:ProviderID) and sts:SoftwareProvider/sts:ProviderID != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB19a]' else if (boolean(/cn:CreditNote)) then '[CAB19a]' else if (boolean(/dn:DebitNote)) then '[DAB19a]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) No se encuentra el NIT Proveedor tecnologico</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(sts:SoftwareProvider/sts:ProviderID/@schemeID) and sts:SoftwareProvider/sts:ProviderID/@schemeID != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB22]' else if (boolean(/cn:CreditNote)) then '[CAB22]' else if (boolean(/dn:DebitNote)) then '[DAB22]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) No se encuentra el attributo schemeID del proveedor tecnologico</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(sts:SoftwareProvider/sts:SoftwareID) and sts:SoftwareProvider/sts:SoftwareID != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB24]' else if (boolean(/cn:CreditNote)) then '[CAB24]' else if (boolean(/dn:DebitNote)) then '[DAB24]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) No se encuentra el codigo de software</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(sts:SoftwareSecurityCode) and sts:SoftwareSecurityCode != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB27]' else if (boolean(/cn:CreditNote)) then '[CAB27]' else if (boolean(/dn:DebitNote)) then '[DAB27]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) No se encuentra el codigo de seguridad del software</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(sts:AuthorizationProvider/sts:AuthorizationProviderID) and sts:AuthorizationProvider/sts:AuthorizationProviderID != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB31]' else if (boolean(/cn:CreditNote)) then '[CAB31]' else if (boolean(/dn:DebitNote)) then '[DAB31]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) No se encuentra el NIT de la DIAN</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (not(/app:ApplicationResponse)) then exists(sts:QRCode) and sts:QRCode != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB36]' else if (boolean(/cn:CreditNote)) then '[CAB36]' else if (boolean(/dn:DebitNote)) then '[DAB36]' else if (boolean(/app:ApplicationResponse)) then '[AAB36]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) No se encuentra el campo con el valor del codigo QR</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="sts:ProviderID" priority="1038" mode="M21">
      <xsl:variable name="nitwithout" select="."/>
      <xsl:variable name="nitwithdv" select="concat(.,'-',@schemeID)"/>
      <xsl:variable name="a"
                    select="if (boolean(substring($nitwithout,1,1))) then substring($nitwithout,1,1) else 0"/>
      <xsl:variable name="b"
                    select="if (boolean(substring($nitwithout,2,1))) then substring($nitwithout,2,1) else 0"/>
      <xsl:variable name="c"
                    select="if (boolean(substring($nitwithout,3,1))) then substring($nitwithout,3,1) else 0"/>
      <xsl:variable name="d"
                    select="if (boolean(substring($nitwithout,4,1))) then substring($nitwithout,4,1) else 0"/>
      <xsl:variable name="e"
                    select="if (boolean(substring($nitwithout,5,1))) then substring($nitwithout,5,1) else 0"/>
      <xsl:variable name="f"
                    select="if (boolean(substring($nitwithout,6,1))) then substring($nitwithout,6,1) else 0"/>
      <xsl:variable name="g"
                    select="if (boolean(substring($nitwithout,7,1))) then substring($nitwithout,7,1) else 0"/>
      <xsl:variable name="h"
                    select="if (boolean(substring($nitwithout,8,1))) then substring($nitwithout,8,1) else 0"/>
      <xsl:variable name="i"
                    select="if (boolean(substring($nitwithout,9,1))) then substring($nitwithout,9,1) else 0"/>
      <xsl:variable name="j"
                    select="if (boolean(substring($nitwithout,10,1))) then substring($nitwithout,10,1) else 0"/>
      <xsl:variable name="k"
                    select="if (boolean(substring($nitwithout,11,1))) then substring($nitwithout,11,1) else 0"/>
      <xsl:variable name="l"
                    select="if (boolean(substring($nitwithout,12,1))) then substring($nitwithout,12,1) else 0"/>
      <xsl:variable name="m"
                    select="if (boolean(substring($nitwithout,13,1))) then substring($nitwithout,13,1) else 0"/>
      <xsl:variable name="n"
                    select="if (boolean(substring($nitwithout,14,1))) then substring($nitwithout,14,1) else 0"/>
      <xsl:variable name="o"
                    select="if (boolean(substring($nitwithout,15,1))) then substring($nitwithout,15,1) else 0"/>
      <xsl:variable name="p"
                    select="if (number(string-length($nitwithout)) = 5) then (number($a) * 19) + (number($b) * 17) + (number($c) * 13) + (number($d) * 7) + (number($e) * 3) else if (number(string-length($nitwithout)) = 6) then (number($a) * 23) + (number($b) * 19) + (number($c) * 17) + (number($d) * 13) + (number($e) * 7) + (number($f) * 3) else if (number(string-length($nitwithout)) = 7) then (number($a) * 29) + (number($b) * 23) + (number($c) * 19) + (number($d) * 17) + (number($e) * 13) + (number($f) * 7) + (number($g) * 3) else if (number(string-length($nitwithout)) = 8) then (number($a) * 37) + (number($b) * 29) + (number($c) * 23) + (number($d) * 19) + (number($e) * 17) + (number($f) * 13) + (number($g) * 7) + (number($h) * 3) else if (number(string-length($nitwithout)) = 9) then ((number($a) * 41) + (number($b) * 37) + (number($c) * 29) + (number($d) * 23) + (number($e) * 19) + (number($f) * 17) + (number($g) * 13) + (number($h) * 7) + (number($i) * 3)) else if (number(string-length($nitwithout)) = 10) then ((number($a) * 43) + (number($b) * 41) + (number($c) * 37) + (number($d) * 29) + (number($e) * 23) + (number($f) * 19) + (number($g) * 17) + (number($h) * 13) + (number($i) * 7) + (number($j) * 3)) else if (number(string-length($nitwithout)) = 11) then ((number($a) * 47) + (number($b) * 43) + (number($c) * 41) + (number($d) * 37) + (number($e) * 29) + (number($f) * 23) + (number($g) * 19) + (number($h) * 17) + (number($i) * 13) + (number($j) * 7) + (number($k) * 3)) else if (number(string-length($nitwithout)) = 12) then ((number($a) * 53) + (number($b) * 47) + (number($c) * 43) + (number($d) * 41) + (number($e) * 37) + (number($f) * 29) + (number($g) * 23) + (number($h) * 19) + (number($i) * 17) + (number($j) * 13) + (number($k) * 7) + (number($l) * 3)) else if (number(string-length($nitwithout)) = 13) then ((number($a) * 59) + (number($b) * 53) + (number($c) * 47) + (number($d) * 43) + (number($e) * 41) + (number($f) * 37) + (number($g) * 29) + (number($h) * 23) + (number($i) * 19) + (number($j) * 17) + (number($k) * 13) + (number($l) * 7) + (number($m) * 3)) else if (number(string-length($nitwithout)) = 14) then ((number($a) * 67) + (number($b) * 59) + (number($c * 53) + (number($d) * 47) + (number($e) * 43) + (number($f) * 41) + (number($g) * 37) + (number($h) * 29) + (number($i) * 23) + (number($j) * 19) + (number($k) * 17) + (number($l) * 13) + (number($m) * 7) + (number($n) * 3))) else if (number(string-length($nitwithout)) = 15) then ((number($a) * 71) + (number($b) * 67) + (number($c) * 59) + (number($d * 53) + (number($e) * 47) + (number($f) * 43) + (number($g) * 41) + (number($h) * 37) + (number($i) * 29) + (number($j) * 23) + (number($k) * 19) + (number($l) * 17) + (number($m) * 13) + (number($n) * 7) + (number($o) * 3))) else ''"/>
      <xsl:variable name="y" select="$p mod 11"/>
      <xsl:variable name="dv" select="if ($y &gt;= 2) then 11 - $y else $y"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then $dv = ./@schemeID else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB22b]' else if (boolean(/cn:CreditNote)) then '[CAB22b]' else if (boolean(/dn:DebitNote)) then '[DAB22b]' else ''"/>
               <xsl:text/>
               <xsl:text>-DV del NIT del Proveedor Tecnologico : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="@schemeID"/>
               <xsl:text/>
               <xsl:text>' no está correctamente calculado : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$dv"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then exists(./@schemeID) and ./@schemeID != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB22a]' else if (boolean(/cn:CreditNote)) then '[CAB22a]' else if (boolean(/dn:DebitNote)) then '[DAB22a]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) NIT del Proveedor Tecnologico debe ser informado con dígito verificador (@schemeName debe ser “31”)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="sts:AuthorizationProviderID" priority="1037" mode="M21">
      <xsl:variable name="nitwithout" select="."/>
      <xsl:variable name="nitwithdv"
                    select="concat(.,'-',sts:AuthorizationProviderID/@schemeID)"/>
      <xsl:variable name="a"
                    select="if (boolean(substring($nitwithout,1,1))) then substring($nitwithout,1,1) else 0"/>
      <xsl:variable name="b"
                    select="if (boolean(substring($nitwithout,2,1))) then substring($nitwithout,2,1) else 0"/>
      <xsl:variable name="c"
                    select="if (boolean(substring($nitwithout,3,1))) then substring($nitwithout,3,1) else 0"/>
      <xsl:variable name="d"
                    select="if (boolean(substring($nitwithout,4,1))) then substring($nitwithout,4,1) else 0"/>
      <xsl:variable name="e"
                    select="if (boolean(substring($nitwithout,5,1))) then substring($nitwithout,5,1) else 0"/>
      <xsl:variable name="f"
                    select="if (boolean(substring($nitwithout,6,1))) then substring($nitwithout,6,1) else 0"/>
      <xsl:variable name="g"
                    select="if (boolean(substring($nitwithout,7,1))) then substring($nitwithout,7,1) else 0"/>
      <xsl:variable name="h"
                    select="if (boolean(substring($nitwithout,8,1))) then substring($nitwithout,8,1) else 0"/>
      <xsl:variable name="i"
                    select="if (boolean(substring($nitwithout,9,1))) then substring($nitwithout,9,1) else 0"/>
      <xsl:variable name="j"
                    select="if (boolean(substring($nitwithout,10,1))) then substring($nitwithout,10,1) else 0"/>
      <xsl:variable name="k"
                    select="if (boolean(substring($nitwithout,11,1))) then substring($nitwithout,11,1) else 0"/>
      <xsl:variable name="l"
                    select="if (boolean(substring($nitwithout,12,1))) then substring($nitwithout,12,1) else 0"/>
      <xsl:variable name="m"
                    select="if (boolean(substring($nitwithout,13,1))) then substring($nitwithout,13,1) else 0"/>
      <xsl:variable name="n"
                    select="if (boolean(substring($nitwithout,14,1))) then substring($nitwithout,14,1) else 0"/>
      <xsl:variable name="o"
                    select="if (boolean(substring($nitwithout,15,1))) then substring($nitwithout,15,1) else 0"/>
      <xsl:variable name="p"
                    select="if (number(string-length($nitwithout)) = 5) then (number($a) * 19) + (number($b) * 17) + (number($c) * 13) + (number($d) * 7) + (number($e) * 3) else if (number(string-length($nitwithout)) = 6) then (number($a) * 23) + (number($b) * 19) + (number($c) * 17) + (number($d) * 13) + (number($e) * 7) + (number($f) * 3) else if (number(string-length($nitwithout)) = 7) then (number($a) * 29) + (number($b) * 23) + (number($c) * 19) + (number($d) * 17) + (number($e) * 13) + (number($f) * 7) + (number($g) * 3) else if (number(string-length($nitwithout)) = 8) then (number($a) * 37) + (number($b) * 29) + (number($c) * 23) + (number($d) * 19) + (number($e) * 17) + (number($f) * 13) + (number($g) * 7) + (number($h) * 3) else if (number(string-length($nitwithout)) = 9) then ((number($a) * 41) + (number($b) * 37) + (number($c) * 29) + (number($d) * 23) + (number($e) * 19) + (number($f) * 17) + (number($g) * 13) + (number($h) * 7) + (number($i) * 3)) else if (number(string-length($nitwithout)) = 10) then ((number($a) * 43) + (number($b) * 41) + (number($c) * 37) + (number($d) * 29) + (number($e) * 23) + (number($f) * 19) + (number($g) * 17) + (number($h) * 13) + (number($i) * 7) + (number($j) * 3)) else if (number(string-length($nitwithout)) = 11) then ((number($a) * 47) + (number($b) * 43) + (number($c) * 41) + (number($d) * 37) + (number($e) * 29) + (number($f) * 23) + (number($g) * 19) + (number($h) * 17) + (number($i) * 13) + (number($j) * 7) + (number($k) * 3)) else if (number(string-length($nitwithout)) = 12) then ((number($a) * 53) + (number($b) * 47) + (number($c) * 43) + (number($d) * 41) + (number($e) * 37) + (number($f) * 29) + (number($g) * 23) + (number($h) * 19) + (number($i) * 17) + (number($j) * 13) + (number($k) * 7) + (number($l) * 3)) else if (number(string-length($nitwithout)) = 13) then ((number($a) * 59) + (number($b) * 53) + (number($c) * 47) + (number($d) * 43) + (number($e) * 41) + (number($f) * 37) + (number($g) * 29) + (number($h) * 23) + (number($i) * 19) + (number($j) * 17) + (number($k) * 13) + (number($l) * 7) + (number($m) * 3)) else if (number(string-length($nitwithout)) = 14) then ((number($a) * 67) + (number($b) * 59) + (number($c * 53) + (number($d) * 47) + (number($e) * 43) + (number($f) * 41) + (number($g) * 37) + (number($h) * 29) + (number($i) * 23) + (number($j) * 19) + (number($k) * 17) + (number($l) * 13) + (number($m) * 7) + (number($n) * 3))) else if (number(string-length($nitwithout)) = 15) then ((number($a) * 71) + (number($b) * 67) + (number($c) * 59) + (number($d * 53) + (number($e) * 47) + (number($f) * 43) + (number($g) * 41) + (number($h) * 37) + (number($i) * 29) + (number($j) * 23) + (number($k) * 19) + (number($l) * 17) + (number($m) * 13) + (number($n) * 7) + (number($o) * 3))) else ''"/>
      <xsl:variable name="y" select="$p mod 11"/>
      <xsl:variable name="dv" select="if ($y &gt;= 2) then 11 - $y else $y"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then $dv = ./@schemeID else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB34]' else if (boolean(/cn:CreditNote)) then '[CAB34]' else if (boolean(/dn:DebitNote)) then '[DAB34]' else ''"/>
               <xsl:text/>
               <xsl:text>-DV del NIT del Proveedor Autorizado : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="@schemeID"/>
               <xsl:text/>
               <xsl:text>' no está correctamente calculado : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$dv"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then exists(./@schemeID) and ./@schemeID != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAB34]' else if (boolean(/cn:CreditNote)) then '[CAB34]' else if (boolean(/dn:DebitNote)) then '[DAB34]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) NIT del Proveedor Autorizado debe ser informado con dígito verificador (@schemeName debe ser “31”)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="ds:Signature" priority="1036" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC02]- (R) El campo ds:SignedInfo esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:CanonicalizationMethod)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC03]- (R) El campo ds:SignedInfo/ds:CanonicalizationMethod esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:SignatureMethod)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC04]- (R) El campo ds:SignedInfo/ds:SignatureMethod esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:Reference)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC05]- (R) El campo ds:SignedInfo/ds:Reference esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:Reference/ds:Transforms)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC06]- (R) El campo ds:SignedInfo/ds:Reference/ds:Transforms esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:Reference/ds:Transforms/ds:Transform)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC07]- (R) El campo ds:SignedInfo/ds:Reference/ds:Transforms/ds:TransForm esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:Reference/ds:DigestMethod)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC08]- (R) El campo ds:SignedInfo/ds:Reference/ds:DigestMethod esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:Reference/ds:DigestValue)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC09]- (R) El campo ds:SignedInfo/ds:Reference/ds:DigestValue esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:Reference)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC10]- (R) El campo ds:SignedInfo/ds:Reference esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:Reference/ds:DigestMethod)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC11]- (R) El campo ds:SignedInfo/ds:Reference/ds:DigestMethod esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:Reference/ds:DigestValue)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC12]- (R) El campo ds:SignedInfo/ds:Reference/ds:DigestValue esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:Reference)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC13]- (R) El campo ds:SignedInfo/ds:Reference esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:Reference/ds:DigestMethod)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC14]- (R) El campo ds:SignedInfo/ds:Reference/ds:DigestMethod esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignedInfo/ds:Reference/ds:DigestValue)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC15]- (R) El campo ds:SignedInfo/ds:Reference/ds:DigestValue esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:SignatureValue)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC16]- (R) El campo ds:SignatureValue esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:KeyInfo)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC17]- (R) El campo ds:KeyInfo esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:KeyInfo/ds:X509Data)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC18]- (R) El campo ds:KeyInfo/ds:X509Data esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:KeyInfo/ds:X509Data/ds:X509Certificate)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC19]- (R) El campo ds:KeyInfo/ds:X509Data/ds:X509Certificate esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC20]- (R) El campo ds:Object esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC21]- (R) El campo ds:Object/xades:QualifyingProperties esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC22]- (R) El campo ds:Object/xades:QualifyingProperties esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC23]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC24]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningTime esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC25]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC26]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC27]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestMethod)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC28]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestMethod esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestValue)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC29]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestValue esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC30]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509IssuerName)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC31]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509IssuerName esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509SerialNumber)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC32]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509SerialNumber esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC33]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC34]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestMethod)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC35]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestMethod esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestValue)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC36]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestValue esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC37]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509IssuerName)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC38]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509IssuerName esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509SerialNumber)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC39]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509SerialNumber esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC40]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC41]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestMethod)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC42]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestMethod esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestValue)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC43]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:CertDigest/ds:DigestValue esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC44]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509IssuerName)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC45]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509IssuerName esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509SerialNumber)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC46]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SigningCertificate/xades:Cert/xades:IssuerSerial/ds:X509SerialNumber esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC47]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC48]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId/xades:SigPolicyId)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC49]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId/xades:SigPolicyId esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId/xades:SigPolicyId/xades:Identifier)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC50]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId/xades:SigPolicyId/xades:Identifier esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId/xades:SigPolicyHash)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC51]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId/xades:SigPolicyHash esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId/xades:SigPolicyHash/ds:DigestMethod)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC52]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId/xades:SigPolicyHash/ds:DigestMethod esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId/xades:SigPolicyHash/ds:DigestValue)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC53]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignaturePolicyIdentifier/xades:SignaturePolicyId/xades:SigPolicyHash/ds:DigestValue esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignerRole)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC54]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignerRole esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignerRole/xades:ClaimedRoles)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC55]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignerRole/xades:ClaimedRoles esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignerRole/xades:ClaimedRoles/xades:ClaimedRole)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DC56]- (R) El campo ds:Object/xades:QualifyingProperties/xades:SignedProperties/xades:SignedSignatureProperties/xades:SignerRole/xades:ClaimedRoles/xades:ClaimedRole esta faltando</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:UBLVersionID" priority="1035" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = 'UBL 2.1'"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD01]' else if (boolean(/cn:CreditNote)) then '[CAD01]' else if (boolean(/dn:DebitNote)) then '[DAD01]' else if (boolean(/app:ApplicationResponse)) then '[AAD01]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) UBLVersionID : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no contiene el literal “UBL 2.1”</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:ProfileID" priority="1034" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = 'DIAN 2.1'"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD03]' else if (boolean(/cn:CreditNote)) then '[CAD03]' else if (boolean(/dn:DebitNote)) then '[DAD03]' else if (boolean(/app:ApplicationResponse)) then '[AAD03]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) ProfileID : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no contiene el literal “DIAN 2.1”</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/descendant::cbc:UUID[1]/@schemeID"
                 priority="1033"
                 mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = //cbc:ProfileExecutionID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD06]' else if (boolean(/cn:CreditNote)) then '[CAD06]' else if (boolean(/dn:DebitNote)) then '[DAD06]' else if (boolean(/app:ApplicationResponse)) then '[AAD06]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor registrado en cbc:UUID/@schemeID : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' Debe ser igual al código informado en cbc:ProfileExecutionID '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="//cbc:ProfileExecutionID"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="sts:Prefix" priority="1032" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = //cac:AccountingSupplierParty//cac:CorporateRegistrationScheme/cbc:ID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text>[FAB10]- (R) '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' Debe ser igual al código de la sucursal correspondiente a este punto de facturación '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="//cac:AccountingSupplierParty//cac:CorporateRegistrationScheme/cbc:ID"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/descendant::cbc:ID[1]" priority="1031" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="not(matches(., '\s')) and not(contains(., '-'))"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD05a]' else if (boolean(/cn:CreditNote)) then '[CAD05a]' else if (boolean(/dn:DebitNote)) then '[DAD05a]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Número de factura : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' contiene caracteres adicionales como espacios o guiones</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice) and /ubl:Invoice/cbc:InvoiceTypeCode != '03') then number(substring-after(., //sts:Prefix)) &gt;= number(//sts:From) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAD05b]- (R) Número de factura : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' inferior al inicio del rango de numeración otorgado: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="//sts:From"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice) and /ubl:Invoice/cbc:InvoiceTypeCode != '03') then number(substring-after(., //sts:Prefix)) &lt;= number(//sts:To) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAD05c]- (R) Número de factura : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' superior al final del rango de numeración otorgado: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="//sts:To"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/descendant::cbc:IssueDate[1]" priority="1030" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:dateTime(concat(., 'T', /descendant::cbc:IssueTime[1])) &lt; current-dateTime() + xs:dayTimeDuration('P10DT0H')"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD09d]' else if (boolean(/cn:CreditNote)) then '[CAD09d]' else if (boolean(/dn:DebitNote)) then '[DAD09d]' else if (boolean(/app:ApplicationResponse)) then '[AAD09D]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Fecha de emision : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="concat(., 'T', /descendant::cbc:IssueTime[1])"/>
               <xsl:text/>
               <xsl:text>' es posterior a diez días calendario contados desde la fecha de transmisión del archivo para su validacón : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="current-dateTime()"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="xs:dateTime(concat(., 'T', /descendant::cbc:IssueTime[1])) &gt; current-dateTime() - xs:dayTimeDuration('P5DT0H')"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD09c]' else if (boolean(/cn:CreditNote)) then '[CAD09c]' else if (boolean(/dn:DebitNote)) then '[DAD09c]' else if (boolean(/app:ApplicationResponse)) then '[AAD09C]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Fecha de emision : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="concat(., 'T', /descendant::cbc:IssueTime[1])"/>
               <xsl:text/>
               <xsl:text>' es anterior a cinco días calendario restados de la fecha actual : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="current-dateTime()"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then xs:date(.) &gt;= xs:date(//sts:InvoiceControl/sts:AuthorizationPeriod/cbc:StartDate) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAD09a]- (R) Fecha de emisión : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' anterior al la fecha de inicio de la autorización de la numeración : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="//sts:InvoiceControl/sts:AuthorizationPeriod/cbc:StartDate"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then xs:date(.) &lt;= xs:date(//sts:InvoiceControl/sts:AuthorizationPeriod/cbc:EndDate) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAD09b]- (R) Fecha de emisión :'</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' posterior al la fecha final de la autorización de la numeración : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="//sts:InvoiceControl/sts:AuthorizationPeriod/cbc:EndDate"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/descendant::cbc:IssueTime[1]" priority="1029" mode="M21">
      <xsl:variable name="hour" select="number(substring(.,1,2))"/>
      <xsl:variable name="minute" select="number(substring(.,4,2))"/>
      <xsl:variable name="second" select="number(substring(.,7,2))"/>
      <xsl:variable name="timezone" select="string(substring(.,9,6))"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="string-length(.)=14 and substring(.,3,1)=':' and substring(.,6,1)=':' and substring(.,9,6)='-05:00'"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD10]' else if (boolean(/cn:CreditNote)) then '[CAD10]' else if (boolean(/dn:DebitNote)) then '[DAD10]' else if (boolean(/app:ApplicationResponse)) then '[AAD10]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Hora del envio : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no esta en el formato autorizado HH:MM:SS-05-00</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$hour&gt;=0 and $hour&lt;=23"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD10]' else if (boolean(/cn:CreditNote)) then '[CAD10]' else if (boolean(/dn:DebitNote)) then '[DAD10]' else if (boolean(/app:ApplicationResponse)) then '[AAD10]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Hora del envio : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$hour"/>
               <xsl:text/>
               <xsl:text>' debe ser entre 0 y 23</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$minute&gt;=0 and $minute&lt;=59"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD10]' else if (boolean(/cn:CreditNote)) then '[CAD10]' else if (boolean(/dn:DebitNote)) then '[DAD10]' else if (boolean(/app:ApplicationResponse)) then '[AAD10]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Minuto del envio : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$minute"/>
               <xsl:text/>
               <xsl:text>' debe ser entre 0 y 59</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$second&gt;=0 and $second&lt;=59"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD10]' else if (boolean(/cn:CreditNote)) then '[CAD10]' else if (boolean(/dn:DebitNote)) then '[DAD10]' else if (boolean(/app:ApplicationResponse)) then '[AAD10]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Segundo del envio : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$second"/>
               <xsl:text/>
               <xsl:text>' debe ser entre 0 y 59</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="$timezone = '-05:00'"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD10]' else if (boolean(/cn:CreditNote)) then '[CAD10]' else if (boolean(/dn:DebitNote)) then '[DAD10]' else if (boolean(/app:ApplicationResponse)) then '[AAD10]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Zona horaria del envio : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$timezone"/>
               <xsl:text/>
               <xsl:text>' debe ser de Colombia (-05:00)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:LineCountNumeric" priority="1028" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test=". = count(//cac:InvoiceLine) or . = count(//cac:CreditNoteLine) or . = count(//cac:DebitNoteLine)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD16]' else if (boolean(/cn:CreditNote)) then '[CAD16]' else if (boolean(/dn:DebitNote)) then '[DAD16]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) LineCountNumeric : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' diferente del número de ocurrencias del grupo /Invoice/cac:InvoiceLine : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="count(//cac:InvoiceLine)"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:DiscrepancyResponse" priority="1027" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/cn:CreditNote) or boolean(/dn:DebitNote)) then exists(../cac:DiscrepancyResponse) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/cn:CreditNote)) then '[CBF01]' else if (boolean(/dn:DebitNote)) then '[DBF01]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) : No se encuentra el nodo cac:DiscrepancyResponse</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:ReferenceID) and cbc:ReferenceID != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/cn:CreditNote)) then '[CBF02]' else if (boolean(/dn:DebitNote)) then '[DBF02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (N) : No se encuentra el prefijo y numero del documento referenciado</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:ResponseCode) and cbc:ResponseCode != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/cn:CreditNote)) then '[CBF03]' else if (boolean(/dn:DebitNote)) then '[DBF03]' else ''"/>
               <xsl:text/>
               <xsl:text>- (N) : No se encuentra el codigo de razon de la nota.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:BillingReference" priority="1026" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (/ubl:Invoice/cbc:InvoiceTypeCode = '03') then exists(../cac:BillingReference) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FBG01]- (R) : No se encuentra el nodo cac:BillingReference</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (/ubl:Invoice/cbc:InvoiceTypeCode = '03') then exists(cac:InvoiceDocumentReference/cbc:ID) and cac:InvoiceDocumentReference/cbc:ID != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FBG03]- (R) : El prefijo y numero de la factura relacionada debe aparecer</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/cn:CreditNote) or boolean(/dn:DebitNote)) then (exists(cac:InvoiceDocumentReference/cbc:ID) and cac:InvoiceDocumentReference/cbc:ID != '') or (exists(cac:CreditNoteDocumentReference/cbc:ID) and cac:CreditNoteDocumentReference/cbc:ID != '') or (exists(cac:DebitNoteDocumentReference/cbc:ID) and cac:DebitNoteDocumentReference/cbc:ID != '') else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/cn:CreditNote)) then '[CBG03]' else if (boolean(/dn:DebitNote)) then '[DBG03]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) : El Numero del documento relacionado debe aparecer</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/cn:CreditNote) or boolean(/dn:DebitNote)) then (exists(cac:InvoiceDocumentReference/cbc:UUID) and cac:InvoiceDocumentReference/cbc:UUID != '') or (exists(cac:CreditNoteDocumentReference/cbc:UUID) and cac:CreditNoteDocumentReference/cbc:UUID != '') or (exists(cac:DebitNoteDocumentReference/cbc:UUID) and cac:DebitNoteDocumentReference/cbc:UUID != '') else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/cn:CreditNote)) then '[CBG04]' else if (boolean(/dn:DebitNote)) then '[DBG04]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) : El CUFE del documento relacionado debe aparecer</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AccountingSupplierParty//cac:PartyTaxScheme/cbc:CompanyID"
                 priority="1025"
                 mode="M21">
      <xsl:variable name="nitwithout" select="."/>
      <xsl:variable name="nitwithdv"
                    select="concat(.,'-',cac:AccountingSupplierParty//cac:PartyTaxScheme/cbc:CompanyID/@schemeID)"/>
      <xsl:variable name="a"
                    select="if (boolean(substring($nitwithout,1,1))) then substring($nitwithout,1,1) else 0"/>
      <xsl:variable name="b"
                    select="if (boolean(substring($nitwithout,2,1))) then substring($nitwithout,2,1) else 0"/>
      <xsl:variable name="c"
                    select="if (boolean(substring($nitwithout,3,1))) then substring($nitwithout,3,1) else 0"/>
      <xsl:variable name="d"
                    select="if (boolean(substring($nitwithout,4,1))) then substring($nitwithout,4,1) else 0"/>
      <xsl:variable name="e"
                    select="if (boolean(substring($nitwithout,5,1))) then substring($nitwithout,5,1) else 0"/>
      <xsl:variable name="f"
                    select="if (boolean(substring($nitwithout,6,1))) then substring($nitwithout,6,1) else 0"/>
      <xsl:variable name="g"
                    select="if (boolean(substring($nitwithout,7,1))) then substring($nitwithout,7,1) else 0"/>
      <xsl:variable name="h"
                    select="if (boolean(substring($nitwithout,8,1))) then substring($nitwithout,8,1) else 0"/>
      <xsl:variable name="i"
                    select="if (boolean(substring($nitwithout,9,1))) then substring($nitwithout,9,1) else 0"/>
      <xsl:variable name="j"
                    select="if (boolean(substring($nitwithout,10,1))) then substring($nitwithout,10,1) else 0"/>
      <xsl:variable name="k"
                    select="if (boolean(substring($nitwithout,11,1))) then substring($nitwithout,11,1) else 0"/>
      <xsl:variable name="l"
                    select="if (boolean(substring($nitwithout,12,1))) then substring($nitwithout,12,1) else 0"/>
      <xsl:variable name="m"
                    select="if (boolean(substring($nitwithout,13,1))) then substring($nitwithout,13,1) else 0"/>
      <xsl:variable name="n"
                    select="if (boolean(substring($nitwithout,14,1))) then substring($nitwithout,14,1) else 0"/>
      <xsl:variable name="o"
                    select="if (boolean(substring($nitwithout,15,1))) then substring($nitwithout,15,1) else 0"/>
      <xsl:variable name="p"
                    select="if (number(string-length($nitwithout)) = 5) then (number($a) * 19) + (number($b) * 17) + (number($c) * 13) + (number($d) * 7) + (number($e) * 3) else if (number(string-length($nitwithout)) = 6) then (number($a) * 23) + (number($b) * 19) + (number($c) * 17) + (number($d) * 13) + (number($e) * 7) + (number($f) * 3) else if (number(string-length($nitwithout)) = 7) then (number($a) * 29) + (number($b) * 23) + (number($c) * 19) + (number($d) * 17) + (number($e) * 13) + (number($f) * 7) + (number($g) * 3) else if (number(string-length($nitwithout)) = 8) then (number($a) * 37) + (number($b) * 29) + (number($c) * 23) + (number($d) * 19) + (number($e) * 17) + (number($f) * 13) + (number($g) * 7) + (number($h) * 3) else if (number(string-length($nitwithout)) = 9) then ((number($a) * 41) + (number($b) * 37) + (number($c) * 29) + (number($d) * 23) + (number($e) * 19) + (number($f) * 17) + (number($g) * 13) + (number($h) * 7) + (number($i) * 3)) else if (number(string-length($nitwithout)) = 10) then ((number($a) * 43) + (number($b) * 41) + (number($c) * 37) + (number($d) * 29) + (number($e) * 23) + (number($f) * 19) + (number($g) * 17) + (number($h) * 13) + (number($i) * 7) + (number($j) * 3)) else if (number(string-length($nitwithout)) = 11) then ((number($a) * 47) + (number($b) * 43) + (number($c) * 41) + (number($d) * 37) + (number($e) * 29) + (number($f) * 23) + (number($g) * 19) + (number($h) * 17) + (number($i) * 13) + (number($j) * 7) + (number($k) * 3)) else if (number(string-length($nitwithout)) = 12) then ((number($a) * 53) + (number($b) * 47) + (number($c) * 43) + (number($d) * 41) + (number($e) * 37) + (number($f) * 29) + (number($g) * 23) + (number($h) * 19) + (number($i) * 17) + (number($j) * 13) + (number($k) * 7) + (number($l) * 3)) else if (number(string-length($nitwithout)) = 13) then ((number($a) * 59) + (number($b) * 53) + (number($c) * 47) + (number($d) * 43) + (number($e) * 41) + (number($f) * 37) + (number($g) * 29) + (number($h) * 23) + (number($i) * 19) + (number($j) * 17) + (number($k) * 13) + (number($l) * 7) + (number($m) * 3)) else if (number(string-length($nitwithout)) = 14) then ((number($a) * 67) + (number($b) * 59) + (number($c * 53) + (number($d) * 47) + (number($e) * 43) + (number($f) * 41) + (number($g) * 37) + (number($h) * 29) + (number($i) * 23) + (number($j) * 19) + (number($k) * 17) + (number($l) * 13) + (number($m) * 7) + (number($n) * 3))) else if (number(string-length($nitwithout)) = 15) then ((number($a) * 71) + (number($b) * 67) + (number($c) * 59) + (number($d * 53) + (number($e) * 47) + (number($f) * 43) + (number($g) * 41) + (number($h) * 37) + (number($i) * 29) + (number($j) * 23) + (number($k) * 19) + (number($l) * 17) + (number($m) * 13) + (number($n) * 7) + (number($o) * 3))) else ''"/>
      <xsl:variable name="y" select="$p mod 11"/>
      <xsl:variable name="dv" select="if ($y &gt;= 2) then 11 - $y else $y"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then $dv = ./@schemeID else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ21]' else if (boolean(/cn:CreditNote)) then '[CAJ21]' else if (boolean(/dn:DebitNote)) then '[DAJ21]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) DV del NIT del emisor : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="@schemeID"/>
               <xsl:text/>
               <xsl:text>' no está correctamente calculado : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$dv"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then exists(./@schemeID) and ./@schemeID != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ21]' else if (boolean(/cn:CreditNote)) then '[CAJ21]' else if (boolean(/dn:DebitNote)) then '[DAJ21]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) NIT del emisor debe ser informado con dígito verificador (si @schemeID es “31”)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AccountingSupplierParty//cac:PartyLegalEntity/cbc:CompanyID"
                 priority="1024"
                 mode="M21">
      <xsl:variable name="nitwithout" select="."/>
      <xsl:variable name="nitwithdv"
                    select="concat(.,'-',cac:AccountingSupplierParty//cac:PartyLegalEntity/cbc:CompanyID/@schemeID)"/>
      <xsl:variable name="a"
                    select="if (boolean(substring($nitwithout,1,1))) then substring($nitwithout,1,1) else 0"/>
      <xsl:variable name="b"
                    select="if (boolean(substring($nitwithout,2,1))) then substring($nitwithout,2,1) else 0"/>
      <xsl:variable name="c"
                    select="if (boolean(substring($nitwithout,3,1))) then substring($nitwithout,3,1) else 0"/>
      <xsl:variable name="d"
                    select="if (boolean(substring($nitwithout,4,1))) then substring($nitwithout,4,1) else 0"/>
      <xsl:variable name="e"
                    select="if (boolean(substring($nitwithout,5,1))) then substring($nitwithout,5,1) else 0"/>
      <xsl:variable name="f"
                    select="if (boolean(substring($nitwithout,6,1))) then substring($nitwithout,6,1) else 0"/>
      <xsl:variable name="g"
                    select="if (boolean(substring($nitwithout,7,1))) then substring($nitwithout,7,1) else 0"/>
      <xsl:variable name="h"
                    select="if (boolean(substring($nitwithout,8,1))) then substring($nitwithout,8,1) else 0"/>
      <xsl:variable name="i"
                    select="if (boolean(substring($nitwithout,9,1))) then substring($nitwithout,9,1) else 0"/>
      <xsl:variable name="j"
                    select="if (boolean(substring($nitwithout,10,1))) then substring($nitwithout,10,1) else 0"/>
      <xsl:variable name="k"
                    select="if (boolean(substring($nitwithout,11,1))) then substring($nitwithout,11,1) else 0"/>
      <xsl:variable name="l"
                    select="if (boolean(substring($nitwithout,12,1))) then substring($nitwithout,12,1) else 0"/>
      <xsl:variable name="m"
                    select="if (boolean(substring($nitwithout,13,1))) then substring($nitwithout,13,1) else 0"/>
      <xsl:variable name="n"
                    select="if (boolean(substring($nitwithout,14,1))) then substring($nitwithout,14,1) else 0"/>
      <xsl:variable name="o"
                    select="if (boolean(substring($nitwithout,15,1))) then substring($nitwithout,15,1) else 0"/>
      <xsl:variable name="p"
                    select="if (number(string-length($nitwithout)) = 5) then (number($a) * 19) + (number($b) * 17) + (number($c) * 13) + (number($d) * 7) + (number($e) * 3) else if (number(string-length($nitwithout)) = 6) then (number($a) * 23) + (number($b) * 19) + (number($c) * 17) + (number($d) * 13) + (number($e) * 7) + (number($f) * 3) else if (number(string-length($nitwithout)) = 7) then (number($a) * 29) + (number($b) * 23) + (number($c) * 19) + (number($d) * 17) + (number($e) * 13) + (number($f) * 7) + (number($g) * 3) else if (number(string-length($nitwithout)) = 8) then (number($a) * 37) + (number($b) * 29) + (number($c) * 23) + (number($d) * 19) + (number($e) * 17) + (number($f) * 13) + (number($g) * 7) + (number($h) * 3) else if (number(string-length($nitwithout)) = 9) then ((number($a) * 41) + (number($b) * 37) + (number($c) * 29) + (number($d) * 23) + (number($e) * 19) + (number($f) * 17) + (number($g) * 13) + (number($h) * 7) + (number($i) * 3)) else if (number(string-length($nitwithout)) = 10) then ((number($a) * 43) + (number($b) * 41) + (number($c) * 37) + (number($d) * 29) + (number($e) * 23) + (number($f) * 19) + (number($g) * 17) + (number($h) * 13) + (number($i) * 7) + (number($j) * 3)) else if (number(string-length($nitwithout)) = 11) then ((number($a) * 47) + (number($b) * 43) + (number($c) * 41) + (number($d) * 37) + (number($e) * 29) + (number($f) * 23) + (number($g) * 19) + (number($h) * 17) + (number($i) * 13) + (number($j) * 7) + (number($k) * 3)) else if (number(string-length($nitwithout)) = 12) then ((number($a) * 53) + (number($b) * 47) + (number($c) * 43) + (number($d) * 41) + (number($e) * 37) + (number($f) * 29) + (number($g) * 23) + (number($h) * 19) + (number($i) * 17) + (number($j) * 13) + (number($k) * 7) + (number($l) * 3)) else if (number(string-length($nitwithout)) = 13) then ((number($a) * 59) + (number($b) * 53) + (number($c) * 47) + (number($d) * 43) + (number($e) * 41) + (number($f) * 37) + (number($g) * 29) + (number($h) * 23) + (number($i) * 19) + (number($j) * 17) + (number($k) * 13) + (number($l) * 7) + (number($m) * 3)) else if (number(string-length($nitwithout)) = 14) then ((number($a) * 67) + (number($b) * 59) + (number($c * 53) + (number($d) * 47) + (number($e) * 43) + (number($f) * 41) + (number($g) * 37) + (number($h) * 29) + (number($i) * 23) + (number($j) * 19) + (number($k) * 17) + (number($l) * 13) + (number($m) * 7) + (number($n) * 3))) else if (number(string-length($nitwithout)) = 15) then ((number($a) * 71) + (number($b) * 67) + (number($c) * 59) + (number($d * 53) + (number($e) * 47) + (number($f) * 43) + (number($g) * 41) + (number($h) * 37) + (number($i) * 29) + (number($j) * 23) + (number($k) * 19) + (number($l) * 17) + (number($m) * 13) + (number($n) * 7) + (number($o) * 3))) else ''"/>
      <xsl:variable name="y" select="$p mod 11"/>
      <xsl:variable name="dv" select="if ($y &gt;= 2) then 11 - $y else $y"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then $dv = ./@schemeID else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ44]' else if (boolean(/cn:CreditNote)) then '[CAJ44]' else if (boolean(/dn:DebitNote)) then '[DAJ44]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) DV del NIT del emisor : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="@schemeID"/>
               <xsl:text/>
               <xsl:text>' no está correctamente calculado : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$dv"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then exists(./@schemeID) and ./@schemeID != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ44]' else if (boolean(/cn:CreditNote)) then '[CAJ44]' else if (boolean(/dn:DebitNote)) then '[DAJ44]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) NIT del emisor debe ser informado con dígito verificador (si @schemeID es “31”)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AccountingSupplierParty" priority="1023" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:AdditionalAccountID) and cbc:AdditionalAccountID != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ02]' else if (boolean(/cn:CreditNote)) then '[CAJ02]' else if (boolean(/dn:DebitNote)) then '[DAJ02]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - No se encuentra el Tipo de organización</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cac:Party)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ03]' else if (boolean(/cn:CreditNote)) then '[CAJ03]' else if (boolean(/dn:DebitNote)) then '[DAJ03]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - No se encuentra el grupo Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AccountingCustomerParty//cac:PartyTaxScheme/cbc:CompanyID"
                 priority="1022"
                 mode="M21">
      <xsl:variable name="nitwithout" select="."/>
      <xsl:variable name="nitwithdv"
                    select="concat(.,'-',cac:AccountingCustomerParty//cac:PartyTaxScheme/cbc:CompanyID/@schemeID)"/>
      <xsl:variable name="a"
                    select="if (boolean(substring($nitwithout,1,1))) then substring($nitwithout,1,1) else 0"/>
      <xsl:variable name="b"
                    select="if (boolean(substring($nitwithout,2,1))) then substring($nitwithout,2,1) else 0"/>
      <xsl:variable name="c"
                    select="if (boolean(substring($nitwithout,3,1))) then substring($nitwithout,3,1) else 0"/>
      <xsl:variable name="d"
                    select="if (boolean(substring($nitwithout,4,1))) then substring($nitwithout,4,1) else 0"/>
      <xsl:variable name="e"
                    select="if (boolean(substring($nitwithout,5,1))) then substring($nitwithout,5,1) else 0"/>
      <xsl:variable name="f"
                    select="if (boolean(substring($nitwithout,6,1))) then substring($nitwithout,6,1) else 0"/>
      <xsl:variable name="g"
                    select="if (boolean(substring($nitwithout,7,1))) then substring($nitwithout,7,1) else 0"/>
      <xsl:variable name="h"
                    select="if (boolean(substring($nitwithout,8,1))) then substring($nitwithout,8,1) else 0"/>
      <xsl:variable name="i"
                    select="if (boolean(substring($nitwithout,9,1))) then substring($nitwithout,9,1) else 0"/>
      <xsl:variable name="j"
                    select="if (boolean(substring($nitwithout,10,1))) then substring($nitwithout,10,1) else 0"/>
      <xsl:variable name="k"
                    select="if (boolean(substring($nitwithout,11,1))) then substring($nitwithout,11,1) else 0"/>
      <xsl:variable name="l"
                    select="if (boolean(substring($nitwithout,12,1))) then substring($nitwithout,12,1) else 0"/>
      <xsl:variable name="m"
                    select="if (boolean(substring($nitwithout,13,1))) then substring($nitwithout,13,1) else 0"/>
      <xsl:variable name="n"
                    select="if (boolean(substring($nitwithout,14,1))) then substring($nitwithout,14,1) else 0"/>
      <xsl:variable name="o"
                    select="if (boolean(substring($nitwithout,15,1))) then substring($nitwithout,15,1) else 0"/>
      <xsl:variable name="p"
                    select="if (number(string-length($nitwithout)) = 5) then (number($a) * 19) + (number($b) * 17) + (number($c) * 13) + (number($d) * 7) + (number($e) * 3) else if (number(string-length($nitwithout)) = 6) then (number($a) * 23) + (number($b) * 19) + (number($c) * 17) + (number($d) * 13) + (number($e) * 7) + (number($f) * 3) else if (number(string-length($nitwithout)) = 7) then (number($a) * 29) + (number($b) * 23) + (number($c) * 19) + (number($d) * 17) + (number($e) * 13) + (number($f) * 7) + (number($g) * 3) else if (number(string-length($nitwithout)) = 8) then (number($a) * 37) + (number($b) * 29) + (number($c) * 23) + (number($d) * 19) + (number($e) * 17) + (number($f) * 13) + (number($g) * 7) + (number($h) * 3) else if (number(string-length($nitwithout)) = 9) then ((number($a) * 41) + (number($b) * 37) + (number($c) * 29) + (number($d) * 23) + (number($e) * 19) + (number($f) * 17) + (number($g) * 13) + (number($h) * 7) + (number($i) * 3)) else if (number(string-length($nitwithout)) = 10) then ((number($a) * 43) + (number($b) * 41) + (number($c) * 37) + (number($d) * 29) + (number($e) * 23) + (number($f) * 19) + (number($g) * 17) + (number($h) * 13) + (number($i) * 7) + (number($j) * 3)) else if (number(string-length($nitwithout)) = 11) then ((number($a) * 47) + (number($b) * 43) + (number($c) * 41) + (number($d) * 37) + (number($e) * 29) + (number($f) * 23) + (number($g) * 19) + (number($h) * 17) + (number($i) * 13) + (number($j) * 7) + (number($k) * 3)) else if (number(string-length($nitwithout)) = 12) then ((number($a) * 53) + (number($b) * 47) + (number($c) * 43) + (number($d) * 41) + (number($e) * 37) + (number($f) * 29) + (number($g) * 23) + (number($h) * 19) + (number($i) * 17) + (number($j) * 13) + (number($k) * 7) + (number($l) * 3)) else if (number(string-length($nitwithout)) = 13) then ((number($a) * 59) + (number($b) * 53) + (number($c) * 47) + (number($d) * 43) + (number($e) * 41) + (number($f) * 37) + (number($g) * 29) + (number($h) * 23) + (number($i) * 19) + (number($j) * 17) + (number($k) * 13) + (number($l) * 7) + (number($m) * 3)) else if (number(string-length($nitwithout)) = 14) then ((number($a) * 67) + (number($b) * 59) + (number($c * 53) + (number($d) * 47) + (number($e) * 43) + (number($f) * 41) + (number($g) * 37) + (number($h) * 29) + (number($i) * 23) + (number($j) * 19) + (number($k) * 17) + (number($l) * 13) + (number($m) * 7) + (number($n) * 3))) else if (number(string-length($nitwithout)) = 15) then ((number($a) * 71) + (number($b) * 67) + (number($c) * 59) + (number($d * 53) + (number($e) * 47) + (number($f) * 43) + (number($g) * 41) + (number($h) * 37) + (number($i) * 29) + (number($j) * 23) + (number($k) * 19) + (number($l) * 17) + (number($m) * 13) + (number($n) * 7) + (number($o) * 3))) else ''"/>
      <xsl:variable name="y" select="$p mod 11"/>
      <xsl:variable name="dv" select="if ($y &gt;= 2) then 11 - $y else $y"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then $dv = ./@schemeID else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAK21]' else if (boolean(/cn:CreditNote)) then '[CAK21]' else if (boolean(/dn:DebitNote)) then '[DAK21]' else ''"/>
               <xsl:text/>
               <xsl:text>-DV del NIT del adquiriente : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="@schemeID"/>
               <xsl:text/>
               <xsl:text>' no está correctamente calculado : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$dv"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then exists(./@schemeID) and ./@schemeID != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAK21]' else if (boolean(/cn:CreditNote)) then '[CAK21]' else if (boolean(/dn:DebitNote)) then '[DAK21]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) NIT del adquiriente debe ser informado con dígito verificador (@schemeName debe ser “31”)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AccountingCustomerParty//cac:PartyLegalEntity/cbc:CompanyID"
                 priority="1021"
                 mode="M21">
      <xsl:variable name="nitwithout" select="."/>
      <xsl:variable name="nitwithdv"
                    select="concat(.,'-',cac:AccountingCustomerParty//cac:PartyLegalEntity/cbc:CompanyID/@schemeID)"/>
      <xsl:variable name="a"
                    select="if (boolean(substring($nitwithout,1,1))) then substring($nitwithout,1,1) else 0"/>
      <xsl:variable name="b"
                    select="if (boolean(substring($nitwithout,2,1))) then substring($nitwithout,2,1) else 0"/>
      <xsl:variable name="c"
                    select="if (boolean(substring($nitwithout,3,1))) then substring($nitwithout,3,1) else 0"/>
      <xsl:variable name="d"
                    select="if (boolean(substring($nitwithout,4,1))) then substring($nitwithout,4,1) else 0"/>
      <xsl:variable name="e"
                    select="if (boolean(substring($nitwithout,5,1))) then substring($nitwithout,5,1) else 0"/>
      <xsl:variable name="f"
                    select="if (boolean(substring($nitwithout,6,1))) then substring($nitwithout,6,1) else 0"/>
      <xsl:variable name="g"
                    select="if (boolean(substring($nitwithout,7,1))) then substring($nitwithout,7,1) else 0"/>
      <xsl:variable name="h"
                    select="if (boolean(substring($nitwithout,8,1))) then substring($nitwithout,8,1) else 0"/>
      <xsl:variable name="i"
                    select="if (boolean(substring($nitwithout,9,1))) then substring($nitwithout,9,1) else 0"/>
      <xsl:variable name="j"
                    select="if (boolean(substring($nitwithout,10,1))) then substring($nitwithout,10,1) else 0"/>
      <xsl:variable name="k"
                    select="if (boolean(substring($nitwithout,11,1))) then substring($nitwithout,11,1) else 0"/>
      <xsl:variable name="l"
                    select="if (boolean(substring($nitwithout,12,1))) then substring($nitwithout,12,1) else 0"/>
      <xsl:variable name="m"
                    select="if (boolean(substring($nitwithout,13,1))) then substring($nitwithout,13,1) else 0"/>
      <xsl:variable name="n"
                    select="if (boolean(substring($nitwithout,14,1))) then substring($nitwithout,14,1) else 0"/>
      <xsl:variable name="o"
                    select="if (boolean(substring($nitwithout,15,1))) then substring($nitwithout,15,1) else 0"/>
      <xsl:variable name="p"
                    select="if (number(string-length($nitwithout)) = 5) then (number($a) * 19) + (number($b) * 17) + (number($c) * 13) + (number($d) * 7) + (number($e) * 3) else if (number(string-length($nitwithout)) = 6) then (number($a) * 23) + (number($b) * 19) + (number($c) * 17) + (number($d) * 13) + (number($e) * 7) + (number($f) * 3) else if (number(string-length($nitwithout)) = 7) then (number($a) * 29) + (number($b) * 23) + (number($c) * 19) + (number($d) * 17) + (number($e) * 13) + (number($f) * 7) + (number($g) * 3) else if (number(string-length($nitwithout)) = 8) then (number($a) * 37) + (number($b) * 29) + (number($c) * 23) + (number($d) * 19) + (number($e) * 17) + (number($f) * 13) + (number($g) * 7) + (number($h) * 3) else if (number(string-length($nitwithout)) = 9) then ((number($a) * 41) + (number($b) * 37) + (number($c) * 29) + (number($d) * 23) + (number($e) * 19) + (number($f) * 17) + (number($g) * 13) + (number($h) * 7) + (number($i) * 3)) else if (number(string-length($nitwithout)) = 10) then ((number($a) * 43) + (number($b) * 41) + (number($c) * 37) + (number($d) * 29) + (number($e) * 23) + (number($f) * 19) + (number($g) * 17) + (number($h) * 13) + (number($i) * 7) + (number($j) * 3)) else if (number(string-length($nitwithout)) = 11) then ((number($a) * 47) + (number($b) * 43) + (number($c) * 41) + (number($d) * 37) + (number($e) * 29) + (number($f) * 23) + (number($g) * 19) + (number($h) * 17) + (number($i) * 13) + (number($j) * 7) + (number($k) * 3)) else if (number(string-length($nitwithout)) = 12) then ((number($a) * 53) + (number($b) * 47) + (number($c) * 43) + (number($d) * 41) + (number($e) * 37) + (number($f) * 29) + (number($g) * 23) + (number($h) * 19) + (number($i) * 17) + (number($j) * 13) + (number($k) * 7) + (number($l) * 3)) else if (number(string-length($nitwithout)) = 13) then ((number($a) * 59) + (number($b) * 53) + (number($c) * 47) + (number($d) * 43) + (number($e) * 41) + (number($f) * 37) + (number($g) * 29) + (number($h) * 23) + (number($i) * 19) + (number($j) * 17) + (number($k) * 13) + (number($l) * 7) + (number($m) * 3)) else if (number(string-length($nitwithout)) = 14) then ((number($a) * 67) + (number($b) * 59) + (number($c * 53) + (number($d) * 47) + (number($e) * 43) + (number($f) * 41) + (number($g) * 37) + (number($h) * 29) + (number($i) * 23) + (number($j) * 19) + (number($k) * 17) + (number($l) * 13) + (number($m) * 7) + (number($n) * 3))) else if (number(string-length($nitwithout)) = 15) then ((number($a) * 71) + (number($b) * 67) + (number($c) * 59) + (number($d * 53) + (number($e) * 47) + (number($f) * 43) + (number($g) * 41) + (number($h) * 37) + (number($i) * 29) + (number($j) * 23) + (number($k) * 19) + (number($l) * 17) + (number($m) * 13) + (number($n) * 7) + (number($o) * 3))) else ''"/>
      <xsl:variable name="y" select="$p mod 11"/>
      <xsl:variable name="dv" select="if ($y &gt;= 2) then 11 - $y else $y"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then $dv = ./@schemeID else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAK44]' else if (boolean(/cn:CreditNote)) then '[CAK44]' else if (boolean(/dn:DebitNote)) then '[DAK44]' else ''"/>
               <xsl:text/>
               <xsl:text>-DV del NIT del adquiriente : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="@schemeID"/>
               <xsl:text/>
               <xsl:text>' no está correctamente calculado : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$dv"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then exists(./@schemeID) and ./@schemeID != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAK44]' else if (boolean(/cn:CreditNote)) then '[CAK44]' else if (boolean(/dn:DebitNote)) then '[DAK44]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) NIT del adquiriente debe ser informado con dígito verificador (@schemeName debe ser “32”)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AccountingCustomerParty" priority="1020" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:AdditionalAccountID) and cbc:AdditionalAccountID != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAK02]' else if (boolean(/cn:CreditNote)) then '[CAK02]' else if (boolean(/dn:DebitNote)) then '[DAK02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) - No se encuentra el Tipo de organización</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cac:Party)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAK03]' else if (boolean(/cn:CreditNote)) then '[CAK03]' else if (boolean(/dn:DebitNote)) then '[DAK03]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - No se encuentra el grupo Party</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:DeliveryParty//cac:PartyTaxScheme/cbc:CompanyID"
                 priority="1019"
                 mode="M21">
      <xsl:variable name="nitwithout" select="."/>
      <xsl:variable name="nitwithdv"
                    select="concat(.,'-',cac:DeliveryParty//cac:PartyTaxScheme/cbc:CompanyID/@schemeID)"/>
      <xsl:variable name="a"
                    select="if (boolean(substring($nitwithout,1,1))) then substring($nitwithout,1,1) else 0"/>
      <xsl:variable name="b"
                    select="if (boolean(substring($nitwithout,2,1))) then substring($nitwithout,2,1) else 0"/>
      <xsl:variable name="c"
                    select="if (boolean(substring($nitwithout,3,1))) then substring($nitwithout,3,1) else 0"/>
      <xsl:variable name="d"
                    select="if (boolean(substring($nitwithout,4,1))) then substring($nitwithout,4,1) else 0"/>
      <xsl:variable name="e"
                    select="if (boolean(substring($nitwithout,5,1))) then substring($nitwithout,5,1) else 0"/>
      <xsl:variable name="f"
                    select="if (boolean(substring($nitwithout,6,1))) then substring($nitwithout,6,1) else 0"/>
      <xsl:variable name="g"
                    select="if (boolean(substring($nitwithout,7,1))) then substring($nitwithout,7,1) else 0"/>
      <xsl:variable name="h"
                    select="if (boolean(substring($nitwithout,8,1))) then substring($nitwithout,8,1) else 0"/>
      <xsl:variable name="i"
                    select="if (boolean(substring($nitwithout,9,1))) then substring($nitwithout,9,1) else 0"/>
      <xsl:variable name="j"
                    select="if (boolean(substring($nitwithout,10,1))) then substring($nitwithout,10,1) else 0"/>
      <xsl:variable name="k"
                    select="if (boolean(substring($nitwithout,11,1))) then substring($nitwithout,11,1) else 0"/>
      <xsl:variable name="l"
                    select="if (boolean(substring($nitwithout,12,1))) then substring($nitwithout,12,1) else 0"/>
      <xsl:variable name="m"
                    select="if (boolean(substring($nitwithout,13,1))) then substring($nitwithout,13,1) else 0"/>
      <xsl:variable name="n"
                    select="if (boolean(substring($nitwithout,14,1))) then substring($nitwithout,14,1) else 0"/>
      <xsl:variable name="o"
                    select="if (boolean(substring($nitwithout,15,1))) then substring($nitwithout,15,1) else 0"/>
      <xsl:variable name="p"
                    select="if (number(string-length($nitwithout)) = 5) then (number($a) * 19) + (number($b) * 17) + (number($c) * 13) + (number($d) * 7) + (number($e) * 3) else if (number(string-length($nitwithout)) = 6) then (number($a) * 23) + (number($b) * 19) + (number($c) * 17) + (number($d) * 13) + (number($e) * 7) + (number($f) * 3) else if (number(string-length($nitwithout)) = 7) then (number($a) * 29) + (number($b) * 23) + (number($c) * 19) + (number($d) * 17) + (number($e) * 13) + (number($f) * 7) + (number($g) * 3) else if (number(string-length($nitwithout)) = 8) then (number($a) * 37) + (number($b) * 29) + (number($c) * 23) + (number($d) * 19) + (number($e) * 17) + (number($f) * 13) + (number($g) * 7) + (number($h) * 3) else if (number(string-length($nitwithout)) = 9) then ((number($a) * 41) + (number($b) * 37) + (number($c) * 29) + (number($d) * 23) + (number($e) * 19) + (number($f) * 17) + (number($g) * 13) + (number($h) * 7) + (number($i) * 3)) else if (number(string-length($nitwithout)) = 10) then ((number($a) * 43) + (number($b) * 41) + (number($c) * 37) + (number($d) * 29) + (number($e) * 23) + (number($f) * 19) + (number($g) * 17) + (number($h) * 13) + (number($i) * 7) + (number($j) * 3)) else if (number(string-length($nitwithout)) = 11) then ((number($a) * 47) + (number($b) * 43) + (number($c) * 41) + (number($d) * 37) + (number($e) * 29) + (number($f) * 23) + (number($g) * 19) + (number($h) * 17) + (number($i) * 13) + (number($j) * 7) + (number($k) * 3)) else if (number(string-length($nitwithout)) = 12) then ((number($a) * 53) + (number($b) * 47) + (number($c) * 43) + (number($d) * 41) + (number($e) * 37) + (number($f) * 29) + (number($g) * 23) + (number($h) * 19) + (number($i) * 17) + (number($j) * 13) + (number($k) * 7) + (number($l) * 3)) else if (number(string-length($nitwithout)) = 13) then ((number($a) * 59) + (number($b) * 53) + (number($c) * 47) + (number($d) * 43) + (number($e) * 41) + (number($f) * 37) + (number($g) * 29) + (number($h) * 23) + (number($i) * 19) + (number($j) * 17) + (number($k) * 13) + (number($l) * 7) + (number($m) * 3)) else if (number(string-length($nitwithout)) = 14) then ((number($a) * 67) + (number($b) * 59) + (number($c * 53) + (number($d) * 47) + (number($e) * 43) + (number($f) * 41) + (number($g) * 37) + (number($h) * 29) + (number($i) * 23) + (number($j) * 19) + (number($k) * 17) + (number($l) * 13) + (number($m) * 7) + (number($n) * 3))) else if (number(string-length($nitwithout)) = 15) then ((number($a) * 71) + (number($b) * 67) + (number($c) * 59) + (number($d * 53) + (number($e) * 47) + (number($f) * 43) + (number($g) * 41) + (number($h) * 37) + (number($i) * 29) + (number($j) * 23) + (number($k) * 19) + (number($l) * 17) + (number($m) * 13) + (number($n) * 7) + (number($o) * 3))) else ''"/>
      <xsl:variable name="y" select="$p mod 11"/>
      <xsl:variable name="dv" select="if ($y &gt;= 2) then 11 - $y else $y"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then $dv = ./@schemeID else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAM31]' else if (boolean(/cn:CreditNote)) then '[CAM31]' else if (boolean(/dn:DebitNote)) then '[DAM31]' else ''"/>
               <xsl:text/>
               <xsl:text>-DV del NIT del transportista : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="@schemeID"/>
               <xsl:text/>
               <xsl:text>' no está correctamente calculado : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$dv"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then exists(./@schemeID) and ./@schemeID != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAM31]' else if (boolean(/cn:CreditNote)) then '[CAM31]' else if (boolean(/dn:DebitNote)) then '[DAM31]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) NIT del transportista debe ser informado con dígito verificador (@schemeName debe ser “32”)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AllowanceCharge[not(ancestor::cac:InvoiceLine) and not(ancestor::cac:DeliveryTerms)]"
                 priority="1018"
                 mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:ChargeIndicator) and cbc:ChargeIndicator = 'true' or cbc:ChargeIndicator = 'false'"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAQ03]' else if (boolean(/cn:CreditNote)) then '[CAQ03]' else if (boolean(/dn:DebitNote)) then '[DAQ03]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Rechazo si este elemento contiene una información diferente de “true” o “false”</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (/ubl:Invoice/cbc:InvoiceTypeCode = '02') then exists(cbc:AllowanceChargeReason) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAQ05]' else if (boolean(/cn:CreditNote)) then '[CAQ05]' else if (boolean(/dn:DebitNote)) then '[DAQ05]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) AllowanceChargeReason Obligatorio si es factura internacional</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:MultiplierFactorNumeric) and number(cbc:MultiplierFactorNumeric) &lt;= 100"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAQ06]' else if (boolean(/cn:CreditNote)) then '[CAQ06]' else if (boolean(/dn:DebitNote)) then '[DAQ06]' else ''"/>
               <xsl:text/>
               <xsl:text>- (N) Notificación: si este elemento &gt; 100 </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (cbc:ChargeIndicator = false()) then number(cbc:Amount) &lt;= number(cbc:BaseAmount) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAQ09]' else if (boolean(/cn:CreditNote)) then '[CAQ09]' else if (boolean(/dn:DebitNote)) then '[DAQ09]' else ''"/>
               <xsl:text/>
               <xsl:text>- (N) Notificación: si monto del descuento </xsl:text>
               <xsl:text/>
               <xsl:value-of select="cbc:Amount"/>
               <xsl:text/>
               <xsl:text> es superior al monto base del calculo del descuento </xsl:text>
               <xsl:text/>
               <xsl:value-of select="cbc:BaseAmount"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then if (cbc:ChargeIndicator = false()) then exists(cbc:AllowanceChargeReasonCode) and cbc:AllowanceChargeReasonCode != '' else true() else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAQ04]' else if (boolean(/cn:CreditNote)) then '[CAQ04]' else if (boolean(/dn:DebitNote)) then '[DAQ04]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Obligatorio de informar si es descuento a nivel de factura.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:TaxTotal[not(ancestor::cac:InvoiceLine)]"
                 priority="1017"
                 mode="M21">
      <xsl:variable name="InvoicedQtyImpTimbre"
                    select="//cac:InvoiceLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:InvoicedQuantity | //cac:CreditNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:CreditedQuantity | //cac:DebitNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:DebitedQuantity"/>
      <xsl:variable name="InvoicedQtyImpBolsa"
                    select="//cac:InvoiceLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:InvoicedQuantity | //cac:CreditNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:CreditedQuantity | //cac:DebitNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:DebitedQuantity"/>
      <xsl:variable name="InvoicedQtyImpCarbono"
                    select="//cac:InvoiceLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:InvoicedQuantity | //cac:CreditNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:CreditedQuantity | //cac:DebitNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:DebitedQuantity"/>
      <xsl:variable name="InvoicedQtyImpCombustible"
                    select="//cac:InvoiceLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:InvoicedQuantity | //cac:CreditNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:CreditedQuantity | //cac:DebitNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:DebitedQuantity"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS02]' else if (boolean(/cn:CreditNote)) then '[CAS02]' else if (boolean(/dn:DebitNote)) then '[DAS02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS02]' else if (boolean(/cn:CreditNote)) then '[CAS02]' else if (boolean(/dn:DebitNote)) then '[DAS02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS02]' else if (boolean(/cn:CreditNote)) then '[CAS02]' else if (boolean(/dn:DebitNote)) then '[DAS02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS02]' else if (boolean(/cn:CreditNote)) then '[CAS02]' else if (boolean(/dn:DebitNote)) then '[DAS02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS02]' else if (boolean(/cn:CreditNote)) then '[CAS02]' else if (boolean(/dn:DebitNote)) then '[DAS02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS02]' else if (boolean(/cn:CreditNote)) then '[CAS02]' else if (boolean(/dn:DebitNote)) then '[DAS02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS02]' else if (boolean(/cn:CreditNote)) then '[CAS02]' else if (boolean(/dn:DebitNote)) then '[DAS02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS02]' else if (boolean(/cn:CreditNote)) then '[CAS02]' else if (boolean(/dn:DebitNote)) then '[DAS02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01') then (every $i in ../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS07]' else if (boolean(/cn:CreditNote)) then '[CAS07]' else if (boolean(/dn:DebitNote)) then '[DAS07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxableAmount * ../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:Percent) div 100))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02') then (every $i in ../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS07]' else if (boolean(/cn:CreditNote)) then '[CAS07]' else if (boolean(/dn:DebitNote)) then '[DAS07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:TaxableAmount * ../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:Percent) div 100))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03') then (every $i in ../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS07]' else if (boolean(/cn:CreditNote)) then '[CAS07]' else if (boolean(/dn:DebitNote)) then '[DAS07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:TaxableAmount * ../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:Percent) div 100))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04') then (every $i in ../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS07]' else if (boolean(/cn:CreditNote)) then '[CAS07]' else if (boolean(/dn:DebitNote)) then '[DAS07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:TaxableAmount * ../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:Percent) div 100))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount) = round(((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:PerUnitAmount * $InvoicedQtyImpBolsa)))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS07]' else if (boolean(/cn:CreditNote)) then '[CAS07]' else if (boolean(/dn:DebitNote)) then '[DAS07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto de la cantidad de items vendidos aplicado sobre el impuesto unico por unidad: </xsl:text>
               <xsl:text/>
               <xsl:value-of select="((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:PerUnitAmount * $InvoicedQtyImpBolsa))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:WithholdingTaxTotal" priority="1016" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05') then round((../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cbc:TaxAmount)) = round(sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cbc:TaxAmount)) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAT02]' else if (boolean(/cn:CreditNote)) then '[CAT02]' else if (boolean(/dn:DebitNote)) then '[DAT02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round((../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cbc:TaxAmount))"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cbc:TaxAmount))"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06') then round((../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cbc:TaxAmount)) = round(sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cbc:TaxAmount)) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAT02]' else if (boolean(/cn:CreditNote)) then '[CAT02]' else if (boolean(/dn:DebitNote)) then '[DAT02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round((../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cbc:TaxAmount))"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cbc:TaxAmount))"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07') then round((../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cbc:TaxAmount)) = round(sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cbc:TaxAmount)) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAT02]' else if (boolean(/cn:CreditNote)) then '[CAT02]' else if (boolean(/dn:DebitNote)) then '[DAT02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round((../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cbc:TaxAmount))"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cbc:TaxAmount))"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05') then (every $i in ../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAT07]' else if (boolean(/cn:CreditNote)) then '[CAT07]' else if (boolean(/dn:DebitNote)) then '[DAT07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06') then (every $i in ../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAT07]' else if (boolean(/cn:CreditNote)) then '[CAT07]' else if (boolean(/dn:DebitNote)) then '[DAT07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07') then (every $i in ../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAT07]' else if (boolean(/cn:CreditNote)) then '[CAT07]' else if (boolean(/dn:DebitNote)) then '[DAT07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PrepaidPayment" priority="1015" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:PaidAmount) and cbc:PaidAmount != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FBD03]' else if (boolean(/cn:CreditNote)) then '[CBD03]' else if (boolean(/dn:DebitNote)) then '[DBD03]' else ''"/>
               <xsl:text/>
               <xsl:text> (N) - No se encuentra el campo cbc:PaidAmount</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(cbc:PaidAmount) &lt; number(../..//cac:LegalMonetaryTotal/cbc:LineExtensionAmount)"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FBD03]' else if (boolean(/cn:CreditNote)) then '[CBD03]' else if (boolean(/dn:DebitNote)) then '[DBD03]' else ''"/>
               <xsl:text/>
               <xsl:text> (N) - Notificación: si PrepaidPayment/cbc:PaidAmount </xsl:text>
               <xsl:text/>
               <xsl:value-of select="./cbc:PaidAmount"/>
               <xsl:text/>
               <xsl:text> &gt; LegalMonetaryTotal/cbc:LineExtensionAmount </xsl:text>
               <xsl:text/>
               <xsl:value-of select="number(../..//cac:LegalMonetaryTotal/cbc:LineExtensionAmount)"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PaymentExchangeRate" priority="1014" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:SourceCurrencyCode) and cbc:SourceCurrencyCode != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAR02]' else if (boolean(/cn:CreditNote)) then '[CAR02]' else if (boolean(/dn:DebitNote)) then '[DAR02]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - No se encuentra el campo cbc:SourceCurrencyCode</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cbc:SourceCurrencyCode = //cbc:DocumentCurrencyCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAR02]' else if (boolean(/cn:CreditNote)) then '[CAR02]' else if (boolean(/dn:DebitNote)) then '[DAR02]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - Rechazo si : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="cbc:SourceCurrencyCode"/>
               <xsl:text/>
               <xsl:text>' no es igual al elemento cbc:DocumentCurrencyCode : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="//cbc:DocumentCurrencyCode"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cbc:SourceCurrencyBaseRate = 1.00"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAR03]' else if (boolean(/cn:CreditNote)) then '[CAR03]' else if (boolean(/dn:DebitNote)) then '[DAR03]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - Rechazo si trae valor : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="cbc:SourceCurrencyBaseRate"/>
               <xsl:text/>
               <xsl:text>' diferente a 1.00</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (//cbc:DocumentCurrencyCode != 'COP') then (cbc:TargetCurrencyCode = 'COP') else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAR04]' else if (boolean(/cn:CreditNote)) then '[CAR04]' else if (boolean(/dn:DebitNote)) then '[DAR04]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - Debe ir diligenciado en COP, si el cbc:DocumentCurrencyCode es diferente a COP</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="cbc:TargetCurrencyBaseRate = 1.00"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAR05]' else if (boolean(/cn:CreditNote)) then '[CAR05]' else if (boolean(/dn:DebitNote)) then '[DAR05]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - Rechazo si trae valor : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="cbc:TargetCurrencyBaseRate"/>
               <xsl:text/>
               <xsl:text>' diferente a 1.00</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:CalculationRate) and cbc:CalculationRate != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAR06]' else if (boolean(/cn:CreditNote)) then '[CAR06]' else if (boolean(/dn:DebitNote)) then '[DAR06]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - No se encuentra el campo cbc:CalculationRate</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:Date) and cbc:Date != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAR07]' else if (boolean(/cn:CreditNote)) then '[CAR07]' else if (boolean(/dn:DebitNote)) then '[DAR07]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - No se encuentra el campo cbc:Date</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:LegalMonetaryTotal[not(ancestor::sts:DianExtensions)]/cbc:LineExtensionAmount | cac:RequestedMonetaryTotal/cbc:LineExtensionAmount"
                 priority="1013"
                 mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then round(.) = round((sum(../../cac:InvoiceLine/cbc:LineExtensionAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAU02]- (R) Valor bruto total de la factura antes de tributos </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente de la suma de los valores de las líneas de la factura que contienen valor comercial: </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round((sum(../..//cac:InvoiceLine/cbc:LineExtensionAmount)))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/cn:CreditNote)) then round(.) = round((sum(../../cac:CreditNoteLine/cbc:LineExtensionAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[CAU02]- (R) Valor bruto total de la factura antes de tributos </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente de la suma de los valores de las líneas de la factura que contienen valor comercial: </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round((sum(../..//cac:InvoiceLine/cbc:LineExtensionAmount)))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/dn:DebitNote)) then round(.) = round((sum(../../cac:DebitNoteLine/cbc:LineExtensionAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DAU02]- (R) Valor bruto total de la factura antes de tributos </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente de la suma de los valores de las líneas de la factura que contienen valor comercial: </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round((sum(../..//cac:InvoiceLine/cbc:LineExtensionAmount)))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:LegalMonetaryTotal[not(ancestor::sts:DianExtensions)]/cbc:TaxExclusiveAmount | cac:RequestedMonetaryTotal/cbc:TaxExclusiveAmount"
                 priority="1012"
                 mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then round(.) = round(sum(../../cac:InvoiceLine/cac:TaxTotal[1]/cac:TaxSubtotal/cbc:TaxableAmount)) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAU03]- (R) Base imponible para el cálculo de los tributos '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text>' diferente del valor bruto total de la factura, sumado a los cargos totales a la facutra, y restado de los descuentos totales a la factura : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(sum(../../cac:InvoiceLine/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount))"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/cn:CreditNote)) then round(.) = round(sum(../../cac:CreditNoteLine/cac:TaxTotal[1]/cac:TaxSubtotal/cbc:TaxableAmount)) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[CAU03]- (R) Base imponible para el cálculo de los tributos '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text>' diferente del valor bruto total de la factura, sumado a los cargos totales a la facutra, y restado de los descuentos totales a la factura : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(sum(../../cac:CreditNoteLine/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount))"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/dn:DebitNote)) then round(.) = round(sum(../../cac:DebitNoteLine/cac:TaxTotal[1]/cac:TaxSubtotal/cbc:TaxableAmount)) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DAU03]- (R) Base imponible para el cálculo de los tributos '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text>' diferente del valor bruto total de la factura, sumado a los cargos totales a la facutra, y restado de los descuentos totales a la factura : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(sum(../../cac:DebitNoteLine/cac:TaxTotal/cac:TaxSubtotal/cbc:TaxableAmount))"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:LegalMonetaryTotal[not(ancestor::sts:DianExtensions)]/cbc:TaxInclusiveAmount | cac:RequestedMonetaryTotal/cbc:TaxInclusiveAmount"
                 priority="1011"
                 mode="M21">
      <xsl:variable name="SumGlobalTaxFE"
                    select="sum(../..//cac:TaxTotal[not(ancestor::cac:InvoiceLine)]/cbc:TaxAmount)"/>
      <xsl:variable name="SumGlobalTaxNC"
                    select="sum(../..//cac:TaxTotal[not(ancestor::cac:CreditNoteLine)]/cbc:TaxAmount)"/>
      <xsl:variable name="SumGlobalTaxND"
                    select="sum(../..//cac:TaxTotal[not(ancestor::cac:DebitNoteLine)]/cbc:TaxAmount)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then round(number(../cbc:LineExtensionAmount + $SumGlobalTaxFE)) = round(number(.)) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAU04]- (R) Monto Incluyendo Impuesto </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente del valor bruto total de la factura, sumado a los cargos totales a la facutra, y restado de los descuentos totales a la factura : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round((../cbc:LineExtensionAmount + $SumGlobalTaxFE))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/cn:CreditNote)) then round(number(../cbc:LineExtensionAmount + $SumGlobalTaxNC)) = round(number(.)) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[CAU04]- (R) Monto Incluyendo Impuesto </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente del valor bruto total de la factura, sumado a los cargos totales a la facutra, y restado de los descuentos totales a la factura : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round((../cbc:LineExtensionAmount + $SumGlobalTaxFE))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/dn:DebitNote)) then round(number(../cbc:LineExtensionAmount + $SumGlobalTaxND)) = round(number(.)) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DAU04]- (R) Monto Incluyendo Impuesto </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente del valor bruto total de la factura, sumado a los cargos totales a la facutra, y restado de los descuentos totales a la factura : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round((../cbc:LineExtensionAmount + $SumGlobalTaxFE))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:LegalMonetaryTotal[not(ancestor::sts:DianExtensions)]/cbc:AllowanceTotalAmount | cac:RequestedMonetaryTotal/cbc:AllowanceTotalAmount"
                 priority="1010"
                 mode="M21">
      <xsl:variable name="SumTotalAllowanceFE"
                    select="sum(../..//cac:AllowanceCharge[not(ancestor::cac:InvoiceLine) and not(ancestor::cac:DeliveryTerms)][cbc:ChargeIndicator = 'false']/cbc:Amount)"/>
      <xsl:variable name="SumTotalAllowanceNC"
                    select="sum(../..//cac:AllowanceCharge[not(ancestor::cac:CreditNoteLine) and not(ancestor::cac:DeliveryTerms)][cbc:ChargeIndicator = 'false']/cbc:Amount)"/>
      <xsl:variable name="SumTotalAllowanceND"
                    select="sum(../..//cac:AllowanceCharge[not(ancestor::cac:DebitNoteLine) and not(ancestor::cac:DeliveryTerms)][cbc:ChargeIndicator = 'false']/cbc:Amount)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then round(.) = round($SumTotalAllowanceFE) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAU05]- (R) Total descuentos </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente de la suma de todos los descuentos aplicados al total de la factura : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round($SumTotalAllowanceFE)"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/cn:CreditNote)) then round(.) = round($SumTotalAllowanceNC) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[CAU05]- (R) Total descuentos </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente de la suma de todos los descuentos aplicados al total de la factura : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round($SumTotalAllowanceNC)"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/dn:DebitNote)) then round(.) = round($SumTotalAllowanceND) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DAU05]- (R) Total descuentos </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente de la suma de todos los descuentos aplicados al total de la factura : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round($SumTotalAllowanceND)"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:LegalMonetaryTotal[not(ancestor::sts:DianExtensions)]/cbc:ChargeTotalAmount | cac:RequestedMonetaryTotal/cbc:ChargeTotalAmount"
                 priority="1009"
                 mode="M21">
      <xsl:variable name="SumTotalChargeFE"
                    select="sum(../..//cac:AllowanceCharge[not(ancestor::cac:InvoiceLine) and not(ancestor::cac:DeliveryTerms)][cbc:ChargeIndicator = 'true']/cbc:Amount)"/>
      <xsl:variable name="SumTotalChargeNC"
                    select="sum(../..//cac:AllowanceCharge[not(ancestor::cac:CreditNoteLine) and not(ancestor::cac:DeliveryTerms)][cbc:ChargeIndicator = 'true']/cbc:Amount)"/>
      <xsl:variable name="SumTotalChargeND"
                    select="sum(../..//cac:AllowanceCharge[not(ancestor::cac:DebitNoteLine) and not(ancestor::cac:DeliveryTerms)][cbc:ChargeIndicator = 'true']/cbc:Amount)"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then round(.) = round($SumTotalChargeFE) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAU06]- (R) Total cargos </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente de la suma de todos los cargos aplicados al total de la factura : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round($SumTotalChargeFE)"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/cn:CreditNote)) then round(.) = round($SumTotalChargeNC) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[CAU06]- (R) Total cargos </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente de la suma de todos los cargos aplicados al total de la factura : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round($SumTotalChargeNC)"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/dn:DebitNote)) then round(.) = round($SumTotalChargeND) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DAU06]- (R) Total cargos </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text> diferente de la suma de todos los cargos aplicados al total de la factura : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="round($SumTotalChargeND)"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:LegalMonetaryTotal[not(ancestor::sts:DianExtensions)]/cbc:PrepaidPayment | cac:RequestedMonetaryTotal/cbc:PrepaidPayment"
                 priority="1008"
                 mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="round(.) = round(sum(../..//cac:PrepaidPayment/cbc:PaidAmount))"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAU07]- (R) Rechazo si LegalMonetaryTotal/cbc:PrepaidAmount : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(.)"/>
               <xsl:text/>
               <xsl:text>' no es la suma de los elementos : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="round(sum(../..//cac:PrepaidPayment/cbc:PaidAmount))"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:LegalMonetaryTotal[not(ancestor::sts:DianExtensions)]/cbc:PayableAmount | cac:RequestedMonetaryTotal/cbc:PayableAmount"
                 priority="1007"
                 mode="M21">
      <xsl:variable name="TaxInclusiveAmount"
                    select="if (boolean(../cbc:TaxInclusiveAmount)) then round(../cbc:TaxInclusiveAmount) else 0.00"/>
      <xsl:variable name="SumTotalAllowance"
                    select="if (boolean(../cbc:AllowanceTotalAmount)) then round(../cbc:AllowanceTotalAmount) else 0.00"/>
      <xsl:variable name="SumTotalCharge"
                    select="if (boolean(../cbc:ChargeTotalAmount)) then round(../cbc:ChargeTotalAmount) else 0.00"/>
      <xsl:variable name="PrepaidAmount"
                    select="if (boolean(../cbc:PrepaidAmount)) then round(sum(../cbc:PrepaidAmount)) else 0.00"/>
      <xsl:variable name="PayableRoundingAmount"
                    select="if (boolean(../cbc:PayableRoundingAmount)) then round(sum(../cbc:PayableRoundingAmount)) else 0.00"/>
      <xsl:variable name="PayableAmount"
                    select="format-number(xs:decimal($TaxInclusiveAmount - $SumTotalAllowance + $SumTotalCharge - $PrepaidAmount + $PayableRoundingAmount),'#0.00')"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (not(/app:ApplicationResponse)) then round(.) = round(number($PayableAmount)) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAR08]' else if (boolean(/cn:CreditNote)) then '[CAR08]' else if (boolean(/dn:DebitNote)) then '[DAR08]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Total de la factura </xsl:text>
               <xsl:text/>
               <xsl:value-of select="format-number(round(.),'#0.00')"/>
               <xsl:text/>
               <xsl:text> diferente de la suma de Total valor bruto + Total Tributos - Total Tributo Retenidos - Anticipos (+/-) Redondeos : </xsl:text>
               <xsl:text/>
               <xsl:value-of select="$PayableAmount"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:InvoiceLine | cac:CreditNoteLine | cac:DebitNoteLine"
                 priority="1006"
                 mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(cbc:ID) = count(distinct-values(cbc:ID))"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAV02]' else if (boolean(/cn:CreditNote)) then '[CAV02]' else if (boolean(/dn:DebitNote)) then '[DAV02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (N) Más de un grupo conteniendo el elemento /Invoice/cac:InvoiceLine/cbc:ID con la misma información</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(ubl:Invoice)) then ../cac:InvoiceLine[last()]/cbc:ID = count(../cac:InvoiceLine) else if (boolean(cn:CreditNote)) then ../cac:CreditNoteLine[last()]/cbc:ID = count(../cac:CreditNoteLine) else if (boolean(dn:DebitNote)) then ../cac:DebitNoteLine[last()]/cbc:ID = count(../cac:DebitNoteLine) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAV02]' else if (boolean(/cn:CreditNote)) then '[CAV02]' else if (boolean(/dn:DebitNote)) then '[DAV02]' else ''"/>
               <xsl:text/>
               <xsl:text>- '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="concat('Linea : ',cbc:ID)"/>
               <xsl:text/>
               <xsl:text>'- (N) Los números de línea de factura utilizados en los diferentes grupos no son consecutivos, empezando con “1”</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:LineExtensionAmount) and cbc:LineExtensionAmount != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAV06]' else if (boolean(/cn:CreditNote)) then '[CAV06]' else if (boolean(/dn:DebitNote)) then '[DAV06]' else ''"/>
               <xsl:text/>
               <xsl:text>- '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="concat('Linea : ',cbc:ID)"/>
               <xsl:text/>
               <xsl:text>'- (N) No se encuentra el campo cbc:LineExtensionAmount</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(cac:AllowanceCharge[cbc:ChargeIndiator = 'false']) and boolean(cac:AllowanceCharge[cbc:ChargeIndicator = 'true'])) then round(cbc:LineExtensionAmount) = round(((cac:Price/cbc:PriceAmount * cac:Price/cbc:BaseQuantity) + cac:AllowanceCharge[cbc:ChargeIndicator = 'true']/cbc:Amount - cac:AllowanceCharge[cbc:ChargeIndicator = 'false']/cbc:Amount)) else if (boolean(cac:AllowanceCharge[cbc:ChargeIndiator = 'false'])) then round(cbc:LineExtensionAmount) = round(((cac:Price/cbc:PriceAmount * cac:Price/cbc:BaseQuantity) - cac:AllowanceCharge[cbc:ChargeIndiator = 'false']/cbc:Amount)) else if (boolean(cac:AllowanceCharge[cbc:ChargeIndiator = 'true'])) then round(cbc:LineExtensionAmount) = round(((cac:Price/cbc:PriceAmount * cac:Price/cbc:BaseQuantity ) + cac:AllowanceCharge[cbc:ChargeIndiator = 'true']/cbc:Amount)) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAV06]' else if (boolean(/cn:CreditNote)) then '[CAV06]' else if (boolean(/dn:DebitNote)) then '[DAV06]' else ''"/>
               <xsl:text/>
               <xsl:text>- '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="concat('Linea : ',cbc:ID)"/>
               <xsl:text/>
               <xsl:text>'- (N) Valor total de la línea, libre de tributos, diferente del producto de la cantidad por el precio unitario, considerados los cargos y los descuentos aplicados en esta línea</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cac:Item/cbc:Description) and cac:Item/cbc:Description != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAZ02]' else if (boolean(/cn:CreditNote)) then '[CAZ02]' else if (boolean(/dn:DebitNote)) then '[DAZ02]' else ''"/>
               <xsl:text/>
               <xsl:text>- '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="concat('Linea : ',cbc:ID)"/>
               <xsl:text/>
               <xsl:text>'- (N) No se encuentra el campo cbc:Description</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cac:Price/cbc:PriceAmount) and cac:Price/cbc:PriceAmount != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FBB02]' else if (boolean(/cn:CreditNote)) then '[CBB02]' else if (boolean(/dn:DebitNote)) then '[DBB02]' else ''"/>
               <xsl:text/>
               <xsl:text>- '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="concat('Linea : ',cbc:ID)"/>
               <xsl:text/>
               <xsl:text>'- (N) No se encuentra el campo cbc:PriceAmount</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:InvoicedQuantity) and cbc:InvoicedQuantity != '' or exists(cbc:CreditedQuantity) and cbc:CreditedQuantity != '' or exists(cbc:DebitedQuantity) and cbc:DebitedQuantity != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAV04]' else if (boolean(/cn:CreditNote)) then '[CAV04]' else if (boolean(/dn:DebitNote)) then '[DAV04]' else ''"/>
               <xsl:text/>
               <xsl:text>- '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="concat('Linea : ',cbc:ID)"/>
               <xsl:text/>
               <xsl:text>'- (N) No se encuentra el campo cbc:InvoicedQuantity</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cac:Price/cbc:BaseQuantity) and cac:Price/cbc:BaseQuantity != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FBB04]' else if (boolean(/cn:CreditNote)) then '[CBB04]' else if (boolean(/dn:DebitNote)) then '[DBB04]' else ''"/>
               <xsl:text/>
               <xsl:text>- '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="concat('Linea : ',cbc:ID)"/>
               <xsl:text/>
               <xsl:text>' - (N) No se encuentra el campo cbc:BaseQuantity</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:InvoiceLine/cac:AllowanceCharge"
                 priority="1005"
                 mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:ChargeIndicator) and cbc:ChargeIndicator = 'true' or cbc:ChargeIndicator = 'false'"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX03]' else if (boolean(/cn:CreditNote)) then '[CAX03]' else if (boolean(/dn:DebitNote)) then '[DAX03]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - Rechazo si este elemento contiene una información diferente de “true” o “false”</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (/ubl:Invoice/cbc:InvoiceTypeCode = '02') then exists(cbc:AllowanceChargeReason) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX04]' else if (boolean(/cn:CreditNote)) then '[CAX04]' else if (boolean(/dn:DebitNote)) then '[DAX04]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) - AllowanceChargeReason Obligatorio si es factura internacional</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (cbc:ChargeIndicator = false()) then number(cbc:Amount) &lt;= number(cbc:BaseAmount) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX06]' else if (boolean(/cn:CreditNote)) then '[CAX06]' else if (boolean(/dn:DebitNote)) then '[DAX06]' else ''"/>
               <xsl:text/>
               <xsl:text> (N) -Notificación: si monto del descuento es superior al monto base del calculo del descuento</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:MultiplierFactorNumeric) and cbc:MultiplierFactorNumeric != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX05]' else if (boolean(/cn:CreditNote)) then '[CAX05]' else if (boolean(/dn:DebitNote)) then '[DAX05]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) -No se encuentra cbc:MultiplierFactorNumeric</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="number(cbc:MultiplierFactorNumeric) &lt;= 100"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX05]' else if (boolean(/cn:CreditNote)) then '[CAX05]' else if (boolean(/dn:DebitNote)) then '[DAX05]' else ''"/>
               <xsl:text/>
               <xsl:text> (R) -Notificación: si cbc:MultiplierFactorNumeric : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="./cbc:MultiplierFactorNumeric"/>
               <xsl:text/>
               <xsl:text>' &gt; 100 </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:InvoiceLine/cac:TaxTotal | cac:CreditNoteLine/cac:TaxTotal | cac:DebitNoteLine/cac:TaxTotal"
                 priority="1004"
                 mode="M21">
      <xsl:variable name="InvoicedQtyImpTimbreFE"
                    select="//cac:InvoiceLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:InvoicedQuantity"/>
      <xsl:variable name="InvoicedQtyImpTimbreNC"
                    select="//cac:CreditNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:CreditedQuantity"/>
      <xsl:variable name="InvoicedQtyImpTimbreND"
                    select="//cac:DebitNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:DebitedQuantity"/>
      <xsl:variable name="InvoicedQtyImpBolsaFE"
                    select="//cac:InvoiceLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:InvoicedQuantity"/>
      <xsl:variable name="InvoicedQtyImpBolsaNC"
                    select="//cac:CreditNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:CreditedQuantity"/>
      <xsl:variable name="InvoicedQtyImpBolsaND"
                    select="//cac:DebitNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:DebitedQuantity"/>
      <xsl:variable name="InvoicedQtyImpCarbonoFE"
                    select="//cac:InvoiceLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:InvoicedQuantity"/>
      <xsl:variable name="InvoicedQtyImpCarbonoNC"
                    select="//cac:CreditNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:CreditedQuantity"/>
      <xsl:variable name="InvoicedQtyImpCarbonoND"
                    select="//cac:DebitNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:DebitedQuantity"/>
      <xsl:variable name="InvoicedQtyImpCombustibleFE"
                    select="//cac:InvoiceLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:InvoicedQuantity"/>
      <xsl:variable name="InvoicedQtyImpCombustibleNC"
                    select="//cac:CreditNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:CreditedQuantity"/>
      <xsl:variable name="InvoicedQtyImpCombustibleND"
                    select="//cac:DebitNoteLine[cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:DebitedQuantity"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX02]' else if (boolean(/cn:CreditNote)) then '[CAX02]' else if (boolean(/dn:DebitNote)) then '[DAX02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX02]' else if (boolean(/cn:CreditNote)) then '[CAX02]' else if (boolean(/dn:DebitNote)) then '[DAX02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX02]' else if (boolean(/cn:CreditNote)) then '[CAX02]' else if (boolean(/dn:DebitNote)) then '[DAX02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX02]' else if (boolean(/cn:CreditNote)) then '[CAX02]' else if (boolean(/dn:DebitNote)) then '[DAX02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX02]' else if (boolean(/cn:CreditNote)) then '[CAX02]' else if (boolean(/dn:DebitNote)) then '[DAX02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '21']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX02]' else if (boolean(/cn:CreditNote)) then '[CAX02]' else if (boolean(/dn:DebitNote)) then '[DAX02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX02]' else if (boolean(/cn:CreditNote)) then '[CAX02]' else if (boolean(/dn:DebitNote)) then '[DAX02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '23']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:TaxAmount) = round(sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX02]' else if (boolean(/cn:CreditNote)) then '[CAX02]' else if (boolean(/dn:DebitNote)) then '[DAX02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '24']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01') then (every $i in ../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX07]' else if (boolean(/cn:CreditNote)) then '[CAX07]' else if (boolean(/dn:DebitNote)) then '[DAX07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02') then (every $i in ../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX07]' else if (boolean(/cn:CreditNote)) then '[CAX07]' else if (boolean(/dn:DebitNote)) then '[DAX07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '02']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03') then (every $i in ../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX07]' else if (boolean(/cn:CreditNote)) then '[CAX07]' else if (boolean(/dn:DebitNote)) then '[DAX07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '03']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04') then (every $i in ../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX07]' else if (boolean(/cn:CreditNote)) then '[CAX07]' else if (boolean(/dn:DebitNote)) then '[DAX07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '04']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount) = round(((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:PerUnitAmount * $InvoicedQtyImpBolsaFE)))) else true() else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX07]' else if (boolean(/cn:CreditNote)) then '[CAX07]' else if (boolean(/dn:DebitNote)) then '[DAX07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto de la cantidad de items vendidos aplicado sobre el impuesto unico por unidad: </xsl:text>
               <xsl:text/>
               <xsl:value-of select="((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:PerUnitAmount * $InvoicedQtyImpBolsaFE))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/cn:CreditNote)) then if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount) = round(((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:PerUnitAmount * $InvoicedQtyImpBolsaNC)))) else true() else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX07]' else if (boolean(/cn:CreditNote)) then '[CAX07]' else if (boolean(/dn:DebitNote)) then '[DAX07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto de la cantidad de items vendidos aplicado sobre el impuesto unico por unidad: </xsl:text>
               <xsl:text/>
               <xsl:value-of select="((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:PerUnitAmount * $InvoicedQtyImpBolsaNC))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/dn:DebitNote)) then if (../cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22') then (round(../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount) = round(((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:PerUnitAmount * $InvoicedQtyImpBolsaND)))) else true() else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX07]' else if (boolean(/cn:CreditNote)) then '[CAX07]' else if (boolean(/dn:DebitNote)) then '[DAX07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:TaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto de la cantidad de items vendidos aplicado sobre el impuesto unico por unidad: </xsl:text>
               <xsl:text/>
               <xsl:value-of select="((../cac:TaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '22']/cbc:PerUnitAmount * $InvoicedQtyImpBolsaND))"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice)) then if (cac:TaxSubtotal/cbc:PerUnitAmount != '') then cac:TaxSubtotal/cbc:BaseUnitMeasure != '' and cac:TaxSubtotal/cbc:BaseUnitMeasure/@unitCode != '' else true() else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAX09]' else if (boolean(/cn:CreditNote)) then '[CAX09]' else if (boolean(/dn:DebitNote)) then '[DAX09]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) PerUnitAmount y la Unidad de medida no se encuentra informada</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:InvoiceLine/cac:WithholdingTaxTotal"
                 priority="1003"
                 mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05') then (round(../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cbc:TaxAmount) = round(sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAY02]' else if (boolean(/cn:CreditNote)) then '[CAY02]' else if (boolean(/dn:DebitNote)) then '[DAY02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06') then (round(../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cbc:TaxAmount) = round(sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAY02]' else if (boolean(/cn:CreditNote)) then '[CAY02]' else if (boolean(/dn:DebitNote)) then '[DAY02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07') then (round(../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cbc:TaxAmount) = round(sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cbc:TaxAmount))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAY02]' else if (boolean(/cn:CreditNote)) then '[CAY02]' else if (boolean(/dn:DebitNote)) then '[DAY02]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Valor total de un tributo : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text>' no corresponde a la suma de todas las informaciones correspondentes a cada una de las tarifas informadas en este documento para este tributo: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="sum(../cac:WithholdingTaxTotal/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cbc:TaxAmount)"/>
               <xsl:text/>
               <xsl:text>' </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05') then (every $i in ../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAY07]' else if (boolean(/cn:CreditNote)) then '[CAY07]' else if (boolean(/dn:DebitNote)) then '[DAY07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06') then (every $i in ../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAY07]' else if (boolean(/cn:CreditNote)) then '[CAY07]' else if (boolean(/dn:DebitNote)) then '[DAY07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '06']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07') then (every $i in ../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cac:TaxSubtotal satisfies round($i/cbc:TaxAmount) = round((($i/cbc:TaxableAmount * $i/cac:TaxCategory/cbc:Percent) div 100))) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAY07]' else if (boolean(/cn:CreditNote)) then '[CAY07]' else if (boolean(/dn:DebitNote)) then '[DAY07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) El valor del tributo correspondiente a una de las tarifas </xsl:text>
               <xsl:text/>
               <xsl:value-of select="../cac:WithholdingTaxTotal[cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '07']/cbc:TaxAmount"/>
               <xsl:text/>
               <xsl:text> es diferente del producto del porcentaje aplicado sobre la base imponible</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (../cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05') then every $i in ../cac:WithholdingTaxTotal satisfies if ($i/cac:TaxSubtotal/cac:TaxCategory/cac:TaxScheme/cbc:ID = '05') then $i/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '05']/cbc:TaxableAmount = $i/cac:TaxSubtotal[cac:TaxCategory/cac:TaxScheme/cbc:ID = '01']/cbc:TaxAmount else true() else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAY07]' else if (boolean(/cn:CreditNote)) then '[CAY07]' else if (boolean(/dn:DebitNote)) then '[DAY07]' else ''"/>
               <xsl:text/>
               <xsl:text>- (N) El Monto Tributable de la Retencion IVA no es igual al Monto del IVA de alguna linea</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Item" priority="1002" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (/ubl:Invoice/cbc:InvoiceTypeCode = '02') then exists(cbc:BrandName) and cbc:BrandName != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text>[FAZ04]- (N) Debe ser informada la marca del artículo en caso de factura internacional</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (/ubl:Invoice/cbc:InvoiceTypeCode = '02') then exists(cbc:ModelName) and cbc:ModelName != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text>[FAZ05]- (N) Debe ser informado el modelo del artículo en caso de factura internacional</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PowerOfAttorney/cac:AgentParty/cac:PartyIdentification/cbc:ID"
                 priority="1001"
                 mode="M21">
      <xsl:variable name="nitwithout" select="."/>
      <xsl:variable name="nitwithdv"
                    select="concat(.,'-',cac:PowerOfAttorney/cac:AgentParty/cac:PartyIdentification/cbc:ID/@schemeID)"/>
      <xsl:variable name="a"
                    select="if (boolean(substring($nitwithout,1,1))) then substring($nitwithout,1,1) else 0"/>
      <xsl:variable name="b"
                    select="if (boolean(substring($nitwithout,2,1))) then substring($nitwithout,2,1) else 0"/>
      <xsl:variable name="c"
                    select="if (boolean(substring($nitwithout,3,1))) then substring($nitwithout,3,1) else 0"/>
      <xsl:variable name="d"
                    select="if (boolean(substring($nitwithout,4,1))) then substring($nitwithout,4,1) else 0"/>
      <xsl:variable name="e"
                    select="if (boolean(substring($nitwithout,5,1))) then substring($nitwithout,5,1) else 0"/>
      <xsl:variable name="f"
                    select="if (boolean(substring($nitwithout,6,1))) then substring($nitwithout,6,1) else 0"/>
      <xsl:variable name="g"
                    select="if (boolean(substring($nitwithout,7,1))) then substring($nitwithout,7,1) else 0"/>
      <xsl:variable name="h"
                    select="if (boolean(substring($nitwithout,8,1))) then substring($nitwithout,8,1) else 0"/>
      <xsl:variable name="i"
                    select="if (boolean(substring($nitwithout,9,1))) then substring($nitwithout,9,1) else 0"/>
      <xsl:variable name="j"
                    select="if (boolean(substring($nitwithout,10,1))) then substring($nitwithout,10,1) else 0"/>
      <xsl:variable name="k"
                    select="if (boolean(substring($nitwithout,11,1))) then substring($nitwithout,11,1) else 0"/>
      <xsl:variable name="l"
                    select="if (boolean(substring($nitwithout,12,1))) then substring($nitwithout,12,1) else 0"/>
      <xsl:variable name="m"
                    select="if (boolean(substring($nitwithout,13,1))) then substring($nitwithout,13,1) else 0"/>
      <xsl:variable name="n"
                    select="if (boolean(substring($nitwithout,14,1))) then substring($nitwithout,14,1) else 0"/>
      <xsl:variable name="o"
                    select="if (boolean(substring($nitwithout,15,1))) then substring($nitwithout,15,1) else 0"/>
      <xsl:variable name="p"
                    select="if (number(string-length($nitwithout)) = 5) then (number($a) * 19) + (number($b) * 17) + (number($c) * 13) + (number($d) * 7) + (number($e) * 3) else if (number(string-length($nitwithout)) = 6) then (number($a) * 23) + (number($b) * 19) + (number($c) * 17) + (number($d) * 13) + (number($e) * 7) + (number($f) * 3) else if (number(string-length($nitwithout)) = 7) then (number($a) * 29) + (number($b) * 23) + (number($c) * 19) + (number($d) * 17) + (number($e) * 13) + (number($f) * 7) + (number($g) * 3) else if (number(string-length($nitwithout)) = 8) then (number($a) * 37) + (number($b) * 29) + (number($c) * 23) + (number($d) * 19) + (number($e) * 17) + (number($f) * 13) + (number($g) * 7) + (number($h) * 3) else if (number(string-length($nitwithout)) = 9) then ((number($a) * 41) + (number($b) * 37) + (number($c) * 29) + (number($d) * 23) + (number($e) * 19) + (number($f) * 17) + (number($g) * 13) + (number($h) * 7) + (number($i) * 3)) else if (number(string-length($nitwithout)) = 10) then ((number($a) * 43) + (number($b) * 41) + (number($c) * 37) + (number($d) * 29) + (number($e) * 23) + (number($f) * 19) + (number($g) * 17) + (number($h) * 13) + (number($i) * 7) + (number($j) * 3)) else if (number(string-length($nitwithout)) = 11) then ((number($a) * 47) + (number($b) * 43) + (number($c) * 41) + (number($d) * 37) + (number($e) * 29) + (number($f) * 23) + (number($g) * 19) + (number($h) * 17) + (number($i) * 13) + (number($j) * 7) + (number($k) * 3)) else if (number(string-length($nitwithout)) = 12) then ((number($a) * 53) + (number($b) * 47) + (number($c) * 43) + (number($d) * 41) + (number($e) * 37) + (number($f) * 29) + (number($g) * 23) + (number($h) * 19) + (number($i) * 17) + (number($j) * 13) + (number($k) * 7) + (number($l) * 3)) else if (number(string-length($nitwithout)) = 13) then ((number($a) * 59) + (number($b) * 53) + (number($c) * 47) + (number($d) * 43) + (number($e) * 41) + (number($f) * 37) + (number($g) * 29) + (number($h) * 23) + (number($i) * 19) + (number($j) * 17) + (number($k) * 13) + (number($l) * 7) + (number($m) * 3)) else if (number(string-length($nitwithout)) = 14) then ((number($a) * 67) + (number($b) * 59) + (number($c * 53) + (number($d) * 47) + (number($e) * 43) + (number($f) * 41) + (number($g) * 37) + (number($h) * 29) + (number($i) * 23) + (number($j) * 19) + (number($k) * 17) + (number($l) * 13) + (number($m) * 7) + (number($n) * 3))) else if (number(string-length($nitwithout)) = 15) then ((number($a) * 71) + (number($b) * 67) + (number($c) * 59) + (number($d * 53) + (number($e) * 47) + (number($f) * 43) + (number($g) * 41) + (number($h) * 37) + (number($i) * 29) + (number($j) * 23) + (number($k) * 19) + (number($l) * 17) + (number($m) * 13) + (number($n) * 7) + (number($o) * 3))) else ''"/>
      <xsl:variable name="y" select="$p mod 11"/>
      <xsl:variable name="dv" select="if ($y &gt;= 2) then 11 - $y else $y"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then $dv = ./@schemeID else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FBA05]' else if (boolean(/cn:CreditNote)) then '[CBA05]' else if (boolean(/dn:DebitNote)) then '[DBA05]' else ''"/>
               <xsl:text/>
               <xsl:text>-DV del NIT Mandante : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="@schemeID"/>
               <xsl:text/>
               <xsl:text>' no está correctamente calculado : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="$dv"/>
               <xsl:text/>
               <xsl:text>'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(@schemeName = '31') then exists(./@schemeID) and ./@schemeID != '' else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FBA05]' else if (boolean(/cn:CreditNote)) then '[CBA05]' else if (boolean(/dn:DebitNote)) then '[DBA05]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) NIT Mandante debe ser informado con dígito verificador (@schemeName debe ser “31”)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Price" priority="1000" mode="M21">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="exists(cbc:BaseQuantity/@unitCode) and cbc:BaseQuantity/@unitCode != ''"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FBB04]' else if (boolean(/cn:CreditNote)) then '[CBB04]' else if (boolean(/dn:DebitNote)) then '[DBB04]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) La unidad de la cantidad utilizada no existe en el XML</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M21"/>
   <xsl:template match="@*|node()" priority="-2" mode="M21">
      <xsl:apply-templates select="@*|node()" mode="M21"/>
   </xsl:template>

   <!--PATTERN ListaCodigos-->


	  <!--RULE -->
   <xsl:template match="cbc:IndustryClassificationCode" priority="1037" mode="M22">
      <xsl:variable name="a" select="tokenize(translate(normalize-space(.),' ',''),';')"/>
      <xsl:variable name="b"
                    select="every $i in  $a satisfies (false() or (contains('&#x7f;1011&#x7f;1012&#x7f;1020&#x7f;1030&#x7f;1040&#x7f;1051&#x7f;1052&#x7f;1061&#x7f;1062&#x7f;1063&#x7f;1071&#x7f;1072&#x7f;1081&#x7f;1082&#x7f;1083&#x7f;1084&#x7f;1089&#x7f;1090&#x7f;1101&#x7f;1102&#x7f;1103&#x7f;1104&#x7f;1200&#x7f;1311&#x7f;1312&#x7f;1313&#x7f;1391&#x7f;1392&#x7f;1393&#x7f;1394&#x7f;1399&#x7f;1410&#x7f;1420&#x7f;1430&#x7f;1511&#x7f;1512&#x7f;1513&#x7f;1521&#x7f;1522&#x7f;1523&#x7f;1610&#x7f;1620&#x7f;1630&#x7f;1640&#x7f;1690&#x7f;1701&#x7f;1702&#x7f;1709&#x7f;1811&#x7f;1812&#x7f;1820&#x7f;1910&#x7f;1921&#x7f;1922&#x7f;2011&#x7f;2012&#x7f;2013&#x7f;2014&#x7f;2021&#x7f;2022&#x7f;2023&#x7f;2029&#x7f;2030&#x7f;2100&#x7f;2211&#x7f;2212&#x7f;2219&#x7f;2221&#x7f;2229&#x7f;2310&#x7f;2391&#x7f;2392&#x7f;2393&#x7f;2394&#x7f;2395&#x7f;2396&#x7f;2399&#x7f;2410&#x7f;2421&#x7f;2429&#x7f;2431&#x7f;2432&#x7f;2511&#x7f;2512&#x7f;2513&#x7f;2520&#x7f;2591&#x7f;2592&#x7f;2593&#x7f;2599&#x7f;2610&#x7f;2620&#x7f;2630&#x7f;2640&#x7f;2651&#x7f;2652&#x7f;2660&#x7f;2670&#x7f;2680&#x7f;2711&#x7f;2712&#x7f;2720&#x7f;2731&#x7f;2732&#x7f;2740&#x7f;2750&#x7f;2790&#x7f;2811&#x7f;2812&#x7f;2813&#x7f;2814&#x7f;2815&#x7f;2816&#x7f;2817&#x7f;2818&#x7f;2819&#x7f;2821&#x7f;2822&#x7f;2823&#x7f;2824&#x7f;2825&#x7f;2826&#x7f;2829&#x7f;2910&#x7f;2920&#x7f;2930&#x7f;3011&#x7f;3012&#x7f;3020&#x7f;3030&#x7f;3040&#x7f;3091&#x7f;3092&#x7f;3099&#x7f;3110&#x7f;3120&#x7f;3210&#x7f;3220&#x7f;3230&#x7f;3240&#x7f;3250&#x7f;3290&#x7f;3311&#x7f;3312&#x7f;3313&#x7f;3314&#x7f;3315&#x7f;3319&#x7f;3320&#x7f;3511&#x7f;3512&#x7f;3513&#x7f;3514&#x7f;3520&#x7f;3530&#x7f;3600&#x7f;3700&#x7f;3811&#x7f;3812&#x7f;3821&#x7f;3822&#x7f;3830&#x7f;3900&#x7f;4111&#x7f;4112&#x7f;4210&#x7f;4220&#x7f;4290&#x7f;4311&#x7f;4312&#x7f;4321&#x7f;4322&#x7f;4329&#x7f;4330&#x7f;4390&#x7f;4511&#x7f;4512&#x7f;4520&#x7f;4530&#x7f;4541&#x7f;4542&#x7f;4610&#x7f;4620&#x7f;4631&#x7f;4632&#x7f;4641&#x7f;4642&#x7f;4643&#x7f;4644&#x7f;4645&#x7f;4649&#x7f;4651&#x7f;4652&#x7f;4653&#x7f;4659&#x7f;4661&#x7f;4662&#x7f;4663&#x7f;4664&#x7f;4665&#x7f;4669&#x7f;4690&#x7f;4711&#x7f;4719&#x7f;4721&#x7f;4722&#x7f;4723&#x7f;4724&#x7f;4729&#x7f;4731&#x7f;4732&#x7f;4741&#x7f;4742&#x7f;4751&#x7f;4752&#x7f;4753&#x7f;4754&#x7f;4755&#x7f;4759&#x7f;4761&#x7f;4762&#x7f;4769&#x7f;4771&#x7f;4772&#x7f;4773&#x7f;4774&#x7f;4775&#x7f;4781&#x7f;4782&#x7f;4789&#x7f;4791&#x7f;4792&#x7f;4799&#x7f;4911&#x7f;4912&#x7f;4921&#x7f;4922&#x7f;4923&#x7f;4930&#x7f;5011&#x7f;5012&#x7f;5021&#x7f;5022&#x7f;5111&#x7f;5112&#x7f;5121&#x7f;5122&#x7f;5210&#x7f;5221&#x7f;5222&#x7f;5223&#x7f;5224&#x7f;5229&#x7f;5310&#x7f;5320&#x7f;5511&#x7f;5512&#x7f;5513&#x7f;5514&#x7f;5519&#x7f;5520&#x7f;5530&#x7f;5590&#x7f;5611&#x7f;5612&#x7f;5613&#x7f;5619&#x7f;5621&#x7f;5629&#x7f;5630&#x7f;5811&#x7f;5812&#x7f;5813&#x7f;5819&#x7f;5820&#x7f;5911&#x7f;5912&#x7f;5913&#x7f;5914&#x7f;5920&#x7f;6010&#x7f;6020&#x7f;6110&#x7f;6120&#x7f;6130&#x7f;6190&#x7f;6201&#x7f;6202&#x7f;6209&#x7f;6311&#x7f;6312&#x7f;6391&#x7f;6399&#x7f;6411&#x7f;6412&#x7f;6421&#x7f;6422&#x7f;6423&#x7f;6424&#x7f;6431&#x7f;6432&#x7f;6491&#x7f;6492&#x7f;6493&#x7f;6494&#x7f;6495&#x7f;6499&#x7f;6511&#x7f;6512&#x7f;6513&#x7f;6514&#x7f;6521&#x7f;6522&#x7f;6531&#x7f;6532&#x7f;6611&#x7f;6612&#x7f;6613&#x7f;6614&#x7f;6615&#x7f;6619&#x7f;6621&#x7f;6629&#x7f;6630&#x7f;6810&#x7f;6820&#x7f;6910&#x7f;6920&#x7f;7010&#x7f;7020&#x7f;7110&#x7f;7120&#x7f;7210&#x7f;7220&#x7f;7310&#x7f;7320&#x7f;7410&#x7f;7420&#x7f;7490&#x7f;7500&#x7f;7710&#x7f;7721&#x7f;7722&#x7f;7729&#x7f;7730&#x7f;7740&#x7f;7810&#x7f;7820&#x7f;7830&#x7f;7911&#x7f;7912&#x7f;7990&#x7f;8010&#x7f;8020&#x7f;8030&#x7f;8110&#x7f;8121&#x7f;8129&#x7f;8130&#x7f;8211&#x7f;8219&#x7f;8220&#x7f;8230&#x7f;8291&#x7f;8292&#x7f;8299&#x7f;8411&#x7f;8412&#x7f;8413&#x7f;8414&#x7f;8415&#x7f;8421&#x7f;8422&#x7f;8423&#x7f;8424&#x7f;8430&#x7f;8511&#x7f;8512&#x7f;8513&#x7f;8521&#x7f;8522&#x7f;8523&#x7f;8530&#x7f;8541&#x7f;8542&#x7f;8543&#x7f;8544&#x7f;8551&#x7f;8552&#x7f;8553&#x7f;8559&#x7f;8560&#x7f;8610&#x7f;8621&#x7f;8622&#x7f;8691&#x7f;8692&#x7f;8699&#x7f;8710&#x7f;8720&#x7f;8730&#x7f;8790&#x7f;8810&#x7f;8890&#x7f;9001&#x7f;9002&#x7f;9003&#x7f;9004&#x7f;9005&#x7f;9006&#x7f;9007&#x7f;9008&#x7f;9101&#x7f;9102&#x7f;9103&#x7f;9200&#x7f;9311&#x7f;9312&#x7f;9319&#x7f;9321&#x7f;9329&#x7f;9411&#x7f;9412&#x7f;9420&#x7f;9491&#x7f;9492&#x7f;9499&#x7f;9511&#x7f;9512&#x7f;9521&#x7f;9522&#x7f;9523&#x7f;9524&#x7f;9529&#x7f;9601&#x7f;9602&#x7f;9603&#x7f;9609&#x7f;9700&#x7f;9810&#x7f;9820&#x7f;9900&#x7f;0111&#x7f;0112&#x7f;0113&#x7f;0114&#x7f;0115&#x7f;0119&#x7f;0121&#x7f;0122&#x7f;0123&#x7f;0124&#x7f;0125&#x7f;0126&#x7f;0127&#x7f;0128&#x7f;0129&#x7f;0130&#x7f;0141&#x7f;0142&#x7f;0143&#x7f;0144&#x7f;0145&#x7f;0149&#x7f;0150&#x7f;0161&#x7f;0162&#x7f;0163&#x7f;0164&#x7f;0170&#x7f;0210&#x7f;0220&#x7f;0230&#x7f;0240&#x7f;0311&#x7f;0312&#x7f;0321&#x7f;0322&#x7f;0510&#x7f;0520&#x7f;0610&#x7f;0620&#x7f;0710&#x7f;0721&#x7f;0722&#x7f;0723&#x7f;0729&#x7f;0811&#x7f;0812&#x7f;0820&#x7f;0891&#x7f;0892&#x7f;0899&#x7f;0910&#x7f;0990&#x7f;',concat('&#x7f;',$i,'&#x7f;'))))"/>
      <xsl:variable name="c"
                    select="if (not($b)) then for $j in $a return$j[not(contains('&#x7f;1011&#x7f;1012&#x7f;1020&#x7f;1030&#x7f;1040&#x7f;1051&#x7f;1052&#x7f;1061&#x7f;1062&#x7f;1063&#x7f;1071&#x7f;1072&#x7f;1081&#x7f;1082&#x7f;1083&#x7f;1084&#x7f;1089&#x7f;1090&#x7f;1101&#x7f;1102&#x7f;1103&#x7f;1104&#x7f;1200&#x7f;1311&#x7f;1312&#x7f;1313&#x7f;1391&#x7f;1392&#x7f;1393&#x7f;1394&#x7f;1399&#x7f;1410&#x7f;1420&#x7f;1430&#x7f;1511&#x7f;1512&#x7f;1513&#x7f;1521&#x7f;1522&#x7f;1523&#x7f;1610&#x7f;1620&#x7f;1630&#x7f;1640&#x7f;1690&#x7f;1701&#x7f;1702&#x7f;1709&#x7f;1811&#x7f;1812&#x7f;1820&#x7f;1910&#x7f;1921&#x7f;1922&#x7f;2011&#x7f;2012&#x7f;2013&#x7f;2014&#x7f;2021&#x7f;2022&#x7f;2023&#x7f;2029&#x7f;2030&#x7f;2100&#x7f;2211&#x7f;2212&#x7f;2219&#x7f;2221&#x7f;2229&#x7f;2310&#x7f;2391&#x7f;2392&#x7f;2393&#x7f;2394&#x7f;2395&#x7f;2396&#x7f;2399&#x7f;2410&#x7f;2421&#x7f;2429&#x7f;2431&#x7f;2432&#x7f;2511&#x7f;2512&#x7f;2513&#x7f;2520&#x7f;2591&#x7f;2592&#x7f;2593&#x7f;2599&#x7f;2610&#x7f;2620&#x7f;2630&#x7f;2640&#x7f;2651&#x7f;2652&#x7f;2660&#x7f;2670&#x7f;2680&#x7f;2711&#x7f;2712&#x7f;2720&#x7f;2731&#x7f;2732&#x7f;2740&#x7f;2750&#x7f;2790&#x7f;2811&#x7f;2812&#x7f;2813&#x7f;2814&#x7f;2815&#x7f;2816&#x7f;2817&#x7f;2818&#x7f;2819&#x7f;2821&#x7f;2822&#x7f;2823&#x7f;2824&#x7f;2825&#x7f;2826&#x7f;2829&#x7f;2910&#x7f;2920&#x7f;2930&#x7f;3011&#x7f;3012&#x7f;3020&#x7f;3030&#x7f;3040&#x7f;3091&#x7f;3092&#x7f;3099&#x7f;3110&#x7f;3120&#x7f;3210&#x7f;3220&#x7f;3230&#x7f;3240&#x7f;3250&#x7f;3290&#x7f;3311&#x7f;3312&#x7f;3313&#x7f;3314&#x7f;3315&#x7f;3319&#x7f;3320&#x7f;3511&#x7f;3512&#x7f;3513&#x7f;3514&#x7f;3520&#x7f;3530&#x7f;3600&#x7f;3700&#x7f;3811&#x7f;3812&#x7f;3821&#x7f;3822&#x7f;3830&#x7f;3900&#x7f;4111&#x7f;4112&#x7f;4210&#x7f;4220&#x7f;4290&#x7f;4311&#x7f;4312&#x7f;4321&#x7f;4322&#x7f;4329&#x7f;4330&#x7f;4390&#x7f;4511&#x7f;4512&#x7f;4520&#x7f;4530&#x7f;4541&#x7f;4542&#x7f;4610&#x7f;4620&#x7f;4631&#x7f;4632&#x7f;4641&#x7f;4642&#x7f;4643&#x7f;4644&#x7f;4645&#x7f;4649&#x7f;4651&#x7f;4652&#x7f;4653&#x7f;4659&#x7f;4661&#x7f;4662&#x7f;4663&#x7f;4664&#x7f;4665&#x7f;4669&#x7f;4690&#x7f;4711&#x7f;4719&#x7f;4721&#x7f;4722&#x7f;4723&#x7f;4724&#x7f;4729&#x7f;4731&#x7f;4732&#x7f;4741&#x7f;4742&#x7f;4751&#x7f;4752&#x7f;4753&#x7f;4754&#x7f;4755&#x7f;4759&#x7f;4761&#x7f;4762&#x7f;4769&#x7f;4771&#x7f;4772&#x7f;4773&#x7f;4774&#x7f;4775&#x7f;4781&#x7f;4782&#x7f;4789&#x7f;4791&#x7f;4792&#x7f;4799&#x7f;4911&#x7f;4912&#x7f;4921&#x7f;4922&#x7f;4923&#x7f;4930&#x7f;5011&#x7f;5012&#x7f;5021&#x7f;5022&#x7f;5111&#x7f;5112&#x7f;5121&#x7f;5122&#x7f;5210&#x7f;5221&#x7f;5222&#x7f;5223&#x7f;5224&#x7f;5229&#x7f;5310&#x7f;5320&#x7f;5511&#x7f;5512&#x7f;5513&#x7f;5514&#x7f;5519&#x7f;5520&#x7f;5530&#x7f;5590&#x7f;5611&#x7f;5612&#x7f;5613&#x7f;5619&#x7f;5621&#x7f;5629&#x7f;5630&#x7f;5811&#x7f;5812&#x7f;5813&#x7f;5819&#x7f;5820&#x7f;5911&#x7f;5912&#x7f;5913&#x7f;5914&#x7f;5920&#x7f;6010&#x7f;6020&#x7f;6110&#x7f;6120&#x7f;6130&#x7f;6190&#x7f;6201&#x7f;6202&#x7f;6209&#x7f;6311&#x7f;6312&#x7f;6391&#x7f;6399&#x7f;6411&#x7f;6412&#x7f;6421&#x7f;6422&#x7f;6423&#x7f;6424&#x7f;6431&#x7f;6432&#x7f;6491&#x7f;6492&#x7f;6493&#x7f;6494&#x7f;6495&#x7f;6499&#x7f;6511&#x7f;6512&#x7f;6513&#x7f;6514&#x7f;6521&#x7f;6522&#x7f;6531&#x7f;6532&#x7f;6611&#x7f;6612&#x7f;6613&#x7f;6614&#x7f;6615&#x7f;6619&#x7f;6621&#x7f;6629&#x7f;6630&#x7f;6810&#x7f;6820&#x7f;6910&#x7f;6920&#x7f;7010&#x7f;7020&#x7f;7110&#x7f;7120&#x7f;7210&#x7f;7220&#x7f;7310&#x7f;7320&#x7f;7410&#x7f;7420&#x7f;7490&#x7f;7500&#x7f;7710&#x7f;7721&#x7f;7722&#x7f;7729&#x7f;7730&#x7f;7740&#x7f;7810&#x7f;7820&#x7f;7830&#x7f;7911&#x7f;7912&#x7f;7990&#x7f;8010&#x7f;8020&#x7f;8030&#x7f;8110&#x7f;8121&#x7f;8129&#x7f;8130&#x7f;8211&#x7f;8219&#x7f;8220&#x7f;8230&#x7f;8291&#x7f;8292&#x7f;8299&#x7f;8411&#x7f;8412&#x7f;8413&#x7f;8414&#x7f;8415&#x7f;8421&#x7f;8422&#x7f;8423&#x7f;8424&#x7f;8430&#x7f;8511&#x7f;8512&#x7f;8513&#x7f;8521&#x7f;8522&#x7f;8523&#x7f;8530&#x7f;8541&#x7f;8542&#x7f;8543&#x7f;8544&#x7f;8551&#x7f;8552&#x7f;8553&#x7f;8559&#x7f;8560&#x7f;8610&#x7f;8621&#x7f;8622&#x7f;8691&#x7f;8692&#x7f;8699&#x7f;8710&#x7f;8720&#x7f;8730&#x7f;8790&#x7f;8810&#x7f;8890&#x7f;9001&#x7f;9002&#x7f;9003&#x7f;9004&#x7f;9005&#x7f;9006&#x7f;9007&#x7f;9008&#x7f;9101&#x7f;9102&#x7f;9103&#x7f;9200&#x7f;9311&#x7f;9312&#x7f;9319&#x7f;9321&#x7f;9329&#x7f;9411&#x7f;9412&#x7f;9420&#x7f;9491&#x7f;9492&#x7f;9499&#x7f;9511&#x7f;9512&#x7f;9521&#x7f;9522&#x7f;9523&#x7f;9524&#x7f;9529&#x7f;9601&#x7f;9602&#x7f;9603&#x7f;9609&#x7f;9700&#x7f;9810&#x7f;9820&#x7f;9900&#x7f;0111&#x7f;0112&#x7f;0113&#x7f;0114&#x7f;0115&#x7f;0119&#x7f;0121&#x7f;0122&#x7f;0123&#x7f;0124&#x7f;0125&#x7f;0126&#x7f;0127&#x7f;0128&#x7f;0129&#x7f;0130&#x7f;0141&#x7f;0142&#x7f;0143&#x7f;0144&#x7f;0145&#x7f;0149&#x7f;0150&#x7f;0161&#x7f;0162&#x7f;0163&#x7f;0164&#x7f;0170&#x7f;0210&#x7f;0220&#x7f;0230&#x7f;0240&#x7f;0311&#x7f;0312&#x7f;0321&#x7f;0322&#x7f;0510&#x7f;0520&#x7f;0610&#x7f;0620&#x7f;0710&#x7f;0721&#x7f;0722&#x7f;0723&#x7f;0729&#x7f;0811&#x7f;0812&#x7f;0820&#x7f;0891&#x7f;0892&#x7f;0899&#x7f;0910&#x7f;0990&#x7f;',concat('&#x7f;',$j,'&#x7f;')))]else 'true'"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(translate(normalize-space(.),' ',''),';') satisfies (false() or (contains('&#x7f;1011&#x7f;1012&#x7f;1020&#x7f;1030&#x7f;1040&#x7f;1051&#x7f;1052&#x7f;1061&#x7f;1062&#x7f;1063&#x7f;1071&#x7f;1072&#x7f;1081&#x7f;1082&#x7f;1083&#x7f;1084&#x7f;1089&#x7f;1090&#x7f;1101&#x7f;1102&#x7f;1103&#x7f;1104&#x7f;1200&#x7f;1311&#x7f;1312&#x7f;1313&#x7f;1391&#x7f;1392&#x7f;1393&#x7f;1394&#x7f;1399&#x7f;1410&#x7f;1420&#x7f;1430&#x7f;1511&#x7f;1512&#x7f;1513&#x7f;1521&#x7f;1522&#x7f;1523&#x7f;1610&#x7f;1620&#x7f;1630&#x7f;1640&#x7f;1690&#x7f;1701&#x7f;1702&#x7f;1709&#x7f;1811&#x7f;1812&#x7f;1820&#x7f;1910&#x7f;1921&#x7f;1922&#x7f;2011&#x7f;2012&#x7f;2013&#x7f;2014&#x7f;2021&#x7f;2022&#x7f;2023&#x7f;2029&#x7f;2030&#x7f;2100&#x7f;2211&#x7f;2212&#x7f;2219&#x7f;2221&#x7f;2229&#x7f;2310&#x7f;2391&#x7f;2392&#x7f;2393&#x7f;2394&#x7f;2395&#x7f;2396&#x7f;2399&#x7f;2410&#x7f;2421&#x7f;2429&#x7f;2431&#x7f;2432&#x7f;2511&#x7f;2512&#x7f;2513&#x7f;2520&#x7f;2591&#x7f;2592&#x7f;2593&#x7f;2599&#x7f;2610&#x7f;2620&#x7f;2630&#x7f;2640&#x7f;2651&#x7f;2652&#x7f;2660&#x7f;2670&#x7f;2680&#x7f;2711&#x7f;2712&#x7f;2720&#x7f;2731&#x7f;2732&#x7f;2740&#x7f;2750&#x7f;2790&#x7f;2811&#x7f;2812&#x7f;2813&#x7f;2814&#x7f;2815&#x7f;2816&#x7f;2817&#x7f;2818&#x7f;2819&#x7f;2821&#x7f;2822&#x7f;2823&#x7f;2824&#x7f;2825&#x7f;2826&#x7f;2829&#x7f;2910&#x7f;2920&#x7f;2930&#x7f;3011&#x7f;3012&#x7f;3020&#x7f;3030&#x7f;3040&#x7f;3091&#x7f;3092&#x7f;3099&#x7f;3110&#x7f;3120&#x7f;3210&#x7f;3220&#x7f;3230&#x7f;3240&#x7f;3250&#x7f;3290&#x7f;3311&#x7f;3312&#x7f;3313&#x7f;3314&#x7f;3315&#x7f;3319&#x7f;3320&#x7f;3511&#x7f;3512&#x7f;3513&#x7f;3514&#x7f;3520&#x7f;3530&#x7f;3600&#x7f;3700&#x7f;3811&#x7f;3812&#x7f;3821&#x7f;3822&#x7f;3830&#x7f;3900&#x7f;4111&#x7f;4112&#x7f;4210&#x7f;4220&#x7f;4290&#x7f;4311&#x7f;4312&#x7f;4321&#x7f;4322&#x7f;4329&#x7f;4330&#x7f;4390&#x7f;4511&#x7f;4512&#x7f;4520&#x7f;4530&#x7f;4541&#x7f;4542&#x7f;4610&#x7f;4620&#x7f;4631&#x7f;4632&#x7f;4641&#x7f;4642&#x7f;4643&#x7f;4644&#x7f;4645&#x7f;4649&#x7f;4651&#x7f;4652&#x7f;4653&#x7f;4659&#x7f;4661&#x7f;4662&#x7f;4663&#x7f;4664&#x7f;4665&#x7f;4669&#x7f;4690&#x7f;4711&#x7f;4719&#x7f;4721&#x7f;4722&#x7f;4723&#x7f;4724&#x7f;4729&#x7f;4731&#x7f;4732&#x7f;4741&#x7f;4742&#x7f;4751&#x7f;4752&#x7f;4753&#x7f;4754&#x7f;4755&#x7f;4759&#x7f;4761&#x7f;4762&#x7f;4769&#x7f;4771&#x7f;4772&#x7f;4773&#x7f;4774&#x7f;4775&#x7f;4781&#x7f;4782&#x7f;4789&#x7f;4791&#x7f;4792&#x7f;4799&#x7f;4911&#x7f;4912&#x7f;4921&#x7f;4922&#x7f;4923&#x7f;4930&#x7f;5011&#x7f;5012&#x7f;5021&#x7f;5022&#x7f;5111&#x7f;5112&#x7f;5121&#x7f;5122&#x7f;5210&#x7f;5221&#x7f;5222&#x7f;5223&#x7f;5224&#x7f;5229&#x7f;5310&#x7f;5320&#x7f;5511&#x7f;5512&#x7f;5513&#x7f;5514&#x7f;5519&#x7f;5520&#x7f;5530&#x7f;5590&#x7f;5611&#x7f;5612&#x7f;5613&#x7f;5619&#x7f;5621&#x7f;5629&#x7f;5630&#x7f;5811&#x7f;5812&#x7f;5813&#x7f;5819&#x7f;5820&#x7f;5911&#x7f;5912&#x7f;5913&#x7f;5914&#x7f;5920&#x7f;6010&#x7f;6020&#x7f;6110&#x7f;6120&#x7f;6130&#x7f;6190&#x7f;6201&#x7f;6202&#x7f;6209&#x7f;6311&#x7f;6312&#x7f;6391&#x7f;6399&#x7f;6411&#x7f;6412&#x7f;6421&#x7f;6422&#x7f;6423&#x7f;6424&#x7f;6431&#x7f;6432&#x7f;6491&#x7f;6492&#x7f;6493&#x7f;6494&#x7f;6495&#x7f;6499&#x7f;6511&#x7f;6512&#x7f;6513&#x7f;6514&#x7f;6521&#x7f;6522&#x7f;6531&#x7f;6532&#x7f;6611&#x7f;6612&#x7f;6613&#x7f;6614&#x7f;6615&#x7f;6619&#x7f;6621&#x7f;6629&#x7f;6630&#x7f;6810&#x7f;6820&#x7f;6910&#x7f;6920&#x7f;7010&#x7f;7020&#x7f;7110&#x7f;7120&#x7f;7210&#x7f;7220&#x7f;7310&#x7f;7320&#x7f;7410&#x7f;7420&#x7f;7490&#x7f;7500&#x7f;7710&#x7f;7721&#x7f;7722&#x7f;7729&#x7f;7730&#x7f;7740&#x7f;7810&#x7f;7820&#x7f;7830&#x7f;7911&#x7f;7912&#x7f;7990&#x7f;8010&#x7f;8020&#x7f;8030&#x7f;8110&#x7f;8121&#x7f;8129&#x7f;8130&#x7f;8211&#x7f;8219&#x7f;8220&#x7f;8230&#x7f;8291&#x7f;8292&#x7f;8299&#x7f;8411&#x7f;8412&#x7f;8413&#x7f;8414&#x7f;8415&#x7f;8421&#x7f;8422&#x7f;8423&#x7f;8424&#x7f;8430&#x7f;8511&#x7f;8512&#x7f;8513&#x7f;8521&#x7f;8522&#x7f;8523&#x7f;8530&#x7f;8541&#x7f;8542&#x7f;8543&#x7f;8544&#x7f;8551&#x7f;8552&#x7f;8553&#x7f;8559&#x7f;8560&#x7f;8610&#x7f;8621&#x7f;8622&#x7f;8691&#x7f;8692&#x7f;8699&#x7f;8710&#x7f;8720&#x7f;8730&#x7f;8790&#x7f;8810&#x7f;8890&#x7f;9001&#x7f;9002&#x7f;9003&#x7f;9004&#x7f;9005&#x7f;9006&#x7f;9007&#x7f;9008&#x7f;9101&#x7f;9102&#x7f;9103&#x7f;9200&#x7f;9311&#x7f;9312&#x7f;9319&#x7f;9321&#x7f;9329&#x7f;9411&#x7f;9412&#x7f;9420&#x7f;9491&#x7f;9492&#x7f;9499&#x7f;9511&#x7f;9512&#x7f;9521&#x7f;9522&#x7f;9523&#x7f;9524&#x7f;9529&#x7f;9601&#x7f;9602&#x7f;9603&#x7f;9609&#x7f;9700&#x7f;9810&#x7f;9820&#x7f;9900&#x7f;0111&#x7f;0112&#x7f;0113&#x7f;0114&#x7f;0115&#x7f;0119&#x7f;0121&#x7f;0122&#x7f;0123&#x7f;0124&#x7f;0125&#x7f;0126&#x7f;0127&#x7f;0128&#x7f;0129&#x7f;0130&#x7f;0141&#x7f;0142&#x7f;0143&#x7f;0144&#x7f;0145&#x7f;0149&#x7f;0150&#x7f;0161&#x7f;0162&#x7f;0163&#x7f;0164&#x7f;0170&#x7f;0210&#x7f;0220&#x7f;0230&#x7f;0240&#x7f;0311&#x7f;0312&#x7f;0321&#x7f;0322&#x7f;0510&#x7f;0520&#x7f;0610&#x7f;0620&#x7f;0710&#x7f;0721&#x7f;0722&#x7f;0723&#x7f;0729&#x7f;0811&#x7f;0812&#x7f;0820&#x7f;0891&#x7f;0892&#x7f;0899&#x7f;0910&#x7f;0990&#x7f;',concat('&#x7f;',$i,'&#x7f;'))))"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ04]' else if (boolean(/cn:CreditNote)) then '[CAJ04]' else if (boolean(/dn:DebitNote)) then '[DAJ04]' else ''"/>
               <xsl:text/>
               <xsl:text>- No fue informada una actividad economica '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="for $i in $c return concat($i,' |')"/>
               <xsl:text/>
               <xsl:text>' parte de la lista ActividadEconomica-2.1.gc</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="/descendant::cbc:UUID[1]/@schemeName"
                 priority="1036"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;CUFE-SHA384&#x7f;CUDE-SHA384&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD08]' else if (boolean(/cn:CreditNote)) then '[CAD08]' else if (boolean(/dn:DebitNote)) then '[DAD08]' else  if (boolean(/app:ApplicationResponse)) then '[AAD08]' else ''"/>
               <xsl:text/>
               <xsl:text>- No fue utilizado uno de los algoritmos permitidos para el cáculo del </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then 'CUFE' else 'CUDE'"/>
               <xsl:text/>
               <xsl:text>: '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text> informado'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AdditionalDocumentReference/cbc:UUID/@schemeName"
                 priority="1035"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;CUFE-SHA384&#x7f;CUDE-SHA384&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAI04]' else if (boolean(/cn:CreditNote)) then '[CAI04]' else if (boolean(/dn:DebitNote)) then '[DAI04]' else ''"/>
               <xsl:text/>
               <xsl:text>- No fue utilizado uno de los algoritmos permitidos para el cáculo del </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (contains('CUFE',.)) then 'CUFE' else 'CUDE'"/>
               <xsl:text/>
               <xsl:text> de un documento de referencia : '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text> informado'</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:AllowanceChargeReasonCode" priority="1034" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;00&#x7f;01&#x7f;02&#x7f;03&#x7f;04&#x7f;05&#x7f;06&#x7f;07&#x7f;08&#x7f;09&#x7f;10&#x7f;11&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAQ04]' else if (boolean(/cn:CreditNote)) then '[CAQ04]' else if (boolean(/dn:DebitNote)) then '[DAQ04]' else ''"/>
               <xsl:text/>
               <xsl:text>- El codigo de descuento '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no es parte de la lista</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:PriceTypeCode" priority="1033" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;01&#x7f;02&#x7f;03&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAW05]' else if (boolean(/cn:CreditNote)) then '[CAW05]' else if (boolean(/dn:DebitNote)) then '[DAW05]' else ''"/>
               <xsl:text/>
               <xsl:text>- Notificación si valor '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no se encuentra en la columna CodigoPrecioReferencia</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:DocumentResponse/cac:Response/cbc:ResponseCode"
                 priority="1032"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;01&#x7f;02&#x7f;03&#x7f;04&#x7f;011&#x7f;030&#x7f;031&#x7f;032&#x7f;033&#x7f;040&#x7f;041&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) )"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[AAH03]- cbc:ResponseCode '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no indica valor autorizado </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:DiscrepancyResponse/cbc:ResponseCode"
                 priority="1031"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(boolean(/cn:CreditNote)) then ( false() or ( contains('&#x7f;1&#x7f;2&#x7f;3&#x7f;4&#x7f;5&#x7f;6&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[CAE03]- Rechazo si el contenido de este atributo '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no corresponde a algún de los valores de la columna </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(boolean(/dn:DebitNote)) then ( false() or ( contains('&#x7f;1&#x7f;2&#x7f;3&#x7f;4&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DAE03]- Rechazo si el contenido de este atributo '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no corresponde a algún de los valores de la columna ConceptoNotaDebito</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AdditionalDocumentReference/cbc:DocumentTypeCode"
                 priority="1030"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(boolean(/cn:CreditNote) and boolean(../cbc:UUID)) then ( false() or ( contains('&#x7f;01&#x7f;02&#x7f;03&#x7f;91&#x7f;92&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[CAI06]- Rechazo si el contenido de este atributo '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no corresponde a algún de los valores de la columna </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(boolean(/dn:DebitNote) and boolean(../cbc:UUID)) then ( false() or ( contains('&#x7f;01&#x7f;02&#x7f;03&#x7f;91&#x7f;92&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[DAI06]- Rechazo si el contenido de este atributo '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no corresponde a algún de los valores de la columna Tipo de Documento </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if(boolean(/ubl:Invoice) or (boolean(/cn:CreditNote) and not(boolean(../cbc:UUID))) or (boolean(/dn:DebitNote) and not(boolean(../cbc:UUID)))) then ( false() or ( contains('&#x7f;01-A&#x7f;02-A&#x7f;03-A&#x7f;04-B&#x7f;05-B&#x7f;06-B&#x7f;07-B&#x7f;08-B&#x7f;09-B&#x7f;10-B&#x7f;11-B&#x7f;12-B&#x7f;13-B&#x7f;15-C&#x7f;16-C&#x7f;ACL&#x7f;LC&#x7f;AAJ&#x7f;AFO&#x7f;AGW&#x7f;MSC&#x7f;AHJ&#x7f;TN&#x7f;AIJ&#x7f;NCP&#x7f;PED&#x7f;DEV&#x7f;OC&#x7f;VEB&#x7f;FTC&#x7f;FTP&#x7f;FTC&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) else true() "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAI06]' else if (boolean(/cn:CreditNote)) then '[CAI06]' else if (boolean(/dn:DebitNote)) then '[DAI06]' else ''"/>
               <xsl:text/>
               <xsl:text>- El elemento cac:AdditionalDocumentReference/cbc:DocumentTypeCode '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>'no corresponde a un elemento de la tabla</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:PaymentMeans/cbc:ID" priority="1029" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;1&#x7f;2&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAN02]' else if (boolean(/cn:CreditNote)) then '[CAN02]' else if (boolean(/dn:DebitNote)) then '[DAN02]' else ''"/>
               <xsl:text/>
               <xsl:text>- Tipo de Venta '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no indica un valor autorizado</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="@languageID" priority="1028" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;aa&#x7f;AA&#x7f;ab&#x7f;AB&#x7f;ae&#x7f;AE&#x7f;af&#x7f;AF&#x7f;ak&#x7f;AK&#x7f;am&#x7f;AM&#x7f;an&#x7f;AN&#x7f;ar&#x7f;AR&#x7f;as&#x7f;AS&#x7f;av&#x7f;AV&#x7f;ay&#x7f;AY&#x7f;az&#x7f;AZ&#x7f;ba&#x7f;BA&#x7f;be&#x7f;BE&#x7f;bg&#x7f;BG&#x7f;bh&#x7f;BH&#x7f;bi&#x7f;BI&#x7f;bm&#x7f;BM&#x7f;bn&#x7f;BN&#x7f;bo&#x7f;BO&#x7f;br&#x7f;BR&#x7f;bs&#x7f;BS&#x7f;ca&#x7f;CA&#x7f;ce&#x7f;CE&#x7f;ch&#x7f;CH&#x7f;co&#x7f;CO&#x7f;cr&#x7f;CR&#x7f;cs&#x7f;CS&#x7f;cu&#x7f;CU&#x7f;cv&#x7f;CV&#x7f;cy&#x7f;CY&#x7f;da&#x7f;DA&#x7f;de&#x7f;DE&#x7f;dv&#x7f;DV&#x7f;dz&#x7f;DZ&#x7f;ee&#x7f;EE&#x7f;el&#x7f;EL&#x7f;en&#x7f;EN&#x7f;eo&#x7f;EO&#x7f;es&#x7f;ES&#x7f;et&#x7f;ET&#x7f;eu&#x7f;EU&#x7f;fa&#x7f;FA&#x7f;ff&#x7f;FF&#x7f;fi&#x7f;FI&#x7f;fj&#x7f;FJ&#x7f;fo&#x7f;FO&#x7f;fr&#x7f;FR&#x7f;fy&#x7f;FY&#x7f;ga&#x7f;GA&#x7f;gd&#x7f;GD&#x7f;gl&#x7f;GL&#x7f;gn&#x7f;GN&#x7f;gu&#x7f;GU&#x7f;gv&#x7f;GV&#x7f;ha&#x7f;HA&#x7f;he&#x7f;HE&#x7f;hi&#x7f;HI&#x7f;ho&#x7f;HO&#x7f;hr&#x7f;HR&#x7f;ht&#x7f;HT&#x7f;hu&#x7f;HU&#x7f;hy&#x7f;HY&#x7f;hz&#x7f;HZ&#x7f;ia&#x7f;IA&#x7f;id&#x7f;ID&#x7f;ie&#x7f;IE&#x7f;ig&#x7f;IG&#x7f;ii&#x7f;II&#x7f;ik&#x7f;IK&#x7f;io&#x7f;IO&#x7f;is&#x7f;IS&#x7f;it&#x7f;IT&#x7f;iu&#x7f;IU&#x7f;ja&#x7f;JA&#x7f;jv&#x7f;JV&#x7f;ka&#x7f;KA&#x7f;kg&#x7f;KG&#x7f;ki&#x7f;KI&#x7f;kj&#x7f;KJ&#x7f;kk&#x7f;KK&#x7f;kl&#x7f;KL&#x7f;km&#x7f;KM&#x7f;kn&#x7f;KN&#x7f;ko&#x7f;KO&#x7f;kr&#x7f;KR&#x7f;ks&#x7f;KS&#x7f;ku&#x7f;KU&#x7f;kv&#x7f;KV&#x7f;kw&#x7f;KW&#x7f;ky&#x7f;KY&#x7f;la&#x7f;LA&#x7f;lb&#x7f;LB&#x7f;lg&#x7f;LG&#x7f;li&#x7f;LI&#x7f;ln&#x7f;LN&#x7f;lo&#x7f;LO&#x7f;lt&#x7f;LT&#x7f;lu&#x7f;LU&#x7f;lv&#x7f;LV&#x7f;mg&#x7f;MG&#x7f;mh&#x7f;MH&#x7f;mi&#x7f;MI&#x7f;mk&#x7f;MK&#x7f;ml&#x7f;ML&#x7f;mn&#x7f;MN&#x7f;mo&#x7f;MO&#x7f;mr&#x7f;MR&#x7f;ms&#x7f;MS&#x7f;mt&#x7f;MT&#x7f;my&#x7f;MY&#x7f;na&#x7f;NA&#x7f;nb&#x7f;NB&#x7f;nd&#x7f;ND&#x7f;ne&#x7f;NE&#x7f;ng&#x7f;NG&#x7f;nl&#x7f;NL&#x7f;nn&#x7f;NN&#x7f;no&#x7f;NO&#x7f;nr&#x7f;NR&#x7f;nv&#x7f;NV&#x7f;ny&#x7f;NY&#x7f;oc&#x7f;OC&#x7f;oj&#x7f;OJ&#x7f;om&#x7f;OM&#x7f;or&#x7f;OR&#x7f;os&#x7f;OS&#x7f;pa&#x7f;PA&#x7f;pi&#x7f;PI&#x7f;pl&#x7f;PL&#x7f;ps&#x7f;PS&#x7f;pt&#x7f;PT&#x7f;qu&#x7f;QU&#x7f;rm&#x7f;RM&#x7f;rn&#x7f;RN&#x7f;ro&#x7f;RO&#x7f;ru&#x7f;RU&#x7f;rw&#x7f;RW&#x7f;sa&#x7f;SA&#x7f;sc&#x7f;SC&#x7f;sd&#x7f;SD&#x7f;se&#x7f;SE&#x7f;sg&#x7f;SG&#x7f;si&#x7f;SI&#x7f;sk&#x7f;SK&#x7f;sl&#x7f;SL&#x7f;sm&#x7f;SM&#x7f;sn&#x7f;SN&#x7f;so&#x7f;SO&#x7f;sq&#x7f;SQ&#x7f;sr&#x7f;SR&#x7f;ss&#x7f;SS&#x7f;st&#x7f;ST&#x7f;su&#x7f;SU&#x7f;sv&#x7f;SV&#x7f;sw&#x7f;SW&#x7f;ta&#x7f;TA&#x7f;te&#x7f;TE&#x7f;tg&#x7f;TG&#x7f;th&#x7f;TH&#x7f;ti&#x7f;TI&#x7f;tk&#x7f;TK&#x7f;tl&#x7f;TL&#x7f;tn&#x7f;TN&#x7f;to&#x7f;TO&#x7f;tr&#x7f;TR&#x7f;ts&#x7f;TS&#x7f;tt&#x7f;TT&#x7f;tw&#x7f;TW&#x7f;ty&#x7f;TY&#x7f;ug&#x7f;UG&#x7f;uk&#x7f;UK&#x7f;ur&#x7f;UR&#x7f;uz&#x7f;UZ&#x7f;ve&#x7f;VE&#x7f;vi&#x7f;VI&#x7f;vo&#x7f;VO&#x7f;wa&#x7f;WA&#x7f;wo&#x7f;WO&#x7f;xh&#x7f;XH&#x7f;yi&#x7f;YI&#x7f;yo&#x7f;YO&#x7f;za&#x7f;ZA&#x7f;zh&#x7f;ZH&#x7f;zu&#x7f;ZU&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAK38]' else if (boolean(/cn:CreditNote)) then '[CAK38]' else if (boolean(/dn:DebitNote)) then '[DAK38]' else ''"/>
               <xsl:text/>
               <xsl:text>- (N) Notificacion si el valor informado '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no se encuentra en lista de valores posibles en 5.3.2, columna “ISO 639-1”</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:PaymentMeansCode" priority="1027" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;1&#x7f;2&#x7f;3&#x7f;4&#x7f;5&#x7f;6&#x7f;7&#x7f;8&#x7f;9&#x7f;10&#x7f;11&#x7f;12&#x7f;13&#x7f;14&#x7f;15&#x7f;16&#x7f;17&#x7f;18&#x7f;19&#x7f;20&#x7f;21&#x7f;22&#x7f;23&#x7f;24&#x7f;25&#x7f;26&#x7f;27&#x7f;28&#x7f;29&#x7f;30&#x7f;31&#x7f;32&#x7f;33&#x7f;34&#x7f;35&#x7f;36&#x7f;37&#x7f;38&#x7f;39&#x7f;40&#x7f;41&#x7f;42&#x7f;43&#x7f;44&#x7f;45&#x7f;46&#x7f;47&#x7f;48&#x7f;49&#x7f;50&#x7f;51&#x7f;52&#x7f;53&#x7f;60&#x7f;61&#x7f;62&#x7f;63&#x7f;64&#x7f;65&#x7f;66&#x7f;67&#x7f;70&#x7f;71&#x7f;72&#x7f;74&#x7f;75&#x7f;76&#x7f;77&#x7f;78&#x7f;91&#x7f;92&#x7f;93&#x7f;94&#x7f;95&#x7f;96&#x7f;97&#x7f;ZZZ&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAN03]' else if (boolean(/cn:CreditNote)) then '[CAN03]' else if (boolean(/dn:DebitNote)) then '[DAN03]' else ''"/>
               <xsl:text/>
               <xsl:text>- Medio de pago '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' inválido</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Party/cac:PhysicalLocation/cac:Address/cbc:ID | cac:RegistrationAddress/cac:PhysicalLocation/cac:Address/cbc:ID"
                 priority="1026"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice) and boolean(/ubl:Invoice/cbc:InvoiceTypeCode != '02')) then ( false() or ( contains('&#x7f;05001&#x7f;05002&#x7f;05004&#x7f;05021&#x7f;05030&#x7f;05031&#x7f;05034&#x7f;05036&#x7f;05038&#x7f;05040&#x7f;05042&#x7f;05044&#x7f;05045&#x7f;05051&#x7f;05055&#x7f;05059&#x7f;05079&#x7f;05086&#x7f;05088&#x7f;05091&#x7f;05093&#x7f;05101&#x7f;05107&#x7f;05113&#x7f;05120&#x7f;05125&#x7f;05129&#x7f;05134&#x7f;05138&#x7f;05142&#x7f;05145&#x7f;05147&#x7f;05148&#x7f;05150&#x7f;05154&#x7f;05172&#x7f;05190&#x7f;05197&#x7f;05206&#x7f;05209&#x7f;05212&#x7f;05234&#x7f;05237&#x7f;05240&#x7f;05250&#x7f;05264&#x7f;05266&#x7f;05282&#x7f;05284&#x7f;05306&#x7f;05308&#x7f;05310&#x7f;05313&#x7f;05315&#x7f;05318&#x7f;05321&#x7f;05347&#x7f;05353&#x7f;05360&#x7f;05361&#x7f;05364&#x7f;05368&#x7f;05376&#x7f;05380&#x7f;05390&#x7f;05400&#x7f;05411&#x7f;05425&#x7f;05440&#x7f;05467&#x7f;05475&#x7f;05480&#x7f;05483&#x7f;05490&#x7f;05495&#x7f;05501&#x7f;05541&#x7f;05543&#x7f;05576&#x7f;05579&#x7f;05585&#x7f;05591&#x7f;05604&#x7f;05607&#x7f;05615&#x7f;05628&#x7f;05631&#x7f;05642&#x7f;05647&#x7f;05649&#x7f;05652&#x7f;05656&#x7f;05658&#x7f;05659&#x7f;05660&#x7f;05664&#x7f;05665&#x7f;05667&#x7f;05670&#x7f;05674&#x7f;05679&#x7f;05686&#x7f;05690&#x7f;05697&#x7f;05736&#x7f;05756&#x7f;05761&#x7f;05789&#x7f;05790&#x7f;05792&#x7f;05809&#x7f;05819&#x7f;05837&#x7f;05842&#x7f;05847&#x7f;05854&#x7f;05856&#x7f;05858&#x7f;05861&#x7f;05873&#x7f;05885&#x7f;05887&#x7f;05890&#x7f;05893&#x7f;05895&#x7f;08001&#x7f;08078&#x7f;08137&#x7f;08141&#x7f;08296&#x7f;08372&#x7f;08421&#x7f;08433&#x7f;08436&#x7f;08520&#x7f;08549&#x7f;08558&#x7f;08560&#x7f;08573&#x7f;08606&#x7f;08634&#x7f;08638&#x7f;08675&#x7f;08685&#x7f;08758&#x7f;08770&#x7f;08832&#x7f;08849&#x7f;11001&#x7f;13001&#x7f;13006&#x7f;13030&#x7f;13042&#x7f;13052&#x7f;13062&#x7f;13074&#x7f;13140&#x7f;13160&#x7f;13188&#x7f;13212&#x7f;13222&#x7f;13244&#x7f;13248&#x7f;13268&#x7f;13300&#x7f;13430&#x7f;13433&#x7f;13440&#x7f;13442&#x7f;13458&#x7f;13468&#x7f;13473&#x7f;13490&#x7f;13549&#x7f;13580&#x7f;13600&#x7f;13620&#x7f;13647&#x7f;13650&#x7f;13654&#x7f;13655&#x7f;13657&#x7f;13667&#x7f;13670&#x7f;13673&#x7f;13683&#x7f;13688&#x7f;13744&#x7f;13760&#x7f;13780&#x7f;13810&#x7f;13836&#x7f;13838&#x7f;13873&#x7f;13894&#x7f;15001&#x7f;15022&#x7f;15047&#x7f;15051&#x7f;15087&#x7f;15090&#x7f;15092&#x7f;15097&#x7f;15104&#x7f;15106&#x7f;15109&#x7f;15114&#x7f;15131&#x7f;15135&#x7f;15162&#x7f;15172&#x7f;15176&#x7f;15180&#x7f;15183&#x7f;15185&#x7f;15187&#x7f;15189&#x7f;15204&#x7f;15212&#x7f;15215&#x7f;15218&#x7f;15223&#x7f;15224&#x7f;15226&#x7f;15232&#x7f;15236&#x7f;15238&#x7f;15244&#x7f;15248&#x7f;15272&#x7f;15276&#x7f;15293&#x7f;15296&#x7f;15299&#x7f;15317&#x7f;15322&#x7f;15325&#x7f;15332&#x7f;15362&#x7f;15367&#x7f;15368&#x7f;15377&#x7f;15380&#x7f;15401&#x7f;15403&#x7f;15407&#x7f;15425&#x7f;15442&#x7f;15455&#x7f;15464&#x7f;15466&#x7f;15469&#x7f;15476&#x7f;15480&#x7f;15491&#x7f;15494&#x7f;15500&#x7f;15507&#x7f;15511&#x7f;15514&#x7f;15516&#x7f;15518&#x7f;15522&#x7f;15531&#x7f;15533&#x7f;15537&#x7f;15542&#x7f;15550&#x7f;15572&#x7f;15580&#x7f;15599&#x7f;15600&#x7f;15621&#x7f;15632&#x7f;15638&#x7f;15646&#x7f;15660&#x7f;15664&#x7f;15667&#x7f;15673&#x7f;15676&#x7f;15681&#x7f;15686&#x7f;15690&#x7f;15693&#x7f;15696&#x7f;15720&#x7f;15723&#x7f;15740&#x7f;15753&#x7f;15755&#x7f;15757&#x7f;15759&#x7f;15761&#x7f;15762&#x7f;15763&#x7f;15764&#x7f;15774&#x7f;15776&#x7f;15778&#x7f;15790&#x7f;15798&#x7f;15804&#x7f;15806&#x7f;15808&#x7f;15810&#x7f;15814&#x7f;15816&#x7f;15820&#x7f;15822&#x7f;15832&#x7f;15835&#x7f;15837&#x7f;15839&#x7f;15842&#x7f;15861&#x7f;15879&#x7f;15897&#x7f;17001&#x7f;17013&#x7f;17042&#x7f;17050&#x7f;17088&#x7f;17174&#x7f;17272&#x7f;17380&#x7f;17388&#x7f;17433&#x7f;17442&#x7f;17444&#x7f;17446&#x7f;17486&#x7f;17495&#x7f;17513&#x7f;17524&#x7f;17541&#x7f;17614&#x7f;17616&#x7f;17653&#x7f;17662&#x7f;17665&#x7f;17777&#x7f;17867&#x7f;17873&#x7f;17877&#x7f;18001&#x7f;18029&#x7f;18094&#x7f;18150&#x7f;18205&#x7f;18247&#x7f;18256&#x7f;18410&#x7f;18460&#x7f;18479&#x7f;18592&#x7f;18610&#x7f;18753&#x7f;18756&#x7f;18785&#x7f;18860&#x7f;19001&#x7f;19022&#x7f;19050&#x7f;19075&#x7f;19100&#x7f;19110&#x7f;19130&#x7f;19137&#x7f;19142&#x7f;19212&#x7f;19256&#x7f;19290&#x7f;19300&#x7f;19318&#x7f;19355&#x7f;19364&#x7f;19392&#x7f;19397&#x7f;19418&#x7f;19450&#x7f;19455&#x7f;19473&#x7f;19513&#x7f;19517&#x7f;19532&#x7f;19533&#x7f;19548&#x7f;19573&#x7f;19585&#x7f;19622&#x7f;19693&#x7f;19698&#x7f;19701&#x7f;19743&#x7f;19760&#x7f;19780&#x7f;19785&#x7f;19807&#x7f;19809&#x7f;19821&#x7f;19824&#x7f;19845&#x7f;20001&#x7f;20011&#x7f;20013&#x7f;20032&#x7f;20045&#x7f;20060&#x7f;20175&#x7f;20178&#x7f;20228&#x7f;20238&#x7f;20250&#x7f;20295&#x7f;20310&#x7f;20383&#x7f;20400&#x7f;20443&#x7f;20517&#x7f;20550&#x7f;20570&#x7f;20614&#x7f;20621&#x7f;20710&#x7f;20750&#x7f;20770&#x7f;20787&#x7f;23001&#x7f;23068&#x7f;23079&#x7f;23090&#x7f;23162&#x7f;23168&#x7f;23182&#x7f;23189&#x7f;23300&#x7f;23350&#x7f;23417&#x7f;23419&#x7f;23464&#x7f;23466&#x7f;23500&#x7f;23555&#x7f;23570&#x7f;23574&#x7f;23580&#x7f;23586&#x7f;23660&#x7f;23670&#x7f;23672&#x7f;23675&#x7f;23678&#x7f;23682&#x7f;23686&#x7f;23807&#x7f;23815&#x7f;23855&#x7f;25001&#x7f;25019&#x7f;25035&#x7f;25040&#x7f;25053&#x7f;25086&#x7f;25095&#x7f;25099&#x7f;25120&#x7f;25123&#x7f;25126&#x7f;25148&#x7f;25151&#x7f;25154&#x7f;25168&#x7f;25175&#x7f;25178&#x7f;25181&#x7f;25183&#x7f;25200&#x7f;25214&#x7f;25224&#x7f;25245&#x7f;25258&#x7f;25260&#x7f;25269&#x7f;25279&#x7f;25281&#x7f;25286&#x7f;25288&#x7f;25290&#x7f;25293&#x7f;25295&#x7f;25297&#x7f;25299&#x7f;25307&#x7f;25312&#x7f;25317&#x7f;25320&#x7f;25322&#x7f;25324&#x7f;25326&#x7f;25328&#x7f;25335&#x7f;25339&#x7f;25368&#x7f;25372&#x7f;25377&#x7f;25386&#x7f;25394&#x7f;25398&#x7f;25402&#x7f;25407&#x7f;25426&#x7f;25430&#x7f;25436&#x7f;25438&#x7f;25473&#x7f;25483&#x7f;25486&#x7f;25488&#x7f;25489&#x7f;25491&#x7f;25506&#x7f;25513&#x7f;25518&#x7f;25524&#x7f;25530&#x7f;25535&#x7f;25572&#x7f;25580&#x7f;25592&#x7f;25594&#x7f;25596&#x7f;25599&#x7f;25612&#x7f;25645&#x7f;25649&#x7f;25653&#x7f;25658&#x7f;25662&#x7f;25718&#x7f;25736&#x7f;25740&#x7f;25743&#x7f;25745&#x7f;25754&#x7f;25758&#x7f;25769&#x7f;25772&#x7f;25777&#x7f;25779&#x7f;25781&#x7f;25785&#x7f;25793&#x7f;25797&#x7f;25799&#x7f;25805&#x7f;25807&#x7f;25815&#x7f;25817&#x7f;25823&#x7f;25839&#x7f;25841&#x7f;25843&#x7f;25845&#x7f;25851&#x7f;25862&#x7f;25867&#x7f;25871&#x7f;25873&#x7f;25875&#x7f;25878&#x7f;25885&#x7f;25898&#x7f;25899&#x7f;27001&#x7f;27006&#x7f;27025&#x7f;27050&#x7f;27073&#x7f;27075&#x7f;27077&#x7f;27099&#x7f;27135&#x7f;27150&#x7f;27160&#x7f;27205&#x7f;27245&#x7f;27250&#x7f;27361&#x7f;27372&#x7f;27413&#x7f;27425&#x7f;27430&#x7f;27450&#x7f;27491&#x7f;27495&#x7f;27580&#x7f;27600&#x7f;27615&#x7f;27660&#x7f;27745&#x7f;27787&#x7f;27800&#x7f;27810&#x7f;41001&#x7f;41006&#x7f;41013&#x7f;41016&#x7f;41020&#x7f;41026&#x7f;41078&#x7f;41132&#x7f;41206&#x7f;41244&#x7f;41298&#x7f;41306&#x7f;41319&#x7f;41349&#x7f;41357&#x7f;41359&#x7f;41378&#x7f;41396&#x7f;41483&#x7f;41503&#x7f;41518&#x7f;41524&#x7f;41530&#x7f;41548&#x7f;41551&#x7f;41615&#x7f;41660&#x7f;41668&#x7f;41676&#x7f;41770&#x7f;41791&#x7f;41797&#x7f;41799&#x7f;41801&#x7f;41807&#x7f;41872&#x7f;41885&#x7f;44001&#x7f;44035&#x7f;44078&#x7f;44090&#x7f;44098&#x7f;44110&#x7f;44279&#x7f;44378&#x7f;44420&#x7f;44430&#x7f;44560&#x7f;44650&#x7f;44847&#x7f;44855&#x7f;44874&#x7f;47001&#x7f;47030&#x7f;47053&#x7f;47058&#x7f;47161&#x7f;47170&#x7f;47189&#x7f;47205&#x7f;47245&#x7f;47258&#x7f;47268&#x7f;47288&#x7f;47318&#x7f;47460&#x7f;47541&#x7f;47545&#x7f;47551&#x7f;47555&#x7f;47570&#x7f;47605&#x7f;47660&#x7f;47675&#x7f;47692&#x7f;47703&#x7f;47707&#x7f;47720&#x7f;47745&#x7f;47798&#x7f;47960&#x7f;47980&#x7f;50001&#x7f;50006&#x7f;50110&#x7f;50124&#x7f;50150&#x7f;50223&#x7f;50226&#x7f;50245&#x7f;50251&#x7f;50270&#x7f;50287&#x7f;50313&#x7f;50318&#x7f;50325&#x7f;50330&#x7f;50350&#x7f;50370&#x7f;50400&#x7f;50450&#x7f;50568&#x7f;50573&#x7f;50577&#x7f;50590&#x7f;50606&#x7f;50680&#x7f;50683&#x7f;50686&#x7f;50689&#x7f;50711&#x7f;52001&#x7f;52019&#x7f;52022&#x7f;52036&#x7f;52051&#x7f;52079&#x7f;52083&#x7f;52110&#x7f;52203&#x7f;52207&#x7f;52210&#x7f;52215&#x7f;52224&#x7f;52227&#x7f;52233&#x7f;52240&#x7f;52250&#x7f;52254&#x7f;52256&#x7f;52258&#x7f;52260&#x7f;52287&#x7f;52317&#x7f;52320&#x7f;52323&#x7f;52352&#x7f;52354&#x7f;52356&#x7f;52378&#x7f;52381&#x7f;52385&#x7f;52390&#x7f;52399&#x7f;52405&#x7f;52411&#x7f;52418&#x7f;52427&#x7f;52435&#x7f;52473&#x7f;52480&#x7f;52490&#x7f;52506&#x7f;52520&#x7f;52540&#x7f;52560&#x7f;52565&#x7f;52573&#x7f;52585&#x7f;52612&#x7f;52621&#x7f;52678&#x7f;52683&#x7f;52685&#x7f;52687&#x7f;52693&#x7f;52694&#x7f;52696&#x7f;52699&#x7f;52720&#x7f;52786&#x7f;52788&#x7f;52835&#x7f;52838&#x7f;52885&#x7f;54001&#x7f;54003&#x7f;54051&#x7f;54099&#x7f;54109&#x7f;54125&#x7f;54128&#x7f;54172&#x7f;54174&#x7f;54206&#x7f;54223&#x7f;54239&#x7f;54245&#x7f;54250&#x7f;54261&#x7f;54313&#x7f;54344&#x7f;54347&#x7f;54377&#x7f;54385&#x7f;54398&#x7f;54405&#x7f;54418&#x7f;54480&#x7f;54498&#x7f;54518&#x7f;54520&#x7f;54553&#x7f;54599&#x7f;54660&#x7f;54670&#x7f;54673&#x7f;54680&#x7f;54720&#x7f;54743&#x7f;54800&#x7f;54810&#x7f;54820&#x7f;54871&#x7f;54874&#x7f;63001&#x7f;63111&#x7f;63130&#x7f;63190&#x7f;63212&#x7f;63272&#x7f;63302&#x7f;63401&#x7f;63470&#x7f;63548&#x7f;63594&#x7f;63690&#x7f;66001&#x7f;66045&#x7f;66075&#x7f;66088&#x7f;66170&#x7f;66318&#x7f;66383&#x7f;66400&#x7f;66440&#x7f;66456&#x7f;66572&#x7f;66594&#x7f;66682&#x7f;66687&#x7f;68001&#x7f;68013&#x7f;68020&#x7f;68051&#x7f;68077&#x7f;68079&#x7f;68081&#x7f;68092&#x7f;68101&#x7f;68121&#x7f;68132&#x7f;68147&#x7f;68152&#x7f;68160&#x7f;68162&#x7f;68167&#x7f;68169&#x7f;68176&#x7f;68179&#x7f;68190&#x7f;68207&#x7f;68209&#x7f;68211&#x7f;68217&#x7f;68229&#x7f;68235&#x7f;68245&#x7f;68250&#x7f;68255&#x7f;68264&#x7f;68266&#x7f;68271&#x7f;68276&#x7f;68296&#x7f;68298&#x7f;68307&#x7f;68318&#x7f;68320&#x7f;68322&#x7f;68324&#x7f;68327&#x7f;68344&#x7f;68368&#x7f;68370&#x7f;68377&#x7f;68385&#x7f;68397&#x7f;68406&#x7f;68418&#x7f;68425&#x7f;68432&#x7f;68444&#x7f;68464&#x7f;68468&#x7f;68498&#x7f;68500&#x7f;68502&#x7f;68522&#x7f;68524&#x7f;68533&#x7f;68547&#x7f;68549&#x7f;68572&#x7f;68573&#x7f;68575&#x7f;68615&#x7f;68655&#x7f;68669&#x7f;68673&#x7f;68679&#x7f;68682&#x7f;68684&#x7f;68686&#x7f;68689&#x7f;68705&#x7f;68720&#x7f;68745&#x7f;68755&#x7f;68770&#x7f;68773&#x7f;68780&#x7f;68820&#x7f;68855&#x7f;68861&#x7f;68867&#x7f;68872&#x7f;68895&#x7f;70001&#x7f;70110&#x7f;70124&#x7f;70204&#x7f;70215&#x7f;70221&#x7f;70230&#x7f;70233&#x7f;70235&#x7f;70265&#x7f;70400&#x7f;70418&#x7f;70429&#x7f;70473&#x7f;70508&#x7f;70523&#x7f;70670&#x7f;70678&#x7f;70702&#x7f;70708&#x7f;70713&#x7f;70717&#x7f;70742&#x7f;70771&#x7f;70820&#x7f;70823&#x7f;73001&#x7f;73024&#x7f;73026&#x7f;73030&#x7f;73043&#x7f;73055&#x7f;73067&#x7f;73124&#x7f;73148&#x7f;73152&#x7f;73168&#x7f;73200&#x7f;73217&#x7f;73226&#x7f;73236&#x7f;73268&#x7f;73270&#x7f;73275&#x7f;73283&#x7f;73319&#x7f;73347&#x7f;73349&#x7f;73352&#x7f;73408&#x7f;73411&#x7f;73443&#x7f;73449&#x7f;73461&#x7f;73483&#x7f;73504&#x7f;73520&#x7f;73547&#x7f;73555&#x7f;73563&#x7f;73585&#x7f;73616&#x7f;73622&#x7f;73624&#x7f;73671&#x7f;73675&#x7f;73678&#x7f;73686&#x7f;73770&#x7f;73854&#x7f;73861&#x7f;73870&#x7f;73873&#x7f;76001&#x7f;76020&#x7f;76036&#x7f;76041&#x7f;76054&#x7f;76100&#x7f;76109&#x7f;76111&#x7f;76113&#x7f;76122&#x7f;76126&#x7f;76130&#x7f;76147&#x7f;76233&#x7f;76243&#x7f;76246&#x7f;76248&#x7f;76250&#x7f;76275&#x7f;76306&#x7f;76318&#x7f;76364&#x7f;76377&#x7f;76400&#x7f;76403&#x7f;76497&#x7f;76520&#x7f;76563&#x7f;76606&#x7f;76616&#x7f;76622&#x7f;76670&#x7f;76736&#x7f;76823&#x7f;76828&#x7f;76834&#x7f;76845&#x7f;76863&#x7f;76869&#x7f;76890&#x7f;76892&#x7f;76895&#x7f;81001&#x7f;81065&#x7f;81220&#x7f;81300&#x7f;81591&#x7f;81736&#x7f;81794&#x7f;85001&#x7f;85010&#x7f;85015&#x7f;85125&#x7f;85136&#x7f;85139&#x7f;85162&#x7f;85225&#x7f;85230&#x7f;85250&#x7f;85263&#x7f;85279&#x7f;85300&#x7f;85315&#x7f;85325&#x7f;85400&#x7f;85410&#x7f;85430&#x7f;85440&#x7f;86001&#x7f;86219&#x7f;86320&#x7f;86568&#x7f;86569&#x7f;86571&#x7f;86573&#x7f;86749&#x7f;86755&#x7f;86757&#x7f;86760&#x7f;86865&#x7f;86885&#x7f;88001&#x7f;88564&#x7f;91001&#x7f;91263&#x7f;91405&#x7f;91407&#x7f;91430&#x7f;91460&#x7f;91530&#x7f;91536&#x7f;91540&#x7f;91669&#x7f;91798&#x7f;94001&#x7f;94343&#x7f;94663&#x7f;94883&#x7f;94884&#x7f;94885&#x7f;94886&#x7f;94887&#x7f;94888&#x7f;95001&#x7f;95015&#x7f;95025&#x7f;95200&#x7f;97001&#x7f;97161&#x7f;97511&#x7f;97666&#x7f;97777&#x7f;97889&#x7f;99001&#x7f;99524&#x7f;99624&#x7f;99773&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAM19]' else if (boolean(/cn:CreditNote)) then '[CAM19]' else if (boolean(/dn:DebitNote)) then '[DAM19]' else ''"/>
               <xsl:text/>
               <xsl:text>- Municipio informado '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no se encuentra en el catalogo de Municipios</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:CountrySubentityCode" priority="1025" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="if (boolean(/ubl:Invoice) and boolean(/ubl:Invoice/cbc:InvoiceTypeCode != '02')) then ( false() or ( contains('&#x7f;91&#x7f;05&#x7f;81&#x7f;08&#x7f;11&#x7f;13&#x7f;15&#x7f;17&#x7f;18&#x7f;85&#x7f;19&#x7f;20&#x7f;27&#x7f;23&#x7f;25&#x7f;94&#x7f;95&#x7f;41&#x7f;44&#x7f;47&#x7f;50&#x7f;52&#x7f;54&#x7f;86&#x7f;63&#x7f;66&#x7f;88&#x7f;68&#x7f;70&#x7f;73&#x7f;76&#x7f;97&#x7f;99&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) else true()"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAM22]' else if (boolean(/cn:CreditNote)) then '[CAM22]' else if (boolean(/dn:DebitNote)) then '[DAM22]' else ''"/>
               <xsl:text/>
               <xsl:text>- CountrySubentity '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' debe corresponder a uno de los valores del la Columna Nombre de 5.4.2</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:InvoiceLine/cac:Item/cac:StandardItemIdentification[@schemeID = '001']/cbc:ID"
                 priority="1024"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;03000000-1&#x7f;03100000-2&#x7f;03110000-5&#x7f;03111000-2&#x7f;03111100-3&#x7f;03111200-4&#x7f;03111300-5&#x7f;03111400-6&#x7f;03111500-7&#x7f;03111600-8&#x7f;03111700-9&#x7f;03111800-0&#x7f;03111900-1&#x7f;03112000-9&#x7f;03113000-6&#x7f;03113100-7&#x7f;03113200-8&#x7f;03114000-3&#x7f;03114100-4&#x7f;03114200-5&#x7f;03115000-0&#x7f;03115100-1&#x7f;03115110-4&#x7f;03115120-7&#x7f;03115130-0&#x7f;03116000-7&#x7f;03116100-8&#x7f;03116200-9&#x7f;03116300-0&#x7f;03117000-4&#x7f;03117100-5&#x7f;03117110-8&#x7f;03117120-1&#x7f;03117130-4&#x7f;03117140-7&#x7f;03117200-6&#x7f;03120000-8&#x7f;03121000-5&#x7f;03121100-6&#x7f;03121200-7&#x7f;03121210-0&#x7f;03130000-1&#x7f;03131000-8&#x7f;03131100-9&#x7f;03131200-0&#x7f;03131300-1&#x7f;03131400-2&#x7f;03132000-5&#x7f;03140000-4&#x7f;03141000-1&#x7f;03142000-8&#x7f;03142100-9&#x7f;03142200-0&#x7f;03142300-1&#x7f;03142400-2&#x7f;03142500-3&#x7f;03143000-5&#x7f;03144000-2&#x7f;03200000-3&#x7f;03210000-6&#x7f;03211000-3&#x7f;03211100-4&#x7f;03211110-7&#x7f;03211120-0&#x7f;03211200-5&#x7f;03211300-6&#x7f;03211400-7&#x7f;03211500-8&#x7f;03211600-9&#x7f;03211700-0&#x7f;03211900-2&#x7f;03212000-0&#x7f;03212100-1&#x7f;03212200-2&#x7f;03212210-5&#x7f;03212211-2&#x7f;03212212-9&#x7f;03212213-6&#x7f;03212220-8&#x7f;03220000-9&#x7f;03221000-6&#x7f;03221100-7&#x7f;03221110-0&#x7f;03221111-7&#x7f;03221112-4&#x7f;03221113-1&#x7f;03221114-8&#x7f;03221120-3&#x7f;03221200-8&#x7f;03221210-1&#x7f;03221211-8&#x7f;03221212-5&#x7f;03221213-2&#x7f;03221220-4&#x7f;03221221-1&#x7f;03221222-8&#x7f;03221230-7&#x7f;03221240-0&#x7f;03221250-3&#x7f;03221260-6&#x7f;03221270-9&#x7f;03221300-9&#x7f;03221310-2&#x7f;03221320-5&#x7f;03221330-8&#x7f;03221340-1&#x7f;03221400-0&#x7f;03221410-3&#x7f;03221420-6&#x7f;03221430-9&#x7f;03221440-2&#x7f;03222000-3&#x7f;03222100-4&#x7f;03222110-7&#x7f;03222111-4&#x7f;03222112-1&#x7f;03222113-8&#x7f;03222114-5&#x7f;03222115-2&#x7f;03222116-9&#x7f;03222117-6&#x7f;03222118-3&#x7f;03222120-0&#x7f;03222200-5&#x7f;03222210-8&#x7f;03222220-1&#x7f;03222230-4&#x7f;03222240-7&#x7f;03222250-0&#x7f;03222300-6&#x7f;03222310-9&#x7f;03222311-6&#x7f;03222312-3&#x7f;03222313-0&#x7f;03222314-7&#x7f;03222315-4&#x7f;03222320-2&#x7f;03222321-9&#x7f;03222322-6&#x7f;03222323-3&#x7f;03222330-5&#x7f;03222331-2&#x7f;03222332-9&#x7f;03222333-6&#x7f;03222334-3&#x7f;03222340-8&#x7f;03222341-5&#x7f;03222342-2&#x7f;03222400-7&#x7f;03300000-2&#x7f;03310000-5&#x7f;03311000-2&#x7f;03311100-3&#x7f;03311110-6&#x7f;03311120-9&#x7f;03311200-4&#x7f;03311210-7&#x7f;03311220-0&#x7f;03311230-3&#x7f;03311240-6&#x7f;03311300-5&#x7f;03311400-6&#x7f;03311500-7&#x7f;03311600-8&#x7f;03311700-9&#x7f;03312000-9&#x7f;03312100-0&#x7f;03312200-1&#x7f;03312300-2&#x7f;03313000-6&#x7f;03313100-7&#x7f;03313200-8&#x7f;03313300-9&#x7f;03313310-2&#x7f;03320000-8&#x7f;03321000-5&#x7f;03321100-6&#x7f;03321200-7&#x7f;03322000-2&#x7f;03322100-3&#x7f;03322200-4&#x7f;03322300-5&#x7f;03323000-9&#x7f;03324000-6&#x7f;03325000-3&#x7f;03325100-4&#x7f;03325200-5&#x7f;03330000-3&#x7f;03331000-0&#x7f;03331100-1&#x7f;03331200-2&#x7f;03332000-7&#x7f;03332100-8&#x7f;03332200-9&#x7f;03333000-4&#x7f;03340000-6&#x7f;03341000-3&#x7f;03400000-4&#x7f;03410000-7&#x7f;03411000-4&#x7f;03412000-1&#x7f;03413000-8&#x7f;03414000-5&#x7f;03415000-2&#x7f;03416000-9&#x7f;03417000-6&#x7f;03417100-7&#x7f;03418000-3&#x7f;03418100-4&#x7f;03419000-0&#x7f;03419100-1&#x7f;03419200-2&#x7f;03420000-0&#x7f;03421000-7&#x7f;03422000-4&#x7f;03430000-3&#x7f;03431000-0&#x7f;03432000-7&#x7f;03432100-8&#x7f;03440000-6&#x7f;03441000-3&#x7f;03450000-9&#x7f;03451000-6&#x7f;03451100-7&#x7f;03451200-8&#x7f;03451300-9&#x7f;03452000-3&#x7f;03460000-2&#x7f;03461000-9&#x7f;03461100-0&#x7f;09000000-3&#x7f;09100000-0&#x7f;09110000-3&#x7f;09111000-0&#x7f;09111100-1&#x7f;09111200-2&#x7f;09111210-5&#x7f;09111220-8&#x7f;09111300-3&#x7f;09111400-4&#x7f;09112000-7&#x7f;09112100-8&#x7f;09112200-9&#x7f;09113000-4&#x7f;09120000-6&#x7f;09121000-3&#x7f;09121100-4&#x7f;09121200-5&#x7f;09122000-0&#x7f;09122100-1&#x7f;09122110-4&#x7f;09122200-2&#x7f;09122210-5&#x7f;09123000-7&#x7f;09130000-9&#x7f;09131000-6&#x7f;09131100-7&#x7f;09132000-3&#x7f;09132100-4&#x7f;09132200-5&#x7f;09132300-6&#x7f;09133000-0&#x7f;09134000-7&#x7f;09134100-8&#x7f;09134200-9&#x7f;09134210-2&#x7f;09134220-5&#x7f;09134230-8&#x7f;09134231-5&#x7f;09134232-2&#x7f;09135000-4&#x7f;09135100-5&#x7f;09135110-8&#x7f;09200000-1&#x7f;09210000-4&#x7f;09211000-1&#x7f;09211100-2&#x7f;09211200-3&#x7f;09211300-4&#x7f;09211400-5&#x7f;09211500-6&#x7f;09211600-7&#x7f;09211610-0&#x7f;09211620-3&#x7f;09211630-6&#x7f;09211640-9&#x7f;09211650-2&#x7f;09211700-8&#x7f;09211710-1&#x7f;09211720-4&#x7f;09211800-9&#x7f;09211810-2&#x7f;09211820-5&#x7f;09211900-0&#x7f;09220000-7&#x7f;09221000-4&#x7f;09221100-5&#x7f;09221200-6&#x7f;09221300-7&#x7f;09221400-8&#x7f;09222000-1&#x7f;09222100-2&#x7f;09230000-0&#x7f;09240000-3&#x7f;09241000-0&#x7f;09242000-7&#x7f;09242100-8&#x7f;09300000-2&#x7f;09310000-5&#x7f;09320000-8&#x7f;09321000-5&#x7f;09322000-2&#x7f;09323000-9&#x7f;09324000-6&#x7f;09330000-1&#x7f;09331000-8&#x7f;09331100-9&#x7f;09331200-0&#x7f;09332000-5&#x7f;09340000-4&#x7f;09341000-1&#x7f;09342000-8&#x7f;09343000-5&#x7f;09344000-2&#x7f;14000000-1&#x7f;14200000-3&#x7f;14210000-6&#x7f;14211000-3&#x7f;14211100-4&#x7f;14212000-0&#x7f;14212100-1&#x7f;14212110-4&#x7f;14212120-7&#x7f;14212200-2&#x7f;14212210-5&#x7f;14212300-3&#x7f;14212310-6&#x7f;14212320-9&#x7f;14212330-2&#x7f;14212400-4&#x7f;14212410-7&#x7f;14212420-0&#x7f;14212430-3&#x7f;14213000-7&#x7f;14213100-8&#x7f;14213200-9&#x7f;14213300-0&#x7f;14220000-9&#x7f;14221000-6&#x7f;14222000-3&#x7f;14300000-4&#x7f;14310000-7&#x7f;14311000-4&#x7f;14311100-5&#x7f;14311200-6&#x7f;14311300-7&#x7f;14312000-1&#x7f;14312100-2&#x7f;14320000-0&#x7f;14400000-5&#x7f;14410000-8&#x7f;14420000-1&#x7f;14430000-4&#x7f;14450000-0&#x7f;14500000-6&#x7f;14520000-2&#x7f;14521000-9&#x7f;14521100-0&#x7f;14521140-2&#x7f;14521200-1&#x7f;14521210-4&#x7f;14522000-6&#x7f;14522100-7&#x7f;14522200-8&#x7f;14522300-9&#x7f;14522400-0&#x7f;14523000-3&#x7f;14523100-4&#x7f;14523200-5&#x7f;14523300-6&#x7f;14523400-7&#x7f;14600000-7&#x7f;14610000-0&#x7f;14611000-7&#x7f;14612000-4&#x7f;14612100-5&#x7f;14612200-6&#x7f;14612300-7&#x7f;14612400-8&#x7f;14612500-9&#x7f;14612600-0&#x7f;14612700-1&#x7f;14613000-1&#x7f;14613100-2&#x7f;14613200-3&#x7f;14614000-8&#x7f;14620000-3&#x7f;14621000-0&#x7f;14621100-1&#x7f;14621110-4&#x7f;14621120-7&#x7f;14621130-0&#x7f;14622000-7&#x7f;14630000-6&#x7f;14700000-8&#x7f;14710000-1&#x7f;14711000-8&#x7f;14711100-9&#x7f;14712000-5&#x7f;14713000-2&#x7f;14714000-9&#x7f;14715000-6&#x7f;14720000-4&#x7f;14721000-1&#x7f;14721100-2&#x7f;14722000-8&#x7f;14723000-5&#x7f;14724000-2&#x7f;14725000-9&#x7f;14730000-7&#x7f;14731000-4&#x7f;14732000-1&#x7f;14733000-8&#x7f;14734000-5&#x7f;14735000-2&#x7f;14740000-0&#x7f;14741000-7&#x7f;14742000-4&#x7f;14743000-1&#x7f;14744000-8&#x7f;14750000-3&#x7f;14751000-0&#x7f;14752000-7&#x7f;14753000-4&#x7f;14754000-1&#x7f;14755000-8&#x7f;14760000-6&#x7f;14761000-3&#x7f;14762000-0&#x7f;14763000-7&#x7f;14764000-4&#x7f;14765000-1&#x7f;14770000-9&#x7f;14771000-6&#x7f;14772000-3&#x7f;14773000-0&#x7f;14774000-7&#x7f;14780000-2&#x7f;14781000-9&#x7f;14782000-6&#x7f;14783000-3&#x7f;14784000-0&#x7f;14790000-5&#x7f;14791000-2&#x7f;14792000-9&#x7f;14793000-6&#x7f;14794000-3&#x7f;14800000-9&#x7f;14810000-2&#x7f;14811000-9&#x7f;14811100-0&#x7f;14811200-1&#x7f;14811300-2&#x7f;14812000-6&#x7f;14813000-3&#x7f;14814000-0&#x7f;14820000-5&#x7f;14830000-8&#x7f;14900000-0&#x7f;14910000-3&#x7f;14920000-6&#x7f;14930000-9&#x7f;15000000-8&#x7f;15100000-9&#x7f;15110000-2&#x7f;15111000-9&#x7f;15111100-0&#x7f;15111200-1&#x7f;15112000-6&#x7f;15112100-7&#x7f;15112110-0&#x7f;15112120-3&#x7f;15112130-6&#x7f;15112140-9&#x7f;15112300-9&#x7f;15112310-2&#x7f;15113000-3&#x7f;15114000-0&#x7f;15115000-7&#x7f;15115100-8&#x7f;15115200-9&#x7f;15117000-1&#x7f;15118000-8&#x7f;15118100-9&#x7f;15118900-7&#x7f;15119000-5&#x7f;15119100-6&#x7f;15119200-7&#x7f;15119300-8&#x7f;15119400-9&#x7f;15119500-0&#x7f;15119600-1&#x7f;15130000-8&#x7f;15131000-5&#x7f;15131100-6&#x7f;15131110-9&#x7f;15131120-2&#x7f;15131130-5&#x7f;15131134-3&#x7f;15131135-0&#x7f;15131200-7&#x7f;15131210-0&#x7f;15131220-3&#x7f;15131230-6&#x7f;15131300-8&#x7f;15131310-1&#x7f;15131320-4&#x7f;15131400-9&#x7f;15131410-2&#x7f;15131420-5&#x7f;15131490-6&#x7f;15131500-0&#x7f;15131600-1&#x7f;15131610-4&#x7f;15131620-7&#x7f;15131640-3&#x7f;15131700-2&#x7f;15200000-0&#x7f;15210000-3&#x7f;15211000-0&#x7f;15211100-1&#x7f;15212000-7&#x7f;15213000-4&#x7f;15220000-6&#x7f;15221000-3&#x7f;15229000-9&#x7f;15230000-9&#x7f;15231000-6&#x7f;15232000-3&#x7f;15233000-0&#x7f;15234000-7&#x7f;15235000-4&#x7f;15240000-2&#x7f;15241000-9&#x7f;15241100-0&#x7f;15241200-1&#x7f;15241300-2&#x7f;15241400-3&#x7f;15241500-4&#x7f;15241600-5&#x7f;15241700-6&#x7f;15241800-7&#x7f;15242000-6&#x7f;15243000-3&#x7f;15244000-0&#x7f;15244100-1&#x7f;15244200-2&#x7f;15250000-5&#x7f;15251000-2&#x7f;15252000-9&#x7f;15253000-6&#x7f;15300000-1&#x7f;15310000-4&#x7f;15311000-1&#x7f;15311100-2&#x7f;15311200-3&#x7f;15312000-8&#x7f;15312100-9&#x7f;15312200-0&#x7f;15312300-1&#x7f;15312310-4&#x7f;15312400-2&#x7f;15312500-3&#x7f;15313000-5&#x7f;15320000-7&#x7f;15321000-4&#x7f;15321100-5&#x7f;15321200-6&#x7f;15321300-7&#x7f;15321400-8&#x7f;15321500-9&#x7f;15321600-0&#x7f;15321700-1&#x7f;15321800-2&#x7f;15322000-1&#x7f;15322100-2&#x7f;15330000-0&#x7f;15331000-7&#x7f;15331100-8&#x7f;15331110-1&#x7f;15331120-4&#x7f;15331130-7&#x7f;15331131-4&#x7f;15331132-1&#x7f;15331133-8&#x7f;15331134-5&#x7f;15331135-2&#x7f;15331136-9&#x7f;15331137-6&#x7f;15331138-3&#x7f;15331140-0&#x7f;15331142-4&#x7f;15331150-3&#x7f;15331170-9&#x7f;15331400-1&#x7f;15331410-4&#x7f;15331411-1&#x7f;15331420-7&#x7f;15331423-8&#x7f;15331425-2&#x7f;15331427-6&#x7f;15331428-3&#x7f;15331430-0&#x7f;15331450-6&#x7f;15331460-9&#x7f;15331461-6&#x7f;15331462-3&#x7f;15331463-0&#x7f;15331464-7&#x7f;15331465-4&#x7f;15331466-1&#x7f;15331470-2&#x7f;15331480-5&#x7f;15331500-2&#x7f;15332000-4&#x7f;15332100-5&#x7f;15332140-7&#x7f;15332150-0&#x7f;15332160-3&#x7f;15332170-6&#x7f;15332180-9&#x7f;15332200-6&#x7f;15332230-5&#x7f;15332231-2&#x7f;15332232-9&#x7f;15332240-8&#x7f;15332250-1&#x7f;15332260-4&#x7f;15332261-1&#x7f;15332270-7&#x7f;15332290-3&#x7f;15332291-0&#x7f;15332292-7&#x7f;15332293-4&#x7f;15332294-1&#x7f;15332295-8&#x7f;15332296-5&#x7f;15332300-7&#x7f;15332310-0&#x7f;15332400-8&#x7f;15332410-1&#x7f;15332411-8&#x7f;15332412-5&#x7f;15332419-4&#x7f;15333000-1&#x7f;15400000-2&#x7f;15410000-5&#x7f;15411000-2&#x7f;15411100-3&#x7f;15411110-6&#x7f;15411120-9&#x7f;15411130-2&#x7f;15411140-5&#x7f;15411200-4&#x7f;15411210-7&#x7f;15412000-9&#x7f;15412100-0&#x7f;15412200-1&#x7f;15413000-6&#x7f;15413100-7&#x7f;15420000-8&#x7f;15421000-5&#x7f;15422000-2&#x7f;15423000-9&#x7f;15424000-6&#x7f;15430000-1&#x7f;15431000-8&#x7f;15431100-9&#x7f;15431110-2&#x7f;15431200-0&#x7f;15500000-3&#x7f;15510000-6&#x7f;15511000-3&#x7f;15511100-4&#x7f;15511200-5&#x7f;15511210-8&#x7f;15511300-6&#x7f;15511400-7&#x7f;15511500-8&#x7f;15511600-9&#x7f;15511700-0&#x7f;15512000-0&#x7f;15512100-1&#x7f;15512200-2&#x7f;15512300-3&#x7f;15512900-9&#x7f;15530000-2&#x7f;15540000-5&#x7f;15541000-2&#x7f;15542000-9&#x7f;15542100-0&#x7f;15542200-1&#x7f;15542300-2&#x7f;15543000-6&#x7f;15543100-7&#x7f;15543200-8&#x7f;15543300-9&#x7f;15543400-0&#x7f;15544000-3&#x7f;15545000-0&#x7f;15550000-8&#x7f;15551000-5&#x7f;15551300-8&#x7f;15551310-1&#x7f;15551320-4&#x7f;15551500-0&#x7f;15552000-2&#x7f;15553000-9&#x7f;15554000-6&#x7f;15555000-3&#x7f;15555100-4&#x7f;15555200-5&#x7f;15600000-4&#x7f;15610000-7&#x7f;15611000-4&#x7f;15612000-1&#x7f;15612100-2&#x7f;15612110-5&#x7f;15612120-8&#x7f;15612130-1&#x7f;15612150-7&#x7f;15612190-9&#x7f;15612200-3&#x7f;15612210-6&#x7f;15612220-9&#x7f;15612300-4&#x7f;15612400-5&#x7f;15612410-8&#x7f;15612420-1&#x7f;15612500-6&#x7f;15613000-8&#x7f;15613100-9&#x7f;15613300-1&#x7f;15613310-4&#x7f;15613311-1&#x7f;15613313-5&#x7f;15613319-7&#x7f;15613380-5&#x7f;15614000-5&#x7f;15614100-6&#x7f;15614200-7&#x7f;15614300-8&#x7f;15615000-2&#x7f;15620000-0&#x7f;15621000-7&#x7f;15622000-4&#x7f;15622100-5&#x7f;15622110-8&#x7f;15622120-1&#x7f;15622300-7&#x7f;15622310-0&#x7f;15622320-3&#x7f;15622321-0&#x7f;15622322-7&#x7f;15623000-1&#x7f;15624000-8&#x7f;15625000-5&#x7f;15626000-2&#x7f;15700000-5&#x7f;15710000-8&#x7f;15711000-5&#x7f;15712000-2&#x7f;15713000-9&#x7f;15800000-6&#x7f;15810000-9&#x7f;15811000-6&#x7f;15811100-7&#x7f;15811200-8&#x7f;15811300-9&#x7f;15811400-0&#x7f;15811500-1&#x7f;15811510-4&#x7f;15811511-1&#x7f;15812000-3&#x7f;15812100-4&#x7f;15812120-0&#x7f;15812121-7&#x7f;15812122-4&#x7f;15812200-5&#x7f;15813000-0&#x7f;15820000-2&#x7f;15821000-9&#x7f;15821100-0&#x7f;15821110-3&#x7f;15821130-9&#x7f;15821150-5&#x7f;15821200-1&#x7f;15830000-5&#x7f;15831000-2&#x7f;15831200-4&#x7f;15831300-5&#x7f;15831400-6&#x7f;15831500-7&#x7f;15831600-8&#x7f;15832000-9&#x7f;15833000-6&#x7f;15833100-7&#x7f;15833110-0&#x7f;15840000-8&#x7f;15841000-5&#x7f;15841100-6&#x7f;15841200-7&#x7f;15841300-8&#x7f;15841400-9&#x7f;15842000-2&#x7f;15842100-3&#x7f;15842200-4&#x7f;15842210-7&#x7f;15842220-0&#x7f;15842300-5&#x7f;15842310-8&#x7f;15842320-1&#x7f;15842400-6&#x7f;15850000-1&#x7f;15851000-8&#x7f;15851100-9&#x7f;15851200-0&#x7f;15851210-3&#x7f;15851220-6&#x7f;15851230-9&#x7f;15851250-5&#x7f;15851290-7&#x7f;15860000-4&#x7f;15861000-1&#x7f;15861100-2&#x7f;15861200-3&#x7f;15862000-8&#x7f;15863000-5&#x7f;15863100-6&#x7f;15863200-7&#x7f;15864000-2&#x7f;15864100-3&#x7f;15865000-9&#x7f;15870000-7&#x7f;15871000-4&#x7f;15871100-5&#x7f;15871110-8&#x7f;15871200-6&#x7f;15871210-9&#x7f;15871230-5&#x7f;15871250-1&#x7f;15871260-4&#x7f;15871270-7&#x7f;15871273-8&#x7f;15871274-5&#x7f;15871279-0&#x7f;15872000-1&#x7f;15872100-2&#x7f;15872200-3&#x7f;15872300-4&#x7f;15872400-5&#x7f;15872500-6&#x7f;15880000-0&#x7f;15881000-7&#x7f;15882000-4&#x7f;15884000-8&#x7f;15890000-3&#x7f;15891000-0&#x7f;15891100-1&#x7f;15891200-2&#x7f;15891300-3&#x7f;15891400-4&#x7f;15891410-7&#x7f;15891500-5&#x7f;15891600-6&#x7f;15891610-9&#x7f;15891900-9&#x7f;15892000-7&#x7f;15892100-8&#x7f;15892200-9&#x7f;15892400-1&#x7f;15893000-4&#x7f;15893100-5&#x7f;15893200-6&#x7f;15893300-7&#x7f;15894000-1&#x7f;15894100-2&#x7f;15894200-3&#x7f;15894210-6&#x7f;15894220-9&#x7f;15894300-4&#x7f;15894400-5&#x7f;15894500-6&#x7f;15894600-7&#x7f;15894700-8&#x7f;15895000-8&#x7f;15895100-9&#x7f;15896000-5&#x7f;15897000-2&#x7f;15897100-3&#x7f;15897200-4&#x7f;15897300-5&#x7f;15898000-9&#x7f;15899000-6&#x7f;15900000-7&#x7f;15910000-0&#x7f;15911000-7&#x7f;15911100-8&#x7f;15911200-9&#x7f;15930000-6&#x7f;15931000-3&#x7f;15931100-4&#x7f;15931200-5&#x7f;15931300-6&#x7f;15931400-7&#x7f;15931500-8&#x7f;15931600-9&#x7f;15932000-0&#x7f;15940000-9&#x7f;15941000-6&#x7f;15942000-3&#x7f;15950000-2&#x7f;15951000-9&#x7f;15960000-5&#x7f;15961000-2&#x7f;15961100-3&#x7f;15962000-9&#x7f;15980000-1&#x7f;15981000-8&#x7f;15981100-9&#x7f;15981200-0&#x7f;15981300-1&#x7f;15981310-4&#x7f;15981320-7&#x7f;15981400-2&#x7f;15982000-5&#x7f;15982100-6&#x7f;15982200-7&#x7f;15990000-4&#x7f;15991000-1&#x7f;15991100-2&#x7f;15991200-3&#x7f;15991300-4&#x7f;15992000-8&#x7f;15992100-9&#x7f;15993000-5&#x7f;15994000-2&#x7f;15994100-3&#x7f;15994200-4&#x7f;16000000-5&#x7f;16100000-6&#x7f;16110000-9&#x7f;16120000-2&#x7f;16130000-5&#x7f;16140000-8&#x7f;16141000-5&#x7f;16150000-1&#x7f;16160000-4&#x7f;16300000-8&#x7f;16310000-1&#x7f;16311000-8&#x7f;16311100-9&#x7f;16320000-4&#x7f;16330000-7&#x7f;16331000-4&#x7f;16340000-0&#x7f;16400000-9&#x7f;16500000-0&#x7f;16510000-3&#x7f;16520000-6&#x7f;16530000-9&#x7f;16540000-2&#x7f;16600000-1&#x7f;16610000-4&#x7f;16611000-1&#x7f;16611100-2&#x7f;16611200-3&#x7f;16612000-8&#x7f;16612100-9&#x7f;16612200-0&#x7f;16613000-5&#x7f;16620000-7&#x7f;16630000-0&#x7f;16640000-3&#x7f;16650000-6&#x7f;16651000-3&#x7f;16700000-2&#x7f;16710000-5&#x7f;16720000-8&#x7f;16730000-1&#x7f;16800000-3&#x7f;16810000-6&#x7f;16820000-9&#x7f;18000000-9&#x7f;18100000-0&#x7f;18110000-3&#x7f;18113000-4&#x7f;18114000-1&#x7f;18130000-9&#x7f;18132000-3&#x7f;18132100-4&#x7f;18132200-5&#x7f;18140000-2&#x7f;18141000-9&#x7f;18142000-6&#x7f;18143000-3&#x7f;18200000-1&#x7f;18210000-4&#x7f;18211000-1&#x7f;18212000-8&#x7f;18213000-5&#x7f;18220000-7&#x7f;18221000-4&#x7f;18221100-5&#x7f;18221200-6&#x7f;18221300-7&#x7f;18222000-1&#x7f;18222100-2&#x7f;18222200-3&#x7f;18223000-8&#x7f;18223100-9&#x7f;18223200-0&#x7f;18224000-5&#x7f;18230000-0&#x7f;18231000-7&#x7f;18232000-4&#x7f;18233000-1&#x7f;18234000-8&#x7f;18235000-5&#x7f;18235100-6&#x7f;18235200-7&#x7f;18235300-8&#x7f;18235400-9&#x7f;18300000-2&#x7f;18310000-5&#x7f;18311000-2&#x7f;18312000-9&#x7f;18313000-6&#x7f;18314000-3&#x7f;18315000-0&#x7f;18316000-7&#x7f;18317000-4&#x7f;18318000-1&#x7f;18318100-2&#x7f;18318200-3&#x7f;18318300-4&#x7f;18318400-5&#x7f;18318500-6&#x7f;18320000-8&#x7f;18321000-5&#x7f;18322000-2&#x7f;18323000-9&#x7f;18330000-1&#x7f;18331000-8&#x7f;18332000-5&#x7f;18333000-2&#x7f;18400000-3&#x7f;18410000-6&#x7f;18411000-3&#x7f;18412000-0&#x7f;18412100-1&#x7f;18412200-2&#x7f;18412300-3&#x7f;18412800-8&#x7f;18420000-9&#x7f;18421000-6&#x7f;18422000-3&#x7f;18423000-0&#x7f;18424000-7&#x7f;18424300-0&#x7f;18424400-1&#x7f;18424500-2&#x7f;18425000-4&#x7f;18425100-5&#x7f;18440000-5&#x7f;18441000-2&#x7f;18443000-6&#x7f;18443100-7&#x7f;18443300-9&#x7f;18443310-2&#x7f;18443320-5&#x7f;18443330-8&#x7f;18443340-1&#x7f;18443400-0&#x7f;18443500-1&#x7f;18444000-3&#x7f;18444100-4&#x7f;18444110-7&#x7f;18444111-4&#x7f;18444112-1&#x7f;18444200-5&#x7f;18450000-8&#x7f;18451000-5&#x7f;18451100-6&#x7f;18452000-2&#x7f;18453000-9&#x7f;18500000-4&#x7f;18510000-7&#x7f;18511000-4&#x7f;18511100-5&#x7f;18511200-6&#x7f;18511300-7&#x7f;18511400-8&#x7f;18511500-9&#x7f;18511600-0&#x7f;18512000-1&#x7f;18512100-2&#x7f;18512200-3&#x7f;18513000-8&#x7f;18513100-9&#x7f;18513200-0&#x7f;18513300-1&#x7f;18513400-2&#x7f;18513500-3&#x7f;18520000-0&#x7f;18521000-7&#x7f;18521100-8&#x7f;18522000-4&#x7f;18523000-1&#x7f;18530000-3&#x7f;18600000-5&#x7f;18610000-8&#x7f;18611000-5&#x7f;18612000-2&#x7f;18613000-9&#x7f;18620000-1&#x7f;18800000-7&#x7f;18810000-0&#x7f;18811000-7&#x7f;18812000-4&#x7f;18812100-5&#x7f;18812200-6&#x7f;18812300-7&#x7f;18812400-8&#x7f;18813000-1&#x7f;18813100-2&#x7f;18813200-3&#x7f;18813300-4&#x7f;18814000-8&#x7f;18815000-5&#x7f;18815100-6&#x7f;18815200-7&#x7f;18815300-8&#x7f;18815400-9&#x7f;18816000-2&#x7f;18820000-3&#x7f;18821000-0&#x7f;18821100-1&#x7f;18822000-7&#x7f;18823000-4&#x7f;18824000-1&#x7f;18830000-6&#x7f;18831000-3&#x7f;18832000-0&#x7f;18832100-1&#x7f;18840000-9&#x7f;18841000-6&#x7f;18842000-3&#x7f;18843000-0&#x7f;18900000-8&#x7f;18910000-1&#x7f;18911000-8&#x7f;18912000-5&#x7f;18913000-2&#x7f;18920000-4&#x7f;18921000-1&#x7f;18923000-5&#x7f;18923100-6&#x7f;18923200-7&#x7f;18924000-2&#x7f;18925000-9&#x7f;18925100-0&#x7f;18925200-1&#x7f;18929000-7&#x7f;18930000-7&#x7f;18931000-4&#x7f;18931100-5&#x7f;18932000-1&#x7f;18933000-8&#x7f;18933100-9&#x7f;18934000-5&#x7f;18935000-2&#x7f;18936000-9&#x7f;18937000-6&#x7f;18937100-7&#x7f;18938000-3&#x7f;18939000-0&#x7f;19000000-6&#x7f;19100000-7&#x7f;19110000-0&#x7f;19120000-3&#x7f;19130000-6&#x7f;19131000-3&#x7f;19132000-0&#x7f;19133000-7&#x7f;19140000-9&#x7f;19141000-6&#x7f;19142000-3&#x7f;19143000-0&#x7f;19144000-7&#x7f;19160000-5&#x7f;19170000-8&#x7f;19200000-8&#x7f;19210000-1&#x7f;19211000-8&#x7f;19211100-9&#x7f;19212000-5&#x7f;19212100-6&#x7f;19212200-7&#x7f;19212300-8&#x7f;19212310-1&#x7f;19212400-9&#x7f;19212500-0&#x7f;19212510-3&#x7f;19220000-4&#x7f;19230000-7&#x7f;19231000-4&#x7f;19240000-0&#x7f;19241000-7&#x7f;19242000-4&#x7f;19243000-1&#x7f;19244000-8&#x7f;19245000-5&#x7f;19250000-3&#x7f;19251000-0&#x7f;19251100-1&#x7f;19252000-7&#x7f;19260000-6&#x7f;19270000-9&#x7f;19280000-2&#x7f;19281000-9&#x7f;19282000-6&#x7f;19283000-3&#x7f;19400000-0&#x7f;19410000-3&#x7f;19420000-6&#x7f;19430000-9&#x7f;19431000-6&#x7f;19432000-3&#x7f;19433000-0&#x7f;19434000-7&#x7f;19435000-4&#x7f;19435100-5&#x7f;19435200-6&#x7f;19436000-1&#x7f;19440000-2&#x7f;19441000-9&#x7f;19442000-6&#x7f;19442100-7&#x7f;19442200-8&#x7f;19500000-1&#x7f;19510000-4&#x7f;19511000-1&#x7f;19511100-2&#x7f;19511200-3&#x7f;19511300-4&#x7f;19512000-8&#x7f;19513000-5&#x7f;19513100-6&#x7f;19513200-7&#x7f;19514000-2&#x7f;19520000-7&#x7f;19521000-4&#x7f;19521100-5&#x7f;19521200-6&#x7f;19522000-1&#x7f;19522100-2&#x7f;19522110-5&#x7f;19600000-2&#x7f;19610000-5&#x7f;19620000-8&#x7f;19630000-1&#x7f;19640000-4&#x7f;19700000-3&#x7f;19710000-6&#x7f;19720000-9&#x7f;19721000-6&#x7f;19722000-3&#x7f;19723000-0&#x7f;19724000-7&#x7f;19730000-2&#x7f;19731000-9&#x7f;19732000-6&#x7f;19733000-3&#x7f;22000000-0&#x7f;22100000-1&#x7f;22110000-4&#x7f;22111000-1&#x7f;22112000-8&#x7f;22113000-5&#x7f;22114000-2&#x7f;22114100-3&#x7f;22114200-4&#x7f;22114300-5&#x7f;22114310-8&#x7f;22114311-5&#x7f;22114400-6&#x7f;22114500-7&#x7f;22120000-7&#x7f;22121000-4&#x7f;22130000-0&#x7f;22140000-3&#x7f;22150000-6&#x7f;22160000-9&#x7f;22200000-2&#x7f;22210000-5&#x7f;22211000-2&#x7f;22211100-3&#x7f;22212000-9&#x7f;22212100-0&#x7f;22213000-6&#x7f;22300000-3&#x7f;22310000-6&#x7f;22312000-0&#x7f;22313000-7&#x7f;22314000-4&#x7f;22315000-1&#x7f;22320000-9&#x7f;22321000-6&#x7f;22400000-4&#x7f;22410000-7&#x7f;22411000-4&#x7f;22412000-1&#x7f;22413000-8&#x7f;22414000-5&#x7f;22420000-0&#x7f;22430000-3&#x7f;22440000-6&#x7f;22450000-9&#x7f;22451000-6&#x7f;22452000-3&#x7f;22453000-0&#x7f;22454000-7&#x7f;22455000-4&#x7f;22455100-5&#x7f;22456000-1&#x7f;22457000-8&#x7f;22458000-5&#x7f;22459000-2&#x7f;22459100-3&#x7f;22460000-2&#x7f;22461000-9&#x7f;22461100-0&#x7f;22462000-6&#x7f;22470000-5&#x7f;22471000-2&#x7f;22472000-9&#x7f;22473000-6&#x7f;22500000-5&#x7f;22510000-8&#x7f;22520000-1&#x7f;22521000-8&#x7f;22600000-6&#x7f;22610000-9&#x7f;22611000-6&#x7f;22612000-3&#x7f;22800000-8&#x7f;22810000-1&#x7f;22813000-2&#x7f;22814000-9&#x7f;22815000-6&#x7f;22816000-3&#x7f;22816100-4&#x7f;22816200-5&#x7f;22816300-6&#x7f;22817000-0&#x7f;22819000-4&#x7f;22820000-4&#x7f;22821000-1&#x7f;22822000-8&#x7f;22822100-9&#x7f;22822200-0&#x7f;22830000-7&#x7f;22831000-4&#x7f;22832000-1&#x7f;22840000-0&#x7f;22841000-7&#x7f;22841100-8&#x7f;22841200-9&#x7f;22850000-3&#x7f;22851000-0&#x7f;22852000-7&#x7f;22852100-8&#x7f;22853000-4&#x7f;22900000-9&#x7f;22990000-6&#x7f;22991000-3&#x7f;22992000-0&#x7f;22993000-7&#x7f;22993100-8&#x7f;22993200-9&#x7f;22993300-0&#x7f;22993400-1&#x7f;24000000-4&#x7f;24100000-5&#x7f;24110000-8&#x7f;24111000-5&#x7f;24111100-6&#x7f;24111200-7&#x7f;24111300-8&#x7f;24111400-9&#x7f;24111500-0&#x7f;24111600-1&#x7f;24111700-2&#x7f;24111800-3&#x7f;24111900-4&#x7f;24112000-2&#x7f;24112100-3&#x7f;24112200-4&#x7f;24112300-5&#x7f;24113000-9&#x7f;24113100-0&#x7f;24113200-1&#x7f;24200000-6&#x7f;24210000-9&#x7f;24211000-6&#x7f;24211100-7&#x7f;24211200-8&#x7f;24211300-9&#x7f;24212000-3&#x7f;24212100-4&#x7f;24212200-5&#x7f;24212300-6&#x7f;24212400-7&#x7f;24212500-8&#x7f;24212600-9&#x7f;24212610-2&#x7f;24212620-5&#x7f;24212630-8&#x7f;24212640-1&#x7f;24212650-4&#x7f;24213000-0&#x7f;24220000-2&#x7f;24221000-9&#x7f;24222000-6&#x7f;24223000-3&#x7f;24224000-0&#x7f;24225000-7&#x7f;24300000-7&#x7f;24310000-0&#x7f;24311000-7&#x7f;24311100-8&#x7f;24311110-1&#x7f;24311120-4&#x7f;24311130-7&#x7f;24311140-0&#x7f;24311150-3&#x7f;24311160-6&#x7f;24311170-9&#x7f;24311180-2&#x7f;24311200-9&#x7f;24311300-0&#x7f;24311310-3&#x7f;24311400-1&#x7f;24311410-4&#x7f;24311411-1&#x7f;24311420-7&#x7f;24311430-0&#x7f;24311440-3&#x7f;24311450-6&#x7f;24311460-9&#x7f;24311470-2&#x7f;24311500-2&#x7f;24311510-5&#x7f;24311511-2&#x7f;24311520-8&#x7f;24311521-5&#x7f;24311522-2&#x7f;24311600-3&#x7f;24311700-4&#x7f;24311800-5&#x7f;24311900-6&#x7f;24312000-4&#x7f;24312100-5&#x7f;24312110-8&#x7f;24312120-1&#x7f;24312121-8&#x7f;24312122-5&#x7f;24312123-2&#x7f;24312130-4&#x7f;24312200-6&#x7f;24312210-9&#x7f;24312220-2&#x7f;24313000-1&#x7f;24313100-2&#x7f;24313110-5&#x7f;24313111-2&#x7f;24313112-9&#x7f;24313120-8&#x7f;24313121-5&#x7f;24313122-2&#x7f;24313123-9&#x7f;24313124-6&#x7f;24313125-3&#x7f;24313126-0&#x7f;24313200-3&#x7f;24313210-6&#x7f;24313220-9&#x7f;24313300-4&#x7f;24313310-7&#x7f;24313320-0&#x7f;24313400-5&#x7f;24314000-8&#x7f;24314100-9&#x7f;24314200-0&#x7f;24315000-5&#x7f;24315100-6&#x7f;24315200-7&#x7f;24315210-0&#x7f;24315220-3&#x7f;24315230-6&#x7f;24315240-9&#x7f;24315300-8&#x7f;24315400-9&#x7f;24315500-0&#x7f;24315600-1&#x7f;24315610-4&#x7f;24315700-2&#x7f;24316000-2&#x7f;24317000-9&#x7f;24317100-0&#x7f;24317200-1&#x7f;24320000-3&#x7f;24321000-0&#x7f;24321100-1&#x7f;24321110-4&#x7f;24321111-1&#x7f;24321112-8&#x7f;24321113-5&#x7f;24321114-2&#x7f;24321115-9&#x7f;24321120-7&#x7f;24321200-2&#x7f;24321210-5&#x7f;24321220-8&#x7f;24321221-5&#x7f;24321222-2&#x7f;24321223-9&#x7f;24321224-6&#x7f;24321225-3&#x7f;24321226-0&#x7f;24321300-3&#x7f;24321310-6&#x7f;24321320-9&#x7f;24322000-7&#x7f;24322100-8&#x7f;24322200-9&#x7f;24322210-2&#x7f;24322220-5&#x7f;24322300-0&#x7f;24322310-3&#x7f;24322320-6&#x7f;24322400-1&#x7f;24322500-2&#x7f;24322510-5&#x7f;24323000-4&#x7f;24323100-5&#x7f;24323200-6&#x7f;24323210-9&#x7f;24323220-2&#x7f;24323300-7&#x7f;24323310-0&#x7f;24323320-3&#x7f;24323400-8&#x7f;24324000-1&#x7f;24324100-2&#x7f;24324200-3&#x7f;24324300-4&#x7f;24324400-5&#x7f;24325000-8&#x7f;24326000-5&#x7f;24326100-6&#x7f;24326200-7&#x7f;24326300-8&#x7f;24326310-1&#x7f;24326320-4&#x7f;24327000-2&#x7f;24327100-3&#x7f;24327200-4&#x7f;24327300-5&#x7f;24327310-8&#x7f;24327311-5&#x7f;24327320-1&#x7f;24327330-4&#x7f;24327400-6&#x7f;24327500-7&#x7f;24400000-8&#x7f;24410000-1&#x7f;24411000-8&#x7f;24411100-9&#x7f;24412000-5&#x7f;24413000-2&#x7f;24413100-3&#x7f;24413200-4&#x7f;24413300-5&#x7f;24420000-4&#x7f;24421000-1&#x7f;24422000-8&#x7f;24430000-7&#x7f;24440000-0&#x7f;24450000-3&#x7f;24451000-0&#x7f;24452000-7&#x7f;24453000-4&#x7f;24454000-1&#x7f;24455000-8&#x7f;24456000-5&#x7f;24457000-2&#x7f;24500000-9&#x7f;24510000-2&#x7f;24520000-5&#x7f;24530000-8&#x7f;24540000-1&#x7f;24541000-8&#x7f;24542000-5&#x7f;24550000-4&#x7f;24560000-7&#x7f;24570000-0&#x7f;24580000-3&#x7f;24590000-6&#x7f;24600000-0&#x7f;24610000-3&#x7f;24611000-0&#x7f;24611100-1&#x7f;24612000-7&#x7f;24612100-8&#x7f;24612200-9&#x7f;24612300-0&#x7f;24613000-4&#x7f;24613100-5&#x7f;24613200-6&#x7f;24615000-8&#x7f;24900000-3&#x7f;24910000-6&#x7f;24911000-3&#x7f;24911200-5&#x7f;24920000-9&#x7f;24930000-2&#x7f;24931000-9&#x7f;24931200-1&#x7f;24931210-4&#x7f;24931220-7&#x7f;24931230-0&#x7f;24931240-3&#x7f;24931250-6&#x7f;24931260-9&#x7f;24950000-8&#x7f;24951000-5&#x7f;24951100-6&#x7f;24951110-9&#x7f;24951120-2&#x7f;24951130-5&#x7f;24951200-7&#x7f;24951210-0&#x7f;24951220-3&#x7f;24951230-6&#x7f;24951300-8&#x7f;24951310-1&#x7f;24951311-8&#x7f;24951400-9&#x7f;24952000-2&#x7f;24952100-3&#x7f;24953000-9&#x7f;24954000-6&#x7f;24954100-7&#x7f;24954200-8&#x7f;24955000-3&#x7f;24956000-0&#x7f;24957000-7&#x7f;24957100-8&#x7f;24957200-9&#x7f;24958000-4&#x7f;24958100-5&#x7f;24958200-6&#x7f;24958300-7&#x7f;24958400-8&#x7f;24959000-1&#x7f;24959100-2&#x7f;24959200-3&#x7f;24960000-1&#x7f;24961000-8&#x7f;24962000-5&#x7f;24963000-2&#x7f;24964000-9&#x7f;24965000-6&#x7f;30000000-9&#x7f;30100000-0&#x7f;30110000-3&#x7f;30111000-0&#x7f;30120000-6&#x7f;30121000-3&#x7f;30121100-4&#x7f;30121200-5&#x7f;30121300-6&#x7f;30121400-7&#x7f;30121410-0&#x7f;30121420-3&#x7f;30121430-6&#x7f;30122000-0&#x7f;30122100-1&#x7f;30122200-2&#x7f;30123000-7&#x7f;30123100-8&#x7f;30123200-9&#x7f;30123300-0&#x7f;30123400-1&#x7f;30123500-2&#x7f;30123600-3&#x7f;30123610-6&#x7f;30123620-9&#x7f;30123630-2&#x7f;30124000-4&#x7f;30124100-5&#x7f;30124110-8&#x7f;30124120-1&#x7f;30124130-4&#x7f;30124140-7&#x7f;30124150-0&#x7f;30124200-6&#x7f;30124300-7&#x7f;30124400-8&#x7f;30124500-9&#x7f;30124510-2&#x7f;30124520-5&#x7f;30124530-8&#x7f;30125000-1&#x7f;30125100-2&#x7f;30125110-5&#x7f;30125120-8&#x7f;30125130-1&#x7f;30130000-9&#x7f;30131000-6&#x7f;30131100-7&#x7f;30131200-8&#x7f;30131300-9&#x7f;30131400-0&#x7f;30131500-1&#x7f;30131600-2&#x7f;30131700-3&#x7f;30131800-4&#x7f;30132000-3&#x7f;30132100-4&#x7f;30132200-5&#x7f;30132300-6&#x7f;30133000-0&#x7f;30133100-1&#x7f;30140000-2&#x7f;30141000-9&#x7f;30141100-0&#x7f;30141200-1&#x7f;30141300-2&#x7f;30141400-3&#x7f;30142000-6&#x7f;30142100-7&#x7f;30142200-8&#x7f;30144000-0&#x7f;30144100-1&#x7f;30144200-2&#x7f;30144300-3&#x7f;30144400-4&#x7f;30145000-7&#x7f;30145100-8&#x7f;30150000-5&#x7f;30151000-2&#x7f;30152000-9&#x7f;30160000-8&#x7f;30161000-5&#x7f;30162000-2&#x7f;30163000-9&#x7f;30163100-0&#x7f;30170000-1&#x7f;30171000-8&#x7f;30172000-5&#x7f;30173000-2&#x7f;30174000-9&#x7f;30175000-6&#x7f;30176000-3&#x7f;30177000-0&#x7f;30178000-7&#x7f;30179000-4&#x7f;30180000-4&#x7f;30181000-1&#x7f;30182000-8&#x7f;30190000-7&#x7f;30191000-4&#x7f;30191100-5&#x7f;30191110-8&#x7f;30191120-1&#x7f;30191130-4&#x7f;30191140-7&#x7f;30191200-6&#x7f;30191400-8&#x7f;30192000-1&#x7f;30192100-2&#x7f;30192110-5&#x7f;30192111-2&#x7f;30192112-9&#x7f;30192113-6&#x7f;30192121-5&#x7f;30192122-2&#x7f;30192123-9&#x7f;30192124-6&#x7f;30192125-3&#x7f;30192126-0&#x7f;30192127-7&#x7f;30192130-1&#x7f;30192131-8&#x7f;30192132-5&#x7f;30192133-2&#x7f;30192134-9&#x7f;30192150-7&#x7f;30192151-4&#x7f;30192152-1&#x7f;30192153-8&#x7f;30192154-5&#x7f;30192155-2&#x7f;30192160-0&#x7f;30192170-3&#x7f;30192200-3&#x7f;30192300-4&#x7f;30192310-7&#x7f;30192320-0&#x7f;30192330-3&#x7f;30192340-6&#x7f;30192350-9&#x7f;30192400-5&#x7f;30192500-6&#x7f;30192600-7&#x7f;30192700-8&#x7f;30192800-9&#x7f;30192900-0&#x7f;30192910-3&#x7f;30192920-6&#x7f;30192930-9&#x7f;30192940-2&#x7f;30192950-5&#x7f;30193000-8&#x7f;30193100-9&#x7f;30193200-0&#x7f;30193300-1&#x7f;30193400-2&#x7f;30193500-3&#x7f;30193600-4&#x7f;30193700-5&#x7f;30193800-6&#x7f;30193900-7&#x7f;30194000-5&#x7f;30194100-6&#x7f;30194200-7&#x7f;30194210-0&#x7f;30194220-3&#x7f;30194300-8&#x7f;30194310-1&#x7f;30194320-4&#x7f;30194400-9&#x7f;30194500-0&#x7f;30194600-1&#x7f;30194700-2&#x7f;30194800-3&#x7f;30194810-6&#x7f;30194820-9&#x7f;30194900-4&#x7f;30195000-2&#x7f;30195100-3&#x7f;30195200-4&#x7f;30195300-5&#x7f;30195400-6&#x7f;30195500-7&#x7f;30195600-8&#x7f;30195700-9&#x7f;30195800-0&#x7f;30195900-1&#x7f;30195910-4&#x7f;30195911-1&#x7f;30195912-8&#x7f;30195913-5&#x7f;30195920-7&#x7f;30195921-4&#x7f;30196000-9&#x7f;30196100-0&#x7f;30196200-1&#x7f;30196300-2&#x7f;30197000-6&#x7f;30197100-7&#x7f;30197110-0&#x7f;30197120-3&#x7f;30197130-6&#x7f;30197200-8&#x7f;30197210-1&#x7f;30197220-4&#x7f;30197221-1&#x7f;30197300-9&#x7f;30197310-2&#x7f;30197320-5&#x7f;30197321-2&#x7f;30197330-8&#x7f;30197400-0&#x7f;30197500-1&#x7f;30197510-4&#x7f;30197600-2&#x7f;30197610-5&#x7f;30197620-8&#x7f;30197621-5&#x7f;30197630-1&#x7f;30197640-4&#x7f;30197641-1&#x7f;30197642-8&#x7f;30197643-5&#x7f;30197644-2&#x7f;30197645-9&#x7f;30198000-3&#x7f;30198100-4&#x7f;30199000-0&#x7f;30199100-1&#x7f;30199110-4&#x7f;30199120-7&#x7f;30199130-0&#x7f;30199140-3&#x7f;30199200-2&#x7f;30199210-5&#x7f;30199220-8&#x7f;30199230-1&#x7f;30199240-4&#x7f;30199300-3&#x7f;30199310-6&#x7f;30199320-9&#x7f;30199330-2&#x7f;30199340-5&#x7f;30199400-4&#x7f;30199410-7&#x7f;30199500-5&#x7f;30199600-6&#x7f;30199700-7&#x7f;30199710-0&#x7f;30199711-7&#x7f;30199712-4&#x7f;30199713-1&#x7f;30199720-3&#x7f;30199730-6&#x7f;30199731-3&#x7f;30199740-9&#x7f;30199750-2&#x7f;30199760-5&#x7f;30199761-2&#x7f;30199762-9&#x7f;30199763-6&#x7f;30199770-8&#x7f;30199780-1&#x7f;30199790-4&#x7f;30199791-1&#x7f;30199792-8&#x7f;30199793-5&#x7f;30200000-1&#x7f;30210000-4&#x7f;30211000-1&#x7f;30211100-2&#x7f;30211200-3&#x7f;30211300-4&#x7f;30211400-5&#x7f;30211500-6&#x7f;30212000-8&#x7f;30212100-9&#x7f;30213000-5&#x7f;30213100-6&#x7f;30213200-7&#x7f;30213300-8&#x7f;30213400-9&#x7f;30213500-0&#x7f;30214000-2&#x7f;30215000-9&#x7f;30215100-0&#x7f;30216000-6&#x7f;30216100-7&#x7f;30216110-0&#x7f;30216120-3&#x7f;30216130-6&#x7f;30216200-8&#x7f;30216300-9&#x7f;30220000-7&#x7f;30221000-4&#x7f;30230000-0&#x7f;30231000-7&#x7f;30231100-8&#x7f;30231200-9&#x7f;30231300-0&#x7f;30231310-3&#x7f;30231320-6&#x7f;30232000-4&#x7f;30232100-5&#x7f;30232110-8&#x7f;30232120-1&#x7f;30232130-4&#x7f;30232140-7&#x7f;30232150-0&#x7f;30232600-0&#x7f;30232700-1&#x7f;30233000-1&#x7f;30233100-2&#x7f;30233110-5&#x7f;30233120-8&#x7f;30233130-1&#x7f;30233131-8&#x7f;30233132-5&#x7f;30233140-4&#x7f;30233141-1&#x7f;30233150-7&#x7f;30233151-4&#x7f;30233152-1&#x7f;30233153-8&#x7f;30233160-0&#x7f;30233161-7&#x7f;30233170-3&#x7f;30233180-6&#x7f;30233190-9&#x7f;30233300-4&#x7f;30233310-7&#x7f;30233320-0&#x7f;30234000-8&#x7f;30234100-9&#x7f;30234200-0&#x7f;30234300-1&#x7f;30234400-2&#x7f;30234500-3&#x7f;30234600-4&#x7f;30234700-5&#x7f;30236000-2&#x7f;30236100-3&#x7f;30236110-6&#x7f;30236111-3&#x7f;30236112-0&#x7f;30236113-7&#x7f;30236114-4&#x7f;30236115-1&#x7f;30236120-9&#x7f;30236121-6&#x7f;30236122-3&#x7f;30236123-0&#x7f;30236200-4&#x7f;30237000-9&#x7f;30237100-0&#x7f;30237110-3&#x7f;30237120-6&#x7f;30237121-3&#x7f;30237130-9&#x7f;30237131-6&#x7f;30237132-3&#x7f;30237133-0&#x7f;30237134-7&#x7f;30237135-4&#x7f;30237136-1&#x7f;30237140-2&#x7f;30237200-1&#x7f;30237210-4&#x7f;30237220-7&#x7f;30237230-0&#x7f;30237240-3&#x7f;30237250-6&#x7f;30237251-3&#x7f;30237252-0&#x7f;30237253-7&#x7f;30237260-9&#x7f;30237270-2&#x7f;30237280-5&#x7f;30237290-8&#x7f;30237295-3&#x7f;30237300-2&#x7f;30237310-5&#x7f;30237320-8&#x7f;30237330-1&#x7f;30237340-4&#x7f;30237350-7&#x7f;30237360-0&#x7f;30237370-3&#x7f;30237380-6&#x7f;30237400-3&#x7f;30237410-6&#x7f;30237420-9&#x7f;30237430-2&#x7f;30237440-5&#x7f;30237450-8&#x7f;30237460-1&#x7f;30237461-8&#x7f;30237470-4&#x7f;30237475-9&#x7f;30237480-7&#x7f;30238000-6&#x7f;31000000-6&#x7f;31100000-7&#x7f;31110000-0&#x7f;31111000-7&#x7f;31120000-3&#x7f;31121000-0&#x7f;31121100-1&#x7f;31121110-4&#x7f;31121111-1&#x7f;31121200-2&#x7f;31121300-3&#x7f;31121310-6&#x7f;31121320-9&#x7f;31121330-2&#x7f;31121331-9&#x7f;31121340-5&#x7f;31122000-7&#x7f;31122100-8&#x7f;31124000-1&#x7f;31124100-2&#x7f;31124200-3&#x7f;31126000-5&#x7f;31127000-2&#x7f;31128000-9&#x7f;31130000-6&#x7f;31131000-3&#x7f;31131100-4&#x7f;31131200-5&#x7f;31132000-0&#x7f;31140000-9&#x7f;31141000-6&#x7f;31150000-2&#x7f;31151000-9&#x7f;31153000-3&#x7f;31154000-0&#x7f;31155000-7&#x7f;31156000-4&#x7f;31157000-1&#x7f;31158000-8&#x7f;31158100-9&#x7f;31158200-0&#x7f;31158300-1&#x7f;31160000-5&#x7f;31161000-2&#x7f;31161100-3&#x7f;31161200-4&#x7f;31161300-5&#x7f;31161400-6&#x7f;31161500-7&#x7f;31161600-8&#x7f;31161700-9&#x7f;31161800-0&#x7f;31161900-1&#x7f;31162000-9&#x7f;31162100-0&#x7f;31170000-8&#x7f;31171000-5&#x7f;31172000-2&#x7f;31173000-9&#x7f;31174000-6&#x7f;31200000-8&#x7f;31210000-1&#x7f;31211000-8&#x7f;31211100-9&#x7f;31211110-2&#x7f;31211200-0&#x7f;31211300-1&#x7f;31211310-4&#x7f;31211320-7&#x7f;31211330-0&#x7f;31211340-3&#x7f;31212000-5&#x7f;31212100-6&#x7f;31212200-7&#x7f;31212300-8&#x7f;31212400-9&#x7f;31213000-2&#x7f;31213100-3&#x7f;31213200-4&#x7f;31213300-5&#x7f;31213400-6&#x7f;31214000-9&#x7f;31214100-0&#x7f;31214110-3&#x7f;31214120-6&#x7f;31214130-9&#x7f;31214140-2&#x7f;31214150-5&#x7f;31214160-8&#x7f;31214170-1&#x7f;31214180-4&#x7f;31214190-7&#x7f;31214200-1&#x7f;31214300-2&#x7f;31214400-3&#x7f;31214500-4&#x7f;31214510-7&#x7f;31214520-0&#x7f;31215000-6&#x7f;31216000-3&#x7f;31216100-4&#x7f;31216200-5&#x7f;31217000-0&#x7f;31218000-7&#x7f;31219000-4&#x7f;31220000-4&#x7f;31221000-1&#x7f;31221100-2&#x7f;31221200-3&#x7f;31221300-4&#x7f;31221400-5&#x7f;31221500-6&#x7f;31221600-7&#x7f;31221700-8&#x7f;31223000-5&#x7f;31224000-2&#x7f;31224100-3&#x7f;31224200-4&#x7f;31224300-5&#x7f;31224400-6&#x7f;31224500-7&#x7f;31224600-8&#x7f;31224700-9&#x7f;31224800-0&#x7f;31224810-3&#x7f;31230000-7&#x7f;31300000-9&#x7f;31310000-2&#x7f;31311000-9&#x7f;31320000-5&#x7f;31321000-2&#x7f;31321100-3&#x7f;31321200-4&#x7f;31321210-7&#x7f;31321220-0&#x7f;31321300-5&#x7f;31321400-6&#x7f;31321500-7&#x7f;31321600-8&#x7f;31321700-9&#x7f;31330000-8&#x7f;31340000-1&#x7f;31341000-8&#x7f;31342000-5&#x7f;31343000-2&#x7f;31344000-9&#x7f;31350000-4&#x7f;31351000-1&#x7f;31400000-0&#x7f;31410000-3&#x7f;31411000-0&#x7f;31420000-6&#x7f;31421000-3&#x7f;31422000-0&#x7f;31430000-9&#x7f;31431000-6&#x7f;31432000-3&#x7f;31433000-0&#x7f;31434000-7&#x7f;31440000-2&#x7f;31500000-1&#x7f;31510000-4&#x7f;31511000-1&#x7f;31512000-8&#x7f;31512100-9&#x7f;31512200-0&#x7f;31512300-1&#x7f;31514000-2&#x7f;31515000-9&#x7f;31516000-6&#x7f;31517000-3&#x7f;31518000-0&#x7f;31518100-1&#x7f;31518200-2&#x7f;31518210-5&#x7f;31518220-8&#x7f;31518300-3&#x7f;31518500-5&#x7f;31518600-6&#x7f;31519000-7&#x7f;31519100-8&#x7f;31519200-9&#x7f;31520000-7&#x7f;31521000-4&#x7f;31521100-5&#x7f;31521200-6&#x7f;31521300-7&#x7f;31521310-0&#x7f;31521320-3&#x7f;31521330-6&#x7f;31522000-1&#x7f;31523000-8&#x7f;31523100-9&#x7f;31523200-0&#x7f;31523300-1&#x7f;31524000-5&#x7f;31524100-6&#x7f;31524110-9&#x7f;31524120-2&#x7f;31524200-7&#x7f;31524210-0&#x7f;31527000-6&#x7f;31527200-8&#x7f;31527210-1&#x7f;31527260-6&#x7f;31527270-9&#x7f;31527300-9&#x7f;31527400-0&#x7f;31530000-0&#x7f;31531000-7&#x7f;31531100-8&#x7f;31532000-4&#x7f;31532100-5&#x7f;31532110-8&#x7f;31532120-1&#x7f;31532200-6&#x7f;31532210-9&#x7f;31532300-7&#x7f;31532310-0&#x7f;31532400-8&#x7f;31532500-9&#x7f;31532510-2&#x7f;31532600-0&#x7f;31532610-3&#x7f;31532700-1&#x7f;31532800-2&#x7f;31532900-3&#x7f;31532910-6&#x7f;31532920-9&#x7f;31600000-2&#x7f;31610000-5&#x7f;31611000-2&#x7f;31612000-9&#x7f;31612200-1&#x7f;31612300-2&#x7f;31612310-5&#x7f;31620000-8&#x7f;31625000-3&#x7f;31625100-4&#x7f;31625200-5&#x7f;31625300-6&#x7f;31630000-1&#x7f;31640000-4&#x7f;31642000-8&#x7f;31642100-9&#x7f;31642200-0&#x7f;31642300-1&#x7f;31642400-2&#x7f;31642500-3&#x7f;31643000-5&#x7f;31643100-6&#x7f;31644000-2&#x7f;31645000-9&#x7f;31650000-7&#x7f;31651000-4&#x7f;31660000-0&#x7f;31670000-3&#x7f;31671000-0&#x7f;31671100-1&#x7f;31671200-2&#x7f;31680000-6&#x7f;31681000-3&#x7f;31681100-4&#x7f;31681200-5&#x7f;31681300-6&#x7f;31681400-7&#x7f;31681410-0&#x7f;31681500-8&#x7f;31682000-0&#x7f;31682100-1&#x7f;31682110-4&#x7f;31682200-2&#x7f;31682210-5&#x7f;31682220-8&#x7f;31682230-1&#x7f;31682300-3&#x7f;31682310-6&#x7f;31682400-4&#x7f;31682410-7&#x7f;31682500-5&#x7f;31682510-8&#x7f;31682520-1&#x7f;31682530-4&#x7f;31682540-7&#x7f;31700000-3&#x7f;31710000-6&#x7f;31711000-3&#x7f;31711100-4&#x7f;31711110-7&#x7f;31711120-0&#x7f;31711130-3&#x7f;31711131-0&#x7f;31711140-6&#x7f;31711150-9&#x7f;31711151-6&#x7f;31711152-3&#x7f;31711154-0&#x7f;31711155-7&#x7f;31711200-5&#x7f;31711300-6&#x7f;31711310-9&#x7f;31711400-7&#x7f;31711410-0&#x7f;31711411-7&#x7f;31711420-3&#x7f;31711421-0&#x7f;31711422-7&#x7f;31711423-4&#x7f;31711424-1&#x7f;31711430-6&#x7f;31711440-9&#x7f;31711500-8&#x7f;31711510-1&#x7f;31711520-4&#x7f;31711530-7&#x7f;31712000-0&#x7f;31712100-1&#x7f;31712110-4&#x7f;31712111-1&#x7f;31712112-8&#x7f;31712113-5&#x7f;31712114-2&#x7f;31712115-9&#x7f;31712116-6&#x7f;31712117-3&#x7f;31712118-0&#x7f;31712119-7&#x7f;31712200-2&#x7f;31712300-3&#x7f;31712310-6&#x7f;31712320-9&#x7f;31712330-2&#x7f;31712331-9&#x7f;31712332-6&#x7f;31712333-3&#x7f;31712334-0&#x7f;31712335-7&#x7f;31712336-4&#x7f;31712340-5&#x7f;31712341-2&#x7f;31712342-9&#x7f;31712343-6&#x7f;31712344-3&#x7f;31712345-0&#x7f;31712346-7&#x7f;31712347-4&#x7f;31712348-1&#x7f;31712349-8&#x7f;31712350-8&#x7f;31712351-5&#x7f;31712352-2&#x7f;31712353-9&#x7f;31712354-6&#x7f;31712355-3&#x7f;31712356-0&#x7f;31712357-7&#x7f;31712358-4&#x7f;31712359-1&#x7f;31712360-1&#x7f;31720000-9&#x7f;31730000-2&#x7f;31731000-9&#x7f;31731100-0&#x7f;32000000-3&#x7f;32200000-5&#x7f;32210000-8&#x7f;32211000-5&#x7f;32220000-1&#x7f;32221000-8&#x7f;32222000-5&#x7f;32223000-2&#x7f;32224000-9&#x7f;32230000-4&#x7f;32231000-1&#x7f;32232000-8&#x7f;32233000-5&#x7f;32234000-2&#x7f;32235000-9&#x7f;32236000-6&#x7f;32237000-3&#x7f;32240000-7&#x7f;32250000-0&#x7f;32251000-7&#x7f;32251100-8&#x7f;32252000-4&#x7f;32252100-5&#x7f;32252110-8&#x7f;32260000-3&#x7f;32270000-6&#x7f;32300000-6&#x7f;32310000-9&#x7f;32320000-2&#x7f;32321000-9&#x7f;32321100-0&#x7f;32321200-1&#x7f;32321300-2&#x7f;32322000-6&#x7f;32323000-3&#x7f;32323100-4&#x7f;32323200-5&#x7f;32323300-6&#x7f;32323400-7&#x7f;32323500-8&#x7f;32324000-0&#x7f;32324100-1&#x7f;32324200-2&#x7f;32324300-3&#x7f;32324310-6&#x7f;32324400-4&#x7f;32324500-5&#x7f;32324600-6&#x7f;32330000-5&#x7f;32331000-2&#x7f;32331100-3&#x7f;32331200-4&#x7f;32331300-5&#x7f;32331500-7&#x7f;32331600-8&#x7f;32332000-9&#x7f;32332100-0&#x7f;32332200-1&#x7f;32332300-2&#x7f;32333000-6&#x7f;32333100-7&#x7f;32333200-8&#x7f;32333300-9&#x7f;32333400-0&#x7f;32340000-8&#x7f;32341000-5&#x7f;32342000-2&#x7f;32342100-3&#x7f;32342200-4&#x7f;32342300-5&#x7f;32342400-6&#x7f;32342410-9&#x7f;32342411-6&#x7f;32342412-3&#x7f;32342420-2&#x7f;32342430-5&#x7f;32342440-8&#x7f;32342450-1&#x7f;32343000-9&#x7f;32343100-0&#x7f;32343200-1&#x7f;32344000-6&#x7f;32344100-7&#x7f;32344110-0&#x7f;32344200-8&#x7f;32344210-1&#x7f;32344220-4&#x7f;32344230-7&#x7f;32344240-0&#x7f;32344250-3&#x7f;32344260-6&#x7f;32344270-9&#x7f;32344280-2&#x7f;32350000-1&#x7f;32351000-8&#x7f;32351100-9&#x7f;32351200-0&#x7f;32351300-1&#x7f;32351310-4&#x7f;32352000-5&#x7f;32352100-6&#x7f;32352200-7&#x7f;32353000-2&#x7f;32353100-3&#x7f;32353200-4&#x7f;32354000-9&#x7f;32354100-0&#x7f;32354110-3&#x7f;32354120-6&#x7f;32354200-1&#x7f;32354300-2&#x7f;32354400-3&#x7f;32354500-4&#x7f;32354600-5&#x7f;32354700-6&#x7f;32354800-7&#x7f;32360000-4&#x7f;32400000-7&#x7f;32410000-0&#x7f;32411000-7&#x7f;32412000-4&#x7f;32412100-5&#x7f;32412110-8&#x7f;32412120-1&#x7f;32413000-1&#x7f;32413100-2&#x7f;32415000-5&#x7f;32416000-2&#x7f;32416100-3&#x7f;32417000-9&#x7f;32418000-6&#x7f;32420000-3&#x7f;32421000-0&#x7f;32422000-7&#x7f;32423000-4&#x7f;32424000-1&#x7f;32425000-8&#x7f;32426000-5&#x7f;32427000-2&#x7f;32428000-9&#x7f;32429000-6&#x7f;32430000-6&#x7f;32440000-9&#x7f;32441000-6&#x7f;32441100-7&#x7f;32441200-8&#x7f;32441300-9&#x7f;32442000-3&#x7f;32442100-4&#x7f;32442200-5&#x7f;32442300-6&#x7f;32442400-7&#x7f;32500000-8&#x7f;32510000-1&#x7f;32520000-4&#x7f;32521000-1&#x7f;32522000-8&#x7f;32523000-5&#x7f;32524000-2&#x7f;32530000-7&#x7f;32531000-4&#x7f;32532000-1&#x7f;32533000-8&#x7f;32534000-5&#x7f;32540000-0&#x7f;32541000-7&#x7f;32542000-4&#x7f;32543000-1&#x7f;32544000-8&#x7f;32545000-5&#x7f;32546000-2&#x7f;32546100-3&#x7f;32547000-9&#x7f;32550000-3&#x7f;32551000-0&#x7f;32551100-1&#x7f;32551200-2&#x7f;32551300-3&#x7f;32551400-4&#x7f;32551500-5&#x7f;32552000-7&#x7f;32552100-8&#x7f;32552110-1&#x7f;32552120-4&#x7f;32552130-7&#x7f;32552140-0&#x7f;32552150-3&#x7f;32552160-6&#x7f;32552200-9&#x7f;32552300-0&#x7f;32552310-3&#x7f;32552320-6&#x7f;32552330-9&#x7f;32552400-1&#x7f;32552410-4&#x7f;32552420-7&#x7f;32552430-0&#x7f;32552500-2&#x7f;32552510-5&#x7f;32552520-8&#x7f;32552600-3&#x7f;32553000-4&#x7f;32560000-6&#x7f;32561000-3&#x7f;32562000-0&#x7f;32562100-1&#x7f;32562200-2&#x7f;32562300-3&#x7f;32570000-9&#x7f;32571000-6&#x7f;32572000-3&#x7f;32572100-4&#x7f;32572200-5&#x7f;32572300-6&#x7f;32573000-0&#x7f;32580000-2&#x7f;32581000-9&#x7f;32581100-0&#x7f;32581110-3&#x7f;32581120-6&#x7f;32581130-9&#x7f;32581200-1&#x7f;32581210-4&#x7f;32582000-6&#x7f;32583000-3&#x7f;32584000-0&#x7f;33000000-0&#x7f;33100000-1&#x7f;33110000-4&#x7f;33111000-1&#x7f;33111100-2&#x7f;33111200-3&#x7f;33111300-4&#x7f;33111400-5&#x7f;33111500-6&#x7f;33111600-7&#x7f;33111610-0&#x7f;33111620-3&#x7f;33111640-9&#x7f;33111650-2&#x7f;33111660-5&#x7f;33111700-8&#x7f;33111710-1&#x7f;33111720-4&#x7f;33111721-1&#x7f;33111730-7&#x7f;33111740-0&#x7f;33111800-9&#x7f;33112000-8&#x7f;33112100-9&#x7f;33112200-0&#x7f;33112300-1&#x7f;33112310-4&#x7f;33112320-7&#x7f;33112330-0&#x7f;33112340-3&#x7f;33113000-5&#x7f;33113100-6&#x7f;33113110-9&#x7f;33114000-2&#x7f;33115000-9&#x7f;33115100-0&#x7f;33115200-1&#x7f;33120000-7&#x7f;33121000-4&#x7f;33121100-5&#x7f;33121200-6&#x7f;33121300-7&#x7f;33121400-8&#x7f;33121500-9&#x7f;33122000-1&#x7f;33123000-8&#x7f;33123100-9&#x7f;33123200-0&#x7f;33123210-3&#x7f;33123220-6&#x7f;33123230-9&#x7f;33124000-5&#x7f;33124100-6&#x7f;33124110-9&#x7f;33124120-2&#x7f;33124130-5&#x7f;33124131-2&#x7f;33124200-7&#x7f;33124210-0&#x7f;33125000-2&#x7f;33126000-9&#x7f;33127000-6&#x7f;33128000-3&#x7f;33130000-0&#x7f;33131000-7&#x7f;33131100-8&#x7f;33131110-1&#x7f;33131111-8&#x7f;33131112-5&#x7f;33131113-2&#x7f;33131114-9&#x7f;33131120-4&#x7f;33131121-1&#x7f;33131122-8&#x7f;33131123-5&#x7f;33131124-2&#x7f;33131130-7&#x7f;33131131-4&#x7f;33131132-1&#x7f;33131140-0&#x7f;33131141-7&#x7f;33131142-4&#x7f;33131150-3&#x7f;33131151-0&#x7f;33131152-7&#x7f;33131153-4&#x7f;33131160-6&#x7f;33131161-3&#x7f;33131162-0&#x7f;33131170-9&#x7f;33131171-6&#x7f;33131172-3&#x7f;33131173-0&#x7f;33131200-9&#x7f;33131300-0&#x7f;33131400-1&#x7f;33131500-2&#x7f;33131510-5&#x7f;33131600-3&#x7f;33132000-4&#x7f;33133000-1&#x7f;33134000-8&#x7f;33135000-5&#x7f;33136000-2&#x7f;33137000-9&#x7f;33138000-6&#x7f;33138100-7&#x7f;33140000-3&#x7f;33141000-0&#x7f;33141100-1&#x7f;33141110-4&#x7f;33141111-1&#x7f;33141112-8&#x7f;33141113-4&#x7f;33141114-2&#x7f;33141115-9&#x7f;33141116-6&#x7f;33141117-3&#x7f;33141118-0&#x7f;33141119-7&#x7f;33141120-7&#x7f;33141121-4&#x7f;33141122-1&#x7f;33141123-8&#x7f;33141124-5&#x7f;33141125-2&#x7f;33141126-9&#x7f;33141127-6&#x7f;33141128-3&#x7f;33141200-2&#x7f;33141210-5&#x7f;33141220-8&#x7f;33141230-1&#x7f;33141240-4&#x7f;33141300-3&#x7f;33141310-6&#x7f;33141320-9&#x7f;33141321-6&#x7f;33141322-3&#x7f;33141323-0&#x7f;33141324-7&#x7f;33141325-4&#x7f;33141326-1&#x7f;33141327-8&#x7f;33141328-5&#x7f;33141329-2&#x7f;33141400-4&#x7f;33141410-7&#x7f;33141411-4&#x7f;33141420-0&#x7f;33141500-5&#x7f;33141510-8&#x7f;33141520-1&#x7f;33141530-4&#x7f;33141540-7&#x7f;33141550-0&#x7f;33141560-3&#x7f;33141570-6&#x7f;33141580-9&#x7f;33141600-6&#x7f;33141610-9&#x7f;33141613-0&#x7f;33141614-7&#x7f;33141615-4&#x7f;33141620-2&#x7f;33141621-9&#x7f;33141622-6&#x7f;33141623-3&#x7f;33141624-0&#x7f;33141625-7&#x7f;33141626-4&#x7f;33141630-5&#x7f;33141640-8&#x7f;33141641-5&#x7f;33141642-2&#x7f;33141700-7&#x7f;33141710-0&#x7f;33141720-3&#x7f;33141730-6&#x7f;33141740-9&#x7f;33141750-2&#x7f;33141760-5&#x7f;33141770-8&#x7f;33141800-8&#x7f;33141810-1&#x7f;33141820-4&#x7f;33141821-1&#x7f;33141822-8&#x7f;33141830-7&#x7f;33141840-0&#x7f;33141850-3&#x7f;33141900-9&#x7f;33150000-6&#x7f;33151000-3&#x7f;33151100-4&#x7f;33151200-5&#x7f;33151300-6&#x7f;33151400-7&#x7f;33152000-0&#x7f;33153000-7&#x7f;33154000-4&#x7f;33155000-1&#x7f;33156000-8&#x7f;33157000-5&#x7f;33157100-6&#x7f;33157110-9&#x7f;33157200-7&#x7f;33157300-8&#x7f;33157400-9&#x7f;33157500-0&#x7f;33157700-2&#x7f;33157800-3&#x7f;33157810-6&#x7f;33158000-2&#x7f;33158100-3&#x7f;33158200-4&#x7f;33158210-7&#x7f;33158300-5&#x7f;33158400-6&#x7f;33158500-7&#x7f;33159000-9&#x7f;33160000-9&#x7f;33161000-6&#x7f;33162000-3&#x7f;33162100-4&#x7f;33162200-5&#x7f;33163000-0&#x7f;33164000-7&#x7f;33164100-8&#x7f;33165000-4&#x7f;33166000-1&#x7f;33167000-8&#x7f;33168000-5&#x7f;33168100-6&#x7f;33169000-2&#x7f;33169100-3&#x7f;33169200-4&#x7f;33169300-5&#x7f;33169400-6&#x7f;33169500-7&#x7f;33170000-2&#x7f;33171000-9&#x7f;33171100-0&#x7f;33171110-3&#x7f;33171200-1&#x7f;33171210-4&#x7f;33171300-2&#x7f;33172000-6&#x7f;33172100-7&#x7f;33172200-8&#x7f;33180000-5&#x7f;33181000-2&#x7f;33181100-3&#x7f;33181200-4&#x7f;33181300-5&#x7f;33181400-6&#x7f;33181500-7&#x7f;33181510-0&#x7f;33181520-3&#x7f;33182000-9&#x7f;33182100-0&#x7f;33182200-1&#x7f;33182210-4&#x7f;33182220-7&#x7f;33182230-0&#x7f;33182240-3&#x7f;33182241-0&#x7f;33182300-2&#x7f;33182400-3&#x7f;33183000-6&#x7f;33183100-7&#x7f;33183200-8&#x7f;33183300-9&#x7f;33184000-3&#x7f;33184100-4&#x7f;33184200-5&#x7f;33184300-6&#x7f;33184400-7&#x7f;33184410-0&#x7f;33184420-3&#x7f;33184500-8&#x7f;33184600-9&#x7f;33185000-0&#x7f;33185100-1&#x7f;33185200-2&#x7f;33185300-3&#x7f;33185400-4&#x7f;33186000-7&#x7f;33186100-8&#x7f;33186200-9&#x7f;33190000-8&#x7f;33191000-5&#x7f;33191100-6&#x7f;33191110-9&#x7f;33192000-2&#x7f;33192100-3&#x7f;33192110-6&#x7f;33192120-9&#x7f;33192130-2&#x7f;33192140-5&#x7f;33192150-8&#x7f;33192160-1&#x7f;33192200-4&#x7f;33192210-7&#x7f;33192230-3&#x7f;33192300-5&#x7f;33192310-8&#x7f;33192320-1&#x7f;33192330-4&#x7f;33192340-7&#x7f;33192350-0&#x7f;33192400-6&#x7f;33192410-9&#x7f;33192500-7&#x7f;33192600-8&#x7f;33193000-9&#x7f;33193100-0&#x7f;33193110-3&#x7f;33193120-6&#x7f;33193121-3&#x7f;33193200-1&#x7f;33193210-4&#x7f;33193211-1&#x7f;33193212-8&#x7f;33193213-5&#x7f;33193214-2&#x7f;33193220-7&#x7f;33193221-4&#x7f;33193222-1&#x7f;33193223-8&#x7f;33193224-5&#x7f;33193225-2&#x7f;33194000-6&#x7f;33194100-7&#x7f;33194110-0&#x7f;33194120-3&#x7f;33194200-8&#x7f;33194210-1&#x7f;33194220-4&#x7f;33195000-3&#x7f;33195100-4&#x7f;33195110-7&#x7f;33195200-5&#x7f;33196000-0&#x7f;33196100-1&#x7f;33196200-2&#x7f;33197000-7&#x7f;33198000-4&#x7f;33198100-5&#x7f;33198200-6&#x7f;33199000-1&#x7f;33600000-6&#x7f;33610000-9&#x7f;33611000-6&#x7f;33612000-3&#x7f;33613000-0&#x7f;33614000-7&#x7f;33615000-4&#x7f;33615100-5&#x7f;33616000-1&#x7f;33616100-2&#x7f;33617000-8&#x7f;33620000-2&#x7f;33621000-9&#x7f;33621100-0&#x7f;33621200-1&#x7f;33621300-2&#x7f;33621400-3&#x7f;33622000-6&#x7f;33622100-7&#x7f;33622200-8&#x7f;33622300-9&#x7f;33622400-0&#x7f;33622500-1&#x7f;33622600-2&#x7f;33622700-3&#x7f;33622800-4&#x7f;33630000-5&#x7f;33631000-2&#x7f;33631100-3&#x7f;33631110-6&#x7f;33631200-4&#x7f;33631300-5&#x7f;33631400-6&#x7f;33631500-7&#x7f;33631600-8&#x7f;33631700-9&#x7f;33632000-9&#x7f;33632100-0&#x7f;33632200-1&#x7f;33632300-2&#x7f;33640000-8&#x7f;33641000-5&#x7f;33641100-6&#x7f;33641200-7&#x7f;33641300-8&#x7f;33641400-9&#x7f;33641410-2&#x7f;33641420-5&#x7f;33642000-2&#x7f;33642100-3&#x7f;33642200-4&#x7f;33642300-5&#x7f;33650000-1&#x7f;33651000-8&#x7f;33651100-9&#x7f;33651200-0&#x7f;33651300-1&#x7f;33651400-2&#x7f;33651500-3&#x7f;33651510-6&#x7f;33651520-9&#x7f;33651600-4&#x7f;33651610-7&#x7f;33651620-0&#x7f;33651630-3&#x7f;33651640-6&#x7f;33651650-9&#x7f;33651660-2&#x7f;33651670-5&#x7f;33651680-8&#x7f;33651690-1&#x7f;33652000-5&#x7f;33652100-6&#x7f;33652200-7&#x7f;33652300-8&#x7f;33660000-4&#x7f;33661000-1&#x7f;33661100-2&#x7f;33661200-3&#x7f;33661300-4&#x7f;33661400-5&#x7f;33661500-6&#x7f;33661600-7&#x7f;33661700-8&#x7f;33662000-8&#x7f;33662100-9&#x7f;33670000-7&#x7f;33673000-8&#x7f;33674000-5&#x7f;33675000-2&#x7f;33680000-0&#x7f;33681000-7&#x7f;33682000-4&#x7f;33683000-1&#x7f;33690000-3&#x7f;33691000-0&#x7f;33691100-1&#x7f;33691200-2&#x7f;33691300-3&#x7f;33692000-7&#x7f;33692100-8&#x7f;33692200-9&#x7f;33692210-2&#x7f;33692300-0&#x7f;33692400-1&#x7f;33692500-2&#x7f;33692510-5&#x7f;33692600-3&#x7f;33692700-4&#x7f;33692800-5&#x7f;33693000-4&#x7f;33693100-5&#x7f;33693200-6&#x7f;33693300-7&#x7f;33694000-1&#x7f;33695000-8&#x7f;33696000-5&#x7f;33696100-6&#x7f;33696200-7&#x7f;33696300-8&#x7f;33696400-9&#x7f;33696500-0&#x7f;33696600-1&#x7f;33696700-2&#x7f;33696800-3&#x7f;33697000-2&#x7f;33697100-3&#x7f;33697110-6&#x7f;33698000-9&#x7f;33698100-0&#x7f;33698200-1&#x7f;33698300-2&#x7f;33700000-7&#x7f;33710000-0&#x7f;33711000-7&#x7f;33711100-8&#x7f;33711110-1&#x7f;33711120-4&#x7f;33711130-7&#x7f;33711140-0&#x7f;33711150-3&#x7f;33711200-9&#x7f;33711300-0&#x7f;33711400-1&#x7f;33711410-4&#x7f;33711420-7&#x7f;33711430-0&#x7f;33711440-3&#x7f;33711450-6&#x7f;33711500-2&#x7f;33711510-5&#x7f;33711520-8&#x7f;33711530-1&#x7f;33711540-4&#x7f;33711600-3&#x7f;33711610-6&#x7f;33711620-9&#x7f;33711630-2&#x7f;33711640-5&#x7f;33711700-4&#x7f;33711710-7&#x7f;33711720-0&#x7f;33711730-3&#x7f;33711740-6&#x7f;33711750-9&#x7f;33711760-2&#x7f;33711770-5&#x7f;33711780-8&#x7f;33711790-1&#x7f;33711800-5&#x7f;33711810-8&#x7f;33711900-6&#x7f;33712000-4&#x7f;33713000-1&#x7f;33720000-3&#x7f;33721000-0&#x7f;33721100-1&#x7f;33721200-2&#x7f;33722000-7&#x7f;33722100-8&#x7f;33722110-1&#x7f;33722200-9&#x7f;33722210-2&#x7f;33722300-0&#x7f;33730000-6&#x7f;33731000-3&#x7f;33731100-4&#x7f;33731110-7&#x7f;33731120-0&#x7f;33732000-0&#x7f;33733000-7&#x7f;33734000-4&#x7f;33734100-5&#x7f;33734200-6&#x7f;33735000-1&#x7f;33735100-2&#x7f;33735200-3&#x7f;33740000-9&#x7f;33741000-6&#x7f;33741100-7&#x7f;33741200-8&#x7f;33741300-9&#x7f;33742000-3&#x7f;33742100-4&#x7f;33742200-5&#x7f;33750000-2&#x7f;33751000-9&#x7f;33752000-6&#x7f;33760000-5&#x7f;33761000-2&#x7f;33762000-9&#x7f;33763000-6&#x7f;33764000-3&#x7f;33770000-8&#x7f;33771000-5&#x7f;33771100-6&#x7f;33771200-7&#x7f;33772000-2&#x7f;33790000-4&#x7f;33791000-1&#x7f;33792000-8&#x7f;33793000-5&#x7f;33900000-9&#x7f;33910000-2&#x7f;33911000-9&#x7f;33912000-6&#x7f;33912100-7&#x7f;33913000-3&#x7f;33914000-0&#x7f;33914100-1&#x7f;33914200-2&#x7f;33914300-3&#x7f;33915000-7&#x7f;33916000-4&#x7f;33916100-5&#x7f;33917000-1&#x7f;33918000-8&#x7f;33919000-5&#x7f;33920000-5&#x7f;33921000-2&#x7f;33922000-9&#x7f;33923000-6&#x7f;33923100-7&#x7f;33923200-8&#x7f;33923300-9&#x7f;33924000-3&#x7f;33925000-0&#x7f;33926000-7&#x7f;33927000-4&#x7f;33928000-1&#x7f;33929000-8&#x7f;33930000-8&#x7f;33931000-5&#x7f;33932000-2&#x7f;33933000-9&#x7f;33933100-0&#x7f;33934000-6&#x7f;33935000-3&#x7f;33936000-0&#x7f;33937000-7&#x7f;33940000-1&#x7f;33941000-8&#x7f;33942000-5&#x7f;33943000-2&#x7f;33944000-9&#x7f;33945000-6&#x7f;33946000-3&#x7f;33947000-0&#x7f;33948000-7&#x7f;33949000-4&#x7f;33950000-4&#x7f;33951000-1&#x7f;33952000-8&#x7f;33953000-5&#x7f;33954000-2&#x7f;33960000-7&#x7f;33961000-4&#x7f;33962000-1&#x7f;33963000-8&#x7f;33964000-5&#x7f;33965000-2&#x7f;33966000-9&#x7f;33967000-6&#x7f;33968000-3&#x7f;33970000-0&#x7f;33971000-7&#x7f;33972000-4&#x7f;33973000-1&#x7f;33974000-8&#x7f;33975000-5&#x7f;34000000-7&#x7f;34100000-8&#x7f;34110000-1&#x7f;34111000-8&#x7f;34111100-9&#x7f;34111200-0&#x7f;34113000-2&#x7f;34113100-3&#x7f;34113200-4&#x7f;34113300-5&#x7f;34114000-9&#x7f;34114100-0&#x7f;34114110-3&#x7f;34114120-6&#x7f;34114121-3&#x7f;34114122-0&#x7f;34114200-1&#x7f;34114210-4&#x7f;34114300-2&#x7f;34114400-3&#x7f;34115000-6&#x7f;34115200-8&#x7f;34115300-9&#x7f;34120000-4&#x7f;34121000-1&#x7f;34121100-2&#x7f;34121200-3&#x7f;34121300-4&#x7f;34121400-5&#x7f;34121500-6&#x7f;34130000-7&#x7f;34131000-4&#x7f;34132000-1&#x7f;34133000-8&#x7f;34133100-9&#x7f;34133110-2&#x7f;34134000-5&#x7f;34134100-6&#x7f;34134200-7&#x7f;34136000-9&#x7f;34136100-0&#x7f;34136200-1&#x7f;34137000-6&#x7f;34138000-3&#x7f;34139000-0&#x7f;34139100-1&#x7f;34139200-2&#x7f;34139300-3&#x7f;34140000-0&#x7f;34142000-4&#x7f;34142100-5&#x7f;34142200-6&#x7f;34142300-7&#x7f;34143000-1&#x7f;34144000-8&#x7f;34144100-9&#x7f;34144200-0&#x7f;34144210-3&#x7f;34144211-0&#x7f;34144212-7&#x7f;34144213-4&#x7f;34144220-6&#x7f;34144300-1&#x7f;34144400-2&#x7f;34144410-5&#x7f;34144420-8&#x7f;34144430-1&#x7f;34144431-8&#x7f;34144440-4&#x7f;34144450-7&#x7f;34144500-3&#x7f;34144510-6&#x7f;34144511-3&#x7f;34144512-0&#x7f;34144520-9&#x7f;34144700-5&#x7f;34144710-8&#x7f;34144730-4&#x7f;34144740-7&#x7f;34144750-0&#x7f;34144751-7&#x7f;34144760-3&#x7f;34144800-6&#x7f;34144900-7&#x7f;34144910-0&#x7f;34150000-3&#x7f;34151000-0&#x7f;34152000-7&#x7f;34200000-9&#x7f;34210000-2&#x7f;34211000-9&#x7f;34211100-9&#x7f;34211200-9&#x7f;34211300-9&#x7f;34220000-5&#x7f;34221000-2&#x7f;34221100-3&#x7f;34221200-4&#x7f;34221300-5&#x7f;34223000-6&#x7f;34223100-7&#x7f;34223200-8&#x7f;34223300-9&#x7f;34223310-2&#x7f;34223320-5&#x7f;34223330-8&#x7f;34223340-1&#x7f;34223350-4&#x7f;34223360-7&#x7f;34223370-0&#x7f;34223400-0&#x7f;34224000-3&#x7f;34224100-4&#x7f;34224200-5&#x7f;34300000-0&#x7f;34310000-3&#x7f;34311000-0&#x7f;34311100-1&#x7f;34311110-4&#x7f;34311120-7&#x7f;34312000-7&#x7f;34312100-8&#x7f;34312200-9&#x7f;34312300-0&#x7f;34312400-1&#x7f;34312500-2&#x7f;34312600-3&#x7f;34312700-4&#x7f;34320000-6&#x7f;34321000-3&#x7f;34321100-4&#x7f;34321200-5&#x7f;34322000-0&#x7f;34322100-1&#x7f;34322200-2&#x7f;34322300-3&#x7f;34322400-4&#x7f;34322500-5&#x7f;34324000-4&#x7f;34324100-5&#x7f;34325000-1&#x7f;34325100-2&#x7f;34325200-3&#x7f;34326000-8&#x7f;34326100-9&#x7f;34326200-0&#x7f;34327000-5&#x7f;34327100-6&#x7f;34327200-7&#x7f;34328000-2&#x7f;34328100-3&#x7f;34328200-4&#x7f;34328300-5&#x7f;34330000-9&#x7f;34350000-5&#x7f;34351000-2&#x7f;34351100-3&#x7f;34352000-9&#x7f;34352100-0&#x7f;34352200-1&#x7f;34352300-2&#x7f;34360000-8&#x7f;34370000-1&#x7f;34390000-7&#x7f;34400000-1&#x7f;34410000-4&#x7f;34411000-1&#x7f;34411100-2&#x7f;34411110-5&#x7f;34411200-3&#x7f;34420000-7&#x7f;34421000-7&#x7f;34422000-7&#x7f;34430000-0&#x7f;34431000-7&#x7f;34432000-4&#x7f;34432100-5&#x7f;34500000-2&#x7f;34510000-5&#x7f;34511100-3&#x7f;34512000-9&#x7f;34512100-0&#x7f;34512200-1&#x7f;34512300-2&#x7f;34512400-3&#x7f;34512500-4&#x7f;34512600-5&#x7f;34512700-6&#x7f;34512800-7&#x7f;34512900-8&#x7f;34512950-3&#x7f;34513000-6&#x7f;34513100-7&#x7f;34513150-2&#x7f;34513200-8&#x7f;34513250-3&#x7f;34513300-9&#x7f;34513350-4&#x7f;34513400-0&#x7f;34513450-5&#x7f;34513500-1&#x7f;34513550-6&#x7f;34513600-2&#x7f;34513650-7&#x7f;34513700-3&#x7f;34513750-8&#x7f;34514000-3&#x7f;34514100-4&#x7f;34514200-5&#x7f;34514300-6&#x7f;34514400-7&#x7f;34514500-8&#x7f;34514600-9&#x7f;34514700-0&#x7f;34514800-1&#x7f;34514900-2&#x7f;34515000-0&#x7f;34515100-1&#x7f;34515200-2&#x7f;34516000-7&#x7f;34520000-8&#x7f;34521000-5&#x7f;34521100-6&#x7f;34521200-7&#x7f;34521300-8&#x7f;34521400-9&#x7f;34522000-2&#x7f;34522100-3&#x7f;34522150-8&#x7f;34522200-4&#x7f;34522250-9&#x7f;34522300-5&#x7f;34522350-0&#x7f;34522400-6&#x7f;34522450-1&#x7f;34522500-7&#x7f;34522550-2&#x7f;34522600-8&#x7f;34522700-9&#x7f;34600000-3&#x7f;34610000-6&#x7f;34611000-3&#x7f;34612000-0&#x7f;34612100-1&#x7f;34612200-2&#x7f;34620000-9&#x7f;34621000-6&#x7f;34621100-7&#x7f;34621200-8&#x7f;34622000-3&#x7f;34622100-4&#x7f;34622200-5&#x7f;34622300-6&#x7f;34622400-7&#x7f;34622500-8&#x7f;34630000-2&#x7f;34631000-9&#x7f;34631100-0&#x7f;34631200-1&#x7f;34631300-2&#x7f;34631400-3&#x7f;34632000-6&#x7f;34632100-7&#x7f;34632200-8&#x7f;34632300-9&#x7f;34640000-5&#x7f;34700000-4&#x7f;34710000-7&#x7f;34711000-4&#x7f;34711100-5&#x7f;34711110-8&#x7f;34711200-6&#x7f;34711300-7&#x7f;34711400-8&#x7f;34711500-9&#x7f;34712000-1&#x7f;34712100-2&#x7f;34712200-3&#x7f;34712300-4&#x7f;34720000-0&#x7f;34721000-7&#x7f;34721100-8&#x7f;34722000-4&#x7f;34722100-5&#x7f;34722200-6&#x7f;34730000-3&#x7f;34731000-0&#x7f;34731100-1&#x7f;34731200-2&#x7f;34731300-3&#x7f;34731400-4&#x7f;34731500-5&#x7f;34731600-6&#x7f;34731700-7&#x7f;34731800-8&#x7f;34740000-6&#x7f;34741000-3&#x7f;34741100-4&#x7f;34741200-5&#x7f;34741300-6&#x7f;34741400-7&#x7f;34741500-8&#x7f;34741600-9&#x7f;34900000-6&#x7f;34910000-9&#x7f;34911000-6&#x7f;34911100-7&#x7f;34912000-3&#x7f;34912100-4&#x7f;34913000-0&#x7f;34913100-1&#x7f;34913200-2&#x7f;34913300-3&#x7f;34913400-4&#x7f;34913500-5&#x7f;34913510-8&#x7f;34913600-6&#x7f;34913700-7&#x7f;34913800-8&#x7f;34920000-2&#x7f;34921000-9&#x7f;34921100-0&#x7f;34921200-1&#x7f;34922000-6&#x7f;34922100-7&#x7f;34922110-0&#x7f;34923000-3&#x7f;34924000-0&#x7f;34926000-4&#x7f;34927000-1&#x7f;34927100-2&#x7f;34928000-8&#x7f;34928100-9&#x7f;34928110-2&#x7f;34928120-5&#x7f;34928200-0&#x7f;34928210-3&#x7f;34928220-6&#x7f;34928230-9&#x7f;34928300-1&#x7f;34928310-4&#x7f;34928320-7&#x7f;34928330-0&#x7f;34928340-3&#x7f;34928400-2&#x7f;34928410-5&#x7f;34928420-8&#x7f;34928430-1&#x7f;34928440-4&#x7f;34928450-7&#x7f;34928460-0&#x7f;34928470-3&#x7f;34928471-0&#x7f;34928472-7&#x7f;34928480-6&#x7f;34928500-3&#x7f;34928510-6&#x7f;34928520-9&#x7f;34928530-2&#x7f;34929000-5&#x7f;34930000-5&#x7f;34931000-2&#x7f;34931100-3&#x7f;34931200-4&#x7f;34931300-5&#x7f;34931400-6&#x7f;34931500-7&#x7f;34932000-9&#x7f;34933000-6&#x7f;34934000-3&#x7f;34940000-8&#x7f;34941000-5&#x7f;34941100-6&#x7f;34941200-7&#x7f;34941300-8&#x7f;34941500-0&#x7f;34941600-1&#x7f;34941800-3&#x7f;34942000-2&#x7f;34942100-3&#x7f;34942200-4&#x7f;34943000-9&#x7f;34944000-6&#x7f;34945000-3&#x7f;34946000-0&#x7f;34946100-1&#x7f;34946110-4&#x7f;34946120-7&#x7f;34946121-4&#x7f;34946122-1&#x7f;34946200-2&#x7f;34946210-5&#x7f;34946220-8&#x7f;34946221-5&#x7f;34946222-2&#x7f;34946223-9&#x7f;34946224-6&#x7f;34946230-1&#x7f;34946231-8&#x7f;34946232-5&#x7f;34946240-4&#x7f;34947000-7&#x7f;34947100-8&#x7f;34947200-9&#x7f;34950000-1&#x7f;34951000-8&#x7f;34951200-0&#x7f;34951300-1&#x7f;34952000-5&#x7f;34953000-2&#x7f;34953100-3&#x7f;34953300-5&#x7f;34954000-9&#x7f;34955000-6&#x7f;34955100-7&#x7f;34960000-4&#x7f;34961000-1&#x7f;34961100-2&#x7f;34962000-8&#x7f;34962100-9&#x7f;34962200-0&#x7f;34962210-3&#x7f;34962220-6&#x7f;34962230-9&#x7f;34963000-5&#x7f;34964000-2&#x7f;34965000-9&#x7f;34966000-6&#x7f;34966100-7&#x7f;34966200-8&#x7f;34967000-3&#x7f;34968000-0&#x7f;34968100-1&#x7f;34968200-2&#x7f;34969000-7&#x7f;34969100-8&#x7f;34969200-9&#x7f;34970000-7&#x7f;34971000-4&#x7f;34972000-1&#x7f;34980000-0&#x7f;34990000-3&#x7f;34991000-0&#x7f;34992000-7&#x7f;34992100-8&#x7f;34992200-9&#x7f;34992300-0&#x7f;34993000-4&#x7f;34993100-5&#x7f;34994000-1&#x7f;34994100-2&#x7f;34995000-8&#x7f;34996000-5&#x7f;34996100-6&#x7f;34996200-7&#x7f;34996300-8&#x7f;34997000-2&#x7f;34997100-3&#x7f;34997200-4&#x7f;34997210-7&#x7f;34998000-9&#x7f;34999000-6&#x7f;34999100-7&#x7f;34999200-8&#x7f;34999300-9&#x7f;34999400-0&#x7f;34999410-3&#x7f;34999420-6&#x7f;35000000-4&#x7f;35100000-5&#x7f;35110000-8&#x7f;35111000-5&#x7f;35111100-6&#x7f;35111200-7&#x7f;35111300-8&#x7f;35111310-1&#x7f;35111320-4&#x7f;35111400-9&#x7f;35111500-0&#x7f;35111510-3&#x7f;35111520-6&#x7f;35112000-2&#x7f;35112100-3&#x7f;35112200-4&#x7f;35112300-5&#x7f;35113000-9&#x7f;35113100-0&#x7f;35113110-0&#x7f;35113200-1&#x7f;35113210-4&#x7f;35113300-2&#x7f;35113400-3&#x7f;35113410-6&#x7f;35113420-9&#x7f;35113430-2&#x7f;35113440-5&#x7f;35113450-8&#x7f;35113460-1&#x7f;35113470-4&#x7f;35113480-7&#x7f;35113490-0&#x7f;35120000-1&#x7f;35121000-8&#x7f;35121100-9&#x7f;35121200-0&#x7f;35121300-1&#x7f;35121400-2&#x7f;35121500-3&#x7f;35121600-4&#x7f;35121700-5&#x7f;35121800-6&#x7f;35121900-7&#x7f;35123000-2&#x7f;35123100-3&#x7f;35123200-4&#x7f;35123300-5&#x7f;35123400-6&#x7f;35123500-7&#x7f;35124000-9&#x7f;35125000-6&#x7f;35125100-7&#x7f;35125110-0&#x7f;35125200-8&#x7f;35125300-2&#x7f;35126000-3&#x7f;35200000-6&#x7f;35210000-9&#x7f;35220000-2&#x7f;35221000-9&#x7f;35230000-5&#x7f;35240000-8&#x7f;35250000-1&#x7f;35260000-4&#x7f;35261000-1&#x7f;35261100-2&#x7f;35262000-8&#x7f;35300000-7&#x7f;35310000-0&#x7f;35311000-7&#x7f;35311100-8&#x7f;35311200-9&#x7f;35311300-0&#x7f;35311400-1&#x7f;35312000-4&#x7f;35320000-3&#x7f;35321000-0&#x7f;35321100-1&#x7f;35321200-2&#x7f;35321300-3&#x7f;35322000-7&#x7f;35322100-8&#x7f;35322200-9&#x7f;35322300-0&#x7f;35322400-1&#x7f;35322500-2&#x7f;35330000-6&#x7f;35331000-3&#x7f;35331100-4&#x7f;35331200-5&#x7f;35331300-3&#x7f;35331400-7&#x7f;35331500-8&#x7f;35332000-0&#x7f;35332100-1&#x7f;35332200-2&#x7f;35333000-7&#x7f;35333100-8&#x7f;35333200-9&#x7f;35340000-9&#x7f;35341000-6&#x7f;35341100-7&#x7f;35342000-3&#x7f;35343000-0&#x7f;35400000-8&#x7f;35410000-1&#x7f;35411000-8&#x7f;35411100-9&#x7f;35411200-0&#x7f;35412000-5&#x7f;35412100-6&#x7f;35412200-7&#x7f;35412300-8&#x7f;35412400-9&#x7f;35412500-0&#x7f;35420000-4&#x7f;35421000-1&#x7f;35421100-2&#x7f;35422000-8&#x7f;35500000-9&#x7f;35510000-2&#x7f;35511000-9&#x7f;35511100-0&#x7f;35511200-1&#x7f;35511300-2&#x7f;35511400-3&#x7f;35512000-6&#x7f;35512100-7&#x7f;35512200-8&#x7f;35512300-9&#x7f;35512400-0&#x7f;35513000-3&#x7f;35513100-4&#x7f;35513200-5&#x7f;35513300-6&#x7f;35513400-7&#x7f;35520000-5&#x7f;35521000-2&#x7f;35521100-3&#x7f;35522000-9&#x7f;35600000-0&#x7f;35610000-3&#x7f;35611100-1&#x7f;35611200-2&#x7f;35611300-3&#x7f;35611400-4&#x7f;35611500-5&#x7f;35611600-6&#x7f;35611700-7&#x7f;35611800-8&#x7f;35612100-8&#x7f;35612200-9&#x7f;35612300-0&#x7f;35612400-1&#x7f;35612500-2&#x7f;35613000-4&#x7f;35613100-5&#x7f;35620000-6&#x7f;35621000-3&#x7f;35621100-4&#x7f;35621200-5&#x7f;35621300-6&#x7f;35621400-7&#x7f;35622000-0&#x7f;35622100-1&#x7f;35622200-2&#x7f;35622300-3&#x7f;35622400-4&#x7f;35622500-5&#x7f;35622600-6&#x7f;35622700-7&#x7f;35623000-7&#x7f;35623100-8&#x7f;35630000-9&#x7f;35631000-6&#x7f;35631100-7&#x7f;35631200-8&#x7f;35631300-9&#x7f;35640000-2&#x7f;35641000-9&#x7f;35641100-0&#x7f;35642000-7&#x7f;35700000-1&#x7f;35710000-4&#x7f;35711000-1&#x7f;35712000-8&#x7f;35720000-7&#x7f;35721000-4&#x7f;35722000-1&#x7f;35723000-8&#x7f;35730000-0&#x7f;35740000-3&#x7f;35800000-2&#x7f;35810000-5&#x7f;35811100-3&#x7f;35811200-4&#x7f;35811300-5&#x7f;35812000-9&#x7f;35812100-0&#x7f;35812200-1&#x7f;35812300-2&#x7f;35813000-6&#x7f;35813100-7&#x7f;35814000-3&#x7f;35815000-0&#x7f;35815100-1&#x7f;35820000-8&#x7f;35821000-5&#x7f;35821100-6&#x7f;37000000-8&#x7f;37300000-1&#x7f;37310000-4&#x7f;37311000-1&#x7f;37311100-2&#x7f;37311200-3&#x7f;37311300-4&#x7f;37311400-5&#x7f;37312000-8&#x7f;37312100-9&#x7f;37312200-0&#x7f;37312300-1&#x7f;37312400-2&#x7f;37312500-3&#x7f;37312600-4&#x7f;37312700-5&#x7f;37312800-6&#x7f;37312900-7&#x7f;37312910-0&#x7f;37312920-3&#x7f;37312930-6&#x7f;37312940-9&#x7f;37313000-5&#x7f;37313100-6&#x7f;37313200-7&#x7f;37313300-8&#x7f;37313400-9&#x7f;37313500-0&#x7f;37313600-1&#x7f;37313700-2&#x7f;37313800-3&#x7f;37313900-4&#x7f;37314000-2&#x7f;37314100-3&#x7f;37314200-4&#x7f;37314300-5&#x7f;37314310-8&#x7f;37314320-1&#x7f;37314400-6&#x7f;37314500-7&#x7f;37314600-8&#x7f;37314700-9&#x7f;37314800-0&#x7f;37314900-1&#x7f;37315000-9&#x7f;37315100-0&#x7f;37316000-6&#x7f;37316100-7&#x7f;37316200-8&#x7f;37316300-9&#x7f;37316400-0&#x7f;37316500-1&#x7f;37316600-2&#x7f;37316700-3&#x7f;37320000-7&#x7f;37321000-4&#x7f;37321100-5&#x7f;37321200-6&#x7f;37321300-7&#x7f;37321400-8&#x7f;37321500-9&#x7f;37321600-0&#x7f;37321700-1&#x7f;37322000-1&#x7f;37322100-2&#x7f;37322200-3&#x7f;37322300-4&#x7f;37322400-5&#x7f;37322500-6&#x7f;37322600-7&#x7f;37322700-8&#x7f;37400000-2&#x7f;37410000-5&#x7f;37411000-2&#x7f;37411100-3&#x7f;37411110-6&#x7f;37411120-9&#x7f;37411130-2&#x7f;37411140-5&#x7f;37411150-8&#x7f;37411160-1&#x7f;37411200-4&#x7f;37411210-7&#x7f;37411220-0&#x7f;37411230-3&#x7f;37411300-5&#x7f;37412000-9&#x7f;37412100-0&#x7f;37412200-1&#x7f;37412210-4&#x7f;37412220-7&#x7f;37412230-0&#x7f;37412240-3&#x7f;37412241-0&#x7f;37412242-7&#x7f;37412243-4&#x7f;37412250-6&#x7f;37412260-9&#x7f;37412270-2&#x7f;37412300-2&#x7f;37412310-5&#x7f;37412320-8&#x7f;37412330-1&#x7f;37412340-4&#x7f;37412350-7&#x7f;37413000-6&#x7f;37413100-7&#x7f;37413110-0&#x7f;37413120-3&#x7f;37413130-6&#x7f;37413140-9&#x7f;37413150-2&#x7f;37413160-5&#x7f;37413200-8&#x7f;37413210-1&#x7f;37413220-4&#x7f;37413230-7&#x7f;37413240-0&#x7f;37414000-3&#x7f;37414100-4&#x7f;37414200-5&#x7f;37414300-6&#x7f;37414600-9&#x7f;37414700-0&#x7f;37414800-1&#x7f;37415000-0&#x7f;37416000-7&#x7f;37420000-8&#x7f;37421000-5&#x7f;37422000-2&#x7f;37422100-3&#x7f;37422200-4&#x7f;37423000-9&#x7f;37423100-0&#x7f;37423200-1&#x7f;37423300-2&#x7f;37424000-6&#x7f;37425000-3&#x7f;37426000-0&#x7f;37430000-1&#x7f;37431000-8&#x7f;37432000-5&#x7f;37433000-2&#x7f;37440000-4&#x7f;37441000-1&#x7f;37441100-2&#x7f;37441200-3&#x7f;37441300-4&#x7f;37441400-5&#x7f;37441500-6&#x7f;37441600-7&#x7f;37441700-8&#x7f;37441800-9&#x7f;37441900-0&#x7f;37442000-8&#x7f;37442100-8&#x7f;37442200-8&#x7f;37442300-8&#x7f;37442310-4&#x7f;37442320-7&#x7f;37442400-8&#x7f;37442500-8&#x7f;37442600-8&#x7f;37442700-8&#x7f;37442800-8&#x7f;37442810-9&#x7f;37442820-2&#x7f;37442900-8&#x7f;37450000-7&#x7f;37451000-4&#x7f;37451100-5&#x7f;37451110-8&#x7f;37451120-1&#x7f;37451130-4&#x7f;37451140-7&#x7f;37451150-0&#x7f;37451160-3&#x7f;37451200-6&#x7f;37451210-9&#x7f;37451220-2&#x7f;37451300-7&#x7f;37451310-0&#x7f;37451320-3&#x7f;37451330-6&#x7f;37451340-9&#x7f;37451400-8&#x7f;37451500-9&#x7f;37451600-0&#x7f;37451700-1&#x7f;37451710-4&#x7f;37451720-7&#x7f;37451730-0&#x7f;37451800-2&#x7f;37451810-5&#x7f;37451820-8&#x7f;37451900-3&#x7f;37451920-9&#x7f;37452000-1&#x7f;37452100-2&#x7f;37452110-5&#x7f;37452120-8&#x7f;37452200-3&#x7f;37452210-6&#x7f;37452300-4&#x7f;37452400-5&#x7f;37452410-8&#x7f;37452420-1&#x7f;37452430-4&#x7f;37452500-6&#x7f;37452600-7&#x7f;37452610-0&#x7f;37452620-3&#x7f;37452700-8&#x7f;37452710-1&#x7f;37452720-4&#x7f;37452730-7&#x7f;37452740-0&#x7f;37452800-9&#x7f;37452810-2&#x7f;37452820-5&#x7f;37452900-0&#x7f;37452910-3&#x7f;37452920-6&#x7f;37453000-8&#x7f;37453100-9&#x7f;37453200-0&#x7f;37453300-1&#x7f;37453400-2&#x7f;37453500-3&#x7f;37453600-4&#x7f;37453700-5&#x7f;37460000-0&#x7f;37461000-7&#x7f;37461100-8&#x7f;37461200-9&#x7f;37461210-2&#x7f;37461220-5&#x7f;37461300-0&#x7f;37461400-1&#x7f;37461500-2&#x7f;37461510-5&#x7f;37461520-8&#x7f;37462000-4&#x7f;37462100-5&#x7f;37462110-8&#x7f;37462120-1&#x7f;37462130-4&#x7f;37462140-7&#x7f;37462150-0&#x7f;37462160-3&#x7f;37462170-6&#x7f;37462180-9&#x7f;37462200-6&#x7f;37462210-9&#x7f;37462300-7&#x7f;37462400-8&#x7f;37470000-3&#x7f;37471000-0&#x7f;37471100-1&#x7f;37471200-2&#x7f;37471300-3&#x7f;37471400-4&#x7f;37471500-5&#x7f;37471600-6&#x7f;37471700-7&#x7f;37471800-8&#x7f;37471900-9&#x7f;37472000-7&#x7f;37480000-6&#x7f;37481000-3&#x7f;37482000-0&#x7f;37500000-3&#x7f;37510000-6&#x7f;37511000-3&#x7f;37512000-0&#x7f;37513000-7&#x7f;37513100-8&#x7f;37520000-9&#x7f;37521000-6&#x7f;37522000-3&#x7f;37523000-0&#x7f;37524000-7&#x7f;37524100-8&#x7f;37524200-9&#x7f;37524300-0&#x7f;37524400-1&#x7f;37524500-2&#x7f;37524600-3&#x7f;37524700-4&#x7f;37524800-5&#x7f;37524810-8&#x7f;37524900-6&#x7f;37525000-4&#x7f;37526000-1&#x7f;37527000-8&#x7f;37527100-9&#x7f;37527200-0&#x7f;37528000-5&#x7f;37529000-2&#x7f;37529100-3&#x7f;37529200-4&#x7f;37530000-2&#x7f;37531000-9&#x7f;37532000-6&#x7f;37533000-3&#x7f;37533100-4&#x7f;37533200-5&#x7f;37533300-6&#x7f;37533400-7&#x7f;37533500-8&#x7f;37534000-0&#x7f;37535000-7&#x7f;37535100-8&#x7f;37535200-9&#x7f;37535210-2&#x7f;37535220-5&#x7f;37535230-8&#x7f;37535240-1&#x7f;37535250-4&#x7f;37535260-7&#x7f;37535270-0&#x7f;37535280-3&#x7f;37535290-6&#x7f;37535291-3&#x7f;37535292-0&#x7f;37540000-5&#x7f;37800000-6&#x7f;37810000-9&#x7f;37820000-2&#x7f;37821000-9&#x7f;37822000-6&#x7f;37822100-7&#x7f;37822200-8&#x7f;37822300-9&#x7f;37822400-0&#x7f;37823000-3&#x7f;37823100-4&#x7f;37823200-5&#x7f;37823300-6&#x7f;37823400-7&#x7f;37823500-8&#x7f;37823600-9&#x7f;37823700-0&#x7f;37823800-1&#x7f;37823900-2&#x7f;38000000-5&#x7f;38100000-6&#x7f;38110000-9&#x7f;38111000-6&#x7f;38111100-7&#x7f;38111110-0&#x7f;38112000-3&#x7f;38112100-4&#x7f;38113000-0&#x7f;38114000-7&#x7f;38115000-4&#x7f;38115100-5&#x7f;38120000-2&#x7f;38121000-9&#x7f;38122000-6&#x7f;38123000-3&#x7f;38124000-0&#x7f;38125000-7&#x7f;38126000-4&#x7f;38126100-5&#x7f;38126200-6&#x7f;38126300-7&#x7f;38126400-8&#x7f;38127000-1&#x7f;38128000-8&#x7f;38200000-7&#x7f;38210000-0&#x7f;38220000-3&#x7f;38221000-0&#x7f;38230000-6&#x7f;38240000-9&#x7f;38250000-2&#x7f;38260000-5&#x7f;38270000-8&#x7f;38280000-1&#x7f;38290000-4&#x7f;38291000-1&#x7f;38292000-8&#x7f;38293000-5&#x7f;38294000-2&#x7f;38295000-9&#x7f;38296000-6&#x7f;38300000-8&#x7f;38310000-1&#x7f;38311000-8&#x7f;38311100-9&#x7f;38311200-0&#x7f;38311210-3&#x7f;38320000-4&#x7f;38321000-1&#x7f;38322000-8&#x7f;38323000-5&#x7f;38330000-7&#x7f;38331000-4&#x7f;38340000-0&#x7f;38341000-7&#x7f;38341100-8&#x7f;38341200-9&#x7f;38341300-0&#x7f;38341310-3&#x7f;38341320-6&#x7f;38341400-1&#x7f;38341500-2&#x7f;38341600-3&#x7f;38342000-4&#x7f;38342100-5&#x7f;38343000-1&#x7f;38344000-8&#x7f;38400000-9&#x7f;38410000-2&#x7f;38411000-9&#x7f;38412000-6&#x7f;38413000-3&#x7f;38414000-0&#x7f;38415000-7&#x7f;38416000-4&#x7f;38417000-1&#x7f;38418000-8&#x7f;38420000-5&#x7f;38421000-2&#x7f;38421100-3&#x7f;38421110-6&#x7f;38422000-9&#x7f;38423000-6&#x7f;38423100-7&#x7f;38424000-3&#x7f;38425000-0&#x7f;38425100-1&#x7f;38425200-2&#x7f;38425300-3&#x7f;38425400-4&#x7f;38425500-5&#x7f;38425600-6&#x7f;38425700-7&#x7f;38425800-8&#x7f;38426000-7&#x7f;38427000-4&#x7f;38428000-1&#x7f;38429000-8&#x7f;38430000-8&#x7f;38431000-5&#x7f;38431100-6&#x7f;38431200-7&#x7f;38431300-8&#x7f;38432000-2&#x7f;38432100-3&#x7f;38432200-4&#x7f;38432210-7&#x7f;38432300-5&#x7f;38433000-9&#x7f;38433100-0&#x7f;38433200-1&#x7f;38433210-4&#x7f;38433300-2&#x7f;38434000-6&#x7f;38434100-7&#x7f;38434200-8&#x7f;38434210-1&#x7f;38434220-4&#x7f;38434300-9&#x7f;38434310-2&#x7f;38434400-0&#x7f;38434500-1&#x7f;38434510-4&#x7f;38434520-7&#x7f;38434530-0&#x7f;38434540-3&#x7f;38434550-6&#x7f;38434560-9&#x7f;38434570-2&#x7f;38434580-5&#x7f;38435000-3&#x7f;38436000-0&#x7f;38436100-1&#x7f;38436110-4&#x7f;38436120-7&#x7f;38436130-0&#x7f;38436140-3&#x7f;38436150-6&#x7f;38436160-9&#x7f;38436170-2&#x7f;38436200-2&#x7f;38436210-5&#x7f;38436220-8&#x7f;38436230-1&#x7f;38436300-3&#x7f;38436310-6&#x7f;38436320-9&#x7f;38436400-4&#x7f;38436410-7&#x7f;38436500-5&#x7f;38436510-8&#x7f;38436600-6&#x7f;38436610-9&#x7f;38436700-7&#x7f;38436710-0&#x7f;38436720-3&#x7f;38436730-6&#x7f;38436800-8&#x7f;38437000-7&#x7f;38437100-8&#x7f;38437110-1&#x7f;38437120-4&#x7f;38500000-0&#x7f;38510000-3&#x7f;38511000-0&#x7f;38511100-1&#x7f;38511200-2&#x7f;38512000-7&#x7f;38512100-8&#x7f;38512200-9&#x7f;38513000-4&#x7f;38513100-5&#x7f;38513200-6&#x7f;38514000-1&#x7f;38514100-2&#x7f;38514200-3&#x7f;38515000-8&#x7f;38515100-9&#x7f;38515200-0&#x7f;38516000-5&#x7f;38517000-2&#x7f;38517100-3&#x7f;38517200-4&#x7f;38518000-9&#x7f;38518100-0&#x7f;38518200-1&#x7f;38519000-6&#x7f;38519100-7&#x7f;38519200-8&#x7f;38519300-9&#x7f;38519310-2&#x7f;38519320-5&#x7f;38519400-0&#x7f;38519500-1&#x7f;38519600-2&#x7f;38519610-5&#x7f;38519620-8&#x7f;38519630-1&#x7f;38519640-4&#x7f;38519650-7&#x7f;38519660-0&#x7f;38520000-6&#x7f;38521000-3&#x7f;38522000-0&#x7f;38527100-6&#x7f;38527200-7&#x7f;38527300-8&#x7f;38527400-9&#x7f;38530000-9&#x7f;38540000-2&#x7f;38541000-9&#x7f;38542000-6&#x7f;38543000-3&#x7f;38544000-0&#x7f;38545000-7&#x7f;38546000-4&#x7f;38546100-5&#x7f;38547000-1&#x7f;38548000-8&#x7f;38550000-5&#x7f;38551000-2&#x7f;38552000-9&#x7f;38553000-6&#x7f;38554000-3&#x7f;38560000-8&#x7f;38561000-5&#x7f;38561100-6&#x7f;38561110-9&#x7f;38561120-2&#x7f;38562000-2&#x7f;38570000-1&#x7f;38571000-8&#x7f;38580000-4&#x7f;38581000-1&#x7f;38582000-8&#x7f;38600000-1&#x7f;38620000-7&#x7f;38621000-4&#x7f;38622000-1&#x7f;38623000-8&#x7f;38624000-5&#x7f;38630000-0&#x7f;38631000-7&#x7f;38632000-4&#x7f;38633000-1&#x7f;38634000-8&#x7f;38635000-5&#x7f;38636000-2&#x7f;38636100-3&#x7f;38636110-6&#x7f;38640000-3&#x7f;38641000-0&#x7f;38650000-6&#x7f;38651000-3&#x7f;38651100-4&#x7f;38651200-5&#x7f;38651300-6&#x7f;38651400-7&#x7f;38651500-8&#x7f;38651600-9&#x7f;38652000-0&#x7f;38652100-1&#x7f;38652110-4&#x7f;38652120-7&#x7f;38652200-2&#x7f;38652300-3&#x7f;38653000-7&#x7f;38653100-8&#x7f;38653110-1&#x7f;38653111-8&#x7f;38653200-9&#x7f;38653300-0&#x7f;38653400-1&#x7f;38654000-4&#x7f;38654100-5&#x7f;38654110-8&#x7f;38654200-6&#x7f;38654210-9&#x7f;38654300-7&#x7f;38654310-0&#x7f;38700000-2&#x7f;38710000-5&#x7f;38720000-8&#x7f;38730000-1&#x7f;38731000-8&#x7f;38740000-4&#x7f;38750000-7&#x7f;38800000-3&#x7f;38810000-6&#x7f;38820000-9&#x7f;38821000-6&#x7f;38822000-3&#x7f;38900000-4&#x7f;38910000-7&#x7f;38911000-4&#x7f;38912000-1&#x7f;38920000-0&#x7f;38921000-7&#x7f;38922000-4&#x7f;38923000-1&#x7f;38930000-3&#x7f;38931000-0&#x7f;38932000-7&#x7f;38940000-6&#x7f;38941000-7&#x7f;38942000-7&#x7f;38943000-7&#x7f;38944000-7&#x7f;38945000-7&#x7f;38946000-7&#x7f;38947000-7&#x7f;38950000-9&#x7f;38951000-6&#x7f;38960000-2&#x7f;38970000-5&#x7f;39000000-2&#x7f;39100000-3&#x7f;39110000-6&#x7f;39111000-3&#x7f;39111100-4&#x7f;39111200-5&#x7f;39111300-6&#x7f;39112000-0&#x7f;39112100-1&#x7f;39113000-7&#x7f;39113100-8&#x7f;39113200-9&#x7f;39113300-0&#x7f;39113400-1&#x7f;39113500-2&#x7f;39113600-3&#x7f;39113700-4&#x7f;39114000-4&#x7f;39114100-5&#x7f;39120000-9&#x7f;39121000-6&#x7f;39121100-7&#x7f;39121200-8&#x7f;39122000-3&#x7f;39122100-4&#x7f;39122200-5&#x7f;39130000-2&#x7f;39131000-9&#x7f;39131100-0&#x7f;39132000-6&#x7f;39132100-7&#x7f;39132200-8&#x7f;39132300-9&#x7f;39132400-0&#x7f;39132500-1&#x7f;39133000-3&#x7f;39134000-0&#x7f;39134100-1&#x7f;39135000-7&#x7f;39135100-8&#x7f;39136000-4&#x7f;39137000-1&#x7f;39140000-5&#x7f;39141000-2&#x7f;39141100-3&#x7f;39141200-4&#x7f;39141300-5&#x7f;39141400-6&#x7f;39141500-7&#x7f;39142000-9&#x7f;39143000-6&#x7f;39143100-7&#x7f;39143110-0&#x7f;39143111-7&#x7f;39143112-4&#x7f;39143113-1&#x7f;39143114-8&#x7f;39143115-5&#x7f;39143116-2&#x7f;39143120-3&#x7f;39143121-0&#x7f;39143122-7&#x7f;39143123-4&#x7f;39143200-8&#x7f;39143210-1&#x7f;39143300-9&#x7f;39143310-2&#x7f;39144000-3&#x7f;39145000-0&#x7f;39150000-8&#x7f;39151000-5&#x7f;39151100-6&#x7f;39151200-7&#x7f;39151300-8&#x7f;39152000-2&#x7f;39153000-9&#x7f;39153100-0&#x7f;39154000-6&#x7f;39154100-7&#x7f;39155000-3&#x7f;39155100-4&#x7f;39156000-0&#x7f;39157000-7&#x7f;39160000-1&#x7f;39161000-8&#x7f;39162000-5&#x7f;39162100-6&#x7f;39162110-9&#x7f;39162200-7&#x7f;39170000-4&#x7f;39171000-1&#x7f;39172000-8&#x7f;39172100-9&#x7f;39173000-5&#x7f;39174000-2&#x7f;39180000-7&#x7f;39181000-4&#x7f;39190000-0&#x7f;39191000-7&#x7f;39191100-8&#x7f;39192000-4&#x7f;39193000-1&#x7f;39200000-4&#x7f;39220000-0&#x7f;39221000-7&#x7f;39221100-8&#x7f;39221110-1&#x7f;39221120-4&#x7f;39221121-1&#x7f;39221122-8&#x7f;39221123-5&#x7f;39221130-7&#x7f;39221140-0&#x7f;39221150-3&#x7f;39221160-6&#x7f;39221170-9&#x7f;39221180-2&#x7f;39221190-5&#x7f;39221200-9&#x7f;39221210-2&#x7f;39221220-5&#x7f;39221230-8&#x7f;39221240-1&#x7f;39221250-4&#x7f;39221260-7&#x7f;39222000-4&#x7f;39222100-5&#x7f;39222110-8&#x7f;39222120-1&#x7f;39222200-6&#x7f;39223000-1&#x7f;39223100-2&#x7f;39223200-3&#x7f;39224000-8&#x7f;39224100-9&#x7f;39224200-0&#x7f;39224210-3&#x7f;39224300-1&#x7f;39224310-4&#x7f;39224320-7&#x7f;39224330-0&#x7f;39224340-3&#x7f;39224350-6&#x7f;39225000-5&#x7f;39225100-6&#x7f;39225200-7&#x7f;39225300-8&#x7f;39225400-9&#x7f;39225500-0&#x7f;39225600-1&#x7f;39225700-2&#x7f;39225710-5&#x7f;39225720-8&#x7f;39225730-1&#x7f;39226000-2&#x7f;39226100-3&#x7f;39226200-4&#x7f;39226210-7&#x7f;39226220-0&#x7f;39226300-5&#x7f;39227000-9&#x7f;39227100-0&#x7f;39227110-3&#x7f;39227120-6&#x7f;39227200-1&#x7f;39230000-3&#x7f;39234000-1&#x7f;39235000-8&#x7f;39236000-5&#x7f;39237000-2&#x7f;39240000-6&#x7f;39241000-3&#x7f;39241100-4&#x7f;39241110-7&#x7f;39241120-0&#x7f;39241130-3&#x7f;39241200-5&#x7f;39254000-7&#x7f;39254100-8&#x7f;39254110-1&#x7f;39254120-4&#x7f;39254130-7&#x7f;39260000-2&#x7f;39261000-9&#x7f;39263000-3&#x7f;39263100-4&#x7f;39264000-0&#x7f;39265000-7&#x7f;39270000-5&#x7f;39290000-1&#x7f;39291000-8&#x7f;39292000-5&#x7f;39292100-6&#x7f;39292110-9&#x7f;39292200-7&#x7f;39292300-8&#x7f;39292400-9&#x7f;39292500-0&#x7f;39293000-2&#x7f;39293100-3&#x7f;39293200-4&#x7f;39293300-5&#x7f;39293400-6&#x7f;39293500-7&#x7f;39294000-9&#x7f;39294100-0&#x7f;39295000-6&#x7f;39295100-7&#x7f;39295200-8&#x7f;39295300-9&#x7f;39295400-0&#x7f;39295500-1&#x7f;39296000-3&#x7f;39296100-4&#x7f;39297000-0&#x7f;39298000-7&#x7f;39298100-8&#x7f;39298200-9&#x7f;39298300-0&#x7f;39298400-1&#x7f;39298500-2&#x7f;39298600-3&#x7f;39298700-4&#x7f;39298800-5&#x7f;39298900-6&#x7f;39298910-9&#x7f;39299000-4&#x7f;39299100-5&#x7f;39299200-6&#x7f;39299300-7&#x7f;39300000-5&#x7f;39310000-8&#x7f;39311000-5&#x7f;39312000-2&#x7f;39312100-3&#x7f;39312200-4&#x7f;39313000-9&#x7f;39314000-6&#x7f;39315000-3&#x7f;39330000-4&#x7f;39340000-7&#x7f;39341000-4&#x7f;39350000-0&#x7f;39360000-3&#x7f;39370000-6&#x7f;39500000-7&#x7f;39510000-0&#x7f;39511000-7&#x7f;39511100-8&#x7f;39511200-9&#x7f;39512000-4&#x7f;39512100-5&#x7f;39512200-6&#x7f;39512300-7&#x7f;39512400-8&#x7f;39512500-9&#x7f;39512600-0&#x7f;39513000-1&#x7f;39513100-2&#x7f;39513200-3&#x7f;39514000-8&#x7f;39514100-9&#x7f;39514200-0&#x7f;39514300-1&#x7f;39514400-2&#x7f;39514500-3&#x7f;39515000-5&#x7f;39515100-6&#x7f;39515110-9&#x7f;39515200-7&#x7f;39515300-8&#x7f;39515400-9&#x7f;39515410-2&#x7f;39515420-5&#x7f;39515430-8&#x7f;39515440-1&#x7f;39516000-2&#x7f;39516100-3&#x7f;39516110-6&#x7f;39516120-9&#x7f;39518000-6&#x7f;39518100-7&#x7f;39518200-8&#x7f;39520000-3&#x7f;39522000-7&#x7f;39522100-8&#x7f;39522110-1&#x7f;39522120-4&#x7f;39522130-7&#x7f;39522200-9&#x7f;39522400-1&#x7f;39522500-2&#x7f;39522510-5&#x7f;39522520-8&#x7f;39522530-1&#x7f;39522540-4&#x7f;39522541-1&#x7f;39523000-4&#x7f;39523100-5&#x7f;39523200-6&#x7f;39525000-8&#x7f;39525100-9&#x7f;39525200-0&#x7f;39525300-1&#x7f;39525400-2&#x7f;39525500-3&#x7f;39525600-4&#x7f;39525700-5&#x7f;39525800-6&#x7f;39525810-9&#x7f;39530000-6&#x7f;39531000-3&#x7f;39531100-4&#x7f;39531200-5&#x7f;39531300-6&#x7f;39531310-9&#x7f;39531400-7&#x7f;39532000-0&#x7f;39533000-7&#x7f;39534000-4&#x7f;39540000-9&#x7f;39541000-6&#x7f;39541100-7&#x7f;39541110-0&#x7f;39541120-3&#x7f;39541130-6&#x7f;39541140-9&#x7f;39541200-8&#x7f;39541210-1&#x7f;39541220-4&#x7f;39542000-3&#x7f;39550000-2&#x7f;39560000-5&#x7f;39561000-2&#x7f;39561100-3&#x7f;39561110-6&#x7f;39561120-9&#x7f;39561130-2&#x7f;39561131-9&#x7f;39561132-6&#x7f;39561133-3&#x7f;39561140-5&#x7f;39561141-2&#x7f;39561142-9&#x7f;39561200-4&#x7f;39562000-9&#x7f;39563000-6&#x7f;39563100-7&#x7f;39563200-8&#x7f;39563300-9&#x7f;39563400-0&#x7f;39563500-1&#x7f;39563510-4&#x7f;39563520-7&#x7f;39563530-0&#x7f;39563600-2&#x7f;39700000-9&#x7f;39710000-2&#x7f;39711000-9&#x7f;39711100-0&#x7f;39711110-3&#x7f;39711120-6&#x7f;39711121-3&#x7f;39711122-0&#x7f;39711123-7&#x7f;39711124-4&#x7f;39711130-9&#x7f;39711200-1&#x7f;39711210-4&#x7f;39711211-1&#x7f;39711300-2&#x7f;39711310-5&#x7f;39711320-8&#x7f;39711330-1&#x7f;39711340-4&#x7f;39711350-7&#x7f;39711360-0&#x7f;39711361-7&#x7f;39711362-4&#x7f;39711400-3&#x7f;39711410-6&#x7f;39711420-9&#x7f;39711430-2&#x7f;39711440-5&#x7f;39711500-4&#x7f;39712000-6&#x7f;39712100-7&#x7f;39712200-8&#x7f;39712210-1&#x7f;39712300-9&#x7f;39713000-3&#x7f;39713100-4&#x7f;39713200-5&#x7f;39713210-8&#x7f;39713211-5&#x7f;39713300-6&#x7f;39713400-7&#x7f;39713410-0&#x7f;39713420-3&#x7f;39713430-6&#x7f;39713431-3&#x7f;39713500-8&#x7f;39713510-1&#x7f;39714000-0&#x7f;39714100-1&#x7f;39714110-4&#x7f;39715000-7&#x7f;39715100-8&#x7f;39715200-9&#x7f;39715210-2&#x7f;39715220-5&#x7f;39715230-8&#x7f;39715240-1&#x7f;39715300-0&#x7f;39716000-4&#x7f;39717000-1&#x7f;39717100-2&#x7f;39717200-3&#x7f;39720000-5&#x7f;39721000-2&#x7f;39721100-3&#x7f;39721200-4&#x7f;39721300-5&#x7f;39721310-8&#x7f;39721320-1&#x7f;39721321-8&#x7f;39721400-6&#x7f;39721410-9&#x7f;39721411-6&#x7f;39722000-9&#x7f;39722100-0&#x7f;39722200-1&#x7f;39722300-2&#x7f;39800000-0&#x7f;39810000-3&#x7f;39811000-0&#x7f;39811100-1&#x7f;39811110-4&#x7f;39811200-2&#x7f;39811300-3&#x7f;39812000-7&#x7f;39812100-8&#x7f;39812200-9&#x7f;39812300-0&#x7f;39812400-1&#x7f;39812500-2&#x7f;39813000-4&#x7f;39820000-6&#x7f;39821000-3&#x7f;39822000-0&#x7f;39830000-9&#x7f;39831000-6&#x7f;39831100-7&#x7f;39831200-8&#x7f;39831210-1&#x7f;39831220-4&#x7f;39831230-7&#x7f;39831240-0&#x7f;39831250-3&#x7f;39831300-9&#x7f;39831400-0&#x7f;39831500-1&#x7f;39831600-2&#x7f;39831700-3&#x7f;39832000-3&#x7f;39832100-4&#x7f;39833000-0&#x7f;39834000-7&#x7f;41000000-9&#x7f;41100000-0&#x7f;41110000-3&#x7f;41120000-6&#x7f;42000000-6&#x7f;42100000-0&#x7f;42110000-3&#x7f;42111000-0&#x7f;42111100-1&#x7f;42112000-7&#x7f;42112100-8&#x7f;42112200-9&#x7f;42112210-2&#x7f;42112300-0&#x7f;42112400-1&#x7f;42112410-4&#x7f;42113000-4&#x7f;42113100-5&#x7f;42113110-8&#x7f;42113120-1&#x7f;42113130-4&#x7f;42113150-0&#x7f;42113160-3&#x7f;42113161-0&#x7f;42113170-6&#x7f;42113171-3&#x7f;42113172-0&#x7f;42113190-2&#x7f;42113200-6&#x7f;42113300-7&#x7f;42113310-0&#x7f;42113320-3&#x7f;42113390-4&#x7f;42113400-8&#x7f;42120000-6&#x7f;42121000-3&#x7f;42121100-4&#x7f;42121200-5&#x7f;42121300-6&#x7f;42121400-7&#x7f;42121500-8&#x7f;42122000-0&#x7f;42122100-1&#x7f;42122110-4&#x7f;42122120-7&#x7f;42122130-0&#x7f;42122160-9&#x7f;42122161-6&#x7f;42122170-2&#x7f;42122180-5&#x7f;42122190-8&#x7f;42122200-2&#x7f;42122210-5&#x7f;42122220-8&#x7f;42122230-1&#x7f;42122300-3&#x7f;42122400-4&#x7f;42122410-7&#x7f;42122411-4&#x7f;42122419-0&#x7f;42122420-0&#x7f;42122430-3&#x7f;42122440-6&#x7f;42122450-9&#x7f;42122460-2&#x7f;42122480-8&#x7f;42122500-5&#x7f;42122510-8&#x7f;42123000-7&#x7f;42123100-8&#x7f;42123200-9&#x7f;42123300-0&#x7f;42123400-1&#x7f;42123410-4&#x7f;42123500-2&#x7f;42123600-3&#x7f;42123610-6&#x7f;42123700-4&#x7f;42123800-5&#x7f;42124000-4&#x7f;42124100-5&#x7f;42124130-4&#x7f;42124150-0&#x7f;42124170-6&#x7f;42124200-6&#x7f;42124210-9&#x7f;42124211-6&#x7f;42124212-3&#x7f;42124213-0&#x7f;42124220-2&#x7f;42124221-9&#x7f;42124222-6&#x7f;42124230-5&#x7f;42124290-3&#x7f;42124300-7&#x7f;42124310-0&#x7f;42124320-3&#x7f;42124330-6&#x7f;42124340-9&#x7f;42130000-9&#x7f;42131000-6&#x7f;42131100-7&#x7f;42131110-0&#x7f;42131120-3&#x7f;42131130-6&#x7f;42131140-9&#x7f;42131141-6&#x7f;42131142-3&#x7f;42131143-0&#x7f;42131144-7&#x7f;42131145-4&#x7f;42131146-1&#x7f;42131147-8&#x7f;42131148-5&#x7f;42131150-2&#x7f;42131160-5&#x7f;42131170-8&#x7f;42131200-8&#x7f;42131210-1&#x7f;42131220-4&#x7f;42131230-7&#x7f;42131240-0&#x7f;42131250-3&#x7f;42131260-6&#x7f;42131270-9&#x7f;42131280-2&#x7f;42131290-5&#x7f;42131291-2&#x7f;42131292-9&#x7f;42131300-9&#x7f;42131310-2&#x7f;42131320-5&#x7f;42131390-6&#x7f;42131400-0&#x7f;42132000-3&#x7f;42132100-4&#x7f;42132110-7&#x7f;42132120-0&#x7f;42132130-3&#x7f;42132200-5&#x7f;42132300-6&#x7f;42140000-2&#x7f;42141000-9&#x7f;42141100-0&#x7f;42141110-3&#x7f;42141120-6&#x7f;42141130-9&#x7f;42141200-1&#x7f;42141300-2&#x7f;42141400-3&#x7f;42141410-6&#x7f;42141500-4&#x7f;42141600-5&#x7f;42141700-6&#x7f;42141800-7&#x7f;42142000-6&#x7f;42142100-7&#x7f;42142200-8&#x7f;42150000-5&#x7f;42151000-2&#x7f;42152000-9&#x7f;42152100-0&#x7f;42152200-1&#x7f;42160000-8&#x7f;42161000-5&#x7f;42162000-2&#x7f;42163000-9&#x7f;42164000-6&#x7f;42165000-3&#x7f;42200000-8&#x7f;42210000-1&#x7f;42211000-8&#x7f;42211100-9&#x7f;42212000-5&#x7f;42213000-2&#x7f;42214000-9&#x7f;42214100-0&#x7f;42214110-3&#x7f;42214200-1&#x7f;42215000-6&#x7f;42215100-7&#x7f;42215110-0&#x7f;42215120-3&#x7f;42215200-8&#x7f;42215300-9&#x7f;42216000-3&#x7f;42220000-4&#x7f;42221000-1&#x7f;42221100-2&#x7f;42221110-5&#x7f;42222000-8&#x7f;42223000-5&#x7f;42300000-9&#x7f;42310000-2&#x7f;42320000-5&#x7f;42330000-8&#x7f;42340000-1&#x7f;42341000-8&#x7f;42350000-4&#x7f;42390000-6&#x7f;42400000-0&#x7f;42410000-3&#x7f;42411000-0&#x7f;42412000-7&#x7f;42412100-8&#x7f;42412110-1&#x7f;42412120-4&#x7f;42412200-9&#x7f;42413000-4&#x7f;42413100-5&#x7f;42413200-6&#x7f;42413300-7&#x7f;42413400-8&#x7f;42413500-9&#x7f;42414000-1&#x7f;42414100-2&#x7f;42414110-5&#x7f;42414120-8&#x7f;42414130-1&#x7f;42414140-4&#x7f;42414150-7&#x7f;42414200-3&#x7f;42414210-6&#x7f;42414220-9&#x7f;42414300-4&#x7f;42414310-7&#x7f;42414320-0&#x7f;42414400-5&#x7f;42414410-8&#x7f;42414500-6&#x7f;42415000-8&#x7f;42415100-9&#x7f;42415110-2&#x7f;42415200-0&#x7f;42415210-3&#x7f;42415300-1&#x7f;42415310-4&#x7f;42415320-7&#x7f;42416000-5&#x7f;42416100-6&#x7f;42416110-9&#x7f;42416120-2&#x7f;42416130-5&#x7f;42416200-7&#x7f;42416210-0&#x7f;42416300-8&#x7f;42416400-9&#x7f;42416500-0&#x7f;42417000-2&#x7f;42417100-3&#x7f;42417200-4&#x7f;42417210-7&#x7f;42417220-0&#x7f;42417230-3&#x7f;42417300-5&#x7f;42417310-8&#x7f;42418000-9&#x7f;42418100-0&#x7f;42418200-1&#x7f;42418210-4&#x7f;42418220-7&#x7f;42418290-8&#x7f;42418300-2&#x7f;42418400-3&#x7f;42418500-4&#x7f;42418900-8&#x7f;42418910-1&#x7f;42418920-4&#x7f;42418930-7&#x7f;42418940-0&#x7f;42419000-6&#x7f;42419100-7&#x7f;42419200-8&#x7f;42419500-1&#x7f;42419510-4&#x7f;42419520-7&#x7f;42419530-0&#x7f;42419540-3&#x7f;42419800-4&#x7f;42419810-7&#x7f;42419890-1&#x7f;42419900-5&#x7f;42420000-6&#x7f;42500000-1&#x7f;42510000-4&#x7f;42511000-1&#x7f;42511100-2&#x7f;42511110-5&#x7f;42511200-3&#x7f;42512000-8&#x7f;42512100-9&#x7f;42512200-0&#x7f;42512300-1&#x7f;42512400-2&#x7f;42512500-3&#x7f;42512510-6&#x7f;42512520-9&#x7f;42513000-5&#x7f;42513100-6&#x7f;42513200-7&#x7f;42513210-0&#x7f;42513220-3&#x7f;42513290-4&#x7f;42514000-2&#x7f;42514200-4&#x7f;42514300-5&#x7f;42514310-8&#x7f;42514320-1&#x7f;42515000-9&#x7f;42520000-7&#x7f;42521000-4&#x7f;42522000-1&#x7f;42522100-2&#x7f;42530000-0&#x7f;42531000-7&#x7f;42532000-4&#x7f;42533000-1&#x7f;42600000-2&#x7f;42610000-5&#x7f;42611000-2&#x7f;42612000-9&#x7f;42612100-0&#x7f;42612200-1&#x7f;42620000-8&#x7f;42621000-5&#x7f;42621100-6&#x7f;42622000-2&#x7f;42623000-9&#x7f;42630000-1&#x7f;42631000-8&#x7f;42632000-5&#x7f;42633000-2&#x7f;42634000-9&#x7f;42635000-6&#x7f;42636000-3&#x7f;42636100-4&#x7f;42637000-0&#x7f;42637100-1&#x7f;42637200-2&#x7f;42637300-3&#x7f;42638000-7&#x7f;42640000-4&#x7f;42641000-1&#x7f;42641100-2&#x7f;42641200-3&#x7f;42641300-4&#x7f;42641400-5&#x7f;42642000-8&#x7f;42642100-9&#x7f;42642200-0&#x7f;42642300-1&#x7f;42642400-2&#x7f;42642500-3&#x7f;42650000-7&#x7f;42651000-4&#x7f;42652000-1&#x7f;42660000-0&#x7f;42661000-7&#x7f;42661100-8&#x7f;42661200-9&#x7f;42662000-4&#x7f;42662100-5&#x7f;42662200-6&#x7f;42663000-1&#x7f;42664000-8&#x7f;42664100-9&#x7f;42665000-5&#x7f;42670000-3&#x7f;42671000-0&#x7f;42671100-1&#x7f;42671110-4&#x7f;42672000-7&#x7f;42673000-4&#x7f;42674000-1&#x7f;42675000-8&#x7f;42675100-9&#x7f;42676000-5&#x7f;42677000-2&#x7f;42700000-3&#x7f;42710000-6&#x7f;42711000-3&#x7f;42712000-0&#x7f;42713000-7&#x7f;42714000-4&#x7f;42715000-1&#x7f;42716000-8&#x7f;42716100-9&#x7f;42716110-2&#x7f;42716120-5&#x7f;42716130-8&#x7f;42716200-0&#x7f;42717000-5&#x7f;42717100-6&#x7f;42718000-2&#x7f;42718100-3&#x7f;42718200-4&#x7f;42720000-9&#x7f;42800000-4&#x7f;42810000-7&#x7f;42900000-5&#x7f;42910000-8&#x7f;42912000-2&#x7f;42912100-3&#x7f;42912110-6&#x7f;42912120-9&#x7f;42912130-2&#x7f;42912300-5&#x7f;42912310-8&#x7f;42912320-1&#x7f;42912330-4&#x7f;42912340-7&#x7f;42912350-0&#x7f;42913000-9&#x7f;42913300-2&#x7f;42913400-3&#x7f;42913500-4&#x7f;42914000-6&#x7f;42920000-1&#x7f;42921000-8&#x7f;42921100-9&#x7f;42921200-0&#x7f;42921300-1&#x7f;42921310-4&#x7f;42921320-7&#x7f;42921330-0&#x7f;42923000-2&#x7f;42923100-3&#x7f;42923110-6&#x7f;42923200-4&#x7f;42923210-7&#x7f;42923220-0&#x7f;42923230-3&#x7f;42924200-1&#x7f;42924300-2&#x7f;42924310-5&#x7f;42924700-6&#x7f;42924710-9&#x7f;42924720-2&#x7f;42924730-5&#x7f;42924740-8&#x7f;42924790-3&#x7f;42930000-4&#x7f;42931000-1&#x7f;42931100-2&#x7f;42931110-5&#x7f;42931120-8&#x7f;42931130-1&#x7f;42931140-4&#x7f;42932000-8&#x7f;42932100-9&#x7f;42933000-5&#x7f;42933100-6&#x7f;42933200-7&#x7f;42933300-8&#x7f;42940000-7&#x7f;42941000-4&#x7f;42942000-1&#x7f;42942200-3&#x7f;42943000-8&#x7f;42943100-9&#x7f;42943200-0&#x7f;42943210-3&#x7f;42943300-1&#x7f;42943400-2&#x7f;42943500-3&#x7f;42943600-4&#x7f;42943700-5&#x7f;42943710-8&#x7f;42950000-0&#x7f;42952000-4&#x7f;42953000-1&#x7f;42954000-8&#x7f;42955000-5&#x7f;42956000-2&#x7f;42957000-9&#x7f;42958000-6&#x7f;42959000-3&#x7f;42960000-3&#x7f;42961000-0&#x7f;42961100-1&#x7f;42961200-2&#x7f;42961300-3&#x7f;42961400-4&#x7f;42962000-7&#x7f;42962100-8&#x7f;42962200-9&#x7f;42962300-0&#x7f;42962400-1&#x7f;42962500-2&#x7f;42963000-4&#x7f;42964000-1&#x7f;42965000-8&#x7f;42965100-9&#x7f;42965110-2&#x7f;42967000-2&#x7f;42967100-3&#x7f;42968000-9&#x7f;42968100-0&#x7f;42968200-1&#x7f;42968300-2&#x7f;42970000-6&#x7f;42971000-3&#x7f;42972000-0&#x7f;42973000-7&#x7f;42974000-4&#x7f;42975000-1&#x7f;42980000-9&#x7f;42981000-6&#x7f;42990000-2&#x7f;42991000-9&#x7f;42991100-0&#x7f;42991110-3&#x7f;42991200-1&#x7f;42991210-4&#x7f;42991220-7&#x7f;42991230-0&#x7f;42991300-2&#x7f;42991400-3&#x7f;42991500-4&#x7f;42992000-6&#x7f;42992100-7&#x7f;42992200-8&#x7f;42992300-9&#x7f;42993000-3&#x7f;42993100-4&#x7f;42993200-5&#x7f;42994000-0&#x7f;42994100-1&#x7f;42994200-2&#x7f;42994220-8&#x7f;42994230-1&#x7f;42995000-7&#x7f;42995100-8&#x7f;42995200-9&#x7f;42996000-4&#x7f;42996100-5&#x7f;42996110-8&#x7f;42996200-6&#x7f;42996300-7&#x7f;42996400-8&#x7f;42996500-9&#x7f;42996600-0&#x7f;42996700-1&#x7f;42996800-2&#x7f;42996900-3&#x7f;42997000-1&#x7f;42997100-2&#x7f;42997200-3&#x7f;42997300-4&#x7f;42998000-8&#x7f;42998100-9&#x7f;42999000-5&#x7f;42999100-6&#x7f;42999200-7&#x7f;42999300-8&#x7f;42999400-9&#x7f;43000000-3&#x7f;43100000-4&#x7f;43120000-0&#x7f;43121000-7&#x7f;43121100-8&#x7f;43121200-9&#x7f;43121300-0&#x7f;43121400-1&#x7f;43121500-2&#x7f;43121600-3&#x7f;43122000-4&#x7f;43123000-1&#x7f;43124000-8&#x7f;43124100-9&#x7f;43124900-7&#x7f;43125000-5&#x7f;43130000-3&#x7f;43131000-0&#x7f;43131100-1&#x7f;43131200-2&#x7f;43132000-7&#x7f;43132100-8&#x7f;43132200-9&#x7f;43132300-0&#x7f;43132400-1&#x7f;43132500-2&#x7f;43133000-4&#x7f;43133100-5&#x7f;43133200-6&#x7f;43134000-1&#x7f;43134100-2&#x7f;43135000-8&#x7f;43135100-9&#x7f;43136000-5&#x7f;43140000-6&#x7f;43200000-5&#x7f;43210000-8&#x7f;43211000-5&#x7f;43212000-2&#x7f;43220000-1&#x7f;43221000-8&#x7f;43230000-4&#x7f;43240000-7&#x7f;43250000-0&#x7f;43251000-7&#x7f;43252000-4&#x7f;43260000-3&#x7f;43261000-0&#x7f;43261100-1&#x7f;43262000-7&#x7f;43262100-8&#x7f;43300000-6&#x7f;43310000-9&#x7f;43311000-6&#x7f;43312000-3&#x7f;43312100-4&#x7f;43312200-5&#x7f;43312300-6&#x7f;43312400-7&#x7f;43312500-8&#x7f;43313000-0&#x7f;43313100-1&#x7f;43313200-2&#x7f;43314000-7&#x7f;43315000-4&#x7f;43316000-1&#x7f;43320000-2&#x7f;43321000-9&#x7f;43322000-6&#x7f;43323000-3&#x7f;43324000-0&#x7f;43324100-1&#x7f;43325000-7&#x7f;43325100-8&#x7f;43327000-1&#x7f;43328000-8&#x7f;43328100-9&#x7f;43329000-5&#x7f;43400000-7&#x7f;43410000-0&#x7f;43411000-7&#x7f;43412000-4&#x7f;43413000-1&#x7f;43413100-2&#x7f;43414000-8&#x7f;43414100-9&#x7f;43415000-5&#x7f;43420000-3&#x7f;43500000-8&#x7f;43600000-9&#x7f;43610000-2&#x7f;43611000-9&#x7f;43611100-0&#x7f;43611200-1&#x7f;43611300-2&#x7f;43611400-3&#x7f;43611500-4&#x7f;43611600-5&#x7f;43611700-6&#x7f;43612000-6&#x7f;43612100-7&#x7f;43612200-8&#x7f;43612300-9&#x7f;43612400-0&#x7f;43612500-1&#x7f;43612600-2&#x7f;43612700-3&#x7f;43612800-4&#x7f;43613000-3&#x7f;43613100-4&#x7f;43613200-5&#x7f;43614000-0&#x7f;43620000-5&#x7f;43630000-8&#x7f;43640000-1&#x7f;43700000-0&#x7f;43710000-3&#x7f;43711000-0&#x7f;43720000-6&#x7f;43721000-3&#x7f;43800000-1&#x7f;43810000-4&#x7f;43811000-1&#x7f;43812000-8&#x7f;43820000-7&#x7f;43830000-0&#x7f;43840000-3&#x7f;44000000-0&#x7f;44100000-1&#x7f;44110000-4&#x7f;44111000-1&#x7f;44111100-2&#x7f;44111200-3&#x7f;44111210-6&#x7f;44111300-4&#x7f;44111400-5&#x7f;44111500-6&#x7f;44111510-9&#x7f;44111511-6&#x7f;44111520-2&#x7f;44111530-5&#x7f;44111540-8&#x7f;44111600-7&#x7f;44111700-8&#x7f;44111800-9&#x7f;44111900-0&#x7f;44112000-8&#x7f;44112100-9&#x7f;44112110-2&#x7f;44112120-5&#x7f;44112200-0&#x7f;44112210-3&#x7f;44112220-6&#x7f;44112230-9&#x7f;44112240-2&#x7f;44112300-1&#x7f;44112310-4&#x7f;44112400-2&#x7f;44112410-5&#x7f;44112420-8&#x7f;44112430-1&#x7f;44112500-3&#x7f;44112510-6&#x7f;44112600-4&#x7f;44112700-5&#x7f;44113000-5&#x7f;44113100-6&#x7f;44113120-2&#x7f;44113130-5&#x7f;44113140-8&#x7f;44113200-7&#x7f;44113300-8&#x7f;44113310-1&#x7f;44113320-4&#x7f;44113330-7&#x7f;44113500-0&#x7f;44113600-1&#x7f;44113610-4&#x7f;44113620-7&#x7f;44113700-2&#x7f;44113800-3&#x7f;44113810-6&#x7f;44113900-4&#x7f;44113910-7&#x7f;44114000-2&#x7f;44114100-3&#x7f;44114200-4&#x7f;44114210-7&#x7f;44114220-0&#x7f;44114250-9&#x7f;44115000-9&#x7f;44115100-0&#x7f;44115200-1&#x7f;44115210-4&#x7f;44115220-7&#x7f;44115310-5&#x7f;44115400-3&#x7f;44115500-4&#x7f;44115600-5&#x7f;44115700-6&#x7f;44115710-9&#x7f;44115800-7&#x7f;44115810-0&#x7f;44115811-7&#x7f;44115900-8&#x7f;44130000-0&#x7f;44131000-7&#x7f;44132000-4&#x7f;44133000-1&#x7f;44134000-8&#x7f;44140000-3&#x7f;44141000-0&#x7f;44141100-1&#x7f;44142000-7&#x7f;44143000-4&#x7f;44144000-1&#x7f;44160000-9&#x7f;44161000-6&#x7f;44161100-7&#x7f;44161110-0&#x7f;44161200-8&#x7f;44161400-0&#x7f;44161410-3&#x7f;44161500-1&#x7f;44161600-2&#x7f;44161700-3&#x7f;44161710-6&#x7f;44161720-9&#x7f;44161730-2&#x7f;44162000-3&#x7f;44162100-4&#x7f;44162200-5&#x7f;44162300-6&#x7f;44162400-7&#x7f;44162500-8&#x7f;44163000-0&#x7f;44163100-1&#x7f;44163110-4&#x7f;44163111-1&#x7f;44163112-8&#x7f;44163120-7&#x7f;44163121-4&#x7f;44163130-0&#x7f;44163140-3&#x7f;44163150-6&#x7f;44163160-9&#x7f;44163200-2&#x7f;44163210-5&#x7f;44163230-1&#x7f;44163240-4&#x7f;44163241-1&#x7f;44164000-7&#x7f;44164100-8&#x7f;44164200-9&#x7f;44164300-0&#x7f;44164310-3&#x7f;44165000-4&#x7f;44165100-5&#x7f;44165110-8&#x7f;44165200-6&#x7f;44165210-9&#x7f;44165300-7&#x7f;44166000-1&#x7f;44167000-8&#x7f;44167100-9&#x7f;44167110-2&#x7f;44167111-9&#x7f;44167200-0&#x7f;44167300-1&#x7f;44167400-2&#x7f;44170000-2&#x7f;44171000-9&#x7f;44172000-6&#x7f;44173000-3&#x7f;44174000-0&#x7f;44175000-7&#x7f;44176000-4&#x7f;44190000-8&#x7f;44191000-5&#x7f;44191100-6&#x7f;44191200-7&#x7f;44191300-8&#x7f;44191400-9&#x7f;44191500-0&#x7f;44191600-1&#x7f;44192000-2&#x7f;44192100-3&#x7f;44192200-4&#x7f;44200000-2&#x7f;44210000-5&#x7f;44211000-2&#x7f;44211100-3&#x7f;44211110-6&#x7f;44211200-4&#x7f;44211300-5&#x7f;44211400-6&#x7f;44211500-7&#x7f;44212000-9&#x7f;44212100-0&#x7f;44212110-3&#x7f;44212120-6&#x7f;44212200-1&#x7f;44212210-4&#x7f;44212211-1&#x7f;44212212-8&#x7f;44212220-7&#x7f;44212221-4&#x7f;44212222-1&#x7f;44212223-8&#x7f;44212224-5&#x7f;44212225-2&#x7f;44212226-9&#x7f;44212227-6&#x7f;44212230-0&#x7f;44212233-1&#x7f;44212240-3&#x7f;44212250-6&#x7f;44212260-9&#x7f;44212261-6&#x7f;44212262-3&#x7f;44212263-0&#x7f;44212300-2&#x7f;44212310-5&#x7f;44212311-2&#x7f;44212312-9&#x7f;44212313-6&#x7f;44212314-3&#x7f;44212315-0&#x7f;44212316-7&#x7f;44212317-4&#x7f;44212318-1&#x7f;44212320-8&#x7f;44212321-5&#x7f;44212322-2&#x7f;44212329-1&#x7f;44212380-6&#x7f;44212381-3&#x7f;44212382-0&#x7f;44212383-7&#x7f;44212390-9&#x7f;44212391-6&#x7f;44212400-3&#x7f;44212410-6&#x7f;44212500-4&#x7f;44212510-7&#x7f;44212520-0&#x7f;44220000-8&#x7f;44221000-5&#x7f;44221100-6&#x7f;44221110-9&#x7f;44221111-6&#x7f;44221120-2&#x7f;44221200-7&#x7f;44221210-0&#x7f;44221211-7&#x7f;44221212-4&#x7f;44221213-1&#x7f;44221220-3&#x7f;44221230-6&#x7f;44221240-9&#x7f;44221300-8&#x7f;44221310-1&#x7f;44221400-9&#x7f;44221500-0&#x7f;44230000-1&#x7f;44231000-8&#x7f;44232000-5&#x7f;44233000-2&#x7f;44300000-3&#x7f;44310000-6&#x7f;44311000-3&#x7f;44312000-0&#x7f;44312300-3&#x7f;44313000-7&#x7f;44313100-8&#x7f;44313200-9&#x7f;44315000-1&#x7f;44315100-2&#x7f;44315200-3&#x7f;44315300-4&#x7f;44315310-7&#x7f;44315320-0&#x7f;44316000-8&#x7f;44316100-9&#x7f;44316200-0&#x7f;44316300-1&#x7f;44316400-2&#x7f;44316500-3&#x7f;44316510-6&#x7f;44317000-5&#x7f;44318000-2&#x7f;44320000-9&#x7f;44321000-6&#x7f;44322000-3&#x7f;44322100-4&#x7f;44322200-5&#x7f;44322300-6&#x7f;44322400-7&#x7f;44330000-2&#x7f;44331000-9&#x7f;44332000-6&#x7f;44333000-3&#x7f;44334000-0&#x7f;44400000-4&#x7f;44410000-7&#x7f;44411000-4&#x7f;44411100-5&#x7f;44411200-6&#x7f;44411300-7&#x7f;44411400-8&#x7f;44411600-0&#x7f;44411700-1&#x7f;44411710-4&#x7f;44411720-7&#x7f;44411740-3&#x7f;44411750-6&#x7f;44411800-2&#x7f;44420000-0&#x7f;44421000-7&#x7f;44421300-0&#x7f;44421500-2&#x7f;44421600-3&#x7f;44421700-4&#x7f;44421710-7&#x7f;44421720-0&#x7f;44421721-7&#x7f;44421722-4&#x7f;44421780-8&#x7f;44421790-1&#x7f;44422000-4&#x7f;44423000-1&#x7f;44423100-2&#x7f;44423200-3&#x7f;44423220-9&#x7f;44423230-2&#x7f;44423300-4&#x7f;44423330-3&#x7f;44423340-6&#x7f;44423400-5&#x7f;44423450-0&#x7f;44423460-3&#x7f;44423700-8&#x7f;44423710-1&#x7f;44423720-4&#x7f;44423730-7&#x7f;44423740-0&#x7f;44423750-3&#x7f;44423760-6&#x7f;44423790-5&#x7f;44423800-9&#x7f;44423810-2&#x7f;44423850-4&#x7f;44423900-0&#x7f;44424000-8&#x7f;44424100-9&#x7f;44424200-0&#x7f;44424300-1&#x7f;44425000-5&#x7f;44425100-6&#x7f;44425110-9&#x7f;44425200-7&#x7f;44425300-8&#x7f;44425400-9&#x7f;44425500-0&#x7f;44430000-3&#x7f;44431000-0&#x7f;44440000-6&#x7f;44441000-3&#x7f;44442000-0&#x7f;44450000-9&#x7f;44451000-6&#x7f;44452000-3&#x7f;44460000-2&#x7f;44461000-9&#x7f;44461100-0&#x7f;44462000-6&#x7f;44464000-0&#x7f;44470000-5&#x7f;44480000-8&#x7f;44481000-5&#x7f;44481100-6&#x7f;44482000-2&#x7f;44482100-3&#x7f;44482200-4&#x7f;44500000-5&#x7f;44510000-8&#x7f;44511000-5&#x7f;44511100-6&#x7f;44511110-9&#x7f;44511120-2&#x7f;44511200-7&#x7f;44511300-8&#x7f;44511310-1&#x7f;44511320-4&#x7f;44511330-7&#x7f;44511340-0&#x7f;44511341-7&#x7f;44511400-9&#x7f;44511500-0&#x7f;44511510-3&#x7f;44512000-2&#x7f;44512100-3&#x7f;44512200-4&#x7f;44512210-7&#x7f;44512300-5&#x7f;44512400-6&#x7f;44512500-7&#x7f;44512600-8&#x7f;44512610-1&#x7f;44512700-9&#x7f;44512800-0&#x7f;44512900-1&#x7f;44512910-4&#x7f;44512920-7&#x7f;44512930-0&#x7f;44512940-3&#x7f;44513000-9&#x7f;44514000-6&#x7f;44514100-7&#x7f;44514200-8&#x7f;44520000-1&#x7f;44521000-8&#x7f;44521100-9&#x7f;44521110-2&#x7f;44521120-5&#x7f;44521130-8&#x7f;44521140-1&#x7f;44521200-0&#x7f;44521210-3&#x7f;44522000-5&#x7f;44522100-6&#x7f;44522200-7&#x7f;44522300-8&#x7f;44522400-9&#x7f;44523000-2&#x7f;44523100-3&#x7f;44523200-4&#x7f;44523300-5&#x7f;44530000-4&#x7f;44531000-1&#x7f;44531100-2&#x7f;44531200-3&#x7f;44531300-4&#x7f;44531400-5&#x7f;44531500-6&#x7f;44531510-9&#x7f;44531520-2&#x7f;44531600-7&#x7f;44531700-8&#x7f;44532000-8&#x7f;44532100-9&#x7f;44532200-0&#x7f;44532300-1&#x7f;44532400-2&#x7f;44533000-5&#x7f;44540000-7&#x7f;44541000-4&#x7f;44542000-1&#x7f;44550000-0&#x7f;44600000-6&#x7f;44610000-9&#x7f;44611000-6&#x7f;44611100-7&#x7f;44611110-0&#x7f;44611200-8&#x7f;44611400-0&#x7f;44611410-3&#x7f;44611420-6&#x7f;44611500-1&#x7f;44611600-2&#x7f;44612000-3&#x7f;44612100-4&#x7f;44612200-5&#x7f;44613000-0&#x7f;44613110-4&#x7f;44613200-2&#x7f;44613210-5&#x7f;44613300-3&#x7f;44613400-4&#x7f;44613500-5&#x7f;44613600-6&#x7f;44613700-7&#x7f;44613800-8&#x7f;44614000-7&#x7f;44614100-8&#x7f;44614300-0&#x7f;44614310-3&#x7f;44615000-4&#x7f;44615100-5&#x7f;44616000-1&#x7f;44616200-3&#x7f;44617000-8&#x7f;44617100-9&#x7f;44617200-0&#x7f;44617300-1&#x7f;44618000-5&#x7f;44618100-6&#x7f;44618300-8&#x7f;44618310-1&#x7f;44618320-4&#x7f;44618330-7&#x7f;44618340-0&#x7f;44618350-3&#x7f;44618400-9&#x7f;44618420-5&#x7f;44618500-0&#x7f;44619000-2&#x7f;44619100-3&#x7f;44619200-4&#x7f;44619300-5&#x7f;44619400-6&#x7f;44619500-7&#x7f;44620000-2&#x7f;44621000-9&#x7f;44621100-0&#x7f;44621110-3&#x7f;44621111-0&#x7f;44621112-7&#x7f;44621200-1&#x7f;44621210-4&#x7f;44621220-7&#x7f;44621221-4&#x7f;44622000-6&#x7f;44622100-7&#x7f;44800000-8&#x7f;44810000-1&#x7f;44811000-8&#x7f;44812000-5&#x7f;44812100-6&#x7f;44812200-7&#x7f;44812210-0&#x7f;44812220-3&#x7f;44812300-8&#x7f;44812310-1&#x7f;44812320-4&#x7f;44812400-9&#x7f;44820000-4&#x7f;44830000-7&#x7f;44831000-4&#x7f;44831100-5&#x7f;44831200-6&#x7f;44831300-7&#x7f;44831400-8&#x7f;44832000-1&#x7f;44832100-2&#x7f;44832200-3&#x7f;44900000-9&#x7f;44910000-2&#x7f;44911000-9&#x7f;44911100-0&#x7f;44911200-1&#x7f;44912000-6&#x7f;44912100-7&#x7f;44912200-8&#x7f;44912300-9&#x7f;44912400-0&#x7f;44920000-5&#x7f;44921000-2&#x7f;44921100-3&#x7f;44921200-4&#x7f;44921210-7&#x7f;44921300-5&#x7f;44922000-9&#x7f;44922100-0&#x7f;44922200-1&#x7f;44930000-8&#x7f;45000000-7&#x7f;45100000-8&#x7f;45110000-1&#x7f;45111000-8&#x7f;45111100-9&#x7f;45111200-0&#x7f;45111210-3&#x7f;45111211-0&#x7f;45111212-7&#x7f;45111213-4&#x7f;45111214-1&#x7f;45111220-6&#x7f;45111230-9&#x7f;45111240-2&#x7f;45111250-5&#x7f;45111260-8&#x7f;45111290-7&#x7f;45111291-4&#x7f;45111300-1&#x7f;45111310-4&#x7f;45111320-7&#x7f;45112000-5&#x7f;45112100-6&#x7f;45112200-7&#x7f;45112210-0&#x7f;45112300-8&#x7f;45112310-1&#x7f;45112320-4&#x7f;45112330-7&#x7f;45112340-0&#x7f;45112350-3&#x7f;45112360-6&#x7f;45112400-9&#x7f;45112410-2&#x7f;45112420-5&#x7f;45112440-1&#x7f;45112441-8&#x7f;45112450-4&#x7f;45112500-0&#x7f;45112600-1&#x7f;45112700-2&#x7f;45112710-5&#x7f;45112711-2&#x7f;45112712-9&#x7f;45112713-6&#x7f;45112714-3&#x7f;45112720-8&#x7f;45112721-5&#x7f;45112722-2&#x7f;45112723-9&#x7f;45112730-1&#x7f;45112740-4&#x7f;45113000-2&#x7f;45120000-4&#x7f;45121000-1&#x7f;45122000-8&#x7f;45200000-9&#x7f;45210000-2&#x7f;45211000-9&#x7f;45211100-0&#x7f;45211200-1&#x7f;45211300-2&#x7f;45211310-5&#x7f;45211320-8&#x7f;45211340-4&#x7f;45211341-1&#x7f;45211350-7&#x7f;45211360-0&#x7f;45211370-3&#x7f;45212000-6&#x7f;45212100-7&#x7f;45212110-0&#x7f;45212120-3&#x7f;45212130-6&#x7f;45212140-9&#x7f;45212150-2&#x7f;45212160-5&#x7f;45212170-8&#x7f;45212171-5&#x7f;45212172-2&#x7f;45212180-1&#x7f;45212190-4&#x7f;45212200-8&#x7f;45212210-1&#x7f;45212211-8&#x7f;45212212-5&#x7f;45212213-2&#x7f;45212220-4&#x7f;45212221-1&#x7f;45212222-8&#x7f;45212223-5&#x7f;45212224-2&#x7f;45212225-9&#x7f;45212230-7&#x7f;45212290-5&#x7f;45212300-9&#x7f;45212310-2&#x7f;45212311-9&#x7f;45212312-6&#x7f;45212313-3&#x7f;45212314-0&#x7f;45212320-5&#x7f;45212321-2&#x7f;45212322-9&#x7f;45212330-8&#x7f;45212331-5&#x7f;45212340-1&#x7f;45212350-4&#x7f;45212351-1&#x7f;45212352-8&#x7f;45212353-5&#x7f;45212354-2&#x7f;45212360-7&#x7f;45212361-4&#x7f;45212400-0&#x7f;45212410-3&#x7f;45212411-0&#x7f;45212412-7&#x7f;45212413-4&#x7f;45212420-6&#x7f;45212421-3&#x7f;45212422-0&#x7f;45212423-7&#x7f;45212500-1&#x7f;45212600-2&#x7f;45213000-3&#x7f;45213100-4&#x7f;45213110-7&#x7f;45213111-4&#x7f;45213112-1&#x7f;45213120-0&#x7f;45213130-3&#x7f;45213140-6&#x7f;45213141-3&#x7f;45213142-0&#x7f;45213150-9&#x7f;45213200-5&#x7f;45213210-8&#x7f;45213220-1&#x7f;45213221-8&#x7f;45213230-4&#x7f;45213240-7&#x7f;45213241-4&#x7f;45213242-1&#x7f;45213250-0&#x7f;45213251-7&#x7f;45213252-4&#x7f;45213260-3&#x7f;45213270-6&#x7f;45213280-9&#x7f;45213300-6&#x7f;45213310-9&#x7f;45213311-6&#x7f;45213312-3&#x7f;45213313-0&#x7f;45213314-7&#x7f;45213315-4&#x7f;45213316-1&#x7f;45213320-2&#x7f;45213321-9&#x7f;45213322-6&#x7f;45213330-5&#x7f;45213331-2&#x7f;45213332-9&#x7f;45213333-6&#x7f;45213340-8&#x7f;45213341-5&#x7f;45213342-2&#x7f;45213350-1&#x7f;45213351-8&#x7f;45213352-5&#x7f;45213353-2&#x7f;45213400-7&#x7f;45214000-0&#x7f;45214100-1&#x7f;45214200-2&#x7f;45214210-5&#x7f;45214220-8&#x7f;45214230-1&#x7f;45214300-3&#x7f;45214310-6&#x7f;45214320-9&#x7f;45214400-4&#x7f;45214410-7&#x7f;45214420-0&#x7f;45214430-3&#x7f;45214500-5&#x7f;45214600-6&#x7f;45214610-9&#x7f;45214620-2&#x7f;45214630-5&#x7f;45214631-2&#x7f;45214640-8&#x7f;45214700-7&#x7f;45214710-0&#x7f;45214800-8&#x7f;45215000-7&#x7f;45215100-8&#x7f;45215110-1&#x7f;45215120-4&#x7f;45215130-7&#x7f;45215140-0&#x7f;45215141-7&#x7f;45215142-4&#x7f;45215143-1&#x7f;45215144-8&#x7f;45215145-5&#x7f;45215146-2&#x7f;45215147-9&#x7f;45215148-6&#x7f;45215200-9&#x7f;45215210-2&#x7f;45215212-6&#x7f;45215213-3&#x7f;45215214-0&#x7f;45215215-7&#x7f;45215220-5&#x7f;45215221-2&#x7f;45215222-9&#x7f;45215300-0&#x7f;45215400-1&#x7f;45215500-2&#x7f;45216000-4&#x7f;45216100-5&#x7f;45216110-8&#x7f;45216111-5&#x7f;45216112-2&#x7f;45216113-9&#x7f;45216114-6&#x7f;45216120-1&#x7f;45216121-8&#x7f;45216122-5&#x7f;45216123-2&#x7f;45216124-9&#x7f;45216125-6&#x7f;45216126-3&#x7f;45216127-0&#x7f;45216128-7&#x7f;45216129-4&#x7f;45216200-6&#x7f;45216220-2&#x7f;45216230-5&#x7f;45216250-1&#x7f;45217000-1&#x7f;45220000-5&#x7f;45221000-2&#x7f;45221100-3&#x7f;45221110-6&#x7f;45221111-3&#x7f;45221112-0&#x7f;45221113-7&#x7f;45221114-4&#x7f;45221115-1&#x7f;45221117-5&#x7f;45221118-2&#x7f;45221119-9&#x7f;45221120-9&#x7f;45221121-6&#x7f;45221122-3&#x7f;45221200-4&#x7f;45221210-7&#x7f;45221211-4&#x7f;45221213-8&#x7f;45221214-5&#x7f;45221220-0&#x7f;45221230-3&#x7f;45221240-6&#x7f;45221241-3&#x7f;45221242-0&#x7f;45221243-7&#x7f;45221244-4&#x7f;45221245-1&#x7f;45221246-8&#x7f;45221247-5&#x7f;45221248-2&#x7f;45221250-9&#x7f;45222000-9&#x7f;45222100-0&#x7f;45222110-3&#x7f;45222200-1&#x7f;45222300-2&#x7f;45223000-6&#x7f;45223100-7&#x7f;45223110-0&#x7f;45223200-8&#x7f;45223210-1&#x7f;45223220-4&#x7f;45223300-9&#x7f;45223310-2&#x7f;45223320-5&#x7f;45223400-0&#x7f;45223500-1&#x7f;45223600-2&#x7f;45223700-3&#x7f;45223710-6&#x7f;45223720-9&#x7f;45223800-4&#x7f;45223810-7&#x7f;45223820-0&#x7f;45223821-7&#x7f;45223822-4&#x7f;45230000-8&#x7f;45231000-5&#x7f;45231100-6&#x7f;45231110-9&#x7f;45231111-6&#x7f;45231112-3&#x7f;45231113-0&#x7f;45231200-7&#x7f;45231210-0&#x7f;45231220-3&#x7f;45231221-0&#x7f;45231222-7&#x7f;45231223-4&#x7f;45231300-8&#x7f;45231400-9&#x7f;45231500-0&#x7f;45231510-3&#x7f;45231600-1&#x7f;45232000-2&#x7f;45232100-3&#x7f;45232120-9&#x7f;45232121-6&#x7f;45232130-2&#x7f;45232140-5&#x7f;45232141-2&#x7f;45232142-9&#x7f;45232150-8&#x7f;45232151-5&#x7f;45232152-2&#x7f;45232153-9&#x7f;45232154-6&#x7f;45232200-4&#x7f;45232210-7&#x7f;45232220-0&#x7f;45232221-7&#x7f;45232300-5&#x7f;45232310-8&#x7f;45232311-5&#x7f;45232320-1&#x7f;45232330-4&#x7f;45232331-1&#x7f;45232332-8&#x7f;45232340-7&#x7f;45232400-6&#x7f;45232410-9&#x7f;45232411-6&#x7f;45232420-2&#x7f;45232421-9&#x7f;45232422-6&#x7f;45232423-3&#x7f;45232424-0&#x7f;45232430-5&#x7f;45232431-2&#x7f;45232440-8&#x7f;45232450-1&#x7f;45232451-8&#x7f;45232452-5&#x7f;45232453-2&#x7f;45232454-9&#x7f;45232460-4&#x7f;45232470-7&#x7f;45233000-9&#x7f;45233100-0&#x7f;45233110-3&#x7f;45233120-6&#x7f;45233121-3&#x7f;45233122-0&#x7f;45233123-7&#x7f;45233124-4&#x7f;45233125-1&#x7f;45233126-8&#x7f;45233127-5&#x7f;45233128-2&#x7f;45233129-9&#x7f;45233130-9&#x7f;45233131-6&#x7f;45233139-3&#x7f;45233140-2&#x7f;45233141-9&#x7f;45233142-6&#x7f;45233144-0&#x7f;45233150-5&#x7f;45233160-8&#x7f;45233161-5&#x7f;45233162-2&#x7f;45233200-1&#x7f;45233210-4&#x7f;45233220-7&#x7f;45233221-4&#x7f;45233222-1&#x7f;45233223-8&#x7f;45233224-5&#x7f;45233225-2&#x7f;45233226-9&#x7f;45233227-6&#x7f;45233228-3&#x7f;45233229-0&#x7f;45233250-6&#x7f;45233251-3&#x7f;45233252-0&#x7f;45233253-7&#x7f;45233260-9&#x7f;45233261-6&#x7f;45233262-3&#x7f;45233270-2&#x7f;45233280-5&#x7f;45233290-8&#x7f;45233291-5&#x7f;45233292-2&#x7f;45233293-9&#x7f;45233294-6&#x7f;45233300-2&#x7f;45233310-5&#x7f;45233320-8&#x7f;45233330-1&#x7f;45233340-4&#x7f;45234000-6&#x7f;45234100-7&#x7f;45234110-0&#x7f;45234111-7&#x7f;45234112-4&#x7f;45234113-1&#x7f;45234114-8&#x7f;45234115-5&#x7f;45234116-2&#x7f;45234120-3&#x7f;45234121-0&#x7f;45234122-7&#x7f;45234123-4&#x7f;45234124-1&#x7f;45234125-8&#x7f;45234126-5&#x7f;45234127-2&#x7f;45234128-9&#x7f;45234129-6&#x7f;45234130-6&#x7f;45234140-9&#x7f;45234160-5&#x7f;45234170-8&#x7f;45234180-1&#x7f;45234181-8&#x7f;45234200-8&#x7f;45234210-1&#x7f;45234220-4&#x7f;45234230-7&#x7f;45234240-0&#x7f;45234250-3&#x7f;45235000-3&#x7f;45235100-4&#x7f;45235110-7&#x7f;45235111-4&#x7f;45235200-5&#x7f;45235210-8&#x7f;45235300-6&#x7f;45235310-9&#x7f;45235311-6&#x7f;45235320-2&#x7f;45236000-0&#x7f;45236100-1&#x7f;45236110-4&#x7f;45236111-1&#x7f;45236112-8&#x7f;45236113-5&#x7f;45236114-2&#x7f;45236119-7&#x7f;45236200-2&#x7f;45236210-5&#x7f;45236220-8&#x7f;45236230-1&#x7f;45236250-7&#x7f;45236290-9&#x7f;45236300-3&#x7f;45237000-7&#x7f;45240000-1&#x7f;45241000-8&#x7f;45241100-9&#x7f;45241200-0&#x7f;45241300-1&#x7f;45241400-2&#x7f;45241500-3&#x7f;45241600-4&#x7f;45242000-5&#x7f;45242100-6&#x7f;45242110-9&#x7f;45242200-7&#x7f;45242210-0&#x7f;45243000-2&#x7f;45243100-3&#x7f;45243110-6&#x7f;45243200-4&#x7f;45243300-5&#x7f;45243400-6&#x7f;45243500-7&#x7f;45243510-0&#x7f;45243600-8&#x7f;45244000-9&#x7f;45244100-0&#x7f;45244200-1&#x7f;45245000-6&#x7f;45246000-3&#x7f;45246100-4&#x7f;45246200-5&#x7f;45246400-7&#x7f;45246410-0&#x7f;45246500-8&#x7f;45246510-1&#x7f;45247000-0&#x7f;45247100-1&#x7f;45247110-4&#x7f;45247111-1&#x7f;45247112-8&#x7f;45247120-7&#x7f;45247130-0&#x7f;45247200-2&#x7f;45247210-5&#x7f;45247211-2&#x7f;45247212-9&#x7f;45247220-8&#x7f;45247230-1&#x7f;45247240-4&#x7f;45247270-3&#x7f;45248000-7&#x7f;45248100-8&#x7f;45248200-9&#x7f;45248300-0&#x7f;45248400-1&#x7f;45248500-2&#x7f;45250000-4&#x7f;45251000-1&#x7f;45251100-2&#x7f;45251110-5&#x7f;45251111-2&#x7f;45251120-8&#x7f;45251140-4&#x7f;45251141-1&#x7f;45251142-8&#x7f;45251143-5&#x7f;45251150-7&#x7f;45251160-0&#x7f;45251200-3&#x7f;45251220-9&#x7f;45251230-2&#x7f;45251240-5&#x7f;45251250-8&#x7f;45252000-8&#x7f;45252100-9&#x7f;45252110-2&#x7f;45252120-5&#x7f;45252121-2&#x7f;45252122-9&#x7f;45252123-6&#x7f;45252124-3&#x7f;45252125-0&#x7f;45252126-7&#x7f;45252127-4&#x7f;45252130-8&#x7f;45252140-1&#x7f;45252150-4&#x7f;45252200-0&#x7f;45252210-3&#x7f;45252300-1&#x7f;45253000-5&#x7f;45253100-6&#x7f;45253200-7&#x7f;45253300-8&#x7f;45253310-1&#x7f;45253320-4&#x7f;45253400-9&#x7f;45253500-0&#x7f;45253600-1&#x7f;45253700-2&#x7f;45253800-3&#x7f;45254000-2&#x7f;45254100-3&#x7f;45254110-6&#x7f;45254200-4&#x7f;45255000-9&#x7f;45255100-0&#x7f;45255110-3&#x7f;45255120-6&#x7f;45255121-3&#x7f;45255200-1&#x7f;45255210-4&#x7f;45255300-2&#x7f;45255400-3&#x7f;45255410-6&#x7f;45255420-9&#x7f;45255430-2&#x7f;45255500-4&#x7f;45255600-5&#x7f;45255700-6&#x7f;45255800-7&#x7f;45259000-7&#x7f;45259100-8&#x7f;45259200-9&#x7f;45259300-0&#x7f;45259900-6&#x7f;45260000-7&#x7f;45261000-4&#x7f;45261100-5&#x7f;45261200-6&#x7f;45261210-9&#x7f;45261211-6&#x7f;45261212-3&#x7f;45261213-0&#x7f;45261214-7&#x7f;45261215-4&#x7f;45261220-2&#x7f;45261221-9&#x7f;45261222-6&#x7f;45261300-7&#x7f;45261310-0&#x7f;45261320-3&#x7f;45261400-8&#x7f;45261410-1&#x7f;45261420-4&#x7f;45261900-3&#x7f;45261910-6&#x7f;45261920-9&#x7f;45262000-1&#x7f;45262100-2&#x7f;45262110-5&#x7f;45262120-8&#x7f;45262200-3&#x7f;45262210-6&#x7f;45262211-3&#x7f;45262212-0&#x7f;45262213-7&#x7f;45262220-9&#x7f;45262300-4&#x7f;45262310-7&#x7f;45262311-4&#x7f;45262320-0&#x7f;45262321-7&#x7f;45262330-3&#x7f;45262340-6&#x7f;45262350-9&#x7f;45262360-2&#x7f;45262370-5&#x7f;45262400-5&#x7f;45262410-8&#x7f;45262420-1&#x7f;45262421-8&#x7f;45262422-5&#x7f;45262423-2&#x7f;45262424-9&#x7f;45262425-6&#x7f;45262426-3&#x7f;45262500-6&#x7f;45262510-9&#x7f;45262511-6&#x7f;45262512-3&#x7f;45262520-2&#x7f;45262521-9&#x7f;45262522-6&#x7f;45262600-7&#x7f;45262610-0&#x7f;45262620-3&#x7f;45262630-6&#x7f;45262640-9&#x7f;45262650-2&#x7f;45262660-5&#x7f;45262670-8&#x7f;45262680-1&#x7f;45262690-4&#x7f;45262700-8&#x7f;45262710-1&#x7f;45262800-9&#x7f;45262900-0&#x7f;45300000-0&#x7f;45310000-3&#x7f;45311000-0&#x7f;45311100-1&#x7f;45311200-2&#x7f;45312000-7&#x7f;45312100-8&#x7f;45312200-9&#x7f;45312300-0&#x7f;45312310-3&#x7f;45312311-0&#x7f;45312320-6&#x7f;45312330-9&#x7f;45313000-4&#x7f;45313100-5&#x7f;45313200-6&#x7f;45313210-9&#x7f;45314000-1&#x7f;45314100-2&#x7f;45314120-8&#x7f;45314200-3&#x7f;45314300-4&#x7f;45314310-7&#x7f;45314320-0&#x7f;45315000-8&#x7f;45315100-9&#x7f;45315200-0&#x7f;45315300-1&#x7f;45315400-2&#x7f;45315500-3&#x7f;45315600-4&#x7f;45315700-5&#x7f;45316000-5&#x7f;45316100-6&#x7f;45316110-9&#x7f;45316200-7&#x7f;45316210-0&#x7f;45316211-7&#x7f;45316212-4&#x7f;45316213-1&#x7f;45316220-3&#x7f;45316230-6&#x7f;45317000-2&#x7f;45317100-3&#x7f;45317200-4&#x7f;45317300-5&#x7f;45317400-6&#x7f;45320000-6&#x7f;45321000-3&#x7f;45323000-7&#x7f;45324000-4&#x7f;45330000-9&#x7f;45331000-6&#x7f;45331100-7&#x7f;45331110-0&#x7f;45331200-8&#x7f;45331210-1&#x7f;45331211-8&#x7f;45331220-4&#x7f;45331221-1&#x7f;45331230-7&#x7f;45331231-4&#x7f;45332000-3&#x7f;45332200-5&#x7f;45332300-6&#x7f;45332400-7&#x7f;45333000-0&#x7f;45333100-1&#x7f;45333200-2&#x7f;45340000-2&#x7f;45341000-9&#x7f;45342000-6&#x7f;45343000-3&#x7f;45343100-4&#x7f;45343200-5&#x7f;45343210-8&#x7f;45343220-1&#x7f;45343230-4&#x7f;45350000-5&#x7f;45351000-2&#x7f;45400000-1&#x7f;45410000-4&#x7f;45420000-7&#x7f;45421000-4&#x7f;45421100-5&#x7f;45421110-8&#x7f;45421111-5&#x7f;45421112-2&#x7f;45421120-1&#x7f;45421130-4&#x7f;45421131-1&#x7f;45421132-8&#x7f;45421140-7&#x7f;45421141-4&#x7f;45421142-1&#x7f;45421143-8&#x7f;45421144-5&#x7f;45421145-2&#x7f;45421146-9&#x7f;45421147-6&#x7f;45421148-3&#x7f;45421150-0&#x7f;45421151-7&#x7f;45421152-4&#x7f;45421153-1&#x7f;45421160-3&#x7f;45422000-1&#x7f;45422100-2&#x7f;45430000-0&#x7f;45431000-7&#x7f;45431100-8&#x7f;45431200-9&#x7f;45432000-4&#x7f;45432100-5&#x7f;45432110-8&#x7f;45432111-5&#x7f;45432112-2&#x7f;45432113-9&#x7f;45432114-6&#x7f;45432120-1&#x7f;45432121-8&#x7f;45432130-4&#x7f;45432200-6&#x7f;45432210-9&#x7f;45432220-2&#x7f;45440000-3&#x7f;45441000-0&#x7f;45442000-7&#x7f;45442100-8&#x7f;45442110-1&#x7f;45442120-4&#x7f;45442121-1&#x7f;45442180-2&#x7f;45442190-5&#x7f;45442200-9&#x7f;45442210-2&#x7f;45442300-0&#x7f;45443000-4&#x7f;45450000-6&#x7f;45451000-3&#x7f;45451100-4&#x7f;45451200-5&#x7f;45451300-6&#x7f;45452000-0&#x7f;45452100-1&#x7f;45453000-7&#x7f;45453100-8&#x7f;45454000-4&#x7f;45454100-5&#x7f;45500000-2&#x7f;45510000-5&#x7f;45520000-8&#x7f;48000000-8&#x7f;48100000-9&#x7f;48110000-2&#x7f;48120000-5&#x7f;48121000-2&#x7f;48130000-8&#x7f;48131000-5&#x7f;48132000-2&#x7f;48140000-1&#x7f;48150000-4&#x7f;48151000-1&#x7f;48160000-7&#x7f;48161000-4&#x7f;48170000-0&#x7f;48180000-3&#x7f;48190000-6&#x7f;48200000-0&#x7f;48210000-3&#x7f;48211000-0&#x7f;48212000-7&#x7f;48213000-4&#x7f;48214000-1&#x7f;48215000-8&#x7f;48216000-5&#x7f;48217000-2&#x7f;48217100-3&#x7f;48217200-4&#x7f;48217300-5&#x7f;48218000-9&#x7f;48219000-6&#x7f;48219100-7&#x7f;48219200-8&#x7f;48219300-9&#x7f;48219400-0&#x7f;48219500-1&#x7f;48219600-2&#x7f;48219700-3&#x7f;48219800-4&#x7f;48220000-6&#x7f;48221000-3&#x7f;48222000-0&#x7f;48223000-7&#x7f;48224000-4&#x7f;48300000-1&#x7f;48310000-4&#x7f;48311000-1&#x7f;48311100-2&#x7f;48312000-8&#x7f;48313000-5&#x7f;48313100-6&#x7f;48314000-2&#x7f;48315000-9&#x7f;48316000-6&#x7f;48317000-3&#x7f;48318000-0&#x7f;48319000-7&#x7f;48320000-7&#x7f;48321000-4&#x7f;48321100-5&#x7f;48322000-1&#x7f;48323000-8&#x7f;48324000-5&#x7f;48325000-2&#x7f;48326000-9&#x7f;48326100-0&#x7f;48327000-6&#x7f;48328000-3&#x7f;48329000-0&#x7f;48330000-0&#x7f;48331000-7&#x7f;48332000-4&#x7f;48333000-1&#x7f;48400000-2&#x7f;48410000-5&#x7f;48411000-2&#x7f;48412000-9&#x7f;48420000-8&#x7f;48421000-5&#x7f;48422000-2&#x7f;48430000-1&#x7f;48440000-4&#x7f;48441000-1&#x7f;48442000-8&#x7f;48443000-5&#x7f;48444000-2&#x7f;48444100-3&#x7f;48445000-9&#x7f;48450000-7&#x7f;48451000-4&#x7f;48460000-0&#x7f;48461000-7&#x7f;48462000-4&#x7f;48463000-1&#x7f;48470000-3&#x7f;48480000-6&#x7f;48481000-3&#x7f;48482000-0&#x7f;48490000-9&#x7f;48500000-3&#x7f;48510000-6&#x7f;48511000-3&#x7f;48512000-0&#x7f;48513000-7&#x7f;48514000-4&#x7f;48515000-1&#x7f;48516000-8&#x7f;48517000-5&#x7f;48518000-2&#x7f;48519000-9&#x7f;48520000-9&#x7f;48521000-6&#x7f;48522000-3&#x7f;48600000-4&#x7f;48610000-7&#x7f;48611000-4&#x7f;48612000-1&#x7f;48613000-8&#x7f;48614000-5&#x7f;48620000-0&#x7f;48621000-7&#x7f;48622000-4&#x7f;48623000-1&#x7f;48624000-8&#x7f;48625000-5&#x7f;48626000-2&#x7f;48627000-9&#x7f;48628000-9&#x7f;48700000-5&#x7f;48710000-8&#x7f;48720000-1&#x7f;48730000-4&#x7f;48731000-1&#x7f;48732000-8&#x7f;48740000-7&#x7f;48750000-0&#x7f;48760000-3&#x7f;48761000-0&#x7f;48770000-6&#x7f;48771000-3&#x7f;48772000-0&#x7f;48773000-7&#x7f;48773100-8&#x7f;48780000-9&#x7f;48781000-6&#x7f;48782000-3&#x7f;48783000-0&#x7f;48790000-2&#x7f;48800000-6&#x7f;48810000-9&#x7f;48811000-6&#x7f;48812000-3&#x7f;48813000-0&#x7f;48813100-1&#x7f;48813200-2&#x7f;48814000-7&#x7f;48814100-8&#x7f;48814200-9&#x7f;48814300-0&#x7f;48814400-1&#x7f;48814500-2&#x7f;48820000-2&#x7f;48821000-9&#x7f;48822000-6&#x7f;48823000-3&#x7f;48824000-0&#x7f;48825000-7&#x7f;48900000-7&#x7f;48910000-0&#x7f;48911000-7&#x7f;48912000-4&#x7f;48913000-1&#x7f;48920000-3&#x7f;48921000-0&#x7f;48930000-6&#x7f;48931000-3&#x7f;48932000-0&#x7f;48940000-9&#x7f;48941000-6&#x7f;48942000-3&#x7f;48950000-2&#x7f;48951000-9&#x7f;48952000-6&#x7f;48960000-5&#x7f;48961000-2&#x7f;48962000-9&#x7f;48970000-8&#x7f;48971000-5&#x7f;48972000-2&#x7f;48980000-1&#x7f;48981000-8&#x7f;48982000-5&#x7f;48983000-2&#x7f;48984000-9&#x7f;48985000-6&#x7f;48986000-3&#x7f;48987000-0&#x7f;48990000-4&#x7f;48991000-1&#x7f;50000000-5&#x7f;50100000-6&#x7f;50110000-9&#x7f;50111000-6&#x7f;50111100-7&#x7f;50111110-0&#x7f;50112000-3&#x7f;50112100-4&#x7f;50112110-7&#x7f;50112111-4&#x7f;50112120-0&#x7f;50112200-5&#x7f;50112300-6&#x7f;50113000-0&#x7f;50113100-1&#x7f;50113200-2&#x7f;50114000-7&#x7f;50114100-8&#x7f;50114200-9&#x7f;50115000-4&#x7f;50115100-5&#x7f;50115200-6&#x7f;50116000-1&#x7f;50116100-2&#x7f;50116200-3&#x7f;50116300-4&#x7f;50116400-5&#x7f;50116500-6&#x7f;50116510-9&#x7f;50116600-7&#x7f;50117000-8&#x7f;50117100-9&#x7f;50117200-0&#x7f;50117300-1&#x7f;50118000-5&#x7f;50118100-6&#x7f;50118110-9&#x7f;50118200-7&#x7f;50118300-8&#x7f;50118400-9&#x7f;50118500-0&#x7f;50190000-3&#x7f;50200000-7&#x7f;50210000-0&#x7f;50211000-7&#x7f;50211100-8&#x7f;50211200-9&#x7f;50211210-2&#x7f;50211211-9&#x7f;50211212-6&#x7f;50211300-0&#x7f;50211310-3&#x7f;50212000-4&#x7f;50220000-3&#x7f;50221000-0&#x7f;50221100-1&#x7f;50221200-2&#x7f;50221300-3&#x7f;50221400-4&#x7f;50222000-7&#x7f;50222100-8&#x7f;50223000-4&#x7f;50224000-1&#x7f;50224100-2&#x7f;50224200-3&#x7f;50225000-8&#x7f;50229000-6&#x7f;50230000-6&#x7f;50232000-0&#x7f;50232100-1&#x7f;50232110-4&#x7f;50232200-2&#x7f;50240000-9&#x7f;50241000-6&#x7f;50241100-7&#x7f;50241200-8&#x7f;50242000-3&#x7f;50243000-0&#x7f;50244000-7&#x7f;50245000-4&#x7f;50246000-1&#x7f;50246100-2&#x7f;50246200-3&#x7f;50246300-4&#x7f;50246400-5&#x7f;50300000-8&#x7f;50310000-1&#x7f;50311000-8&#x7f;50311400-2&#x7f;50312000-5&#x7f;50312100-6&#x7f;50312110-9&#x7f;50312120-2&#x7f;50312200-7&#x7f;50312210-0&#x7f;50312220-3&#x7f;50312300-8&#x7f;50312310-1&#x7f;50312320-4&#x7f;50312400-9&#x7f;50312410-2&#x7f;50312420-5&#x7f;50312600-1&#x7f;50312610-4&#x7f;50312620-7&#x7f;50313000-2&#x7f;50313100-3&#x7f;50313200-4&#x7f;50314000-9&#x7f;50315000-6&#x7f;50316000-3&#x7f;50317000-0&#x7f;50320000-4&#x7f;50321000-1&#x7f;50322000-8&#x7f;50323000-5&#x7f;50323100-6&#x7f;50323200-7&#x7f;50324000-2&#x7f;50324100-3&#x7f;50324200-4&#x7f;50330000-7&#x7f;50331000-4&#x7f;50332000-1&#x7f;50333000-8&#x7f;50333100-9&#x7f;50333200-0&#x7f;50334000-5&#x7f;50334100-6&#x7f;50334110-9&#x7f;50334120-2&#x7f;50334130-5&#x7f;50334140-8&#x7f;50334200-7&#x7f;50334300-8&#x7f;50334400-9&#x7f;50340000-0&#x7f;50341000-7&#x7f;50341100-8&#x7f;50341200-9&#x7f;50342000-4&#x7f;50343000-1&#x7f;50344000-8&#x7f;50344100-9&#x7f;50344200-0&#x7f;50400000-9&#x7f;50410000-2&#x7f;50411000-9&#x7f;50411100-0&#x7f;50411200-1&#x7f;50411300-2&#x7f;50411400-3&#x7f;50411500-4&#x7f;50412000-6&#x7f;50413000-3&#x7f;50413100-4&#x7f;50413200-5&#x7f;50420000-5&#x7f;50421000-2&#x7f;50421100-3&#x7f;50421200-4&#x7f;50422000-9&#x7f;50430000-8&#x7f;50431000-5&#x7f;50432000-2&#x7f;50433000-9&#x7f;50500000-0&#x7f;50510000-3&#x7f;50511000-0&#x7f;50511100-1&#x7f;50511200-2&#x7f;50512000-7&#x7f;50513000-4&#x7f;50514000-1&#x7f;50514100-2&#x7f;50514200-3&#x7f;50514300-4&#x7f;50530000-9&#x7f;50531000-6&#x7f;50531100-7&#x7f;50531200-8&#x7f;50531300-9&#x7f;50531400-0&#x7f;50531500-1&#x7f;50531510-4&#x7f;50532000-3&#x7f;50532100-4&#x7f;50532200-5&#x7f;50532300-6&#x7f;50532400-7&#x7f;50600000-1&#x7f;50610000-4&#x7f;50620000-7&#x7f;50630000-0&#x7f;50640000-3&#x7f;50650000-6&#x7f;50660000-9&#x7f;50700000-2&#x7f;50710000-5&#x7f;50711000-2&#x7f;50712000-9&#x7f;50720000-8&#x7f;50721000-5&#x7f;50730000-1&#x7f;50740000-4&#x7f;50750000-7&#x7f;50760000-0&#x7f;50800000-3&#x7f;50810000-6&#x7f;50820000-9&#x7f;50821000-6&#x7f;50822000-3&#x7f;50830000-2&#x7f;50840000-5&#x7f;50841000-2&#x7f;50842000-9&#x7f;50850000-8&#x7f;50860000-1&#x7f;50870000-4&#x7f;50880000-7&#x7f;50881000-4&#x7f;50882000-1&#x7f;50883000-8&#x7f;50884000-5&#x7f;51000000-9&#x7f;51100000-3&#x7f;51110000-6&#x7f;51111000-3&#x7f;51111100-4&#x7f;51111200-5&#x7f;51111300-6&#x7f;51112000-0&#x7f;51112100-1&#x7f;51112200-2&#x7f;51120000-9&#x7f;51121000-6&#x7f;51122000-3&#x7f;51130000-2&#x7f;51131000-9&#x7f;51133000-3&#x7f;51133100-4&#x7f;51134000-0&#x7f;51135000-7&#x7f;51135100-8&#x7f;51135110-1&#x7f;51140000-5&#x7f;51141000-2&#x7f;51142000-9&#x7f;51143000-6&#x7f;51144000-3&#x7f;51145000-0&#x7f;51146000-7&#x7f;51200000-4&#x7f;51210000-7&#x7f;51211000-4&#x7f;51212000-1&#x7f;51213000-8&#x7f;51214000-5&#x7f;51215000-2&#x7f;51216000-9&#x7f;51220000-0&#x7f;51221000-7&#x7f;51230000-3&#x7f;51240000-6&#x7f;51300000-5&#x7f;51310000-8&#x7f;51311000-5&#x7f;51312000-2&#x7f;51313000-9&#x7f;51314000-6&#x7f;51320000-1&#x7f;51321000-8&#x7f;51322000-5&#x7f;51330000-4&#x7f;51340000-7&#x7f;51350000-0&#x7f;51400000-6&#x7f;51410000-9&#x7f;51411000-6&#x7f;51412000-3&#x7f;51413000-0&#x7f;51414000-7&#x7f;51415000-4&#x7f;51416000-1&#x7f;51420000-2&#x7f;51430000-5&#x7f;51500000-7&#x7f;51510000-0&#x7f;51511000-7&#x7f;51511100-8&#x7f;51511110-1&#x7f;51511200-9&#x7f;51511300-0&#x7f;51511400-1&#x7f;51514000-8&#x7f;51514100-9&#x7f;51514110-2&#x7f;51520000-3&#x7f;51521000-0&#x7f;51522000-7&#x7f;51530000-6&#x7f;51540000-9&#x7f;51541000-6&#x7f;51541100-7&#x7f;51541200-8&#x7f;51541300-9&#x7f;51541400-0&#x7f;51542000-3&#x7f;51542100-4&#x7f;51542200-5&#x7f;51542300-6&#x7f;51543000-0&#x7f;51543100-1&#x7f;51543200-2&#x7f;51543300-3&#x7f;51543400-4&#x7f;51544000-7&#x7f;51544100-8&#x7f;51544200-9&#x7f;51545000-4&#x7f;51550000-2&#x7f;51600000-8&#x7f;51610000-1&#x7f;51611000-8&#x7f;51611100-9&#x7f;51611110-2&#x7f;51611120-5&#x7f;51612000-5&#x7f;51620000-4&#x7f;51700000-9&#x7f;51800000-0&#x7f;51810000-3&#x7f;51820000-6&#x7f;51900000-1&#x7f;55000000-0&#x7f;55100000-1&#x7f;55110000-4&#x7f;55120000-7&#x7f;55130000-0&#x7f;55200000-2&#x7f;55210000-5&#x7f;55220000-8&#x7f;55221000-5&#x7f;55240000-4&#x7f;55241000-1&#x7f;55242000-8&#x7f;55243000-5&#x7f;55250000-7&#x7f;55260000-0&#x7f;55270000-3&#x7f;55300000-3&#x7f;55310000-6&#x7f;55311000-3&#x7f;55312000-0&#x7f;55320000-9&#x7f;55321000-6&#x7f;55322000-3&#x7f;55330000-2&#x7f;55400000-4&#x7f;55410000-7&#x7f;55500000-5&#x7f;55510000-8&#x7f;55511000-5&#x7f;55512000-2&#x7f;55520000-1&#x7f;55521000-8&#x7f;55521100-9&#x7f;55521200-0&#x7f;55522000-5&#x7f;55523000-2&#x7f;55523100-3&#x7f;55524000-9&#x7f;55900000-9&#x7f;60000000-8&#x7f;60100000-9&#x7f;60112000-6&#x7f;60120000-5&#x7f;60130000-8&#x7f;60140000-1&#x7f;60150000-4&#x7f;60160000-7&#x7f;60161000-4&#x7f;60170000-0&#x7f;60171000-7&#x7f;60172000-4&#x7f;60180000-3&#x7f;60181000-0&#x7f;60182000-7&#x7f;60183000-4&#x7f;60200000-0&#x7f;60210000-3&#x7f;60220000-6&#x7f;60300000-1&#x7f;60400000-2&#x7f;60410000-5&#x7f;60411000-2&#x7f;60420000-8&#x7f;60421000-5&#x7f;60423000-9&#x7f;60424000-6&#x7f;60424100-7&#x7f;60424110-0&#x7f;60424120-3&#x7f;60440000-4&#x7f;60441000-1&#x7f;60442000-8&#x7f;60443000-5&#x7f;60443100-6&#x7f;60444000-2&#x7f;60444100-3&#x7f;60445000-9&#x7f;60500000-3&#x7f;60510000-6&#x7f;60520000-9&#x7f;60600000-4&#x7f;60610000-7&#x7f;60620000-0&#x7f;60630000-3&#x7f;60640000-6&#x7f;60650000-9&#x7f;60651000-6&#x7f;60651100-7&#x7f;60651200-8&#x7f;60651300-9&#x7f;60651400-0&#x7f;60651500-1&#x7f;60651600-2&#x7f;60653000-0&#x7f;63000000-9&#x7f;63100000-0&#x7f;63110000-3&#x7f;63111000-0&#x7f;63112000-7&#x7f;63112100-8&#x7f;63112110-1&#x7f;63120000-6&#x7f;63121000-3&#x7f;63121100-4&#x7f;63121110-7&#x7f;63122000-0&#x7f;63500000-4&#x7f;63510000-7&#x7f;63511000-4&#x7f;63512000-1&#x7f;63513000-8&#x7f;63514000-5&#x7f;63515000-2&#x7f;63516000-9&#x7f;63520000-0&#x7f;63521000-7&#x7f;63522000-4&#x7f;63523000-1&#x7f;63524000-8&#x7f;63700000-6&#x7f;63710000-9&#x7f;63711000-6&#x7f;63711100-7&#x7f;63711200-8&#x7f;63712000-3&#x7f;63712100-4&#x7f;63712200-5&#x7f;63712210-8&#x7f;63712300-6&#x7f;63712310-9&#x7f;63712311-6&#x7f;63712320-2&#x7f;63712321-9&#x7f;63712400-7&#x7f;63712500-8&#x7f;63712600-9&#x7f;63712700-0&#x7f;63712710-3&#x7f;63720000-2&#x7f;63721000-9&#x7f;63721100-0&#x7f;63721200-1&#x7f;63721300-2&#x7f;63721400-3&#x7f;63721500-4&#x7f;63722000-6&#x7f;63723000-3&#x7f;63724000-0&#x7f;63724100-1&#x7f;63724110-4&#x7f;63724200-2&#x7f;63724300-3&#x7f;63724310-6&#x7f;63724400-4&#x7f;63725000-7&#x7f;63725100-8&#x7f;63725200-9&#x7f;63725300-0&#x7f;63726000-4&#x7f;63726100-5&#x7f;63726200-6&#x7f;63726300-7&#x7f;63726400-8&#x7f;63726500-9&#x7f;63726600-0&#x7f;63726610-3&#x7f;63726620-6&#x7f;63726700-1&#x7f;63726800-2&#x7f;63726900-3&#x7f;63727000-1&#x7f;63727100-2&#x7f;63727200-3&#x7f;63730000-5&#x7f;63731000-2&#x7f;63731100-3&#x7f;63732000-9&#x7f;63733000-6&#x7f;63734000-3&#x7f;64000000-6&#x7f;64100000-7&#x7f;64110000-0&#x7f;64111000-7&#x7f;64112000-4&#x7f;64113000-1&#x7f;64114000-8&#x7f;64115000-5&#x7f;64116000-2&#x7f;64120000-3&#x7f;64121000-0&#x7f;64121100-1&#x7f;64121200-2&#x7f;64122000-7&#x7f;64200000-8&#x7f;64210000-1&#x7f;64211000-8&#x7f;64211100-9&#x7f;64211200-0&#x7f;64212000-5&#x7f;64212100-6&#x7f;64212200-7&#x7f;64212300-8&#x7f;64212400-9&#x7f;64212500-0&#x7f;64212600-1&#x7f;64212700-2&#x7f;64212800-3&#x7f;64212900-4&#x7f;64213000-2&#x7f;64214000-9&#x7f;64214100-0&#x7f;64214200-1&#x7f;64214400-3&#x7f;64215000-6&#x7f;64216000-3&#x7f;64216100-4&#x7f;64216110-7&#x7f;64216120-0&#x7f;64216130-3&#x7f;64216140-6&#x7f;64216200-5&#x7f;64216210-8&#x7f;64216300-6&#x7f;64220000-4&#x7f;64221000-1&#x7f;64222000-8&#x7f;64223000-5&#x7f;64224000-2&#x7f;64225000-9&#x7f;64226000-6&#x7f;64227000-3&#x7f;64228000-0&#x7f;64228100-1&#x7f;64228200-2&#x7f;65000000-3&#x7f;65100000-4&#x7f;65110000-7&#x7f;65111000-4&#x7f;65120000-0&#x7f;65121000-7&#x7f;65122000-0&#x7f;65123000-3&#x7f;65130000-3&#x7f;65200000-5&#x7f;65210000-8&#x7f;65300000-6&#x7f;65310000-9&#x7f;65320000-2&#x7f;65400000-7&#x7f;65410000-0&#x7f;65500000-8&#x7f;66000000-0&#x7f;66100000-1&#x7f;66110000-4&#x7f;66111000-1&#x7f;66112000-8&#x7f;66113000-5&#x7f;66113100-6&#x7f;66114000-2&#x7f;66115000-9&#x7f;66120000-7&#x7f;66121000-4&#x7f;66122000-1&#x7f;66130000-0&#x7f;66131000-7&#x7f;66131100-8&#x7f;66132000-4&#x7f;66133000-1&#x7f;66140000-3&#x7f;66141000-0&#x7f;66150000-6&#x7f;66151000-3&#x7f;66151100-4&#x7f;66152000-0&#x7f;66160000-9&#x7f;66161000-6&#x7f;66162000-3&#x7f;66170000-2&#x7f;66171000-9&#x7f;66172000-6&#x7f;66180000-5&#x7f;66190000-8&#x7f;66500000-5&#x7f;66510000-8&#x7f;66511000-5&#x7f;66512000-2&#x7f;66512100-3&#x7f;66512200-4&#x7f;66512210-7&#x7f;66512220-0&#x7f;66513000-9&#x7f;66513100-0&#x7f;66513200-1&#x7f;66514000-6&#x7f;66514100-7&#x7f;66514110-0&#x7f;66514120-3&#x7f;66514130-6&#x7f;66514140-9&#x7f;66514150-2&#x7f;66514200-8&#x7f;66515000-3&#x7f;66515100-4&#x7f;66515200-5&#x7f;66515300-6&#x7f;66515400-7&#x7f;66515410-0&#x7f;66515411-7&#x7f;66516000-0&#x7f;66516100-1&#x7f;66516200-2&#x7f;66516300-3&#x7f;66516400-4&#x7f;66516500-5&#x7f;66517000-7&#x7f;66517100-8&#x7f;66517200-9&#x7f;66517300-0&#x7f;66518000-4&#x7f;66518100-5&#x7f;66518200-6&#x7f;66518300-7&#x7f;66519000-1&#x7f;66519100-2&#x7f;66519200-3&#x7f;66519300-4&#x7f;66519310-7&#x7f;66519400-5&#x7f;66519500-6&#x7f;66519600-7&#x7f;66519700-8&#x7f;66520000-1&#x7f;66521000-8&#x7f;66522000-5&#x7f;66523000-2&#x7f;66523100-3&#x7f;66600000-6&#x7f;66700000-7&#x7f;66710000-0&#x7f;66720000-3&#x7f;70000000-1&#x7f;70100000-2&#x7f;70110000-5&#x7f;70111000-2&#x7f;70112000-9&#x7f;70120000-8&#x7f;70121000-5&#x7f;70121100-6&#x7f;70121200-7&#x7f;70122000-2&#x7f;70122100-3&#x7f;70122110-6&#x7f;70122200-4&#x7f;70122210-7&#x7f;70123000-9&#x7f;70123100-0&#x7f;70123200-1&#x7f;70130000-1&#x7f;70200000-3&#x7f;70210000-6&#x7f;70220000-9&#x7f;70300000-4&#x7f;70310000-7&#x7f;70311000-4&#x7f;70320000-0&#x7f;70321000-7&#x7f;70322000-4&#x7f;70330000-3&#x7f;70331000-0&#x7f;70331100-1&#x7f;70332000-7&#x7f;70332100-8&#x7f;70332200-9&#x7f;70332300-0&#x7f;70333000-4&#x7f;70340000-6&#x7f;71000000-8&#x7f;71200000-0&#x7f;71210000-3&#x7f;71220000-6&#x7f;71221000-3&#x7f;71222000-0&#x7f;71222100-1&#x7f;71222200-2&#x7f;71223000-7&#x7f;71230000-9&#x7f;71240000-2&#x7f;71241000-9&#x7f;71242000-6&#x7f;71243000-3&#x7f;71244000-0&#x7f;71245000-7&#x7f;71246000-4&#x7f;71247000-1&#x7f;71248000-8&#x7f;71250000-5&#x7f;71251000-2&#x7f;71300000-1&#x7f;71310000-4&#x7f;71311000-1&#x7f;71311100-2&#x7f;71311200-3&#x7f;71311210-6&#x7f;71311220-9&#x7f;71311230-2&#x7f;71311240-5&#x7f;71311300-4&#x7f;71312000-8&#x7f;71313000-5&#x7f;71313100-6&#x7f;71313200-7&#x7f;71313400-9&#x7f;71313410-2&#x7f;71313420-5&#x7f;71313430-8&#x7f;71313440-1&#x7f;71313450-4&#x7f;71314000-2&#x7f;71314100-3&#x7f;71314200-4&#x7f;71314300-5&#x7f;71314310-8&#x7f;71315000-9&#x7f;71315100-0&#x7f;71315200-1&#x7f;71315210-4&#x7f;71315300-2&#x7f;71315400-3&#x7f;71315410-6&#x7f;71316000-6&#x7f;71317000-3&#x7f;71317100-4&#x7f;71317200-5&#x7f;71317210-8&#x7f;71318000-0&#x7f;71318100-1&#x7f;71319000-7&#x7f;71320000-7&#x7f;71321000-4&#x7f;71321100-5&#x7f;71321200-6&#x7f;71321300-7&#x7f;71321400-8&#x7f;71322000-1&#x7f;71322100-2&#x7f;71322200-3&#x7f;71322300-4&#x7f;71322400-5&#x7f;71322500-6&#x7f;71323000-8&#x7f;71323100-9&#x7f;71323200-0&#x7f;71324000-5&#x7f;71325000-2&#x7f;71326000-9&#x7f;71327000-6&#x7f;71328000-3&#x7f;71330000-0&#x7f;71331000-7&#x7f;71332000-4&#x7f;71333000-1&#x7f;71334000-8&#x7f;71335000-5&#x7f;71336000-2&#x7f;71337000-9&#x7f;71340000-3&#x7f;71350000-6&#x7f;71351000-3&#x7f;71351100-4&#x7f;71351200-5&#x7f;71351210-8&#x7f;71351220-1&#x7f;71351300-6&#x7f;71351400-7&#x7f;71351500-8&#x7f;71351600-9&#x7f;71351610-2&#x7f;71351611-9&#x7f;71351612-6&#x7f;71351700-0&#x7f;71351710-3&#x7f;71351720-6&#x7f;71351730-9&#x7f;71351800-1&#x7f;71351810-4&#x7f;71351811-1&#x7f;71351820-7&#x7f;71351900-2&#x7f;71351910-5&#x7f;71351911-2&#x7f;71351912-9&#x7f;71351913-6&#x7f;71351914-3&#x7f;71351920-2&#x7f;71351921-2&#x7f;71351922-2&#x7f;71351923-2&#x7f;71351924-2&#x7f;71352000-0&#x7f;71352100-1&#x7f;71352110-4&#x7f;71352120-7&#x7f;71352130-0&#x7f;71352140-3&#x7f;71352300-3&#x7f;71353000-7&#x7f;71353100-8&#x7f;71353200-9&#x7f;71354000-4&#x7f;71354100-5&#x7f;71354200-6&#x7f;71354300-7&#x7f;71354400-8&#x7f;71354500-9&#x7f;71355000-1&#x7f;71355100-2&#x7f;71355200-3&#x7f;71356000-8&#x7f;71356100-9&#x7f;71356200-0&#x7f;71356300-1&#x7f;71356400-2&#x7f;71400000-2&#x7f;71410000-5&#x7f;71420000-8&#x7f;71421000-5&#x7f;71500000-3&#x7f;71510000-6&#x7f;71520000-9&#x7f;71521000-6&#x7f;71530000-2&#x7f;71540000-5&#x7f;71541000-2&#x7f;71550000-8&#x7f;71600000-4&#x7f;71610000-7&#x7f;71620000-0&#x7f;71621000-7&#x7f;71630000-3&#x7f;71631000-0&#x7f;71631100-1&#x7f;71631200-2&#x7f;71631300-3&#x7f;71631400-4&#x7f;71631420-0&#x7f;71631430-3&#x7f;71631440-6&#x7f;71631450-9&#x7f;71631460-2&#x7f;71631470-5&#x7f;71631480-8&#x7f;71631490-1&#x7f;71632000-7&#x7f;71632100-8&#x7f;71632200-9&#x7f;71700000-5&#x7f;71730000-4&#x7f;71731000-1&#x7f;71800000-6&#x7f;71900000-7&#x7f;72000000-5&#x7f;72100000-6&#x7f;72110000-9&#x7f;72120000-2&#x7f;72130000-5&#x7f;72140000-8&#x7f;72150000-1&#x7f;72200000-7&#x7f;72210000-0&#x7f;72211000-7&#x7f;72212000-4&#x7f;72212100-0&#x7f;72212110-3&#x7f;72212120-6&#x7f;72212121-3&#x7f;72212130-9&#x7f;72212131-6&#x7f;72212132-3&#x7f;72212140-2&#x7f;72212150-5&#x7f;72212160-8&#x7f;72212170-1&#x7f;72212180-4&#x7f;72212190-7&#x7f;72212200-1&#x7f;72212210-4&#x7f;72212211-1&#x7f;72212212-8&#x7f;72212213-5&#x7f;72212214-2&#x7f;72212215-9&#x7f;72212216-6&#x7f;72212217-3&#x7f;72212218-0&#x7f;72212219-7&#x7f;72212220-7&#x7f;72212221-4&#x7f;72212222-1&#x7f;72212223-8&#x7f;72212224-5&#x7f;72212300-2&#x7f;72212310-5&#x7f;72212311-2&#x7f;72212312-9&#x7f;72212313-6&#x7f;72212314-3&#x7f;72212315-0&#x7f;72212316-7&#x7f;72212317-4&#x7f;72212318-1&#x7f;72212320-8&#x7f;72212321-5&#x7f;72212322-2&#x7f;72212323-9&#x7f;72212324-6&#x7f;72212325-3&#x7f;72212326-0&#x7f;72212327-7&#x7f;72212328-4&#x7f;72212330-1&#x7f;72212331-8&#x7f;72212332-5&#x7f;72212333-2&#x7f;72212400-3&#x7f;72212410-6&#x7f;72212411-3&#x7f;72212412-0&#x7f;72212420-9&#x7f;72212421-6&#x7f;72212422-3&#x7f;72212430-2&#x7f;72212440-5&#x7f;72212441-2&#x7f;72212442-9&#x7f;72212443-6&#x7f;72212445-0&#x7f;72212450-8&#x7f;72212451-5&#x7f;72212460-1&#x7f;72212461-8&#x7f;72212462-5&#x7f;72212463-2&#x7f;72212470-4&#x7f;72212480-7&#x7f;72212481-4&#x7f;72212482-1&#x7f;72212490-0&#x7f;72212500-4&#x7f;72212510-7&#x7f;72212511-4&#x7f;72212512-1&#x7f;72212513-8&#x7f;72212514-5&#x7f;72212515-2&#x7f;72212516-9&#x7f;72212517-6&#x7f;72212518-3&#x7f;72212519-0&#x7f;72212520-0&#x7f;72212521-7&#x7f;72212522-4&#x7f;72212600-5&#x7f;72212610-8&#x7f;72212620-1&#x7f;72212630-4&#x7f;72212640-7&#x7f;72212650-0&#x7f;72212660-3&#x7f;72212670-6&#x7f;72212700-6&#x7f;72212710-9&#x7f;72212720-2&#x7f;72212730-5&#x7f;72212731-2&#x7f;72212732-9&#x7f;72212740-8&#x7f;72212750-1&#x7f;72212760-4&#x7f;72212761-1&#x7f;72212770-7&#x7f;72212771-4&#x7f;72212772-1&#x7f;72212780-0&#x7f;72212781-7&#x7f;72212782-4&#x7f;72212783-1&#x7f;72212790-3&#x7f;72212900-8&#x7f;72212910-1&#x7f;72212911-8&#x7f;72212920-4&#x7f;72212930-7&#x7f;72212931-4&#x7f;72212932-1&#x7f;72212940-0&#x7f;72212941-7&#x7f;72212942-4&#x7f;72212960-6&#x7f;72212970-9&#x7f;72212971-6&#x7f;72212972-3&#x7f;72212980-2&#x7f;72212981-9&#x7f;72212982-6&#x7f;72212983-3&#x7f;72212984-0&#x7f;72212985-7&#x7f;72212990-5&#x7f;72212991-2&#x7f;72220000-3&#x7f;72221000-0&#x7f;72222000-7&#x7f;72222100-8&#x7f;72222200-9&#x7f;72222300-0&#x7f;72223000-4&#x7f;72224000-1&#x7f;72224100-2&#x7f;72224200-3&#x7f;72225000-8&#x7f;72226000-5&#x7f;72227000-2&#x7f;72228000-9&#x7f;72230000-6&#x7f;72231000-3&#x7f;72232000-0&#x7f;72240000-9&#x7f;72241000-6&#x7f;72242000-3&#x7f;72243000-0&#x7f;72244000-7&#x7f;72245000-4&#x7f;72246000-1&#x7f;72250000-2&#x7f;72251000-9&#x7f;72252000-6&#x7f;72253000-3&#x7f;72253100-4&#x7f;72253200-5&#x7f;72254000-0&#x7f;72254100-1&#x7f;72260000-5&#x7f;72261000-2&#x7f;72262000-9&#x7f;72263000-6&#x7f;72264000-3&#x7f;72265000-0&#x7f;72266000-7&#x7f;72267000-4&#x7f;72267100-0&#x7f;72267200-1&#x7f;72268000-1&#x7f;72300000-8&#x7f;72310000-1&#x7f;72311000-8&#x7f;72311100-9&#x7f;72311200-0&#x7f;72311300-1&#x7f;72312000-5&#x7f;72312100-6&#x7f;72312200-7&#x7f;72313000-2&#x7f;72314000-9&#x7f;72315000-6&#x7f;72315100-7&#x7f;72315200-8&#x7f;72316000-3&#x7f;72317000-0&#x7f;72318000-7&#x7f;72319000-4&#x7f;72320000-4&#x7f;72321000-1&#x7f;72322000-8&#x7f;72330000-2&#x7f;72400000-4&#x7f;72410000-7&#x7f;72411000-4&#x7f;72412000-1&#x7f;72413000-8&#x7f;72414000-5&#x7f;72415000-2&#x7f;72416000-9&#x7f;72417000-6&#x7f;72420000-0&#x7f;72421000-7&#x7f;72422000-4&#x7f;72500000-0&#x7f;72510000-3&#x7f;72511000-0&#x7f;72512000-7&#x7f;72513000-4&#x7f;72514000-1&#x7f;72514100-2&#x7f;72514200-3&#x7f;72514300-4&#x7f;72540000-2&#x7f;72541000-9&#x7f;72541100-0&#x7f;72590000-7&#x7f;72591000-4&#x7f;72600000-6&#x7f;72610000-9&#x7f;72611000-6&#x7f;72700000-7&#x7f;72710000-0&#x7f;72720000-3&#x7f;72800000-8&#x7f;72810000-1&#x7f;72820000-4&#x7f;72900000-9&#x7f;72910000-2&#x7f;72920000-5&#x7f;73000000-2&#x7f;73100000-3&#x7f;73110000-6&#x7f;73111000-3&#x7f;73112000-0&#x7f;73120000-9&#x7f;73200000-4&#x7f;73210000-7&#x7f;73220000-0&#x7f;73300000-5&#x7f;73400000-6&#x7f;73410000-9&#x7f;73420000-2&#x7f;73421000-9&#x7f;73422000-6&#x7f;73423000-3&#x7f;73424000-0&#x7f;73425000-7&#x7f;73426000-4&#x7f;73430000-5&#x7f;73431000-2&#x7f;73432000-9&#x7f;73433000-6&#x7f;73434000-3&#x7f;73435000-0&#x7f;73436000-7&#x7f;75000000-6&#x7f;75100000-7&#x7f;75110000-0&#x7f;75111000-7&#x7f;75111100-8&#x7f;75111200-9&#x7f;75112000-4&#x7f;75112100-5&#x7f;75120000-3&#x7f;75121000-0&#x7f;75122000-7&#x7f;75123000-4&#x7f;75124000-1&#x7f;75125000-8&#x7f;75130000-6&#x7f;75131000-3&#x7f;75131100-4&#x7f;75200000-8&#x7f;75210000-1&#x7f;75211000-8&#x7f;75211100-9&#x7f;75211110-2&#x7f;75211200-0&#x7f;75211300-1&#x7f;75220000-4&#x7f;75221000-1&#x7f;75222000-8&#x7f;75230000-7&#x7f;75231000-4&#x7f;75231100-5&#x7f;75231200-6&#x7f;75231210-9&#x7f;75231220-2&#x7f;75231230-5&#x7f;75231240-8&#x7f;75240000-0&#x7f;75241000-7&#x7f;75241100-8&#x7f;75242000-4&#x7f;75242100-5&#x7f;75242110-8&#x7f;75250000-3&#x7f;75251000-0&#x7f;75251100-1&#x7f;75251110-4&#x7f;75251120-7&#x7f;75252000-7&#x7f;75300000-9&#x7f;75310000-2&#x7f;75311000-9&#x7f;75312000-6&#x7f;75313000-3&#x7f;75313100-4&#x7f;75314000-0&#x7f;75320000-5&#x7f;75330000-8&#x7f;75340000-1&#x7f;76000000-3&#x7f;76100000-4&#x7f;76110000-7&#x7f;76111000-4&#x7f;76120000-0&#x7f;76121000-7&#x7f;76200000-5&#x7f;76210000-8&#x7f;76211000-5&#x7f;76211100-6&#x7f;76211110-9&#x7f;76211120-2&#x7f;76211200-7&#x7f;76300000-6&#x7f;76310000-9&#x7f;76320000-2&#x7f;76330000-5&#x7f;76331000-2&#x7f;76340000-8&#x7f;76400000-7&#x7f;76410000-0&#x7f;76411000-7&#x7f;76411100-8&#x7f;76411200-9&#x7f;76411300-0&#x7f;76411400-1&#x7f;76420000-3&#x7f;76421000-0&#x7f;76422000-7&#x7f;76423000-4&#x7f;76430000-6&#x7f;76431000-3&#x7f;76431100-4&#x7f;76431200-5&#x7f;76431300-6&#x7f;76431400-7&#x7f;76431500-8&#x7f;76431600-9&#x7f;76440000-9&#x7f;76441000-6&#x7f;76442000-3&#x7f;76443000-0&#x7f;76450000-2&#x7f;76460000-5&#x7f;76470000-8&#x7f;76471000-5&#x7f;76472000-2&#x7f;76473000-9&#x7f;76480000-1&#x7f;76490000-4&#x7f;76491000-1&#x7f;76492000-8&#x7f;76500000-8&#x7f;76510000-1&#x7f;76520000-4&#x7f;76521000-1&#x7f;76522000-8&#x7f;76530000-7&#x7f;76531000-4&#x7f;76532000-1&#x7f;76533000-8&#x7f;76534000-5&#x7f;76535000-2&#x7f;76536000-9&#x7f;76537000-6&#x7f;76537100-7&#x7f;76600000-9&#x7f;77000000-0&#x7f;77100000-1&#x7f;77110000-4&#x7f;77111000-1&#x7f;77112000-8&#x7f;77120000-7&#x7f;77200000-2&#x7f;77210000-5&#x7f;77211000-2&#x7f;77211100-3&#x7f;77211200-4&#x7f;77211300-5&#x7f;77211400-6&#x7f;77211500-7&#x7f;77211600-8&#x7f;77220000-8&#x7f;77230000-1&#x7f;77231000-8&#x7f;77231100-9&#x7f;77231200-0&#x7f;77231300-1&#x7f;77231400-2&#x7f;77231500-3&#x7f;77231600-4&#x7f;77231700-5&#x7f;77231800-6&#x7f;77231900-7&#x7f;77300000-3&#x7f;77310000-6&#x7f;77311000-3&#x7f;77312000-0&#x7f;77312100-1&#x7f;77313000-7&#x7f;77314000-4&#x7f;77314100-5&#x7f;77315000-1&#x7f;77320000-9&#x7f;77330000-2&#x7f;77340000-5&#x7f;77341000-2&#x7f;77342000-9&#x7f;77400000-4&#x7f;77500000-5&#x7f;77510000-8&#x7f;77600000-6&#x7f;77610000-9&#x7f;77700000-7&#x7f;77800000-8&#x7f;77810000-1&#x7f;77820000-4&#x7f;77830000-7&#x7f;77840000-0&#x7f;77850000-3&#x7f;77900000-9&#x7f;79000000-4&#x7f;79100000-5&#x7f;79110000-8&#x7f;79111000-5&#x7f;79112000-2&#x7f;79112100-3&#x7f;79120000-1&#x7f;79121000-8&#x7f;79121100-9&#x7f;79130000-4&#x7f;79131000-1&#x7f;79132000-8&#x7f;79132100-9&#x7f;79140000-7&#x7f;79200000-6&#x7f;79210000-9&#x7f;79211000-6&#x7f;79211100-7&#x7f;79211110-0&#x7f;79211120-3&#x7f;79211200-8&#x7f;79212000-3&#x7f;79212100-4&#x7f;79212110-7&#x7f;79212200-5&#x7f;79212300-6&#x7f;79212400-7&#x7f;79212500-8&#x7f;79220000-2&#x7f;79221000-9&#x7f;79222000-6&#x7f;79223000-3&#x7f;79300000-7&#x7f;79310000-0&#x7f;79311000-7&#x7f;79311100-8&#x7f;79311200-9&#x7f;79311210-2&#x7f;79311300-0&#x7f;79311400-1&#x7f;79311410-4&#x7f;79312000-4&#x7f;79313000-1&#x7f;79314000-8&#x7f;79315000-5&#x7f;79320000-3&#x7f;79330000-6&#x7f;79340000-9&#x7f;79341000-6&#x7f;79341100-7&#x7f;79341200-8&#x7f;79341400-0&#x7f;79341500-1&#x7f;79342000-3&#x7f;79342100-4&#x7f;79342200-5&#x7f;79342300-6&#x7f;79342310-9&#x7f;79342311-6&#x7f;79342320-2&#x7f;79342321-9&#x7f;79342400-7&#x7f;79342410-4&#x7f;79400000-8&#x7f;79410000-1&#x7f;79411000-8&#x7f;79411100-9&#x7f;79412000-5&#x7f;79413000-2&#x7f;79414000-9&#x7f;79415000-6&#x7f;79415200-8&#x7f;79416000-3&#x7f;79416100-4&#x7f;79416200-5&#x7f;79417000-0&#x7f;79418000-7&#x7f;79419000-4&#x7f;79420000-4&#x7f;79421000-1&#x7f;79421100-2&#x7f;79421200-3&#x7f;79422000-8&#x7f;79430000-7&#x7f;79500000-9&#x7f;79510000-2&#x7f;79511000-9&#x7f;79512000-6&#x7f;79520000-5&#x7f;79521000-2&#x7f;79530000-8&#x7f;79540000-1&#x7f;79550000-4&#x7f;79551000-1&#x7f;79552000-8&#x7f;79553000-5&#x7f;79560000-7&#x7f;79570000-0&#x7f;79571000-7&#x7f;79600000-0&#x7f;79610000-3&#x7f;79611000-0&#x7f;79612000-7&#x7f;79613000-4&#x7f;79620000-6&#x7f;79621000-3&#x7f;79622000-0&#x7f;79623000-7&#x7f;79624000-4&#x7f;79625000-1&#x7f;79630000-9&#x7f;79631000-6&#x7f;79632000-3&#x7f;79633000-0&#x7f;79634000-7&#x7f;79635000-4&#x7f;79700000-1&#x7f;79710000-4&#x7f;79711000-1&#x7f;79713000-5&#x7f;79714000-2&#x7f;79714100-3&#x7f;79714110-6&#x7f;79715000-9&#x7f;79716000-6&#x7f;79720000-7&#x7f;79721000-4&#x7f;79722000-1&#x7f;79723000-8&#x7f;79800000-2&#x7f;79810000-5&#x7f;79811000-2&#x7f;79812000-9&#x7f;79820000-8&#x7f;79821000-5&#x7f;79821100-6&#x7f;79822000-2&#x7f;79822100-3&#x7f;79822200-4&#x7f;79822300-5&#x7f;79822400-6&#x7f;79822500-7&#x7f;79823000-9&#x7f;79824000-6&#x7f;79900000-3&#x7f;79910000-6&#x7f;79920000-9&#x7f;79921000-6&#x7f;79930000-2&#x7f;79931000-9&#x7f;79932000-6&#x7f;79933000-3&#x7f;79934000-0&#x7f;79940000-5&#x7f;79941000-2&#x7f;79950000-8&#x7f;79951000-5&#x7f;79952000-2&#x7f;79952100-3&#x7f;79953000-9&#x7f;79954000-6&#x7f;79955000-3&#x7f;79956000-0&#x7f;79957000-7&#x7f;79960000-1&#x7f;79961000-8&#x7f;79961100-9&#x7f;79961200-0&#x7f;79961300-1&#x7f;79961310-4&#x7f;79961320-7&#x7f;79961330-0&#x7f;79961340-3&#x7f;79961350-6&#x7f;79962000-5&#x7f;79963000-2&#x7f;79970000-4&#x7f;79971000-1&#x7f;79971100-2&#x7f;79971200-3&#x7f;79972000-8&#x7f;79972100-9&#x7f;79980000-7&#x7f;79990000-0&#x7f;79991000-7&#x7f;79992000-4&#x7f;79993000-1&#x7f;79993100-2&#x7f;79994000-8&#x7f;79995000-5&#x7f;79995100-6&#x7f;79995200-7&#x7f;79996000-2&#x7f;79996100-3&#x7f;79997000-9&#x7f;79998000-6&#x7f;79999000-3&#x7f;79999100-4&#x7f;79999200-5&#x7f;80000000-4&#x7f;80100000-5&#x7f;80110000-8&#x7f;80200000-6&#x7f;80210000-9&#x7f;80211000-6&#x7f;80212000-3&#x7f;80300000-7&#x7f;80310000-0&#x7f;80320000-3&#x7f;80330000-6&#x7f;80340000-9&#x7f;80400000-8&#x7f;80410000-1&#x7f;80411000-8&#x7f;80411100-9&#x7f;80411200-0&#x7f;80412000-5&#x7f;80413000-2&#x7f;80414000-9&#x7f;80415000-6&#x7f;80420000-4&#x7f;80430000-7&#x7f;80490000-5&#x7f;80500000-9&#x7f;80510000-2&#x7f;80511000-9&#x7f;80512000-6&#x7f;80513000-3&#x7f;80520000-5&#x7f;80521000-2&#x7f;80522000-9&#x7f;80530000-8&#x7f;80531000-5&#x7f;80531100-6&#x7f;80531200-7&#x7f;80532000-2&#x7f;80533000-9&#x7f;80533100-0&#x7f;80533200-1&#x7f;80540000-1&#x7f;80550000-4&#x7f;80560000-7&#x7f;80561000-4&#x7f;80562000-1&#x7f;80570000-0&#x7f;80580000-3&#x7f;80590000-6&#x7f;80600000-0&#x7f;80610000-3&#x7f;80620000-6&#x7f;80630000-9&#x7f;80640000-2&#x7f;80650000-5&#x7f;80660000-8&#x7f;85000000-9&#x7f;85100000-0&#x7f;85110000-3&#x7f;85111000-0&#x7f;85111100-1&#x7f;85111200-2&#x7f;85111300-3&#x7f;85111310-6&#x7f;85111320-9&#x7f;85111400-4&#x7f;85111500-5&#x7f;85111600-6&#x7f;85111700-7&#x7f;85111800-8&#x7f;85111810-1&#x7f;85111820-4&#x7f;85111900-9&#x7f;85112000-7&#x7f;85112100-8&#x7f;85112200-9&#x7f;85120000-6&#x7f;85121000-3&#x7f;85121100-4&#x7f;85121200-5&#x7f;85121210-8&#x7f;85121220-1&#x7f;85121230-4&#x7f;85121231-1&#x7f;85121232-8&#x7f;85121240-7&#x7f;85121250-0&#x7f;85121251-7&#x7f;85121252-4&#x7f;85121270-6&#x7f;85121271-3&#x7f;85121280-9&#x7f;85121281-6&#x7f;85121282-3&#x7f;85121283-0&#x7f;85121290-2&#x7f;85121291-9&#x7f;85121292-6&#x7f;85121300-6&#x7f;85130000-9&#x7f;85131000-6&#x7f;85131100-7&#x7f;85131110-0&#x7f;85140000-2&#x7f;85141000-9&#x7f;85141100-0&#x7f;85141200-1&#x7f;85141210-4&#x7f;85141211-1&#x7f;85141220-7&#x7f;85142000-6&#x7f;85142100-7&#x7f;85142200-8&#x7f;85142300-9&#x7f;85142400-0&#x7f;85143000-3&#x7f;85144000-0&#x7f;85144100-1&#x7f;85145000-7&#x7f;85146000-4&#x7f;85146100-5&#x7f;85146200-6&#x7f;85147000-1&#x7f;85148000-8&#x7f;85149000-5&#x7f;85150000-5&#x7f;85160000-8&#x7f;85170000-1&#x7f;85171000-8&#x7f;85172000-5&#x7f;85200000-1&#x7f;85210000-3&#x7f;85300000-2&#x7f;85310000-5&#x7f;85311000-2&#x7f;85311100-3&#x7f;85311200-4&#x7f;85311300-5&#x7f;85312000-9&#x7f;85312100-0&#x7f;85312110-3&#x7f;85312120-6&#x7f;85312200-1&#x7f;85312300-2&#x7f;85312310-5&#x7f;85312320-8&#x7f;85312330-1&#x7f;85312400-3&#x7f;85312500-4&#x7f;85312510-7&#x7f;85320000-8&#x7f;85321000-5&#x7f;85322000-2&#x7f;85323000-9&#x7f;90000000-7&#x7f;90400000-1&#x7f;90410000-4&#x7f;90420000-7&#x7f;90430000-0&#x7f;90440000-3&#x7f;90450000-6&#x7f;90460000-9&#x7f;90470000-2&#x7f;90480000-5&#x7f;90481000-2&#x7f;90490000-8&#x7f;90491000-5&#x7f;90492000-2&#x7f;90500000-2&#x7f;90510000-5&#x7f;90511000-2&#x7f;90511100-3&#x7f;90511200-4&#x7f;90511300-5&#x7f;90511400-6&#x7f;90512000-9&#x7f;90513000-6&#x7f;90513100-7&#x7f;90513200-8&#x7f;90513300-9&#x7f;90513400-0&#x7f;90513500-1&#x7f;90513600-2&#x7f;90513700-3&#x7f;90513800-4&#x7f;90513900-5&#x7f;90514000-3&#x7f;90520000-8&#x7f;90521000-5&#x7f;90521100-6&#x7f;90521200-7&#x7f;90521300-8&#x7f;90521400-9&#x7f;90521410-2&#x7f;90521420-5&#x7f;90521500-0&#x7f;90521510-3&#x7f;90521520-6&#x7f;90522000-2&#x7f;90522100-3&#x7f;90522200-4&#x7f;90522300-5&#x7f;90522400-6&#x7f;90523000-9&#x7f;90523100-0&#x7f;90523200-1&#x7f;90523300-2&#x7f;90524000-6&#x7f;90524100-7&#x7f;90524200-8&#x7f;90524300-9&#x7f;90524400-0&#x7f;90530000-1&#x7f;90531000-8&#x7f;90532000-5&#x7f;90533000-2&#x7f;90600000-3&#x7f;90610000-6&#x7f;90611000-3&#x7f;90612000-0&#x7f;90620000-9&#x7f;90630000-2&#x7f;90640000-5&#x7f;90641000-2&#x7f;90642000-9&#x7f;90650000-8&#x7f;90660000-1&#x7f;90670000-4&#x7f;90680000-7&#x7f;90690000-0&#x7f;90700000-4&#x7f;90710000-7&#x7f;90711000-4&#x7f;90711100-5&#x7f;90711200-6&#x7f;90711300-7&#x7f;90711400-8&#x7f;90711500-9&#x7f;90712000-1&#x7f;90712100-2&#x7f;90712200-3&#x7f;90712300-4&#x7f;90712400-5&#x7f;90712500-6&#x7f;90713000-8&#x7f;90713100-9&#x7f;90714000-5&#x7f;90714100-6&#x7f;90714200-7&#x7f;90714300-8&#x7f;90714400-9&#x7f;90714500-0&#x7f;90714600-1&#x7f;90715000-2&#x7f;90715100-3&#x7f;90715110-6&#x7f;90715120-9&#x7f;90715200-4&#x7f;90715210-7&#x7f;90715220-0&#x7f;90715230-3&#x7f;90715240-6&#x7f;90715250-9&#x7f;90715260-2&#x7f;90715270-5&#x7f;90715280-8&#x7f;90720000-0&#x7f;90721000-7&#x7f;90721100-8&#x7f;90721200-9&#x7f;90721300-0&#x7f;90721400-1&#x7f;90721500-2&#x7f;90721600-3&#x7f;90721700-4&#x7f;90721800-5&#x7f;90722000-4&#x7f;90722100-5&#x7f;90722200-6&#x7f;90722300-7&#x7f;90730000-3&#x7f;90731000-0&#x7f;90731100-1&#x7f;90731200-2&#x7f;90731210-5&#x7f;90731300-3&#x7f;90731400-4&#x7f;90731500-5&#x7f;90731600-6&#x7f;90731700-7&#x7f;90731800-8&#x7f;90731900-9&#x7f;90732000-7&#x7f;90732100-8&#x7f;90732200-9&#x7f;90732300-0&#x7f;90732400-1&#x7f;90732500-2&#x7f;90732600-3&#x7f;90732700-4&#x7f;90732800-5&#x7f;90732900-6&#x7f;90732910-9&#x7f;90732920-2&#x7f;90733000-4&#x7f;90733100-5&#x7f;90733200-6&#x7f;90733300-7&#x7f;90733400-8&#x7f;90733500-9&#x7f;90733600-0&#x7f;90733700-1&#x7f;90733800-2&#x7f;90733900-3&#x7f;90740000-6&#x7f;90741000-3&#x7f;90741100-4&#x7f;90741200-5&#x7f;90741300-6&#x7f;90742000-0&#x7f;90742100-1&#x7f;90742200-2&#x7f;90742300-3&#x7f;90742400-4&#x7f;90743000-7&#x7f;90743100-8&#x7f;90743200-9&#x7f;90900000-6&#x7f;90910000-9&#x7f;90911000-6&#x7f;90911100-7&#x7f;90911200-8&#x7f;90911300-9&#x7f;90912000-3&#x7f;90913000-0&#x7f;90913100-1&#x7f;90913200-2&#x7f;90914000-7&#x7f;90915000-4&#x7f;90916000-1&#x7f;90917000-8&#x7f;90918000-5&#x7f;90919000-2&#x7f;90919100-3&#x7f;90919200-4&#x7f;90919300-5&#x7f;90920000-2&#x7f;90921000-9&#x7f;90922000-6&#x7f;90923000-3&#x7f;90924000-0&#x7f;92000000-1&#x7f;92100000-2&#x7f;92110000-5&#x7f;92111000-2&#x7f;92111100-3&#x7f;92111200-4&#x7f;92111210-7&#x7f;92111220-0&#x7f;92111230-3&#x7f;92111240-6&#x7f;92111250-9&#x7f;92111260-2&#x7f;92111300-5&#x7f;92111310-8&#x7f;92111320-1&#x7f;92112000-9&#x7f;92120000-8&#x7f;92121000-5&#x7f;92122000-2&#x7f;92130000-1&#x7f;92140000-4&#x7f;92200000-3&#x7f;92210000-6&#x7f;92211000-3&#x7f;92213000-7&#x7f;92214000-4&#x7f;92215000-1&#x7f;92216000-8&#x7f;92217000-5&#x7f;92220000-9&#x7f;92221000-6&#x7f;92222000-3&#x7f;92224000-7&#x7f;92225000-4&#x7f;92225100-7&#x7f;92226000-1&#x7f;92230000-2&#x7f;92231000-9&#x7f;92232000-6&#x7f;92300000-4&#x7f;92310000-7&#x7f;92311000-4&#x7f;92312000-1&#x7f;92312100-2&#x7f;92312110-5&#x7f;92312120-8&#x7f;92312130-1&#x7f;92312140-4&#x7f;92312200-3&#x7f;92312210-6&#x7f;92312211-3&#x7f;92312212-0&#x7f;92312213-7&#x7f;92312220-9&#x7f;92312230-2&#x7f;92312240-5&#x7f;92312250-8&#x7f;92312251-5&#x7f;92320000-0&#x7f;92330000-3&#x7f;92331000-0&#x7f;92331100-1&#x7f;92331200-2&#x7f;92331210-5&#x7f;92332000-7&#x7f;92340000-6&#x7f;92341000-3&#x7f;92342000-0&#x7f;92342100-1&#x7f;92342200-2&#x7f;92350000-9&#x7f;92351000-6&#x7f;92351100-7&#x7f;92351200-8&#x7f;92352000-3&#x7f;92352100-4&#x7f;92352200-5&#x7f;92360000-2&#x7f;92370000-5&#x7f;92400000-5&#x7f;92500000-6&#x7f;92510000-9&#x7f;92511000-6&#x7f;92512000-3&#x7f;92512100-4&#x7f;92520000-2&#x7f;92521000-9&#x7f;92521100-0&#x7f;92521200-1&#x7f;92521210-4&#x7f;92521220-7&#x7f;92522000-6&#x7f;92522100-7&#x7f;92522200-8&#x7f;92530000-5&#x7f;92531000-2&#x7f;92532000-9&#x7f;92533000-6&#x7f;92534000-3&#x7f;92600000-7&#x7f;92610000-0&#x7f;92620000-3&#x7f;92621000-0&#x7f;92622000-7&#x7f;92700000-8&#x7f;98000000-3&#x7f;98100000-4&#x7f;98110000-7&#x7f;98111000-4&#x7f;98112000-1&#x7f;98113000-8&#x7f;98113100-9&#x7f;98120000-0&#x7f;98130000-3&#x7f;98131000-0&#x7f;98132000-7&#x7f;98133000-4&#x7f;98133100-5&#x7f;98133110-8&#x7f;98200000-5&#x7f;98300000-6&#x7f;98310000-9&#x7f;98311000-6&#x7f;98311100-7&#x7f;98311200-8&#x7f;98312000-3&#x7f;98312100-4&#x7f;98313000-0&#x7f;98314000-7&#x7f;98315000-4&#x7f;98316000-1&#x7f;98320000-2&#x7f;98321000-9&#x7f;98321100-0&#x7f;98322000-6&#x7f;98322100-7&#x7f;98322110-0&#x7f;98322120-3&#x7f;98322130-6&#x7f;98322140-9&#x7f;98330000-5&#x7f;98331000-2&#x7f;98332000-9&#x7f;98333000-6&#x7f;98334000-3&#x7f;98336000-7&#x7f;98340000-8&#x7f;98341000-5&#x7f;98341100-6&#x7f;98341110-9&#x7f;98341120-2&#x7f;98341130-5&#x7f;98341140-8&#x7f;98342000-2&#x7f;98350000-1&#x7f;98351000-8&#x7f;98351100-9&#x7f;98351110-2&#x7f;98360000-4&#x7f;98361000-1&#x7f;98362000-8&#x7f;98362100-9&#x7f;98363000-5&#x7f;98370000-7&#x7f;98371000-4&#x7f;98371100-5&#x7f;98371110-8&#x7f;98371111-5&#x7f;98371120-1&#x7f;98371200-6&#x7f;98380000-0&#x7f;98390000-3&#x7f;98391000-0&#x7f;98392000-7&#x7f;98393000-4&#x7f;98394000-1&#x7f;98395000-8&#x7f;98396000-5&#x7f;98500000-8&#x7f;98510000-1&#x7f;98511000-8&#x7f;98512000-5&#x7f;98513000-2&#x7f;98513100-3&#x7f;98513200-4&#x7f;98513300-5&#x7f;98513310-8&#x7f;98514000-9&#x7f;98900000-2&#x7f;98910000-5&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAZ10]' else if (boolean(/cn:CreditNote)) then '[CAZ10]' else if (boolean(/dn:DebitNote)) then '[DAZ10]' else ''"/>
               <xsl:text/>
               <xsl:text>- Informada la utilización de la lista de Colombia Compra Eficiente, pero el código utilizado '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no existe en aquella lista </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/cbc:ID = '01']/cbc:Percent"
                 priority="1023"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;0.00&#x7f;5.00&#x7f;16.00&#x7f;19.00&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAY10]' else if (boolean(/cn:CreditNote)) then '[CAY10]' else if (boolean(/dn:DebitNote)) then '[DAY10]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Rechazo: Si reporta una tarifa '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' diferente para uno de los tributos enunciados en la tabla 5.3.9</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:TaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/cbc:ID = '04']/cbc:Percent"
                 priority="1022"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;2.00&#x7f;4.00&#x7f;8.00&#x7f;16.00&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAY10]' else if (boolean(/cn:CreditNote)) then '[CAY10]' else if (boolean(/dn:DebitNote)) then '[DAY10]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Rechazo: Si reporta una tarifa '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' diferente para uno de los tributos enunciados en la tabla 5.3.9</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/cbc:ID = '05']/cbc:Percent"
                 priority="1021"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;15.00&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAY10]' else if (boolean(/cn:CreditNote)) then '[CAY10]' else if (boolean(/dn:DebitNote)) then '[DAY10]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Rechazo: Si reporta una tarifa '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' diferente para uno de los tributos enunciados en la tabla 5.3.9</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:WithholdingTaxTotal/cac:TaxSubtotal/cac:TaxCategory[cac:TaxScheme/cbc:ID = '06']/cbc:Percent"
                 priority="1020"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;2.50&#x7f;3.50&#x7f;1.50&#x7f;1.50&#x7f;2.50&#x7f;3.50&#x7f;0.50&#x7f;0.10&#x7f;1.00&#x7f;1.00&#x7f;1.00&#x7f;2.50&#x7f;2.50&#x7f;4.00&#x7f;6.00&#x7f;4.00&#x7f;3.50&#x7f;1.00&#x7f;3.50&#x7f;3.50&#x7f;1.00&#x7f;1.00&#x7f;2.00&#x7f;2.00&#x7f;3.50&#x7f;3.50&#x7f;4.00&#x7f;3.50&#x7f;3.50&#x7f;2.50&#x7f;3.50&#x7f;11.00&#x7f;11.00&#x7f;10.00&#x7f;3.50&#x7f;7.00&#x7f;4.00&#x7f;20.00&#x7f;3.00&#x7f;2.00&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAY10]' else if (boolean(/cn:CreditNote)) then '[CAY10]' else if (boolean(/dn:DebitNote)) then '[DAY10]' else ''"/>
               <xsl:text/>
               <xsl:text>- (R) Rechazo: Si reporta una tarifa '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' diferente para uno de los tributos enunciados en la tabla 5.3.9</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:ProfileExecutionID" priority="1019" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;1&#x7f;2&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD04]' else if (boolean(/cn:CreditNote)) then '[CAD04]' else if (boolean(/dn:DebitNote)) then '[DAD04]' else ''"/>
               <xsl:text/>
               <xsl:text>- ProfileExecutionID '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no indica un valor válido para ambiente de destino del documento</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:StandardItemIdentification/cbc:ID/@schemeID"
                 priority="1018"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;001&#x7f;010&#x7f;020&#x7f;999&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAZ12]' else if (boolean(/cn:CreditNote)) then '[CAZ12]' else if (boolean(/dn:DebitNote)) then '[DAZ12]' else ''"/>
               <xsl:text/>
               <xsl:text>- Notificación si el código '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no existe en un estándar cerrado </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:InvoiceTypeCode" priority="1017" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;01&#x7f;02&#x7f;03&#x7f;91&#x7f;92&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text>[FAD12]- Código de tipo de factura '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' inválido</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Party//@schemeName" priority="1016" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;11&#x7f;12&#x7f;13&#x7f;21&#x7f;22&#x7f;31&#x7f;41&#x7f;42&#x7f;50&#x7f;91&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ25]' else if (boolean(/cn:CreditNote)) then '[CAJ25]' else if (boolean(/dn:DebitNote)) then '[DAJ25]' else ''"/>
               <xsl:text/>
               <xsl:text>- SchemeName '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no indica un valor autorizado</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:TaxRepresentativeParty/cac:PartyIdentification/cbc:ID/@schemeName"
                 priority="1015"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;11&#x7f;12&#x7f;13&#x7f;21&#x7f;22&#x7f;31&#x7f;41&#x7f;42&#x7f;50&#x7f;91&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAL06]' else if (boolean(/cn:CreditNote)) then '[CAL06]' else if (boolean(/dn:DebitNote)) then '[DAL06]' else ''"/>
               <xsl:text/>
               <xsl:text>- Tipo de documento de identidad del Autorizado a descargar documento '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' debe ser parte de la lista (Documento de identificación)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:TaxTotal//cac:TaxCategory/cac:TaxScheme/cbc:ID | cac:WithholdingTaxTotal//cac:TaxCategory/cac:TaxScheme/cbc:ID "
                 priority="1014"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;01&#x7f;02&#x7f;03&#x7f;04&#x7f;05&#x7f;06&#x7f;07&#x7f;08&#x7f;20&#x7f;21&#x7f;22&#x7f;23&#x7f;24&#x7f;25&#x7f;26&#x7f;Zy&#x7f;ZZ&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAS16]' else if (boolean(/cn:CreditNote)) then '[CAS16]' else if (boolean(/dn:DebitNote)) then '[DAS16]' else ''"/>
               <xsl:text/>
               <xsl:text>- Rechazo si el contenido de este elemento '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no corresponde a un contenido de la columna 5.2.2 </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AccountingSupplierParty//cac:TaxCategory/cac:TaxScheme/cbc:ID | cac:AccountingCustomerParty//cac:TaxCategory/cac:TaxScheme/cbc:ID | cac:DeliveryParty//cac:TaxCategory/cac:TaxScheme/cbc:ID"
                 priority="1013"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;01&#x7f;02&#x7f;03&#x7f;04&#x7f;05&#x7f;06&#x7f;07&#x7f;08&#x7f;20&#x7f;21&#x7f;22&#x7f;23&#x7f;24&#x7f;25&#x7f;26&#x7f;Zy&#x7f;ZZ&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ40]' else if (boolean(/cn:CreditNote)) then '[CAJ40]' else if (boolean(/dn:DebitNote)) then '[DAJ40]' else ''"/>
               <xsl:text/>
               <xsl:text>- TaxScheme '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no indica un valor autorizado</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="@currencyID except sts:DianExtensions//@currencyID"
                 priority="1012"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;AED&#x7f;AFN&#x7f;ALL&#x7f;AMD&#x7f;ANG&#x7f;AOA&#x7f;ARS&#x7f;AUD&#x7f;AWG&#x7f;AZN&#x7f;BAM&#x7f;BBD&#x7f;BDT&#x7f;BGN&#x7f;BHD&#x7f;BIF&#x7f;BMD&#x7f;BND&#x7f;BOB&#x7f;BOV&#x7f;BRL&#x7f;BSD&#x7f;BTN&#x7f;BWP&#x7f;BYR&#x7f;BZD&#x7f;CAD&#x7f;CDF&#x7f;CHE&#x7f;CHF&#x7f;CHW&#x7f;CLF&#x7f;CLP&#x7f;CNY&#x7f;COP&#x7f;COU&#x7f;CRC&#x7f;CUC&#x7f;CUP&#x7f;CVE&#x7f;CZK&#x7f;DJF&#x7f;DKK&#x7f;DOP&#x7f;DZD&#x7f;EGP&#x7f;ERN&#x7f;ETB&#x7f;EUR&#x7f;FJD&#x7f;FKP&#x7f;GBP&#x7f;GEL&#x7f;GHS&#x7f;GIP&#x7f;GMD&#x7f;GNF&#x7f;GTQ&#x7f;GYD&#x7f;HKD&#x7f;HNL&#x7f;HRK&#x7f;HTG&#x7f;HUF&#x7f;IDR&#x7f;ILS&#x7f;INR&#x7f;IQD&#x7f;IRR&#x7f;ISK&#x7f;JMD&#x7f;JOD&#x7f;JPY&#x7f;KES&#x7f;KGS&#x7f;KHR&#x7f;KMF&#x7f;KPW&#x7f;KRW&#x7f;KWD&#x7f;KYD&#x7f;KZT&#x7f;LAK&#x7f;LBP&#x7f;LKR&#x7f;LRD&#x7f;LSL&#x7f;LYD&#x7f;MAD&#x7f;MDL&#x7f;MGA&#x7f;MKD&#x7f;MMK&#x7f;MNT&#x7f;MOP&#x7f;MRO&#x7f;MUR&#x7f;MVR&#x7f;MWK&#x7f;MXN&#x7f;MXV&#x7f;MYR&#x7f;MZN&#x7f;NAD&#x7f;NGN&#x7f;NIO&#x7f;NOK&#x7f;NPR&#x7f;NZD&#x7f;OMR&#x7f;PAB&#x7f;PEN&#x7f;PGK&#x7f;PHP&#x7f;PKR&#x7f;PLN&#x7f;PYG&#x7f;QAR&#x7f;RON&#x7f;RSD&#x7f;RUB&#x7f;RWF&#x7f;SAR&#x7f;SBD&#x7f;SCR&#x7f;SDG&#x7f;SEK&#x7f;SGD&#x7f;SHP&#x7f;SLL&#x7f;SOS&#x7f;SRD&#x7f;SSP&#x7f;STD&#x7f;SVC&#x7f;SYP&#x7f;SZL&#x7f;THB&#x7f;TJS&#x7f;TMT&#x7f;TND&#x7f;TOP&#x7f;TRY&#x7f;TTD&#x7f;TWD&#x7f;TZS&#x7f;UAH&#x7f;UGX&#x7f;USD&#x7f;USN&#x7f;UYI&#x7f;UYU&#x7f;UZS&#x7f;VEF&#x7f;VES7&#x7f;VND&#x7f;VUV&#x7f;WST&#x7f;XAF&#x7f;XAG&#x7f;XAU&#x7f;XBA&#x7f;XBB&#x7f;XBC&#x7f;XBD&#x7f;XCD&#x7f;XDR&#x7f;XOF&#x7f;XPD&#x7f;XPF&#x7f;XPT&#x7f;XSU&#x7f;XTS&#x7f;XUA&#x7f;XXX&#x7f;YER&#x7f;ZAR&#x7f;ZMW&#x7f;ZWL&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD15]' else if (boolean(/cn:CreditNote)) then '[CAD15]' else if (boolean(/dn:DebitNote)) then '[DAD15]' else ''"/>
               <xsl:text/>
               <xsl:text>- Código de divisa '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' inválido</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:DocumentCurrencyCode" priority="1011" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;AED&#x7f;AFN&#x7f;ALL&#x7f;AMD&#x7f;ANG&#x7f;AOA&#x7f;ARS&#x7f;AUD&#x7f;AWG&#x7f;AZN&#x7f;BAM&#x7f;BBD&#x7f;BDT&#x7f;BGN&#x7f;BHD&#x7f;BIF&#x7f;BMD&#x7f;BND&#x7f;BOB&#x7f;BOV&#x7f;BRL&#x7f;BSD&#x7f;BTN&#x7f;BWP&#x7f;BYR&#x7f;BZD&#x7f;CAD&#x7f;CDF&#x7f;CHE&#x7f;CHF&#x7f;CHW&#x7f;CLF&#x7f;CLP&#x7f;CNY&#x7f;COP&#x7f;COU&#x7f;CRC&#x7f;CUC&#x7f;CUP&#x7f;CVE&#x7f;CZK&#x7f;DJF&#x7f;DKK&#x7f;DOP&#x7f;DZD&#x7f;EGP&#x7f;ERN&#x7f;ETB&#x7f;EUR&#x7f;FJD&#x7f;FKP&#x7f;GBP&#x7f;GEL&#x7f;GHS&#x7f;GIP&#x7f;GMD&#x7f;GNF&#x7f;GTQ&#x7f;GYD&#x7f;HKD&#x7f;HNL&#x7f;HRK&#x7f;HTG&#x7f;HUF&#x7f;IDR&#x7f;ILS&#x7f;INR&#x7f;IQD&#x7f;IRR&#x7f;ISK&#x7f;JMD&#x7f;JOD&#x7f;JPY&#x7f;KES&#x7f;KGS&#x7f;KHR&#x7f;KMF&#x7f;KPW&#x7f;KRW&#x7f;KWD&#x7f;KYD&#x7f;KZT&#x7f;LAK&#x7f;LBP&#x7f;LKR&#x7f;LRD&#x7f;LSL&#x7f;LYD&#x7f;MAD&#x7f;MDL&#x7f;MGA&#x7f;MKD&#x7f;MMK&#x7f;MNT&#x7f;MOP&#x7f;MRO&#x7f;MUR&#x7f;MVR&#x7f;MWK&#x7f;MXN&#x7f;MXV&#x7f;MYR&#x7f;MZN&#x7f;NAD&#x7f;NGN&#x7f;NIO&#x7f;NOK&#x7f;NPR&#x7f;NZD&#x7f;OMR&#x7f;PAB&#x7f;PEN&#x7f;PGK&#x7f;PHP&#x7f;PKR&#x7f;PLN&#x7f;PYG&#x7f;QAR&#x7f;RON&#x7f;RSD&#x7f;RUB&#x7f;RWF&#x7f;SAR&#x7f;SBD&#x7f;SCR&#x7f;SDG&#x7f;SEK&#x7f;SGD&#x7f;SHP&#x7f;SLL&#x7f;SOS&#x7f;SRD&#x7f;SSP&#x7f;STD&#x7f;SVC&#x7f;SYP&#x7f;SZL&#x7f;THB&#x7f;TJS&#x7f;TMT&#x7f;TND&#x7f;TOP&#x7f;TRY&#x7f;TTD&#x7f;TWD&#x7f;TZS&#x7f;UAH&#x7f;UGX&#x7f;USD&#x7f;USN&#x7f;UYI&#x7f;UYU&#x7f;UZS&#x7f;VEF&#x7f;VES7&#x7f;VND&#x7f;VUV&#x7f;WST&#x7f;XAF&#x7f;XAG&#x7f;XAU&#x7f;XBA&#x7f;XBB&#x7f;XBC&#x7f;XBD&#x7f;XCD&#x7f;XDR&#x7f;XOF&#x7f;XPD&#x7f;XPF&#x7f;XPT&#x7f;XSU&#x7f;XTS&#x7f;XUA&#x7f;XXX&#x7f;YER&#x7f;ZAR&#x7f;ZMW&#x7f;ZWL&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD15]' else if (boolean(/cn:CreditNote)) then '[CAD15]' else if (boolean(/dn:DebitNote)) then '[DAD15]' else ''"/>
               <xsl:text/>
               <xsl:text>- Código de divisa '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' inválido</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:SourceCurrencyCode" priority="1010" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;AED&#x7f;AFN&#x7f;ALL&#x7f;AMD&#x7f;ANG&#x7f;AOA&#x7f;ARS&#x7f;AUD&#x7f;AWG&#x7f;AZN&#x7f;BAM&#x7f;BBD&#x7f;BDT&#x7f;BGN&#x7f;BHD&#x7f;BIF&#x7f;BMD&#x7f;BND&#x7f;BOB&#x7f;BOV&#x7f;BRL&#x7f;BSD&#x7f;BTN&#x7f;BWP&#x7f;BYR&#x7f;BZD&#x7f;CAD&#x7f;CDF&#x7f;CHE&#x7f;CHF&#x7f;CHW&#x7f;CLF&#x7f;CLP&#x7f;CNY&#x7f;COP&#x7f;COU&#x7f;CRC&#x7f;CUC&#x7f;CUP&#x7f;CVE&#x7f;CZK&#x7f;DJF&#x7f;DKK&#x7f;DOP&#x7f;DZD&#x7f;EGP&#x7f;ERN&#x7f;ETB&#x7f;EUR&#x7f;FJD&#x7f;FKP&#x7f;GBP&#x7f;GEL&#x7f;GHS&#x7f;GIP&#x7f;GMD&#x7f;GNF&#x7f;GTQ&#x7f;GYD&#x7f;HKD&#x7f;HNL&#x7f;HRK&#x7f;HTG&#x7f;HUF&#x7f;IDR&#x7f;ILS&#x7f;INR&#x7f;IQD&#x7f;IRR&#x7f;ISK&#x7f;JMD&#x7f;JOD&#x7f;JPY&#x7f;KES&#x7f;KGS&#x7f;KHR&#x7f;KMF&#x7f;KPW&#x7f;KRW&#x7f;KWD&#x7f;KYD&#x7f;KZT&#x7f;LAK&#x7f;LBP&#x7f;LKR&#x7f;LRD&#x7f;LSL&#x7f;LYD&#x7f;MAD&#x7f;MDL&#x7f;MGA&#x7f;MKD&#x7f;MMK&#x7f;MNT&#x7f;MOP&#x7f;MRO&#x7f;MUR&#x7f;MVR&#x7f;MWK&#x7f;MXN&#x7f;MXV&#x7f;MYR&#x7f;MZN&#x7f;NAD&#x7f;NGN&#x7f;NIO&#x7f;NOK&#x7f;NPR&#x7f;NZD&#x7f;OMR&#x7f;PAB&#x7f;PEN&#x7f;PGK&#x7f;PHP&#x7f;PKR&#x7f;PLN&#x7f;PYG&#x7f;QAR&#x7f;RON&#x7f;RSD&#x7f;RUB&#x7f;RWF&#x7f;SAR&#x7f;SBD&#x7f;SCR&#x7f;SDG&#x7f;SEK&#x7f;SGD&#x7f;SHP&#x7f;SLL&#x7f;SOS&#x7f;SRD&#x7f;SSP&#x7f;STD&#x7f;SVC&#x7f;SYP&#x7f;SZL&#x7f;THB&#x7f;TJS&#x7f;TMT&#x7f;TND&#x7f;TOP&#x7f;TRY&#x7f;TTD&#x7f;TWD&#x7f;TZS&#x7f;UAH&#x7f;UGX&#x7f;USD&#x7f;USN&#x7f;UYI&#x7f;UYU&#x7f;UZS&#x7f;VEF&#x7f;VES7&#x7f;VND&#x7f;VUV&#x7f;WST&#x7f;XAF&#x7f;XAG&#x7f;XAU&#x7f;XBA&#x7f;XBB&#x7f;XBC&#x7f;XBD&#x7f;XCD&#x7f;XDR&#x7f;XOF&#x7f;XPD&#x7f;XPF&#x7f;XPT&#x7f;XSU&#x7f;XTS&#x7f;XUA&#x7f;XXX&#x7f;YER&#x7f;ZAR&#x7f;ZMW&#x7f;ZWL&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAR02]' else if (boolean(/cn:CreditNote)) then '[CAR02]' else if (boolean(/dn:DebitNote)) then '[DAR02]' else ''"/>
               <xsl:text/>
               <xsl:text>- Código de divisa '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' inválido</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:TargetCurrencyCode" priority="1009" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;AED&#x7f;AFN&#x7f;ALL&#x7f;AMD&#x7f;ANG&#x7f;AOA&#x7f;ARS&#x7f;AUD&#x7f;AWG&#x7f;AZN&#x7f;BAM&#x7f;BBD&#x7f;BDT&#x7f;BGN&#x7f;BHD&#x7f;BIF&#x7f;BMD&#x7f;BND&#x7f;BOB&#x7f;BOV&#x7f;BRL&#x7f;BSD&#x7f;BTN&#x7f;BWP&#x7f;BYR&#x7f;BZD&#x7f;CAD&#x7f;CDF&#x7f;CHE&#x7f;CHF&#x7f;CHW&#x7f;CLF&#x7f;CLP&#x7f;CNY&#x7f;COP&#x7f;COU&#x7f;CRC&#x7f;CUC&#x7f;CUP&#x7f;CVE&#x7f;CZK&#x7f;DJF&#x7f;DKK&#x7f;DOP&#x7f;DZD&#x7f;EGP&#x7f;ERN&#x7f;ETB&#x7f;EUR&#x7f;FJD&#x7f;FKP&#x7f;GBP&#x7f;GEL&#x7f;GHS&#x7f;GIP&#x7f;GMD&#x7f;GNF&#x7f;GTQ&#x7f;GYD&#x7f;HKD&#x7f;HNL&#x7f;HRK&#x7f;HTG&#x7f;HUF&#x7f;IDR&#x7f;ILS&#x7f;INR&#x7f;IQD&#x7f;IRR&#x7f;ISK&#x7f;JMD&#x7f;JOD&#x7f;JPY&#x7f;KES&#x7f;KGS&#x7f;KHR&#x7f;KMF&#x7f;KPW&#x7f;KRW&#x7f;KWD&#x7f;KYD&#x7f;KZT&#x7f;LAK&#x7f;LBP&#x7f;LKR&#x7f;LRD&#x7f;LSL&#x7f;LYD&#x7f;MAD&#x7f;MDL&#x7f;MGA&#x7f;MKD&#x7f;MMK&#x7f;MNT&#x7f;MOP&#x7f;MRO&#x7f;MUR&#x7f;MVR&#x7f;MWK&#x7f;MXN&#x7f;MXV&#x7f;MYR&#x7f;MZN&#x7f;NAD&#x7f;NGN&#x7f;NIO&#x7f;NOK&#x7f;NPR&#x7f;NZD&#x7f;OMR&#x7f;PAB&#x7f;PEN&#x7f;PGK&#x7f;PHP&#x7f;PKR&#x7f;PLN&#x7f;PYG&#x7f;QAR&#x7f;RON&#x7f;RSD&#x7f;RUB&#x7f;RWF&#x7f;SAR&#x7f;SBD&#x7f;SCR&#x7f;SDG&#x7f;SEK&#x7f;SGD&#x7f;SHP&#x7f;SLL&#x7f;SOS&#x7f;SRD&#x7f;SSP&#x7f;STD&#x7f;SVC&#x7f;SYP&#x7f;SZL&#x7f;THB&#x7f;TJS&#x7f;TMT&#x7f;TND&#x7f;TOP&#x7f;TRY&#x7f;TTD&#x7f;TWD&#x7f;TZS&#x7f;UAH&#x7f;UGX&#x7f;USD&#x7f;USN&#x7f;UYI&#x7f;UYU&#x7f;UZS&#x7f;VEF&#x7f;VES7&#x7f;VND&#x7f;VUV&#x7f;WST&#x7f;XAF&#x7f;XAG&#x7f;XAU&#x7f;XBA&#x7f;XBB&#x7f;XBC&#x7f;XBD&#x7f;XCD&#x7f;XDR&#x7f;XOF&#x7f;XPD&#x7f;XPF&#x7f;XPT&#x7f;XSU&#x7f;XTS&#x7f;XUA&#x7f;XXX&#x7f;YER&#x7f;ZAR&#x7f;ZMW&#x7f;ZWL&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAR04]' else if (boolean(/cn:CreditNote)) then '[CAR04]' else if (boolean(/dn:DebitNote)) then '[DAR04]' else ''"/>
               <xsl:text/>
               <xsl:text>- Código de divisa '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' inválido</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:CustomizationID" priority="1008" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;01&#x7f;02&#x7f;03&#x7f;04&#x7f;05&#x7f;06&#x7f;07&#x7f;08&#x7f;09&#x7f;10&#x7f;11&#x7f;12&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAD02]' else if (boolean(/cn:CreditNote)) then '[CAD02]' else if (boolean(/dn:DebitNote)) then '[DAD02]' else ''"/>
               <xsl:text/>
               <xsl:text>- CustomizationID '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no indica un valor válido para el tipo de operación</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AccountingSupplierParty/cbc:AdditionalAccountID"
                 priority="1007"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;1&#x7f;2&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ02]' else if (boolean(/cn:CreditNote)) then '[CAJ02]' else if (boolean(/dn:DebitNote)) then '[DAJ02]' else ''"/>
               <xsl:text/>
               <xsl:text>- Emisor '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' debe ser persona física o jurídica (AccountingSupplierParty)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:AccountingCustomerParty/cbc:AdditionalAccountID"
                 priority="1006"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;1&#x7f;2&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAK02]' else if (boolean(/cn:CreditNote)) then '[CAK02]' else if (boolean(/dn:DebitNote)) then '[DAK02]' else ''"/>
               <xsl:text/>
               <xsl:text>- Receptor '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' debe ser persona física o jurídica (AccountingCustomerParty)</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Party//cbc:TaxLevelCode/@listName | //cac:DeliveryParty//cbc:TaxLevelCode/@listName"
                 priority="1005"
                 mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;04&#x7f;05&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ27]' else if (boolean(/cn:CreditNote)) then '[CAJ27]' else if (boolean(/dn:DebitNote)) then '[DAJ27]' else ''"/>
               <xsl:text/>
               <xsl:text>- TaxLevelCode '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no indica un valor autorizado</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cac:Party//cbc:TaxLevelCode | //cac:DeliveryParty//cbc:TaxLevelCode"
                 priority="1004"
                 mode="M22">
      <xsl:variable name="a" select="tokenize(translate(normalize-space(.),' ',''),';')"/>
      <xsl:variable name="b"
                    select="every $i in  $a satisfies ( false() or ( contains('&#x7f;O-06&#x7f;O-07&#x7f;O-08&#x7f;O-09&#x7f;O-11&#x7f;O-12&#x7f;O-13&#x7f;O-14&#x7f;O-15&#x7f;O-16&#x7f;O-17&#x7f;O-19&#x7f;O-22&#x7f;O-23&#x7f;O-32&#x7f;O-33&#x7f;O-34&#x7f;O-36&#x7f;O-37&#x7f;O-38&#x7f;O-39&#x7f;O-99&#x7f;R-00-PN&#x7f;R-12-PN&#x7f;R-16-PN&#x7f;R-25-PN&#x7f;R-99-PN&#x7f;R-06-PJ&#x7f;R-07-PJ&#x7f;R-12-PJ&#x7f;R-16-PJ&#x7f;R-99-PJ&#x7f;A-01&#x7f;A-02&#x7f;A-03&#x7f;A-04&#x7f;A-05&#x7f;A-06&#x7f;A-07&#x7f;A-08&#x7f;A-09&#x7f;A-10&#x7f;A-11&#x7f;A-12&#x7f;A-13&#x7f;A-14&#x7f;A-15&#x7f;A-16&#x7f;A-17&#x7f;A-18&#x7f;A-19&#x7f;A-20&#x7f;A-21&#x7f;A-22&#x7f;A-23&#x7f;A-24&#x7f;A-25&#x7f;A-26&#x7f;A-27&#x7f;A-28&#x7f;A-29&#x7f;A-30&#x7f;A-32&#x7f;A-34&#x7f;A-36&#x7f;A-37&#x7f;A-38&#x7f;A-39&#x7f;A-40&#x7f;A-41&#x7f;A-42&#x7f;A-43&#x7f;A-44&#x7f;A-46&#x7f;A-47&#x7f;A-48&#x7f;A-49&#x7f;A-50&#x7f;A-53&#x7f;A-54&#x7f;A-55&#x7f;A-56&#x7f;A-57&#x7f;A-58&#x7f;A-60&#x7f;A-61&#x7f;A-62&#x7f;A-63&#x7f;A-64&#x7f;A-99&#x7f;E-01&#x7f;E-02&#x7f;E-03&#x7f;E-04&#x7f;E-05&#x7f;E-06&#x7f;E-07&#x7f;E-08&#x7f;E-09&#x7f;E-10&#x7f;E-11&#x7f;E-12&#x7f;E-13&#x7f;E-14&#x7f;E-15&#x7f;E-16&#x7f;E-17&#x7f;E-18&#x7f;E-19&#x7f;E-20&#x7f;E-21&#x7f;E-22&#x7f;E-99&#x7f;',concat('&#x7f;',$i,'&#x7f;')) ) )"/>
      <xsl:variable name="c"
                    select="if (not($b)) then for $j in $a return$j[not(contains('&#x7f;O-06&#x7f;O-07&#x7f;O-08&#x7f;O-09&#x7f;O-11&#x7f;O-12&#x7f;O-13&#x7f;O-14&#x7f;O-15&#x7f;O-16&#x7f;O-17&#x7f;O-19&#x7f;O-22&#x7f;O-23&#x7f;O-32&#x7f;O-33&#x7f;O-34&#x7f;O-36&#x7f;O-37&#x7f;O-38&#x7f;O-39&#x7f;O-99&#x7f;R-00-PN&#x7f;R-12-PN&#x7f;R-16-PN&#x7f;R-25-PN&#x7f;R-99-PN&#x7f;R-06-PJ&#x7f;R-07-PJ&#x7f;R-12-PJ&#x7f;R-16-PJ&#x7f;R-99-PJ&#x7f;A-01&#x7f;A-02&#x7f;A-03&#x7f;A-04&#x7f;A-05&#x7f;A-06&#x7f;A-07&#x7f;A-08&#x7f;A-09&#x7f;A-10&#x7f;A-11&#x7f;A-12&#x7f;A-13&#x7f;A-14&#x7f;A-15&#x7f;A-16&#x7f;A-17&#x7f;A-18&#x7f;A-19&#x7f;A-20&#x7f;A-21&#x7f;A-22&#x7f;A-23&#x7f;A-24&#x7f;A-25&#x7f;A-26&#x7f;A-27&#x7f;A-28&#x7f;A-29&#x7f;A-30&#x7f;A-32&#x7f;A-34&#x7f;A-36&#x7f;A-37&#x7f;A-38&#x7f;A-39&#x7f;A-40&#x7f;A-41&#x7f;A-42&#x7f;A-43&#x7f;A-44&#x7f;A-46&#x7f;A-47&#x7f;A-48&#x7f;A-49&#x7f;A-50&#x7f;A-53&#x7f;A-54&#x7f;A-55&#x7f;A-56&#x7f;A-57&#x7f;A-58&#x7f;A-60&#x7f;A-61&#x7f;A-62&#x7f;A-63&#x7f;A-64&#x7f;A-99&#x7f;E-01&#x7f;E-02&#x7f;E-03&#x7f;E-04&#x7f;E-05&#x7f;E-06&#x7f;E-07&#x7f;E-08&#x7f;E-09&#x7f;E-10&#x7f;E-11&#x7f;E-12&#x7f;E-13&#x7f;E-14&#x7f;E-15&#x7f;E-16&#x7f;E-17&#x7f;E-18&#x7f;E-19&#x7f;E-20&#x7f;E-21&#x7f;E-22&#x7f;E-99&#x7f;',concat('&#x7f;',$j,'&#x7f;')))]else 'true'"/>

		    <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="every $i in tokenize(translate(normalize-space(.),' ',''),';') satisfies (false() or (contains('&#x7f;O-06&#x7f;O-07&#x7f;O-08&#x7f;O-09&#x7f;O-11&#x7f;O-12&#x7f;O-13&#x7f;O-14&#x7f;O-15&#x7f;O-16&#x7f;O-17&#x7f;O-19&#x7f;O-22&#x7f;O-23&#x7f;O-32&#x7f;O-33&#x7f;O-34&#x7f;O-36&#x7f;O-37&#x7f;O-38&#x7f;O-39&#x7f;O-99&#x7f;R-00-PN&#x7f;R-12-PN&#x7f;R-16-PN&#x7f;R-25-PN&#x7f;R-99-PN&#x7f;R-06-PJ&#x7f;R-07-PJ&#x7f;R-12-PJ&#x7f;R-16-PJ&#x7f;R-99-PJ&#x7f;A-01&#x7f;A-02&#x7f;A-03&#x7f;A-04&#x7f;A-05&#x7f;A-06&#x7f;A-07&#x7f;A-08&#x7f;A-09&#x7f;A-10&#x7f;A-11&#x7f;A-12&#x7f;A-13&#x7f;A-14&#x7f;A-15&#x7f;A-16&#x7f;A-17&#x7f;A-18&#x7f;A-19&#x7f;A-20&#x7f;A-21&#x7f;A-22&#x7f;A-23&#x7f;A-24&#x7f;A-25&#x7f;A-26&#x7f;A-27&#x7f;A-28&#x7f;A-29&#x7f;A-30&#x7f;A-32&#x7f;A-34&#x7f;A-36&#x7f;A-37&#x7f;A-38&#x7f;A-39&#x7f;A-40&#x7f;A-41&#x7f;A-42&#x7f;A-43&#x7f;A-44&#x7f;A-46&#x7f;A-47&#x7f;A-48&#x7f;A-49&#x7f;A-50&#x7f;A-53&#x7f;A-54&#x7f;A-55&#x7f;A-56&#x7f;A-57&#x7f;A-58&#x7f;A-60&#x7f;A-61&#x7f;A-62&#x7f;A-63&#x7f;A-64&#x7f;A-99&#x7f;E-01&#x7f;E-02&#x7f;E-03&#x7f;E-04&#x7f;E-05&#x7f;E-06&#x7f;E-07&#x7f;E-08&#x7f;E-09&#x7f;E-10&#x7f;E-11&#x7f;E-12&#x7f;E-13&#x7f;E-14&#x7f;E-15&#x7f;E-16&#x7f;E-17&#x7f;E-18&#x7f;E-19&#x7f;E-20&#x7f;E-21&#x7f;E-22&#x7f;E-99&#x7f;',concat('&#x7f;',$i,'&#x7f;'))))"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ26]' else if (boolean(/cn:CreditNote)) then '[CAJ26]' else if (boolean(/dn:DebitNote)) then '[DAJ26]' else ''"/>
               <xsl:text/>
               <xsl:text>- TaxLevelCode '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="for $i in $c return concat($i,' |')"/>
               <xsl:text/>
               <xsl:text>' no indica un valor autorizado</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="@unitCode" priority="1003" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;04&#x7f;05&#x7f;08&#x7f;10&#x7f;11&#x7f;13&#x7f;14&#x7f;15&#x7f;16&#x7f;17&#x7f;18&#x7f;19&#x7f;20&#x7f;21&#x7f;22&#x7f;23&#x7f;24&#x7f;25&#x7f;26&#x7f;27&#x7f;28&#x7f;29&#x7f;30&#x7f;31&#x7f;32&#x7f;33&#x7f;34&#x7f;35&#x7f;36&#x7f;37&#x7f;38&#x7f;40&#x7f;41&#x7f;43&#x7f;44&#x7f;45&#x7f;46&#x7f;47&#x7f;48&#x7f;53&#x7f;54&#x7f;56&#x7f;57&#x7f;58&#x7f;59&#x7f;60&#x7f;61&#x7f;62&#x7f;63&#x7f;64&#x7f;66&#x7f;69&#x7f;71&#x7f;72&#x7f;73&#x7f;74&#x7f;76&#x7f;77&#x7f;78&#x7f;80&#x7f;81&#x7f;84&#x7f;85&#x7f;87&#x7f;89&#x7f;90&#x7f;91&#x7f;92&#x7f;93&#x7f;94&#x7f;95&#x7f;96&#x7f;97&#x7f;98&#x7f;1ª&#x7f;1B&#x7f;1C&#x7f;1D&#x7f;1E&#x7f;1F&#x7f;1G&#x7f;1H&#x7f;1I&#x7f;1J&#x7f;1K&#x7f;1L&#x7f;1M&#x7f;1X&#x7f;2ª&#x7f;2B&#x7f;2C&#x7f;2I&#x7f;2J&#x7f;2K&#x7f;2L&#x7f;2M&#x7f;2N&#x7f;2P&#x7f;2Q&#x7f;2R&#x7f;2U&#x7f;2V&#x7f;2W&#x7f;2X&#x7f;2Y&#x7f;2Z&#x7f;3B&#x7f;3C&#x7f;3E&#x7f;3G&#x7f;3H&#x7f;3I&#x7f;4ª&#x7f;4B&#x7f;4C&#x7f;4E&#x7f;4G&#x7f;4H&#x7f;4K&#x7f;4L&#x7f;4M&#x7f;4N&#x7f;4º&#x7f;4P&#x7f;4Q&#x7f;4R&#x7f;4T&#x7f;4U&#x7f;4W&#x7f;4X&#x7f;5ª&#x7f;5B&#x7f;5C&#x7f;5E&#x7f;5F&#x7f;5G&#x7f;5H&#x7f;5I&#x7f;5J&#x7f;5K&#x7f;5P&#x7f;5Q&#x7f;A1&#x7f;A10&#x7f;A11&#x7f;A12&#x7f;A13&#x7f;A14&#x7f;A15&#x7f;A16&#x7f;A17&#x7f;A18&#x7f;A19&#x7f;A2&#x7f;A20&#x7f;A21&#x7f;A22&#x7f;A23&#x7f;A24&#x7f;A25&#x7f;A26&#x7f;A27&#x7f;A28&#x7f;A29&#x7f;A3&#x7f;A30&#x7f;A31&#x7f;A32&#x7f;A33&#x7f;A34&#x7f;A35&#x7f;A36&#x7f;A37&#x7f;A38&#x7f;A39&#x7f;A4&#x7f;A40&#x7f;A41&#x7f;A42&#x7f;A43&#x7f;A44&#x7f;A45&#x7f;A47&#x7f;A48&#x7f;A49&#x7f;A5&#x7f;A50&#x7f;A51&#x7f;A52&#x7f;A53&#x7f;A54&#x7f;A55&#x7f;A56&#x7f;A57&#x7f;A58&#x7f;A6&#x7f;A60&#x7f;A61&#x7f;A62&#x7f;A63&#x7f;A64&#x7f;A65&#x7f;A66&#x7f;A67&#x7f;A68&#x7f;A69&#x7f;A7&#x7f;A70&#x7f;A71&#x7f;A73&#x7f;A74&#x7f;A75&#x7f;A76&#x7f;A77&#x7f;A78&#x7f;A79&#x7f;A8&#x7f;A80&#x7f;A81&#x7f;A82&#x7f;A83&#x7f;A84&#x7f;A85&#x7f;A86&#x7f;A87&#x7f;A88&#x7f;A89&#x7f;A9&#x7f;A90&#x7f;A91&#x7f;A93&#x7f;A94&#x7f;A95&#x7f;A96&#x7f;A97&#x7f;A98&#x7f;AA&#x7f;AB&#x7f;ACR&#x7f;AD&#x7f;AE&#x7f;AH&#x7f;AI&#x7f;AJ&#x7f;AK&#x7f;AL&#x7f;AM&#x7f;AMH&#x7f;AMP&#x7f;ANA&#x7f;AP&#x7f;APZ&#x7f;AQ&#x7f;AR&#x7f;SON&#x7f;COMO&#x7f;ASM&#x7f;ASU&#x7f;ATM&#x7f;ATT&#x7f;AV&#x7f;AW&#x7f;SÍ&#x7f;AZ&#x7f;B0&#x7f;B1&#x7f;B11&#x7f;B12&#x7f;B13&#x7f;B14&#x7f;B15&#x7f;B16&#x7f;B18&#x7f;B2&#x7f;B20&#x7f;B21&#x7f;B22&#x7f;B23&#x7f;B24&#x7f;B25&#x7f;B26&#x7f;B27&#x7f;B28&#x7f;B29&#x7f;B3&#x7f;B31&#x7f;B32&#x7f;B33&#x7f;B34&#x7f;B35&#x7f;B36&#x7f;B37&#x7f;B38&#x7f;B39&#x7f;B4&#x7f;B40&#x7f;B41&#x7f;B42&#x7f;B43&#x7f;B44&#x7f;B45&#x7f;B46&#x7f;B47&#x7f;B48&#x7f;B49&#x7f;B5&#x7f;B50&#x7f;B51&#x7f;B52&#x7f;B53&#x7f;B54&#x7f;B55&#x7f;B56&#x7f;B57&#x7f;B58&#x7f;B59&#x7f;B6&#x7f;B60&#x7f;B61&#x7f;B62&#x7f;B63&#x7f;B64&#x7f;B65&#x7f;B66&#x7f;B67&#x7f;B69&#x7f;B7&#x7f;B70&#x7f;B71&#x7f;B72&#x7f;B73&#x7f;B74&#x7f;B75&#x7f;B76&#x7f;B77&#x7f;B78&#x7f;B79&#x7f;B8&#x7f;B81&#x7f;B83&#x7f;B84&#x7f;B85&#x7f;B86&#x7f;B87&#x7f;B88&#x7f;B89&#x7f;B9&#x7f;B90&#x7f;B91&#x7f;B92&#x7f;B93&#x7f;B94&#x7f;B95&#x7f;B96&#x7f;B97&#x7f;B98&#x7f;B99&#x7f;BAR&#x7f;BB&#x7f;BD&#x7f;SER&#x7f;BFT&#x7f;BG&#x7f;BH&#x7f;BHP&#x7f;BIL&#x7f;BJ&#x7f;BK&#x7f;BL&#x7f;BLD&#x7f;BLL&#x7f;BO&#x7f;BP&#x7f;BQL&#x7f;BR&#x7f;BT&#x7f;BTU&#x7f;BUA&#x7f;BUI&#x7f;BW&#x7f;BX&#x7f;BZ&#x7f;C0&#x7f;C1&#x7f;C10&#x7f;C11&#x7f;C12&#x7f;C13&#x7f;C14&#x7f;C15&#x7f;C16&#x7f;C17&#x7f;C18&#x7f;C19&#x7f;C2&#x7f;C20&#x7f;C22&#x7f;C23&#x7f;C24&#x7f;C25&#x7f;C26&#x7f;C27&#x7f;C28&#x7f;C29&#x7f;C3&#x7f;C30&#x7f;C31&#x7f;C32&#x7f;C33&#x7f;C34&#x7f;C35&#x7f;C36&#x7f;C38&#x7f;C39&#x7f;C4&#x7f;C40&#x7f;C41&#x7f;C42&#x7f;C43&#x7f;C44&#x7f;C45&#x7f;C46&#x7f;C47&#x7f;C48&#x7f;C49&#x7f;C5&#x7f;C50&#x7f;C51&#x7f;C52&#x7f;C53&#x7f;C54&#x7f;C55&#x7f;C56&#x7f;C57&#x7f;C58&#x7f;C59&#x7f;C6&#x7f;C60&#x7f;C61&#x7f;C62&#x7f;C63&#x7f;C64&#x7f;C65&#x7f;C66&#x7f;C67&#x7f;C68&#x7f;C69&#x7f;C7&#x7f;C70&#x7f;C71&#x7f;C72&#x7f;C73&#x7f;C75&#x7f;C76&#x7f;C77&#x7f;C78&#x7f;C8&#x7f;C80&#x7f;C81&#x7f;C82&#x7f;C83&#x7f;C84&#x7f;C85&#x7f;C86&#x7f;C87&#x7f;C88&#x7f;C89&#x7f;C9&#x7f;C90&#x7f;C91&#x7f;C92&#x7f;C93&#x7f;C94&#x7f;C95&#x7f;C96&#x7f;C97&#x7f;C98&#x7f;C99&#x7f;CA&#x7f;CCT&#x7f;CDL&#x7f;CEL&#x7f;CEN&#x7f;CG&#x7f;CGM&#x7f;CH&#x7f;CJ&#x7f;CK&#x7f;CKG&#x7f;CL&#x7f;CLF&#x7f;CLT&#x7f;CMK&#x7f;CMQ&#x7f;CMT&#x7f;CNP&#x7f;CNT&#x7f;CO&#x7f;COU&#x7f;CQ&#x7f;CR&#x7f;CS&#x7f;CT&#x7f;CTM&#x7f;CU&#x7f;CUR&#x7f;CV&#x7f;CWA&#x7f;CWI&#x7f;CY&#x7f;CZ&#x7f;D1&#x7f;D10&#x7f;D12&#x7f;D13&#x7f;D14&#x7f;D15&#x7f;D16&#x7f;D17&#x7f;D18&#x7f;D19&#x7f;D2&#x7f;D20&#x7f;D21&#x7f;D22&#x7f;D23&#x7f;D24&#x7f;D25&#x7f;D26&#x7f;D27&#x7f;D28&#x7f;D29&#x7f;D30&#x7f;D31&#x7f;D32&#x7f;D33&#x7f;D34&#x7f;D35&#x7f;D37&#x7f;D38&#x7f;D39&#x7f;D40&#x7f;D41&#x7f;D42&#x7f;D43&#x7f;D44&#x7f;D45&#x7f;D46&#x7f;D47&#x7f;D48&#x7f;D49&#x7f;D5&#x7f;D50&#x7f;D51&#x7f;D52&#x7f;D53&#x7f;D54&#x7f;D55&#x7f;D56&#x7f;D57&#x7f;D58&#x7f;D59&#x7f;D6&#x7f;D60&#x7f;D61&#x7f;D62&#x7f;D63&#x7f;D64&#x7f;D65&#x7f;D66&#x7f;D67&#x7f;D69&#x7f;D7&#x7f;D70&#x7f;D71&#x7f;D72&#x7f;D73&#x7f;D74&#x7f;D75&#x7f;D76&#x7f;D77&#x7f;D79&#x7f;D8&#x7f;D80&#x7f;D81&#x7f;D82&#x7f;D83&#x7f;D85&#x7f;D86&#x7f;D87&#x7f;D88&#x7f;D89&#x7f;D9&#x7f;D90&#x7f;D91&#x7f;D92&#x7f;D93&#x7f;D94&#x7f;D95&#x7f;D96&#x7f;D97&#x7f;D98&#x7f;D99&#x7f;DAA&#x7f;DAD&#x7f;DAY&#x7f;DB&#x7f;DC&#x7f;DD&#x7f;DE&#x7f;DEC&#x7f;DG&#x7f;DI&#x7f;DJ&#x7f;DLT&#x7f;DMK&#x7f;DMQ&#x7f;DMT&#x7f;DN&#x7f;DPC&#x7f;DPR&#x7f;DPT&#x7f;DQ&#x7f;DR&#x7f;DRA&#x7f;DRI&#x7f;DRL&#x7f;DRM&#x7f;DS&#x7f;DT&#x7f;DTN&#x7f;DU&#x7f;DWT&#x7f;DX&#x7f;DY&#x7f;DZN&#x7f;DZP&#x7f;E2&#x7f;E3&#x7f;E4&#x7f;E5&#x7f;EA&#x7f;EB&#x7f;CE&#x7f;EP&#x7f;EQ&#x7f;EV&#x7f;F1&#x7f;F9&#x7f;FAH&#x7f;FAR&#x7f;FB&#x7f;FC&#x7f;FD&#x7f;FE&#x7f;FF&#x7f;FG&#x7f;FH&#x7f;FL&#x7f;FM&#x7f;FOT&#x7f;FP&#x7f;FR&#x7f;FS&#x7f;FTK&#x7f;FTQ&#x7f;G2&#x7f;G3&#x7f;G7&#x7f;GB&#x7f;GBQ&#x7f;GC&#x7f;GD&#x7f;GE&#x7f;GF&#x7f;GFI&#x7f;GGR&#x7f;GH&#x7f;GIA&#x7f;GII&#x7f;GJ&#x7f;GK&#x7f;GL&#x7f;GLD&#x7f;GLI&#x7f;GLL&#x7f;GM&#x7f;GN&#x7f;GO&#x7f;GP&#x7f;GQ&#x7f;GRM&#x7f;GRN&#x7f;GRO&#x7f;GRT&#x7f;GT&#x7f;GV&#x7f;GW&#x7f;GWH&#x7f;GY&#x7f;GZ&#x7f;H1&#x7f;H2&#x7f;HA&#x7f;HAR&#x7f;HBA&#x7f;HBX&#x7f;HC&#x7f;HD&#x7f;ÉL&#x7f;HF&#x7f;HGM&#x7f;HH&#x7f;HI&#x7f;HIU&#x7f;HJ&#x7f;HK&#x7f;HL&#x7f;HLT&#x7f;HM&#x7f;HMQ&#x7f;HMT&#x7f;HN&#x7f;HO&#x7f;HP&#x7f;HPA&#x7f;HS&#x7f;HT&#x7f;HTZ&#x7f;HUR&#x7f;HY&#x7f;IA&#x7f;IC&#x7f;IE&#x7f;IF&#x7f;II&#x7f;IL&#x7f;IM&#x7f;INH&#x7f;INK&#x7f;INQ&#x7f;IP&#x7f;IT&#x7f;IU&#x7f;IV&#x7f;J2&#x7f;JB&#x7f;JE&#x7f;JG&#x7f;JK&#x7f;JM&#x7f;JO&#x7f;JOU&#x7f;JR&#x7f;K1&#x7f;K2&#x7f;K3&#x7f;K5&#x7f;K6&#x7f;KA&#x7f;KB&#x7f;KBA&#x7f;KD&#x7f;KEL&#x7f;KF&#x7f;KG&#x7f;KGM&#x7f;KGS&#x7f;KHZ&#x7f;KI&#x7f;KJ&#x7f;KJO&#x7f;KL&#x7f;KMH&#x7f;KMK&#x7f;KMQ&#x7f;KNI&#x7f;KNS&#x7f;KNT&#x7f;KO&#x7f;KPA&#x7f;KPH&#x7f;KPO&#x7f;KPP&#x7f;KR&#x7f;KS&#x7f;KSD&#x7f;KSH&#x7f;KT&#x7f;KTM&#x7f;KTN&#x7f;KUR&#x7f;KVA&#x7f;KVR&#x7f;KVT&#x7f;KW&#x7f;KWH&#x7f;KWT&#x7f;KX&#x7f;L2&#x7f;LA&#x7f;LBR&#x7f;LBT&#x7f;LC&#x7f;LD&#x7f;LE&#x7f;LEF&#x7f;LF&#x7f;LH&#x7f;LI&#x7f;LJ&#x7f;LK&#x7f;LM&#x7f;LN&#x7f;LO&#x7f;LP&#x7f;LPA&#x7f;LR&#x7f;LS&#x7f;LTN&#x7f;LTR&#x7f;LUM&#x7f;LUX&#x7f;LX&#x7f;LY&#x7f;M0&#x7f;M1&#x7f;M4&#x7f;M5&#x7f;M7&#x7f;M9&#x7f;MA&#x7f;MAL&#x7f;MAM&#x7f;MAW&#x7f;MBE&#x7f;MBF&#x7f;MBR&#x7f;MC&#x7f;MCU&#x7f;MD&#x7f;MF&#x7f;MGM&#x7f;MGM&#x7f;MIK&#x7f;MIL&#x7f;MIN&#x7f;MIO&#x7f;MIU&#x7f;MK&#x7f;MLD&#x7f;MLT&#x7f;MMK&#x7f;MMQ&#x7f;MMT&#x7f;LUN&#x7f;MPA&#x7f;MQ&#x7f;MQH&#x7f;MQS&#x7f;MSK&#x7f;MT&#x7f;MTK&#x7f;MTQ&#x7f;MTR&#x7f;MTS&#x7f;MV&#x7f;MVA&#x7f;MWH&#x7f;N1&#x7f;N2&#x7f;N3&#x7f;NA&#x7f;NAR&#x7f;NB&#x7f;NBB&#x7f;NC&#x7f;NCL&#x7f;ND&#x7f;NE&#x7f;NEW&#x7f;NF&#x7f;NG&#x7f;NH&#x7f;NI&#x7f;NIU&#x7f;NJ&#x7f;NL&#x7f;MNI&#x7f;NMP&#x7f;NN&#x7f;NPL&#x7f;NPR&#x7f;TNP&#x7f;NQ&#x7f;NR&#x7f;NRL&#x7f;NT&#x7f;NTT&#x7f;NU&#x7f;NV&#x7f;NX&#x7f;NY&#x7f;OA&#x7f;OHM&#x7f;EN&#x7f;ONZ&#x7f;OP&#x7f;OT&#x7f;ONZ&#x7f;OZA&#x7f;OZI&#x7f;P0&#x7f;P1&#x7f;P2&#x7f;P3&#x7f;P4&#x7f;P5&#x7f;P6&#x7f;P7&#x7f;P8&#x7f;P9&#x7f;PA&#x7f;PAL&#x7f;PB&#x7f;PD&#x7f;PE&#x7f;PF&#x7f;PG&#x7f;PGL&#x7f;Pi&#x7f;PK&#x7f;PL&#x7f;PM&#x7f;PN&#x7f;PO&#x7f;PQ&#x7f;PR&#x7f;PD&#x7f;PT&#x7f;PTD&#x7f;PTI&#x7f;PTL&#x7f;PU&#x7f;PV&#x7f;PW&#x7f;PY&#x7f;PZ&#x7f;Q3&#x7f;QA&#x7f;QAN&#x7f;QB&#x7f;QD&#x7f;QH&#x7f;QK&#x7f;QR&#x7f;QT&#x7f;QTD&#x7f;QTI&#x7f;QTL&#x7f;QTR&#x7f;R1&#x7f;R4&#x7f;R9&#x7f;RA&#x7f;RD&#x7f;RG&#x7f;RH&#x7f;RK&#x7f;RL&#x7f;RM&#x7f;RN&#x7f;RO&#x7f;RP&#x7f;RPM&#x7f;RPS&#x7f;RS&#x7f;RT&#x7f;RU&#x7f;S3&#x7f;S4&#x7f;S5&#x7f;S6&#x7f;S7&#x7f;S8&#x7f;SA&#x7f;SAN&#x7f;OCS&#x7f;SCR&#x7f;SD&#x7f;SE&#x7f;SEC&#x7f;SET&#x7f;SG&#x7f;SHT&#x7f;SIE&#x7f;SK&#x7f;SL&#x7f;SMI&#x7f;SN&#x7f;SO&#x7f;SP&#x7f;SQ&#x7f;SR&#x7f;SS&#x7f;SST&#x7f;ST&#x7f;ITS&#x7f;STN&#x7f;SV&#x7f;SO&#x7f;SX&#x7f;T0&#x7f;T1&#x7f;T3&#x7f;T4&#x7f;T5&#x7f;T6&#x7f;T7&#x7f;T8&#x7f;TA&#x7f;TAH&#x7f;TC&#x7f;TD&#x7f;TE&#x7f;TF&#x7f;TI&#x7f;TJ&#x7f;TK&#x7f;TL&#x7f;TN&#x7f;TNE&#x7f;TP&#x7f;TPR&#x7f;TQ&#x7f;TQD&#x7f;TR&#x7f;TRL&#x7f;TS&#x7f;TSD&#x7f;TSH&#x7f;TT&#x7f;TU&#x7f;TV&#x7f;TW&#x7f;TY&#x7f;U1&#x7f;U2&#x7f;UA&#x7f;UB&#x7f;UC&#x7f;UD&#x7f;UE&#x7f;UF&#x7f;UH&#x7f;UM&#x7f;VA&#x7f;VI&#x7f;VLT&#x7f;VQ&#x7f;VS&#x7f;W2&#x7f;W4&#x7f;WA&#x7f;WB&#x7f;WCD&#x7f;WE&#x7f;WEB&#x7f;WEE&#x7f;WG&#x7f;WH&#x7f;WHR&#x7f;WI&#x7f;WM&#x7f;WR&#x7f;WSD&#x7f;WTT&#x7f;WW&#x7f;X1&#x7f;YDK&#x7f;YDQ&#x7f;YL&#x7f;YRD&#x7f;YT&#x7f;Z1&#x7f;Z2&#x7f;Z3&#x7f;Z4&#x7f;Z5&#x7f;Z6&#x7f;Z8&#x7f;ZP&#x7f;ZZ&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Warning:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAV05]' else if (boolean(/cn:CreditNote)) then '[CAV05]' else if (boolean(/dn:DebitNote)) then '[DAV05]' else ''"/>
               <xsl:text/>
               <xsl:text>- Unidad de medida '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' inválida</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:PostalZone" priority="1002" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;913057&#x7f;915010&#x7f;911018&#x7f;913050&#x7f;915019&#x7f;914050&#x7f;917010&#x7f;911039&#x7f;911037&#x7f;911017&#x7f;916017&#x7f;915017&#x7f;912010&#x7f;915018&#x7f;913017&#x7f;911038&#x7f;917017&#x7f;912019&#x7f;913019&#x7f;916057&#x7f;912018&#x7f;913010&#x7f;914057&#x7f;911010&#x7f;910001&#x7f;911030&#x7f;910007&#x7f;916058&#x7f;913018&#x7f;910008&#x7f;917018&#x7f;912017&#x7f;054018&#x7f;055030&#x7f;051437&#x7f;050032&#x7f;057067&#x7f;051430&#x7f;056040&#x7f;056417&#x7f;054438&#x7f;051037&#x7f;055068&#x7f;056847&#x7f;055020&#x7f;053838&#x7f;055840&#x7f;052050&#x7f;057040&#x7f;054848&#x7f;057030&#x7f;051448&#x7f;051030&#x7f;057050&#x7f;054828&#x7f;053467&#x7f;057457&#x7f;056438&#x7f;057857&#x7f;057837&#x7f;050040&#x7f;055057&#x7f;056860&#x7f;051417&#x7f;051860&#x7f;052850&#x7f;057028&#x7f;053830&#x7f;057458&#x7f;053010&#x7f;056470&#x7f;051857&#x7f;057440&#x7f;054057&#x7f;053420&#x7f;055837&#x7f;052848&#x7f;055050&#x7f;051020&#x7f;054038&#x7f;051427&#x7f;056838&#x7f;051054&#x7f;054428&#x7f;056027&#x7f;054058&#x7f;054817&#x7f;052810&#x7f;051038&#x7f;056850&#x7f;055430&#x7f;056427&#x7f;056837&#x7f;055440&#x7f;055867&#x7f;056818&#x7f;057840&#x7f;055027&#x7f;052448&#x7f;052079&#x7f;053820&#x7f;054030&#x7f;053020&#x7f;057068&#x7f;055420&#x7f;053017&#x7f;057420&#x7f;056820&#x7f;055038&#x7f;057017&#x7f;057829&#x7f;053857&#x7f;054838&#x7f;057868&#x7f;054020&#x7f;051410&#x7f;051058&#x7f;057020&#x7f;055070&#x7f;053810&#x7f;057447&#x7f;050015&#x7f;051858&#x7f;053457&#x7f;051028&#x7f;052060&#x7f;053817&#x7f;053048&#x7f;050004&#x7f;051868&#x7f;053028&#x7f;054448&#x7f;050006&#x7f;050043&#x7f;054827&#x7f;051070&#x7f;053447&#x7f;053410&#x7f;053428&#x7f;051460&#x7f;050016&#x7f;057010&#x7f;053440&#x7f;050024&#x7f;052447&#x7f;055077&#x7f;057467&#x7f;057438&#x7f;052030&#x7f;055438&#x7f;054010&#x7f;053430&#x7f;050036&#x7f;057427&#x7f;052020&#x7f;050021&#x7f;055427&#x7f;051450&#x7f;051447&#x7f;055827&#x7f;057820&#x7f;052847&#x7f;050012&#x7f;057418&#x7f;050010&#x7f;054050&#x7f;055460&#x7f;057817&#x7f;053050&#x7f;054048&#x7f;053427&#x7f;054017&#x7f;052857&#x7f;054410&#x7f;051837&#x7f;051027&#x7f;056017&#x7f;052018&#x7f;055848&#x7f;056817&#x7f;055422&#x7f;056467&#x7f;055421&#x7f;050007&#x7f;051847&#x7f;055858&#x7f;056447&#x7f;052428&#x7f;052017&#x7f;055018&#x7f;050041&#x7f;055010&#x7f;052438&#x7f;050029&#x7f;057827&#x7f;056830&#x7f;051059&#x7f;055450&#x7f;056037&#x7f;054028&#x7f;051838&#x7f;050023&#x7f;051850&#x7f;057839&#x7f;055457&#x7f;053450&#x7f;056440&#x7f;050037&#x7f;051830&#x7f;055847&#x7f;050033&#x7f;055860&#x7f;054440&#x7f;053037&#x7f;055817&#x7f;050013&#x7f;054430&#x7f;054847&#x7f;056430&#x7f;057018&#x7f;057878&#x7f;057858&#x7f;055411&#x7f;050020&#x7f;056477&#x7f;055048&#x7f;057037&#x7f;052837&#x7f;050031&#x7f;050048&#x7f;050018&#x7f;052068&#x7f;057460&#x7f;055040&#x7f;056468&#x7f;056840&#x7f;051818&#x7f;052458&#x7f;050047&#x7f;050044&#x7f;052437&#x7f;052067&#x7f;050022&#x7f;052418&#x7f;050014&#x7f;050030&#x7f;053417&#x7f;051468&#x7f;055017&#x7f;053418&#x7f;053460&#x7f;051052&#x7f;056867&#x7f;052037&#x7f;052077&#x7f;050001&#x7f;050025&#x7f;056047&#x7f;053040&#x7f;056810&#x7f;056010&#x7f;051817&#x7f;052047&#x7f;056420&#x7f;051810&#x7f;052468&#x7f;052427&#x7f;050017&#x7f;052818&#x7f;051820&#x7f;057847&#x7f;052820&#x7f;057038&#x7f;050011&#x7f;052038&#x7f;054450&#x7f;055818&#x7f;055410&#x7f;054040&#x7f;057060&#x7f;051057&#x7f;057410&#x7f;056460&#x7f;056410&#x7f;057417&#x7f;052027&#x7f;054447&#x7f;055437&#x7f;057450&#x7f;053047&#x7f;056828&#x7f;054417&#x7f;051053&#x7f;057828&#x7f;053837&#x7f;053437&#x7f;057877&#x7f;051048&#x7f;056077&#x7f;056858&#x7f;057437&#x7f;057428&#x7f;051827&#x7f;055067&#x7f;053847&#x7f;052450&#x7f;051051&#x7f;050005&#x7f;052010&#x7f;057860&#x7f;050026&#x7f;053027&#x7f;057841&#x7f;053827&#x7f;054840&#x7f;052827&#x7f;055028&#x7f;054810&#x7f;057869&#x7f;056067&#x7f;055820&#x7f;055078&#x7f;057058&#x7f;056020&#x7f;056057&#x7f;052460&#x7f;055037&#x7f;052828&#x7f;052817&#x7f;056478&#x7f;050034&#x7f;052070&#x7f;054047&#x7f;052467&#x7f;052417&#x7f;054027&#x7f;050002&#x7f;052840&#x7f;055467&#x7f;052440&#x7f;054427&#x7f;052420&#x7f;057870&#x7f;055413&#x7f;051420&#x7f;055417&#x7f;056030&#x7f;055810&#x7f;057047&#x7f;051840&#x7f;055468&#x7f;055857&#x7f;057850&#x7f;056068&#x7f;055850&#x7f;052040&#x7f;054837&#x7f;050027&#x7f;054457&#x7f;050028&#x7f;056857&#x7f;057430&#x7f;052057&#x7f;053840&#x7f;054437&#x7f;051467&#x7f;051867&#x7f;050042&#x7f;055830&#x7f;051047&#x7f;055060&#x7f;053850&#x7f;050003&#x7f;051010&#x7f;056457&#x7f;055047&#x7f;055447&#x7f;056060&#x7f;057027&#x7f;051050&#x7f;053030&#x7f;056827&#x7f;056028&#x7f;057838&#x7f;057810&#x7f;051017&#x7f;055448&#x7f;053448&#x7f;055412&#x7f;054820&#x7f;052457&#x7f;055058&#x7f;056050&#x7f;052430&#x7f;056450&#x7f;056868&#x7f;056070&#x7f;052410&#x7f;057830&#x7f;052078&#x7f;054037&#x7f;050035&#x7f;054830&#x7f;052830&#x7f;054420&#x7f;054829&#x7f;051457&#x7f;057057&#x7f;054818&#x7f;051077&#x7f;051440&#x7f;055428&#x7f;057867&#x7f;053057&#x7f;056437&#x7f;051040&#x7f;814057&#x7f;815017&#x7f;816018&#x7f;810009&#x7f;813017&#x7f;813010&#x7f;814050&#x7f;814017&#x7f;814010&#x7f;812017&#x7f;812010&#x7f;816017&#x7f;816019&#x7f;810008&#x7f;812019&#x7f;810001&#x7f;815010&#x7f;816010&#x7f;814058&#x7f;810007&#x7f;814018&#x7f;812018&#x7f;813018&#x7f;815018&#x7f;880007&#x7f;880001&#x7f;880028&#x7f;880008&#x7f;880027&#x7f;880020&#x7f;082020&#x7f;081007&#x7f;080006&#x7f;083027&#x7f;084047&#x7f;080011&#x7f;082040&#x7f;081028&#x7f;085001&#x7f;080016&#x7f;081001&#x7f;082001&#x7f;084040&#x7f;082007&#x7f;085040&#x7f;082027&#x7f;081047&#x7f;082047&#x7f;085047&#x7f;084067&#x7f;081040&#x7f;080010&#x7f;083080&#x7f;084001&#x7f;081027&#x7f;080004&#x7f;083020&#x7f;085067&#x7f;085060&#x7f;083087&#x7f;085020&#x7f;085027&#x7f;080001&#x7f;085007&#x7f;084060&#x7f;085048&#x7f;084027&#x7f;083005&#x7f;084087&#x7f;082067&#x7f;083040&#x7f;084008&#x7f;080012&#x7f;085068&#x7f;085008&#x7f;080020&#x7f;081020&#x7f;080002&#x7f;080015&#x7f;083060&#x7f;083003&#x7f;083010&#x7f;083001&#x7f;084080&#x7f;083004&#x7f;083021&#x7f;085009&#x7f;081067&#x7f;081048&#x7f;081008&#x7f;083007&#x7f;083047&#x7f;081060&#x7f;084007&#x7f;080005&#x7f;080003&#x7f;080007&#x7f;083067&#x7f;083002&#x7f;080013&#x7f;083028&#x7f;084020&#x7f;082060&#x7f;080014&#x7f;083006&#x7f;082028&#x7f;111321&#x7f;110231&#x7f;110931&#x7f;110511&#x7f;110841&#x7f;111161&#x7f;111221&#x7f;111961&#x7f;110911&#x7f;111121&#x7f;110721&#x7f;110441&#x7f;110551&#x7f;110561&#x7f;111151&#x7f;110871&#x7f;111821&#x7f;111041&#x7f;111621&#x7f;111971&#x7f;111941&#x7f;110311&#x7f;111156&#x7f;111176&#x7f;110111&#x7f;111631&#x7f;110151&#x7f;112021&#x7f;112031&#x7f;111131&#x7f;111611&#x7f;110571&#x7f;110421&#x7f;110921&#x7f;110221&#x7f;110741&#x7f;111911&#x7f;111311&#x7f;111011&#x7f;112011&#x7f;110881&#x7f;111061&#x7f;111921&#x7f;111031&#x7f;111021&#x7f;110431&#x7f;110731&#x7f;111811&#x7f;112041&#x7f;111711&#x7f;110411&#x7f;111511&#x7f;110121&#x7f;110811&#x7f;110531&#x7f;111051&#x7f;111951&#x7f;111831&#x7f;111211&#x7f;110851&#x7f;111411&#x7f;111111&#x7f;111071&#x7f;111171&#x7f;110861&#x7f;110611&#x7f;110711&#x7f;111166&#x7f;110541&#x7f;110821&#x7f;110131&#x7f;111981&#x7f;111931&#x7f;110621&#x7f;111141&#x7f;111841&#x7f;110521&#x7f;110321&#x7f;110831&#x7f;110211&#x7f;110141&#x7f;131077&#x7f;130015&#x7f;132527&#x7f;134077&#x7f;134040&#x7f;131547&#x7f;131040&#x7f;132047&#x7f;131028&#x7f;132057&#x7f;135027&#x7f;130011&#x7f;130510&#x7f;133040&#x7f;130528&#x7f;133537&#x7f;134070&#x7f;133049&#x7f;132040&#x7f;130008&#x7f;134517&#x7f;130002&#x7f;134501&#x7f;132511&#x7f;131067&#x7f;133028&#x7f;132519&#x7f;130027&#x7f;130014&#x7f;131540&#x7f;133007&#x7f;134068&#x7f;131029&#x7f;134027&#x7f;132547&#x7f;134527&#x7f;133567&#x7f;130012&#x7f;130013&#x7f;130018&#x7f;130019&#x7f;131520&#x7f;130527&#x7f;132557&#x7f;134047&#x7f;132567&#x7f;133518&#x7f;130530&#x7f;132050&#x7f;131068&#x7f;131069&#x7f;132560&#x7f;130009&#x7f;130547&#x7f;135008&#x7f;132030&#x7f;132058&#x7f;135007&#x7f;134510&#x7f;131020&#x7f;133510&#x7f;133550&#x7f;130017&#x7f;135028&#x7f;134020&#x7f;135048&#x7f;131507&#x7f;135040&#x7f;134048&#x7f;134548&#x7f;133538&#x7f;134547&#x7f;132059&#x7f;130501&#x7f;133530&#x7f;133020&#x7f;132540&#x7f;133047&#x7f;132548&#x7f;130540&#x7f;131548&#x7f;130001&#x7f;130007&#x7f;135060&#x7f;135067&#x7f;132518&#x7f;134008&#x7f;132001&#x7f;131017&#x7f;131007&#x7f;131527&#x7f;132501&#x7f;130517&#x7f;132018&#x7f;131501&#x7f;131027&#x7f;131010&#x7f;130005&#x7f;131567&#x7f;130003&#x7f;133508&#x7f;132507&#x7f;134067&#x7f;131008&#x7f;134060&#x7f;134001&#x7f;135020&#x7f;135047&#x7f;131001&#x7f;133507&#x7f;133558&#x7f;133557&#x7f;132037&#x7f;130537&#x7f;130507&#x7f;134028&#x7f;134520&#x7f;132512&#x7f;134507&#x7f;133501&#x7f;133027&#x7f;132550&#x7f;132007&#x7f;132517&#x7f;130508&#x7f;133001&#x7f;130006&#x7f;133048&#x7f;133560&#x7f;132568&#x7f;132017&#x7f;131560&#x7f;134007&#x7f;131048&#x7f;133517&#x7f;132010&#x7f;132508&#x7f;130520&#x7f;133008&#x7f;130004&#x7f;131047&#x7f;135001&#x7f;131060&#x7f;130010&#x7f;134540&#x7f;153420&#x7f;151007&#x7f;151407&#x7f;153880&#x7f;155218&#x7f;152429&#x7f;153207&#x7f;152001&#x7f;151201&#x7f;150617&#x7f;151287&#x7f;154407&#x7f;153667&#x7f;153287&#x7f;153450&#x7f;155047&#x7f;154827&#x7f;150610&#x7f;152847&#x7f;150487&#x7f;154001&#x7f;155060&#x7f;152211&#x7f;151240&#x7f;150267&#x7f;150680&#x7f;150220&#x7f;150640&#x7f;153847&#x7f;150462&#x7f;151801&#x7f;155219&#x7f;154269&#x7f;153020&#x7f;155201&#x7f;150660&#x7f;154448&#x7f;152447&#x7f;151267&#x7f;154860&#x7f;150647&#x7f;152468&#x7f;154847&#x7f;153867&#x7f;150469&#x7f;153827&#x7f;150488&#x7f;150620&#x7f;153240&#x7f;152240&#x7f;154040&#x7f;155001&#x7f;151047&#x7f;153468&#x7f;152867&#x7f;150207&#x7f;153460&#x7f;151827&#x7f;153801&#x7f;155027&#x7f;153260&#x7f;152047&#x7f;152080&#x7f;153227&#x7f;151247&#x7f;153840&#x7f;152647&#x7f;152247&#x7f;153037&#x7f;153407&#x7f;151820&#x7f;152601&#x7f;154220&#x7f;153057&#x7f;153440&#x7f;150247&#x7f;151647&#x7f;152469&#x7f;150820&#x7f;152427&#x7f;154808&#x7f;153608&#x7f;153860&#x7f;153220&#x7f;154080&#x7f;152210&#x7f;154427&#x7f;150448&#x7f;154887&#x7f;151608&#x7f;154201&#x7f;150667&#x7f;151660&#x7f;153457&#x7f;151807&#x7f;153620&#x7f;150807&#x7f;151667&#x7f;154268&#x7f;152237&#x7f;154667&#x7f;150627&#x7f;153248&#x7f;154640&#x7f;153627&#x7f;151027&#x7f;152217&#x7f;151627&#x7f;153047&#x7f;153280&#x7f;153201&#x7f;150480&#x7f;152627&#x7f;153268&#x7f;153809&#x7f;150408&#x7f;153247&#x7f;150827&#x7f;153067&#x7f;151447&#x7f;150008&#x7f;152667&#x7f;152060&#x7f;153637&#x7f;154601&#x7f;151427&#x7f;153467&#x7f;154447&#x7f;153447&#x7f;150009&#x7f;154820&#x7f;150002&#x7f;153887&#x7f;152448&#x7f;154801&#x7f;151020&#x7f;152020&#x7f;153050&#x7f;150467&#x7f;154647&#x7f;155217&#x7f;152250&#x7f;150687&#x7f;154047&#x7f;150840&#x7f;150607&#x7f;153668&#x7f;151448&#x7f;152218&#x7f;152268&#x7f;152640&#x7f;155208&#x7f;152428&#x7f;153217&#x7f;154460&#x7f;150887&#x7f;150260&#x7f;154087&#x7f;151260&#x7f;150447&#x7f;152401&#x7f;152807&#x7f;155067&#x7f;153267&#x7f;154267&#x7f;154207&#x7f;154609&#x7f;150461&#x7f;151420&#x7f;150601&#x7f;150468&#x7f;154660&#x7f;154840&#x7f;152027&#x7f;154608&#x7f;153660&#x7f;154828&#x7f;155028&#x7f;153647&#x7f;151601&#x7f;154807&#x7f;150440&#x7f;153487&#x7f;152087&#x7f;154428&#x7f;154677&#x7f;153630&#x7f;153648&#x7f;152820&#x7f;154617&#x7f;153030&#x7f;152840&#x7f;153807&#x7f;153607&#x7f;152257&#x7f;151220&#x7f;151280&#x7f;154227&#x7f;151609&#x7f;151440&#x7f;154260&#x7f;150427&#x7f;155048&#x7f;153427&#x7f;151640&#x7f;150268&#x7f;152280&#x7f;152267&#x7f;150449&#x7f;152467&#x7f;150880&#x7f;151067&#x7f;154060&#x7f;154240&#x7f;150401&#x7f;153408&#x7f;153649&#x7f;152288&#x7f;152620&#x7f;152260&#x7f;154648&#x7f;154007&#x7f;155209&#x7f;154670&#x7f;153060&#x7f;152420&#x7f;151401&#x7f;152660&#x7f;152287&#x7f;152407&#x7f;152207&#x7f;150407&#x7f;152230&#x7f;150801&#x7f;154687&#x7f;152680&#x7f;153001&#x7f;154440&#x7f;151840&#x7f;152219&#x7f;153820&#x7f;152607&#x7f;151060&#x7f;153617&#x7f;152067&#x7f;153808&#x7f;152007&#x7f;152617&#x7f;150227&#x7f;150201&#x7f;151628&#x7f;150477&#x7f;151001&#x7f;152440&#x7f;150007&#x7f;154401&#x7f;150420&#x7f;151040&#x7f;151607&#x7f;155068&#x7f;154247&#x7f;151620&#x7f;153601&#x7f;150003&#x7f;154467&#x7f;154067&#x7f;155007&#x7f;150208&#x7f;153040&#x7f;154607&#x7f;151847&#x7f;153210&#x7f;152687&#x7f;154420&#x7f;150860&#x7f;153027&#x7f;150847&#x7f;153610&#x7f;153007&#x7f;154020&#x7f;152827&#x7f;152460&#x7f;150428&#x7f;150240&#x7f;150867&#x7f;153640&#x7f;154680&#x7f;152801&#x7f;152201&#x7f;155207&#x7f;152040&#x7f;155040&#x7f;153480&#x7f;150001&#x7f;152860&#x7f;154880&#x7f;154848&#x7f;151227&#x7f;151207&#x7f;152610&#x7f;153401&#x7f;154867&#x7f;154027&#x7f;155020&#x7f;172001&#x7f;170003&#x7f;176001&#x7f;170008&#x7f;176007&#x7f;177060&#x7f;171020&#x7f;172027&#x7f;174008&#x7f;173020&#x7f;172048&#x7f;170001&#x7f;172060&#x7f;178001&#x7f;170017&#x7f;178047&#x7f;170002&#x7f;178057&#x7f;174001&#x7f;177087&#x7f;176048&#x7f;173060&#x7f;172029&#x7f;176028&#x7f;174007&#x7f;175001&#x7f;178049&#x7f;177089&#x7f;177040&#x7f;173001&#x7f;171008&#x7f;178020&#x7f;172047&#x7f;172040&#x7f;178048&#x7f;171047&#x7f;174037&#x7f;177047&#x7f;175007&#x7f;176047&#x7f;175037&#x7f;170009&#x7f;172007&#x7f;178007&#x7f;171001&#x7f;172009&#x7f;173047&#x7f;173067&#x7f;177020&#x7f;173007&#x7f;175030&#x7f;176040&#x7f;177027&#x7f;177067&#x7f;170006&#x7f;178040&#x7f;173028&#x7f;170004&#x7f;172008&#x7f;174030&#x7f;176027&#x7f;172028&#x7f;171007&#x7f;177007&#x7f;170007&#x7f;171040&#x7f;171028&#x7f;173048&#x7f;173040&#x7f;178028&#x7f;177080&#x7f;177001&#x7f;172067&#x7f;173068&#x7f;176020&#x7f;177068&#x7f;175038&#x7f;174038&#x7f;177088&#x7f;173069&#x7f;174009&#x7f;175031&#x7f;176008&#x7f;171027&#x7f;172020&#x7f;173027&#x7f;178027&#x7f;180017&#x7f;184010&#x7f;186037&#x7f;181037&#x7f;180002&#x7f;181059&#x7f;186017&#x7f;184017&#x7f;186058&#x7f;181058&#x7f;186038&#x7f;181017&#x7f;182017&#x7f;185017&#x7f;186010&#x7f;186030&#x7f;186077&#x7f;184019&#x7f;183010&#x7f;185077&#x7f;186059&#x7f;186057&#x7f;185037&#x7f;180001&#x7f;185057&#x7f;181039&#x7f;181050&#x7f;185030&#x7f;186070&#x7f;183019&#x7f;182058&#x7f;181057&#x7f;185070&#x7f;185058&#x7f;186050&#x7f;181010&#x7f;185018&#x7f;183017&#x7f;182019&#x7f;181038&#x7f;180007&#x7f;184018&#x7f;185038&#x7f;180009&#x7f;181067&#x7f;185010&#x7f;185050&#x7f;182018&#x7f;182057&#x7f;186078&#x7f;182050&#x7f;186018&#x7f;183027&#x7f;182059&#x7f;183018&#x7f;182010&#x7f;181018&#x7f;181030&#x7f;180008&#x7f;181019&#x7f;185078&#x7f;855030&#x7f;850001&#x7f;855039&#x7f;852058&#x7f;856017&#x7f;853059&#x7f;851070&#x7f;856030&#x7f;853038&#x7f;851030&#x7f;856019&#x7f;851077&#x7f;854037&#x7f;854017&#x7f;855050&#x7f;854018&#x7f;852039&#x7f;852038&#x7f;853039&#x7f;853057&#x7f;855057&#x7f;852050&#x7f;855038&#x7f;855010&#x7f;853030&#x7f;852030&#x7f;852037&#x7f;850007&#x7f;856010&#x7f;855018&#x7f;853058&#x7f;850008&#x7f;854019&#x7f;851038&#x7f;856038&#x7f;853017&#x7f;853010&#x7f;854010&#x7f;856050&#x7f;855058&#x7f;851078&#x7f;851057&#x7f;852019&#x7f;851010&#x7f;856058&#x7f;856018&#x7f;854038&#x7f;853018&#x7f;855037&#x7f;854039&#x7f;850009&#x7f;851037&#x7f;855017&#x7f;851058&#x7f;851017&#x7f;850002&#x7f;853037&#x7f;852017&#x7f;852057&#x7f;854030&#x7f;856057&#x7f;852010&#x7f;852018&#x7f;851050&#x7f;853050&#x7f;856037&#x7f;853019&#x7f;191077&#x7f;191088&#x7f;193588&#x7f;194028&#x7f;195539&#x7f;191528&#x7f;190509&#x7f;191501&#x7f;194007&#x7f;192027&#x7f;196038&#x7f;194037&#x7f;192579&#x7f;193507&#x7f;190517&#x7f;190547&#x7f;193550&#x7f;193001&#x7f;194080&#x7f;193589&#x7f;191048&#x7f;195008&#x7f;190567&#x7f;194068&#x7f;192008&#x7f;196009&#x7f;190518&#x7f;195067&#x7f;193578&#x7f;191079&#x7f;192007&#x7f;190009&#x7f;190508&#x7f;190018&#x7f;190501&#x7f;195040&#x7f;192020&#x7f;195047&#x7f;192048&#x7f;192578&#x7f;192057&#x7f;191047&#x7f;196030&#x7f;195017&#x7f;195538&#x7f;191529&#x7f;193579&#x7f;192077&#x7f;194558&#x7f;194508&#x7f;195060&#x7f;193570&#x7f;192001&#x7f;192508&#x7f;190538&#x7f;191039&#x7f;195009&#x7f;190002&#x7f;190558&#x7f;195547&#x7f;191067&#x7f;191568&#x7f;196037&#x7f;194089&#x7f;191007&#x7f;196008&#x7f;194501&#x7f;191017&#x7f;195507&#x7f;190017&#x7f;192040&#x7f;190589&#x7f;196060&#x7f;194027&#x7f;191567&#x7f;191540&#x7f;191038&#x7f;195019&#x7f;193508&#x7f;190539&#x7f;191037&#x7f;190004&#x7f;190001&#x7f;192547&#x7f;190507&#x7f;194008&#x7f;195001&#x7f;192518&#x7f;194067&#x7f;192009&#x7f;191569&#x7f;193537&#x7f;191030&#x7f;190548&#x7f;193008&#x7f;195018&#x7f;190530&#x7f;192539&#x7f;192049&#x7f;193007&#x7f;193557&#x7f;193577&#x7f;191060&#x7f;194088&#x7f;192078&#x7f;194509&#x7f;195508&#x7f;194029&#x7f;195567&#x7f;194087&#x7f;193597&#x7f;191087&#x7f;190003&#x7f;192531&#x7f;194001&#x7f;194528&#x7f;196001&#x7f;190588&#x7f;194527&#x7f;193520&#x7f;193009&#x7f;191009&#x7f;195501&#x7f;196068&#x7f;190537&#x7f;194060&#x7f;194557&#x7f;190580&#x7f;191001&#x7f;192548&#x7f;195068&#x7f;192047&#x7f;191078&#x7f;191049&#x7f;190550&#x7f;191008&#x7f;192079&#x7f;190008&#x7f;192537&#x7f;192570&#x7f;192070&#x7f;191520&#x7f;190559&#x7f;193527&#x7f;192577&#x7f;190557&#x7f;194520&#x7f;192029&#x7f;194507&#x7f;195069&#x7f;192028&#x7f;191560&#x7f;195530&#x7f;192501&#x7f;190587&#x7f;193587&#x7f;194020&#x7f;195560&#x7f;191527&#x7f;194550&#x7f;192509&#x7f;190597&#x7f;192507&#x7f;192517&#x7f;193529&#x7f;196007&#x7f;194038&#x7f;195007&#x7f;192087&#x7f;196067&#x7f;192538&#x7f;191547&#x7f;193528&#x7f;193501&#x7f;193558&#x7f;191507&#x7f;195509&#x7f;190007&#x7f;191070&#x7f;195537&#x7f;200009&#x7f;201057&#x7f;201038&#x7f;201048&#x7f;203067&#x7f;205008&#x7f;205010&#x7f;201058&#x7f;200002&#x7f;202037&#x7f;201037&#x7f;205017&#x7f;200008&#x7f;204067&#x7f;205078&#x7f;204001&#x7f;200001&#x7f;200007&#x7f;201010&#x7f;203020&#x7f;201040&#x7f;202017&#x7f;203060&#x7f;203048&#x7f;203047&#x7f;201027&#x7f;201030&#x7f;205040&#x7f;204047&#x7f;204020&#x7f;200017&#x7f;201050&#x7f;204040&#x7f;203040&#x7f;202018&#x7f;202030&#x7f;205037&#x7f;202010&#x7f;204028&#x7f;201018&#x7f;203001&#x7f;204068&#x7f;205050&#x7f;201020&#x7f;201017&#x7f;202038&#x7f;204060&#x7f;203007&#x7f;200003&#x7f;201001&#x7f;205047&#x7f;205007&#x7f;204027&#x7f;204007&#x7f;203027&#x7f;205057&#x7f;202050&#x7f;202058&#x7f;201007&#x7f;205030&#x7f;205058&#x7f;205070&#x7f;205048&#x7f;202057&#x7f;200004&#x7f;200018&#x7f;201047&#x7f;200005&#x7f;205059&#x7f;202001&#x7f;201008&#x7f;205018&#x7f;205077&#x7f;202007&#x7f;205001&#x7f;274017&#x7f;273077&#x7f;272017&#x7f;276078&#x7f;272020&#x7f;272050&#x7f;278037&#x7f;272048&#x7f;274050&#x7f;276018&#x7f;276030&#x7f;276038&#x7f;275038&#x7f;277010&#x7f;273058&#x7f;271037&#x7f;276019&#x7f;275010&#x7f;273037&#x7f;276050&#x7f;272058&#x7f;276077&#x7f;274010&#x7f;277050&#x7f;272040&#x7f;272057&#x7f;270070&#x7f;272027&#x7f;275030&#x7f;271030&#x7f;274018&#x7f;274039&#x7f;270077&#x7f;273030&#x7f;272037&#x7f;276070&#x7f;273057&#x7f;277038&#x7f;270078&#x7f;277037&#x7f;275058&#x7f;275057&#x7f;276037&#x7f;278010&#x7f;273010&#x7f;277030&#x7f;273038&#x7f;278057&#x7f;274037&#x7f;271017&#x7f;277017&#x7f;274058&#x7f;278038&#x7f;275037&#x7f;275050&#x7f;278018&#x7f;271050&#x7f;270007&#x7f;273050&#x7f;273078&#x7f;271018&#x7f;278050&#x7f;274038&#x7f;270002&#x7f;276057&#x7f;272047&#x7f;270009&#x7f;277018&#x7f;278017&#x7f;270001&#x7f;274019&#x7f;276058&#x7f;278030&#x7f;272010&#x7f;275017&#x7f;273070&#x7f;272018&#x7f;274030&#x7f;275018&#x7f;271058&#x7f;278058&#x7f;273017&#x7f;271010&#x7f;274057&#x7f;276010&#x7f;272030&#x7f;276017&#x7f;271077&#x7f;271070&#x7f;271057&#x7f;277057&#x7f;270008&#x7f;231520&#x7f;233049&#x7f;232039&#x7f;230520&#x7f;232557&#x7f;230017&#x7f;234010&#x7f;233501&#x7f;230507&#x7f;232537&#x7f;234538&#x7f;234007&#x7f;231048&#x7f;234517&#x7f;235020&#x7f;233048&#x7f;234539&#x7f;230558&#x7f;230550&#x7f;233001&#x7f;232050&#x7f;234030&#x7f;235028&#x7f;232508&#x7f;233020&#x7f;232529&#x7f;233538&#x7f;231038&#x7f;231007&#x7f;232547&#x7f;230027&#x7f;231540&#x7f;234039&#x7f;234508&#x7f;230002&#x7f;231029&#x7f;230009&#x7f;232558&#x7f;232020&#x7f;232507&#x7f;235027&#x7f;230028&#x7f;230019&#x7f;233530&#x7f;232527&#x7f;234038&#x7f;232008&#x7f;231507&#x7f;235048&#x7f;233028&#x7f;234518&#x7f;234537&#x7f;232017&#x7f;234501&#x7f;232001&#x7f;231027&#x7f;235008&#x7f;235040&#x7f;230529&#x7f;234507&#x7f;231047&#x7f;230537&#x7f;232059&#x7f;233040&#x7f;230007&#x7f;233537&#x7f;231020&#x7f;232559&#x7f;230018&#x7f;234001&#x7f;232540&#x7f;233007&#x7f;232007&#x7f;231528&#x7f;232528&#x7f;235007&#x7f;231508&#x7f;231001&#x7f;230538&#x7f;235047&#x7f;233027&#x7f;232038&#x7f;232520&#x7f;232010&#x7f;232030&#x7f;232548&#x7f;233507&#x7f;232058&#x7f;232057&#x7f;230003&#x7f;233539&#x7f;232538&#x7f;231527&#x7f;230557&#x7f;234037&#x7f;232509&#x7f;233008&#x7f;231501&#x7f;231028&#x7f;230029&#x7f;232027&#x7f;231037&#x7f;233009&#x7f;231509&#x7f;230528&#x7f;234530&#x7f;232517&#x7f;230501&#x7f;231039&#x7f;230527&#x7f;235001&#x7f;230001&#x7f;232549&#x7f;233047&#x7f;233057&#x7f;232501&#x7f;230004&#x7f;230008&#x7f;234509&#x7f;230559&#x7f;231547&#x7f;234008&#x7f;231008&#x7f;234017&#x7f;232018&#x7f;253427&#x7f;253627&#x7f;252610&#x7f;252417&#x7f;252848&#x7f;253460&#x7f;252847&#x7f;250601&#x7f;251267&#x7f;251227&#x7f;251628&#x7f;250051&#x7f;250818&#x7f;253047&#x7f;253620&#x7f;253040&#x7f;252008&#x7f;252212&#x7f;250257&#x7f;250020&#x7f;251208&#x7f;253840&#x7f;252040&#x7f;253847&#x7f;250407&#x7f;250630&#x7f;252247&#x7f;251020&#x7f;250220&#x7f;250251&#x7f;253440&#x7f;250637&#x7f;250418&#x7f;254007&#x7f;251810&#x7f;250450&#x7f;251038&#x7f;253660&#x7f;253437&#x7f;252801&#x7f;253607&#x7f;253601&#x7f;253227&#x7f;250607&#x7f;251027&#x7f;252010&#x7f;251047&#x7f;252820&#x7f;254040&#x7f;252030&#x7f;250052&#x7f;250410&#x7f;252037&#x7f;253201&#x7f;250252&#x7f;253260&#x7f;250430&#x7f;252657&#x7f;253610&#x7f;250640&#x7f;252001&#x7f;253449&#x7f;251407&#x7f;252248&#x7f;250030&#x7f;253420&#x7f;253217&#x7f;251847&#x7f;251040&#x7f;253447&#x7f;250078&#x7f;250608&#x7f;252830&#x7f;253257&#x7f;252627&#x7f;252640&#x7f;253647&#x7f;250810&#x7f;253230&#x7f;251850&#x7f;250417&#x7f;251830&#x7f;252201&#x7f;250830&#x7f;250055&#x7f;250077&#x7f;252638&#x7f;251620&#x7f;253827&#x7f;251217&#x7f;250054&#x7f;250247&#x7f;252630&#x7f;253608&#x7f;250827&#x7f;253020&#x7f;252850&#x7f;251808&#x7f;253650&#x7f;251401&#x7f;250217&#x7f;252810&#x7f;252648&#x7f;251057&#x7f;251010&#x7f;250440&#x7f;252431&#x7f;250037&#x7f;252217&#x7f;253030&#x7f;252410&#x7f;253052&#x7f;251240&#x7f;250437&#x7f;252240&#x7f;251607&#x7f;253250&#x7f;253618&#x7f;253410&#x7f;250010&#x7f;253637&#x7f;253057&#x7f;252211&#x7f;253051&#x7f;253407&#x7f;250837&#x7f;251230&#x7f;250847&#x7f;251837&#x7f;251627&#x7f;252607&#x7f;253667&#x7f;251001&#x7f;251648&#x7f;252257&#x7f;252219&#x7f;253401&#x7f;251201&#x7f;250620&#x7f;251247&#x7f;250047&#x7f;251857&#x7f;250240&#x7f;250428&#x7f;250058&#x7f;253207&#x7f;250447&#x7f;252207&#x7f;253007&#x7f;252401&#x7f;250057&#x7f;254020&#x7f;254008&#x7f;250420&#x7f;250002&#x7f;251647&#x7f;252667&#x7f;251067&#x7f;254027&#x7f;253408&#x7f;251428&#x7f;253027&#x7f;250820&#x7f;253258&#x7f;253468&#x7f;253237&#x7f;252020&#x7f;253807&#x7f;250617&#x7f;252408&#x7f;253240&#x7f;251210&#x7f;250227&#x7f;251817&#x7f;252218&#x7f;251058&#x7f;250848&#x7f;253808&#x7f;254030&#x7f;250618&#x7f;250017&#x7f;252840&#x7f;252007&#x7f;250840&#x7f;253010&#x7f;251030&#x7f;251048&#x7f;252028&#x7f;253220&#x7f;253658&#x7f;252208&#x7f;251420&#x7f;250210&#x7f;251218&#x7f;250801&#x7f;251050&#x7f;251801&#x7f;253467&#x7f;253480&#x7f;250401&#x7f;253017&#x7f;251220&#x7f;250457&#x7f;253820&#x7f;251807&#x7f;252647&#x7f;253448&#x7f;252817&#x7f;251820&#x7f;251060&#x7f;252432&#x7f;254050&#x7f;251008&#x7f;250228&#x7f;250647&#x7f;251860&#x7f;252660&#x7f;252608&#x7f;254037&#x7f;252237&#x7f;252437&#x7f;251260&#x7f;254047&#x7f;251827&#x7f;250053&#x7f;252827&#x7f;251237&#x7f;252617&#x7f;251427&#x7f;250007&#x7f;250008&#x7f;251268&#x7f;254057&#x7f;253640&#x7f;253001&#x7f;252620&#x7f;251840&#x7f;251257&#x7f;250627&#x7f;253037&#x7f;250207&#x7f;250027&#x7f;253247&#x7f;253430&#x7f;252637&#x7f;252047&#x7f;253801&#x7f;252807&#x7f;250427&#x7f;252650&#x7f;252407&#x7f;252230&#x7f;253058&#x7f;252250&#x7f;252857&#x7f;250237&#x7f;254001&#x7f;250408&#x7f;253630&#x7f;253617&#x7f;251207&#x7f;251601&#x7f;253417&#x7f;253418&#x7f;253487&#x7f;250258&#x7f;250610&#x7f;252601&#x7f;253657&#x7f;250201&#x7f;250038&#x7f;250070&#x7f;251238&#x7f;251640&#x7f;251037&#x7f;253048&#x7f;253267&#x7f;252668&#x7f;250208&#x7f;250040&#x7f;253648&#x7f;252017&#x7f;250001&#x7f;252027&#x7f;251017&#x7f;252837&#x7f;253210&#x7f;253848&#x7f;251250&#x7f;250808&#x7f;251007&#x7f;250807&#x7f;250230&#x7f;250817&#x7f;251867&#x7f;942057&#x7f;944058&#x7f;944018&#x7f;943018&#x7f;940001&#x7f;944057&#x7f;941017&#x7f;942010&#x7f;940008&#x7f;943019&#x7f;943067&#x7f;940018&#x7f;943058&#x7f;940007&#x7f;940027&#x7f;941038&#x7f;940028&#x7f;941047&#x7f;940019&#x7f;940009&#x7f;943057&#x7f;941018&#x7f;941039&#x7f;941037&#x7f;941010&#x7f;943059&#x7f;944019&#x7f;942018&#x7f;944059&#x7f;940017&#x7f;942017&#x7f;944010&#x7f;943017&#x7f;944017&#x7f;951008&#x7f;951007&#x7f;952001&#x7f;953007&#x7f;950001&#x7f;952017&#x7f;953009&#x7f;950007&#x7f;952007&#x7f;951001&#x7f;952008&#x7f;950008&#x7f;952009&#x7f;950009&#x7f;951009&#x7f;953017&#x7f;951017&#x7f;953001&#x7f;953018&#x7f;953008&#x7f;418049&#x7f;414040&#x7f;410003&#x7f;418047&#x7f;412020&#x7f;417038&#x7f;414027&#x7f;416048&#x7f;416001&#x7f;413008&#x7f;413067&#x7f;418077&#x7f;418067&#x7f;415008&#x7f;413001&#x7f;416067&#x7f;418007&#x7f;410007&#x7f;417039&#x7f;414020&#x7f;417018&#x7f;411087&#x7f;415047&#x7f;415001&#x7f;411048&#x7f;414008&#x7f;414029&#x7f;411027&#x7f;414068&#x7f;416087&#x7f;415080&#x7f;412047&#x7f;415069&#x7f;414009&#x7f;415040&#x7f;417060&#x7f;412080&#x7f;412087&#x7f;410001&#x7f;411088&#x7f;411007&#x7f;410017&#x7f;416047&#x7f;415027&#x7f;411028&#x7f;418001&#x7f;417079&#x7f;417030&#x7f;416007&#x7f;417037&#x7f;415060&#x7f;413040&#x7f;414060&#x7f;411080&#x7f;417007&#x7f;410010&#x7f;411060&#x7f;418028&#x7f;414028&#x7f;415078&#x7f;412060&#x7f;411001&#x7f;414001&#x7f;418040&#x7f;416088&#x7f;410006&#x7f;414047&#x7f;415087&#x7f;410009&#x7f;418069&#x7f;417070&#x7f;417078&#x7f;415020&#x7f;412008&#x7f;413028&#x7f;410005&#x7f;410008&#x7f;412067&#x7f;414067&#x7f;413027&#x7f;414007&#x7f;417067&#x7f;415007&#x7f;417088&#x7f;412027&#x7f;415077&#x7f;418027&#x7f;416080&#x7f;418068&#x7f;411047&#x7f;412040&#x7f;413060&#x7f;411020&#x7f;418008&#x7f;412068&#x7f;416027&#x7f;411040&#x7f;418020&#x7f;417001&#x7f;413047&#x7f;418060&#x7f;417087&#x7f;417077&#x7f;410004&#x7f;418048&#x7f;411008&#x7f;412001&#x7f;416020&#x7f;413020&#x7f;412007&#x7f;410002&#x7f;415068&#x7f;413007&#x7f;415088&#x7f;416089&#x7f;417047&#x7f;416040&#x7f;417048&#x7f;410018&#x7f;411067&#x7f;417017&#x7f;417010&#x7f;413048&#x7f;446007&#x7f;440007&#x7f;446009&#x7f;444008&#x7f;443027&#x7f;440003&#x7f;444010&#x7f;441048&#x7f;444037&#x7f;443007&#x7f;444030&#x7f;446008&#x7f;443049&#x7f;444057&#x7f;442009&#x7f;441009&#x7f;440008&#x7f;443048&#x7f;445007&#x7f;441008&#x7f;444050&#x7f;442001&#x7f;441039&#x7f;445040&#x7f;443040&#x7f;442008&#x7f;443028&#x7f;441057&#x7f;441058&#x7f;441027&#x7f;441018&#x7f;444007&#x7f;445027&#x7f;444001&#x7f;445020&#x7f;441007&#x7f;443047&#x7f;440001&#x7f;441059&#x7f;441001&#x7f;443020&#x7f;440009&#x7f;444018&#x7f;446017&#x7f;446001&#x7f;443008&#x7f;440017&#x7f;445047&#x7f;441047&#x7f;440002&#x7f;441017&#x7f;442007&#x7f;444038&#x7f;445001&#x7f;444017&#x7f;441020&#x7f;441038&#x7f;445008&#x7f;441049&#x7f;443009&#x7f;443001&#x7f;441029&#x7f;441037&#x7f;441028&#x7f;474048&#x7f;476020&#x7f;478007&#x7f;472007&#x7f;475008&#x7f;472028&#x7f;475007&#x7f;478020&#x7f;478001&#x7f;470009&#x7f;473029&#x7f;475057&#x7f;478067&#x7f;476067&#x7f;475030&#x7f;475020&#x7f;476058&#x7f;470004&#x7f;476068&#x7f;478027&#x7f;473047&#x7f;473027&#x7f;474028&#x7f;473048&#x7f;475017&#x7f;475010&#x7f;474067&#x7f;473049&#x7f;477047&#x7f;476007&#x7f;472027&#x7f;470017&#x7f;478048&#x7f;475038&#x7f;472047&#x7f;476027&#x7f;477009&#x7f;476037&#x7f;474020&#x7f;475018&#x7f;472020&#x7f;478060&#x7f;475037&#x7f;477050&#x7f;473001&#x7f;477001&#x7f;475027&#x7f;472040&#x7f;470002&#x7f;474040&#x7f;474007&#x7f;476047&#x7f;476040&#x7f;477008&#x7f;475019&#x7f;475028&#x7f;476057&#x7f;470008&#x7f;472008&#x7f;478037&#x7f;478008&#x7f;477040&#x7f;470007&#x7f;472001&#x7f;478040&#x7f;478029&#x7f;475001&#x7f;474068&#x7f;473040&#x7f;476008&#x7f;473020&#x7f;476048&#x7f;477058&#x7f;478002&#x7f;477020&#x7f;477057&#x7f;476050&#x7f;476030&#x7f;470003&#x7f;478047&#x7f;470005&#x7f;470001&#x7f;473028&#x7f;474001&#x7f;474027&#x7f;476060&#x7f;474047&#x7f;475050&#x7f;473007&#x7f;473008&#x7f;478028&#x7f;477007&#x7f;477027&#x7f;470006&#x7f;476001&#x7f;474060&#x7f;504068&#x7f;503008&#x7f;504027&#x7f;501001&#x7f;500004&#x7f;503007&#x7f;506027&#x7f;506068&#x7f;504067&#x7f;505008&#x7f;507019&#x7f;500003&#x7f;507008&#x7f;507051&#x7f;502008&#x7f;507048&#x7f;501028&#x7f;506047&#x7f;500001&#x7f;504047&#x7f;506061&#x7f;504001&#x7f;506001&#x7f;507028&#x7f;501007&#x7f;501021&#x7f;504061&#x7f;505007&#x7f;507058&#x7f;503061&#x7f;501017&#x7f;502048&#x7f;507021&#x7f;503067&#x7f;503021&#x7f;501057&#x7f;500017&#x7f;507047&#x7f;500005&#x7f;506007&#x7f;504007&#x7f;506048&#x7f;506041&#x7f;504048&#x7f;501041&#x7f;507037&#x7f;501038&#x7f;502047&#x7f;507007&#x7f;502049&#x7f;503068&#x7f;502041&#x7f;501018&#x7f;503027&#x7f;500007&#x7f;505048&#x7f;501047&#x7f;504021&#x7f;501027&#x7f;503029&#x7f;503041&#x7f;507041&#x7f;506021&#x7f;503001&#x7f;501031&#x7f;505021&#x7f;505047&#x7f;502058&#x7f;507057&#x7f;502009&#x7f;504028&#x7f;500002&#x7f;505028&#x7f;507017&#x7f;503037&#x7f;504041&#x7f;505027&#x7f;500008&#x7f;507029&#x7f;501037&#x7f;507027&#x7f;507001&#x7f;502001&#x7f;504008&#x7f;505001&#x7f;501011&#x7f;506008&#x7f;505041&#x7f;502057&#x7f;502007&#x7f;502059&#x7f;507011&#x7f;503028&#x7f;506067&#x7f;500009&#x7f;501051&#x7f;507009&#x7f;503047&#x7f;528538&#x7f;524587&#x7f;527529&#x7f;525550&#x7f;527520&#x7f;524038&#x7f;522068&#x7f;525068&#x7f;525038&#x7f;525030&#x7f;527007&#x7f;527580&#x7f;527060&#x7f;526520&#x7f;521060&#x7f;524527&#x7f;526027&#x7f;520530&#x7f;523540&#x7f;526001&#x7f;528008&#x7f;520004&#x7f;525001&#x7f;526560&#x7f;526007&#x7f;525037&#x7f;526567&#x7f;527589&#x7f;522048&#x7f;525069&#x7f;525529&#x7f;527067&#x7f;521048&#x7f;521080&#x7f;520537&#x7f;523007&#x7f;522067&#x7f;520003&#x7f;522520&#x7f;524039&#x7f;521001&#x7f;520577&#x7f;520509&#x7f;521548&#x7f;527508&#x7f;521501&#x7f;527547&#x7f;524069&#x7f;528039&#x7f;520027&#x7f;528560&#x7f;526057&#x7f;523087&#x7f;520517&#x7f;522047&#x7f;521569&#x7f;525579&#x7f;520518&#x7f;528517&#x7f;528078&#x7f;525067&#x7f;524009&#x7f;524520&#x7f;523507&#x7f;523527&#x7f;524540&#x7f;528037&#x7f;528009&#x7f;523080&#x7f;520570&#x7f;522088&#x7f;528519&#x7f;522501&#x7f;524060&#x7f;524030&#x7f;520019&#x7f;522087&#x7f;525558&#x7f;527068&#x7f;525047&#x7f;521540&#x7f;525501&#x7f;523067&#x7f;527527&#x7f;525570&#x7f;520010&#x7f;528509&#x7f;527039&#x7f;528502&#x7f;528047&#x7f;528069&#x7f;528518&#x7f;525520&#x7f;523501&#x7f;520029&#x7f;522007&#x7f;521560&#x7f;524007&#x7f;527540&#x7f;526568&#x7f;522027&#x7f;520002&#x7f;524077&#x7f;520039&#x7f;528007&#x7f;526507&#x7f;524078&#x7f;525507&#x7f;524567&#x7f;525008&#x7f;524547&#x7f;525009&#x7f;520501&#x7f;523547&#x7f;527548&#x7f;527030&#x7f;520028&#x7f;524528&#x7f;526527&#x7f;522527&#x7f;523068&#x7f;520538&#x7f;520037&#x7f;520008&#x7f;526529&#x7f;520007&#x7f;521087&#x7f;526047&#x7f;525528&#x7f;521067&#x7f;520038&#x7f;528067&#x7f;521520&#x7f;525039&#x7f;521547&#x7f;520557&#x7f;526040&#x7f;523060&#x7f;521040&#x7f;527001&#x7f;526528&#x7f;523008&#x7f;523548&#x7f;524037&#x7f;521007&#x7f;522060&#x7f;525557&#x7f;528508&#x7f;520009&#x7f;522080&#x7f;528507&#x7f;521020&#x7f;522547&#x7f;526501&#x7f;524067&#x7f;522540&#x7f;524008&#x7f;527038&#x7f;528539&#x7f;525527&#x7f;520018&#x7f;520507&#x7f;521528&#x7f;527037&#x7f;521549&#x7f;527567&#x7f;528567&#x7f;526020&#x7f;523508&#x7f;528527&#x7f;521050&#x7f;527587&#x7f;528528&#x7f;525007&#x7f;521028&#x7f;520017&#x7f;528068&#x7f;527569&#x7f;522020&#x7f;528568&#x7f;525537&#x7f;524507&#x7f;521027&#x7f;521047&#x7f;527568&#x7f;523040&#x7f;525508&#x7f;524061&#x7f;527008&#x7f;524588&#x7f;522040&#x7f;520001&#x7f;528537&#x7f;521527&#x7f;528060&#x7f;527501&#x7f;524001&#x7f;528017&#x7f;522548&#x7f;528030&#x7f;524560&#x7f;527009&#x7f;527537&#x7f;522507&#x7f;520006&#x7f;525577&#x7f;521529&#x7f;520539&#x7f;526049&#x7f;527588&#x7f;525060&#x7f;523001&#x7f;523047&#x7f;522508&#x7f;526058&#x7f;527560&#x7f;521508&#x7f;523027&#x7f;522001&#x7f;520578&#x7f;521568&#x7f;528038&#x7f;523520&#x7f;523028&#x7f;524501&#x7f;521567&#x7f;520508&#x7f;521507&#x7f;528529&#x7f;528001&#x7f;528501&#x7f;527528&#x7f;528503&#x7f;527507&#x7f;523528&#x7f;526048&#x7f;525578&#x7f;524068&#x7f;524580&#x7f;523020&#x7f;528077&#x7f;547018&#x7f;545077&#x7f;540004&#x7f;545557&#x7f;547010&#x7f;540003&#x7f;547050&#x7f;540007&#x7f;543037&#x7f;542017&#x7f;540008&#x7f;541057&#x7f;548017&#x7f;541017&#x7f;546058&#x7f;547077&#x7f;546551&#x7f;547017&#x7f;542037&#x7f;547057&#x7f;542030&#x7f;543030&#x7f;546552&#x7f;546077&#x7f;544070&#x7f;545037&#x7f;545537&#x7f;547058&#x7f;540019&#x7f;547037&#x7f;545070&#x7f;548050&#x7f;547039&#x7f;542050&#x7f;546070&#x7f;544058&#x7f;546557&#x7f;546559&#x7f;544017&#x7f;544527&#x7f;540001&#x7f;544520&#x7f;540011&#x7f;542038&#x7f;548030&#x7f;541030&#x7f;544557&#x7f;548057&#x7f;546079&#x7f;546510&#x7f;540005&#x7f;543010&#x7f;545530&#x7f;540002&#x7f;544528&#x7f;545539&#x7f;544037&#x7f;541038&#x7f;547070&#x7f;545050&#x7f;545538&#x7f;546057&#x7f;542058&#x7f;547078&#x7f;546078&#x7f;545518&#x7f;545010&#x7f;548058&#x7f;544057&#x7f;541070&#x7f;546537&#x7f;546038&#x7f;546030&#x7f;542010&#x7f;542018&#x7f;545517&#x7f;546037&#x7f;544558&#x7f;544030&#x7f;548010&#x7f;543050&#x7f;540013&#x7f;546050&#x7f;545550&#x7f;543018&#x7f;541018&#x7f;545510&#x7f;543057&#x7f;546010&#x7f;545017&#x7f;545030&#x7f;547030&#x7f;546017&#x7f;546517&#x7f;544570&#x7f;540010&#x7f;544578&#x7f;548037&#x7f;547059&#x7f;544529&#x7f;544077&#x7f;544010&#x7f;544050&#x7f;541010&#x7f;544577&#x7f;545558&#x7f;544517&#x7f;547038&#x7f;543058&#x7f;543017&#x7f;541050&#x7f;540017&#x7f;546558&#x7f;547079&#x7f;543038&#x7f;540006&#x7f;546530&#x7f;542057&#x7f;544550&#x7f;541077&#x7f;540018&#x7f;544038&#x7f;545057&#x7f;544510&#x7f;548018&#x7f;861040&#x7f;864007&#x7f;861007&#x7f;861027&#x7f;864008&#x7f;863007&#x7f;862080&#x7f;861088&#x7f;861087&#x7f;861047&#x7f;862047&#x7f;861060&#x7f;861067&#x7f;861020&#x7f;863008&#x7f;860001&#x7f;862020&#x7f;863001&#x7f;862069&#x7f;861068&#x7f;861001&#x7f;862040&#x7f;862060&#x7f;862001&#x7f;862087&#x7f;861008&#x7f;862008&#x7f;861080&#x7f;862028&#x7f;864009&#x7f;862068&#x7f;862067&#x7f;864001&#x7f;862007&#x7f;860007&#x7f;862027&#x7f;860008&#x7f;634001&#x7f;633027&#x7f;632008&#x7f;631028&#x7f;634008&#x7f;632060&#x7f;630004&#x7f;632001&#x7f;634007&#x7f;633001&#x7f;632027&#x7f;630001&#x7f;630002&#x7f;630007&#x7f;632020&#x7f;633020&#x7f;632040&#x7f;632007&#x7f;633007&#x7f;630003&#x7f;631020&#x7f;630008&#x7f;631001&#x7f;634027&#x7f;632080&#x7f;632067&#x7f;632047&#x7f;632087&#x7f;631007&#x7f;631008&#x7f;634020&#x7f;633008&#x7f;631027&#x7f;661007&#x7f;660004&#x7f;660007&#x7f;661048&#x7f;660001&#x7f;661001&#x7f;663037&#x7f;661047&#x7f;660002&#x7f;661040&#x7f;662030&#x7f;660006&#x7f;664017&#x7f;663038&#x7f;660008&#x7f;664008&#x7f;664047&#x7f;663017&#x7f;660017&#x7f;664007&#x7f;664020&#x7f;661027&#x7f;664027&#x7f;664001&#x7f;663030&#x7f;662017&#x7f;663007&#x7f;662010&#x7f;662007&#x7f;664040&#x7f;664048&#x7f;662001&#x7f;661028&#x7f;663008&#x7f;660005&#x7f;661002&#x7f;664028&#x7f;663018&#x7f;663011&#x7f;663001&#x7f;662037&#x7f;660009&#x7f;660003&#x7f;664018&#x7f;661020&#x7f;661008&#x7f;664010&#x7f;687519&#x7f;682548&#x7f;683531&#x7f;685517&#x7f;687038&#x7f;683019&#x7f;680001&#x7f;682061&#x7f;685501&#x7f;682031&#x7f;683528&#x7f;684051&#x7f;682538&#x7f;680507&#x7f;685041&#x7f;685048&#x7f;680547&#x7f;683037&#x7f;686537&#x7f;687039&#x7f;686029&#x7f;683571&#x7f;684021&#x7f;681002&#x7f;683587&#x7f;686531&#x7f;682527&#x7f;682001&#x7f;683049&#x7f;686058&#x7f;685507&#x7f;683061&#x7f;685561&#x7f;685518&#x7f;681531&#x7f;684069&#x7f;681003&#x7f;687587&#x7f;682009&#x7f;685567&#x7f;685007&#x7f;683541&#x7f;682578&#x7f;685551&#x7f;681521&#x7f;687061&#x7f;681027&#x7f;683031&#x7f;687578&#x7f;683028&#x7f;682051&#x7f;681019&#x7f;684041&#x7f;685527&#x7f;683057&#x7f;683581&#x7f;684017&#x7f;687518&#x7f;682547&#x7f;687509&#x7f;680004&#x7f;683021&#x7f;682568&#x7f;687557&#x7f;680002&#x7f;680541&#x7f;683521&#x7f;684527&#x7f;686028&#x7f;680007&#x7f;682509&#x7f;687577&#x7f;683557&#x7f;681501&#x7f;684507&#x7f;687517&#x7f;682021&#x7f;682041&#x7f;681048&#x7f;681547&#x7f;680567&#x7f;681557&#x7f;686508&#x7f;683578&#x7f;680527&#x7f;683507&#x7f;684058&#x7f;686569&#x7f;684541&#x7f;685541&#x7f;686007&#x7f;681518&#x7f;684061&#x7f;681527&#x7f;683568&#x7f;687527&#x7f;687069&#x7f;683517&#x7f;681007&#x7f;681561&#x7f;682017&#x7f;687068&#x7f;680531&#x7f;684517&#x7f;687047&#x7f;681017&#x7f;685047&#x7f;687001&#x7f;682559&#x7f;683501&#x7f;683029&#x7f;684057&#x7f;680568&#x7f;684037&#x7f;682557&#x7f;683077&#x7f;687511&#x7f;680501&#x7f;683017&#x7f;685521&#x7f;686001&#x7f;681507&#x7f;686567&#x7f;682058&#x7f;681038&#x7f;682577&#x7f;683569&#x7f;683547&#x7f;683051&#x7f;681567&#x7f;687501&#x7f;685008&#x7f;687548&#x7f;686008&#x7f;683527&#x7f;683567&#x7f;682549&#x7f;687507&#x7f;681508&#x7f;681018&#x7f;681551&#x7f;681519&#x7f;686539&#x7f;686021&#x7f;683537&#x7f;684028&#x7f;681031&#x7f;682537&#x7f;686047&#x7f;686027&#x7f;680561&#x7f;684007&#x7f;682517&#x7f;682541&#x7f;680003&#x7f;684031&#x7f;683558&#x7f;685001&#x7f;682528&#x7f;684511&#x7f;681548&#x7f;682551&#x7f;684011&#x7f;682531&#x7f;683071&#x7f;683007&#x7f;686568&#x7f;686049&#x7f;687008&#x7f;682508&#x7f;682048&#x7f;685531&#x7f;685547&#x7f;685568&#x7f;681509&#x7f;687579&#x7f;683048&#x7f;682008&#x7f;682038&#x7f;687571&#x7f;681541&#x7f;686538&#x7f;684039&#x7f;684001&#x7f;682511&#x7f;681001&#x7f;683041&#x7f;682037&#x7f;687508&#x7f;683001&#x7f;681004&#x7f;681511&#x7f;685061&#x7f;682507&#x7f;687032&#x7f;680517&#x7f;683038&#x7f;685009&#x7f;680008&#x7f;687007&#x7f;683561&#x7f;684537&#x7f;684067&#x7f;682571&#x7f;683011&#x7f;682519&#x7f;682057&#x7f;682529&#x7f;682018&#x7f;683511&#x7f;686041&#x7f;687067&#x7f;686057&#x7f;686507&#x7f;681537&#x7f;681037&#x7f;681529&#x7f;686501&#x7f;686547&#x7f;682047&#x7f;684521&#x7f;685569&#x7f;684551&#x7f;683039&#x7f;687542&#x7f;686577&#x7f;683027&#x7f;681538&#x7f;687558&#x7f;683551&#x7f;687549&#x7f;681517&#x7f;687547&#x7f;684531&#x7f;682539&#x7f;682567&#x7f;681528&#x7f;680011&#x7f;682067&#x7f;685021&#x7f;686561&#x7f;687033&#x7f;682007&#x7f;680005&#x7f;683577&#x7f;684068&#x7f;681021&#x7f;687031&#x7f;684557&#x7f;685067&#x7f;681012&#x7f;685557&#x7f;684027&#x7f;682027&#x7f;685049&#x7f;683047&#x7f;682011&#x7f;684008&#x7f;684038&#x7f;681008&#x7f;687037&#x7f;685511&#x7f;684048&#x7f;687541&#x7f;684009&#x7f;682558&#x7f;680006&#x7f;680551&#x7f;684501&#x7f;682521&#x7f;682501&#x7f;684047&#x7f;686048&#x7f;680557&#x7f;685027&#x7f;681047&#x7f;680548&#x7f;681011&#x7f;682561&#x7f;683518&#x7f;683067&#x7f;684547&#x7f;685537&#x7f;680511&#x7f;707030&#x7f;705070&#x7f;704050&#x7f;702037&#x7f;706037&#x7f;700001&#x7f;702057&#x7f;705077&#x7f;702070&#x7f;705018&#x7f;704018&#x7f;703058&#x7f;703038&#x7f;703070&#x7f;701038&#x7f;705050&#x7f;707010&#x7f;701057&#x7f;700003&#x7f;705057&#x7f;705078&#x7f;705037&#x7f;702018&#x7f;702017&#x7f;703018&#x7f;701037&#x7f;704030&#x7f;707057&#x7f;705039&#x7f;701050&#x7f;700009&#x7f;703030&#x7f;701030&#x7f;703037&#x7f;704037&#x7f;702010&#x7f;701077&#x7f;704010&#x7f;707037&#x7f;704038&#x7f;705058&#x7f;703010&#x7f;705079&#x7f;706018&#x7f;701017&#x7f;700008&#x7f;703078&#x7f;706017&#x7f;705017&#x7f;705038&#x7f;701010&#x7f;705010&#x7f;706030&#x7f;702077&#x7f;706010&#x7f;702078&#x7f;700007&#x7f;701078&#x7f;707017&#x7f;704057&#x7f;701070&#x7f;700002&#x7f;704017&#x7f;705030&#x7f;703077&#x7f;703050&#x7f;702050&#x7f;707018&#x7f;707050&#x7f;706057&#x7f;703017&#x7f;700017&#x7f;702030&#x7f;703057&#x7f;706050&#x7f;701058&#x7f;734007&#x7f;733508&#x7f;730002&#x7f;735538&#x7f;733578&#x7f;730588&#x7f;730568&#x7f;731501&#x7f;730018&#x7f;735058&#x7f;733558&#x7f;734540&#x7f;731580&#x7f;732028&#x7f;732508&#x7f;732040&#x7f;730006&#x7f;733547&#x7f;730001&#x7f;735567&#x7f;735569&#x7f;733517&#x7f;733527&#x7f;732001&#x7f;734060&#x7f;730587&#x7f;735007&#x7f;734560&#x7f;731568&#x7f;734567&#x7f;735070&#x7f;731507&#x7f;735037&#x7f;731060&#x7f;735028&#x7f;730004&#x7f;730019&#x7f;730003&#x7f;732027&#x7f;735507&#x7f;730580&#x7f;731587&#x7f;732020&#x7f;733587&#x7f;730520&#x7f;731040&#x7f;730005&#x7f;734068&#x7f;731001&#x7f;731528&#x7f;734509&#x7f;733529&#x7f;735029&#x7f;733048&#x7f;732507&#x7f;735560&#x7f;735550&#x7f;731047&#x7f;735057&#x7f;733520&#x7f;731067&#x7f;735537&#x7f;730009&#x7f;734040&#x7f;734020&#x7f;733001&#x7f;734507&#x7f;734067&#x7f;735008&#x7f;733008&#x7f;734528&#x7f;731007&#x7f;734547&#x7f;733507&#x7f;733540&#x7f;735078&#x7f;735509&#x7f;735557&#x7f;730527&#x7f;732047&#x7f;733040&#x7f;735588&#x7f;730528&#x7f;735001&#x7f;730501&#x7f;732060&#x7f;735027&#x7f;730010&#x7f;734027&#x7f;732007&#x7f;731560&#x7f;734048&#x7f;732068&#x7f;733510&#x7f;730507&#x7f;735517&#x7f;731567&#x7f;735508&#x7f;735050&#x7f;733047&#x7f;735501&#x7f;734001&#x7f;732501&#x7f;731527&#x7f;731540&#x7f;735077&#x7f;733577&#x7f;734508&#x7f;735587&#x7f;730017&#x7f;733007&#x7f;733501&#x7f;730008&#x7f;731048&#x7f;734520&#x7f;730567&#x7f;733588&#x7f;734527&#x7f;735530&#x7f;733557&#x7f;734047&#x7f;735589&#x7f;733549&#x7f;732048&#x7f;734028&#x7f;733548&#x7f;734501&#x7f;731547&#x7f;732067&#x7f;730548&#x7f;731548&#x7f;735568&#x7f;731027&#x7f;733020&#x7f;733027&#x7f;735020&#x7f;730547&#x7f;730560&#x7f;730540&#x7f;735580&#x7f;731520&#x7f;731508&#x7f;733528&#x7f;731020&#x7f;733597&#x7f;730007&#x7f;733570&#x7f;732008&#x7f;733580&#x7f;733590&#x7f;760036&#x7f;762037&#x7f;762520&#x7f;764503&#x7f;760011&#x7f;763001&#x7f;763038&#x7f;760507&#x7f;762501&#x7f;761501&#x7f;760009&#x7f;762017&#x7f;761528&#x7f;760001&#x7f;760024&#x7f;763037&#x7f;760557&#x7f;763517&#x7f;762530&#x7f;761047&#x7f;762047&#x7f;763567&#x7f;760026&#x7f;760538&#x7f;761540&#x7f;762548&#x7f;761038&#x7f;761028&#x7f;762027&#x7f;760518&#x7f;760023&#x7f;760035&#x7f;761558&#x7f;760016&#x7f;764007&#x7f;760010&#x7f;760031&#x7f;760006&#x7f;761048&#x7f;761030&#x7f;762538&#x7f;762517&#x7f;760042&#x7f;764504&#x7f;762021&#x7f;760034&#x7f;761517&#x7f;762547&#x7f;764509&#x7f;763527&#x7f;763557&#x7f;762018&#x7f;760527&#x7f;763578&#x7f;761530&#x7f;763021&#x7f;760014&#x7f;760004&#x7f;760003&#x7f;760044&#x7f;760041&#x7f;763520&#x7f;762527&#x7f;761520&#x7f;764001&#x7f;760517&#x7f;760020&#x7f;763049&#x7f;763550&#x7f;763538&#x7f;762001&#x7f;763008&#x7f;760510&#x7f;762008&#x7f;762007&#x7f;760547&#x7f;762010&#x7f;763558&#x7f;762022&#x7f;762537&#x7f;763029&#x7f;761037&#x7f;761008&#x7f;760550&#x7f;763537&#x7f;760030&#x7f;764517&#x7f;763048&#x7f;763501&#x7f;763047&#x7f;761537&#x7f;763042&#x7f;760529&#x7f;761001&#x7f;762540&#x7f;763028&#x7f;763560&#x7f;761007&#x7f;761020&#x7f;762040&#x7f;763568&#x7f;760002&#x7f;763547&#x7f;763027&#x7f;760050&#x7f;761040&#x7f;763507&#x7f;763532&#x7f;763579&#x7f;760508&#x7f;761557&#x7f;762510&#x7f;763518&#x7f;760040&#x7f;764008&#x7f;763533&#x7f;761527&#x7f;760015&#x7f;760540&#x7f;764507&#x7f;760530&#x7f;761567&#x7f;760013&#x7f;760528&#x7f;760007&#x7f;761550&#x7f;761548&#x7f;760548&#x7f;762030&#x7f;763577&#x7f;760043&#x7f;760022&#x7f;760502&#x7f;763010&#x7f;763510&#x7f;760033&#x7f;761027&#x7f;763022&#x7f;763531&#x7f;760045&#x7f;760501&#x7f;763023&#x7f;763041&#x7f;763508&#x7f;763570&#x7f;760021&#x7f;760008&#x7f;763539&#x7f;760537&#x7f;760520&#x7f;761560&#x7f;762528&#x7f;760012&#x7f;761547&#x7f;764502&#x7f;761507&#x7f;764508&#x7f;760025&#x7f;760032&#x7f;760046&#x7f;764501&#x7f;761508&#x7f;763528&#x7f;763030&#x7f;763007&#x7f;762507&#x7f;761510&#x7f;763017&#x7f;970009&#x7f;971007&#x7f;973008&#x7f;972047&#x7f;973048&#x7f;972048&#x7f;970008&#x7f;972007&#x7f;970007&#x7f;972008&#x7f;970001&#x7f;973047&#x7f;971008&#x7f;972040&#x7f;973001&#x7f;973007&#x7f;990001&#x7f;992009&#x7f;991057&#x7f;992001&#x7f;991059&#x7f;991007&#x7f;991019&#x7f;990009&#x7f;991048&#x7f;992017&#x7f;992018&#x7f;991009&#x7f;995007&#x7f;991001&#x7f;992007&#x7f;991049&#x7f;991047&#x7f;991038&#x7f;990008&#x7f;995008&#x7f;991039&#x7f;990007&#x7f;990018&#x7f;991008&#x7f;991017&#x7f;991027&#x7f;992050&#x7f;991018&#x7f;991058&#x7f;991029&#x7f;992008&#x7f;995009&#x7f;991028&#x7f;991037&#x7f;990017&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ73]' else if (boolean(/cn:CreditNote)) then '[CAJ73]' else if (boolean(/dn:DebitNote)) then '[DAJ73]' else ''"/>
               <xsl:text/>
               <xsl:text>- El elemento PostalZone '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>' no corresponde a un elemento de la tabla</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:IdentificationCode" priority="1001" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;AF&#x7f;AX&#x7f;AL&#x7f;DE&#x7f;AD&#x7f;AO&#x7f;AI&#x7f;AQ&#x7f;AG&#x7f;SA&#x7f;DZ&#x7f;AR&#x7f;AM&#x7f;AW&#x7f;AU&#x7f;AT&#x7f;AZ&#x7f;BS&#x7f;BD&#x7f;BB&#x7f;BH&#x7f;BE&#x7f;BZ&#x7f;BJ&#x7f;BM&#x7f;BY&#x7f;BO&#x7f;BQ&#x7f;BA&#x7f;BW&#x7f;BR&#x7f;BN&#x7f;BG&#x7f;BF&#x7f;BI&#x7f;BT&#x7f;CV&#x7f;KH&#x7f;CM&#x7f;CA&#x7f;QA&#x7f;TD&#x7f;CL&#x7f;CN&#x7f;CY&#x7f;CO&#x7f;KM&#x7f;KP&#x7f;KR&#x7f;CI&#x7f;CR&#x7f;HR&#x7f;CU&#x7f;CW&#x7f;DK&#x7f;DM&#x7f;EC&#x7f;EG&#x7f;SV&#x7f;AE&#x7f;ER&#x7f;SK&#x7f;SI&#x7f;ES&#x7f;US&#x7f;EE&#x7f;ET&#x7f;PH&#x7f;FI&#x7f;FJ&#x7f;FR&#x7f;GA&#x7f;GM&#x7f;GE&#x7f;GH&#x7f;GI&#x7f;GD&#x7f;GR&#x7f;GL&#x7f;GP&#x7f;GU&#x7f;GT&#x7f;GF&#x7f;GG&#x7f;GN&#x7f;GW&#x7f;GQ&#x7f;GY&#x7f;HT&#x7f;HN&#x7f;HK&#x7f;HU&#x7f;IN&#x7f;ID&#x7f;IQ&#x7f;IR&#x7f;IE&#x7f;BV&#x7f;IM&#x7f;CX&#x7f;IS&#x7f;KY&#x7f;CC&#x7f;CK&#x7f;FO&#x7f;GS&#x7f;HM&#x7f;FK&#x7f;MP&#x7f;MH&#x7f;PN&#x7f;SB&#x7f;TC&#x7f;UM&#x7f;VG&#x7f;VI&#x7f;IL&#x7f;IT&#x7f;JM&#x7f;JP&#x7f;JE&#x7f;JO&#x7f;KZ&#x7f;KE&#x7f;KG&#x7f;KI&#x7f;KW&#x7f;LA&#x7f;LS&#x7f;LV&#x7f;LB&#x7f;LR&#x7f;LY&#x7f;LI&#x7f;LT&#x7f;LU&#x7f;MO&#x7f;MK&#x7f;MG&#x7f;MY&#x7f;MW&#x7f;MV&#x7f;ML&#x7f;MT&#x7f;MA&#x7f;MQ&#x7f;MU&#x7f;MR&#x7f;YT&#x7f;MX&#x7f;FM&#x7f;MD&#x7f;MC&#x7f;MN&#x7f;ME&#x7f;MS&#x7f;MZ&#x7f;MM&#x7f;NA&#x7f;NR&#x7f;NP&#x7f;NI&#x7f;NE&#x7f;NG&#x7f;UN&#x7f;NF&#x7f;NO&#x7f;NC&#x7f;NZ&#x7f;OM&#x7f;NL&#x7f;PK&#x7f;PW&#x7f;PS&#x7f;PA&#x7f;PG&#x7f;PY&#x7f;PE&#x7f;PF&#x7f;PL&#x7f;PT&#x7f;PR&#x7f;GB&#x7f;EH&#x7f;CF&#x7f;CZ&#x7f;CG&#x7f;CD&#x7f;DO&#x7f;RE&#x7f;RW&#x7f;RO&#x7f;RU&#x7f;WS&#x7f;AS&#x7f;BL&#x7f;KN&#x7f;SM&#x7f;MF&#x7f;PM&#x7f;VC&#x7f;SH&#x7f;LC&#x7f;ST&#x7f;SN&#x7f;RS&#x7f;SC&#x7f;SL&#x7f;SG&#x7f;SX&#x7f;SY&#x7f;SO&#x7f;LK&#x7f;SZ&#x7f;ZA&#x7f;SD&#x7f;SS&#x7f;SI&#x7f;CH&#x7f;SR&#x7f;SJ&#x7f;TH&#x7f;TW&#x7f;TZ&#x7f;TJ&#x7f;IO&#x7f;TF&#x7f;TL&#x7f;TG&#x7f;TK&#x7f;TO&#x7f;TT&#x7f;TN&#x7f;TM&#x7f;TR&#x7f;TV&#x7f;UA&#x7f;UG&#x7f;UY&#x7f;UZ&#x7f;VU&#x7f;VA&#x7f;VE&#x7f;VN&#x7f;WF&#x7f;YE&#x7f;DJ&#x7f;ZM&#x7f;ZW&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FAJ16]' else if (boolean(/cn:CreditNote)) then '[CAJ16]' else if (boolean(/dn:DebitNote)) then '[DAJ16]' else ''"/>
               <xsl:text/>
               <xsl:text>- El elemento cbc:IdentificationCode '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>'no corresponde a un elemento de la tabla</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>

	  <!--RULE -->
   <xsl:template match="cbc:LossRiskResponsibilityCode " priority="1000" mode="M22">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="( false() or ( contains('&#x7f;CFR&#x7f;CIF&#x7f;CIP&#x7f;CPT&#x7f;DAP&#x7f;DAT&#x7f;DDP&#x7f;EXW&#x7f;FAS&#x7f;FCA&#x7f;FOB&#x7f;',concat('&#x7f;',.,'&#x7f;')) ) ) "/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Fatal:</xsl:text>
               <xsl:text> </xsl:text>
               <xsl:text/>
               <xsl:value-of select="if (boolean(/ubl:Invoice)) then '[FBC04]' else if (boolean(/cn:CreditNote)) then '[CBC04]' else if (boolean(/dn:DebitNote)) then '[DBC04]' else ''"/>
               <xsl:text/>
               <xsl:text>- El elemento cbc:LossRiskResponsibilityCode '</xsl:text>
               <xsl:text/>
               <xsl:value-of select="."/>
               <xsl:text/>
               <xsl:text>'no corresponde a un elemento de la tabla Condiciones de Entrega</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M22"/>
   <xsl:template match="@*|node()" priority="-2" mode="M22">
      <xsl:apply-templates select="@*|node()" mode="M22"/>
   </xsl:template>
</xsl:stylesheet>
