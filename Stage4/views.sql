
-- purpose: show the subscriptions that readers are subscribed to

create view subscriptionreaders as
select
	r.readerid, 
	r.firstname, 
	r.lastname,
	r.address,
	r.phonenumber,
	s.subscriptionid,
	s.renewal_date,
	s.purchase_date,
	s.tier
from
	readers r
	join subscription s on r.subscriptionid = s.subscriptionid;

-- select query: get the `subscription tier` of `'kimberly torres'`

select tier from subscriptionreaders
where firstname = 'kimberly' and lastname = 'torres'

-- update query: some of the subscriptions had 2 readers so i changed their tiers to `premium`

update subscription
set tier = 'premium'
where subscriptionid in (select subscriptionid 
	from (select count(*) c, subscriptionid, tier
				from subscriptionreaders
				where tier != 'family' 
				group by subscriptionid, tier) 
	where c > 1)


-- view loan status:

-- purpose: show the loan status of the books per reader

create view readerloanstatus as
select
	r.readerid, 
	r.subscriptionid,
	bl.loanid,
	bl.bookid,
	bl.loandate,
	bl.duedate,
	br.returnid,
	br.conditiononreturn,
	br.returndate
from
	readers r
    join booksonloan bl on r.readerid = bl.readerid
    full join booksreturned br on bl.loanid = br.loanid

-- select query: selects book load where the return condition is `poor`

select readerid from readerloanstatus
where conditiononreturn = 'poor'
group by readerid

-- update query: inserts into the `bookreturned` table a new book return

 insert into booksreturned (loanid, conditiononreturn, returndate)
values (
       (select loanid from readerloanstatus
       where subscriptionid = 26927 and bookid = 44140
       limit 1),
       'good',
       '2025-02-02');