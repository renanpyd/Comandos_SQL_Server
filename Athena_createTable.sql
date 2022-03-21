CREATE EXTERNAL TABLE IF NOT EXISTS database.RH (
      `Age` int                             , `Attrition` string
	, `BusinessTravel` string               , `DailyRate` int
    , `Department` string                   , `DistanceFromHome` int
    , `Education` int                       , `EducationField` string
    , `EmployeeCount` int                   , `EmployeeNumber` int
    , `EnvironmentSatisfaction`	int         , `Gender` string
    , `HourlyRate` int                      , `JobInvolvement` int
    , `JobLevel` int                        , `JobRole` string
    , `JobSatisfaction` int                 , `MaritalStatus` string
    , `MonthlyIncome` int                   , `MonthlyRate` int
    , `NumCompaniesWorked` int              , `Over18` string
    , `OverTime` string                     , `PercentSalaryHike` int
    , `PerformanceRating` int               , `RelationshipSatisfaction` int
    , `StandardHours` int                   , `StockOptionLevel` int
    , `TotalWorkingYears` int               , `TrainingTimesLastYear` int
    , `WorkLifeBalance` int                 , `YearsAtCompany` int
    , `YearsInCurrentRole` int              , `YearsSinceLastPromotion` int 
    , `YearsWithCurrManager` int
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe'
WITH SERDEPROPERTIES (
    'serialization.format' = ',',
    'field.delim' = ','
) LOCATION 's3://athena-exercitando-buck/'
TBLPROPERTIES ('has_encrypted_data' = 'false');
	