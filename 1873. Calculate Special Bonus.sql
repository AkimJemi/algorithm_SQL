-- my oralce sql
select employee_id,
case when mod(employee_id,2) = 1 and name not like 'M%' then salary
else 0
end bonus
from employees
order by 1;
