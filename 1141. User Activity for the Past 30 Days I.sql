-- my oracle sql
select distinct 
TO_CHAR(activity_date, 'YYYY-MM-DD') as day, 
count(distinct user_id) over(partition by activity_date) as active_users 
from Activity
where activity_date between '2019-06-28' and '2019-07-27'
order by 1

-- others sql 1
select to_char(activity_date,'YYYY-MM-DD') as day, count(distinct user_id) as active_users from Activity where activity_date between to_date('2019-06-28','YYYY-MM-DD') AND to_date('2019-07-27','YYYY-MM-DD') group by activity_date;

-- others sql 2
SELECT
    TO_CHAR(activity_date, 'YYYY-MM-DD') AS day,
    COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date BETWEEN DATE '2019-06-28'
                        AND DATE '2019-07-27'
GROUP BY activity_date
ORDER BY activity_date;