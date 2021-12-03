--DATA CLEANING IN SQL

Select *
From dbo.JuvilleHousing
order by ParcelID


--STANDARDIZE DATA FORMAT

Select SaleDateConverted, SaleDate, CONVERT(Date, Saledate) 
From dbo.JuvilleHousing

Update dbo.JuvilleHousing
SET SaleDate = CONVERT(DATE, SaleDate)

ALTER TABLE JuvilleHousing
Add SaleDateConverted Date;

Update dbo.JuvilleHousing
SET SaleDateConverted = CONVERT(Date, SaleDate)


--POPULATE PROPERTY ADDRESS DATA

Select f.ParcelID, f.PropertyAddress, s.[ParcelID], s.PropertyAddress, ISNULL(f.PropertyAddress,s.PropertyAddress)
From dbo.JuvilleHousing as f
join dbo.JuvilleHousing as s
on f.parcelid = s.parcelid
and f.[UniqueID ]<> s.[UniqueID ]
where f.PropertyAddress is Null


update f
set PropertyAddress = ISNULL(f.propertyAddress, s.PropertyAddress)
From dbo.JuvilleHousing as f
Join dbo.JuvilleHousing as s
on f.ParcelID = s.ParcelID
And f.[UniqueID ]<> s.[UniqueID ]
where f.PropertyAddress is NULL


--BREAKINGOUT ADDRESS INTO INDIVIDUAL COLUMNS(ADDRESS, CITY, STATE)

Select
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS City
From dbo.JuvilleHousing
--order by ParcelID

ALTER TABLE JuvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update dbo.JuvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE JuvilleHousing
Add PropertySplitCity Nvarchar(255);

Update dbo.JuvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



Select OwnerAddress,
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)
From dbo.JuvilleHousing
--order by ParcelID


ALTER TABLE JuvilleHousing
ADD OwnerSplitAddress Nvarchar(255);

Update JuvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

ALTER TABLE JuvilleHousing
ADD OwnerSplitCity Nvarchar(255);

Update JuvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

ALTER TABLE JuvilleHousing
ADD OwnerSplitState Nvarchar(255);

UPDATE JuvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)  


--CHANGE Y AND N TO YES AND NO IN "SOLD AS VACANT" FIELD


select SoldAsVacant,
	CASE When SoldAsVacant = 'Y' then 'YES'
		 When SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
	END
From JuvilleHousing

Update JuvilleHousing
SET SoldAsVacant = 
	CASE When SoldAsVacant = 'Y' then 'YES'
		 When SoldAsVacant = 'N' then 'No'
		 Else SoldAsVacant
	END


SELECT DISTINCT(SoldasVacant)
From JuvilleHousing



--REMOVE DUPLICATES


WITH RowNumCTE AS(
select *, 
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
From JuvilleHousing
)
Select *
From RowNumCTE
where row_num > 1
Order by UniqueID


--DELETE UNUSED COLUMNS

Select *
from JuvilleHousing

ALTER TABLE JuvilleHousing
DROP column OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE JuvilleHousing
DROP column SaleDate