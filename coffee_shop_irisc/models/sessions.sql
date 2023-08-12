{{ config(
    materialized='table'
 ) }}

select a.id
  , #### as session_id
  , a.visitor_id
  , a.device_type
  , a.timestamp
  , a.page
  , a.customer_id
from {{ ref ('user_stitching') }}


`analytics-engineers-club.web_tracking.pageviews` a
left join (select distinct customer_id as customer_id, max(visitor_id) as vistor_id
    from `analytics-engineers-club.web_tracking.pageviews`
    where customer_id is not null
    group by 1) b on a.customer_id=b.customer_id
