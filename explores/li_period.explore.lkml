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

explore: li_period_comparison_config {
  extends: [li_period_fact]
  hidden: no
  extension: required
}

explore: li_period_comparison {
  extends: [li_period_comparison_config]
  hidden: no
  group_label: "Block LinkedIn Ads"
}
