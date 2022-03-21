include: "/views/linkedin_ads.view"

explore: linkedin_ad_impressions_campaign {
  extends: [linkedin_ad_impressions_campaign_config]
  group_label: "Block LinkedIn Ads"
}

explore: linkedin_ad_impressions_ad {
  extends: [linkedin_ad_impressions_ad_config]
  group_label: "Block LinkedIn Ads"
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
