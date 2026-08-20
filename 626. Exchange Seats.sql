-- my oralce sql
select 
id, 
decode(
    MOD(id, 2)
    ,0, LAG(student, 1) OVER (ORDER BY id)
    ,1, NVL(LEAD(student, 1) OVER (ORDER BY id), student)
    ) as student 
from Seat;

-- others sql 1
select (case when mod(id,2) > 0 and id != (select max(id) from Seat) then id+1 when mod(id,2) = 0 then id-1 else id end) id, student
from Seat
order by id

-- others sql 2
select id, nvl(decode(mod(id, 2), 1, next_student, last_student), student) as student
  from (select id,
               student, 
               lag(student) over(partition by 1 order by id) as last_student,
               lead(student) over(partition by 1 order by id) as next_student
          from seat)

-- others sql 3
select id, 
coalesce(case 
    when mod(id,2) = 1 then lead(student) over (order by id)
    else lag(student) over (order by id)
end, student) as student 
from seat;