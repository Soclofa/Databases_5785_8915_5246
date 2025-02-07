
-- select on first view: get the names of all readers that have `peremium` subscriptions

select firstname, lastname
from subscriptionreaders
where tier = 'premium'

-- update on first view: inserts a new reader into the `reader` table only if the subscription is not full yet

do
$do$
begin
   if exists (select count(*),sr.tier 
   			from subscriptionreaders sr
			join subscription_tiers st on st.tier = sr.tier
			where subscriptionid = 29
			group by sr.tier
			
   	) then
	   insert into readers (firstname,lastname, address, phonenumber,subscriptionid)
	   values ('jack', 'jackson', 'london', '477-233-1380', 29);
   end if;
end
$do$

-- select second view: gets all the loaned books that where returned by readers that their `subscriptionid` is 29

select count(*), t.subscriptionid,  s.tier
from (select returnid, loanid, subscriptionid 
	from readerloanstatus rls
	where subscriptionid = 29 
	group by returnid, loanid, subscriptionid) t
join subscription s on s.subscriptionid = t.subscriptionid
where returnid is not null
group by t.subscriptionid, s. tier

--  insert second view adds a penalty to the penalty table with values from the returned table

 with bookreturn as (
insert into booksreturned (loanid, conditiononreturn, returndate)
select t.loanid, 'damaged', '2025-01-30'
from (select *
       from readerloanstatus rls
       where subscriptionid = 29 and duedate = '2024-12-17') t
where returnid is null
limit 1
returning returnid, loanid
)
insert into penalty (cost, description, status, penalty_type, bookloanid)
select cost, 'book lost', 0, 'lost item fee', returnid
from bookreturn br
join booksonloan bol on bol.loanid = br.loanid
join book b on b.bookid = bol.bookid
join asset a on a.assetid = b.assetid;