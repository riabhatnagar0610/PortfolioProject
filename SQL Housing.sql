select *
from [Housing Data]..housing

--Standardize Date Format (removing time)
select SaleDate, convert(date,saledate)
from [Housing Data]..housing

alter table [Housing Data]..housing
add SaleDateConverted date;

update [Housing Data]..housing
set SaleDateConverted = CONVERT(date, saledate)

select SaleDateConverted
from [Housing Data]..housing

--Populate Property Address
select *
from [Housing Data]..housing
where PropertyAddress is null

select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress,
isnull(a.propertyaddress, b.propertyaddress)
from [Housing Data]..housing a
join [Housing Data]..housing b
 on a.parcelid = b.parcelid 
 and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

update a
set PropertyAddress = isnull(a.propertyaddress, b.propertyaddress)
from [Housing Data]..housing a
join [Housing Data]..housing b
 on a.parcelid = b.parcelid 
 and a.uniqueid <> b.uniqueid
where a.propertyaddress is null


--Breaking Owner and Property Address into address, city and state
select PropertyAddress
from [Housing Data]..housing

select 
substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1) as Address,
substring(PropertyAddress, charindex(',', PropertyAddress)+1, len(PropertyAddress)) as City
from [Housing Data]..housing

alter table [Housing Data]..housing
add Address nvarchar(255);
update [Housing Data]..housing
set Address = substring(PropertyAddress, 1, charindex(',', PropertyAddress)-1)

alter table [Housing Data]..housing
add City nvarchar(255);
update[Housing Data]..housing
set City = substring(PropertyAddress, charindex(',', PropertyAddress)+1, len(PropertyAddress))

select Address, City
from [Housing Data]..housing

--for owner address using parse
select OwnerAddress
from [Housing Data]..housing


select 
PARSENAME(replace(owneraddress,',','.'), 1)
from [Housing Data]..housing

select 
PARSENAME(replace(owneraddress,',','.'), 3),
PARSENAME(replace(owneraddress,',','.'), 2),
PARSENAME(replace(owneraddress,',','.'), 1)
from [Housing Data]..housing

alter table [Housing Data]..housing
add O_Address nvarchar(255);
update[Housing Data]..housing
set O_Address = PARSENAME(replace(owneraddress,',','.'), 3)

alter table [Housing Data]..housing
add O_City nvarchar(255);
update[Housing Data]..housing
set O_City = PARSENAME(replace(owneraddress,',','.'), 2)

alter table [Housing Data]..housing
add O_State nvarchar(255);
update[Housing Data]..housing
set O_State = PARSENAME(replace(owneraddress,',','.'), 1)

select O_Address, O_City, O_State
from [Housing Data]..housing

--changing Yand N to YES and NO in 'sold as vacant' field
select SoldAsVacant
from [Housing Data]..housing

select distinct(SoldAsVacant), count(soldasvacant)
from [Housing Data]..housing
group by SoldAsVacant
order by 2

select SoldAsVacant
, case when SoldAsVacant='Y' then 'Yes'
       when SoldAsVacant='N' then 'No'
	   else SoldAsVacant
	   end
from [Housing Data]..housing

alter table [Housing Data]..housing
add Sold_as_vacant nvarchar(255);
update [Housing Data]..housing
set Sold_as_vacant = case when SoldAsVacant='Y' then 'Yes'
       when SoldAsVacant='N' then 'No'
	   else SoldAsVacant
	   end

select distinct(Sold_As_Vacant), count(sold_as_vacant)
from [Housing Data]..housing
group by Sold_As_Vacant
order by 2

--Remove Duplicates

with row_num_cte as (
select *,
ROW_NUMBER() over (
    partition by parcelid,
	propertyaddress,
	saleprice,
	saledate,
	legalreference
	order by uniqueid) row_num
from [Housing Data]..housing)

delete
--select *
from row_num_cte
where row_num > 1
--order by PropertyAddress


with row_num_cte as (
select *,
ROW_NUMBER() over (
    partition by parcelid,
	propertyaddress,
	saleprice,
	saledate,
	legalreference
	order by uniqueid) row_num
from [Housing Data]..housing)

select * 
from row_num_cte
where row_num > 1
order by propertyaddress


--delete unused coloumns
select *
from [Housing Data]..housing

alter table [Housing Data]..housing
drop column OwnerAddress, PropertyAddress, TaxDistrict

alter table [Housing Data]..housing
drop column SaleDate

alter table [Housing Data]..housing
drop column Property_Address

