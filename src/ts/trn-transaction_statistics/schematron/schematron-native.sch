<schema queryBinding="xslt2" schemaVersion="iso" xmlns="http://purl.oclc.org/dsdl/schematron">
  <title>Natively written schematron rules</title>
  <ns prefix="xmldsig" uri="http://www.w3.org/2000/09/xmldsig#"/>
  <ns prefix="xsi" uri="http://www.w3.org/2001/XMLSchema-instance"/>
  <ns prefix="ts" uri="urn:peppol:transaction-statistics:1.0"/>

<pattern id="cardinalities">
  <rule context="ts:TransactionStatistics">
    <assert flag="fatal" id="CRD-00001" test="ts:Header[1] and not(ts:Header[2])">Only and only one instance of xs:Header is allowed.</assert>
  </rule>
  </pattern>
</schema>
