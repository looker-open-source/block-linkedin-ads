project_name: "block-linkedin-ads"

remote_dependency: app-marketing-common {
  url: "git://github.com/looker/app-marketing-common-bigquery"
  ref: "3d8fe8aa069aecfb55b245599cf2f7a9ed1b8f36"
}

# LookML to map the ETL and data warehouse for LinkedIn Ads
remote_dependency: app-marketing-linkedin-ads-adapter {
  url: "git://github.com/looker/app-marketing-linkedin-ads-fivetran-bigquery"
  ref: "c4a5ff395c421164adbd194e2884a300dd3218db"
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
  value: "looker_application"
  export: override_required
}

constant: LINKEDIN_SCHEMA {
  value: "linkedin_ads"
  export: override_required
}
