-- my oracle sql
select request_at AS Day, 
ROUND(
(COUNT(CASE WHEN trips.status = 'cancelled_by_driver' THEN 1
WHEN trips.status = 'cancelled_by_client' THEN 1 END)) / COUNT(*)
, 2
) as "Cancellation Rate"
from 
trips inner join users
on users.users_id = trips.client_id 
and users.role = 'client'
and users.banned = 'No'
inner join users
on users.users_id = trips.driver_id 
and users.role = 'driver'
and users.banned = 'No'
where request_at BETWEEN '2013-10-01' AND '2013-10-03'
group by trips.request_at
order by request_at;

-- others sql 1
select t.request_at as day,
round(
    sum(
        case 
        when t.status <> 'completed' then 1
        else 0
        end) /count(*),2
    ) as "cancellation rate"
from trips t,users u,users d
where t.client_id=u.users_id
and t.driver_id=d.users_id
and u.banned='No'
and d.banned='No'
and t.request_at between '2013-10-01' and '2013-10-03'
group by t.request_at
order by 1;

-- others sql 2
SELECT t.request_at AS Day, ROUND(SUM(CASE WHEN t.status IN ('cancelled_by_driver', 'cancelled_by_client') THEN 1 ELSE 0 END) / COUNT(*),2) AS "Cancellation Rate"
FROM Trips t
JOIN Users c ON t.client_id = c.users_id
JOIN Users d ON t.driver_id = d.users_id
WHERE c.banned = 'No'AND d.banned = 'No'
  AND t.request_at BETWEEN '2013-10-01' AND '2013-10-03'
GROUP BY t.request_at
ORDER BY t.request_at;