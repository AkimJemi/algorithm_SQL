-- my oracle sql
with y_pri as (
    select employee_id, department_id from employee where primary_flag = 'Y'
)
, n_pri as (
    select employee_id, department_id from employee where employee_id not in (select employee_id from y_pri)
)
select * from y_pri
union all 
select * from n_pri

-- others sql 1
Select 
    employee_id, 
    department_id
from 
    Employee
where
    primary_flag = 'Y'
union
Select 
    employee_id, 
    max(department_id) department_id
from 
    Employee
group by
    employee_id
having 
    count(employee_id) = 1
    ;

-- others sql 2
SELECT employee_id, department_id FROM(
SELECT 
employee_id, 
department_id, 
primary_flag,
ROW_NUMBER() OVER(PARTITION BY employee_id order by primary_flag desc) as rn FROM employee)
WHERE RN = 1
