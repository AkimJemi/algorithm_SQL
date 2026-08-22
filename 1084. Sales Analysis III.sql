-- my oracle sql
select distinct p.product_id, p.product_name from product p inner join sales s
on p.product_id = s.product_id
where exists (
    select 1 from sales ss 
    where s.product_id = ss.product_id
    group by product_id having 
    min(ss.sale_date) between '2019-01-01' and '2019-03-31'
    and max(ss.sale_date) between '2019-01-01' and '2019-03-31'
)

-- others sql 1
select distinct
s.product_id,
p.product_name
from Product p 
left join Sales s on s.product_id = p.product_id
where s.product_id not in (select product_id from Sales where sale_date > date '2019-03-31' or sale_date < date '2019-01-01') 

-- others sql 2
select distinct p.product_id as product_id,
p.product_name as product_name
from Product p
right join
sales s
on p.product_id = s.product_id
where s.sale_date >= '2019-01-01' and s.sale_date <= '2019-03-31'
and p.product_id not in (select p.product_id as product_id
from Product p
right join
sales s
on p.product_id = s.product_id
where s.sale_date > '2019-03-31'or s.sale_date < '2019-01-01')