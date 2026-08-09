/* KIM sql */
with rnk as (
    select employee.salary as SecondHighestSalary, DENSE_RANK() over(order by salary desc) AS all_rank from employee
) 
select
case
when (select count(*) from rnk )<2 then null
else (select distinct SecondHighestSalary from rnk where all_rank = 2)
end AS SecondHighestSalary
from dual;

/* other sql */
/*cooorelated queryyy. use an aggregate cause it returns null if theres nothing*/
-- 1
select min(salary) as SecondHighestSalary from Employee e where 1=(select count(distinct salary) from Employee d where d.salary>e.salary);

-- 2
select max(salary) SecondHighestSalary from Employee where salary not in (select max(salary) salary from Employee);  

-- 3
SELECT  MAX( DISTINCT Salary)  AS SecondHighestSalary FROM Employee
WHERE salary < (SELECT MAX( DISTINCT Salary) FROM Employee)


-- AI sql
-- 1
SELECT MAX(salary) AS SecondHighestSalary
FROM employee
WHERE salary < (SELECT MAX(salary) FROM employee);

-- 2
WITH ranked AS (
    SELECT DISTINCT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS all_rank
    FROM employee
)
SELECT MAX(salary) AS SecondHighestSalary
FROM ranked
WHERE all_rank = 2;