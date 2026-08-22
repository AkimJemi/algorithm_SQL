-- my oracle sql
select product_id, year as first_year, quantity, price from sales m
where exists
(
    select * from sales s
    where m.product_id = s.product_id
    group by product_id
    having min(year) = m.year
)
;

-- others sql1
SELECT B.PRODUCT_ID, 
        B.YEAR AS FIRST_YEAR,
        B.QUANTITY AS QUANTITY,
        B.PRICE AS PRICE
FROM (
    SELECT PRODUCT_ID,
            MIN(YEAR) AS YEAR
            -- DENSE_RANK() OVER (PARTITION BY PRODUCT_ID ORDER BY YEAR) AS DRN
        FROM SALES
        GROUP BY PRODUCT_ID
    ) A
INNER JOIN SALES B
ON A.PRODUCT_ID = B.PRODUCT_ID
AND B.YEAR = A.YEAR

-- others sql 2
SELECT 
s.product_id, 
s.year as first_year, 
s.quantity, 
s.price
FROM sales s
JOIN 
(SELECT 
s1.product_id, 
MIN(s1.year) as first_year 
FROM sales s1
GROUP BY s1.product_id) res
ON s.product_id = res.product_id
AND s.year = res.first_year