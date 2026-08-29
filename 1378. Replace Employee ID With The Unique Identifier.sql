-- my oracle sql
select eu.unique_id, e.name from employees e left join employeeUNI eu
on e.id = eu.id

-- others sql
select unique_id , name
from EmployeeUNI empu, employees emp
where emp.id = empu.id(+);