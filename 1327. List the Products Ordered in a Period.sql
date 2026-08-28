-- my oralce sql
select p.product_name, sum(o.unit) unit from products p inner join orders o
on p.product_id = o.product_id
where o.order_date between '2020-02-01' and '2020-02-29'
group by product_name
having sum(o.unit) >= 100

-- others sql 1
select product_name , sum(unit) unit
from Products , Orders 
where Products.product_id = Orders.product_id
and to_char(order_date,'mm-yyyy') = '02-2020'
group by product_name
having sum(unit) >= 100
