-- my oracle sql
select 
    r.user_id
    , r.reaction dominant_reaction
    , round(count(r.reaction) / s.ttl_rc, 2) reaction_ratio 
from reactions r 
inner join (
    select 
        user_id 
        , count(reaction) ttl_rc
    from reactions
    group by user_id
    having count(reaction) >= 5
) s
on r.user_id = s.user_id
group by r.user_id, r.reaction, s.ttl_rc
having count(r.reaction) / s.ttl_rc > 0.6
order by 3 desc, 1 asc

-- others sql 1
WITH reaction_counts AS (
    SELECT user_id, reaction, count(reaction) reaction_count, ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY count(reaction) DESC) rn,
    sum(count(reaction)) OVER (PARTITION BY user_id) total FROM reactions
    GROUP BY user_id, reaction
    ORDER BY user_id ASC, count(reaction) DESC
)
SELECT user_id, reaction dominant_reaction, ROUND(reaction_count / total, 2) reaction_ratio FROM reaction_counts
WHERE rn = 1
AND total > =5
AND ROUND(reaction_count / total, 2) > 0.6
ORDER BY reaction_ratio DESC, user_id ASC
