-- my oracle sql
select ep.name, bonus from Employee ep left join bonus bn on ep.empId = bn.empId
where bn.bonus < 1000 or bn.bonus is null;

-- others sql
select e.name , bonus from Employee E
left outer join Bonus B on b.empid=E.empid
where b.bonus<1000 Or b.bonus is null;
