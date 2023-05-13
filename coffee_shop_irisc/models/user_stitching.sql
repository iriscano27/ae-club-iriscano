{{ config(
    materialized='table'
 ) }}

select a.id
  , case when a.customer_id is not null then b.vistor_id else a.visitor_id end as visitor_id
  , a.device_type
  , a.timestamp
  , a.page
  , a.customer_id
from `analytics-engineers-club.web_tracking.pageviews` a
left join (select distinct customer_id as customer_id, max(visitor_id) as vistor_id
    from `analytics-engineers-club.web_tracking.pageviews`
    where customer_id is not null
    group by 1) b on a.customer_id=b.customer_id
