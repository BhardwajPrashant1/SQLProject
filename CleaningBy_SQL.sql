Select *
from CleaningSQL..Housing

--Date Format Standardization

Select SaleDate,convert(Date,SaleDate) Sale_Date_Updated
from CleaningSQL..Housing

Update Housing
set SaleDate=convert(Date,SaleDate)

Alter Table Housing
add Sale_Date_Updated Date ;

Update Housing
set Sale_Date_Updated =convert(Date,SaleDate) ;

--Changes in Address

Select PropertyAddress
from CleaningSQL.dbo.Housing

Select PropertyAddress
from CleaningSQL.dbo.Housing
where PropertyAddress IS NULL;

--Using Self-Join Concepts to populate address using Parcel_ID i.e. Filed missing address using ParcelId

Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,Isnull(a.PropertyAddress,b.PropertyAddress)
from CleaningSQL..Housing a
join CleaningSQL..Housing b
on a.ParcelID=b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress IS NULL;

Update a --Not using table Name i.e Housing as JOIN is used in Update statement so instead of table name using alias
set PropertyAddress=Isnull(a.PropertyAddress,b.PropertyAddress)
from CleaningSQL..Housing a
join CleaningSQL..Housing b
on a.ParcelID=b.ParcelID
  and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress IS NULL;


--Splitting Address column into 3 blocks i.e Add,City,State

Select PropertyAddress
from CleaningSQL..Housing


Select 
SUBSTRING(PropertyAddress,1,Charindex(',',PropertyAddress)-1) as Address -- -1 to remove comma from Address column
,SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress)+1,len(PropertyAddress)) as City
from CleaningSQL..Housing 

Alter Table Housing
add Property_SplitAddress Nvarchar(255) ;

Update Housing
set Property_SplitAddress=SUBSTRING(PropertyAddress,1,Charindex(',',PropertyAddress)-1)

Alter Table Housing
add Property_SplitCity Nvarchar(255) ;

Update Housing
set Property_SplitCity =SUBSTRING(PropertyAddress,Charindex(',',PropertyAddress)+1,len(PropertyAddress))

Select Property_SplitAddress, Property_SplitCity
from CleaningSQL..Housing

--Another way to split column by using "Parsename":it take periods i.e "." and not  comma's ","

Select OwnerAddress
from CleaningSQL..Housing

--Select OwnerAddress,SUBSTRING(OwnerAddress,1,CHARINDEX(',',OwnerAddress)-1) as newaddress
--from CleaningSQL..Housing

Select PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from CleaningSQL..Housing

Alter Table Housing
add Owner_SplitAddress Nvarchar(255) ;

Update Housing
set Owner_SplitAddress=PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table Housing
add Owner_SplitCity Nvarchar(255) ;

Update Housing
set Owner_SplitCity=PARSENAME(Replace(OwnerAddress,',','.'),2)

Alter Table Housing
add Owner_SplitState Nvarchar(255) ;

Update Housing
set Owner_SplitState=PARSENAME(Replace(OwnerAddress,',','.'),1)


--Change Y and N in column SoldAsVacant to yes or no

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
from CleaningSQL..Housing
group by SoldAsVacant
order by 2

Select SoldAsVacant,
Case When SoldAsVacant='Y' THEN 'Yes'
      When SoldAsVacant='N' THEN 'No'
	  else SoldAsVacant
	  END
FROM CleaningSQL..Housing ;

Update CleaningSQL..Housing
Set SoldAsVacant=Case When SoldAsVacant='Y' THEN 'Yes'
      When SoldAsVacant='N' THEN 'No'
	  else SoldAsVacant
	  END




--Remove Unused Columns

Select *
from CleaningSQL..Housing

Alter Table CleaningSQL..Housing
Drop Column OwnerAddress,TaxDistrict,SaleDate

Alter Table CleaningSQL..Housing
Drop Column SaleDate


