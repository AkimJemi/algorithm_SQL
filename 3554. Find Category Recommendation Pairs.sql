-- my oracle sql
with pp as (
    select distinct
        pp.user_id, pi.category
    from ProductPurchases pp
    inner join ProductInfo pi
    on pp.product_id = pi.product_id
)
select distinct
pp1.category category1, pp2.category category2, count(pp1.user_id) customer_count
from pp pp1, pp pp2
where pp1.user_id = pp2.user_id
and pp1.category < pp2.category
group by pp1.category, pp2.category
having count(pp1.user_id) >= 3
order by customer_count desc, category1 asc, category2 asc

-- others sql 1
With user_purchase as (
    SELECT distinct p.user_id
        , u.category
    FROM Productpurchases p
    JOIN ProductInfo u
        ON p.product_id = u.product_id
    ORDER BY p.user_id
)SELECT DISTINCT u1.category as category1
        ,u2.category as category2
        ,COUNT(u1.user_id) AS customer_count
 FROM user_purchase u1
 JOIN user_purchase u2 
    ON u1.user_id = u2.user_id
    AND u1.category < u2.category 

GROUP BY 
    u1.category, 
    u2.category
HAVING 
    COUNT(u1.user_id) >= 3
ORDER BY 
    customer_count DESC, 
    category1 ASC, 
    category2 ASC; 