-- my oralce sql
with cnt_table as (
select id, count(id) num from (
select requester_id id from RequestAccepted
union all 
select accepter_id id from RequestAccepted
) group by id
)
select id, num from cnt_table
where num = (SELECT MAX(num) FROM cnt_table)

-- others sql
select * from (select id,sum(num) as num from
(select requester_id as id, count(*) as num  from RequestAccepted  group by requester_id 
union all
select accepter_id as id, count(*) as num from RequestAccepted  group by accepter_id) temp  group by id order by num desc) where rownum =1

-- others sql
/* Write your PL/SQL query statement below */
with
ids as (
    (
        select distinct requester_id as id from RequestAccepted
    )
    union
    (
        select distinct accepter_id as id from RequestAccepted
    )
),
friends as (
    (
        select distinct id, accepter_id as friend
        from ids inner join RequestAccepted on (id = requester_id)
    )
    union
    (
        select distinct id, requester_id as friend
        from ids inner join RequestAccepted on (id = accepter_id)
    )
),
nfriends as (
    select id, count(friend) as num
    from friends
    group by id
)
select id, num
from nfriends
where num = (select max(f.num) from nfriends f);