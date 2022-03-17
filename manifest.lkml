project_name: "block-linkedin-ads"


# LookML to map the ETL and data warehouse for LinkedIn Ads
constant: CONNECTION_NAME {
  value: "4mile_bigquery"
  export: override_required
}

constant: LINKEDIN_SCHEMA {
  value: "linkedin_generated"
  export: override_required
}
