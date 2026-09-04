-- my oracle sql
(select employee_id from Employees minus select employee_id from Salaries)
union all 
(select employee_id from Salaries minus select employee_id from Employees)
order by 1

-- others sql 1
SELECT
case 
    when e.employee_id  is null then s.employee_id 
    when s.employee_id  is not null then s.employee_id 
    else e.employee_id
    end as "employee_id"
FROM Employees e
full join Salaries s on e.employee_id = s.employee_id
where e.name is null or s.salary is null
order by  1;

-- others sql 2
select employee_id as employee_id from Employees where employee_id not in(select employee_id from Salaries)
union all
select employee_id from Salaries where employee_id not in(select employee_id from Employees)
order by employee_id asc;