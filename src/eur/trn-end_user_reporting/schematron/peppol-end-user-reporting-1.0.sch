<?xml version="1.0" encoding="iso-8859-1"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding='xslt2'
        schemaVersion="ISO19757-3">
  <title>OpenPeppol End User Report</title>

  <p id="about">
    This is the Schematron for the Peppol End User Reports.
    This is based on the "Internal Regulations" document,
      chapter 4.3 "Service Provider Reporting about End Users"

    Author:
      Philip Helger

    History:
      2022-10-27, Muhammet Yildiz, Philip Helger - updates after the first review
      2022-04-15, Philip Helger - initial version
  </p>

  <ns prefix="eur" uri="urn:fdc:peppol:end-user-report:1.0"/>

  <pattern id="default">
    <let name="cl_spidtype" value="' CertSubjectCN '"/>

    <rule context="/eur:EndUserReport">
      <let name="total" value="eur:Total/eur:SendingEndUsers + eur:Total/eur:ReceivingEndUsers"/>
      <let name="empty" value="$total = 0"/>

      <assert id="SCH-EUR-01" flag="fatal" test="normalize-space(eur:CustomizationID) = 'urn:fdc:peppol.eu:oo:trns:end-user-report:1.0'"
      >[SCH-EUR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:oo:trns:end-user-report:1.0'</assert>
      <assert id="SCH-EUR-02" flag="fatal" test="normalize-space(eur:ProfileID) = 'urn:fdc:peppol.eu:oo:bis:reporting:1.0'"
      >[SCH-EUR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:oo:bis:reporting:1.0'</assert>

      <assert id="SCH-EUR-03" flag="fatal" test="$empty or eur:Subtotal/eur:SendingEndUsers[not(. &lt; ../../eur:Subtotal/eur:SendingEndUsers)][1] &lt;= eur:Total/eur:SendingEndUsers"
      >[SCH-EUR-03] The maximum of all subtotals of SendingEndUsers MUST be lower or equal to Totals/SendingEndUsers</assert>
      <assert id="SCH-EUR-04" flag="fatal" test="$empty or eur:Subtotal/eur:ReceivingEndUsers[not(. &lt; ../../eur:Subtotal/eur:ReceivingEndUsers)][1] &lt;= eur:Total/eur:ReceivingEndUsers"
      >[SCH-EUR-04] The maximum of all subtotals of ReceivingEndUsers MUST be lower or equal to Totals/ReceivingEndUsers</assert>
        
      <!-- Per Dataset Type -->
      <!-- Check Subtotal existence -->
      <assert id="SCH-EUR-15" flag="fatal" test="$empty or eur:Subtotal[normalize-space(@type) = 'PerDT-PR']"
      >[SCH-EUR-15] The subtotals per 'Dataset Type ID and Process ID' MUST exist</assert>
        
      <!-- Global uniqueness check per Key -->
      <assert id="SCH-EUR-13" flag="fatal" test="every $st in (eur:Subtotal[normalize-space(@type) = 'PerDT-PR']),
                                                       $stdt in ($st/eur:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                       $stpr in ($st/eur:Key[normalize-space(@metaSchemeID) = 'PR'])  satisfies
                                                   count(eur:Subtotal[normalize-space(@type) ='PerDT-PR'][every $dt in (eur:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                                                                                $pr in (eur:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies
                                                                                                          concat(normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',
                                                                                                                 normalize-space($pr/@schemeID),'::',normalize-space($pr)) =
                                                                                                          concat(normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',
                                                                                                                 normalize-space($stpr/@schemeID),'::',normalize-space($stpr))]) = 1"
      >[SCH-EUR-13] Each combination of 'Dataset Type ID and Process ID' MUST occur only once.</assert>
        
      <!-- Check that no other types are used -->  
      <assert id="SCH-EUR-14" flag="fatal" test="count(eur:Subtotal[normalize-space(@type) !='PerDT-PR']) = 0"
      >[SCH-EUR-14] Only allowed subtotal types MUST be used.</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:Header">
      <assert id="SCH-EUR-05" flag="fatal" test="matches(normalize-space(eur:ReportPeriod), '^[0-9]{4}\-[0-9]{2}$')"
      >[SCH-EUR-05] The reporting period (<value-of select="normalize-space(eur:ReportPeriod)"/>) MUST NOT contain timezone information</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:Header/eur:ReporterID">
      <assert id="SCH-EUR-06" flag="fatal" test="normalize-space(.) != ''"
      >[SCH-EUR-06] The Reporter ID MUST be present</assert>
      <assert id="SCH-EUR-07" flag="fatal" test="not(contains(normalize-space(@schemeID), ' ')) and
                                                contains($cl_spidtype, concat(' ', normalize-space(@schemeID), ' '))"
      >[SCH-EUR-07] The Reporter ID scheme ID (<value-of select="normalize-space(@schemeID)"/>) MUST be coded according to the code list</assert>
      <assert id="SCH-EUR-08" flag="fatal" test="(@schemeID='CertSubjectCN' and
                                                  matches(normalize-space(.), '^P[A-Z]{2}[0-9]{6}$')) or 
                                                 not(@schemeID='CertSubjectCN')"
      >[SCH-EUR-08] The layout of the certificate subject CN (<value-of select="normalize-space(.)"/>) is not a valid Peppol Seat ID</assert>
    </rule>

    <!-- Per Dataset Type and Process ID aggregation -->
    <rule context="/eur:EndUserReport/eur:Subtotal[normalize-space(@type) = 'PerDT-PR']">
      <let name="name" value="'The subtotal per Dataset Type ID and Process ID'"/>
      <assert id="SCH-EUR-09" flag="fatal" test="count(eur:Key) = 2"
      >[SCH-EUR-09] $name MUST have two Key elements</assert>
      <assert id="SCH-EUR-10" flag="fatal" test="count(eur:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
      >[SCH-EUR-10] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="SCH-EUR-11" flag="fatal" test="count(eur:Key[normalize-space(@metaSchemeID) = 'PR']) = 1"
      >[SCH-EUR-11] $name MUST have one Key element with the meta scheme ID 'PR'</assert>
    </rule>
  </pattern>
</schema>
