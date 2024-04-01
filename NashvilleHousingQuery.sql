select *
from NashvilleHousing..NashvilleHousingTable

--Changing SaleDate

select SaleDateConverted, CONVERT(Date,SaleDate)
from NashvilleHousing..NashvilleHousingTable

Update NashvilleHousingTable
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousingTable
Add SaleDateConverted Date;

Update NashvilleHousingTable
SET SaleDateConverted = CONVERT(Date,SaleDate)

--Populate Property Address data

select *
from NashvilleHousing..NashvilleHousingTable
--where PropertyAddress is NULL
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing..NashvilleHousingTable a
JOIN NashvilleHousing..NashvilleHousingTable b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from NashvilleHousing..NashvilleHousingTable a
JOIN NashvilleHousing..NashvilleHousingTable b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out Address into Individual columns (Address, City, State)

select PropertyAddress
from NashvilleHousing..NashvilleHousingTable
--where PropertyAddress is NULL
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress)) as Address
from NashvilleHousing..NashvilleHousingTable


ALTER TABLE NashvilleHousingTable
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousingTable
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousingTable
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousingTable
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))



ALTER TABLE NashvilleHousingTable
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousingTable
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

ALTER TABLE NashvilleHousingTable
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousingTable
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+1, LEN(PropertyAddress))

select *
from NashvilleHousing..NashvilleHousingTable

select OwnerAddress
from NashvilleHousing..NashvilleHousingTable

Select
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from NashvilleHousing..NashvilleHousingTable



ALTER TABLE NashvilleHousingTable
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousingTable
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousingTable
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousingTable
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousingTable
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousingTable
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)



--Changing Y to Yes and N to No in SoldAsVacant field

select Distinct(SoldAsVacant),Count(SoldAsVacant)
from NashvilleHousing..NashvilleHousingTable
Group by SoldAsVacant
order by 2

select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
from NashvilleHousing..NashvilleHousingTable

update NashvilleHousingTable
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Remove Duplicates
WITH RowNumCTE AS(
select *,
   ROW_NUMBER() OVER (
   PARTITION BY ParcelId,
				PropertyAddress,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY
					UniqueID
					) row_num
from NashvilleHousing..NashvilleHousingTable
--ORDER BY ParcelID
)
DELETE
from RowNumCTE
where row_num> 1
--order by PropertyAddress

select *
from NashvilleHousing..NashvilleHousingTable


-- Delete Unused Columns

Select *
from NashvilleHousing..NashvilleHousingTable

ALTER TABLE NashvilleHousing..NashvilleHousingTable
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE NashvilleHousing..NashvilleHousingTable
DROP COLUMN SaleDate