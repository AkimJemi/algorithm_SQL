-- my oralce sql
select 
user_id, max(time_stamp) last_stamp
from logins
where to_char(time_stamp, 'YYYY') = '2020'
group by user_id

-- others sql
select user_id, max(time_stamp) as last_stamp
from Logins
WHERE time_stamp >= '2020-01-01'
AND time_stamp <  '2021-01-01'
group by(user_id)

-- others sql 2