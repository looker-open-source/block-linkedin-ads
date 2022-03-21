connection: "@{CONNECTION_NAME}"

include: "/explores/li_period.explore"
include: "/explores/linkedin_ads.explore"
include: "/explores/linkedin_ad.explore"
include: "/explores/linkedin_campaign.explore"

include: "/dashboards/*.dashboard"

datagroup: linkedin_ads_etl_datagroup {
  sql_trigger: SELECT COUNT(*) FROM `@{LINKEDIN_SCHEMA}.ad_analytics_by_campaign` ;;
  max_cache_age: "24 hours"
}
