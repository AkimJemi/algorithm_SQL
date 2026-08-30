-- my oracle sql
select distinct 
contest_id, 
round(
    count(distinct user_id) over(partition by contest_id) / (select count(*) from users) * 100
    , 2
) percentage
from register
order by 2 desc,1;

-- others sql
SELECT 
    contest_id, 
    ROUND(COUNT(user_id) * 100.0 / (SELECT COUNT(*) FROM Users), 2) AS percentage
FROM Register
GROUP BY contest_id
ORDER BY percentage DESC, contest_id ASC;