Composers
---------

.. digraph:: foo

   "Invoice"
   "CreditNote"
   "DebitNote"
   "SupplierParty"
   "CustomerParty"
   "Party"
   "Location"
   "Address"
   "PartyTaxScheme"
   "PartyLegalEntity"
   "Person"
   "AllowanceCharge"
   "Payment"
   "TaxTotal"
   "MonetaryTotal"
   "TaxSubtotal"
   "Delivery"
   "Despatch"
   "DeliveryTerms"
   "InvoiceLine"
   "Item"
   "Price"

   // Invoice
   "Invoice" -> "SupplierParty";
   "Invoice" -> "CustomerParty";
   "Invoice" -> "Delivery";
   "Invoice" -> "DeliveryTerms";
   "Invoice" -> "Payment";
   "Invoice" -> "AllowanceCharge";
   "Invoice" -> "TaxTotal";
   "Invoice" -> "MonetaryTotal";
   "Invoice" -> "InvoiceLine";

   // Credit Note
   "CreditNote" -> "SupplierParty";
   "CreditNote" -> "CustomerParty";
   "CreditNote" -> "Payment";
   "CreditNote" -> "TaxTotal";
   "CreditNote" -> "MonetaryTotal";
   "CreditNote" -> "InvoiceLine";
   
   // Debit Note
   "DebitNote" -> "SupplierParty";
   "DebitNote" -> "CustomerParty";
   "DebitNote" -> "Payment";
   "DebitNote" -> "TaxTotal";
   "DebitNote" -> "MonetaryTotal";
   "DebitNote" -> "InvoiceLine";

   // Supplier Party
   "SupplierParty" -> "Party";

   // Customer Party
   "CustomerParty" -> "Party";

   // Party
   "Party" -> "Location";
   "Party" -> "PartyTaxScheme";
   "Party" -> "PartyLegalEntity";
   "Party" -> "Person";

   // Location
   "Location" -> "Address";

   // TaxTotal
   "TaxTotal" -> "TaxSubtotal";

   // Delivery
   "Delivery" -> "Address";
   "Delivery" -> "Location";
   "Delivery" -> "Party";
   "Delivery" -> "Despatch";

   // Delivery
   "Despatch" -> "Address";
   "Despatch" -> "Party";

   // Invoice Line
   "InvoiceLine" -> "Item";
   "InvoiceLine" -> "Price";


