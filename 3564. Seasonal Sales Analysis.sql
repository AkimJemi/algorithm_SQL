-- my oracle sql
with max_tb as (
    select 
        case 
            when to_char(s.sale_date, 'MM') between '03' and '05' then 'Spring' 
            when to_char(s.sale_date, 'MM') between '06' and '08' then 'Summer' 
            when to_char(s.sale_date, 'MM') between '09' and '11' then 'Fall' 
            when to_char(s.sale_date, 'MM') in ('12', '01', '02') then 'Winter' 
        end season,
        p.category,
        sum(s.quantity) total_quantity,
        sum(s.quantity * s.price) total_revenue,
        ROW_NUMBER() over(partition by
        case 
            when to_char(s.sale_date, 'MM') between '03' and '05' then 'Spring' 
            when to_char(s.sale_date, 'MM') between '06' and '08' then 'Summer' 
            when to_char(s.sale_date, 'MM') between '09' and '11' then 'Fall' 
            when to_char(s.sale_date, 'MM') in ('12', '01', '02') then 'Winter' 
        end
        order by sum(s.quantity) desc, sum(s.quantity * s.price) desc
        ) rnk
    from sales s
    inner join products p
    on s.product_id = p.product_id
    group by 
    case 
        when to_char(s.sale_date, 'MM') between '03' and '05' then 'Spring' 
        when to_char(s.sale_date, 'MM') between '06' and '08' then 'Summer' 
        when to_char(s.sale_date, 'MM') between '09' and '11' then 'Fall' 
        when to_char(s.sale_date, 'MM') in ('12', '01', '02') then 'Winter' 
    end, p.category
) 
select mt.SEASON, mt.CATEGORY, mt.TOTAL_QUANTITY, mt.TOTAL_REVENUE
from max_tb mt
where rnk = 1;

-- others sql 1
WITH season_sales AS
(
    SELECT
        CASE
            WHEN EXTRACT(MONTH FROM s.sale_date) IN (12,1,2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM s.sale_date) IN (3,4,5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM s.sale_date) IN (6,7,8) THEN 'Summer'
            ELSE 'Fall'
        END AS season,
        p.category,
        SUM(s.quantity) AS total_quantity,
        SUM(s.quantity * s.price) AS total_revenue
    FROM sales s
    JOIN products p
      ON s.product_id = p.product_id
    GROUP BY
        CASE
            WHEN EXTRACT(MONTH FROM s.sale_date) IN (12,1,2) THEN 'Winter'
            WHEN EXTRACT(MONTH FROM s.sale_date) IN (3,4,5) THEN 'Spring'
            WHEN EXTRACT(MONTH FROM s.sale_date) IN (6,7,8) THEN 'Summer'
            ELSE 'Fall'
        END,
        p.category
),
ranked AS
(
    SELECT
        season,
        category,
        total_quantity,
        total_revenue,
        ROW_NUMBER() OVER
        (
            PARTITION BY season
            ORDER BY total_quantity DESC,
                     total_revenue DESC,
                     category ASC
        ) rn
    FROM season_sales
)
SELECT
    season,
    category,
    total_quantity,
    total_revenue
FROM ranked
WHERE rn = 1
ORDER BY season;

-- others sql 2
with cte
as
(
select p.category, sum(quantity) as total_quantity, sum(price*quantity) as total_price,
case when 
extract(month from sale_date ) = 12 or extract(month from sale_date ) = 1 or
extract(month from sale_date ) = 2 then
'Winter' 
when extract(month from sale_date ) = 3 or extract(month from sale_date ) = 4 or
extract(month from sale_date ) = 5 then
'Spring'
when extract(month from sale_date ) = 6 or extract(month from sale_date ) = 7 or
extract(month from sale_date ) = 8 then
'Summer'
else
'Fall'
end as season

from sales s, products p where s.product_id = p.product_id
group by p.category,
case when 
extract(month from sale_date ) = 12 or extract(month from sale_date ) = 1 or
extract(month from sale_date ) = 2 then
'Winter' 
when extract(month from sale_date ) = 3 or extract(month from sale_date ) = 4 or
extract(month from sale_date ) = 5 then
'Spring'
when extract(month from sale_date ) = 6 or extract(month from sale_date ) = 7 or
extract(month from sale_date ) = 8 then
'Summer'
else
'Fall'
end
), cte2 as
(
select 
    season,
    category,
    total_quantity,
    total_price as total_revenue,
    row_number() over (partition by season order by total_quantity desc, total_price desc, category asc) as rn

from cte
)
select season, category, total_quantity, total_revenue from cte2
where rn = 1;