-- my oracle sql
select ssu.student_id, ssu.student_name , ssu.subject_name, count(e.subject_name) as attended_exams from (
select *
from students s, Subjects su 
) ssu
left join Examinations e
on ssu.subject_name = e.subject_name;
and ssu.student_id  = e.student_id
group by ssu.student_id, ssu.student_name , ssu.subject_name
order by 1,3;

-- others sql 1
SELECT
    s.student_id,
    s.student_name,
    sub.subject_name,
    COUNT(e.subject_name) AS attended_exams
FROM Students s
CROSS JOIN Subjects sub
LEFT JOIN Examinations e
ON s.student_id = e.student_id
AND sub.subject_name = e.subject_name
GROUP BY
    s.student_id,
    s.student_name,
    sub.subject_name
ORDER BY
    s.student_id,
    sub.subject_name;

-- others sql 2
select x.student_id, x.student_name,x.subject_name,count(e.student_id) attended_exams 
from (select s.student_id,s.student_name,sub.subject_name from students s,subjects sub) x,examinations e 
where x.student_id =e.student_id(+)
and x.subject_name=e.subject_name(+)
group by x.student_id,x.student_name,x.subject_name
order by x.student_id, x.student_name;