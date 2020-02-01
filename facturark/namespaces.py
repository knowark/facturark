class NameSpaces:
    def __init__(self):
        # self.fe = "http://www.dian.gov.co/contratos/facturaelectronica/v1"

        self.cac = ("urn:oasis:names:specification:ubl:"
                    "schema:xsd:CommonAggregateComponents-2")
        self.cbc = ("urn:oasis:names:specification:ubl:"
                    "schema:xsd:CommonBasicComponents-2")
        self.clm54217 = ("urn:un:unece:uncefact:codelist:"
                         "specification:54217:2001")
        self.clm66411 = ("urn:un:unece:uncefact:codelist:"
                         "specification:66411:2001")
        self.clmIANAMIMEMediaType = ("urn:un:unece:uncefact:codelist:"
                                     "specification:IANAMIMEMediaType:2003")
        self.ext = ("urn:oasis:names:specification:ubl:"
                    "schema:xsd:CommonExtensionComponents-2")
        self.qdt = ("urn:oasis:names:specification:ubl:"
                    "schema:xsd:QualifiedDatatypes-2")
        self.sts = "dian:gov:co:facturaelectronica:Structures-2-1"
        self.udt = ("urn:un:unece:uncefact:data:"
                    "specification:UnqualifiedDataTypesSchemaModule:2")
        self.xsi = "http://www.w3.org/2001/XMLSchema-instance"
        self.ds = "http://www.w3.org/2000/09/xmldsig#"
        self.xades = "http://uri.etsi.org/01903/v1.3.2#"
        self.xades141 = "http://uri.etsi.org/01903/v1.4.1#"


NS = NameSpaces()
