

--Cleaning Data in SQL Queries

SELECT * FROM PortfolioProject.dbo.nashvillehousing


-- Standardize Date Format

SELECT SaleDate, CONVERT(DATE,SaleDate) AS SaledateConverter
FROM PortfolioProject.dbo.nashvillehousing

UPDATE nashvillehousing
SET SaleDate = CONVERT(DATE,SaleDate)

-- Populate Property Address Data

SELECT * FROM PortfolioProject.dbo.nashvillehousing
WHERE PropertyAddress IS NULL

-- There are many NULL values in the Property Address columns, We are having two PARCEL ID  which are repeating the same address, so let's populate with the first one.

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.nashvillehousing a
JOIN PortfolioProject.dbo.nashvillehousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.dbo.nashvillehousing a
JOIN PortfolioProject.dbo.nashvillehousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress IS NULL


--Breaking out ADDRESS into Individual Columns ( ADDRESS, CITY, STATE)

SELECT PropertyAddress from 
PortfolioProject.dbo.nashvillehousing

SELECT SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) AS Address
FROM PortfolioProject.dbo.nashvillehousing

ALTER TABLE PortfolioProject.dbo.nashvillehousing
ADD propertysplitaddress NVARCHAR(255);

UPDATE PortfolioProject.dbo.nashvillehousing
SET propertysplitaddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE PortfolioProject.dbo.nashvillehousing
ADD propertysplitcity NVARCHAR(255);

UPDATE PortfolioProject.dbo.nashvillehousing
SET propertysplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))


SELECT * FROM PortfolioProject.dbo.nashvillehousing

-- Easy way

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing

ALTER TABLE PortfolioProject.dbo.nashvillehousing
ADD ownersplitaddress NVARCHAR(255);

UPDATE PortfolioProject.dbo.nashvillehousing
SET ownersplitaddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE PortfolioProject.dbo.nashvillehousing
ADD ownersplitcity NVARCHAR(255);

UPDATE PortfolioProject.dbo.nashvillehousing
SET ownersplitcity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE PortfolioProject.dbo.nashvillehousing
ADD ownersplitstate NVARCHAR(255);

UPDATE PortfolioProject.dbo.nashvillehousing
SET ownersplitstate = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

SELECT * FROM PortfolioProject.dbo.nashvillehousing


-- Change Y and N to 'Yes' and 'No' in 'Soldasvacant'

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.nashvillehousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
 ELSE SoldAsVacant
 END
 FROM PortfolioProject.dbo.nashvillehousing 

 UPDATE PortfolioProject.dbo.nashvillehousing 
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
      WHEN SoldAsVacant = 'N' THEN 'No'
 ELSE SoldAsVacant
 END

 -- Remove Duplicates

 WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
DELETE
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


 WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
SELECT * 
From RowNumCTE
Where row_num > 1
--Order by PropertyAddress


Select *
From PortfolioProject.dbo.NashvilleHousing


-- DELETE UNUSED COLUMNS

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress,SaleDate

Select *
From PortfolioProject.dbo.NashvilleHousing

--THANK YOU, the whole point of this Projectis to clean the data and make it more usable and user-friendly and standardize


