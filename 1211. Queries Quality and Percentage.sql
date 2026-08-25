-- my oralce sql 
SELECT
query_name,
round(sum(rating / position) / COUNT(*),2) as quality,
round(COUNT(CASE WHEN rating <3 THEN 1 ELSE null END) / COUNT(*) * 100, 2) as poor_query_percentage 
from Queries
group by query_name;

-- others sql 1
select query_name, round(avg(rating/position), 2) as quality, 
round((SUM(
    CASE
        WHEN rating<3 THEN 1 ELSE 0 
    END
    )/ count(query_name)) * 100, 2) as poor_query_percentage
from Queries 
group by query_name; 

-- others sql 2
SELECT 
    query_name,
    ROUND(AVG(rating / TO_NUMBER(position)), 2) AS quality,
    ROUND(AVG(CASE WHEN rating < 3 THEN 1 ELSE 0 END) * 100, 2) AS poor_query_percentage
FROM 
    Queries
WHERE 
    query_name IS NOT Null
GROUP BY 
    query_name;