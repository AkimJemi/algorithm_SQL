-- my oracle sql
select 
user_id, 
round(avg(case when activity_type = 'free_trial' then activity_duration end),2) trial_avg_duration,
round(avg(case when activity_type = 'paid' then activity_duration end),2) paid_avg_duration
from UserActivity 
group by user_id
having 
avg(case when activity_type = 'free_trial' then activity_duration end) is not null and
avg(case when activity_type = 'paid' then activity_duration end) is not null
order by user_id;
