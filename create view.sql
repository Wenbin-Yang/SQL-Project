use _weya9345_project;
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



















