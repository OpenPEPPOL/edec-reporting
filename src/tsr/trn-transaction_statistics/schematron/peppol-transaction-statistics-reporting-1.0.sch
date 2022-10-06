<?xml version="1.0" encoding="iso-8859-1"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
        queryBinding='xslt2'
        schemaVersion="ISO19757-3">
  <title>OpenPeppol Transaction Statistics Reporting</title>

  <p id="about">
    This is the Schematron for the Peppol Transaction Statistics Reporting
    This is based on the "Internal Regulations" document,
    chapter 4.4 "Service Provider Reporting on Transaction Statistics"

    Author:
    Philip Helger

    History:
    2022-04-21, Philip Helger
    initial version
  </p>

  <ns prefix="tsr" uri="urn:fdc:peppol:transaction-statistics-reporting:1.0"/>

  <pattern id="default">
    <let name="cl_iso3166" value="' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW '"/>
    <let name="cl_spidtype" value="' CertSubjectCN '"/>
    <let name="cl_subtotalType" value="' PerTP PerSP-DT-PR PerSP-DT-PR-CC '"/>
    <let name="re_seatid" value="'^P[A-Z]{2}[0-9]{6}$'"/>

    <rule context="/tsr:TransactionStatisticsReport">
      <let name="total" value="tsr:Total/tsr:Incoming + tsr:Total/tsr:Outgoing"/>
      <let name="empty" value="$total = 0"/>

      <assert id="TSR-01" flag="fatal" test="normalize-space(tsr:CustomizationID) = 'urn:fdc:peppol.eu:oo:trns:transaction-statistics-reporting:1'"
        >[TSR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:oo:trns:transaction-statistics-reporting:1'</assert>
      <assert id="TSR-02" flag="fatal" test="normalize-space(tsr:ProfileID) = 'urn:fdc:peppol.eu:oo:bis:reporting:1'"
        >[TSR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:oo:bis:reporting:1'</assert>

      <!-- Per Transport Protocol -->
      <!-- Check Subtotal existence -->
      <let name="name_tp" value="'Transport Protocol ID'"/>
      <assert id="TSR-03" flag="fatal" test="$empty or tsr:Subtotal[normalize-space(@type) = 'PerTP']"
        >[TSR-03] The subtotals per $name_tp are missing</assert>
        
      <!-- Check Subtotal sums -->
      <assert id="TSR-04" flag="fatal" test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Incoming) = tsr:Total/tsr:Incoming"
        >[TSR-04] The sum of all subtotals per $name_tp incoming MUST match the total incoming count</assert>
      <assert id="TSR-05" flag="fatal" test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Outgoing) = tsr:Total/tsr:Outgoing"
        >[TSR-05] The sum of all subtotals per $name_tp outgoing MUST match the total outgoing count</assert>

      <!-- Global uniqueness check per Key -->
      <assert id="TSR-06" flag="fatal" test="every $key in (tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Key) satisfies 
                                               count(tsr:Subtotal[normalize-space(@type) = 'PerTP']/tsr:Key[concat(normalize-space(@schemeID),'::',normalize-space(.)) = 
                                                                                                            concat(normalize-space($key/@schemeID),'::',normalize-space($key))]) = 1"
        >[TSR-06] Each $name_tp MUST occur only once.</assert>

      <!-- Per Service Provider and Dataset Type -->
      <let name="name_spdtpr" value="'Service Provider ID, Dataset Type ID and Process ID'" />
      <assert id="TSR-07" flag="fatal" test="$empty or tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']"
        >[TSR-07] The subtotals per $name_spdtpr are missing</assert>
      <assert id="TSR-08" flag="fatal" test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']/tsr:Incoming) = tsr:Total/tsr:Incoming"
        >[TSR-08] The sum of all subtotals per $name_spdtpr incoming MUST match the total incoming count</assert>
      <assert id="TSR-09" flag="fatal" test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']/tsr:Outgoing) = tsr:Total/tsr:Outgoing"
        >[TSR-09] The sum of all subtotals per $name_spdtpr outgoing MUST match the total outgoing count</assert>
      <assert id="TSR-10" flag="fatal" test="every $st in (tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']),
                                                   $stsp in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'SP']),
                                                   $stdt in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                   $stpr in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'PR'])  satisfies
                                               count(tsr:Subtotal[normalize-space(@type) ='PerSP-DT-PR'][every $sp in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']),
                                                                                                               $dt in (tsr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                                                                               $pr in (tsr:Key[normalize-space(@metaSchemeID) = 'PR']) satisfies
                                                                                                         concat(normalize-space($sp/@schemeID),'::',normalize-space($sp),'::',
                                                                                                                normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',
                                                                                                                normalize-space($pr/@schemeID),'::',normalize-space($pr)) =
                                                                                                         concat(normalize-space($stsp/@schemeID),'::',normalize-space($stsp),'::',
                                                                                                                normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',
                                                                                                                normalize-space($stpr/@schemeID),'::',normalize-space($stpr))]) = 1"
        >[TSR-10] Each combination of $name_spdtpr MUST occur only once.</assert>

      <!-- Per Service Provider and Dataset Type and Country to Country-->
      <let name="name_spdtprcc" value="'Service Provider ID, Dataset Type ID, Process ID, Sender Country and Receiver Country'"/>
      <assert id="TSR-11" flag="warning" test="$empty or tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']"
        >[TSR-11] The subtotals per $name_spdtprcc are missing</assert>
      <assert id="TSR-12" flag="warning" test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']/tsr:Incoming) = tsr:Total/tsr:Incoming"
        >[TSR-12] The sum of all subtotals per $name_spdtprcc incoming MUST match the total incoming count</assert>
      <assert id="TSR-13" flag="warning" test="$empty or sum(tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']/tsr:Outgoing) = tsr:Total/tsr:Outgoing"
        >[TSR-13] The sum of all subtotals per $name_spdtprcc outgoing MUST match the total outgoing count</assert>
      <assert id="TSR-14" flag="fatal" test="every $st in (tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']),
                                                   $stsp in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'SP']),
                                                   $stdt in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                   $stpr in ($st/tsr:Key[normalize-space(@metaSchemeID) = 'PR']),
                                                   $stsc in ($st/tsr:Key[normalize-space(@schemeID) = 'SenderCountry']),
                                                   $strc in ($st/tsr:Key[normalize-space(@schemeID) = 'ReceiverCountry']) satisfies 
                                               count(tsr:Subtotal[normalize-space(@type) ='PerSP-DT-PR-CC'][every $sp in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']),
                                                                                                                  $dt in (tsr:Key[normalize-space(@metaSchemeID) = 'DT']),
                                                                                                                  $pr in (tsr:Key[normalize-space(@metaSchemeID) = 'PR']),
                                                                                                                  $sc in (tsr:Key[normalize-space(@schemeID) = 'SenderCountry']),
                                                                                                                  $rc in (tsr:Key[normalize-space(@schemeID) = 'ReceiverCountry']) satisfies
                                                                                                            concat(normalize-space($sp/@schemeID),'::',normalize-space($sp),'::',
                                                                                                                   normalize-space($dt/@schemeID),'::',normalize-space($dt),'::',
                                                                                                                   normalize-space($pr/@schemeID),'::',normalize-space($pr),'::',
                                                                                                                   normalize-space($sc),'::',normalize-space($rc)) = 
                                                                                                            concat(normalize-space($stsp/@schemeID),'::',normalize-space($stsp),'::',
                                                                                                                   normalize-space($stdt/@schemeID),'::',normalize-space($stdt),'::',
                                                                                                                   normalize-space($stpr/@schemeID),'::',normalize-space($stpr),'::',
                                                                                                                   normalize-space($stsc),'::',normalize-space($strc))]) = 1"
        >[TSR-14] Each combination of $name_spdtprcc MUST occur only once.</assert>
    </rule>

    <rule context="/tsr:TransactionStatisticsReport/tsr:Header">
      <assert id="TSR-15" flag="fatal" test="matches(normalize-space(tsr:ReportPeriod), '^[0-9]{4}\-[0-9]{2}$')"
        >[TSR-15] The report period (<value-of select="normalize-space(tsr:ReportPeriod)"/>) MUST NOT contain timezone information</assert>
    </rule>

    <rule context="/tsr:TransactionStatisticsReport/tsr:Header/tsr:ReporterID">
      <assert id="TSR-16" flag="fatal" test="normalize-space(.) != ''"
        >[TSR-16] The reporter ID MUST be present</assert>
      <assert id="TSR-17" flag="fatal" test="not(contains(normalize-space(@schemeID), ' ')) and 
                                             contains($cl_spidtype, concat(' ', normalize-space(@schemeID), ' '))"
        >[TSR-17] The Reporter ID scheme (<value-of select="normalize-space(@schemeID)"/>) MUST be coded according to the code list</assert>
      <assert id="TSR-18" flag="fatal" test="(@schemeID='CertSubjectCN' and 
                                              matches(normalize-space(.), $re_seatid)) or 
                                             not(@schemeID='CertSubjectCN')"
        >[TSR-18] The layout of the certificate subject CN (<value-of select="normalize-space(.)"/>) is not a valid Peppol Seat ID</assert>
    </rule>

    <!-- Make this check outside to ensure it works for different subtotals -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal/tsr:Key[normalize-space(@schemeID) = 'CertSubjectCN']">
      <assert id="TSR-19" flag="fatal" test="matches(normalize-space(.), $re_seatid)"
        >[TSR-19] The layout of the certificate subject CN is not a valid Peppol Seat ID</assert>
    </rule>

    <!-- Make this check outside to ensure it works for different subtotals -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal/tsr:Key[normalize-space(@schemeID) = 'SenderCountry' or 
                                                                         normalize-space(@schemeID) = 'ReceiverCountry']">
      <assert id="TSR-20" flag="fatal" test="not(contains(normalize-space(.), ' ')) and 
                                                contains($cl_iso3166, concat(' ', normalize-space(.), ' '))"
        >[TSR-20] The country code MUST be coded with ISO code ISO 3166-1 alpha-2. Nevertheless, Greece may use the code 'EL', Kosovo may use the code 'XK'.</assert>
    </rule>

    <!-- Per Transport Protocol aggregation -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerTP']">
      <let name="name" value="'The subtotal per Transport Protocol ID'"/>
      <assert id="TSR-21" flag="fatal" test="count(tsr:Key) = 1"
        >[TSR-21] $name MUST have one Key element</assert>
      <assert id="TSR-22" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'TP']) = 1"
        >[TSR-22] $name MUST have one Key element with the meta scheme ID 'TP'</assert>
      <assert id="TSR-23" flag="fatal" test="count(tsr:Key[normalize-space(@schemeID) = 'Peppol']) = 1"
        >[TSR-23] $name MUST have one Key element with the scheme ID 'Peppol'</assert>
    </rule>

    <!-- Per Service Provider and DatasetType aggregation -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR']">
      <let name="name" value="'The subtotal per Service Provider ID, Dataset Type ID and Process ID'"/>
      <assert id="TSR-24" flag="fatal" test="count(tsr:Key) = 3"
        >[TSR-24] $name MUST have three Key elements</assert>
      <assert id="TSR-25" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'SP']) = 1"
        >[TSR-25] $name MUST have one Key element with the meta scheme ID 'SP'</assert>
      <assert id="TSR-26" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
        >[TSR-26] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="TSR-27" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1"
        >[TSR-27] $name MUST have one Key element with the meta scheme ID 'PR'</assert>
      <assert id="TSR-28" flag="fatal" test="every $x in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']) satisfies
                                               not(contains(normalize-space($x/@schemeID), ' ')) and 
                                               contains($cl_spidtype, concat(' ', normalize-space($x/@schemeID), ' '))"
        >[TSR-28] $name MUST have one SP Key element with the scheme ID coded according to the code list</assert>
    </rule>

    <!-- Per Service Provider and DatasetType and Countries aggregation -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[normalize-space(@type) = 'PerSP-DT-PR-CC']">
      <let name="name" value="'The subtotal per Service Provider ID, Dataset Type ID, Sender Country and Receiver Country'"/>
      <assert id="TSR-29" flag="fatal" test="count(tsr:Key) = 5"
        >[TSR-29] $name MUST have five Key elements</assert>
      <assert id="TSR-30" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'SP']) = 1"
        >[TSR-30] $name MUST have one Key element with the meta scheme ID 'SP'</assert>
      <assert id="TSR-31" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'DT']) = 1"
        >[TSR-31] $name MUST have one Key element with the meta scheme ID 'DT'</assert>
      <assert id="TSR-32" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'PR']) = 1"
        >[TSR-32] $name MUST have one Key element with the meta scheme ID 'PR'</assert>
      <assert id="TSR-33" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC']) = 2"
        >[TSR-33] $name MUST have two Key elements with the meta scheme ID 'CC'</assert>
      <assert id="TSR-34" flag="fatal" test="every $x in (tsr:Key[normalize-space(@metaSchemeID) = 'SP']) satisfies
                                               not(contains(normalize-space($x/@schemeID), ' ')) and 
                                               contains($cl_spidtype, concat(' ', normalize-space($x/@schemeID), ' '))"
        >[TSR-34] $name MUST have one SP Key element with the scheme ID coded according to the code list</assert>
      <assert id="TSR-35" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'SenderCountry']) = 1"
        >[TSR-35] $name MUST have one CC Key element with the scheme ID 'SenderCountry'</assert>
      <assert id="TSR-36" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC'][normalize-space(@schemeID) = 'ReceiverCountry']) = 1"
        >[TSR-36] $name MUST have one CC Key element with the scheme ID 'ReceiverCountry'</assert>
    </rule>

    <!-- After all the specific Subtotals -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal">
      <assert id="TSR-37" flag="fatal" test="not(contains(normalize-space(@type), ' ')) and
                                             contains($cl_subtotalType, concat(' ', normalize-space(@type), ' '))"
        >[TSR-37] The Subtotal type (<value-of select="normalize-space(@type)"/>) MUST be coded according to the code list</assert>
    </rule>
  </pattern>
</schema>
