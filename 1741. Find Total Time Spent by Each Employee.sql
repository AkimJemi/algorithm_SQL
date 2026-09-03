/* Write your PL/SQL query statement below */
select to_char(event_day, 'YYYY-MM-DD') day,
emp_id,
sum(out_time) - sum(in_time) as total_time
from employees
group by emp_id, event_day 
