-- my oracle sql 
select 
pp.product1_id,
pp.product2_id,
pi1.category product1_category,
pi2.category product2_category,
pp.customer_count
from (
    select 
    distinct 
    count(p1.user_id) over(partition by p1.product_id, p2.product_id) customer_count,
    p1.product_id product1_id,
    p2.product_id product2_id
    from ProductPurchases p1, ProductPurchases p2
    where 
    p1.user_id = p2.user_id
    and p1.product_id < p2.product_id
) pp inner join ProductInfo pi1
on pp.product1_id = pi1.product_id
inner join ProductInfo pi2
on pp.product2_id = pi2.product_id
where pp.customer_count >= 3
order by customer_count desc, product1_id asc, product2_id asc;

-- others sql 1
WITH product_pairs AS
(
    SELECT
        p1.product_id AS product1_id,
        p2.product_id AS product2_id,
        COUNT(DISTINCT p1.user_id) AS customer_count
    FROM ProductPurchases p1
    JOIN ProductPurchases p2
      ON p1.user_id = p2.user_id
     AND p1.product_id < p2.product_id
    GROUP BY
        p1.product_id,
        p2.product_id
    HAVING COUNT(DISTINCT p1.user_id) >= 3
)
SELECT
    pp.product1_id,
    pp.product2_id,
    pi1.category AS product1_category,
    pi2.category AS product2_category,
    pp.customer_count
FROM product_pairs pp
JOIN ProductInfo pi1
    ON pp.product1_id = pi1.product_id
JOIN ProductInfo pi2
    ON pp.product2_id = pi2.product_id
ORDER BY
    pp.customer_count DESC,
    pp.product1_id ASC,
    pp.product2_id ASC;

-- others sql 2
SELECT 
res.product1 as product1_id, 
res.product2 as product2_id, 
pri1.category as product1_category, 
pri2.category as product2_category, 
res.customer_count
FROM 
(SELECT 
pp1.product_id as product1, 
pp2.product_id as product2,
COUNT(DISTINCT pp1.user_id) as customer_count
FROM productpurchases pp1
JOIN productpurchases pp2
ON pp1.user_id = pp2.user_id 
AND pp1.product_id < pp2.product_id
GROUP BY pp1.product_id, pp2.product_id
HAVING COUNT(DISTINCT pp1.user_id) >= 3) res
LEFT JOIN productinfo pri1 
ON pri1.product_id = res.product1
LEFT JOIN productinfo pri2 
ON pri2.product_id = res.product2
ORDER BY res.customer_count DESC, product1_id, product2_id