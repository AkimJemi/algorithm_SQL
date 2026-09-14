-- my oracle sql
select user_id, count(tokens) prompt_count, round(avg(tokens),2) avg_tokens from prompts group by user_id
having count(tokens) >= 3
and max(tokens) <> min(tokens)
order by avg_tokens desc, user_id asc;

-- others sql 1
WITH cte AS (
SELECT user_id, COUNT(prompt) OVER(partition by user_id) prompt_count, ROUND(AVG(tokens) OVER(partition by user_id),2) avg_tokens,
MAX(tokens) OVER(partition by user_id) max_tokens
FROM prompts)
SELECT DISTINCT user_id, prompt_count, avg_tokens
FROM cte
WHERE prompt_count > 2 AND max_tokens > avg_tokens
ORDER BY avg_tokens DESC, user_id;

-- others sql 2
SELECT 
DISTINCT user_id,
prompt_count,
avg_tokens
FROM
(SELECT 
user_id,
count(prompt) over (partition by user_id) as prompt_count,
round(avg(tokens) over (partition by user_id),2) as avg_tokens,
tokens
FROM prompts)
WHERE  prompt_count>=3 AND tokens>avg_tokens
ORDER BY avg_tokens DESC, user_id ASC