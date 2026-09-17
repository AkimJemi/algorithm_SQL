-- my oracle sql 
with tb as (
    select
        m.employee_id,
        e.employee_name,
        e.department,
        m.duration_hours,
        m.meeting_date,
        trunc((meeting_date - DATE '0001-01-10') / 7)  as　day_kubun
        -- trunc((extract(year from meeting_date)*10000 + extract(month from meeting_date)*100 + extract(day from meeting_date-3)) / 7) day_kubun
    from employees e
    inner join meetings m
    on e.employee_id = m.employee_id;
), kako as (
    select 
        employee_id
    from tb
    group by day_kubun, employee_id
    having sum(duration_hours) > 20
), kako2 as (
    select
    distinct
        employee_id,
        count(employee_id) meeting_heavy_weeks
    from kako
    group by employee_id
    having count(employee_id) >= 2
)
select
distinct 
t.employee_id, t.employee_name, t.department, k.meeting_heavy_weeks
from tb t
inner join kako2 k
on t.employee_id = k.employee_id
order by meeting_heavy_weeks desc, employee_name asc;

-- others sql 1
WITH T1 AS
(
SELECT
  e.employee_id,
  e.employee_name,
  e.department,
  SUM(m.duration_hours)
FROM employees e
  JOIN meetings m ON e.employee_id = m.employee_id 
GROUP BY e.employee_id, e.employee_name, e.department, TRUNC(m.meeting_date, 'IW')
HAVING SUM(m.duration_hours) > 20
)
SELECT
  employee_id,
  employee_name,
  department,
  COUNT(*) AS meeting_heavy_weeks
FROM T1
GROUP BY employee_id,
  employee_name,
  department
HAVING COUNT(*) >= 2
ORDER BY meeting_heavy_weeks DESC, employee_name

-- others sql 2
select EMPLOYEE_ID as "employee_id" ,employee_name as "employee_name",department as "department" ,count(WEEK_START)
 as "meeting_heavy_weeks" from(
select * from(
select a.employee_id,b.employee_name ,b.department  ,trunc(a.meeting_date ,'IW')
as week_start,sum(duration_hours )total_hours,
40 as total_hrs
,
(sum(duration_hours )/40*100) as avg_hs
 from meetings a inner join employees b on(
    a.employee_id=b.employee_id
 )
group by a.employee_id,b.employee_name ,b.department ,trunc(meeting_date ,'IW')
) where avg_hs>=50
) group by employee_id,employee_name ,department  having 
count(WEEK_START)>=2
order by 4 desc ,2 asc