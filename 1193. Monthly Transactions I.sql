-- my oralce sql
select distinct 
    to_char(trans_date, 'YYYY-MM') as month ,
    country,
    count(amount) over(partition by country, to_char(trans_date, 'YYYY-MM')) as trans_count,
    count(CASE WHEN state = 'approved' THEN 1 ELSE null END) over(partition by country, to_char(trans_date, 'YYYY-MM'))  as approved_count,
    sum(amount) over(partition by country, to_char(trans_date, 'YYYY-MM')) as trans_total_amount,
    sum(CASE WHEN state = 'approved' THEN amount ELSE 0 END) over(partition by country, to_char(trans_date, 'YYYY-MM')) as approved_total_amount
from transactions;

-- others sql 1
SELECT 
    TO_CHAR(trans_date, 'YYYY-MM') AS month,
    country,
    COUNT(id) AS trans_count,
    SUM(CASE WHEN state = 'approved' THEN 1 ELSE 0 END) AS approved_count,
    SUM(amount) AS trans_total_amount,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY TO_CHAR(trans_date, 'YYYY-MM'), country;

-- others sql 2
WITH T AS(
    SELECT id, country, state, amount, TO_CHAR(trans_date, 'YYYY-MM') AS month,
    CASE
        WHEN state = 'approved' THEN 1
        ELSE 0
    END AS is_approved,
    CASE
        WHEN state = 'approved' THEN amount
        ELSE 0
    END AS approved_amount
    FROM Transactions
)
SELECT month, country, COUNT(*) AS trans_count, SUM(is_approved) AS approved_count, SUM(amount) AS trans_total_amount, SUM(approved_amount) AS approved_total_amount
FROM T
GROUP BY month, country
ORDER BY month, country DESC;
