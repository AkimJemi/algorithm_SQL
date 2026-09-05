select *
from Users
where
REGEXP_LIKE(email, '^[a-zA-Z0-9]+@[a-zA-Z]+\.com$', 'i')
order by user_id