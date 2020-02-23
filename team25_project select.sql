use _weya9345_project;


use _szch8839_project;
#1 To see which companies CEO are below 45 year-old
select name, title, year(now())-YearBorn 'age',CompanyCode
from company_execs
where year(now())-YearBorn <= 45;

#2 To show the CEO information at the company has employees more than 300000.
select *
from company_execs
where CompanyCode in (
select companycode
from all_profiles
where Employees > 300000);

#3 To show each company's close price on my 21st Birthday (2016-03-28)
select dayname('2016-03-28');
Select aa.Date, aa.close as 'apple', am.close "amazon", fb.close as 'Facebook', gg.close as 'Google', 
		ibm.close as 'IBM', ints.close as 'Instagram', msft.close 'Microsoft', orac.close 'Oracle', techy.close '騰訊'
from aaplstockprice as aa
left join amznstockprice  as am
on aa.date= am.date
left join fbstockprice as fb
on aa.date=fb.date
left join googlestockprice as gg
on aa.date= gg.date
left join ibmstockprice as ibm
on aa.date= ibm.date
left join intcstockprice as ints
on aa.date= ints.date
left join msftstockprice as msft 
on aa.date= msft.date
left join oraclestockprice as orac
on aa.date= orac.date
left join techystockprice as techy
on aa.date=techy.date
where aa.date= ('2016-03-28');

#1: Basic Query: CEO who earns more than 10 million
select companycode, name, title, pay 
from company_execs
where pay > 10000000
order by pay desc;

# 2 Subquery: Display name,title,yearborn,companycode, pay for all exces who earn more than avgerage pay and who work at Google 
select name, title, yearborn,companycode,pay
from company_execs
where pay >
(select pay > avg(pay) 
from company_execs)
having companycode = 'goog';

#3 Join: To compare the close price between FB and TCENT in 2015
select  fb.date,fb.close facebook,  tc.close techy
from fbstockprice as fb
left join techystockprice as tc
on fb.date= tc.date
where year(fb.date) = 2015;


# select all the leaders' name and title from tencent
select CompanyCode,Name, title 
from company_execs
where CompanyCode = 'Tcent';

# connect  all_profiles and company_execs 
select * from company_execs
left join all_profiles
on company_execs.CompanyCode = all_profiles.CompanyCode;

# select the CEOs' companycode, name, and yearborn from the Technology companies 
select CompanyCode,Name, title, YearBorn
from company_execs
where CompanyCode in (
	select CompanyCode from all_profiles where Sector = 'Technology')
Having title like '%CEO%';


# These nine companies belong to which states? which state's companies provide the most job opportunities for the world? 
select state,sum(Employees) 'total employees', count(companycode) 'numbers'from all_profiles
group by state
order by sum(Employees) desc;


# get the gap(max(high) - min(low)) of each company in each year;
CREATE VIEW `Apple` AS
select year(Date) 'year', max(high) - min(low) 'gap'
from aaplstockprice 
group by year(Date);

CREATE VIEW `Amazon` AS
select year(Date) 'year', max(high) - min(low) 'gap'
from amznstockprice 
group by year(Date);

CREATE VIEW `Facebook` AS
select year(Date) 'year', max(high) - min(low) 'gap'
from fbstockprice 
group by year(Date);

CREATE VIEW `Google` AS
select year(Date) 'year', max(high) - min(low) 'gap'
from googlestockprice 
group by year(Date);

CREATE VIEW `IBM` AS
select year(Date) 'year', max(high) - min(low) 'gap'
from  ibmstockprice
group by year(Date);

CREATE VIEW `instagram` AS
select year(Date) 'year', max(high) - min(low) 'gap'
from intcstockprice 
group by year(Date);

CREATE VIEW `Microsoft` AS
select year(Date) 'year', max(high) - min(low) 'gap'
from msftstockprice 
group by year(Date);

CREATE VIEW `Oracle_Corporation` AS
select year(Date) 'year', max(high) - min(low) 'gap'
from oraclestockprice 
group by year(Date);

CREATE VIEW `TENCENT` AS
select year(Date) 'year', max(high) - min(low) 'gap'
from techystockprice 
group by year(Date);

select ap.year, ap.gap 'gap of apple', az.gap 'gap of amazon', fb.gap 'gap of facebook',gl.gap 'gap of google',
				ib.gap 'gap of IBM', it.gap 'gap of intel', ms.gap 'gap of microsoft',
				oc.gap 'gap of oracle_corporation', tc.gap 'gap of tencent'
from apple ap
left join amazon az
on ap.year = az.year
left join facebook fb
on ap.year = fb.year
left join google gl
on ap.year = gl.year
left join ibm ib
on ap.year = ib.year
left join intel it
on ap.year = it.year
left join microsoft ms
on ap.year = ms.year
left join oracle_corporation oc
on ap.year = oc.year
left join tencent tc
on ap.year = tc.year;


# Robert Shiller, the famous economist from Yale, is arguing with Eugene Fama, another famous economist, regarding the stock market. 
# Eugene believes the market is pretty eﬃcient, so that returns on any given day are unrelated to any other day. 
# Robert thinks Mondays are diﬀerent: after the weekend people go into Wall Street on Monday feeling gloomy, and as a consequence returns should be lower.
# According to this, Is the stock average close price lowest on Monday?
drop view if exists `avg_adj_close_price`;
CREATE VIEW `avg_adj_close_price` AS
select dayname(ap.date) dayname, avg(ap.Adj_Close) 'apple', avg(az.Adj_Close) 'amazon', avg(fb.Adj_Close) 'facebook', avg(gl.Adj_Close) 'google',
								 avg(ib.Adj_Close) 'IBM', avg(it.Adj_Close) 'intel', avg(ms.Adj_Close) 'microsoft', 
                                 avg(oc.Adj_Close) 'oracle_corporation', avg(tc.Adj_Close) 'tencent'
from aaplstockprice ap
left join amznstockprice az
on ap.date = az.date
left join fbstockprice fb
on ap.date = fb.date
left join googlestockprice gl
on ap.date = gl.date
left join ibmstockprice ib
on ap.date = ib.date
left join intcstockprice it
on ap.date = it.date
left join msftstockprice ms
on ap.date = ms.date
left join oraclestockprice oc
on ap.date = oc.date
left join techystockprice tc
on ap.date = tc.date
group by dayname(ap.date);


select 
(select dayname
from avg_adj_close_price
WHERE apple = (select min(apple) from avg_adj_close_price))apple, 
(select dayname
from avg_adj_close_price
WHERE amazon = (select min(amazon) from avg_adj_close_price))amazon,
(select dayname
from avg_adj_close_price
WHERE facebook = (select min(facebook) from avg_adj_close_price))facebook,
(select dayname
from avg_adj_close_price
WHERE google = (select min(google) from avg_adj_close_price))google,
(select dayname
from avg_adj_close_price
WHERE IBM = (select min(IBM) from avg_adj_close_price))IBM,
(select dayname
from avg_adj_close_price
WHERE intel = (select min(intel) from avg_adj_close_price))intel,
(select dayname
from avg_adj_close_price
WHERE microsoft = (select min(microsoft) from avg_adj_close_price))microsoft,
(select dayname
from avg_adj_close_price
WHERE oracle_corporation = (select min(oracle_corporation) from avg_adj_close_price))oracle_corporation,
(select dayname
from avg_adj_close_price
WHERE tencent = (select min(tencent) from avg_adj_close_price))tencent;

# 8 of the 9 companies' average close price occured in Monday, We can say Investors are less active on Monday;





######## function #########

DELIMITER // 
CREATE FUNCTION get_app_adj_close(date_input INT)
RETURNS decimal(10,6)
BEGIN
DECLARE adjusted_close VARCHAR(100);
if date(date_input) in (select date from aaplstockprice)
THEN SELECT adj_close
INTO adjusted_close
FROM aaplstockprice
WHERE date(date_input)	= date;
end if;
RETURN(adjusted_close);
END//
DELIMITER ;


## Good Day/ Bad Day Function ##
drop function if exists GBdays;
delimiter $$
create function GBdays (openprice decimal (10,6), closeprice decimal (10,6)) returns varchar(15)
deterministic
begin
	declare calc decimal (10,6);
	declare GDorBD varchar(15);
    set calc = closeprice - openprice;
    
    case 
    when calc > 0 then set GDorBD = ':)';
    when calc < 0 then set GDorBD = ':(';
    else set GDorBD = ':|';
    end case;
return (GDorBD);
end $$

delimiter ;

select *, GBdays(open, close) as 'Return' from aaplstockprice;

##PROCEDURE##
drop procedure if exists CapOnDay;
delimiter $$
create procedure CapOnDay(IN dateOfReq date, OUT CapThatDay int)
begin
	set CapThatDay = 
    (
	select sum(Volume * Close) from aaplstockprice
    where Date = dateOfReq
    );
end $$
delimiter ;

call CapOnDay('2000-01-03', @CapThatDay);
call CapOnDay('2000-01-04', @CapThatDay2);
call CapOnDay('2000-01-06', @CapThatDay3);
call CapOnDay('2006-01-08', @CapThatDay4);
call CapOnDay('2006-02-02', @CapThatDay5);


select @CapThatDay as MarketCap;
select @CapThatDay2 as MarketCap;
select @CapThatDay3 as MarketCap;
select @CapThatDay4 as MarketCap;
select @CapThatDay5 as MarketCap;

# TRIGGER

create table ExecAudit(
	Name varchar(100),
    Title varchar(100),
    Pay int,
    Exercised int,
    YearBorn varchar(5),
    CompanyCode varchar(5),
    lastUpdate timestamp,
    whatChanged char(20)
);

delimiter $$
create trigger ExecutiveAudit
after update on company_execs
for each row
begin
	if NEW.Name <> OLD.Name then
	insert into ExecAudit(Name, Title, Pay, Exercised, YearBorn, CompanyCode, lastUpdate, whatChanged)
	values (old.Name, old.Title, old.Pay, old.Exercised, old.YearBorn, old.CompanyCode, current_timestamp(), 'Original');
	insert into ExecAudit(Name, Title, Pay, Exercised, YearBorn, CompanyCode, lastUpdate, whatChanged)
	values (new.Name, old.Title, old.Pay, old.Exercised, old.YearBorn, old.CompanyCode, current_timestamp(), 'Name');
    elseif NEW.Title <> OLD.Title then
	insert into ExecAudit(Name, Title, Pay, Exercised, YearBorn, CompanyCode, lastUpdate, whatChanged)
	values (old.Name, old.Title, old.Pay, old.Exercised, old.YearBorn, old.CompanyCode, current_timestamp(), 'Original');
	insert into ExecAudit(Name, Title, Pay, Exercised, YearBorn, CompanyCode, lastUpdate, whatChanged)
	values (old.Name, new.Title, old.Pay, old.Exercised, old.YearBorn, old.CompanyCode, current_timestamp(), 'Title');
    elseif NEW.Name <> OLD.Name and NEW.Title <> Old.Title then
	insert into ExecAudit(Name, Title, Pay, Exercised, YearBorn, CompanyCode, lastUpdate, whatChanged)
	values (old.Name, old.Title, old.Pay, old.Exercised, old.YearBorn, old.CompanyCode, current_timestamp(), 'Original');
	insert into ExecAudit(Name, Title, Pay, Exercised, YearBorn, CompanyCode, lastUpdate, whatChanged)
	values (new.Name, new.Title, old.Pay, old.Exercised, old.YearBorn, old.CompanyCode, current_timestamp(), 'Name AND Title');
    end if;
    
end $$
delimiter ;



