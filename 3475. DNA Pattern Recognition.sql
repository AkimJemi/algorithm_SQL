-- my oracle sql
select sample_id,dna_sequence,species,
case when REGEXP_LIKE(dna_sequence, '^ATG', 'i') then 1 else 0 end has_start, 
case when REGEXP_LIKE(dna_sequence, '(TAA|TAG|TGA)$', 'i') then 1 else 0 end has_stop, 
case when REGEXP_LIKE(dna_sequence, '+(ATAT)+', 'i') then 1 else 0 end has_atat, 
case when REGEXP_LIKE(dna_sequence, 'GGG', 'i') then 1 else 0 end has_ggg
from samples;

-- others sql 1
select sample_id, dna_sequence ,   species   ,
case when  dna_sequence like 'ATG%' then 1
     else 0
     end as has_start   ,
case when dna_sequence like '%TAA' then 1
     when dna_sequence like '%TAG' then 1
     when dna_sequence like '%TGA' then 1
     else 0
     end as has_stop   ,
case when dna_sequence like '%ATAT%' then 1
     else 0
     end as has_atat,
case when dna_sequence like '%GGG%' then 1
     else 0
     end as has_ggg    
from Samples