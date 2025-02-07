-- replacing the loan ids in the penalty table to match the real data
with return_ids as (
select returnid, row_number() over () as rn from (
	select * 
	from booksreturned 
	order by random() 
	limit (select count(*) from penalty)
	)
),
penalty_ids as (
    select penaltyid, row_number() over () as rn from penalty
),
updated_penalties as (
    select p.penaltyid as penalty_id, r.returnid as new_return_id
    from penalty_ids p
    join return_ids r on p.rn = r.rn
)
update penalty
set bookloanid = up.new_return_id
from updated_penalties up
where penalty.penaltyid = up.penalty_id;

---adding subscriptionid to reader table

alter table readers
add column subscriptionid int references subscription(subscriptionid) on delete set null;

-- set all subscriptions without readers to cancelled
update subscription
set tier = 'cancelled'
where subscriptionid not in (select distinct subscriptionid from readers where subscriptionid is not null);