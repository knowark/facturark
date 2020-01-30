<?xml version="1.0" encoding="UTF-8"?>
<!-- 
            DIAN UBL 2.1 Validaciones. 
            Created by Eric Van Boxsom
            Timestamp: 2019-06-24 15:55:57 -0300
            Version: 3.0
     -->
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
  xmlns:ubl="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"
  xmlns:cn="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"
  xmlns:dn="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2"
  xmlns:app="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"
  xmlns:ext="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"
  xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
  xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
  xmlns:sts="dian:gov:co:facturaelectronica:Structures-2-1"
  xmlns:ds="http://www.w3.org/2000/09/xmldsig#"
  xmlns:xades="http://uri.etsi.org/01903/v1.3.2#"
  xmlns:xades141="http://uri.etsi.org/01903/v1.4.1#" queryBinding="xslt3">
  <title>DIAN UBL2.1 Reglas de Validación</title>
  <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema"/>
  <ns prefix="ubl" uri="urn:oasis:names:specification:ubl:schema:xsd:Invoice-2"/>
  <ns prefix="cn" uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2"/>
  <ns prefix="dn" uri="urn:oasis:names:specification:ubl:schema:xsd:DebitNote-2"/>
  <ns prefix="app" uri="urn:oasis:names:specification:ubl:schema:xsd:ApplicationResponse-2"/>
  <ns prefix="ext" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2"/>
  <ns prefix="cbc" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"/>
  <ns prefix="cac" uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"/>
  <ns prefix="qdt" uri="urn:oasis:names:specification:ubl:schema:xsd:QualifiedDataTypes-2"/>
  <ns prefix="udt" uri="urn:oasis:names:specification:ubl:schema:xsd:UnqualifiedDataTypes-2"/>
  <ns prefix="sts" uri="dian:gov:co:facturaelectronica:Structures-2-1"/>
  <ns prefix="ds" uri="http://www.w3.org/2000/09/xmldsig#"/>
  <ns prefix="xades" uri="http://uri.etsi.org/01903/v1.3.2#"/>
  <ns prefix="xades141" uri="http://uri.etsi.org/01903/v1.4.1#"/>
  <!-- Validaciones de conformidad UBL 2.1-->
  <!-- ======================= -->
  <phase id="UBL21_Structure_check">
    <active pattern="UBL21-structure1"/>
    <active pattern="UBL21-structure2"/>
    <active pattern="UBL21-structure3"/>
  </phase>
  <!-- Validaciones de las reglas UBL 2.1 DIAN -->
  <!-- ======================= -->
  <phase id="DIAN_UBL21-model_phase">
    <active pattern="UBL-model"/>
  </phase>
  <!-- Validaciones de las Listas de valores -->
  <!-- ======================== -->
  <phase id="codelist_phase">
    <active pattern="ListaCodigos"/>
  </phase>
  <!-- Inclusión de las hojas de validación -->
  <include href="UBL21/UBL21-Structure1.sch"/>
  <include href="UBL21/UBL21-Structure2.sch"/>
  <include href="UBL21/UBL21-Structure3.sch"/>
  <include href="UBL21/DIAN-UBL21-model.sch"/>
  <include href="listacodigos/DIAN_UBL21-listacodigos_v2.0.sch"/>
</schema>
