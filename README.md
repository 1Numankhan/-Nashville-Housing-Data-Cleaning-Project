# Nashville Housing Data Cleaning Project
## Overview
This portfolio project focuses on cleaning and preparing the Nashville housing dataset using MySQL. The primary goal is to standardize date formats, handle missing values, split and format address and owner information, and address other data quality issues. The cleaning process involves using various SQL queries to transform and standardize the data.

# Queries and Data Cleaning Steps

## **1. Standardizing Sales Date**
```sql
-- Extracting and standardizing sale dates
SELECT Saledate, CONVERT(Saledate, DATE) AS convertedSaleDate
FROM  data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`;

-- Updating the table with the standardized dates
UPDATE `nashville housing data for data cleaning (reuploaded)`
SET Saledate =  CONVERT(Saledate, DATE);

-- Adding a new column for the standardized sale dates
ALTER TABLE `nashville housing data for data cleaning (reuploaded)`
ADD convertedSaleDate DATE;

-- Updating the new column with the standardized dates
UPDATE `nashville housing data for data cleaning (reuploaded)`
SET SaleDate = CONVERT(Saledate, DATE);
```
## 2. Handling Null Values in Property Address

```sql
-- Selecting rows with null PropertyAddress
SELECT *
FROM data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`
WHERE PropertyAddress IS NULL;
```

## 3. Self-Joining the Table for Null Property Address
``` SQL
-- Self-joining to find rows with null PropertyAddress based on ParcelID
SELECT 
    a.ParcelID, a.PropertyAddress,
    b.ParcelID, b.PropertyAddress
FROM
    data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)` a
JOIN
    data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)` b
    ON a.ParcelID = b.ParcelID AND a.`ï»¿UniqueID` <> b.`ï»¿UniqueID`
WHERE
    a.PropertyAddress IS NULL;
```
## 4. Breaking Address into Individual Columns
```sql
-- Breaking PropertyAddress into two columns
SELECT 
    SUBSTRING_INDEX(PropertyAddress, ',', 1) AS address,
    SUBSTRING_INDEX(PropertyAddress, ',', -1) AS city
FROM 
    data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`;
```

## 5. Splitting Owner Address
```sql
-- Splitting OwnerAddress into three parts
SELECT 
    SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '-'), '-', 1), '-', -1) AS first_part,
    SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '-'), '-', 2), '-', -1) AS second_part,
    SUBSTRING_INDEX(SUBSTRING_INDEX(REPLACE(OwnerAddress, ',', '-'), '-', 3), '-', -1) AS third_part
FROM 
    data_cleaning_house_data.`nashville housing data for data cleaning (reuploaded)`;
```

## 6. Standardizing 'SoldAsVacant' Column
Standardizing 'SoldAsVacant' column values
```sql
UPDATE `nashville housing data for data cleaning (reuploaded)`
SET SoldAsVacant = CASE 
                        WHEN SoldAsVacant = 'Y' THEN 'YES'
                        WHEN SoldAsVacant = 'N' THEN 'NO'
                        ELSE SoldAsVacant 
                    END;
```

## 7. Removing Duplicates Using CTE and Window Function
```sql
-- Using CTE and window function to identify and select duplicates
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
```

 Dropping unused columns from the table
```sql
ALTER TABLE `nashville housing data for data cleaning (reuploaded)`
DROP COLUMN OwnerAddress,
DROP COLUMN PropertyAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN SaleDate;
```
## Conclusion
The provided queries outline the step-by-step process of cleaning the Nashville housing dataset. The operations include standardizing date formats, handling null values, splitting address and owner information into separate columns, standardizing categorical values, identifying and removing duplicates, and dropping unused columns. These cleaning steps ensure that the dataset is well-organized, standardized, and ready for further analysis or modeling.
