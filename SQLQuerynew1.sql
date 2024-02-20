--Cleaning Data in sql Queries------------------------------------------------
select * from PortfolioProject..NashvilleHousing

--Standardize Date Formate----------------------------------------------

select saleDateConverted,CONVERT(date,SaleDate)
from PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing
set SaleDate = CONVERT(date,SaleDate)

alter table PortfolioProject..NashvilleHousing
add saleDateConverted date;

update PortfolioProject..NashvilleHousing
set saleDateConverted = CONVERT(date,SaleDate);

--Populate Property Address Data-----------------------------------------------
-- getting rid of null values 

select PropertyAddress
from PortfolioProject..NashvilleHousing
where PropertyAddress is null

select * from PortfolioProject..NashvilleHousing
--where PropertyAddress is null;
order by ParcelID;

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress
from PortfolioProject..NashvilleHousing a 
join PortfolioProject..NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

select a.ParcelID, a.PropertyAddress,b.ParcelID,b.PropertyAddress
,isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a 
join PortfolioProject..NashvilleHousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

update a
set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject..NashvilleHousing a 
join PortfolioProject..NashvilleHousing b
  on a.ParcelID = b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
   where a.PropertyAddress is null

--Breaking out Address into Individual Columns (Address,City,State)-----------------

select PropertyAddress
from PortfolioProject..NashvilleHousing 

select 
SUBSTRING (PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as address
,SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress)) as address
from PortfolioProject..NashvilleHousing 


alter table PortfolioProject..NashvilleHousing
add PropertySplitAddress Nvarchar(255);

update PortfolioProject..NashvilleHousing
set PropertySplitAddress = SUBSTRING (PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)


alter table PortfolioProject..NashvilleHousing
add PropertySplitCity Nvarchar(255);

update PortfolioProject..NashvilleHousing
set PropertySplitCity= SUBSTRING (PropertyAddress,CHARINDEX(',',PropertyAddress)+1,len(PropertyAddress))


select OwnerAddress
from PortfolioProject..NashvilleHousing

select 
PARSENAME(replace(OwnerAddress,',' , '.'),3)
,PARSENAME(replace(OwnerAddress,',' , '.'),2)
,PARSENAME(replace(OwnerAddress,',' , '.'),1)
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

update PortfolioProject..NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',' , '.'),3)

alter table PortfolioProject..NashvilleHousing
add OwnerSplitCity Nvarchar(255);

update PortfolioProject..NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',' , '.'),2)

alter table PortfolioProject..NashvilleHousing
add OwnerSplitSate Nvarchar(255);

update PortfolioProject..NashvilleHousing
set OwnerSplitSate = PARSENAME(replace(OwnerAddress,',' , '.'),1)

--Change Y and N to yes and no in 'SoldasVacant' field-----------------------------

select Distinct(SoldAsVacant), COUNT(SoldasVacant)
from PortfolioProject..NashvilleHousing
group by SoldasVacant
order by 2

select SoldAsVacant
,case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant 
	end
from PortfolioProject..NashvilleHousing

update PortfolioProject..NashvilleHousing
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant 
	end 

--Remove Duplicates-------------------------------------------------------

with RowNumCTE AS (
select *, 
	Row_Number() over (
	partition by 
				ParcelID,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				Order by UniqueID
				)row_num
from PortfolioProject..NashvilleHousing
--order by ParcelID
)
 select * 
--delete 
from RowNumCTE
where row_num > 1
--order by PropertyAddress
 
--Delete Unused Colums-------------------------------------------------------------

select * 
from PortfolioProject..NashvilleHousing 

Alter Table PortfolioProject..NashvilleHousing
Drop column OwnerAddress,TaxDistrict,PropertyAddress

Alter Table PortfolioProject..NashvilleHousing
Drop column SaleDate