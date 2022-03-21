include: "/views/linkedin_ads.view"

explore: linkedin_ads_ad_impressions {
  persist_with: linkedin_ads_etl_datagroup
  hidden: yes
  from: linkedin_ads_ad_impressions
  view_name: fact
}
