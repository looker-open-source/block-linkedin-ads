project_name: "block-linkedin-ads"

remote_dependency: app-marketing-common {
  url: "git://github.com/looker/app-marketing-common-bigquery"
  ref: "d0405a8ef76925449d722b11103f419b3d40e37b"
}

# LookML to map the ETL and data warehouse for LinkedIn Ads
remote_dependency: app-marketing-linkedin-ads-adapter {
  url: "git://github.com/looker/app-marketing-linkedin-ads-fivetran-bigquery"
  ref: "86c8f7f34c05eb5a107db3c4fea6b3b99011f780"
}

remote_dependency: app-marketing-linkedin-ads {
  url: "git://github.com/looker/app-marketing-linkedin-ads"
  ref: "871edd2221ccb9e6fe2e11664786eccc4e63472e"
}

local_dependency: {
  project: "@{CONFIG_PROJECT_NAME}"

  override_constant: LINKEDIN_SCHEMA {
    value: "@{LINKEDIN_SCHEMA}"
  }
}

constant: CONFIG_PROJECT_NAME {
  value: "block-linkedin-ads-config"
  export: override_required
}

# LookML to map the ETL and data warehouse for LinkedIn Ads
constant: CONNECTION_NAME {
  value: "looker_app_2"
  export: override_required
}

constant: LINKEDIN_SCHEMA {
  value: "linkedin_generated"
  export: override_required
}
