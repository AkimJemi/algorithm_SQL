-- my oracle sql
with mt_3 as (
    select employee_id from performance_reviews
    group by employee_id
    having count(*) >= 3
)
, kako as (
    select 
    employee_id
    , review_date
    , row_number() over(partition by employee_id order by review_date desc) rvd_num
    , rating
    from
    performance_reviews pr
    where exists (
        select * from mt_3 mt where pr.employee_id = mt.employee_id
    )
),
last3 as (
    select k1.employee_id, k1.rating - k3.rating as improvement_score from kako k1, kako k2, kako k3 
    where 
    k1.employee_id = k2.employee_id
    and k2.employee_id = k3.employee_id
    and k1.rvd_num = 1 
    and k2.rvd_num = 2 
    and k3.rvd_num = 3
    and k1.rating > k2.rating
    and k2.rating > k3.rating
)
select l.employee_id, e.name, l.improvement_score from last3 l
inner join employees e
on l.employee_id = e.employee_id
order by improvement_score desc, name asc

-- others sql 1
with d as (
  select pr.employee_id,
         e.name,
         pr.rating,
         row_number()
         over(partition by pr.employee_id
              order by pr.review_id desc
         ) rn_rev,
         lead(pr.rating)
         over(partition by pr.employee_id
              order by pr.review_id desc
         ) rating_prv
    from employees e,
         performance_reviews pr
   where e.employee_id = pr.employee_id
)
select employee_id,
       name,
       max(rating) - min(rating) improvement_score
  from d
 where rn_rev <= 3
 group by employee_id,
          name
having count(
  case
    when rating > rating_prv or rn_rev = 3 then
      1
  end
) >= 3
order by improvement_score desc, name

-- others sql 2
With q0 as
(Select
Employee_id, 
Review_date, 
Rating, 
Row_number() over(partition by Employee_id order by Review_date desc) rn, 
Count(*) over(partition by Employee_id) as cnt
From performance_Reviews),

q1 as 
(Select 
Employee_id, 
To_char(Review_date, 'YYYY-MM-DD') Review_date, 
Rating, 
Rn, 
Rating - Lead(rating) over(partition by Employee_id order  by rn) as diff
from q0 
Where cnt>=3 and rn<=3), 

q2 as
(
Select Employee_id, 
Max(rating) - Min(rating) as improvement_score
from q1
Group by Employee_id 
Having min(diff)>0) 

Select q2.Employee_id, e.name, improvement_score
From q2
Inner join Employees e
On q2.Employee_id = e.Employee_id
Order by improvement_score desc, name