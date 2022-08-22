select * 
from [International Air Traffic]..['Airlinewise Monthly$']

select year, [AIRLINE NAME], [PASSENGERS TO INDIA], [PASSENGERS FROM INDIA], 
([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]) as total_passengers_flown
from [International Air Traffic]..['Airlinewise Monthly$']

--from india percentage
select year, [AIRLINE NAME], [PASSENGERS TO INDIA], [PASSENGERS FROM INDIA], 
([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]) as total_passengers_flown,
([PASSENGERS FROM INDIA]/([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]))*100 as from_india_percentage
from [International Air Traffic]..['Airlinewise Monthly$']
where [PASSENGERS FROM INDIA] <> 0 and [PASSENGERS TO INDIA] <> 0

--to india percentage
select year, [AIRLINE NAME], [PASSENGERS TO INDIA], [PASSENGERS FROM INDIA], 
([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]) as total_passengers_flown,
([PASSENGERS TO INDIA]/([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]))*100 as to_india_percentage
from [International Air Traffic]..['Airlinewise Monthly$']
where [PASSENGERS FROM INDIA] <> 0 and [PASSENGERS TO INDIA] <> 0

--combine table with percentage
select [AIRLINE NAME], [PASSENGERS TO INDIA], [PASSENGERS FROM INDIA], 
([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]) as total_passengers_flown,
([PASSENGERS FROM INDIA]/([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]))*100 as from_india_percentage,
([PASSENGERS TO INDIA]/([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]))*100 as to_india_percentage
from [International Air Traffic]..['Airlinewise Monthly$']
where [PASSENGERS FROM INDIA] <> 0 and [PASSENGERS TO INDIA] <> 0
group by [AIRLINE NAME], [PASSENGERS TO INDIA], [PASSENGERS FROM INDIA]
order by [AIRLINE NAME]

--for tableau table 1
select [AIRLINE NAME], sum([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]) as total_passengers_flown
from [International Air Traffic]..['Airlinewise Monthly$']
group by [AIRLINE NAME]
having sum([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]) > 3200000
order by total_passengers_flown desc

select distinct [AIRLINE NAME],
sum([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]) as total_passengers_flown,
avg([PASSENGERS FROM INDIA]/([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]))*100 as from_india_percentage,
avg([PASSENGERS TO INDIA]/([PASSENGERS TO INDIA]+[PASSENGERS FROM INDIA]))*100 as to_india_percentage
from [International Air Traffic]..['Airlinewise Monthly$']
where [PASSENGERS FROM INDIA] <> 0 and [PASSENGERS TO INDIA] <> 0
group by [AIRLINE NAME]
order by [AIRLINE NAME] asc

-- for tableau table 2
select distinct [CARRIER TYPE], count([CARRIER TYPE]) as TotalType
from [International Air Traffic]..['Airlinewise Monthly$']
group by [CARRIER TYPE]
order by 2

select *
from [International Air Traffic]..['Countrywise Quarterly Internati$']

--for tableau table 3
select distinct [COUNTRY NAME], sum([PASSENGERS FROM INDIA]+[PASSENGERS TO INDIA]) as TotalPassengers
from [International Air Traffic]..['Countrywise Quarterly Internati$']
group by [COUNTRY NAME]
order by TotalPassengers desc

select distinct [COUNTRY NAME], sum([PASSENGERS FROM INDIA]+[PASSENGERS TO INDIA]) as TotalPassengers,
avg([PASSENGERS FROM INDIA]/([PASSENGERS FROM INDIA]+[PASSENGERS TO INDIA]))*100 as from_india_percent,
avg([PASSENGERS TO INDIA]/([PASSENGERS FROM INDIA]+[PASSENGERS TO INDIA]))*100 as to_india_percent
from [International Air Traffic]..['Countrywise Quarterly Internati$']
where [PASSENGERS FROM INDIA] <> 0 and [PASSENGERS TO INDIA] <> 0
group by [COUNTRY NAME]
order by [COUNTRY NAME] asc

select *
from [International Air Traffic]..['Citypairwise Quarterly Internat$']

--for tableau table 4
select CITY2, sum([PASSENGERS FROM CITY1 TO CITY2]) as cityTotal
from [International Air Traffic]..['Citypairwise Quarterly Internat$']
group by CITY2
order by cityTotal asc

--for tableau table 5
select YEAR, sum([PASSENGERS FROM INDIA]+[PASSENGERS TO INDIA]) as TotalbyYear
from [International Air Traffic]..['Countrywise Quarterly Internati$']
group by YEAR

--for tableau table 6
select QUARTER,year, sum([PASSENGERS FROM INDIA]+[PASSENGERS TO INDIA]) as TotalbyQuarter
from [International Air Traffic]..['Countrywise Quarterly Internati$']
group by QUARTER, year