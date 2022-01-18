

view: li_period_comparison {
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

view: linkedin_ad_impressions_campaign {
  extends: [linkedin_ad_impressions_campaign_template]
}

view: linkedin_ad_impressions_ad {
  extends: [linkedin_ad_impressions_ad_template]
}

view: ad_metrics_base {

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
    drill_fields: [fact.date_date, campaign.name, fact.total_conversions, fact.total_cost, fact.average_cost_per_conversion]
  }

  measure: average_cost_per_value {
    label: "Cost per value"
    description: "Cost per value."
    type: number
    sql: ${total_cost}*1.0 / NULLIF(${total_conversionvalue},0) ;;
    value_format_name: usd
    drill_fields: [fact.date_date, campaign.name, fact.total_conversionvalue, fact.total_cost, fact.average_cost_per_conversion]
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
    drill_fields: [fact.date_date, campaign.name, fact.total_conversions]
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
    sql: CAST(${_date} as DATE) ;;
  }

  dimension: date_week_date {
    group_label: "Event"
    label: "Week Date"
    hidden: yes
    type: date
    convert_tz: no
    sql: CAST(${date_week} AS DATE) ;;
#     expression: to_date(${date_week}) ;;
  }

  dimension: date_month_date {
    group_label: "Event"
    label: "Month Date"
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_TRUNC(${date_date}, MONTH) ;;
#     expression: trunc_months(${date_date});;
  }

  dimension: date_quarter_date {
    group_label: "Event"
    label: "Quarter Date"
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_TRUNC(${date_date}, QUARTER) ;;
#     expression: trunc_quarters(${date_date});;
  }

  dimension: date_year_date {
    group_label: "Event"
    label: "Year Date"
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_TRUNC(${date_date}, YEAR) ;;
#     expression: trunc_years(${date_date}) ;;
  }

  dimension: date_day_of_quarter {
    group_label: "Event"
    label: "Day of Quarter"
    hidden: yes
    type: number
    sql: DATE_DIFF(${date_date}, ${date_quarter_date}, day)  ;;
#     expression: diff_days(${date_quarter_date}, ${date_date}) ;;
  }

  dimension: date_last_week {
    group_label: "Event"
    label: "Last Week"
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}), INTERVAL -1 WEEK) ;;
#     expression: add_days(${date_date}, 7) ;;
  }

  dimension: date_last_month {
    group_label: "Event"
    label: "Last Month"
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}), INTERVAL -1 MONTH) ;;
#     expression: add_months(${date_date}, 1) ;;
  }

  dimension: date_last_quarter {
    group_label: "Event"
    label: "Last Quarter"
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}), INTERVAL -1 QUARTER) ;;
#     expression: add_months(${date_date}, -3) ;;
  }

  dimension: date_next_week {
    hidden: yes
    type: date
    convert_tz: no
    sql:  DATE_ADD(${date_date}), INTERVAL 1 WEEK) ;;
#     expression: add_days(${date_date}, 7) ;;
  }

  dimension: date_next_month {
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}), INTERVAL 1 MONTH) ;;
#     expression: add_months(${date_date}, 1) ;;
  }

  dimension: date_next_quarter {
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}), INTERVAL 1 QUARTER) ;;
#     expression: add_months(${date_date}, 3) ;;
  }

  dimension: date_next_year {
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}), INTERVAL 1 YEAR) ;;
#     expression: add_years(${date_date}, 1) ;;
  }

  dimension: date_last_year {
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}), INTERVAL -1 YEAR) ;;
#     expression: add_years(${date_date}, -1) ;;
  }

  dimension: date_days_prior {
    hidden: yes
    type: number
    sql: DATE_DIFF(${date_date}, CURRENT_DATE(), DAY) ;;
#     expression: diff_days(${date_date}, now()) ;;
  }

  dimension: date_day_of_7_days_prior {
    hidden: yes
    type: number
    sql: MOD(MOD(${date_days_prior}, 7) + 7, 7) ;;
#     expression: mod(mod(${date_days_prior}, 7) + 7, 7) ;;
  }

  dimension: date_day_of_28_days_prior {
    hidden: yes
    type: number
    sql: MOD(MOD(${date_days_prior}, 28) + 28, 28) ;;
#     expression: mod(mod(${date_days_prior}, 28) + 28, 28) ;;
  }

  dimension: date_day_of_91_days_prior {
    hidden: yes
    type: number
    sql: MOD(MOD(${date_days_prior}, 91) + 91, 91) ;;
#     expression: mod(mod(${date_days_prior}, 91) + 91, 91) ;;
  }

  dimension: date_day_of_364_days_prior {
    hidden: yes
    type: number
    sql: MOD(MOD(${date_days_prior}, 364) + 364, 364) ;;
#     expression: mod(mod(${date_days_prior}, 364) + 364, 364) ;;
  }

  dimension: date_date_7_days_prior {
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}, INTERVAL -${date_day_of_7_days_prior} DAY) ;;
#     expression: add_days(-1 * ${date_day_of_7_days_prior}, ${date_date}) ;;
  }

  dimension: date_date_28_days_prior {
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}, INTERVAL -${date_day_of_28_days_prior} DAY) ;;
#     expression: add_days(-1 * ${date_day_of_28_days_prior}, ${date_date}) ;;
  }

  dimension: date_date_91_days_prior {
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}, INTERVAL -${date_day_of_91_days_prior} DAY) ;;
#     expression: add_days(-1 * ${date_day_of_91_days_prior}, ${date_date}) ;;
  }

  dimension: date_date_364_days_prior {
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}, INTERVAL -${date_day_of_364_days_prior} DAY) ;;
#     expression: add_days(-1 * ${date_day_of_364_days_prior}, ${date_date}) ;;
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
    sql: DATE_DIFF(${date_end_date_range}, ${date_start_date_range}, day) ;;
#     expression: diff_days(${date_end_date_range}, ${date_start_date_range}) ;;
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
#     expression: mod(mod(${date_days_prior},  ${date_range_difference}) +  ${date_range_difference},  ${date_range_difference}) ;;
  }

  dimension: date_range_days_prior {
    hidden: yes
    type: date
    convert_tz: no
    sql: DATE_ADD(${date_date}, INTERVAL -${date_range_day_of_range_prior} DAY) ;;
#     expression: add_days(-1 * ${date_range_difference}, ${date_date}) ;;
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
    sql: TIMESTAMP({% if fact.period._parameter_value contains "day" %}
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
      {% endif %}) ;;
    allow_fill: no
  }
  dimension: date_end_of_period {
    type: date
    convert_tz: no
    label_from_parameter: period
    group_label: "Event"
    sql: TIMESTAMP({% if fact.period._parameter_value contains "day" %}
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
        {% endif %}) ;;
    allow_fill: no
  }
  dimension: date_period_latest {
    type: yesno
    group_label: "Event"
    sql: ${date_period} < CURRENT_DATE() AND ${date_end_of_period} >= CURRENT_DATE() ;;
    # expression: ${date_period} < now() AND ${date_end_of_period} >= now() ;;
  }
  dimension: date_period_before_latest {
    type: yesno
    group_label: "Event"
    sql: ${date_period} < CURRENT_DATE() ;;
    # expression: ${date_period} < now() ;;
  }
  dimension: date_period_comparison_period {
    hidden: yes
    description: "Is the selected period (This Period) in the last two periods?"
    type: yesno
    group_label: "Event"
    sql: ${date_period} >=
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
      {% endif %} ;;
  }
  dimension: date_period_dynamic_grain {
    datatype: date
    hidden: yes
    type: date
    convert_tz: no
    group_label: "Event"
    label: "{% if fact.period._parameter_value contains 'year'
    or fact.period._parameter_value contains '364 day' %}Month{% elsif fact.period._parameter_value contains 'quarter'
    or fact.period._parameter_value contains '91 day' %}Week{% else %}Date{% endif %}"
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
      sql: DATE_ADD(${date_period}, INTERVAL -{% if fact.period._parameter_value == "'7 day'" %}7
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
        {% endif %}) ;;
      allow_fill: no
    }
  }
