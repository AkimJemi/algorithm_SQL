-- my oracle sql
select 
to_char(sell_date, 'YYYY-MM-DD') as sell_date, 
count(distinct product) num_sold,
LISTAGG(product, ',') WITHIN GROUP (ORDER BY product) products
from
(select distinct * from activities)
group by sell_date;

-- others sql
SELECT
    to_char(sell_date,'YYYY-MM-DD') AS sell_date,
    COUNT(DISTINCT product) AS num_sold,
    LISTAGG(product, ',')
        WITHIN GROUP (ORDER BY product) AS products
FROM (
    SELECT DISTINCT sell_date, product
    FROM Activities
)
GROUP BY sell_date
ORDER BY sell_date;