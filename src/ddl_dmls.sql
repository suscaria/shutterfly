create table orders (
customer_id  varchar(500),
order_date timestamp,
order_amt decimal(18,6),
currency  varchar(100)
);

create table orders (
customer_id  varchar(500),
cust_city  varchar(500),
cust_state  varchar(500)
);


create table clickstream (
event_type  varchar(500),
customer_id  varchar(500),
event_timestamp  timestamp
);



select
T1.customer_id,
52 * (case when order_amt is not null then order amt else 0 end) * site_cnt *10 as LTV
(
   select
   customer_id,
   sum(case when event_type='SITE_VISIT' then 1 else 0 end ) as site_cnt
   from
   clickstream
   where
   event_timestamp between '2018-07-22' and '2018-07-28'
   group by 1
) T1
left join
(
   select
   customer_id,
   sum(order_amt) as order_amt
   from
   orders
   where
   order_date between '2018-07-22' and '2018-07-28'
   group by 1
) T2
where
T1.customer_id=T2.customer_id