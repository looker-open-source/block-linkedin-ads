## LI Period
view: li_period_fact {
  extends: [linkedin_ads_config, date_base, period_base, ad_metrics_base]
  derived_table: {
    datagroup_trigger: linkedin_ads_etl_datagroup
    explore_source: linkedin_ads_ad_impressions {
      column: _date { field: fact.date_date }
      column: account_name { field: fact.account_name }
      column: account_id { field: fact.account_id }
      column: campaign_id { field: fact.campaign_id }
      column: campaign_name { field: fact.campaign_name }
      column: clicks { field: fact.total_clicks }
      column: conversions { field: fact.total_conversions }
      column: conversionvalue { field: fact.total_conversionvalue }
      column: cost { field: fact.total_cost }
      column: impressions { field: fact.total_impressions }
    }
  }

  dimension: key_base {
    hidden: yes
    sql: CONCAT(CAST(${account_id} AS STRING),"-", CAST(${campaign_id} AS STRING));;
  }

  dimension: primary_key {
    primary_key: yes
    hidden: yes
    sql: CONCAT(CAST(${date_period} AS STRING)
              , "|", CAST(${date_day_of_period} AS STRING)
              , "|", ${key_base}
            ) ;;
  }
  dimension: account_id {
    hidden: yes
  }
  dimension: campaign_id {
    hidden: yes
  }
  dimension: account_name {}
  dimension: campaign_name {}
  dimension: date_day_of_period {
    hidden:  yes
  }
  dimension: _date {
    type: date_raw
  }
}
view: li_period_comparison {
  extends: [li_period_fact]
}

view: linkedin_account {
  extends: [linkedin_ads_config]
  derived_table: {
    sql:
    (
    SELECT account_history.* FROM `{{ account.linkedin_ads_schema._sql }}.account_history` as account_history
    INNER JOIN (
    SELECT
    id, max(last_modified_time) as max_fivetran_synced
    FROM `{{ account.linkedin_ads_schema._sql }}.account_history`
    GROUP BY id) max_account_history
    ON max_account_history.id = account_history.id
    AND max_account_history.max_fivetran_synced = account_history.last_modified_time
    ) ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._fivetran_synced ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_time ;;
  }

  dimension: currency {
    type: string
    sql: ${TABLE}.currency ;;
  }

  dimension_group: _date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_time ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: notified_on_campaign_optimization {
    type: yesno
    sql: ${TABLE}.notified_on_campaign_optimization ;;
  }

  dimension: notified_on_creative_approval {
    type: yesno
    sql: ${TABLE}.notified_on_creative_approval ;;
  }

  dimension: notified_on_creative_rejection {
    type: yesno
    sql: ${TABLE}.notified_on_creative_rejection ;;
  }

  dimension: notified_on_end_of_campaign {
    type: yesno
    sql: ${TABLE}.notified_on_end_of_campaign ;;
  }

  dimension: reference {
    type: string
    sql: ${TABLE}.reference ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: total_budget_amount {
    type: number
    sql: ${TABLE}.total_budget_amount ;;
  }

  dimension: total_budget_currency_code {
    type: string
    sql: ${TABLE}.total_budget_currency_code ;;
  }

  dimension: total_budget_ends_at {
    type: number
    sql: ${TABLE}.total_budget_ends_at ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: version_tag {
    type: string
    sql: ${TABLE}.version_tag ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
view: linkedin_ad_impressions_ad {
  extends: [date_base, period_base, linkedin_ad_metrics_base, linkedin_ads_config, linkedin_ad_metrics_base_dimensions]

  sql_table_name: {{ linkedin_ads_schema._sql }}.ad_analytics_by_creative ;;

  dimension: ad_id {
    hidden: yes
    type: number
    sql: ${TABLE}.creative_id ;;
  }

  dimension: _date {
    hidden: yes
    type: date
    sql: ${TABLE}.day ;;
  }

  dimension: ad_id_string {
    hidden: yes
    sql: CAST(${TABLE}.creative_id as STRING) ;;
  }

}
view: linkedin_ad_impressions_campaign {
  extends: [date_base, period_base, linkedin_ad_metrics_base, linkedin_ads_config, linkedin_ad_metrics_base_dimensions]
  sql_table_name: {{ linkedin_ads_schema._sql }}.ad_analytics_by_campaign ;;

  dimension: campaign_id {
    hidden: yes
    type: number
  }

  dimension: campaign_id_string {
    hidden: yes
    sql: CAST(${TABLE}.campaign_id as STRING) ;;
  }

  dimension: _date {
    hidden: yes
    type: date
    sql: ${TABLE}.day ;;
  }
}
view: linkedin_campaign {
  extends: [linkedin_ads_config]
  derived_table: {
    sql:
    (
    SELECT campaign_history.* FROM `{{ campaign.linkedin_ads_schema._sql }}.campaign_history` as campaign_history
    INNER JOIN (
    SELECT
    id, max(last_modified_time) as max_fivetran_synced
    FROM `{{ campaign.linkedin_ads_schema._sql }}.campaign_history`
    GROUP BY id) max_campaign_history
    ON max_campaign_history.id = campaign_history.id
    AND max_campaign_history.max_fivetran_synced = campaign_history.last_modified_time
    ) ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._fivetran_synced ;;
  }

  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension: account_id_string {
    hidden: yes
    sql: CAST(${TABLE}.account_id as STRING) ;;
  }

  dimension: associated_entity {
    type: string
    sql: ${TABLE}.associated_entity ;;
  }

  dimension: audience_expansion_enabled {
    type: yesno
    sql: ${TABLE}.audience_expansion_enabled ;;
  }

  dimension: campaign_group_id {
    type: number
    sql: ${TABLE}.campaign_group_id ;;
  }

  dimension: cost_type {
    type: string
    sql: ${TABLE}.cost_type ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_time ;;
  }

  dimension: creative_selection {
    type: string
    sql: ${TABLE}.creative_selection ;;
  }

  dimension: daily_budget_amount {
    type: number
    sql: ${TABLE}.daily_budget_amount ;;
  }

  dimension: daily_budget_currency_code {
    type: string
    sql: ${TABLE}.daily_budget_currency_code ;;
  }

  dimension: format {
    type: string
    sql: ${TABLE}.format ;;
  }

  dimension_group: _date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_time ;;
  }

  dimension: locale_country {
    type: string
    sql: ${TABLE}.locale_country ;;
  }

  dimension: locale_language {
    type: string
    sql: ${TABLE}.locale_language ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: objective_type {
    type: string
    sql: ${TABLE}.objective_type ;;
  }

  dimension: offsite_delivery_enabled {
    type: yesno
    sql: ${TABLE}.offsite_delivery_enabled ;;
  }

  dimension: optimization_target_type {
    type: string
    sql: ${TABLE}.optimization_target_type ;;
  }

  dimension_group: run_schedule_end {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.run_schedule_end ;;
  }

  dimension_group: run_schedule_start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.run_schedule_start ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: unit_cost_amount {
    type: number
    sql: ${TABLE}.unit_cost_amount ;;
  }

  dimension: unit_cost_currency_code {
    type: string
    sql: ${TABLE}.unit_cost_currency_code ;;
  }

  dimension: version_tag {
    type: string
    sql: ${TABLE}.version_tag ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
view: linkedin_campaign_group {
  extends: [linkedin_ads_config]
  derived_table: {
    sql:
    (
    SELECT campaign_group_history.* FROM `{{ campaign_group.linkedin_ads_schema._sql }}.campaign_group_history` as campaign_group_history
    INNER JOIN (
    SELECT
    id, max(last_modified_time) as max_fivetran_synced
    FROM `{{ campaign_group.linkedin_ads_schema._sql }}.campaign_group_history`
    GROUP BY id) max_campaign_group_history
    ON max_campaign_group_history.id = campaign_group_history.id
    AND max_campaign_group_history.max_fivetran_synced = campaign_group_history.last_modified_time
    ) ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._fivetran_synced ;;
  }

  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension: backfilled {
    type: yesno
    sql: ${TABLE}.backfilled ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_time ;;
  }

  dimension_group: last_modified {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_time ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension_group: run_schedule_end {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.run_schedule_end ;;
  }

  dimension_group: run_schedule_start {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.run_schedule_start ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
view: linkedin_creative {
  extends: [linkedin_ads_config]
  derived_table: {
    sql:
    (
    SELECT creative_history.* FROM `{{ ad.linkedin_ads_schema._sql }}.creative_history` as creative_history
    INNER JOIN (
    SELECT
    id, max(last_modified_time) as max_fivetran_synced
    FROM `{{ ad.linkedin_ads_schema._sql }}.creative_history`
    GROUP BY id) max_creative_history
    ON max_creative_history.id = creative_history.id
    AND max_creative_history.max_fivetran_synced = creative_history.last_modified_time
    ) ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._fivetran_synced ;;
  }

  dimension: activity {
    type: string
    sql: ${TABLE}.activity ;;
  }

  dimension: call_to_action {
    type: string
    sql: ${TABLE}.call_to_action ;;
  }

  dimension: call_to_action_label_type {
    type: string
    sql: ${TABLE}.call_to_action_label_type ;;
  }

  dimension: call_to_action_target {
    type: string
    sql: ${TABLE}.call_to_action_target ;;
  }

  dimension: campaign_id {
    type: number
    sql: ${TABLE}.campaign_id ;;
  }

  dimension: click_uri {
    type: string
    sql: ${TABLE}.click_uri ;;
  }

  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
  }

  dimension: content {
    type: string
    sql: ${TABLE}.content ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_time ;;
  }

  dimension: custom_background {
    type: string
    sql: ${TABLE}.custom_background ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: direct_sponsored_content {
    type: yesno
    sql: ${TABLE}.direct_sponsored_content ;;
  }

  dimension: duration_micro {
    type: number
    sql: ${TABLE}.duration_micro ;;
  }

  dimension: forum_name {
    type: string
    sql: ${TABLE}.forum_name ;;
  }

  dimension: headline {
    type: string
    sql: ${TABLE}.headline ;;
  }

  dimension_group: _date {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_time ;;
  }

  dimension: logo {
    type: string
    sql: ${TABLE}.logo ;;
  }

  dimension: media_asset {
    type: string
    sql: ${TABLE}.media_asset ;;
  }

  dimension: organization {
    type: string
    sql: ${TABLE}.organization ;;
  }

  dimension: organization_logo {
    type: string
    sql: ${TABLE}.organization_logo ;;
  }

  dimension: organization_name {
    type: string
    sql: ${TABLE}.organization_name ;;
  }

  dimension: reference {
    type: string
    sql: ${TABLE}.reference ;;
  }

  dimension: review_status {
    type: string
    sql: ${TABLE}.review_status ;;
  }

  dimension: share {
    type: string
    sql: ${TABLE}.share ;;
  }

  dimension: show_member_profile_photo {
    type: yesno
    sql: ${TABLE}.show_member_profile_photo ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: text {
    type: string
    sql: ${TABLE}.text_ad_text ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.text_ad_title ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  dimension: user_generated_content_post {
    type: string
    sql: ${TABLE}.user_generated_content_post ;;
  }

  dimension: version_tag {
    type: string
    sql: ${TABLE}.version_tag ;;
  }

  measure: count {
    type: count
    drill_fields: [id, organization_name, forum_name, company_name]
  }
}
view: linkedin_video_ad {
  derived_table: {
    sql:
    (
    SELECT video_ad_history.* FROM `{{ video_ad.linkedin_ads_schema._sql }}.video_ad_history` as video_ad_history
    INNER JOIN (
    SELECT
    id, max(last_modified_time) as max_fivetran_synced
    FROM `{{ video_ad.linkedin_ads_schema._sql }}.video_ad_history`
    GROUP BY id) max_video_history
    ON max_video_history.id = video_ad_history.id
    AND max_video_history.max_fivetran_synced = video_ad_history.last_modified_time
    ) ;;
  }
  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}._fivetran_synced ;;
  }

  dimension: account_id {
    type: number
    sql: ${TABLE}.account_id ;;
  }

  dimension_group: account_last_modified {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.account_last_modified_time ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_time ;;
  }

  dimension_group: last_modified {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_modified_time ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: owner {
    type: string
    sql: ${TABLE}.owner ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}

## Derived Views
view: linkedin_ad_date_fact {
  extends: [date_base, linkedin_ad_metrics_base, period_base,
    ad_metrics_period_comparison_base, date_primary_key_base]
  derived_table: {
    datagroup_trigger: linkedin_ads_etl_datagroup
    explore_source: linkedin_ad_impressions_ad {
      column: _date { field: fact.date_date }
      column: ad_id {field: fact.ad_id}
      column: ad_title {field: ad.title}
      column: campaign_id {field: campaign.id}
      column: campaign_name {field: campaign.name}
      column: bid_type {field: campaign.cost_type}
      column: clicks {field: fact.total_clicks }
      column: conversions {field: fact.total_conversions}
      column: revenue {field: fact.total_conversionvalue}
      column: cost {field: fact.cost}
      column: impressions { field: fact.total_impressions}
      column: conversionvalue { field: fact.total_conversionvalue}
    }
  }
  dimension: ad_id {
    hidden: yes
  }

  dimension: campaign_id {
    hidden: yes
  }

  dimension: campaign_name {
  }

  dimension: ad_title {
  }

  dimension: bid_type {
  }

  dimension: cost {
    hidden: yes
    sql: ${TABLE}.cost ;;
  }

  dimension: conversions {
    hidden: yes
    sql: ${TABLE}.conversions ;;
  }

  dimension: conversionvalue {
    hidden: yes
    sql: ${TABLE}.conversionvalue ;;
  }

  dimension: _date {
    hidden: yes
    type: date_raw
    sql: CAST(${TABLE}._date AS DATE) ;;
  }

  dimension: ad_key_base {
    hidden: yes
    sql: {% if _dialect._name == 'snowflake' %}
        TO_CHAR(${campaign_id}) || '-' ||  TO_CHAR(${ad_id})
      {% elsif _dialect._name == 'redshift' %}
        CAST(${campaign_id} AS VARCHAR) || '-' || CAST(${ad_id} AS VARCHAR)
      {% else %}
        CONCAT(CAST(${campaign_id} AS STRING), "-", CAST(${ad_id} AS STRING))
      {% endif %} ;;
  }
  dimension: key_base {
    hidden: yes
    sql: ${ad_key_base} ;;
  }

  set: detail {
    fields: [ad_id]
  }
}
view: linkedin_ads_ad_impressions {
  extends: [ad_metrics_base, date_base, period_base, date_primary_key_base]

  derived_table: {
    datagroup_trigger: linkedin_ads_etl_datagroup
    explore_source: linkedin_ad_impressions_campaign {
      column: _date { field: fact.date_date }
      column: account_id { field: campaign.account_id_string}
      derived_column: channel { sql: "LinkedIn" ;;}
      derived_column: account_name {  sql: CAST(NULL AS STRING);;  }
      column: campaign_id { field: fact.campaign_id_string }
      column: campaign_name { field: campaign.name }
      derived_column: ad_group_id { sql: CAST(NULL AS STRING) ;;}
      derived_column: ad_group_name { sql: CAST(NULL AS STRING) ;;}
      column: cost { field: fact.total_cost }
      column: impressions { field: fact.total_impressions }
      column: clicks { field: fact.total_clicks }
      column: conversions { field: fact.total_conversions }
      column: conversionvalue { field: fact.total_conversionvalue }
    }
  }

  dimension: _date {
    hidden: yes
    type: date_raw
  }

  dimension: cost {
    hidden: yes
    sql: ${TABLE}.cost ;;
  }

  dimension: conversions {
    hidden: yes
    sql: ${TABLE}.conversions ;;
  }
  dimension: channel {}
  dimension: account_id {
    hidden: yes
  }
  dimension: campaign_id {
    hidden: yes
  }
  dimension: ad_group_id {
    hidden: yes
  }
  dimension: account_name {}
  dimension: campaign_name {}
  dimension: ad_group_name {}
  dimension: cross_channel_ad_group_key_base {
    hidden: yes
    sql: concat(${channel}, ${account_id}, ${campaign_id}, ${ad_group_id}) ;;
  }
  dimension: key_base {
    hidden: yes
    sql: ${cross_channel_ad_group_key_base} ;;
  }
}
view: linkedin_campaign_date_fact {
  extends: [date_base, linkedin_ad_metrics_base, period_base,
    ad_metrics_period_comparison_base, date_primary_key_base]
  derived_table: {
    datagroup_trigger: linkedin_ads_etl_datagroup
    explore_source: linkedin_ad_impressions_campaign {
      column: _date { field: fact.date_date }
      column: campaign_id {field: fact.campaign_id}
      column: campaign_name {field: campaign.name}
      column: clicks {field: fact.total_clicks }
      column: conversions {field: fact.total_conversions}
      column: revenue {field: fact.total_conversionvalue}
      column: cost {field: fact.cost}
      column: impressions { field: fact.total_impressions}
      column: conversionvalue { field: fact.total_conversionvalue}
    }
  }
  dimension: campaign_id {
    hidden: yes
  }

  dimension: campaign_name {
    hidden: no
  }

  dimension: cost {
    hidden: yes
    sql: ${TABLE}.cost ;;
  }

  dimension: conversions {
    hidden: yes
    sql: ${TABLE}.conversions ;;
  }

  dimension: conversionvalue {
    hidden: yes
    sql: ${TABLE}.conversionvalue ;;
  }

  dimension: _date {
    hidden: yes
    type: date_raw
    sql: CAST(${TABLE}._date AS DATE) ;;
  }

  dimension: primary_key {
    hidden: no
  }

  dimension: campaign_key_base {
    hidden: yes
    sql: {% if _dialect._name == 'snowflake' %}
         TO_CHAR(${campaign_id})
      {% elsif _dialect._name == 'redshift' %}
        CAST(${campaign_id} AS VARCHAR)
      {% else %}
        CAST(${campaign_id} as STRING)
      {% endif %} ;;
  }
  dimension: key_base {
    hidden: yes
    sql: ${campaign_key_base} ;;
  }

  set: detail {
    fields: [campaign_id]
  }
}

## Extended/Base Views
view: ad_metrics_base {
  extension: required
  extends: [ad_metrics_dimension_base]
  measure: average_click_rate {
    label: "Click Through Rate"
    description: "Percent of people that click on an ad."
    type: number
    sql: ${total_clicks}*1.0/nullif(${total_impressions},0) ;;
    value_format_name: percent_2
    drill_fields: [fact.date_date, campaign.name, average_click_rate]
  }

  measure: average_cost_per_conversion {
    label: "Cost per Conversion"
    description: "Cost per conversion."
    type: number
    sql: ${total_cost}*1.0 / NULLIF(${total_conversions},0) ;;
    value_format_name: usd
    drill_fields: [fact.date_date, campaign.name, fact.average_cost_per_conversion]
  }

  measure: average_value_per_conversion {
    label: "Value per Conversion"
    description: "Average value per conversion."
    type: number
    sql: ${total_conversionvalue}*1.0 / NULLIF(${total_conversions},0) ;;
    value_format_name: usd
  }

  measure: average_cost_per_click {
    label: "Cost per Click"
    description: "Average cost per ad click."
    type: number
    sql: ${total_cost}*1.0 / NULLIF(${total_clicks},0) ;;
    value_format_name: usd
    drill_fields: [fact.date_date, campaign.name, average_cost_per_click]
  }

  measure: average_cost_per_value {
    label: "Cost per value"
    description: "Cost per value."
    type: number
    sql: ${total_cost}*1.0 / NULLIF(${total_conversionvalue},0) ;;
    value_format_name: usd
    drill_fields: [fact.date_date, campaign.name, fact.total_conversionvalue, fact.total_cost, fact.average_cost_per_conversion]
  }

  measure: average_value_per_click {
    label: "Value per Click"
    description: "Average value per ad click."
    type: number
    sql: ${total_conversionvalue}*1.0 / NULLIF(${total_clicks},0) ;;
    value_format_name: usd
  }

  measure: average_cost_per_impression {
    label: "CPM"
    description: "Average cost per ad impression viewed."
    type: number
    sql: ${total_cost}*1.0 / NULLIF(${total_impressions},0) * 1000.0 ;;
    value_format_name: usd
  }

  measure: average_value_per_impression {
    label: "Value per Impression"
    description: "Average value per ad impression viewed."
    type: number
    sql: ${total_conversionvalue}*1.0 / NULLIF(${total_impressions},0) ;;
    value_format_name: usd
  }

  measure: average_value_per_cost {
    label: "ROAS"
    description: "Average Return on Ad Spend."
    type: number
    sql: ${total_conversionvalue}*1.0 / NULLIF(${total_cost},0) ;;
    value_format_name: percent_0
  }

  measure: average_conversion_rate {
    label: "Conversion Rate"
    description: "Percent of people that convert after they interact with an ad."
    type: number
    sql: ${total_conversions}*1.0 / NULLIF(${total_clicks},0) ;;
    value_format_name: percent_2
    drill_fields: [fact.date_date, campaign.name, average_conversion_rate]
  }

  measure: cumulative_spend {
    type: running_total
    sql: ${total_cost} ;;
    drill_fields: [fact.date_date, campaign.name, fact.total_cost]
    value_format_name: usd_0
    direction: "column"
  }

  measure: cumulative_conversions {
    type: running_total
    sql: ${total_conversions} ;;
    drill_fields: [fact.date_date, campaign.name, fact.total_cost]
    value_format_name: decimal_0
    direction: "column"
  }

  measure: total_clicks {
    label: "Clicks"
    description: "Total ad clicks."
    type: sum
    sql: ${clicks} ;;
    value_format_name: decimal_0
    drill_fields: [fact.date_date, campaign.name, total_clicks]
  }

  measure: total_conversions {
    label: "Conversions"
    description: "Total conversions."
    type: sum
    sql: ${conversions} ;;
    value_format_name: decimal_0
    drill_fields: [fact.date_date, campaign.name, total_conversions]
  }

  measure: total_conversionvalue {
    label: "Conv. Value"
    description: "Total conversion value."
    type: sum
    sql: ${conversionvalue} ;;
    value_format_name: usd_0
  }

  measure: total_cost {
    label: "Cost"
    description: "Total cost."
    type: sum
    sql: ${cost} ;;
    value_format_name: usd_0
    drill_fields: [fact.date_date, campaign.name, total_cost]
  }

  measure: total_impressions {
    label: "Impressions"
    description: "Total ad impressions."
    type:  sum
    sql:  ${impressions} ;;
    drill_fields: [external_customer_id, total_impressions]
    value_format_name: decimal_0
  }

  set: ad_metrics_set {
    fields: [
      cost,
      impressions,
      clicks,
      conversions,
      conversionvalue,
      click_rate,
      conversion_rate,
      cost_per_impression,
      cost_per_click,
      cost_per_conversion,
      total_cost,
      total_impressions,
      total_clicks,
      total_conversions,
      total_conversionvalue,
      average_click_rate,
      average_conversion_rate,
      average_cost_per_impression,
      average_cost_per_click,
      average_cost_per_conversion,
      cumulative_conversions,
      cumulative_spend,
      average_value_per_cost
    ]
  }
}
view: linkedin_ad_metrics_base {
  extension: required
  extends: [ad_metrics_base]

  dimension: conversions {
    sql: ${external_website_conversions} ;;
  }

  dimension: conversionvalue {
    sql: ${conversion_value_in_local_currency} ;;
  }

  dimension: cost {
    sql: ${cost_in_local_currency} ;;
  }
}
view: linkedin_ad_metrics_base_dimensions {
  extension: required

  dimension: action_clicks {
    type: number
    sql: ${TABLE}.action_clicks ;;
  }

  dimension: ad_unit_clicks {
    type: number
    sql: ${TABLE}.ad_unit_clicks ;;
  }

  dimension: card_clicks {
    type: number
    sql: ${TABLE}.card_clicks ;;
  }

  dimension: card_impressions {
    type: number
    sql: ${TABLE}.card_impressions ;;
  }

  dimension: clicks {
    type: number
    sql: ${TABLE}.clicks ;;
  }

  dimension: comments {
    type: number
    sql: ${TABLE}.comments ;;
  }

  dimension: comments_likes {
    type: number
    sql: ${TABLE}.comments_likes ;;
  }

  dimension: company_page_clicks {
    type: number
    sql: ${TABLE}.company_page_clicks ;;
  }

  dimension: conversion_value_in_local_currency {
    type: number
    sql: ${TABLE}.conversion_value_in_local_currency ;;
  }

  dimension: cost_in_local_currency {
    type: number
    sql: ${TABLE}.cost_in_local_currency ;;
  }

  dimension: cost_in_usd {
    type: number
    sql: ${TABLE}.cost_in_usd ;;
  }

  dimension: external_website_conversions {
    type: number
    sql: ${TABLE}.external_website_conversions ;;
  }

  dimension: external_website_post_click_conversions {
    type: number
    sql: ${TABLE}.external_website_post_click_conversions ;;
  }

  dimension: external_website_post_view_conversions {
    type: number
    sql: ${TABLE}.external_website_post_view_conversions ;;
  }

  dimension: follows {
    type: number
    sql: ${TABLE}.follows ;;
  }

  dimension: impressions {
    type: number
    sql: ${TABLE}.impressions ;;
  }

  dimension: landing_page_clicks {
    type: number
    sql: ${TABLE}.landing_page_clicks ;;
  }

  dimension: likes {
    type: number
    sql: ${TABLE}.likes ;;
  }

  dimension: shares {
    type: number
    sql: ${TABLE}.shares ;;
  }

  dimension: text_url_clicks {
    type: number
    sql: ${TABLE}.text_url_clicks ;;
  }

  dimension: total_engagements {
    type: number
    sql: ${TABLE}.total_engagements ;;
  }

  dimension: video_completions {
    type: number
    sql: ${TABLE}.video_completions ;;
  }

  dimension: video_views {
    type: number
    sql: ${TABLE}.video_views ;;
  }

  dimension: viral_card_clicks {
    type: number
    sql: ${TABLE}.viral_card_clicks ;;
  }

  dimension: viral_card_impressions {
    type: number
    sql: ${TABLE}.viral_card_impressions ;;
  }

  dimension: viral_clicks {
    type: number
    sql: ${TABLE}.viral_clicks ;;
  }

  dimension: viral_comment_likes {
    type: number
    sql: ${TABLE}.viral_comment_likes ;;
  }

  dimension: viral_comments {
    type: number
    sql: ${TABLE}.viral_comments ;;
  }

  dimension: viral_comments_likes {
    type: number
    sql: ${TABLE}.viral_comments_likes ;;
  }

  dimension: viral_company_page_clicks {
    type: number
    sql: ${TABLE}.viral_company_page_clicks ;;
  }

  dimension: viral_extrernal_website_conversions {
    type: number
    sql: ${TABLE}.viral_extrernal_website_conversions ;;
  }

  dimension: viral_extrernal_website_post_click_conversions {
    type: number
    sql: ${TABLE}.viral_extrernal_website_post_click_conversions ;;
  }

  dimension: viral_extrernal_website_post_view_conversions {
    type: number
    sql: ${TABLE}.viral_extrernal_website_post_view_conversions ;;
  }

  dimension: viral_follows {
    type: number
    sql: ${TABLE}.viral_follows ;;
  }

  dimension: viral_impressions {
    type: number
    sql: ${TABLE}.viral_impressions ;;
  }

  dimension: viral_landing_page_clicks {
    type: number
    sql: ${TABLE}.viral_landing_page_clicks ;;
  }

  dimension: viral_likes {
    type: number
    sql: ${TABLE}.viral_likes ;;
  }

  dimension: viral_one_click_leads {
    type: number
    sql: ${TABLE}.viral_one_click_leads ;;
  }

  dimension: viral_shares {
    type: number
    sql: ${TABLE}.viral_shares ;;
  }

  dimension: viral_total_engagements {
    type: number
    sql: ${TABLE}.viral_total_engagements ;;
  }

  dimension: viral_video_completions {
    type: number
    sql: ${TABLE}.viral_video_completions ;;
  }

  dimension: viral_video_views {
    type: number
    sql: ${TABLE}.viral_video_views ;;
  }
}
view: linkedin_ads_config {
  extension: required

# Should remain hidden as it's not intended to be used as a column.
  dimension: linkedin_ads_schema {
    hidden: yes
    sql:@{LINKEDIN_SCHEMA};;
  }
}
view: date_primary_key_base {
  extension: required

  dimension: primary_key {
    hidden: yes
    primary_key: yes
    sql: CONCAT(CAST(${_date} AS STRING), "-", ${key_base}) ;;
  }
}
view: date_base {
  extension: required

  dimension_group: date {
    group_label: "Event"
    label: ""
    type: time
    datatype: date
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week,
      day_of_week_index,
      day_of_month,
      day_of_year
    ]
    convert_tz: no
    sql: ${_date} ;;
  }

  dimension: date_week_date {
    group_label: "Event"
    label: "Week Date"
    hidden: yes
    type: date
    convert_tz: no
    sql: CAST(${date_week} AS DATE) ;;
  }

  dimension: date_month_date {
    group_label: "Event"
    label: "Month Date"
    hidden: yes
    type: date
    convert_tz: no
    sql:
      {% if _dialect._name == 'redshift' %}
        DATETRUNC(${date_date}, MONTH)
      {% else %}
        DATE_TRUNC(MONTH, ${date_date})
      {% endif %}
    ;;
    }

    dimension: date_quarter_date {
      group_label: "Event"
      label: "Quarter Date"
      hidden: yes
      type: date
      convert_tz: no
      sql: {% if _dialect._name == 'redshift' %}
        DATETRUNC(QUARTER, ${date_date})
      {% else %}
        DATE_TRUNC(${date_date}, QUARTER)
      {% endif %} ;;
      }

      dimension: date_year_date {
        group_label: "Event"
        label: "Year Date"
        hidden: yes
        type: date
        convert_tz: no
        sql: {% if _dialect._name == 'redshift' %}
                  DATETRUNC(YEAR, ${date_date})
                  {% else %}
                  DATE_TRUNC(${date_date}, YEAR)
                {% endif %}  ;;
        }

        dimension: date_day_of_quarter {
          group_label: "Event"
          label: "Day of Quarter"
          hidden: yes
          type: number
          sql: {% if _dialect._name == 'redshift' %}
                    DATEDIFF(day, ${date_date}, ${date_quarter_date})
                    {% else %}
                    DATE_DIFF(${date_date}, ${date_quarter_date}, day)
                  {% endif %}  ;;
          }

          dimension: date_last_week {
            group_label: "Event"
            label: "Last Week"
            hidden: yes
            type: date
            convert_tz: no
            sql: {% if _dialect._name == 'redshift' %}
                      DATEADD(week, -1, ${date_quarter_date})
                      {% else %}
                      DATE_ADD(${date_date}), INTERVAL -1 WEEK)
                    {% endif %} ;;
            }

            dimension: date_last_month {
              group_label: "Event"
              label: "Last Month"
              hidden: yes
              type: date
              convert_tz: no
              sql: {% if _dialect._name == 'redshift' %}
                        DATEADD(month, -1, ${date_date})
                        {% else %}
                        DATE_ADD(${date_date}), INTERVAL -1 MONTH)
                      {% endif %} ;;
              }

              dimension: date_last_quarter {
                group_label: "Event"
                label: "Last Quarter"
                hidden: yes
                type: date
                convert_tz: no
                sql: {% if _dialect._name == 'redshift' %}
                          DATEADD(quarter, -1, ${date_date})
                          {% else %}
                          DATE_ADD(${date_date}), INTERVAL -1 QUARTER)
                          {% endif %} ;;
                }

                dimension: date_next_week {
                  hidden: yes
                  type: date
                  convert_tz: no
                  sql:  {% if _dialect._name == 'redshift' %}
                              DATEADD(week, 1, ${date_date})
                              {% else %}
                              DATE_ADD(${date_date}), INTERVAL 1 WEEK)
                              {% endif %} ;;
                  }

                  dimension: date_next_month {
                    hidden: yes
                    type: date
                    convert_tz: no
                    sql: {% if _dialect._name == 'redshift' %}
                                DATEADD(month, 1, ${date_date})
                                {% else %}
                                DATE_ADD(${date_date}), INTERVAL 1 MONTH)
                                {% endif %}  ;;
                    }

                    dimension: date_next_quarter {
                      hidden: yes
                      type: date
                      convert_tz: no
                      sql: {% if _dialect._name == 'redshift' %}
                                  DATEADD(quarter, 1, ${date_date})
                                  {% else %}
                                  DATE_ADD(${date_date}), INTERVAL 1 QUARTER)
                                  {% endif %}  ;;
                      }

                      dimension: date_next_year {
                        hidden: yes
                        type: date
                        convert_tz: no
                        sql: {% if _dialect._name == 'redshift' %}
                                    DATEADD(year, 1, ${date_date})
                                    {% else %}
                                    DATE_ADD(${date_date}), INTERVAL 1 YEAR)
                                    {% endif %}  ;;
                        }

                        dimension: date_last_year {
                          hidden: yes
                          type: date
                          convert_tz: no
                          sql: {% if _dialect._name == 'redshift' %}
                                      DATEADD(year, -1, ${date_date})
                                      {% else %}
                                      DATE_ADD(${date_date}), INTERVAL -1 YEAR)
                                      {% endif %}  ;;
                          }

                          dimension: date_days_prior {
                            hidden: yes
                            type: number
                            sql: {% if _dialect._name == 'redshift' %}
                                        DATEDIFF(day, ${date_date}, CURRENT_DATE)
                                      {% else %}
                                        DATE_DIFF(${date_date}, CURRENT_DATE(), DAY)
                                      {% endif %}  ;;
                            }

                            dimension: date_day_of_7_days_prior {
                              hidden: yes
                              type: number
                              sql: MOD(MOD(${date_days_prior}, 7) + 7, 7) ;;
                            }

                            dimension: date_day_of_28_days_prior {
                              hidden: yes
                              type: number
                              sql: MOD(MOD(${date_days_prior}, 28) + 28, 28) ;;
                            }

                            dimension: date_day_of_91_days_prior {
                              hidden: yes
                              type: number
                              sql: MOD(MOD(${date_days_prior}, 91) + 91, 91) ;;
                            }

                            dimension: date_day_of_364_days_prior {
                              hidden: yes
                              type: number
                              sql: MOD(MOD(${date_days_prior}, 364) + 364, 364) ;;
                            }

                            dimension: date_date_7_days_prior {
                              hidden: yes
                              type: date
                              convert_tz: no
                              sql: {% if _dialect._name == 'redshift' %}
                                          DATEADD(day, -${date_day_of_7_days_prior}, ${date_date})
                                        {% else %}
                                          DATE_ADD(${date_date}, INTERVAL -${date_day_of_7_days_prior} DAY)
                                        {% endif %} ;;
                              }

                              dimension: date_date_28_days_prior {
                                hidden: yes
                                type: date
                                convert_tz: no
                                sql: {% if _dialect._name == 'redshift' %}
                                            DATEADD(day, -${date_day_of_28_days_prior}, ${date_date})
                                          {% else %}
                                            DATE_ADD(${date_date}, INTERVAL -${date_day_of_28_days_prior} DAY)
                                          {% endif %} ;;
                                }

                                dimension: date_date_91_days_prior {
                                  hidden: yes
                                  type: date
                                  convert_tz: no
                                  sql: {% if _dialect._name == 'redshift' %}
                                              DATEADD(day, -${date_day_of_91_days_prior}, ${date_date})
                                            {% else %}
                                              DATE_ADD(${date_date}, INTERVAL -${date_day_of_91_days_prior} DAY)
                                            {% endif %} ;;
                                  }

                                  dimension: date_date_364_days_prior {
                                    hidden: yes
                                    type: date
                                    convert_tz: no
                                    sql: {% if _dialect._name == 'redshift' %}
                                                DATEADD(day, -${date_day_of_364_days_prior}, ${date_date})
                                              {% else %}
                                                DATE_ADD(${date_date}, INTERVAL -${date_day_of_364_days_prior} DAY)
                                              {% endif %} ;;
                                    }

                                  }
view: period_base {
  extension: required

  filter: date_range {
    hidden: yes
    type: date
    convert_tz: no
    sql: ${in_date_range} ;;
  }

  dimension: date_start_date_range {
    hidden: yes
    type: date
    convert_tz: no
    sql: {% date_start date_range %} ;;
  }

  dimension: date_end_date_range {
    hidden: yes
    type: date
    convert_tz: no
    sql: {% date_end date_range %} ;;
  }

  dimension: date_range_difference {
    hidden: yes
    type: number
    sql: {% if _dialect._name == 'redshift' %}
        DATEDIFF(day, ${date_end_date_range}, ${date_start_date_range})
      {% else %}
        DATE_DIFF(${date_end_date_range}, ${date_start_date_range}, day)
      {% endif %} ;;
    }

    dimension: in_date_range {
      hidden: yes
      type: yesno
      sql: {% condition date_range %}CAST(${fact.date_raw} AS TIMESTAMP){% endcondition %} ;;
    }

    dimension: date_range_day_of_range_prior {
      hidden: yes
      type: number
      sql: MOD(MOD(${date_days_prior}, ${date_range_difference}) + ${date_range_difference}, ${date_range_difference}) ;;
    }

    dimension: date_range_days_prior {
      hidden: yes
      type: date
      convert_tz: no
      sql: {% if _dialect._name == 'redshift' %}
        DATEADD(day, -${date_range_day_of_range_prior}, ${date_date})
      {% else %}
        DATE_ADD(${date_date}, INTERVAL -${date_range_day_of_range_prior} DAY)
      {% endif %}  ;;
      }

      parameter: period {
        description: "Prior Period for Comparison"
        type: string
        allowed_value: {
          value: "day"
          label: "Day"
        }
        allowed_value: {
          value: "week"
          label: "Week (Mon - Sun)"
        }
        allowed_value: {
          value: "month"
          label: "Month"
        }
        allowed_value: {
          value: "quarter"
          label: "Quarter"
        }
        allowed_value: {
          value: "year"
          label: "Year"
        }
        allowed_value: {
          value: "7 day"
          label: "Last 7 Days"
        }
        allowed_value: {
          value: "28 day"
          label: "Last 28 Days"
        }
        allowed_value: {
          value: "91 day"
          label: "Last 91 Days"
        }
        allowed_value: {
          value: "364 day"
          label: "Last 364 Days"
        }
        default_value: "28 day"
      }
      dimension: date_period {
        type: date
        convert_tz: no
        label_from_parameter: period
        group_label: "Event"
        sql: {% if _dialect._name == 'redshift' %}
          {% if fact.period._parameter_value contains "day" %}
          {% if fact.period._parameter_value == "'7 day'" %}${date_date_7_days_prior}
          {% elsif fact.period._parameter_value == "'28 day'" %}${date_date_28_days_prior}
          {% elsif fact.period._parameter_value == "'91 day'" %}${date_date_91_days_prior}
          {% elsif fact.period._parameter_value == "'364 day'" %}${date_date_364_days_prior}
          {% else %}${date_date}
          {% endif %}
          {% elsif fact.period._parameter_value contains "week" %}${date_week}
          {% elsif fact.period._parameter_value contains "month" %}${date_month_date}
          {% elsif fact.period._parameter_value contains "quarter" %}${date_quarter_date}
          {% elsif fact.period._parameter_value contains "year" %}${date_year_date}
          {% endif %}
      {% else %}
        TIMESTAMP({% if fact.period._parameter_value contains "day" %}
        {% if fact.period._parameter_value == "'7 day'" %}${date_date_7_days_prior}
        {% elsif fact.period._parameter_value == "'28 day'" %}${date_date_28_days_prior}
        {% elsif fact.period._parameter_value == "'91 day'" %}${date_date_91_days_prior}
        {% elsif fact.period._parameter_value == "'364 day'" %}${date_date_364_days_prior}
        {% else %}${date_date}
        {% endif %}
        {% elsif fact.period._parameter_value contains "week" %}${date_week}
        {% elsif fact.period._parameter_value contains "month" %}${date_month_date}
        {% elsif fact.period._parameter_value contains "quarter" %}${date_quarter_date}
        {% elsif fact.period._parameter_value contains "year" %}${date_year_date}
      {% endif %})
      {% endif %} ;;
        allow_fill: no
      }
      dimension: date_end_of_period {
        type: date
        convert_tz: no
        label_from_parameter: period
        group_label: "Event"
        sql: {% if _dialect._name == 'redshift' %}
                  {% if fact.period._parameter_value contains "day" %}
                  {% if fact.period._parameter_value == "'7 day'" %}DATEADD(day, 7, ${date_period})
                  {% elsif fact.period._parameter_value == "'28 day'" %}DATEADD(day, 28, ${date_period})
                  {% elsif fact.period._parameter_value == "'91 day'" %}DATEADD(day, 91, ${date_period})
                  {% elsif fact.period._parameter_value == "'364 day'" %}DATEADD(day, 364, ${date_period})
                  {% else %}DATEADD(day, 1, ${date_date})
                  {% endif %}
                  {% elsif fact.period._parameter_value contains "week" %}DATEADD(week, 1, ${date_period})
                  {% elsif fact.period._parameter_value contains "month" %}DATEADD(month, 1, ${date_period})
                  {% elsif fact.period._parameter_value contains "quarter" %}DATEADD(quarter, 1, ${date_period})
                  {% elsif fact.period._parameter_value contains "year" %}DATEADD(year, 1, ${date_period})
                  {% endif %}
                {% else %}
                  TIMESTAMP({% if fact.period._parameter_value contains "day" %}
                  {% if fact.period._parameter_value == "'7 day'" %}DATE_ADD(${date_period}, INTERVAL 7 DAY)
                  {% elsif fact.period._parameter_value == "'28 day'" %}DATE_ADD(${date_period}, INTERVAL 28 DAY)
                  {% elsif fact.period._parameter_value == "'91 day'" %}DATE_ADD(${date_period}, INTERVAL 91 DAY)
                  {% elsif fact.period._parameter_value == "'364 day'" %}DATE_ADD(${date_period}, INTERVAL 364 DAY)
                  {% else %}DATE_ADD(${date_date}, INTERVAL 1 DAY)
                  {% endif %}
                  {% elsif fact.period._parameter_value contains "week" %}DATE_ADD(${date_period}, INTERVAL 1 WEEK)
                  {% elsif fact.period._parameter_value contains "month" %}DATE_ADD(${date_period}, INTERVAL 1 MONTH)
                  {% elsif fact.period._parameter_value contains "quarter" %}DATE_ADD(${date_period}, INTERVAL 1 QUARTER)
                  {% elsif fact.period._parameter_value contains "year" %}DATE_ADD(${date_period}, INTERVAL 1 YEAR)
                  {% endif %})
                {% endif %} ;;
        allow_fill: no
      }
      dimension: date_period_latest {
        type: yesno
        group_label: "Event"
        sql: {% if _dialect._name == 'redshift' %}
          ${date_period} < CURRENT_DATE AND ${date_end_of_period} >= CURRENT_DATE
        {% else %}
          ${date_period} < CURRENT_DATE() AND ${date_end_of_period} >= CURRENT_DATE()
        {% endif %} ;;
    # expression: ${date_period} < now() AND ${date_end_of_period} >= now() ;;
        }
        dimension: date_period_before_latest {
          type: yesno
          group_label: "Event"
          sql: {% if _dialect._name == 'redshift' %}
                      ${date_period} < CURRENT_DATE
                     {% else %}
                      ${date_period} < CURRENT_DATE()
                     {% endif %} ;;
                # expression: ${date_period} < now() ;;
          }
          dimension: date_period_comparison_period {
            hidden: yes
            description: "Is the selected period (This Period) in the last two periods?"
            type: yesno
            group_label: "Event"
            sql: ${date_period} >=
                    {% if _dialect._name == 'redshift' %}
                      {% if period._parameter_value contains "day" %}
                        {% if period._parameter_value == "'7 day'" %}DATEADD(day, -2*7, CURRENT_DATE)
                        {% elsif period._parameter_value == "'28 day'" %}DATEADD(day, -2*28, CURRENT_DATE)
                        {% elsif period._parameter_value == "'91 day'" %}DATEADD(day, -2*91, CURRENT_DATE)
                        {% elsif period._parameter_value == "'364 day'" %}DATEADD(day, -2*364, CURRENT_DATE)
                        {% else %}DATEADD(day, -2, CURRENT_DATE)
                        {% endif %}
                      {% elsif period._parameter_value contains "week" %}DATEADD(week, -2, CURRENT_DATE)
                      {% elsif period._parameter_value contains "month" %}DATEADD(month, -2, CURRENT_DATE)
                      {% elsif period._parameter_value contains "quarter" %}DATEADD(quarter, -2, CURRENT_DATE)
                      {% elsif period._parameter_value contains "year" %}DATEADD(year, -2, CURRENT_DATE)
                      {% endif %}
                    {% else %}
                      {% if period._parameter_value contains "day" %}
                        {% if period._parameter_value == "'7 day'" %}DATE_ADD(CURRENT_DATE(), INTERVAL -2*7 DAY)
                        {% elsif period._parameter_value == "'28 day'" %}DATE_ADD(CURRENT_DATE(), INTERVAL -2*28 DAY)
                        {% elsif period._parameter_value == "'91 day'" %}DATE_ADD(CURRENT_DATE(), INTERVAL -2*91 DAY)
                        {% elsif period._parameter_value == "'364 day'" %}DATE_ADD(CURRENT_DATE(), INTERVAL -2*364 DAY)
                        {% else %}DATE_ADD(CURRENT_DATE(), INTERVAL -2 DAY)
                        {% endif %}
                      {% elsif period._parameter_value contains "week" %}DATE_ADD(CURRENT_DATE(), INTERVAL -2 WEEK)
                      {% elsif period._parameter_value contains "month" %}DATE_ADD(CURRENT_DATE(), INTERVAL -2 MONTH)
                      {% elsif period._parameter_value contains "quarter" %}DATE_ADD(CURRENT_DATE(), INTERVAL -2 QUARTER)
                      {% elsif period._parameter_value contains "year" %}DATE_ADD(CURRENT_DATE(), INTERVAL -2 YEAR)
                      {% endif %}
                    {% endif %};;
          }
          dimension: date_period_dynamic_grain {
            datatype: date
            hidden: yes
            type: date
            convert_tz: no
            group_label: "Event"
            label: "{% if fact.period._parameter_value contains 'year'
                       or fact.period._parameter_value contains '364 day' %} Month
                    {% elsif fact.period._parameter_value contains 'quarter'
                       or fact.period._parameter_value contains '91 day' %} Week
                    {% else %} Date
                    {% endif %}"
            sql: {% if fact.period._parameter_value contains 'year'
                      or fact.period._parameter_value contains '364 day' %}${date_month_date}
                    {% elsif fact.period._parameter_value contains 'quarter'
                      or fact.period._parameter_value contains '91 day' %}${date_week}
                    {% else %} ${date_raw}
                    {% endif %} ;;
            allow_fill: no
          }
          dimension: date_day_of_period {
            hidden: yes
            type: number
            label: "{% if fact.period._parameter_value contains 'day' %}Day of Period
                    {% elsif fact.period._parameter_value contains 'week' %}Day of Week
                    {% elsif fact.period._parameter_value contains 'month' %}Day of Month
                    {% elsif fact.period._parameter_value contains 'quarter' %}Day of Quarter
                    {% elsif fact.period._parameter_value contains 'year' %}Day of Year
                    {% endif %}"
            group_label: "Event"
            sql: {% if fact.period._parameter_value contains "day" %}
                      {% if fact.period._parameter_value == "'7 day'" %}${date_day_of_7_days_prior}
                      {% elsif fact.period._parameter_value == "'28 day'" %}${date_day_of_28_days_prior}
                      {% elsif fact.period._parameter_value == "'91 day'" %}${date_day_of_91_days_prior}
                      {% elsif fact.period._parameter_value == "'364 day'" %}${date_day_of_364_days_prior}
                      {% else %}0
                      {% endif %}
                      {% elsif fact.period._parameter_value contains "week" %}${date_day_of_week_index}
                      {% elsif fact.period._parameter_value contains "month" %}${date_day_of_month}
                      {% elsif fact.period._parameter_value contains "quarter" %}${date_day_of_quarter}
                      {% elsif fact.period._parameter_value contains "year" %}${date_day_of_year}
                      {% endif %} ;;
                  # html: {{ value | plus: 1 }} - {{ date_date }};;
                  # required_fields: [date_date]
            }
            dimension: date_last_period {
              group_label: "Event"
              label: "Prior Period"
              type: date
              convert_tz: no
              sql: {% if _dialect._name == 'redshift' %}
                        DATEADD(
                        {% if fact.period._parameter_value contains "day" %}day
                        {% elsif fact.period._parameter_value contains "week" %}week
                        {% elsif fact.period._parameter_value contains "month" %}month
                        {% elsif fact.period._parameter_value contains "quarter" %}quarter
                        {% elsif fact.period._parameter_value contains "year" %}year
                        {% endif %}
                        , - {% if fact.period._parameter_value == "'7 day'" %}7
                        {% elsif fact.period._parameter_value == "'28 day'" %}28
                        {% elsif fact.period._parameter_value == "'91 day'" %}91
                        {% elsif fact.period._parameter_value == "'364 day'" %}364
                        {% else %}1
                        {% endif %}
                        , ${date_period})
                      {% else %}
                        DATE_ADD(${date_period}, INTERVAL -{% if fact.period._parameter_value == "'7 day'" %}7
                        {% elsif fact.period._parameter_value == "'28 day'" %}28
                        {% elsif fact.period._parameter_value == "'91 day'" %}91
                        {% elsif fact.period._parameter_value == "'364 day'" %}364
                        {% else %}1
                        {% endif %}
                        {% if fact.period._parameter_value contains "day" %}day
                        {% elsif fact.period._parameter_value contains "week" %}week
                        {% elsif fact.period._parameter_value contains "month" %}month
                        {% elsif fact.period._parameter_value contains "quarter" %}quarter
                        {% elsif fact.period._parameter_value contains "year" %}year
                        {% endif %})
                      {% endif %} ;;
              allow_fill: no
            }
          }
view: ad_metrics_period_comparison_base {
  extension: required

  dimension: impressions_period_delta {
    hidden: yes
    type: number
    sql: ${fact.impressions} - ${last_fact.impressions} ;;
    group_label: "Period Comparisons"
  }
  dimension: clicks_period_delta {
    hidden: yes
    type: number
    sql: ${fact.clicks} - ${last_fact.clicks} ;;
    group_label: "Period Comparisons"
  }
  dimension: conversions_period_delta {
    hidden: yes
    type: number
    sql: ${fact.conversions} - ${last_fact.conversions} ;;
    group_label: "Period Comparisons"
  }
  dimension: conversionvalue_period_delta {
    hidden: yes
    type: number
    sql: ${fact.conversionvalue} - ${last_fact.conversionvalue} ;;
    group_label: "Period Comparisons"
  }
  dimension: click_rate_period_percent_change {
    hidden: yes
    type: number
    sql: (${fact.click_rate} - ${last_fact.click_rate}) / NULLIF(${last_fact.click_rate}, 0) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  dimension: click_rate_period_percent_change_abs {
    hidden: yes
    type: number
    sql: abs(${fact.click_rate_period_percent_change}) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  dimension: value_per_cost_period_percent_change {
    hidden: yes
    type: number
    sql: (${fact.value_per_cost} - ${last_fact.value_per_cost}) / NULLIF(${last_fact.value_per_cost}, 0) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  dimension:  value_per_cost_period_percent_change_abs {
    hidden: yes
    type: number
    sql: abs(${fact.value_per_cost_period_percent_change}) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  dimension: conversion_rate_period_percent_change {
    hidden: yes
    type: number
    sql: (${fact.conversion_rate} - ${last_fact.conversion_rate}) / NULLIF(${last_fact.conversion_rate}, 0) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  dimension: conversion_rate_period_percent_change_abs {
    hidden: yes
    type: number
    sql: abs(${fact.conversion_rate_period_percent_change}) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  dimension: cost_per_click_period_percent_change {
    hidden: yes
    type: number
    sql: (${fact.cost_per_click} - ${last_fact.cost_per_click}) / NULLIF(${last_fact.cost_per_click}, 0) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  dimension: cost_per_click_period_percent_change_abs {
    hidden: yes
    type: number
    sql: abs(${fact.cost_per_click_period_percent_change}) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  dimension: cost_per_conversion_period_percent_change {
    hidden: yes
    type: number
    sql: (${fact.cost_per_conversion} - ${last_fact.cost_per_conversion}) / NULLIF(${last_fact.cost_per_conversion}, 0) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  dimension: cost_per_conversion_period_percent_change_abs {
    hidden: yes
    type: number
    sql: abs(${fact.cost_per_conversion_period_percent_change}) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }

  dimension: click_rate_both_periods {
    hidden: yes
    type: number
    # sql:  IF((${fact.clicks} + ${last_fact.clicks}) / NULLIF((${fact.impressions} + ${last_fact.impressions}),0)>1,
    #         NULL,
    #        (${fact.clicks} + ${last_fact.clicks}) / NULLIF((${fact.impressions} + ${last_fact.impressions}),0));;
    expression:
      if((${fact.clicks} + ${last_fact.clicks}) / if((${fact.impressions} + ${last_fact.impressions})=0,null,${fact.impressions} + ${last_fact.impressions})>1,
        null,
        (${fact.clicks} + ${last_fact.clicks}) / if((${fact.impressions} + ${last_fact.impressions})=0,null,${fact.impressions} + ${last_fact.impressions}))
    ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }

  dimension: click_rate_period_z_score {
    hidden: yes
    type: number
    sql:
    (
      (${fact.click_rate}) -
      (${last_fact.click_rate})
    ) /
    NULLIF(SQRT(
      ${click_rate_both_periods} *
      (1 - ${click_rate_both_periods}) *
      ((1 / NULLIF(${fact.impressions},0)) + (1 / NULLIF(${last_fact.impressions},0)))
    ),0) ;;
    group_label: "Period Comparisons"
    value_format_name: decimal_2
  }
  dimension: click_rate_period_significant {
    hidden: yes
    type: yesno
    sql:  (${fact.click_rate_period_z_score} > 1.96) OR
      (${fact.click_rate_period_z_score} < -1.96) ;;
    group_label: "Period Comparisons"
  }
  dimension: click_rate_period_better {
    hidden: yes
    type: yesno
    sql:  ${fact.click_rate} > ${last_fact.click_rate} ;;
    group_label: "Period Comparisons"
  }

  dimension: conversion_rate_both_periods {
    hidden: yes
    type: number
    #sql:  IF((${fact.conversions} + ${last_fact.conversions}) / NULLIF((${fact.clicks} + ${last_fact.clicks}),0) > 1,
    #         NULL,
    #         (${fact.conversions} + ${last_fact.conversions}) / NULLIF((${fact.clicks} + ${last_fact.clicks}),0)) ;;
    expression:
      if((${fact.conversions} + ${last_fact.conversions}) / if((${fact.clicks} + ${last_fact.clicks})=0,null,${fact.clicks} + ${last_fact.clicks}) > 1,
        null,
        (${fact.conversions} + ${last_fact.conversions}) / if((${fact.clicks} + ${last_fact.clicks})=0,null,${fact.clicks} + ${last_fact.clicks}))
    ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }

  dimension: conversion_rate_period_z_score {
    hidden: yes
    type: number
    sql:
    (
      (${fact.conversion_rate}) -
      (${last_fact.conversion_rate})
    ) /
    NULLIF(SQRT(
      ${conversion_rate_both_periods} *
      (1 - ${conversion_rate_both_periods}) *
      ((1 / NULLIF(${fact.clicks},0)) + (1 / NULLIF(${last_fact.clicks},0)))
    ),0) ;;
    group_label: "Period Comparisons"
    value_format_name: decimal_2
  }
  dimension: conversion_rate_period_significant {
    hidden: yes
    type: yesno
    sql:  (${fact.conversion_rate_period_z_score} > 1.96) OR
      (${fact.conversion_rate_period_z_score} < -1.96) ;;
    group_label: "Period Comparisons"
  }
  dimension: conversion_rate_period_better {
    hidden: yes
    type: yesno
    sql:  ${fact.conversion_rate} > ${last_fact.conversion_rate} ;;
    group_label: "Period Comparisons"
  }
  measure: total_cost_period_delta {
    hidden: yes
    type: number
    sql: ${fact.total_cost} - ${last_fact.total_cost} ;;
    group_label: "Period Comparisons"
  }
  measure: total_impressions_period_delta {
    hidden: yes
    type: number
    sql: ${fact.total_impressions} - ${last_fact.total_impressions} ;;
    group_label: "Period Comparisons"
  }
  measure: total_clicks_period_delta {
    hidden: yes
    type: number
    sql: ${fact.total_clicks} - ${last_fact.total_clicks} ;;
    group_label: "Period Comparisons"
  }
  measure: total_conversions_period_delta {
    hidden: yes
    type: number
    sql: ${fact.total_conversions} - ${last_fact.total_conversions} ;;
    group_label: "Period Comparisons"
  }
  measure: total_conversionvalue_period_delta {
    hidden: yes
    type: number
    sql: ${fact.total_conversionvalue} - ${last_fact.total_conversionvalue} ;;
    group_label: "Period Comparisons"
  }
  measure: average_click_rate_period_percent_change {
    hidden: yes
    type: number
    sql: (${fact.average_click_rate} - ${last_fact.average_click_rate}) / NULLIF(${last_fact.average_click_rate}, 0) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  measure: average_click_rate_period_percent_change_abs {
    hidden: yes
    type: number
    sql: abs(${fact.average_click_rate_period_percent_change}) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  measure: average_conversion_rate_period_percent_change {
    hidden: yes
    type: number
    sql: (${fact.average_conversion_rate} - ${last_fact.average_conversion_rate}) / NULLIF(${last_fact.average_conversion_rate}, 0) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  measure: average_conversion_rate_period_percent_change_abs {
    hidden: yes
    type: number
    sql: abs(${fact.average_conversion_rate_period_percent_change}) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }

  measure: clicks_percent_change {
    hidden: yes
    type: number
    sql: (${fact.total_clicks} - ${last_fact.total_clicks}) / NULLIF(${last_fact.total_clicks}, 0) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  measure: clicks_percent_change_abs {
    hidden: yes
    type: number
    sql: abs(${fact.clicks_percent_change}) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  measure: average_cost_per_click_period_percent_change {
    hidden: yes
    type: number
    sql: (${fact.average_cost_per_click} - ${last_fact.average_cost_per_click}) / NULLIF(${last_fact.average_cost_per_click}, 0) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  measure: average_cost_per_click_period_percent_change_abs {
    hidden: yes
    type: number
    sql: abs(${fact.average_cost_per_click_period_percent_change}) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }

  measure: average_value_per_cost_period_percent_change {
    hidden: yes
    type: number
    sql: (${fact.average_value_per_cost} - ${last_fact.average_value_per_cost}) / NULLIF(${last_fact.average_value_per_cost}, 0) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  measure: average_value_per_cost_percent_change_abs {
    hidden: yes
    type: number
    sql: abs(${fact.average_value_per_cost_period_percent_change}) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  measure: average_cost_per_conversion_period_percent_change {
    hidden: yes
    type: number
    sql: (${fact.average_cost_per_conversion} - ${last_fact.average_cost_per_conversion}) / NULLIF(${last_fact.average_cost_per_conversion}, 0) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  measure: average_cost_per_conversion_period_percent_change_abs {
    hidden: yes
    type: number
    sql: abs(${fact.average_cost_per_conversion_period_percent_change}) ;;
    group_label: "Period Comparisons"
    value_format_name: percent_1
  }
  measure: average_click_rate_period_z_score {
    hidden: yes
    type: number
    sql:
    (
      (${fact.average_click_rate}) -
      (${last_fact.average_click_rate})
    ) /
    NULLIF(SQRT(
      (${fact.total_clicks} + ${last_fact.total_clicks}) / (${fact.total_impressions} + ${last_fact.total_impressions}) *
      (1 - (${fact.total_clicks} + ${last_fact.total_clicks}) / (${fact.total_impressions} + ${last_fact.total_impressions})) *
      ((1 / NULLIF(${fact.total_impressions},0)) + (1 / NULLIF(${last_fact.total_impressions},0)))
    ),0) ;;
    group_label: "Period Comparisons"
    value_format_name: decimal_2
  }
  measure: average_click_rate_period_significant {
    hidden: yes
    type: yesno
    sql:  (${fact.average_click_rate_period_z_score} > 1.96) OR
      (${fact.average_click_rate_period_z_score} < -1.96) ;;
    group_label: "Period Comparisons"
  }
  measure: average_click_rate_period_better {
    hidden: yes
    type: yesno
    sql:  ${fact.average_click_rate} > ${last_fact.average_click_rate} ;;
    group_label: "Period Comparisons"
  }
  measure: average_conversion_rate_period_z_score {
    hidden: yes
    type: number
    sql:
    (
      (${fact.average_conversion_rate}) -
      (${last_fact.average_conversion_rate})
    ) /
    NULLIF(SQRT(
      (${fact.total_conversions} + ${last_fact.total_conversions}) / (${fact.total_clicks} + ${last_fact.total_clicks}) *
      (1 - (${fact.total_conversions} + ${last_fact.total_conversions}) / (${fact.total_clicks} + ${last_fact.total_clicks})) *
      ((1 / NULLIF(${fact.total_clicks},0)) + (1 / NULLIF(${last_fact.total_clicks},0)))
    ),0) ;;
    group_label: "Period Comparisons"
    value_format_name: decimal_2
  }
  measure: average_conversion_rate_period_significant {
    hidden: yes
    type: yesno
    sql:  (${fact.average_conversion_rate_period_z_score} > 1.96) OR
      (${fact.average_conversion_rate_period_z_score} < -1.96) ;;
    group_label: "Period Comparisons"
  }
  measure: average_conversion_rate_period_better {
    hidden: yes
    type: yesno
    sql:  ${fact.average_conversion_rate} > ${last_fact.average_conversion_rate} ;;
    group_label: "Period Comparisons"
  }

  dimension: cost_per_click_big_mover {
    hidden: yes
    type: yesno
    sql: ${cost_per_click_period_percent_change_abs} > .2 ;;
    group_label: "Period Comparisons"
  }
  dimension: cost_per_conversion_big_mover {
    hidden: yes
    type: yesno
    sql: ${cost_per_conversion_period_percent_change_abs} > .2 ;;
    group_label: "Period Comparisons"
  }
  dimension: value_per_cost_big_mover {
    hidden: yes
    type: yesno
    sql: ${value_per_cost_period_percent_change_abs} > .2 ;;
    group_label: "Period Comparisons"
  }

  dimension: conversion_rate_big_mover {
    hidden: yes
    type: yesno
    sql: ${conversion_rate_period_percent_change_abs} > .2 AND ${conversion_rate_period_significant};;
    group_label: "Period Comparisons"
  }

  dimension: click_rate_big_mover {
    hidden: yes
    type: yesno
    sql: ${click_rate_period_percent_change_abs} > .2 AND ${click_rate_period_significant};;
    group_label: "Period Comparisons"
  }

  measure: cost_per_conversion_count_big_mover {
    hidden: yes
    type: count_distinct
    sql: ${key_base} ;;
    filters: {
      field: cost_per_conversion_big_mover
      value: "Yes"
    }
    group_label: "Period Comparisons"
  }

  measure: conversion_rate_count_big_mover {
    hidden: yes
    type: count_distinct
    sql: ${key_base} ;;
    filters: {
      field: conversion_rate_big_mover
      value: "Yes"
    }
    group_label: "Period Comparisons"
  }

  measure: click_rate_count_big_mover {
    hidden: yes
    type: count_distinct
    sql: ${key_base} ;;
    filters: {
      field: click_rate_big_mover
      value: "Yes"
    }
    group_label: "Period Comparisons"
  }
}
view: ad_metrics_dimension_base {
  extension: required

  dimension: clicks {
    hidden: yes
    type: number
    sql: ${TABLE}.clicks ;;
  }

  dimension: conversions {
    hidden: yes
    type: number
    sql: ${TABLE}.conversions ;;
  }

  dimension: conversionvalue {
    hidden: yes
    type: number
    sql: ${TABLE}.conversionvalue ;;
  }

  dimension: cost {
    hidden: yes
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: impressions {
    hidden: yes
    type: number
    sql: ${TABLE}.impressions ;;
  }

  dimension: click_rate {
    hidden: yes
    label: "Click Through Rate"
    description: "Percent of people that click on an ad."
    type: number
    sql: ${clicks}*1.0/nullif(${impressions},0) ;;
    value_format_name: percent_2
  }

  dimension: cost_per_conversion {
    hidden: yes
    label: "Cost per Conversion"
    description: "Cost per conversion."
    type: number
    sql: ${cost}*1.0 / NULLIF(${conversions},0) ;;
    value_format_name: usd
  }

  dimension: value_per_conversion {
    hidden: yes
    label: "Value per Conversion"
    description: "Conv. Value per conversion."
    type: number
    sql: ${conversionvalue}*1.0 / NULLIF(${conversions},0) ;;
    value_format_name: usd
  }

  dimension: cost_per_click {
    hidden: yes
    label: "Cost per Click"
    description: "Average cost per ad click."
    type: number
    sql: ${cost}*1.0 / NULLIF(${clicks},0) ;;
    value_format_name: usd
  }

  dimension: value_per_click {
    hidden: yes
    label: "Value per Click"
    description: "Conv. Value per Click."
    type: number
    sql: ${conversionvalue}*1.0 / NULLIF(${clicks},0) ;;
    value_format_name: usd
  }

  dimension: cost_per_impression {
    hidden: yes
    label: "CPM"
    description: "Average cost per 1000 ad impressions."
    type: number
    sql: ${cost}*1.0 / NULLIF(${impressions},0) * 1000.0 ;;
    value_format_name: usd
  }

  dimension: value_per_impression {
    hidden: yes
    label: "Value per Impression"
    description: "Conv. Value per Impression."
    type: number
    sql: ${conversionvalue}*1.0 / NULLIF(${impressions},0) ;;
    value_format_name: usd
  }

  dimension: value_per_cost {
    hidden: yes
    label: "ROAS"
    description: "Return on Ad Spend."
    type: number
    sql: ${conversionvalue}*1.0 / NULLIF(${cost},0) ;;
    value_format_name: percent_0
  }

  dimension: conversion_rate {
    hidden: yes
    label: "Conversion Rate"
    description: "Percent of people that convert after they interact with an ad."
    type: number
    sql: ${conversions}*1.0 / NULLIF(${clicks},0) ;;
    value_format_name: percent_2
  }
}
