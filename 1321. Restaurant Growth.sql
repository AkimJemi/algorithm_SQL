-- my oracle sql
select 
    to_char(visited_on, 'YYYY-MM-DD') visited_on, 
    amount, round(amount/7, 2) average_amount 
from
(
    select distinct 
        visited_on, 
        sum(amount) over(order by visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as amount, 
        rownum rn
    from 
    (
        select 
            visited_on, 
            sum(amount) amount 
        from Customer 
        group by visited_on
        order by 1
    ) 
)
where rn > 6;

-- others sql 1
WITH daily_sales AS (
    SELECT
        visited_on,
        SUM(amount) AS daily_amount
    FROM Customer
    GROUP BY visited_on
),
result AS (
    SELECT
        visited_on,
        SUM(daily_amount) OVER (
            ORDER BY visited_on
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS amount,
        ROW_NUMBER() OVER (ORDER BY visited_on) AS rn
    FROM daily_sales
)
SELECT
    TO_CHAR(visited_on, 'YYYY-MM-DD') AS VISITED_ON,
    amount,
    ROUND(amount / 7, 2) AS average_amount
FROM result
WHERE rn >= 7
ORDER BY visited_on;

-- others sql 2
SELECT 
    TO_CHAR(visited_on, 'YYYY-MM-DD') AS visited_on,
    amount,
    ROUND(average_amount, 2) AS average_amount
FROM (
    SELECT 
        visited_on,
        SUM(daily_amount) OVER (
            ORDER BY visited_on 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS amount,
        AVG(daily_amount) OVER (
            ORDER BY visited_on 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) AS average_amount,
        ROW_NUMBER() OVER (ORDER BY visited_on) AS rn
    FROM (
        SELECT 
            visited_on,
            SUM(amount) AS daily_amount
        FROM Customer
        GROUP BY visited_on
    )
)
WHERE rn >= 7
ORDER BY visited_on;
