- dashboard: linked_ads_clicks
  title: Linked Ads - Clicks
  layout: newspaper
  embed_style:
    background_color: "#ffffff"
    show_title: false
    title_color: "#3a4245"
    show_filters_bar: false
    tile_text_color: "#3a4245"
    text_tile_text_color: ''
  filters:
    - name: Period
      title: Period
      type: field_filter
      default_value: 28 day
      allow_multiple_values: false
      required: true
      model: block_linkedin_ads
      explore: linkedin_ads_ad_impressions
      listens_to_filters: []
      field: fact.period
    - name: Period Latest
      title: Period Latest
      type: field_filter
      default_value: 'Yes'
      allow_multiple_values: false
      required: true
      model: block_linkedin_ads
      explore: linkedin_ads_ad_impressions
      listens_to_filters: []
      field: fact.date_period_latest
    - name: Campaign
      title: Campaign
      type: field_filter
      default_value: ''
      allow_multiple_values: true
      required: false
      model: block_linkedin_ads
      explore: linkedin_ads_ad_impressions
      listens_to_filters:
      - Period
      - Period Latest
      - Account
      field: fact.campaign_name
  elements:
  - title: Clicks To Date
    name: Clicks To Date
    model: block_linkedin_ads
    explore: linkedin_campaign_date_fact
    type: looker_line
    fields: [fact.date_date, fact.total_conversions, fact.average_cost_per_conversion,
      fact.average_conversion_rate, fact.average_cost_per_click, fact.average_click_rate,
      fact.total_impressions, fact.total_clicks]
    fill_fields: [fact.date_date]
    sorts: [fact.date_date desc]
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    stacking: ''
    colors: ["#7869df", "#6e98f9", "#8ac8ca", "#d06180", "#dc9d4f", "#4bb86a", "#a4a6a9",
      "#a6b7ff", "#afe8fd", "#ea9895", "#f1e582"]
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    point_style: none
    series_colors: {}
    series_types: {}
    limit_displayed_rows: false
    hidden_series: [fact.average_cost_per_conversion, fact.average_conversion_rate,
      fact.average_cost_per_click, fact.average_click_rate, fact.total_conversions,
      fact.total_impressions]
    y_axes: [{label: '', orientation: left, series: [{id: fact.total_conversions,
            name: Conversions, axisId: fact.total_conversions, __FILE: app-marketing-linkedin-ads/li_campaign_metrics_clicks.dashboard.lookml,
            __LINE_NUM: 59}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear, __FILE: app-marketing-linkedin-ads/li_campaign_metrics_clicks.dashboard.lookml,
        __LINE_NUM: 56}, {label: '', orientation: left, series: [{id: fact.average_cost_per_click,
            name: Cost per Click, axisId: fact.average_cost_per_click, __FILE: app-marketing-linkedin-ads/li_campaign_metrics_clicks.dashboard.lookml,
            __LINE_NUM: 75}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear, __FILE: app-marketing-linkedin-ads/li_campaign_metrics_clicks.dashboard.lookml,
        __LINE_NUM: 72}, {label: '', orientation: left, series: [{id: fact.average_click_rate,
            name: Click Through Rate, axisId: fact.average_click_rate, __FILE: app-marketing-linkedin-ads/li_campaign_metrics_clicks.dashboard.lookml,
            __LINE_NUM: 90}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, type: linear, __FILE: app-marketing-linkedin-ads/li_campaign_metrics_clicks.dashboard.lookml,
        __LINE_NUM: 87}, {label: !!null '', orientation: left, series: [{id: fact.average_cost_per_conversion,
            name: Cost per Conversion, axisId: fact.average_cost_per_conversion, __FILE: app-marketing-linkedin-ads/li_campaign_metrics_clicks.dashboard.lookml,
            __LINE_NUM: 105}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear, __FILE: app-marketing-linkedin-ads/li_campaign_metrics_clicks.dashboard.lookml,
        __LINE_NUM: 102}, {label: !!null '', orientation: right, series: [{id: fact.average_conversion_rate,
            name: Conversion Rate, axisId: fact.average_conversion_rate, __FILE: app-marketing-linkedin-ads/li_campaign_metrics_clicks.dashboard.lookml,
            __LINE_NUM: 121}], showLabels: true, showValues: true, unpinAxis: false,
        tickDensity: default, tickDensityCustom: 5, type: linear, __FILE: app-marketing-linkedin-ads/li_campaign_metrics_clicks.dashboard.lookml,
        __LINE_NUM: 118}]
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    show_null_points: true
    interpolation: linear
    ordering: none
    show_null_labels: false
    show_dropoff: true
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: white
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    listen:
      Period: fact.period
      Period Latest: fact.date_period_latest
      Campaign: fact.campaign_name
    row: 0
    col: 0
    width: 16
    height: 11
  - title: Ad Clicks Change
    name: Ad Clicks Change
    model: block_linkedin_ads
    explore: linkedin_ad_date_fact
    type: looker_bar
    fields: [last_fact.total_clicks_period_delta, last_fact.total_clicks, fact.total_clicks,
      fact.ad_title, fact.campaign_name]
    filters:
      fact.total_conversions_period_delta: ">0"
    sorts: [last_fact.total_clicks_period_delta desc]
    limit: 50
    column_limit: 50
    query_timezone: America/Los_Angeles
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    y_axes: [{label: '', orientation: bottom, series: [{id: last_fact.total_conversions,
            name: Ad Last Period, axisId: last_fact.total_conversions, __FILE: app-marketing-config-5f71074d49e24011ceee3a8ee7cf1e94-17c0a9c0ef0b6e37e243eeece3212db4462642e5/bi_campaign_metrics_clicks.dashboard.lookml,
            __LINE_NUM: 206}, {id: fact.total_conversions, name: Ad This Period, axisId: fact.total_conversions,
            __FILE: app-marketing-config-5f71074d49e24011ceee3a8ee7cf1e94-17c0a9c0ef0b6e37e243eeece3212db4462642e5/bi_campaign_metrics_clicks.dashboard.lookml,
            __LINE_NUM: 211}], showLabels: true, showValues: false, unpinAxis: false,
        tickDensity: default, type: linear, __FILE: app-marketing-config-5f71074d49e24011ceee3a8ee7cf1e94-17c0a9c0ef0b6e37e243eeece3212db4462642e5/bi_campaign_metrics_clicks.dashboard.lookml,
        __LINE_NUM: 203}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    hide_legend: false
    legend_position: center
    colors: ["#a6b7ff", "#7869df", "#ea9895", "#d06180", "#6e98f9", "#8ac8ca", "#dc9d4f",
      "#4bb86a", "#a4a6a9", "#a6b7ff", "#afe8fd", "#ea989"]
    series_types: {}
    point_style: none
    series_colors:
      last_fact.total_clicks: "#c8c9cc"
      fact.total_clicks: "#87888a"
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: gray
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields: [campaign.name, ad_group.ad_group_name, ad_group.ad_group_name,
      campaign.campaign_name, last_fact.total_clicks_period_delta]
    listen:
      Period: fact.period
      Period Latest: fact.date_period_latest
      Campaign: fact.campaign_name
    row: 11
    col: 13
    width: 11
    height: 9
  - title: Clicks by Bid Type
    name: Clicks by Bid Type
    model: block_linkedin_ads
    explore: linkedin_ad_date_fact
    type: looker_bar
    fields: [fact.total_clicks, fact.bid_type]
    filters: {}
    sorts: [fact.total_clicks desc]
    limit: 50
    column_limit: 50
    query_timezone: America/Los_Angeles
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
      options:
        steps: 5
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    y_axes: [{label: '', orientation: bottom, series: [{axisId: fact.total_clicks,
            id: fact.total_clicks, name: Clicks}], showLabels: false, showValues: false,
        unpinAxis: false, tickDensity: default, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    hide_legend: false
    legend_position: center
    colors: ["#a6b7ff", "#7869df", "#ea9895", "#d06180", "#6e98f9", "#8ac8ca", "#dc9d4f",
      "#4bb86a", "#a4a6a9", "#a6b7ff", "#afe8fd", "#ea989"]
    series_types: {}
    point_style: none
    series_colors:
      fact.total_clicks: "#a4a6a9"
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: gray
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields: [campaign.name, ad_group.ad_group_name, ad_group.ad_group_name,
      campaign.campaign_name]
    listen:
      Period: fact.period
      Period Latest: fact.date_period_latest
      Campaign: fact.campaign_name
    row: 11
    col: 0
    width: 13
    height: 9
  - title: Clicks By Day Of Week
    name: Clicks By Day Of Week
    model: block_linkedin_ads
    explore: linkedin_ad_date_fact
    type: looker_bar
    fields: [fact.total_clicks, fact.date_day_of_week]
    filters: {}
    sorts: [fact.date_day_of_week]
    limit: 50
    column_limit: 50
    query_timezone: America/Los_Angeles
    x_axis_gridlines: false
    y_axis_gridlines: false
    show_view_names: false
    y_axes: [{label: '', orientation: bottom, series: [{axisId: fact.total_clicks,
            id: fact.total_clicks, name: Clicks}], showLabels: false, showValues: false,
        unpinAxis: false, tickDensity: default, type: linear}]
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: ''
    limit_displayed_rows: true
    limit_displayed_rows_values:
      show_hide: show
      first_last: first
      num_rows: '10'
    hide_legend: false
    legend_position: center
    colors: ["#a6b7ff", "#7869df", "#ea9895", "#d06180", "#6e98f9", "#8ac8ca", "#dc9d4f",
      "#4bb86a", "#a4a6a9", "#a6b7ff", "#afe8fd", "#ea989"]
    series_types: {}
    point_style: none
    series_colors:
      fact.total_clicks: "#a4a6a9"
    show_value_labels: true
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    show_row_numbers: true
    truncate_column_names: false
    hide_totals: false
    hide_row_totals: false
    table_theme: gray
    enable_conditional_formatting: false
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    hidden_fields: [campaign.name, ad_group.ad_group_name, ad_group.ad_group_name,
      campaign.campaign_name]
    listen:
      Period: fact.period
      Period Latest: fact.date_period_latest
      Campaign: fact.campaign_name
    row: 0
    col: 16
    width: 8
    height: 11
