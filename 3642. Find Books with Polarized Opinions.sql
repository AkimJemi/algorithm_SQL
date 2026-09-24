-- my oracle sql 
select 
r.book_id
, b.title
, b.author
, b.genre
, b.pages
, max(r.session_rating) - min(r.session_rating) rating_spread
, round(count(case when r.session_rating != 3 then 1 end) / count(r.session_rating),2) polarization_score
from reading_sessions r
inner join books b
on r.book_id = b.book_id
group by 
r.book_id
, b.title
, b.author
, b.genre
, b.pages
having 
count(r.session_rating) >= 5
and max(r.session_rating) > 3
and min(r.session_rating) < 3
and count(case when r.session_rating != 3 then 1 end) / count(r.session_rating) >= 0.6
order by polarization_score desc, title desc

-- others sql 1
WITH CTE AS(
  SELECT
    book_id,
    MAX(session_rating) AS h_rating,
    MIN(session_rating) AS l_rating,
    COUNT(CASE WHEN session_rating >= 4 THEN 1 END) AS h_rating_num,
    COUNT(CASE WHEN session_rating <= 2 THEN 1 END) AS l_rating_num,
    ROUND((COUNT(
        CASE WHEN session_rating >= 4 OR session_rating <= 2 THEN 1 END
    )/ COUNT(*)), 2) AS polarization_score
  FROM reading_sessions 
  GROUP BY book_id
  HAVING COUNT(*) >= 5
)    
SELECT
  b.book_id,
  b.title,
  b.author,
  b.genre,
  b.pages,
  (c.h_rating - c.l_rating) AS rating_spread,
  c.polarization_score
FROM books b
  JOIN CTE c ON b.book_id = c.book_id
WHERE c.h_rating_num >= 1
  AND c.l_rating_num >= 1
  AND c.polarization_score >=0.6
ORDER BY c.polarization_score DESC, b.title DESC

-- others sql 2
select r.book_id,
       b.title,
       b.author,
       b.genre,
       b.pages,
       max(r.session_rating) - min(r.session_rating) as rating_spread,
       round(sum(case when r.session_rating >= 4 or r.session_rating <=2 then 1 end) /  count(r.session_id),2) polarization_score
  from reading_sessions r
 join books b on b.book_id = r.book_id
 group by r.book_id,
          b.title,
          b.author,
          b.genre,
          b.pages
 having count(r.session_id) >= 5
    and sum(case when r.session_rating >= 4 then 1 end) >= 1
    and sum(case when r.session_rating <= 2 then 1 end) >= 1
    and sum(case when r.session_rating >= 4 or r.session_rating <=2 then 1 end) /  count(r.session_id) >= 0.6
order by sum(case when r.session_rating >= 4 or r.session_rating <=2 then 1 end) /  count(r.session_id) desc,
         b.title desc