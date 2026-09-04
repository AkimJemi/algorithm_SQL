-- my oracle sql
select employee_id 
from employees 
where salary < 30000 and manager_id not in (select distinct employee_id from employees)
order by 1;

-- oracle sql 1
SELECT e.employee_id
FROM Employees e
LEFT JOIN Employees m ON e.manager_id = m.employee_id
WHERE e.salary < 30000
AND e.manager_id IS NOT NULL
AND m.employee_id IS NULL
ORDER BY e.employee_id;

-- oracle sql 2
select c.employee_id employee_id
from employees c,employees m
where c.manager_id=m.employee_id(+)
and c.salary<30000
and m.employee_id is null
and c.manager_id is not null
order by c.employee_id;