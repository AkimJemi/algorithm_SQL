-- my oracle sql
select
id,
case
when p_id is null then 'Root'
when (SELECT COUNT(*) FROM Tree t2 WHERE t2.p_id = t1.id) = 0 then 'Leaf'
else 'Inner'
end as type
from Tree t1;

-- others sql 1
select id, (case when p_id is null then 'Root' when id in (select p_id from tree) then 'Inner' else 'Leaf' end) as type from Tree; 

-- others sql 2
select 
id,
case when P_id is null then 'Root'
when  EXISTS (
    SELECT 1 FROM Tree t2 WHERE t2.p_id = t1.id
) then 'Inner'
else 'Leaf'
end type
from tree t1;