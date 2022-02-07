with customers as (
    select * from {{ref('stg_customers')}}
),

payments as (
    select * from {{ref('fct_orders')}}
),

customer_orders as (
    select customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders
    from payments
    group by 1
),
customer_payments as (
    select customer_id
    , sum(amount) lifetime_value
    from payments
    group by 1
),
final as (
    select customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders
        , cp.lifetime_value
    from customers
        left join customer_orders using (customer_id)
        left join customer_payments cp on cp.customer_id = customer_orders.customer_id
)
select *
from final
