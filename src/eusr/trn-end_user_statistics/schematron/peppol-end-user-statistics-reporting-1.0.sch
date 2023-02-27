<?xml version="1.0" encoding="iso-8859-1"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding='xslt2'
        schemaVersion="ISO19757-3">
  <title>OpenPeppol End User Statistics Report</title>

  <p id="about">
    This is the Schematron for the Peppol End User Statistics Reports.
    This is based on the "Internal Regulations" document,
      chapter 4.3 "Service Provider Reporting about End Users"

    Author:
      Philip Helger

    History:
      EUSR RC3
      * 2023-02-27, Philip Helger - updates after second review
      EUSR RC2
      * 2022-11-14, Muhammet Yildiz, Philip Helger - updates after the first review
      EUR RC1
      * 2022-04-15, Philip Helger - initial version
  </p>

  <ns prefix="eusr" uri="urn:fdc:peppol:end-user-statistics-report:1.0"/>

  <pattern id="default">
    <let name="cl_spidtype" value="' CertSubjectCN '"/>

    <rule context="/eusr:EndUserStatisticsReport">
      <let name="total" value="eusr:FullSet/eusr:SendingEndUsers + eusr:FullSet/eusr:ReceivingEndUsers"/>
      <let name="empty" value="$total = 0"/>

      <assert id="SCH-EUSR-01" flag="fatal" test="normalize-space(eusr:CustomizationID) = 'urn:fdc:peppol.eu:edec:trns:end-user-statistics-report:1.0'"
      >[SCH-EUSR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:edec:trns:end-user-statistics-report:1.0'</assert>
      <assert id="SCH-EUSR-02" flag="fatal" test="normalize-space(eusr:ProfileID) = 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'"
      >[SCH-EUSR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:edec:bis:reporting:1.0'</assert>

      <assert id="SCH-EUSR-03" flag="fatal" test="$empty or eusr:Subset/eusr:SendingEndUsers[not(. &lt; ../../eusr:Subset/eusr:SendingEndUsers)][1] &lt;= eusr:FullSet/eusr:SendingEndUsers"
      >[SCH-EUSR-03] The maximum of all subtotals of SendingEndUsers MUST be lower or equal to FullSet/SendingEndUsers</assert>
      <assert id="SCH-EUSR-04" flag="fatal" test="$empty or eusr:Subset/eusr:ReceivingEndUsers[not(. &lt; ../../eusr:Subset/eusr:ReceivingEndUsers)][1] &lt;= eusr:FullSet/eusr:ReceivingEndUsers"
      >[SCH-EUSR-04] The maximum of all subtotals of ReceivingEndUsers MUST be lower or equal to FullSet/ReceivingEndUsers</assert>
      <assert id="SCH-EUSR-22" flag="fatal" test="$empty or eusr:Subset/eusr:SendingOrReceivingEndUsers[not(. &lt; ../../eusr:Subset/eusr:SendingOrReceivingEndUsers)][1] &lt;= eusr:FullSet/eusr:SendingOrReceivingEndUsers"
      >[SCH-EUSR-22] The maximum of all subtotals of SendingOrReceivingEndUsers MUST be lower or equal to FullSet/SendingOrReceivingEndUsers</assert>

      <assert id="SCH-EUSR-19" flag="fatal" test="eusr:FullSet/eusr:SendingOrReceivingEndUsers &lt;= $total"
      >[SCH-EUSR-19] The total number of total SendingOrReceivingEndUsers (<value-of select="eusr:FullSet/eusr:SendingOrReceivingEndUsers"/>) MUST be lower or equal to the sum of the total SendingEndUsers and total ReceivingEndUsers</assert>
      <assert id="SCH-EUSR-20" flag="fatal" test="eusr:FullSet/eusr:SendingOrReceivingEndUsers &gt;= eusr:FullSet/eusr:SendingEndUsers"
      >[SCH-EUSR-20] The total number of total SendingOrReceivingEndUsers (<value-of select="eusr:FullSet/eusr:SendingOrReceivingEndUsers"/>) MUST be greater or equal to number of total SendingEndUsers (<value-of select="eusr:FullSet/eusr:SendingEndUsers"/>)</assert>
      <assert id="SCH-EUSR-21" flag="fatal" test="eusr:FullSet/eusr:SendingOrReceivingEndUsers &gt;= eusr:FullSet/eusr:ReceivingEndUsers"
      >[SCH-EUSR-21] The total number of total SendingOrReceivingEndUsers (<value-of select="eusr:FullSet/eusr:SendingOrReceivingEndUsers"/>) MUST be greater or equal to number of total ReceivingEndUsers (<value-of select="eusr:FullSet/eusr:ReceivingEndUsers"/>)</assert>

      <!-- Per Dataset Type -->
      <!-- Check Subset existence -->
      <assert id="SCH-EUSR-15" flag="fatal" test="$empty or eusr:Subset[normalize-space(@type) = 'PerDT-PR']"
      >[SCH-EUSR-15] The subtotals per 'Dataset Type ID and Process ID' MUST exist</assert>
        
      <!-- Global uniqueness check per Key -->
      <assert id="SCH-EUSR-13" flag="fatal" test="every $st in (eusr:Subset[normalize-space(@type) = 'PerDT-PR']),
                                                        $stdt in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                        $stpr in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'PR'])  satisfies
                                                    count(eusr:Subset[normalize-space(@type) ='PerDT-PR'][every $dt in (eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                                                                                $pr in (eusr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies
                                                                                                          concat(normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',
                                                                                                                 normalize-space($pr/@schemeID),'::',normalize-space($pr)) =
                                                                                                          concat(normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',
                                                                                                                 normalize-space($stpr/@schemeID),'::',normalize-space($stpr))]) = 1"
      >[SCH-EUSR-13] Each combination of 'Dataset Type ID and Process ID' MUST occur only once.</assert>

      <assert id="SCH-EUSR-29" flag="fatal" test="every $st in (eusr:Subset[normalize-space(@type) = 'PerDT-PR-CC']),
                                                        $stdt in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                        $stpr in ($st/eusr:Key[normalize-space(@metaSchemeID) = 'PR']),
                                                        $stsc in ($st/eusr:Key[normalize-space(@schemeID) = 'SenderCountry']),
                                                        $strc in ($st/eusr:Key[normalize-space(@schemeID) = 'ReceiverCountry'])  satisfies
                                                    count(eusr:Subset[normalize-space(@type) ='PerDT-PR-CC'][every $dt in (eusr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                                                                                   $pr in (eusr:Key[normalize-space(@metaSchemeID) = 'PR']),
                                                                                                                   $sc in (eusr:Key[normalize-space(@schemeID) = 'SenderCountry']),
                                                                                                                   $rc in (eusr:Key[normalize-space(@schemeID) = 'ReceiverCountry']) satisfies
                                                                                                             concat(normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',
                                                                                                                    normalize-space($pr/@schemeID),'::',normalize-space($pr),'::',
                                                                                                                    normalize-space($sc),'::',
                                                                                                                    normalize-space($rc)) =
                                                                                                             concat(normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',
                                                                                                                    normalize-space($stpr/@schemeID),'::',normalize-space($stpr),'::',
                                                                                                                    normalize-space($sc),'::',
                                                                                                                    normalize-space($rc))]) = 1"
      >[SCH-EUSR-29] Each combination of 'Dataset Type ID, Process ID, Sender Country and Receiver Country' MUST occur only once.</assert>
        
      <!-- Check that no other types are used -->  
      <assert id="SCH-EUSR-14" flag="fatal" test="count(eusr:Subset[normalize-space(@type) !='PerDT-PR' and 
                                                                    normalize-space(@type) !='PerDT-PR-CC']) = 0"
      >[SCH-EUSR-14] Only allowed subtotal types MUST be used.</assert>
    </rule>

    <rule context="/eusr:EndUserStatisticsReport/eusr:Header">
      <assert id="SCH-EUSR-16" flag="fatal" test="matches(normalize-space(eusr:ReportPeriod/eusr:StartDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')"
      >[SCH-EUSR-16] The reporting period start date (<value-of select="normalize-space(eusr:ReportPeriod/eusr:StartDate)"/>) MUST NOT contain timezone information</assert>
      <assert id="SCH-EUSR-17" flag="fatal" test="matches(normalize-space(eusr:ReportPeriod/eusr:EndDate), '^[0-9]{4}\-[0-9]{2}\-[0-9]{2}$')"
      >[SCH-EUSR-17] The reporting period end date (<value-of select="normalize-space(eusr:ReportPeriod/eusr:EndDate)"/>) MUST NOT contain timezone information</assert>
      <!-- Note: the effective report period length is checked somewhere else -->
      <assert id="SCH-EUSR-18" flag="fatal" test="eusr:ReportPeriod/eusr:EndDate &gt;= eusr:ReportPeriod/eusr:StartDate"
      >[SCH-EUSR-18] The report period start date (<value-of select="normalize-space(eusr:ReportPeriod/eusr:StartDate)"/>) MUST NOT be after the report period end date (<value-of select="normalize-space(eusr:ReportPeriod/eusr:EndDate)"/>)</assert>
    </rule>

    <rule context="/eusr:EndUserStatisticsReport/eusr:Header/eusr:ReporterID">
      <assert id="SCH-EUSR-06" flag="fatal" test="normalize-space(.) != ''"
      >[SCH-EUSR-06] The Reporter ID MUST be present</assert>
      <assert id="SCH-EUSR-07" flag="fatal" test="not(contains(normalize-space(@schemeID), ' ')) and
                                                  contains($cl_spidtype, concat(' ', normalize-space(@schemeID), ' '))"
      >[SCH-EUSR-07] The Reporter ID scheme ID (<value-of select="normalize-space(@schemeID)"/>) MUST be coded according to the code list</assert>
      <assert id="SCH-EUSR-08" flag="fatal" test="(@schemeID='CertSubjectCN' and
                                                   matches(normalize-space(.), '^P[A-Z]{2}[0-9]{6}$')) or 
                                                  not(@schemeID='CertSubjectCN')"
      >[SCH-EUSR-08] The layout of the certificate subject CN (<value-of select="normalize-space(.)"/>) is not a valid Peppol Seat ID</assert>
    </rule>

    <!-- Per Dataset Type and Process ID aggregation -->
    <rule context="/eusr:EndUserStatisticsReport/eusr:Subset[normalize-space(@type) = 'PerDT-PR']">
      <let name="name" value="'The subtotal per Dataset Type ID and Process ID'"/>
      
      <assert id="SCH-EUSR-09" flag="fatal" test="count(eusr:Key) = 2"
      >[SCH-EUSR-09] $name MUST have two Key elements</assert>
      <assert id="SCH-EUSR-10" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
      >[SCH-EUSR-10] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="SCH-EUSR-11" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1"
      >[SCH-EUSR-11] $name MUST have one Key element with the meta scheme ID 'PR'</assert>
    </rule>

    <!-- Per Dataset Type, Process ID, Sender Country and Receiver Country aggregation -->
    <rule context="/eusr:EndUserStatisticsReport/eusr:Subset[normalize-space(@type) = 'PerDT-PR-CC']">
      <let name="name" value="'The subtotal per Dataset Type ID, Process ID, Sender Country and Receiver Country'"/>
      
      <assert id="SCH-EUSR-23" flag="fatal" test="count(eusr:Key) = 4"
      >[SCH-EUSR-23] $name MUST have four Key elements</assert>
      <assert id="SCH-EUSR-24" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
      >[SCH-EUSR-24] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="SCH-EUSR-25" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1"
      >[SCH-EUSR-25] $name MUST have one Key element with the meta scheme ID 'PR'</assert>
      <assert id="SCH-EUSR-26" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'CC']) = 2"
      >[SCH-EUSR-26] $name MUST have two Key elements with the meta scheme ID 'CC'</assert>
      <assert id="SCH-EUSR-27" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'SenderCountry']) = 1"
      >[SCH-EUSR-27] $name MUST have one CC Key element with the scheme ID 'SenderCountry'</assert>
      <assert id="SCH-EUSR-28" flag="fatal" test="count(eusr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'ReceiverCountry']) = 1"
      >[SCH-EUSR-28] $name MUST have one CC Key element with the scheme ID 'ReceiverCountry'</assert>
    </rule>
  </pattern>
</schema>
