
-- 1. Clean up duration column and get hurricane duration in days
/*
ALTER  TABLE Hurricanes
ADD NewDuration nvarchar(255)

ALTER  TABLE Hurricanes
ALTER COLUMN FromDate datetime

ALTER  TABLE Hurricanes
ADD ToDate Datetime
*/

alter table Hurricanes
add FromDate_ datetime


UPDATE Hurricanes
SET NewDuration = REPLACE(REPLACE(REPLACE(REPLACE(Duration, 'â€', ''), '”', ' to '), '“', ' to '), 'Â', '')

select NewDuration, 
case when CHARINDEX(' to ', NewDuration) <> 0 then 
          case when CHARINDEX(',', NewDuration) > CHARINDEX('to', NewDuration) THEN SUBSTRING(NewDuration, 1, CHARINDEX(' to ', NewDuration)) + SUBSTRING(NewDuration, CHARINDEX(',', NewDuration), LEN(NewDuration))
		  ELSE SUBSTRING(NewDuration, 1, CHARINDEX('to', NewDuration)-1) end
     when CHARINDEX('-', NewDuration) <> 0 then SUBSTRING(NewDuration, 1, CHARINDEX('-', NewDuration)-1) + SUBSTRING(NewDuration, CHARINDEX(',', NewDuration), LEN(NewDuration))
     else NewDuration
end as FromDate
from Hurricanes

select NewDuration, FromDate from Hurricanes
where CHARINDEX(',', NewDuration) < CHARINDEX('to', NewDuration)

UPDATE T1
SET T1.FromDate = (select 
case when CHARINDEX(' to ', NewDuration) <> 0 then 
          case when CHARINDEX(',', NewDuration) > CHARINDEX('to', NewDuration) THEN SUBSTRING(NewDuration, 1, CHARINDEX(' to ', NewDuration)) + SUBSTRING(NewDuration, CHARINDEX(',', NewDuration), LEN(NewDuration))
		  ELSE SUBSTRING(NewDuration, 1, CHARINDEX('to', NewDuration)-1) end
     when CHARINDEX('-', NewDuration) <> 0 then SUBSTRING(NewDuration, 1, CHARINDEX('-', NewDuration)-1) + SUBSTRING(NewDuration, CHARINDEX(',', NewDuration), LEN(NewDuration))
     else NewDuration
end as FromDate
from Hurricanes AS T2 WHERE T2.F1 = T1.F1)
FROM Hurricanes AS T1

select NewDuration, FromDate from Hurricanes

select NewDuration, 
case when CHARINDEX(' to ', NewDuration) <> 0 then 
     case when SUBSTRING(NewDuration, CHARINDEX(' to ', NewDuration) +3, LEN(NewDuration))  not like '%[A-Za-z]%' then substring(NewDuration, 1, 3) + SUBSTRING(NewDuration, CHARINDEX(' to ', NewDuration) +3, LEN(NewDuration))
          else SUBSTRING(NewDuration, CHARINDEX(' to ', NewDuration) +3, LEN(NewDuration)) end
	 when CHARINDEX('-', NewDuration) <> 0 then 
	 case when SUBSTRING(NewDuration, CHARINDEX('-', NewDuration) +1, LEN(NewDuration))  not like '%[A-Za-z]%' then substring(NewDuration, 1, 3) + SUBSTRING(NewDuration, CHARINDEX('-', NewDuration) +1, LEN(NewDuration))
          else SUBSTRING(NewDuration, CHARINDEX('-', NewDuration) +1, LEN(NewDuration)) end
	 else NULL
end as ToDate 
from Hurricanes


UPDATE T1
SET T1.ToDate = (select 
case when CHARINDEX(' to ', NewDuration) <> 0 then 
     case when SUBSTRING(NewDuration, CHARINDEX(' to ', NewDuration) +3, LEN(NewDuration))  not like '%[A-Za-z]%' then substring(NewDuration, 1, 3) + SUBSTRING(NewDuration, CHARINDEX(' to ', NewDuration) +3, LEN(NewDuration))
          else SUBSTRING(NewDuration, CHARINDEX(' to ', NewDuration) +3, LEN(NewDuration)) end
	 when CHARINDEX('-', NewDuration) <> 0 then 
	 case when SUBSTRING(NewDuration, CHARINDEX('-', NewDuration) +1, LEN(NewDuration))  not like '%[A-Za-z]%' then substring(NewDuration, 1, 3) + SUBSTRING(NewDuration, CHARINDEX('-', NewDuration) +1, LEN(NewDuration))
          else SUBSTRING(NewDuration, CHARINDEX('-', NewDuration) +1, LEN(NewDuration)) end
	 else NULL
end as ToDate
       from Hurricanes AS T2 WHERE T2.F1 = T1.F1)
FROM Hurricanes AS T1

UPDATE Hurricanes
SET FromDate = TRIM(REPLACE(FromDate, '  ', ' '))

UPDATE Hurricanes
SET ToDate = TRIM(REPLACE(ToDate, '  ', ' '))

select NewDuration, FromDate, ToDate 
from Hurricanes

Select NewDuration, FromDate, ToDate, 
case when SUBSTRING(FromDate,1,5) like '%Jan%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-1-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Feb%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-2-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Mar%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-3-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Apr%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-4-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%May%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-5-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Jun%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-6-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Jul%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-7-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Aug%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-8-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Sep%'                                                                                                                                                                                                                             
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-9-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Oct%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-10-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Nov%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-11-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Dec%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-12-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
end as FromDate
from Hurricanes
/*
update Hurricanes
set FromDate_ = convert(datetime, FromDate)
*/
UPDATE T1
SET T1.FromDate_ = (select 
case when SUBSTRING(FromDate,1,5) like '%Jan%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-1-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Feb%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-2-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Mar%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-3-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Apr%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-4-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%May%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-5-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Jun%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-6-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Jul%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-7-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Aug%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-8-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Sep%'                                                                                                                                                                                                                             
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-9-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Oct%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-10-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Nov%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-11-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
     when SUBSTRING(FromDate,1,5) like '%Dec%' 
        then replace(replace(trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', FromDate), len(FromDate))),',','.'), 1)) + '-12-' + trim(parsename(replace(trim(SUBSTRING(FromDate, CHARINDEX(' ', REPLACE(FromDate, ' ', ' ')), len(FromDate))),',','.'), 2)), ' ', ''), ' ', '')
end as FromDate
       from Hurricanes AS T2 WHERE T2.F1 = T1.F1)
FROM Hurricanes AS T1

select NewDuration, FromDate, FromDate_ from Hurricanes

select NewDuration, ToDate from Hurricanes

Select NewDuration, FromDate, ToDate, 
case when ToDate is not NULL then
     case when SUBSTRING(ToDate,1,5) like '%Jan%' 
             then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-1-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		  when SUBSTRING(ToDate,1,5) like '%Feb%' 
			 then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-2-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		  when SUBSTRING(ToDate,1,5) like '%Mar%' 
			 then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-3-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
   		 when SUBSTRING(ToDate,1,5) like '%Apr%' 
	 		then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-4-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
	 	 when SUBSTRING(ToDate,1,5) like '%May%' 
	 		then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-5-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
	 	 when SUBSTRING(ToDate,1,5) like '%Jun%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-6-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Jul%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-7-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Aug%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-8-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Sep%'                                                                                                                                                                                                                             
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-9-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Oct%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-10-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Nov%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-11-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Dec%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-12-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		end
else ToDate 
end as ToDate
from Hurricanes

ALTER TABLE Hurricanes
add ToDate_ Datetime

UPDATE T1
SET T1.ToDate_ = (select 
case when ToDate is not NULL then
     case when SUBSTRING(ToDate,1,5) like '%Jan%' 
             then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-1-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		  when SUBSTRING(ToDate,1,5) like '%Feb%' 
			 then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-2-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		  when SUBSTRING(ToDate,1,5) like '%Mar%' 
			 then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-3-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
   		 when SUBSTRING(ToDate,1,5) like '%Apr%' 
	 		then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-4-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
	 	 when SUBSTRING(ToDate,1,5) like '%May%' 
	 		then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-5-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
	 	 when SUBSTRING(ToDate,1,5) like '%Jun%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-6-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Jul%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-7-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Aug%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-8-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Sep%'                                                                                                                                                                                                                             
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-9-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Oct%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-10-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Nov%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-11-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		 when SUBSTRING(ToDate,1,5) like '%Dec%' 
			then replace(replace(trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', ToDate), len(ToDate))),',','.'), 1)) + '-12-' + trim(parsename(replace(trim(SUBSTRING(ToDate, CHARINDEX(' ', REPLACE(ToDate, ' ', ' ')), len(ToDate))),',','.'), 2)), ' ', ''), ' ', '')
		end
else ToDate 
end as ToDate
       from Hurricanes AS T2 WHERE T2.F1 = T1.F1)
FROM Hurricanes AS T1

select FromDate_, ToDate_, DATEDIFF(day, FromDate_, ToDate_) 
from Hurricanes

ALTER TABLE Hurricanes
ADD NO_OF_DAYS INT

UPDATE T1
SET T1.NO_OF_DAYS = (select DATEDIFF(day, FromDate_, ToDate_) 
       from Hurricanes AS T2 WHERE T2.F1 = T1.F1)
FROM Hurricanes AS T1

SELECT min(NO_OF_DAYS), max(no_of_days)
FROM Hurricanes

-- 2. Clean up damage column









--Filter area affected column by USA states
--Clean up wind speed and pressure columns
--Get the date from duration column