{{ config(
    materialized='table'
 ) }}

with base as (
select * from {{ ref ('user_stitching') }})

, previous_timestamp as (
  select *,lag(timestamp) OVER (PARTITION BY visitor_id ORDER BY timestamp) as lagged_timestamp
  from base)

, diff as (
  select *, date_diff(timestamp, lagged_timestamp, minute) as difference_minutes
  from previous_timestamp)

, new_session as (
  select *, cast(coalesce(difference_minutes > 30, true) as integer) as is_new_session
  from diff)

, add_session as (
  select *, sum(is_new_session) over (partition by visitor_id order by timestamp rows between unbounded preceding and current row) as session_number
  from new_session)

select * from add_session