-- my sql
with ranked_ep_table as (
    select dm.name AS dm_name, ep.name as ep_name, ep.salary, DENSE_RANK() over (PARTITION BY ep.departmentId ORDER BY ep.salary DESC) AS rank_salary from employee ep inner join department dm on ep.departmentId = dm.id )
select dm_name AS Department, ep_name AS "Employee", salary from ranked_ep_table where rank_salary <=3;

-- others sql
with abc as(
    select a.name as department , b.name as employee , b.salary , dense_rank() over(partition by b.departmentid order by b.salary desc)  as rn from employee b left join 
    department a on a.id = b.departmentid
)
select department , employee, salary from abc 
where rn<=3;