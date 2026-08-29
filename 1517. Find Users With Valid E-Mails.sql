-- my oralce sql
select * from users 
where
REGEXP_LIKE(mail, '^[a-zA-Z]+[a-zA-Z0-9._-]*@leetcode\.com$')

-- others sql 1
SELECT *--SUBSTR(mail, 1, INSTR(mail, '@') - 1), SUBSTR(mail, INSTR(mail, '@'))
FROM Users
WHERE REGEXP_LIKE(SUBSTR(mail, 1, INSTR(mail, '@') - 1), '^[a-zA-Z][a-zA-Z0-9_.-]*$')
AND SUBSTR(mail, INSTR(mail, '@')) = '@leetcode.com'

-- others sql 2
select * from users where regexp_like
(mail,'^[A-Za-z][A-Za-z0-9_.-]*@leetcode\.com$');