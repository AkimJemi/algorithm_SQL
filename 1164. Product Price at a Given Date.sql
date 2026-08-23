-- my oracle sql
select product_id, nvl(new_price, 10) as price from(
    select 
        f.product_id, 
        s.new_price, 
        row_number() over(partition by f.product_id order by nvl(s.change_date, '1000-12-31') DESC) rw_num
    from products f
    left join products s
    on f.product_id = s.product_id
    and s.change_date <= '2019-08-16'
)
where rw_num=1;

-- others sql 1
with prod_info as(select product_id,new_price,change_date,
row_number() over (partition by product_id
order by  change_date desc ) rn
from Products
where change_date<=date '2019-08-16'
) ,
prod_dtls as
(select distinct product_id  from products)
select a.product_id,nvl(NEW_PRICE ,10) as "price" from prod_dtls a left join
prod_info b
on(a.product_id=b.product_id
and rn=1);

-- others sql 2
Select DISTINCT P2.product_id, NVL(P1.Price, 10) AS PRICE from (Select product_id, Max(new_price) KEEP (DENSE_RANK LAST ORDER BY change_date) AS price
from Products 
WHERE change_date <= '2019-08-16' GROUP BY product_id) P1 Right JOIN Products P2 ON P1.product_id
= P2.product_id;