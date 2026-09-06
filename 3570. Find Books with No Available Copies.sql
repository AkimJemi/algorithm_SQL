-- my oracle sql
select 
l.book_id ,l.title, l.author, l.genre, l.publication_year, b.bw current_borrowers 
from 
library_books l left join 
(select book_id, count(*) bw from borrowing_records where return_date is null group by book_id) b
on l.book_id = b.book_id
where l.total_copies = b.bw
order by current_borrowers desc, title asc

-- others sql 1
select l.book_id book_id,l.title title,l.author author,l.genre genre,l.publication_year publication_year,count(*) current_borrowers
from library_books l,borrowing_records b
where l.book_id=b.book_id
and return_date is null
group by l.book_id,l.title,l.author,l.genre,l.publication_year,l.total_copies
having count(*)=l.total_copies
order by current_borrowers desc,l.title