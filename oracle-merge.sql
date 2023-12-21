(
cust_id number,
cust_name varchar2(50),
mobile varchar2(50),
address varchar2(50),
email varchar2(50),
dob date
);

INSERT INTO HR.S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1000',
'Neena', '515.123.4568', 'Venice', 'NKOCHHAR', TO_DATE('2005-09-21 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO HR.S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1001',
'Lex', '515.123.4569', 'Texas', 'LDEHAAN', TO_DATE('2001-01-13 00:00:00', 'YYYY-MM-DD HH24:MI:SS'));
INSERT INTO HR.S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1002',
'Alexander', '590.423.4567', 'New York', 'AHUNOLD', TO_DATE('2006-01-03 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO HR.S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1003',
'Bruce', '590.423.4568', 'Southlake', 'BERNST', TO_DATE('2007-05-21 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO HR.S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1004',
'David', '590.423.4569', 'South San Francisco', 'DAUSTIN', TO_DATE('2005-06-25 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO HR.S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1005',
'Valli', '590.423.4560', 'South Brunswick', 'VPATABAL', TO_DATE('2006-02-05 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO HR.S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1006',
'Diana', '590.423.5567', 'Seattle', 'DLORENTZ', TO_DATE('2007-02-07 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));
INSERT INTO HR.S_CUSTOMER (CUST_ID, CUST_NAME, MOBILE, ADDRESS, EMAIL, DOB) VALUES ('1007',
'Nancy', '515.124.4569', 'Toronto', 'NGREENBE', TO_DATE('2002-08-17 00:00:00', 'YYYY-MM-DD
HH24:MI:SS'));

COMMIT;

create table t_customer
(
cust_id number primary key,
cust_name varchar2(50),
mobile varchar2(50),
address varchar2(50),
email varchar2(50),
dob date
);

-- Merge syntax
/*
merge into target
using source
on (condition)
when not matched then
insert
when matched then
update/delete;
*/
-- Merge statement
erge into t_customer t
using s_customer s
on (s.cust_id=t.cust_id)
when not matched then
insert values(s.cust_id,s.cust_name,s.mobile,s.address,s.email,s.dob)
when matched then
update set t.cust_name=s.cust_name,t.mobile=s.mobile,t.address=s.address,t.email=s.email,
t.dob=s.dob;

-- Merge with minus query

merge into t_customer t
using (select * from s_customer
minus
select * from t_customer) s
on (s.cust_id=t.cust_id)
when not matched then
insert values(s.cust_id,s.cust_name,s.mobile,s.address,s.email,s.dob)
when matched then
update set t.cust_name=s.cust_name,t.mobile=s.mobile,t.address=s.address,t.email=s.email,
t.dob=s.dob;

select * from s_customer
minus
select * from t_customer;

-- Merge with update and delete

merge into t_customer t
using (select nvl(s.cust_id,t.cust_id) as cust_id,
s.cust_name,s.mobile,s.address,s.email,s.dob from t_customer t full outer join
s_customer s on s.cust_id=t.cust_id) s
on (t.cust_id=s.cust_id)
when matched then
update set t.cust_name=s.cust_name,t.mobile=s.mobile,t.address=s.address,t.email=s.email,
t.dob=s.dob
delete where s.cust_name is null;

-- Merge with insert, update and delete

merge into t_customer t
using (select nvl(s.cust_id,t.cust_id) as cust_id,
s.cust_name,s.mobile,s.address,s.email,s.dob from t_customer t full outer join
s_customer s on s.cust_id=t.cust_id) s
on (t.cust_id=s.cust_id)
when not matched then
insert values(s.cust_id,s.cust_name,s.mobile,s.address,s.email,s.dob)
when matched then
update set t.cust_name=s.cust_name,t.mobile=s.mobile,t.address=s.address,t.email=s.email
t.dob=s.dob
delete where s.cust_name is null;
