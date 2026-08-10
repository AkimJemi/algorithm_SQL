-- my sql
WITH consecutive_nums AS (
    SELECT 
        id,
        num,
        CASE 
            WHEN num = LEAD(num, 1) OVER (ORDER BY id) 
             AND num = LEAD(num, 2) OVER (ORDER BY id) 
            THEN 1 
            ELSE 0 
        END AS is_consecutive
    FROM Logs
)
select DISTINCT num AS ConsecutiveNums from consecutive_nums where is_consecutive = 1;

-- 1 others sql
select distinct l1.num ConsecutiveNums
from logs l1 join logs l2 on l1.id=l2.id - 1 and l1.num=l2.num 
join logs l3  on l1.id=l3.id-2 and l1.num=l3.num;

-- 2 others sql
select DISTINCT num as consecutiveNums from (select num, lag(num,1) over(order by id) as prev1, lag(num,2) over(order by id) prev2 from logs )where num = prev1 and num = prev2;