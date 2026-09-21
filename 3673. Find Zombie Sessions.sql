-- my oracle sql
select 
    session_id,
    user_id,
    (max(event_timestamp ) - min(event_timestamp)) * 1440 as session_duration_minutes,
    count(case when event_type = 'scroll' then 1 end) as scroll_count
from app_events
group by user_id, session_id
having count(case when event_type = 'purchase' then 1 end) = 0
    and count(case when event_type = 'scroll' then 1 end) >= 5
    and sum(case when event_type = 'click' then 1 else 0 end) / sum(case when event_type = 'scroll' then 1 else 0 end)  < 0.2
    and max(event_timestamp ) - min(event_timestamp) > 0.0208333333
order by scroll_count desc, session_id asc
;

-- others sql 1
select 
    session_id
    , user_id
    , session_duration_minutes
    , scroll_count 
from (
    select
        session_id
        , user_id
        , (max(event_timestamp) - min(event_timestamp)) * 1440 as session_duration_minutes 
        , count(case when event_type = 'scroll' then 1 end) as scroll_count   
        , count(case when event_type = 'click' then 1 end) as click_count
           
    from
        app_events
    group by
        session_id
        , user_id
    having count(case when event_type = 'purchase' then 1 end) = 0
)
where click_count / scroll_count < 0.2
    and scroll_count > 4
    and session_duration_minutes > 29
order by scroll_count desc, session_id asc