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
      2022-04-15, Philip Helger
        initial version
  </p>

  <ns prefix="eur" uri="urn:fdc:peppol:end-user-reporting:1.0" />

  <pattern id="default">
    <let name="cl_iso3166" value="' 1A AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH EL ER ES ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE VG VI VN VU WF WS XI YE YT ZA ZM ZW '" />
    <let name="cl_spidtype" value="' CertSubjectCN '" />

    <rule context="/eur:EndUserReport">
      <assert id="EUR-01" flag="fatal" test="normalize-space(eur:CustomizationID) = 'urn:fdc:peppol.eu:oo:trns:end-user-report:1'"
        >[EUR-01] The customization ID MUST use the value 'urn:fdc:peppol.eu:oo:trns:end-user-report:1'</assert>
      <assert id="EUR-02" flag="fatal" test="normalize-space(eur:ProfileID) = 'urn:fdc:peppol.eu:oo:bis:reporting:1'"
        >[EUR-02] The profile ID MUST use the value 'urn:fdc:peppol.eu:oo:bis:reporting:1'</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:Header">
      <assert id="EUR-03" flag="fatal" test="matches(normalize-space(eur:ReportPeriod), '^[0-9]{4}\-[0-9]{2}$')"
        >[EUR-03] The reporting period (<value-of select="normalize-space(eur:ReportPeriod)" />) MUST NOT contain timezone information</assert>
    </rule>

    <rule context="/eur:EndUserReport/eur:Header/eur:ReporterID">
      <assert id="EUR-04" flag="fatal" test="normalize-space(.) != ''"
        >[EUR-04] The Reporter ID MUST be present</assert>
      <assert id="EUR-05" flag="fatal" test="not(contains(normalize-space(@schemeID), ' ')) and 
                                             contains($cl_spidtype, concat(' ', normalize-space(@schemeID), ' '))"
        >[EUR-05] The Reporter ID scheme ID (<value-of select="normalize-space(@schemeID)" />) MUST be coded according to the code list</assert>
      <assert id="EUR-06" flag="fatal" test="(@schemeID='CertSubjectCN' and 
                                              matches(normalize-space(.), '^P[A-Z]{2}[0-9]{6}$')) or 
                                             not(@schemeID='CertSubjectCN')"
        >[EUR-06] The layout of the certificate subject CN (<value-of select="normalize-space(.)" />) is not a valid Peppol Seat ID</assert>
    </rule>


    <rule context="/eur:EndUserReport/eur:Totals">
      <assert id="EUR-07" flag="fatal" test="matches(normalize-space(eur:SendingEndUsers), '^\d+$')">
        [EUR-07] The Totals/SendingEndUsers  (<value-of select="normalize-space(eur:SendingEndUsers)"/>) MUST be a non-negative number
      </assert>
      <assert id="EUR-08" flag="fatal" test="matches(normalize-space(eur:ReceivingEndUsers), '^\d+$')">
        [EUR-08] The Totals/ReceivingEndUsers  (<value-of select="normalize-space(eur:ReceivingEndUsers)"/>) MUST be a non-negative number
      </assert>
    </rule>

  </pattern>
</schema>
