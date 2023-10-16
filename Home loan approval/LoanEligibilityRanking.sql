select count(*) from dbo.loan_sanction						--614
select count(*) from dbo.loan_sanction_personal				--614

--Total loan amount sanctioned and not sanctioned
select loan_status, sum(LoanAmount * 1000) as Total_loan_amount, count(*) as 'No. of applications'
from dbo.loan_sanction
where LoanAmount is not null 
  and Loan_Amount_Term is not null
group by Loan_Status

--min and max income cap for with loan was sanctioned or not
select san.Loan_Status,
       min(per.ApplicantIncome + per.CoapplicantIncome) as min_income, 
       max(per.ApplicantIncome + per.CoapplicantIncome) as max_income
from dbo.loan_sanction as san
join dbo.loan_sanction_personal as per
on san.Loan_ID = per.Loan_ID
group by san.Loan_Status

--View the number of loans sanctioned based on Credit score
Create View LoanToCreditRatio as
with cte as (
select per.Credit_History as Credit_History, san.Loan_Status as Loan_Status, count(*) as 'No. of applicants'
from dbo.loan_sanction as san
join dbo.loan_sanction_personal as per
on san.Loan_ID = per.Loan_ID
group by per.Credit_History, san.Loan_Status
)
select Credit_History, Loan_status, [No. of applicants], 
       sum([No. of applicants]) over(partition by Credit_History) as Total_applicants
from cte

select * from LoanToCreditRatio
order by Loan_Status desc, Credit_History desc

--View the number of loans sanctioned for Self Employed
Create View LoanToSelfEmployed as
with cte as (
select per.Self_Employed as Self_Employed, san.Loan_Status as Loan_Status, count(*) as 'No. of applicants'
from dbo.loan_sanction as san
join dbo.loan_sanction_personal as per
on san.Loan_ID = per.Loan_ID
group by per.Self_Employed, san.Loan_Status
)
select Self_Employed, Loan_status, [No. of applicants], 
       sum([No. of applicants]) over(partition by Self_Employed) as Total_applicants
from cte

select * from LoanToSelfEmployed
order by Loan_Status desc, Self_Employed desc

--View the number of loans sanctioned for Graduates
Create View LoanToEducation as
with cte as (
select per.Education as Education, san.Loan_Status as Loan_status, count(*) as 'No. of applicants'
from dbo.loan_sanction as san
join dbo.loan_sanction_personal as per
on san.Loan_ID = per.Loan_ID
group by per.Education, san.Loan_Status
)
select Education, Loan_status, [No. of applicants], 
       sum([No. of applicants]) over(partition by Education) as Total_applicants
from cte

select * from LoanToEducation
order by Loan_Status desc, Education desc

--View the number of loans sanctioned to no. of Dependents
Create View LoanToDependent as
with cte as (
select per.Dependents as Dependents, san.Loan_Status as Loan_status, count(*) as 'No. of applicants'
from dbo.loan_sanction as san
join dbo.loan_sanction_personal as per
on san.Loan_ID = per.Loan_ID
group by per.Dependents, san.Loan_Status
)
select Dependents, Loan_status, [No. of applicants], 
       sum([No. of applicants]) over(partition by Loan_status) as Total_applicants_to_LoanStatus,
	   sum([No. of applicants]) over(partition by Dependents) as Total_applicants_to_Dependents
from cte

select * from LoanToDependent
order by Loan_Status desc, Dependents desc

--View with number of loans sanctioned for Married
Create View LoanToMarried as
with cte as (
select per.Married as Married, san.Loan_Status as Loan_status, count(*) as 'No. of applicants'
from dbo.loan_sanction as san
join dbo.loan_sanction_personal as per
on san.Loan_ID = per.Loan_ID
group by per.Married, san.Loan_Status
)
select Married, Loan_status, [No. of applicants], 
       sum([No. of applicants]) over(partition by Married) as Total_applicants
from cte

select * from LoanToMarried
order by Loan_Status desc, Married desc

--View with number of loans sanctioned for Gender
Create View LoanToGender as
with cte as (
select per.Gender as Gender, san.Loan_Status as Loan_status, count(*) as 'No. of applicants'
from dbo.loan_sanction as san
join dbo.loan_sanction_personal as per
on san.Loan_ID = per.Loan_ID
group by per.Gender, san.Loan_Status
)
select Gender, Loan_status, [No. of applicants], 
       sum([No. of applicants]) over(partition by loan_status) as Total_applicants
from cte

select * from LoanToGender
order by Loan_Status desc, Gender desc

--Create a temp table with Loan Eligibility ranking
drop table if exists #LoanEligibilityRanking

CREATE TABLE #LoanEligibilityRanking ( Loan_ID nvarchar(255),
									   Credit_History float,
									   Education nvarchar(255),
									   Dependents nvarchar(255),
                                       Property_Area nvarchar(255),
									   Self_Employed nvarchar(255),
									   Income_Points numeric,
									   Elig_Points numeric,
									   Elig_Rank numeric NULL
									)

select * from #LoanEligibilityRanking

--Insert the decision factors and points based on total income of applicants to temp table
insert into #LoanEligibilityRanking
select san.Loan_ID as Loan_ID, per.Credit_History as Credit_History, per.Education as Education, per.Dependents as Dependents,per.Property_Area as Property_Area,per.Self_Employed as Self_Employed,
       DENSE_RANK() over(partition by Property_Area
	                     order by (per.ApplicantIncome + per.CoApplicantIncome) asc)
	   as Income_points, 0 as Elig_Points, 0 as Elig_Rank 
from dbo.loan_sanction as san
join dbo.loan_sanction_personal as per
on san.Loan_ID = per.Loan_ID

select * from #LoanEligibilityRanking

--Assign the Eligibility points based on various deciding factors
update t1 
set t1.Elig_Points = (
select 
case when (Credit_History = 1) and (Education = 'Graduate') and (Dependents = '3+') then (Income_Points + 10 + 5 - 3)
     when (Credit_History = 1) and (Education = 'Graduate') and (Dependents = '2') then (Income_Points + 10 + 5 - 2)
	 when (Credit_History = 1) and (Education = 'Graduate') and (Dependents = '1') then (Income_Points + 10 + 5 - 1)
	 when (Credit_History = 1) and (Education = 'Graduate') then (Income_Points + 10 + 5)
	 when (Credit_History = 1) then (Income_Points + 10)
	 else Income_Points
end as Elig_Points
from #LoanEligibilityRanking as t2
where t1.Loan_ID = t2.Loan_ID
)
from #LoanEligibilityRanking as t1

select * from #LoanEligibilityRanking

--Rank based on eligibility points
update t1 
set t1.Elig_Rank = t2.Elig_rank
from #LoanEligibilityRanking t1
join (
select Loan_ID, RANK() over(partition by Property_Area
	               order by Elig_Points desc)
	   as Elig_Rank
from #LoanEligibilityRanking 
) as t2
on t1.Loan_ID = t2.Loan_ID

select * from #LoanEligibilityRanking
order by Property_Area, Elig_Rank asc




