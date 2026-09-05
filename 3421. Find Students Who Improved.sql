-- my oracle sql 
with tb as (
    select 
        student_id
        , subject
        , score
        , count(exam_date) over(partition by student_id, subject) cnt
        , row_number() over(partition by student_id, subject order by exam_date) rnk 
    from scores
), tb_2 as (
    select * from tb where cnt > 1
)
select student_id, subject, rnk1.score first_score, rnk_last.score latest_score from 
    (select * from tb_2 where rnk = 1) rnk1
    inner join (
        select * from tb_2 inner join (select student_id, subject, max(rnk) rnk from tb_2 group by student_id, subject)
        using (student_id, subject, rnk)
        ) rnk_last
    using (student_id, subject)
where 
    rnk1.score < rnk_last.score;

-- others sql 1
WITH cte AS (
    SELECT DISTINCT 
        student_id, 
        subject, 
        FIRST_VALUE(score) OVER (
            PARTITION BY student_id, subject 
            ORDER BY exam_date 
        ) AS first_score, 
        FIRST_VALUE(score) OVER (
            PARTITION BY student_id, subject 
            ORDER BY exam_date desc
        ) AS latest_score
    FROM 
        Scores
)
SELECT 
    student_id,
    subject,
    first_score, 
    latest_score 
FROM 
    cte 
WHERE 
    latest_score > first_score
ORDER BY 
    student_id, 
    subject;

-- others sql 2
select * from (
select student_id, subject, MIN(score) KEEP (DENSE_RANK FIRST ORDER BY exam_date) AS first_score,
       MIN(score) KEEP (DENSE_RANK LAST  ORDER BY exam_date) AS latest_score
from Scores
group by student_id, subject 
having count(exam_date) > 1 ) t
where  first_score < latest_score
order by student_id, subject