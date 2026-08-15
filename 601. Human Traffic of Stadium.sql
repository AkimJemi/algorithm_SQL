-- my oracle sql
with hum_people as (
select * from stadium where people >= 100
),
 fir_filter as (
    select distinct kako_id as id, to_char(kako_date, 'yyyy-mm-dd') as visit_date, kako_ppl as people
    from (
        select 
            a.id as id_col1, b.id as id_col2, c.id as id_col3, 
            a.visit_date as date_col1, b.visit_date as date_col2, c.visit_date as date_col3, 
            a.people as ppl_col1, b.people as ppl_col2, c.people as ppl_col3
        from hum_people a 
        inner join hum_people b on a.id = b.id - 1
        inner join hum_people c on b.id = c.id - 1
    ) unpivot (
        (kako_id, kako_date, kako_ppl) for col_name in (
            (id_col1, date_col1, ppl_col1) as 'col1',
            (id_col2, date_col2, ppl_col2) as 'col2',
            (id_col3, date_col3, ppl_col3) as 'col3'
        )
    )
)
select * from fir_filter
order by id;

-- others sql
with conseq as(
    select id,visit_date,people, id - rownum as id_diff
    from Stadium
    where people >=100
)
select
    id,to_char(visit_date,'YYYY-MM-DD') as visit_date,people
from conseq
where id_diff in(
    select distinct id_diff from conseq 
    group by id_diff having count(*)>2 
)
order by visit_date;

-- 2
with cte as (select
id,
to_char(visit_date,'yyyy-mm-dd') as visit_date,
people,
lag(id,1)over(order by id asc) pre_num_1,
lag(id,2)over(order by id asc) pre_num_2,
lead(id,1)over(order by id asc) after_num_1,
lead(id,2)over(order by id asc) after_num_2
from stadium
WHERE people >= 100
)

select 
id,
visit_date,
people
from cte
where (id = pre_num_1 + 1 and id = pre_num_2 +2) 
or (id = pre_num_1 + 1 and id = after_num_1 - 1)
or (id = after_num_1 - 1 and id = after_num_2 - 2)
order by visit_date asc;
-- 3
select distinct id, 
to_char(visit_date ,'YYYY-MM-DD') as visit_date, 
people as people 
from
( 
select 
id, 
visit_date , people ,
lead(people) over ( order by visit_date) as next_people_count ,
lead(people,2) over ( order by visit_date) as next_to_next_people_count ,
lag(people) over ( order by visit_date) as prev_people_count ,
lag(people,2) over ( order by visit_date) as prev_to_prev_people_count 
from
Stadium
) where
( people >= 100 and next_people_count >= 100 and next_to_next_people_count >= 100 ) 
or 
( people >= 100 and prev_people_count >= 100 and prev_to_prev_people_count >= 100 )
or
( people >= 100 and prev_people_count >= 100 and next_people_count >= 100 )
order by  visit_date;
-- 4
SELECT
    id,
    TO_CHAR(visit_date, 'YYYY-MM-DD') AS visit_date,
    people
FROM Stadium
WHERE id IN (
    SELECT s1.id
    FROM Stadium s1
    JOIN Stadium s2 ON s2.id = s1.id + 1
    JOIN Stadium s3 ON s3.id = s2.id + 1
    WHERE s1.people >= 100
      AND s2.people >= 100
      AND s3.people >= 100

    UNION

    SELECT s2.id
    FROM Stadium s1
    JOIN Stadium s2 ON s2.id = s1.id + 1
    JOIN Stadium s3 ON s3.id = s2.id + 1
    WHERE s1.people >= 100
      AND s2.people >= 100
      AND s3.people >= 100

    UNION

    SELECT s3.id
    FROM Stadium s1
    JOIN Stadium s2 ON s2.id = s1.id + 1
    JOIN Stadium s3 ON s3.id = s2.id + 1
    WHERE s1.people >= 100
      AND s2.people >= 100
      AND s3.people >= 100
)
ORDER BY visit_date;
