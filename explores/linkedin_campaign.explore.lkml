include: "/views/linkedin_ads.view"

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
