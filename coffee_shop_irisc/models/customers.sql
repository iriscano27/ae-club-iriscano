{{ config(
    materialized='table'
 ) }}

select 
  customers.id as customer_id
  , name
  , email
  , min(created_at) as first_order_at
  , count(*) as number_of_orders
from {{ source ('customers')}} customers
left join {{ source ('orders')}} orders on customers.id=orders.customer_id
group by 1,2,3