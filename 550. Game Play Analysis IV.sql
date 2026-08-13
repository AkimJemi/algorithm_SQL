-- my oracle sql
with kako_table AS (
select
distinct
player_id,
min(event_date) OVER (PARTITION BY player_id) as first_logged_date
from 
Activity
)
, kako2_table as (
    select player_id, event_date
    from (
        SELECT 
            player_id,
            event_date,
            ROW_NUMBER() OVER (PARTITION BY player_id ORDER BY event_date ASC) AS rnum
        from 
            Activity
    ) 
    where rnum = 2
)
select 
round(
count(distinct case when first_logged_date + 1 = event_date then player_id end)
/ 
count(distinct player_id)
,2) as fraction 
from 
kako_table left join
kako2_table
using (player_id)
;

-- others sql 1
WITH player_first_dates AS (
    SELECT player_id,
           event_date,
           MIN(event_date) OVER(PARTITION BY player_id) as first_date
    FROM activity
),
retention_flag AS (
    SELECT player_id,
           CASE WHEN event_date = first_date + 1 THEN 1 ELSE 0 END as returned
    FROM player_first_dates
)
SELECT 
    ROUND(
        COUNT(DISTINCT CASE WHEN returned = 1 THEN player_id END) 
        / 
        COUNT(DISTINCT player_id), 
        2
    ) as fraction
FROM retention_flag;

-- others sql 2
with
first_login as (
    select player_id, min(event_date) as event_date
    from Activity
    group by player_id
)
select round(sum(
    case when Activity.event_date - first_login.event_date = 1 then 1 else 0 end
) / count(distinct player_id), 2) as fraction
from first_login inner join Activity using (player_id);