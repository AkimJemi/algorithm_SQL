-- my oracle sql
select min(name) as results
from Users
where user_id in 
(
    select user_id 
    from movieRating 
    group by user_id 
    having 
        count(user_id) = (select max(count(user_id)) from movierating group by user_id)
)
union all 
select min(title)
from Movies
where movie_id in
(
    select movie_id 
    from movieRating 
    where created_at between '2020-02-01' and '2020-02-29'
    group by movie_id 
    having 
        AVG(rating) = (
                    select max(avg(rating)) 
                    from movieRating 
                    where created_at between '2020-02-01' and '2020-02-29' group by movie_id
                    )
)

-- others sql 1
SELECT name as results
FROM (
    SELECT u.name,
           COUNT(mr.movie_id) AS cnt_movie
    FROM MovieRating mr 
    JOIN Users u ON mr.user_id = u.user_id
    GROUP BY u.name
    ORDER BY cnt_movie DESC, u.name
) t
WHERE ROWNUM = 1
union all
select TITLE as result
from (
        select m.title, avg(mr.rating) as avg_rating
    from MovieRating mr 
    join Movies m on m.movie_id=mr.movie_id
    where to_char(mr.created_at, 'yyyy-mm')='2020-02'
    group by m.title
    order by avg_rating desc , m.title asc)
where rownum=1

-- others sql 2
/* Write your PL/SQL query statement below */
WITH TopUser AS (
    SELECT name AS results
    FROM (
        SELECT u.name, COUNT(m.movie_id) as cnt
        FROM Users u 
        LEFT JOIN MovieRating m ON u.user_id = m.user_id
        GROUP BY u.user_id, u.name
        ORDER BY COUNT(m.movie_id) DESC, u.name ASC
    )
    WHERE ROWNUM = 1
),
TopMovie AS (
    SELECT title AS results
    FROM (
        SELECT m.title, AVG(r.rating) as avg_rate
        FROM Movies m 
        INNER JOIN MovieRating r ON m.movie_id = r.movie_id
        WHERE r.created_at BETWEEN TO_DATE('2020-02-01', 'YYYY-MM-DD') 
                               AND TO_DATE('2020-02-29', 'YYYY-MM-DD')
        GROUP BY m.movie_id, m.title
        ORDER BY AVG(r.rating) DESC, m.title ASC
    )
    WHERE ROWNUM = 1
)
SELECT results FROM TopUser
UNION ALL
SELECT results FROM TopMovie;