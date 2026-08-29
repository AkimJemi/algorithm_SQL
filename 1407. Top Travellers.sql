-- my oracle sql
select u.name, sum(NVL(distance,0)) as travelled_distance 
from users u left join rides r
on u.id = r.user_id
group by 
u.name,u.id
order by 2 desc, 1

-- others sql 1
with cte as(
    select user_id,NVL(sum(distance),0) as travelled_distance
    from Rides
    Group by user_id
) 
select u.name,NVL(c.travelled_distance,0) as travelled_distance
from Users u
left join cte c on c.user_id = u.id
Order by travelled_distance desc , u.name asc

-- others sql 2
select u.name as name, COALESCE(SUM(r.distance), 0) as travelled_distance from Users u
left join Rides r on u.id=r.user_id 
group by u.id, u.name order by travelled_distance desc, u.name asc;