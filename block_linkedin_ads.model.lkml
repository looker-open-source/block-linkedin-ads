connection: "@{CONNECTION_NAME}"

include: "/views/*.view"
include: "/dashboards/*.dashboard"


explore: li_period_comparison {
  persist_with: linkedin_ads_etl_datagroup
  from: li_period_fact
  extension: required
  view_name: fact
  label: "LinkedIn Period Comparison"
  view_label: "This Period"
  join: last_fact {
    from: li_period_fact
    view_label: "Prior Period"
    sql_on: ${fact.account_id} = ${last_fact.account_id} AND
      ${fact.campaign_id} = ${last_fact.campaign_id} AND
      ${fact.date_last_period} = ${last_fact.date_period} AND
      ${fact.date_day_of_period} = ${last_fact.date_day_of_period} ;;
    relationship: one_to_one
  }
  hidden: no
  group_label: "Block LinkedIn Ads"
}

explore: linkedin_ad_impressions_campaign {
  persist_with: linkedin_ads_etl_datagroup
  extension: required
  extends: [linkedin_ad_impressions_campaign_adapter]
  from: linkedin_ad_impressions_campaign
  view_name: fact
  group_label: "Block LinkedIn Ads"
  label: "LinkedIn Ads Impressions by Campaign"
  view_label: "Impressions by Campaign"
}

explore: linkedin_ad_impressions_ad {
  persist_with: linkedin_ads_etl_datagroup
  extends: [linkedin_ad_impressions_ad_adapter]
  from: linkedin_ad_impressions_ad
  extension: required
  view_name: fact
  group_label: "Block LinkedIn Ads"
  label: "LinkedIn Ads Impressions by Ad"
  view_label: "Impressions by Ad"
}
