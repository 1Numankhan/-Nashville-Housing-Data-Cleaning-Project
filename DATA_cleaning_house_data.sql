SELECT 
*
FROM data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`;

# standardize sales date

SELECT Saledate, convert(Saledate,Date) As convertedSaleDate
FROM  data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`;

update `nashville housing data for data cleaning (reuploaded)`
SET Saledate =  convert(Saledate,Date);

ALTER TABLE `nashville housing data for data cleaning (reuploaded)`
ADD convertedSaleDate DATE;

Update `nashville housing data for data cleaning (reuploaded)`
SET SaleDate = convert(Saledate,Date);


# property address
SELECT *
FROM data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`
WHERE PropertyAddress is NUll;

SELECT *
FROM data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`
-- WHERE PropertyAddress IS NULL OR PropertyAddress = '';
order by ParcelID;

-- self join the table
SELECT 
a.ParcelID,a.PropertyAddress ,
 b.ParcelID,b.PropertyAddress
FROM data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)` a 
JOIN 
    data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)` b 
 ON a.ParcelID = b.ParcelID AND a.`ï»¿UniqueID` <> b.`ï»¿UniqueID`
  
WHERE a.PorpertyAddress is NULL;



SELECT 
    a.ParcelID, a.PropertyAddress,
    b.ParcelID, b.PropertyAddress
FROM
    data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)` a
JOIN
    data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)` b
    ON a.ParcelID = b.ParcelID AND a.`ï»¿UniqueID` <> b.`ï»¿UniqueID`
WHERE
    a.PropertyAddress IS  NULL;



-- Breaking address into individual columns
-- instead of charindex for searching exact match we will be using Locate function here in mysql 
SELECT 
    SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress)- 1 ) AS address
    ,  SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress)+ 1 ) AS address
FROM 
    data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`;

-- splitting address into columns

# creating two new columns

ALTER TABLE `nashville housing data for data cleaning (reuploaded)`
ADD PropertySplitaddress Nvarchar(255);

Update `nashville housing data for data cleaning (reuploaded)`
SET PropertySplitaddress =    SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress)- 1 ) ;

ALTER TABLE `nashville housing data for data cleaning (reuploaded)`
ADD PropertySplitCity Nvarchar(255);

Update `nashville housing data for data cleaning (reuploaded)`
SET PropertySplitCity  = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress)+ 1 );

SELECT * 
FROM  data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`;




# owner address 
# split function will be sung for this task substring is little bit complicated

select 
OwnerAddress
 FROM 
  data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`;

SELECT 
substring(Replace(OwnerAddress, ',', '-'),3),
substring(Replace(OwnerAddress, ',', '-'),2),
substring(Replace(OwnerAddress, ',', '-'),1)
FROM 
  data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`;
  
  
  
  # substring_index to extract substring at specific position using certain delimitter 
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '-'), '-', 1), '-', -1) AS first_part,
    SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '-'), '-', 2), '-', -1) AS second_part,
    SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '-'), '-', 3), '-', -1) AS third_part
FROM 
    data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`;


# we will add separate columns for each 

ALter table `nashville housing data for data cleaning (reuploaded)`
Add OwnerSplitAddress nvarchar(255);

update `nashville housing data for data cleaning (reuploaded)`
set OwnerSplitAddress =   SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '-'), '-', 1), '-', -1) ;

Alter table `nashville housing data for data cleaning (reuploaded)`
add Ownersplitcity nvarchar(255);

Update `nashville housing data for data cleaning (reuploaded)`
SET Ownersplitcity =  SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '-'), '-', 2), '-', -1);

Alter table `nashville housing data for data cleaning (reuploaded)`
add ownersplitstate nvarchar(255);

update `nashville housing data for data cleaning (reuploaded)`
set ownersplitstate =  SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '-'), '-', 3), '-', -1);


SELECT *
FROM `nashville housing data for data cleaning (reuploaded)`;
 # we successfully split it into three different columns 
 




# next we will looking to sold vacant and change the N and Y to Yes and NO 
SELECT distinct(SoldAsVacant)
FROM `nashville housing data for data cleaning (reuploaded)`;

SELECT distinct(SoldAsVacant), Count(SoldAsVacant)
FROM `nashville housing data for data cleaning (reuploaded)`
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant;

# we will be using case statement 

SELECT
SoldAsVacant,
CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
     ELSE SoldAsVacant 
     END AS Soldasvacant
FROM `nashville housing data for data cleaning (reuploaded)`;


Update `nashville housing data for data cleaning (reuploaded)`
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'YES'
     WHEN SoldAsVacant = 'N' THEN 'NO'
     ELSE SoldAsVacant 
     END ;
     
     
     
     # NEXT WILL BE REMOVING DUPLICATES
	  # CTEs and window functiion where the duplicates is
      

      
      
      WITH RowNumber_CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID,
                            PropertyAddress,
                            SalePrice,
                            SaleDate,
                            LegalReference
               ORDER BY `ï»¿UniqueID`
           ) AS row_num
    FROM `nashville housing data for data cleaning (reuploaded)`
    )
SELECT *
FROM RowNumber_CTE
WHERE row_num > 1
ORDER BY PropertyAddress;


# we will delete some unused columns 
SELECT *
FROM `nashville housing data for data cleaning (reuploaded)`;

ALTER TABLE `nashville housing data for data cleaning (reuploaded)`
DROP COLUMN OwnerAddress,
DROP COLUMN PropertyAddress,
DROP COLUMN TaxDistrict;
DROP COLUMN SaleDate;
