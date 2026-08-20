-- my oracle sql
select * from Cinema
where MOD(id, 2) = 1 and
description != 'boring'
order by rating desc

-- others sql
SELECT id, movie, description, rating
    FROM cinema
WHERE MOD(id, 2) <> 0 AND description <> 'boring' 
ORDER BY rating DESC
