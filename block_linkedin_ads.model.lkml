connection: "@{CONNECTION_NAME}"

include: "/views/*.view"
include: "/dashboards/*.dashboard"

datagroup: linkedin_ads_etl_datagroup {
  sql_trigger: SELECT COUNT(*) FROM `@{LINKEDIN_SCHEMA}.ad_analytics_by_campaign` ;;
  max_cache_age: "24 hours"
}

explore: li_period_comparison {
  extends: [li_period_comparison_config]
  hidden: no
  group_label: "Block LinkedIn Ads"
}

explore: linkedin_ad_impressions_campaign {
  extends: [linkedin_ad_impressions_campaign_config]
  group_label: "Block LinkedIn Ads"
}

explore: linkedin_ad_impressions_ad {
  extends: [linkedin_ad_impressions_ad_config]
  group_label: "Block LinkedIn Ads"
}

explore: li_period_comparison_config {
  extends: [li_period_fact]
  hidden: no
  extension: required
}

explore: linkedin_ad_impressions_campaign_config {
  extends: [linkedin_ad_impressions_campaign_template]
  extension: required
}

explore: linkedin_ad_impressions_ad_config {
  extends: [linkedin_ad_impressions_ad_template]
  extension: required
}

explore: linkedin_ad_impressions_campaign_adapter {
  from: linkedin_ad_impressions_campaign_adapter
  view_name: fact
  extension: required
  group_label: "Linkedin Ads"
  label: "Linkedin Ads Impressions by Campaign"
  view_label: "Impressions by Campaign"

  join: campaign {
    from: linkedin_campaign
    view_label: "Campaign"
    sql_on: ${fact.campaign_id} = ${campaign.id};;
    relationship: many_to_one
  }
}

explore: linkedin_ad_impressions_ad_adapter {
  from: linkedin_ad_impressions_ad_adapter
  view_name: fact
  extension: required
  group_label: "Linkedin Ads"
  label: "Linkedin Ads Impressions by Ad"
  view_label: "Impressions by Ad"

  join: ad {
    from: linkedin_creative
    view_label: "Ad"
    sql_on:
      ${ad.id} = ${fact.ad_id} ;;
    relationship:  many_to_one
  }

  join: campaign {
    from: linkedin_campaign
    view_label: "Campaign"
    sql_on: ${ad.campaign_id} = ${campaign.id} ;;
    relationship: many_to_one
  }

}

explore: linkedin_ad_impressions_campaign_template {
  persist_with: linkedin_ads_etl_datagroup
  extension: required
  extends: [linkedin_ad_impressions_campaign_adapter]
  from: linkedin_ad_impressions_campaign
  view_name: fact
  group_label: "Marketing Analytics"
  label: "LinkedIn Ads Impressions by Campaign"
  view_label: "Impressions by Campaign"
}

explore: linkedin_ad_impressions_ad_template {
  persist_with: linkedin_ads_etl_datagroup
  extends: [linkedin_ad_impressions_ad_adapter]
  from: linkedin_ad_impressions_ad
  extension: required
  view_name: fact
  group_label: "Marketing Analytics"
  label: "LinkedIn Ads Impressions by Ad"
  view_label: "Impressions by Ad"
}

explore: li_period_fact {
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
}

explore: linkedin_ad_date_fact {
  persist_with: linkedin_ads_etl_datagroup
  from: linkedin_ad_date_fact
  view_name: fact
  label: "LinkedIn Ad This Period"
  view_label: "Ad This Period"
  hidden: yes
  join: last_fact {
    from: linkedin_ad_date_fact
    view_label: "Ad Prior Period"
    sql_on:
      ${fact.ad_id} = ${last_fact.ad_id} AND
      ${fact.date_last_period} = ${last_fact.date_period} AND
      ${fact.date_day_of_period} = ${last_fact.date_day_of_period} ;;
    relationship: one_to_one
  }
}

explore: linkedin_ads_ad_impressions {
  persist_with: linkedin_ads_etl_datagroup
  hidden: yes
  from: linkedin_ads_ad_impressions
  view_name: fact
}

explore: linkedin_campaign_date_fact {
  persist_with: linkedin_ads_etl_datagroup
  from: linkedin_campaign_date_fact
  view_name: fact
  label: "LinkedIn Campaign This Period"
  view_label: "Campaign This Period"
  hidden: yes
  join: last_fact {
    from: linkedin_campaign_date_fact
    view_label: "Campaign Prior Period"
    sql_on:
      ${fact.campaign_id} = ${last_fact.campaign_id} AND
      ${fact.date_last_period} = ${last_fact.date_period} AND
      ${fact.date_day_of_period} = ${last_fact.date_day_of_period} ;;
    relationship: one_to_one
  }
}
