/* Write your PL/SQL query statement below */
select 
    machine_id,
    round(
        sum(
        case when activity_type ='start' 
            then -timestamp 
            else timestamp
        end)
        /
        count(
        case when activity_type ='start' 
            then 1
        end
        )
    ,3) as processing_time
from Activity
group by machine_id;

-- others sql 1
select a1.machine_id, round(avg(a2.timestamp-a1.timestamp), 3) as processing_time 
from Activity a1
join Activity a2 
on a1.machine_id=a2.machine_id and a1.process_id=a2.process_id
and a1.activity_type='start' and a2.activity_type='end'
group by a1.machine_id