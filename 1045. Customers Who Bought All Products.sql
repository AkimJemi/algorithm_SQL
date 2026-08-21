-- my oracle sql
select customer_id
from 
(
select distinct customer_id, count(distinct product_key) over(partition by customer_id) cnt from 
Customer
)
where cnt = (select count(distinct product_key) from product)
;

-- others sql 1
select customer_id
from (select distinct * from Customer)
group by customer_id
having count(*)>= (select count(*) from Product);

-- others sql 2
select customer_id 
from customer
group by customer_id 
having count(distinct(product_key)) = (select count(*) from product)