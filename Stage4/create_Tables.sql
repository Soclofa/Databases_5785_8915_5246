create table employee
(
  employeeid int not null,
  primary key (employeeid)
);

create table booksreturned
(
  returnid int not null,
  contitiononreturn int not null,
  returndate int not null,
  primary key (returnid)
);

create table billing
(
  amount int not null,
  date int not null,
  type_(monthly/irregular) int not null,
  billingid int not null,
  primary key (billingid)
);

create table asset_expense
(
  source int not null,
  billingid int not null,
  primary key (billingid),
  foreign key (billingid) references billing(billingid)
);

create table subscription_tiers
(
  tier int not null,
  cost int not null,
  max_readers int not null,
  primary key (tier)
);

create table subscription
(
  subscriptionid int not null,
  renewal_date int not null,
  purchase_date int not null,
  tier int not null,
  primary key (subscriptionid),
  foreign key (tier) references subscription_tiers(tier)
);

create table penalty
(
  cost int not null,
  penaltyid int not null,
  description int not null,
  status int not null,
  returnid int not null,
  primary key (penaltyid),
  foreign key (returnid) references booksreturned(returnid)
);

create table wage
(
  amount int not null,
  monthly_payment_date int not null,
  employeeid int not null,
  primary key (employeeid),
  foreign key (employeeid) references employee(employeeid)
);

create table asset
(
  assetid int not null,
  type int not null,
  cost int not null,
  billingid int not null,
  primary key (assetid),
  foreign key (billingid) references asset_expense(billingid)
);

create table penalty_income
(
  billingid int not null,
  penaltyid int not null,
  primary key (billingid),
  foreign key (billingid) references billing(billingid),
  foreign key (penaltyid) references penalty(penaltyid)
);

create table subscription_monthly_income
(
  billingid int not null,
  subscriptionid int not null,
  primary key (billingid),
  foreign key (billingid) references billing(billingid),
  foreign key (subscriptionid) references subscription(subscriptionid)
);

create table wage_expense
(
  billingid int not null,
  employeeid int not null,
  primary key (billingid),
  foreign key (billingid) references billing(billingid),
  foreign key (employeeid) references wage(employeeid)
);

create table book
(
  bookid int not null,
  assetid int not null,
  primary key (bookid),
  foreign key (assetid) references asset(assetid)
);

create table booksonloan
(
  loanid int not null,
  loandate int not null,
  duedate int not null,
  bookid int not null,
  returnid int not null,
  primary key (loanid),
  foreign key (bookid) references book(bookid),
  foreign key (returnid) references booksreturned(returnid)
);

create table reader
(
  readerid int not null,
  address int not null,
  firstname int not null,
  lastname int not null,
  phonenumber int not null,
  subscriptionid int not null,
  loanid int not null,
  primary key (readerid),
  foreign key (subscriptionid) references subscription(subscriptionid),
  foreign key (loanid) references booksonloan(loanid)
);

create table insurance
(
  insuranceid int not null,
  covered_amount int not null,
  end_date int not null,
  start_date int not null,
  assetid int not null,
  primary key (insuranceid),
  foreign key (assetid) references asset(assetid)
);

create table insurance_expense
(
  billingid int not null,
  insuranceid int not null,
  primary key (billingid),
  foreign key (billingid) references billing(billingid),
  foreign key (insuranceid) references insurance(insuranceid)
);

create table readcard
(
  cardid int not null,
  cardtype int not null,
  expirationdate int not null,
  readerid int not null,
  primary key (cardid),
  foreign key (readerid) references reader(readerid)
);

create table notifications
(
  notificationid int not null,
  message int not null,
  senddata int not null,
  isread int not null,
  readerid int not null,
  primary key (notificationid),
  foreign key (readerid) references reader(readerid)
);

create table family_relationship
(
  readerid_1 int not null,
  family_relationshipreaderid_2 int not null,
  primary key (readerid_1, family_relationshipreaderid_2),
  foreign key (readerid_1) references reader(readerid),
  foreign key (family_relationshipreaderid_2) references reader(readerid)
);