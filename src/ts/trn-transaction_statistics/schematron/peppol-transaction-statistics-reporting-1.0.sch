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
      2022-04-12, Philip Helger
        initial version
  </p>

  <ns prefix="ts" uri="urn:fdc:peppol:transaction-statistics:1.0" />

  <pattern id="default">
    <let name="cl_iso3166" value="' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW '" />
    <let name="cl_subtotalType" value="' PerSP PerDatasetType PerTP PerCountryToCountry '" />
    <let name="re_seatid" value="'^P[A-Z]{2}[0-9]{6}$'" />
 
    <rule context="/ts:TransactionStatistics">
      <let name="total" value="ts:Total/ts:Incoming + ts:Total/ts:Outgoing" />
      <let name="empty" value="$total = 0" />
      
      <assert id="BR-TS-01" flag="fatal" test="normalize-space(ts:CustomizationID) = 'urn:fdc:peppol.eu:oo:trns:transaction-statistics:1'"
        >[BR-TS-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:oo:trns:transaction-statistics:1'</assert>
      <assert id="BR-TS-02" flag="fatal" test="normalize-space(ts:ProfileID) = 'urn:fdc:peppol.eu:oo:bis:reporting:1'"
        >[BR-TS-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:oo:bis:reporting:1'</assert>
        
      <!-- Check Subtotal existence -->  
      <assert id="BR-TS-10" flag="fatal" test="$empty or ts:Subtotal[@type='PerSP']"
        >[BR-TS-10] The subtotals aggregated by Service Provider ID are missing</assert>
      <!-- Check Subtotal sums -->
      <assert id="BR-TS-11" flag="fatal" test="$empty or sum(ts:Subtotal[@type='PerSP']/ts:Incoming) = ts:Total/ts:Incoming"
        >[BR-TS-11] The sum of all subtotal aggregated per Service Provider ID incoming MUST match the total incoming count</assert>
      <assert id="BR-TS-12" flag="fatal" test="$empty or sum(ts:Subtotal[@type='PerSP']/ts:Outgoing) = ts:Total/ts:Outgoing"
        >[BR-TS-12] The sum of all subtotal aggregated per Service Provider ID outgoing MUST match the total outgoing count</assert>
      <!-- Uniqueness check per Key -->
      <assert id="BR-TS-13" flag="fatal" test="every $x in (ts:Subtotal[@type='PerSP']) satisfies 
                                                 count(ts:Subtotal[@type='PerSP'][concat(normalize-space(ts:Key/@schemeID),'::',normalize-space(ts:Key)) = 
                                                                                  concat(normalize-space($x/ts:Key/@schemeID),'::',normalize-space($x/ts:Key))]) = 1"
        >[BR-TS-13] Each Service Provider ID MUST occur only once.</assert>

      <!-- Check Subtotal existence -->  
      <assert id="BR-TS-14" flag="fatal" test="$empty or ts:Subtotal[@type='PerDatasetType']"
        >[BR-TS-14] The subtotals aggregated by Dataset Type ID are missing</assert>
      <!-- Check Subtotal sums -->
      <assert id="BR-TS-15" flag="fatal" test="$empty or sum(ts:Subtotal[@type='PerDatasetType']/ts:Incoming) = ts:Total/ts:Incoming"
        >[BR-TS-15] The sum of all subtotal aggregated per Dataset Type ID incoming MUST match the total incoming count</assert>
      <assert id="BR-TS-16" flag="fatal" test="$empty or sum(ts:Subtotal[@type='PerDatasetType']/ts:Outgoing) = ts:Total/ts:Outgoing"
        >[BR-TS-16] The sum of all subtotal aggregated per Dataset Type ID outgoing MUST match the total outgoing count</assert>
      <!-- Uniqueness check per Key -->
      <assert id="BR-TS-17" flag="fatal" test="every $x in (ts:Subtotal[@type='PerDatasetType']) satisfies 
                                                 count(ts:Subtotal[@type='PerDatasetType'][concat(normalize-space(ts:Key/@schemeID),'::',normalize-space(ts:Key)) = 
                                                                                           concat(normalize-space($x/ts:Key/@schemeID),'::',normalize-space($x/ts:Key))]) = 1"
        >[BR-TS-17] Each Dataset Type ID MUST occur only once.</assert>

      <!-- Check Subtotal existence -->  
      <assert id="BR-TS-18" flag="fatal" test="$empty or ts:Subtotal[@type='PerTP']"
        >[BR-TS-18] The subtotals aggregated by Transport Protocol ID are missing</assert>
      <!-- Check Subtotal sums -->
      <assert id="BR-TS-19" flag="fatal" test="$empty or sum(ts:Subtotal[@type='PerTP']/ts:Incoming) = ts:Total/ts:Incoming"
        >[BR-TS-19] The sum of all subtotal aggregated per Transport Protocol ID incoming MUST match the total incoming count</assert>
      <assert id="BR-TS-20" flag="fatal" test="$empty or sum(ts:Subtotal[@type='PerTP']/ts:Outgoing) = ts:Total/ts:Outgoing"
        >[BR-TS-20] The sum of all subtotal aggregated per Transport Protocol ID outgoing MUST match the total outgoing count</assert>
      <!-- Uniqueness check per Key -->
      <assert id="BR-TS-21" flag="fatal" test="every $x in (ts:Subtotal[@type='PerTP']) satisfies 
                                                 count(ts:Subtotal[@type='PerTP'][concat(normalize-space(ts:Key/@schemeID),'::',normalize-space(ts:Key)) = 
                                                                                  concat(normalize-space($x/ts:Key/@schemeID),'::',normalize-space($x/ts:Key))]) = 1"
        >[BR-TS-21] Each Transport Protocol ID MUST occur only once.</assert>

      <!-- Check Subtotal existence -->  
      <assert id="BR-TS-22" flag="fatal" test="$empty or ts:Subtotal[@type='PerCountryToCountry']"
        >[BR-TS-22] The subtotals aggregated by Country to Country are missing</assert>
      <!-- Check Subtotal sums -->
      <assert id="BR-TS-23" flag="fatal" test="$empty or sum(ts:Subtotal[@type='PerCountryToCountry']/ts:Incoming) = ts:Total/ts:Incoming"
        >[BR-TS-23] The sum of all subtotal aggregated per Country to Country incoming MUST match the total incoming count</assert>
      <assert id="BR-TS-24" flag="fatal" test="$empty or sum(ts:Subtotal[@type='PerCountryToCountry']/ts:Outgoing) = ts:Total/ts:Outgoing"
        >[BR-TS-24] The sum of all subtotal aggregated per Country to Country outgoing MUST match the total outgoing count</assert>
      <!-- Uniqueness check per Key -->
      <assert id="BR-TS-25" flag="fatal" test="every $x in (ts:Subtotal[@type='PerCountryToCountry']) satisfies 
                                                 count(ts:Subtotal[@type='PerCountryToCountry'][concat(normalize-space(ts:Key[@schemeID='SenderCountry']),'::',normalize-space(ts:Key[@schemeID='ReceiverCountry'])) = 
                                                                                                concat(normalize-space($x/ts:Key[@schemeID='SenderCountry']),'::',normalize-space($x/ts:Key[@schemeID='ReceiverCountry']))]) = 1"
        >[BR-TS-25] Each Country to Country combination MUST occur only once.</assert>
    </rule>

    <rule context="/ts:TransactionStatistics/ts:Header">
      <assert id="BR-TS-04" flag="fatal" test="matches(normalize-space(ts:ReportPeriod), '^[0-9]{4}\-[0-9]{2}$')"
        >[BR-TS-04] The report period (<value-of select="normalize-space(ts:ReportPeriod)" />) MUST NOT contain timezone information</assert>
    </rule>

    <rule context="/ts:TransactionStatistics/ts:Header/ts:ReporterID">
      <assert id="BR-TS-05" flag="fatal" test="normalize-space(.) != ''"
        >[BR-TS-05] The reporter ID MUST be present</assert>
      <assert id="BR-TS-06" flag="fatal" test="not(contains(normalize-space(@schemeID), ' ')) and 
                                                contains(' CertSubjectCN ', concat(' ', normalize-space(@schemeID), ' '))"
        >[BR-TS-06] The Reporter ID scheme (<value-of select="normalize-space(@schemeID)" />) MUST be coded according to the code list</assert>
      <assert id="BR-TS-07" flag="fatal" test="(@schemeID='CertSubjectCN' and 
                                                 matches(normalize-space(.), $re_seatid)) or 
                                                not(@schemeID='CertSubjectCN')"
        >[BR-TS-07] The layout of the certificate subject CN (<value-of select="normalize-space(.)" />) is not a valid Peppol Seat ID</assert>
    </rule>
    
    <!-- Per Service Provider aggregation -->
    <rule context="/ts:TransactionStatistics/ts:Subtotal[@type='PerSP']">
      <assert id="TR-TS-01" flag="fatal" test="count(ts:Key) = 1"
        >[TR-TS-01] The subtotal per Service Provider ID MUST have one Key element</assert>
      <assert id="TR-TS-02" flag="fatal" test="ts:Key[@metaSchemeID='SP']"
        >[TR-TS-02] The subtotal per Service Provider ID MUST have a Key element with the meta scheme ID 'SP'</assert>
    </rule>
    
    <!-- Per Dataset Type aggregation -->
    <rule context="/ts:TransactionStatistics/ts:Subtotal[@type='PerDatasetType']">
      <assert id="TR-TS-03" flag="fatal" test="count(ts:Key) = 1"
        >[TR-TS-03] The subtotal per Dataset Type ID MUST have one Key element</assert>
      <assert id="TR-TS-04" flag="fatal" test="ts:Key[@metaSchemeID='DT']"
        >[TR-TS-04] The subtotal per Dataset Type ID MUST have a Key element with the meta scheme ID 'DT'</assert>
    </rule>
    
    <!-- Per Transport Protocol aggregation -->
    <rule context="/ts:TransactionStatistics/ts:Subtotal[@type='PerTP']">
      <assert id="TR-TS-05" flag="fatal" test="count(ts:Key) = 1"
        >[TR-TS-05] The subtotal per Transport Protocol ID MUST have one Key element</assert>
      <assert id="TR-TS-06" flag="fatal" test="ts:Key[@metaSchemeID='TP']"
        >[TR-TS-06] The subtotal per Transport Protocol ID MUST have a Key element with the meta scheme ID 'TP'</assert>
    </rule>
    
    <!-- Per Country to Country aggregation -->
    <rule context="/ts:TransactionStatistics/ts:Subtotal[@type='PerCountryToCountry']">
      <assert id="TR-TS-07" flag="fatal" test="count(ts:Key) = 2"
        >[TR-TS-07] The subtotal per Country to Country MUST have two Key elements</assert>
      <assert id="TR-TS-08" flag="fatal" test="count(ts:Key[@metaSchemeID='CC']) = 2"
        >[TR-TS-08] The subtotal per Country to Country MUST have two Key elements with the meta scheme ID 'CC'</assert>
      <assert id="TR-TS-09" flag="fatal" test="count(ts:Key[@schemeID='SenderCountry']) = 1"
        >[TR-TS-09] The subtotal per Country to Country MUST have one Key element with the scheme ID 'SenderCountry'</assert>
      <assert id="TR-TS-10" flag="fatal" test="count(ts:Key[@schemeID='ReceiverCountry']) = 1"
        >[TR-TS-10] The subtotal per Country to Country MUST have one Key element with the scheme ID 'ReceiverCountry'</assert>
    </rule>

    <!-- After all the specific Subtotals -->
    <rule context="/ts:TransactionStatistics/ts:Subtotal">
      <assert id="TR-TS-11" flag="fatal" test="not(contains(normalize-space(@type), ' ')) and 
                                                contains($cl_subtotalType, concat(' ', normalize-space(@type), ' '))"
        >[TR-TS-11] The Subtotal type (<value-of select="normalize-space(@type)" />) MUST be coded according to the code list</assert>
    </rule>
    
    <!-- Test on Key elements -->
    <rule context="/ts:TransactionStatistics/ts:Subtotal/ts:Key[@schemeID='CertSubjectCN']">
      <assert id="TR-TS-12" flag="fatal" test="matches(normalize-space(.), $re_seatid)"
        >[TR-TS-12] The layout of the certificate subject CN (<value-of select="normalize-space(.)" />) is not a valid Peppol Seat ID</assert>
    </rule>
    <rule context="/ts:TransactionStatistics/ts:Subtotal/ts:Key[@schemeID='SenderCountry' or @schemeID='ReceiverCountry']">
      <assert id="TR-TS-13" flag="fatal" test="not(contains(normalize-space(.), ' ')) and 
                                               contains($cl_iso3166, concat(' ', normalize-space(.), ' '))"
        >[TR-TS-13] The country code MUST be coded with ISO code ISO 3166-1 alpha-2. Nevertheless, Greece may use the code 'EL', Kosovo may use the code 'XK'.</assert>
    </rule>
  </pattern>
</schema>
