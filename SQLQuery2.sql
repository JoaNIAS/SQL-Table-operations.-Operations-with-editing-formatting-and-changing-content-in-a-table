--Cleaning Data in SQL Queries 

Select * 
From [Covid_19 ]..NashvilleHousing


-- Standartize Date Format

Select SaleDateConverted, CONVERT(date, SaleDate)
From [Covid_19 ]..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(Date, SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--------------------------------------------------------------------------
--Populate Property Adress data

Select *
From [Covid_19 ]..NasvilleHousing
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Covid_19 ]..NasvilleHousing a
Join [Covid_19 ]..NasvilleHousing b
	on a.ParcelID = b.ParcelID 
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Covid_19 ]..NasvilleHousing a
Join [Covid_19 ]..NasvilleHousing b
	on a.ParcelID = b.ParcelID 
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


--------------------------------------------------------------------------
--Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [Covid_19 ]..NasvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress )-1) as Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress )+1 , LEN(PropertyAddress)) as Address

From [Covid_19 ]..NasvilleHousing

ALTER TABLE NasvilleHousing 
Add PropertySplitAddress Nvarchar(255);

Update NasvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress )-1)

ALTER TABLE NasvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NasvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress )+1 , LEN(PropertyAddress)) 

Select * 
From [Covid_19 ]..NasvilleHousing




Select OwnerAddress 
From [Covid_19 ]..NasvilleHousing

Select
PARSENAME(Replace(OwnerAddress, ',', '.'), 3),
PARSENAME(Replace(OwnerAddress, ',', '.'), 2),
PARSENAME(Replace(OwnerAddress, ',', '.'), 1)
From [Covid_19 ]..NasvilleHousing

ALTER TABLE [Covid_19 ]..NashvilleHousing
Add OwnerSplitAdress Nvarchar(255);

Update [Covid_19 ]..NashvilleHousing
SET OwnerSplitAdress = PARSENAME(Replace(OwnerAddress, ',', '.'), 3)


ALTER TABLE [Covid_19 ]..NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [Covid_19 ]..NashvilleHousing
SET OwnerSplitCity  = PARSENAME(Replace(OwnerAddress, ',', '.'), 2)


ALTER TABLE [Covid_19 ]..NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update [Covid_19 ]..NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

Select * 
From [Covid_19 ]..NashvilleHousing


-- Change Y and N to Yes and No in ""Sold as Vacant" field 

Select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
From [Covid_19 ]..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select SoldAsVacant 
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [Covid_19 ]..NashvilleHousing

Update [Covid_19 ]..NashvilleHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Remove Duplicates

WITH RowNuCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					)	row_num
From [Covid_19 ]..NashvilleHousing
)
DELETE
From RowNuCTE
Where row_num > 1
--Order by PropertyAddress

Select * 
From [Covid_19 ]..NashvilleHousing



-- Delete Unused Columns

Select* 
From [Covid_19 ]..NashvilleHousing

ALTER TABLE [Covid_19 ]..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertySplitAddress

ALTER TABLE [Covid_19 ]..NashvilleHousing
DROP COLUMN SaleDate