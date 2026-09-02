-- my oracle sql
select user_id, UPPER(substr(name, 1, 1)) || LOWER(substr(name, 2)) as name from users
order by 1;
