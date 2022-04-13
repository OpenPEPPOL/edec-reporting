<?xml version="1.0" encoding="iso-8859-1"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
        queryBinding='xslt2'
        schemaVersion="ISO19757-3">
  <title>OpenPeppol End User Reporting</title>

  <p id="about">
    This is the Schematron for the Peppol End User Reporting.
    This is based on the "Internal Regulations" document, 
      chapter 4.3 "Service Provider Reporting about End Users"
   
    Author:
      Philip Helger

    History: 
      2022-04-12, Philip Helger
        initial version
  </p>

  <ns prefix="eur" uri="urn:fdc:peppol:end-user-reporting:1.0" />

  <pattern id="default">
    <rule context="/eur:EndUserReport">
      <assert id="BR-EUR-01" flag="fatal" test="normalize-space(eur:CustomizationID) = 'urn:fdc:peppol.eu:oo:trns:end-user-report:1'"
        >[BR-EUR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:oo:trns:end-user-report:1'</assert>
      <assert id="BR-EUR-02" flag="fatal" test="normalize-space(eur:ProfileID) = 'urn:fdc:peppol.eu:oo:bis:reporting:1'"
        >[BR-EUR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:oo:bis:reporting:1'</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:Header">
      <assert id="BR-EUR-04" flag="fatal" test="matches(normalize-space(eur:ReportPeriod), '^[0-9]{4}\-[0-9]{2}$')"
        >[BR-EUR-04] The report period (<value-of select="normalize-space(eur:ReportPeriod)" />) MUST NOT contain timezone information</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:Header/eur:ReporterID">
      <assert id="BR-EUR-05" flag="fatal" test="normalize-space(.) != ''"
        >[BR-EUR-05] The reporter ID MUST be present</assert>
      <assert id="BR-EUR-06" flag="fatal" test="not(contains(normalize-space(@schemeID), ' ')) and 
                                                contains(' CertSubjectCN ', concat(' ', normalize-space(@schemeID), ' '))"
        >[BR-EUR-06] The Reporter ID scheme (<value-of select="normalize-space(@schemeID)" />) MUST be coded according to the code list</assert>
      <assert id="BR-EUR-07" flag="fatal" test="(@schemeID='CertSubjectCN' and 
                                                 matches(normalize-space(.), '^P[A-Z]{2}[0-9]{6}$')) or 
                                                not(@schemeID='CertSubjectCN')"
        >[BR-EUR-07] The layout of the certificate subject CN (<value-of select="normalize-space(.)" />) is not a valid Peppol Seat ID</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:EndUser">
      <assert id="BR-EUR-09" flag="fatal" test="normalize-space(eur:LegalID) != ''"
        >[BR-EUR-09] The legal ID MUST be present</assert>
      <assert id="BR-EUR-10" flag="fatal" test="normalize-space(eur:LegalID/@schemeID) != ''"
        >[BR-EUR-10] The legal ID scheme ID MUST be present</assert>
      <assert id="BR-EUR-11" flag="fatal" test="normalize-space(eur:LegalName) != ''"
        >[BR-EUR-11] The legal name MUST be present</assert>
      
      <!-- Uniqueness checks -->
      <assert id="BR-EUR-15" flag="fatal" test="every $x in (eur:SendingDatasetID) satisfies 
                                                  count(eur:SendingDatasetID[concat(normalize-space(@schemeID),'::',normalize-space(.)) = concat(normalize-space($x/@schemeID),'::',normalize-space($x))])= 1"
        >[BR-EUR-15] Each Sending Dataset Type ID must be reported only once.</assert>
      <assert id="BR-EUR-18" flag="fatal" test="every $x in (eur:ReceivingDatasetID) satisfies 
                                                  count(eur:ReceivingDatasetID[concat(normalize-space(@schemeID),'::',normalize-space(.)) = concat(normalize-space($x/@schemeID),'::',normalize-space($x))])= 1"
        >[BR-EUR-18] Each Receiving Dataset Type ID must be reported only once.</assert>
      <assert id="BR-EUR-21" flag="fatal" test="every $x in (eur:ParticipantID) satisfies 
                                                  count(eur:ParticipantID[concat(normalize-space(@schemeID),'::',normalize-space(.)) = concat(normalize-space($x/@schemeID),'::',normalize-space($x))])= 1"
        >[BR-EUR-21] Each Participant ID must be reported only once.</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:EndUser/eur:SendingDatasetID">
      <assert id="BR-EUR-13" flag="fatal" test="normalize-space(.) != ''"
        >[BR-EUR-13] The Sending Dataset Type ID MUST be present</assert>
      <assert id="BR-EUR-14" flag="fatal" test="normalize-space(@schemeID) != ''"
        >[BR-EUR-14] The scheme ID MUST be present</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:EndUser/eur:ReceivingDatasetID">
      <assert id="BR-EUR-16" flag="fatal" test="normalize-space(.) != ''"
        >[BR-EUR-16] The Receiving Dataset ID MUST be present</assert>
      <assert id="BR-EUR-17" flag="fatal" test="normalize-space(@schemeID) != ''"
        >[BR-EUR-17] The scheme ID MUST be present</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:EndUser/eur:ParticipantID">
      <assert id="BR-EUR-19" flag="fatal" test="normalize-space(.) != ''"
        >[BR-EUR-19] The Participant ID MUST be present</assert>
      <assert id="BR-EUR-20" flag="fatal" test="normalize-space(@schemeID) != ''"
        >[BR-EUR-20] The scheme ID MUST be present</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:EndUser/eur:Intermediary">
      <assert id="BR-EUR-22" flag="fatal" test="normalize-space(eur:LegalID) != ''"
        >[BR-EUR-22] The legal ID MUST be present</assert>
      <assert id="BR-EUR-23" flag="fatal" test="normalize-space(eur:LegalID/@schemeID) != ''"
        >[BR-EUR-23] The legal ID scheme ID MUST be present</assert>
      <assert id="BR-EUR-24" flag="fatal" test="normalize-space(eur:LegalName) != ''"
        >[BR-EUR-24] The legal name MUST be present</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:EndUser/eur:Country | /eur:EndUserReport/eur:EndUser/eur:Intermediary/eur:Country">
      <assert id="BR-EUR-12" flag="fatal" test="not(contains(normalize-space(.), ' ')) and 
                                                contains(' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW ', concat(' ', normalize-space(.), ' '))"
        >[BR-EUR-12] The country code MUST be coded with ISO code ISO 3166-1 alpha-2. Nevertheless, Greece may use the code 'EL', Kosovo may use the code 'XK'.</assert>
    </rule>
  </pattern>
</schema>
