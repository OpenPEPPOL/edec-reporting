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
    2022-04-15, Philip Helger
    initial version
  </p>

  <ns prefix="eur" uri="urn:fdc:peppol:end-user-reporting:1.0"/>

  <pattern id="default">
    <let name="cl_spidtype" value="' CertSubjectCN '"/>

    <rule context="/eur:EndUserReport">
      <assert id="EUR-01" flag="fatal" test="normalize-space(eur:CustomizationID) = 'urn:fdc:peppol.eu:oo:trns:end-user-report:1'"
        >[EUR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:oo:trns:end-user-report:1'</assert>
      <assert id="EUR-02" flag="fatal" test="normalize-space(eur:ProfileID) = 'urn:fdc:peppol.eu:oo:bis:reporting:1'"
        >[EUR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:oo:bis:reporting:1'</assert>
      <assert id="EUR-03" flag="fatal" test="sum(eur:Subtotal/eur:SendingEndUsers) = eur:Total/eur:SendingEndUsers"
        >[EUR-03] The sum of all subtotals of SendingEndUsers should be equal to Totals/SendingEndUsers</assert>
      <assert id="EUR-04" flag="fatal" test="sum(eur:Subtotal/eur:ReceivingEndUsers) = eur:Total/eur:ReceivingEndUsers"
        >[EUR-04] The sum of all subtotals of ReceivingEndUsers should be equal to Totals/ReceivingEndUsers</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:Header">
      <assert id="EUR-05" flag="fatal" test="matches(normalize-space(eur:ReportPeriod), '^[0-9]{4}\-[0-9]{2}$')"
        >[EUR-05] The reporting period (<value-of select="normalize-space(eur:ReportPeriod)"/>) MUST NOT contain timezone information</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:Header/eur:ReporterID">
      <assert id="EUR-06" flag="fatal" test="normalize-space(.) != ''"
        >[EUR-06] The Reporter ID MUST be present</assert>
      <assert id="EUR-07" flag="fatal" test="not(contains(normalize-space(@schemeID), ' ')) and
                                             contains($cl_spidtype, concat(' ', normalize-space(@schemeID), ' '))"
        >[EUR-07] The Reporter ID scheme ID (<value-of select="normalize-space(@schemeID)"/>) MUST be coded according to the code list</assert>
      <assert id="EUR-08" flag="fatal" test="(@schemeID='CertSubjectCN' and
                                              matches(normalize-space(.), '^P[A-Z]{2}[0-9]{6}$')) or 
                                             not(@schemeID='CertSubjectCN')"
        >[EUR-08] The layout of the certificate subject CN (<value-of select="normalize-space(.)"/>) is not a valid Peppol Seat ID</assert>
    </rule>

    <!-- Per Dataset Type and Process ID aggregation -->
    <rule context="/eur:EndUserReport/eur:Subtotal[normalize-space(@type) = 'PerDT-PR']">
      <let name="name" value="'The subtotal per Dataset Type ID and Process ID'"/>
      <assert id="EUR-09" flag="fatal" test="count(eur:Key) = 2"
        >[EUR-09] $name MUST have two Key elements</assert>
      <assert id="EUR-10" flag="fatal" test="count(eur:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
        >[EUR-10] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="EUR-11" flag="fatal" test="count(eur:Key[normalize-space(@metaSchemeID) = 'PR']) = 1"
        >[EUR-11] $name MUST have one Key element with the meta scheme ID 'PR'</assert>
    </rule>

    <rule context="//*[not(*) and not(normalize-space())]">
      <assert id="EUR-12" test="false()" flag="fatal"
      >[EUR-12] The Document MUST not contain empty elements.
      </assert>
    </rule>
  </pattern>
</schema>
