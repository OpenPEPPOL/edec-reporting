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
      2022-04-14, Philip Helger
        initial version
  </p>

  <ns prefix="tsr" uri="urn:fdc:peppol:transaction-statistics-reporting:1.0" />

  <pattern id="default">
    <let name="cl_iso3166" value="' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW '" />
    <let name="cl_ridtype" value="' CertSubjectCN '" />
    <let name="cl_subtotalType" value="' PerSP PerDatasetType PerTP PerCountryToCountry '" />
    <let name="re_seatid" value="'^P[A-Z]{2}[0-9]{6}$'" />
 
    <rule context="/tsr:TransactionStatisticsReport">
      <let name="total" value="tsr:Total/tsr:Incoming + tsr:Total/tsr:Outgoing" />
      <let name="empty" value="$total = 0" />
      
      <assert id="BR-TSR-01" flag="fatal" test="normalize-space(tsr:CustomizationID) = 'urn:fdc:peppol.eu:oo:trns:transaction-statistics-reporting:1'"
        >[BR-TSR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:oo:trns:transaction-statistics-reporting:1'</assert>
      <assert id="BR-TSR-02" flag="fatal" test="normalize-space(tsr:ProfileID) = 'urn:fdc:peppol.eu:oo:bis:reporting:1'"
        >[BR-TSR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:oo:bis:reporting:1'</assert>
        
      <!-- Check Subtotal existence -->  
      <assert id="BR-TSR-10" flag="fatal" test="$empty or tsr:Subtotal[@type='PerSP']"
        >[BR-TSR-10] The subtotals aggregated by Service Provider ID are missing</assert>
      <!-- Check Subtotal sums -->
      <assert id="BR-TSR-11" flag="fatal" test="$empty or sum(tsr:Subtotal[@type='PerSP']/tsr:Incoming) = tsr:Total/tsr:Incoming"
        >[BR-TSR-11] The sum of all subtotal aggregated per Service Provider ID incoming MUST match the total incoming count</assert>
      <assert id="BR-TSR-12" flag="fatal" test="$empty or sum(tsr:Subtotal[@type='PerSP']/tsr:Outgoing) = tsr:Total/tsr:Outgoing"
        >[BR-TSR-12] The sum of all subtotal aggregated per Service Provider ID outgoing MUST match the total outgoing count</assert>
      <!-- Global uniqueness check per Key -->
      <assert id="BR-TSR-13" flag="fatal" test="every $x in (tsr:Subtotal[@type='PerSP']/tsr:Key) satisfies 
                                                 count(tsr:Subtotal[@type='PerSP']/tsr:Key[concat(normalize-space(@schemeID),'::',normalize-space(.)) = 
                                                                                           concat(normalize-space($x/@schemeID),'::',normalize-space($x))]) = 1"
        >[BR-TSR-13] Each Service Provider ID MUST occur only once.</assert>

      <!-- Check Subtotal existence -->  
      <assert id="BR-TSR-14" flag="fatal" test="$empty or tsr:Subtotal[@type='PerDatasetType']"
        >[BR-TSR-14] The subtotals aggregated by Dataset Type ID are missing</assert>
      <!-- Check Subtotal sums -->
      <assert id="BR-TSR-15" flag="fatal" test="$empty or sum(tsr:Subtotal[@type='PerDatasetType']/tsr:Incoming) = tsr:Total/tsr:Incoming"
        >[BR-TSR-15] The sum of all subtotal aggregated per Dataset Type ID incoming MUST match the total incoming count</assert>
      <assert id="BR-TSR-16" flag="fatal" test="$empty or sum(tsr:Subtotal[@type='PerDatasetType']/tsr:Outgoing) = tsr:Total/tsr:Outgoing"
        >[BR-TSR-16] The sum of all subtotal aggregated per Dataset Type ID outgoing MUST match the total outgoing count</assert>
      <!-- Global uniqueness check per Key -->
      <assert id="BR-TSR-17" flag="fatal" test="every $x in (tsr:Subtotal[@type='PerDatasetType']/tsr:Key) satisfies 
                                                 count(tsr:Subtotal[@type='PerDatasetType']/tsr:Key[concat(normalize-space(@schemeID),'::',normalize-space(.)) = 
                                                                                                    concat(normalize-space($x/@schemeID),'::',normalize-space($x))]) = 1"
        >[BR-TSR-17] Each Dataset Type ID MUST occur only once.</assert>

      <!-- Check Subtotal existence -->  
      <assert id="BR-TSR-18" flag="fatal" test="$empty or tsr:Subtotal[@type='PerTP']"
        >[BR-TSR-18] The subtotals aggregated by Transport Protocol ID are missing</assert>
      <!-- Check Subtotal sums -->
      <assert id="BR-TSR-19" flag="fatal" test="$empty or sum(tsr:Subtotal[@type='PerTP']/tsr:Incoming) = tsr:Total/tsr:Incoming"
        >[BR-TSR-19] The sum of all subtotal aggregated per Transport Protocol ID incoming MUST match the total incoming count</assert>
      <assert id="BR-TSR-20" flag="fatal" test="$empty or sum(tsr:Subtotal[@type='PerTP']/tsr:Outgoing) = tsr:Total/tsr:Outgoing"
        >[BR-TSR-20] The sum of all subtotal aggregated per Transport Protocol ID outgoing MUST match the total outgoing count</assert>
      <!-- Global uniqueness check per Key -->
      <assert id="BR-TSR-21" flag="fatal" test="every $x in (tsr:Subtotal[@type='PerTP']/tsr:Key) satisfies 
                                                 count(tsr:Subtotal[@type='PerTP']/tsr:Key[concat(normalize-space(@schemeID),'::',normalize-space(.)) = 
                                                                                           concat(normalize-space($x/@schemeID),'::',normalize-space($x))]) = 1"
        >[BR-TSR-21] Each Transport Protocol ID MUST occur only once.</assert>

      <!-- Check Subtotal existence -->  
      <assert id="BR-TSR-22" flag="fatal" test="$empty or tsr:Subtotal[@type='PerCountryToCountry']"
        >[BR-TSR-22] The subtotals aggregated by Country to Country are missing</assert>
      <!-- Check Subtotal sums -->
      <assert id="BR-TSR-23" flag="fatal" test="$empty or sum(tsr:Subtotal[@type='PerCountryToCountry']/tsr:Incoming) = tsr:Total/tsr:Incoming"
        >[BR-TSR-23] The sum of all subtotal aggregated per Country to Country incoming MUST match the total incoming count</assert>
      <assert id="BR-TSR-24" flag="fatal" test="$empty or sum(tsr:Subtotal[@type='PerCountryToCountry']/tsr:Outgoing) = tsr:Total/tsr:Outgoing"
        >[BR-TSR-24] The sum of all subtotal aggregated per Country to Country outgoing MUST match the total outgoing count</assert>
      <!-- Global uniqueness check per Key -->
      <assert id="BR-TSR-25" flag="fatal" test="every $cc in (tsr:Subtotal[@type='PerCountryToCountry']),
                                                      $ccsc in ($cc/tsr:Key[@schemeID='SenderCountry']),
                                                      $ccrc in ($cc/tsr:Key[@schemeID='ReceiverCountry']) satisfies 
                                                 count(tsr:Subtotal[@type='PerCountryToCountry'][every $sc in (tsr:Key[@schemeID='SenderCountry']),
                                                                                                       $rc in (tsr:Key[@schemeID='ReceiverCountry']) satisfies
                                                                                                  concat(normalize-space($sc),'::',normalize-space($rc)) = 
                                                                                                  concat(normalize-space($ccsc),'::',normalize-space($ccrc))]) = 1"
        >[BR-TSR-25] Each Country to Country combination MUST occur only once.</assert>
    </rule>

    <rule context="/tsr:TransactionStatisticsReport/tsr:Header">
      <assert id="BR-TSR-04" flag="fatal" test="matches(normalize-space(tsr:ReportPeriod), '^[0-9]{4}\-[0-9]{2}$')"
        >[BR-TSR-04] The report period (<value-of select="normalize-space(tsr:ReportPeriod)" />) MUST NOT contain timezone information</assert>
    </rule>

    <rule context="/tsr:TransactionStatisticsReport/tsr:Header/tsr:ReporterID">
      <assert id="BR-TSR-05" flag="fatal" test="normalize-space(.) != ''"
        >[BR-TSR-05] The reporter ID MUST be present</assert>
      <assert id="BR-TSR-06" flag="fatal" test="not(contains(normalize-space(@schemeID), ' ')) and 
                                                contains($cl_ridtype, concat(' ', normalize-space(@schemeID), ' '))"
        >[BR-TSR-06] The Reporter ID scheme (<value-of select="normalize-space(@schemeID)" />) MUST be coded according to the code list</assert>
      <assert id="BR-TSR-07" flag="fatal" test="(@schemeID='CertSubjectCN' and 
                                                 matches(normalize-space(.), $re_seatid)) or 
                                                not(@schemeID='CertSubjectCN')"
        >[BR-TSR-07] The layout of the certificate subject CN (<value-of select="normalize-space(.)" />) is not a valid Peppol Seat ID</assert>
    </rule>
    
    <!-- Per Service Provider aggregation -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[@type='PerSP']">
      <assert id="TR-TSR-01" flag="fatal" test="count(tsr:Key) = 1"
        >[TR-TSR-01] The subtotal per Service Provider ID MUST have one Key element</assert>
      <assert id="TR-TSR-02" flag="fatal" test="tsr:Key[normalize-space(@metaSchemeID) = 'SP']"
        >[TR-TSR-02] The subtotal per Service Provider ID MUST have a Key element with the meta scheme ID 'SP'</assert>
      <assert id="TR-TSR-03" flag="fatal" test="every $x in (tsr:Key) satisfies 
                                                 not(contains(normalize-space($x/@schemeID), ' ')) and 
                                                 contains($cl_ridtype, concat(' ', normalize-space($x/@schemeID), ' '))"
        >[TR-TSR-03] The subtotal per Service Provider ID MUST have a Key element with the scheme ID coded according to the code list</assert>
    </rule>
    
    <!-- Make this check outside to ensure it works for different subtotals -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal/tsr:Key[@schemeID='CertSubjectCN']">
      <assert id="TR-TSR-04" flag="fatal" test="matches(normalize-space(.), $re_seatid)"
        >[TR-TSR-04] The layout of the certificate subject CN is not a valid Peppol Seat ID</assert>
    </rule>

    <!-- Per Dataset Type aggregation -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[@type='PerDatasetType']">
      <assert id="TR-TSR-05" flag="fatal" test="count(tsr:Key) = 1"
        >[TR-TSR-05] The subtotal per Dataset Type ID MUST have one Key element</assert>
      <assert id="TR-TSR-06" flag="fatal" test="tsr:Key[normalize-space(@metaSchemeID) = 'DT']"
        >[TR-TSR-06] The subtotal per Dataset Type ID MUST have a Key element with the meta scheme ID 'DT'</assert>
    </rule>
    
    <!-- Per Transport Protocol aggregation -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[@type='PerTP']">
      <assert id="TR-TSR-07" flag="fatal" test="count(tsr:Key) = 1"
        >[TR-TSR-07] The subtotal per Transport Protocol ID MUST have one Key element</assert>
      <assert id="TR-TSR-08" flag="fatal" test="tsr:Key[normalize-space(@metaSchemeID) = 'TP']"
        >[TR-TSR-08] The subtotal per Transport Protocol ID MUST have a Key element with the meta scheme ID 'TP'</assert>
      <assert id="TR-TSR-09" flag="fatal" test="tsr:Key[normalize-space(@schemeID) = 'Peppol']"
        >[TR-TSR-09] The subtotal per Transport Protocol ID MUST have a Key element with the scheme ID 'Peppol'</assert>
    </rule>
    
    <!-- Per Country to Country aggregation -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal[@type='PerCountryToCountry']">
      <assert id="TR-TSR-10" flag="fatal" test="count(tsr:Key) = 2"
        >[TR-TSR-10] The subtotal per Country to Country MUST have two Key elements</assert>
      <assert id="TR-TSR-11" flag="fatal" test="count(tsr:Key[normalize-space(@metaSchemeID) = 'CC']) = 2"
        >[TR-TSR-11] The subtotal per Country to Country MUST have two Key elements with the meta scheme ID 'CC'</assert>
      <assert id="TR-TSR-12" flag="fatal" test="count(tsr:Key[normalize-space(@schemeID) = 'SenderCountry']) = 1"
        >[TR-TSR-12] The subtotal per Country to Country MUST have one Key element with the scheme ID 'SenderCountry'</assert>
      <assert id="TR-TSR-13" flag="fatal" test="count(tsr:Key[normalize-space(@schemeID) = 'ReceiverCountry']) = 1"
        >[TR-TSR-13] The subtotal per Country to Country MUST have one Key element with the scheme ID 'ReceiverCountry'</assert>
    </rule>
    
    <!-- Make this check outside to ensure it works for different subtotals -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal/tsr:Key[@schemeID='SenderCountry' or @schemeID='ReceiverCountry']">
      <assert id="TR-TSR-14" flag="fatal" test="not(contains(normalize-space(.), ' ')) and 
                                                contains($cl_iso3166, concat(' ', normalize-space(.), ' '))"
        >[TR-TSR-14] The country code MUST be coded with ISO code ISO 3166-1 alpha-2. Nevertheless, Greece may use the code 'EL', Kosovo may use the code 'XK'.</assert>
    </rule>

    <!-- After all the specific Subtotals -->
    <rule context="/tsr:TransactionStatisticsReport/tsr:Subtotal">
      <assert id="TR-TSR-15" flag="fatal" test="not(contains(normalize-space(@type), ' ')) and 
                                                contains($cl_subtotalType, concat(' ', normalize-space(@type), ' '))"
        >[TR-TSR-15] The Subtotal type (<value-of select="normalize-space(@type)" />) MUST be coded according to the code list</assert>
    </rule>
  </pattern>
</schema>
