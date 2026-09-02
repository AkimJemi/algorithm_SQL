-- my oracle sql
select m.employee_id, m.name, count(e.reports_to) reports_count, round(avg(e.age)) average_age
from employees m
left join employees e
on m.employee_id = e.reports_to
where exists (
    select * from employees e where m.employee_id = e.reports_to
)
group by m.employee_id, m.name
order by m.employee_id
;

-- others sql 1
WITH Manager AS (
    SELECT reports_to ,COUNT(*) reports_count, ROUND(AVG(age)) average_age FROM Employees 
    WHERE reports_to IS NOT NULL 
    GROUP BY reports_to
)
SELECT E.employee_id , E.name , M.reports_count , M.average_age FROM Manager M 
INNER JOIN 
Employees E ON M.reports_to = E.employee_id
ORDER BY E.employee_id;

-- others sql 2
select e1.reports_to as employee_id, (select e2.name from employees e2 where e2.employee_id = e1.reports_to) as name , count(e1.reports_to) as reports_count, round(avg(age)) as average_age 
from employees e1
where e1.reports_to is not null
group by e1.reports_to
order by e1.reports_to