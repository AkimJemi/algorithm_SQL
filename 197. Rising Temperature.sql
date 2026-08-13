-- my oracle sql
select cur.id from Weather cur inner join Weather pre on cur.recordDate - 1 = pre.recordDate
where cur.temperature > pre.temperature

-- others sql 1
SELECT current_day.id
FROM Weather current_day
WHERE EXISTS (
    SELECT 1
    FROM Weather yesterday
    WHERE current_day.temperature > yesterday.temperature
    AND current_day.recordDate = yesterday.recordDate + 1
);
-- others sql 2
SELECT today.id 
FROM Weather yesterday
CROSS JOIN Weather today
WHERE today.recorddate - yesterday.recorddate = 1
    AND today.temperature > yesterday.temperature 
;