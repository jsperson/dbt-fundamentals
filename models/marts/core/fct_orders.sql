select o.order_id
, o.customer_id
, o.order_date
, coalesce(p.amount,0) as amount
from {{(ref('stg_orders'))}} o
left outer join {{(ref('stg_payments'))}} p
on p.order_id = o.order_id