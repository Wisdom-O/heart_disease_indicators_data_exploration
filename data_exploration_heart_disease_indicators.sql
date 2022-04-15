
SELECT * 
FROM HeartDiseaseIndicators;

-- showing the proportion of people with heartdisease
SELECT AVG(CASE WHEN HeartDisease = 'Yes' THEN 1 ELSE 0 END) AS proportion_with_heartdisease
FROM HeartDiseaseIndicators;

-- checking min and max values of numerical columns in the dataset
SELECT
-- 	   HeartDisease,  -- optional to group the summary statistics by people who have or do not have the disease
	   MIN(BMI) AS min_bmi,
	   ROUND(AVG(BMI),2) AS avg_bmi,
-- subquery to extract the median BMI
	   (SELECT BMI 
			FROM HeartDiseaseIndicators
			ORDER BY BMI
			LIMIT 1
			OFFSET(SELECT COUNT(*)
			FROM HeartDiseaseIndicators)/2) AS Median_bmi,
	   MAX(BMI) AS max_bmi,
	   MIN(physicalhealth) AS min_physical_health,
	   ROUND(AVG(physicalhealth),2) AS avg_physical_health,
-- subquery to extract the median physical health
	   (SELECT physicalhealth 
			FROM HeartDiseaseIndicators
			ORDER BY PhysicalHealth
			LIMIT 1
			OFFSET(SELECT COUNT(*)
			FROM HeartDiseaseIndicators)/2) AS Median_physical_health,
	   MAX(physicalhealth) AS max_physical_health,
	   MIN(mentalhealth) AS min_mental_health,
	   ROUND(AVG(mentalhealth),2) AS avg_mental_health,
-- subquery to extract the median mental health
	   (SELECT MentalHealth
			FROM HeartDiseaseIndicators
			ORDER BY MentalHealth
			LIMIT 1
			OFFSET(SELECT COUNT(*)
			FROM HeartDiseaseIndicators)/2) AS Median_mental_health,
	   MAX(mentalhealth) AS max_mental_health,
	   MIN(sleeptime) AS min_sleep_time,
	   ROUND(AVG(sleeptime),2) AS avg_sleep_time,
-- subquery to calculate the median sleeptime
	   (SELECT SleepTime
			FROM HeartDiseaseIndicators
			ORDER BY SleepTime
			LIMIT 1
			OFFSET(SELECT COUNT(*)
			FROM HeartDiseaseIndicators)/2) AS Median_sleeptime,
	   MAX(sleeptime) AS max_sleep_time	  
FROM HeartDiseaseIndicators;
-- GROUP BY HeartDisease    -- optional group by

-- checking the value of records of the lowest BMIs (12.02)
SELECT *
FROM HeartDiseaseIndicators
WHERE bmi = (SELECT MIN(bmi) FROM HeartDiseaseIndicators);

-- looking at the value of records with maximum sleeptime (24 hours)
SELECT * 
FROM HeartDiseaseIndicators
WHERE SleepTime = (SELECT MAX(sleeptime) FROM HeartDiseaseIndicators);

--reoords with minimum sleeptime (1 hour)
SELECT * 
FROM HeartDiseaseIndicators
WHERE SleepTime = (SELECT MIN(sleeptime) FROM HeartDiseaseIndicators);

-- count and proportion of people in different age categories
SELECT AgeCategory,
		COUNT(*) AS frequency,
		ROUND(CAST(COUNT(*) AS FLOAT)/SUM(COUNT(*)) OVER(),4) AS proportion_of_total
FROM HeartDiseaseIndicators
GROUP BY AgeCategory;

-- count and proportion of people with a heart disease in different age categories
SELECT AgeCategory,
	   COUNT(*) AS absolute_frequency,
	   ROUND(CAST(COUNT(*) AS FLOAT)/SUM(COUNT(*)) OVER(), 4) AS relative_frequency
FROM HeartDiseaseIndicators
WHERE HeartDisease = 'Yes'
GROUP BY AgeCategory;

-- Showing a crosstab of the proportion of smokers and non-smokers with and without heart disease
SELECT HeartDisease,
	   ROUND(CAST(SUM(CASE WHEN smoking = 'Yes' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN smoking = 'Yes' THEN 1 ELSE 0 END)) OVER(), 2) AS Smokers,
	   ROUND(CAST(SUM(CASE WHEN smoking = 'No' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN smoking = 'No' THEN 1 ELSE 0 END)) OVER(),2)  AS Non_smokers
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;

-- Crosstab of the proportion of people who drink or do not drink and have or do not have heart disease
SELECT HeartDisease,
	   ROUND(CAST(SUM(CASE WHEN AlcoholDrinking = 'Yes' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN AlcoholDrinking = 'Yes' THEN 1 ELSE 0 END)) OVER(), 2) AS alcohol,
	   ROUND(CAST(SUM(CASE WHEN AlcoholDrinking = 'No' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN AlcoholDrinking = 'No' THEN 1 ELSE 0 END)) OVER(),2)  AS No_alcohol
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;

-- crosstab of the proportion of people who have had stoker or not and have or do not have heart disease
SELECT HeartDisease,
	   ROUND(CAST(SUM(CASE WHEN Stroke= 'Yes' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN Stroke = 'Yes' THEN 1 ELSE 0 END)) OVER(), 2) AS stroke,
	   ROUND(CAST(SUM(CASE WHEN Stroke = 'No' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN Stroke = 'No' THEN 1 ELSE 0 END)) OVER(),2)  AS No_stroke
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;

-- crosstab of the proportion of people who have or do not have difficulty walking and have or do not have heart disease
SELECT HeartDisease,
	   ROUND(CAST(SUM(CASE WHEN DiffWalking= 'Yes' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN DiffWalking = 'Yes' THEN 1 ELSE 0 END)) OVER(), 2) AS DiffWalking,
	   ROUND(CAST(SUM(CASE WHEN DiffWalking = 'No' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN DiffWalking = 'No' THEN 1 ELSE 0 END)) OVER(),2)  AS No_Diffwalking
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;

-- crosstab of the proportion of males and females who have or do not have heart disease
SELECT HeartDisease,
	   ROUND(CAST(SUM(CASE WHEN sex= 'Male' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN sex='Male' THEN 1 ELSE 0 END)) OVER(), 2) AS Male,
	   ROUND(CAST(SUM(CASE WHEN sex='Female' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN sex='Female' THEN 1 ELSE 0 END)) OVER(),2)  AS Female
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;

-- crosstab of the proportion of different races who have or do not have the disease 
SELECT HeartDisease,
      ROUND(CAST(SUM(CASE WHEN race = 'American Indian/Alaskan Native' THEN 1 ELSE 0 END) AS FLOAT)/ SUM(CAST(SUM(CASE WHEN race = 'American Indian/Alaskan Native' THEN 1 ELSE 0 END) AS FLOAT)) OVER(), 2) AS American_Indian,
	  ROUND(CAST(SUM(CASE WHEN race = 'Asian' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN race = 'Asian' THEN 1 ELSE 0 END)) OVER(), 2) AS Asian,
	  ROUND(CAST(SUM(CASE WHEN race = 'Black' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN race = 'Black' THEN 1 ELSE 0 END)) OVER(), 2) AS Black,
	  ROUND(CAST(SUM(CASE WHEN race = 'Hispanic' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN race = 'Hispanic' THEN 1 ELSE 0 END)) OVER(), 2) AS Hispanic,
	  ROUND(CAST(SUM(CASE WHEN race = 'White' THEN 1 ELSE 0 END) AS FLOAT) /SUM(SUM(CASE WHEN race = 'White' THEN 1 ELSE 0 END)) OVER(),2) AS White,
	  ROUND(CAST(SUM(CASE WHEN race = 'Other' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN race = 'Other' THEN 1 ELSE 0 END)) OVER(), 2) AS  Other
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;

-- pivot table of the proportion of people with different diabetic status who have or do not have the disease
SELECT HeartDisease,
	   ROUND(CAST(SUM(CASE WHEN Diabetic= 'Yes' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN Diabetic = 'Yes' THEN 1 ELSE 0 END)) OVER(), 2) AS Diabetic,
	   ROUND(CAST(SUM(CASE WHEN Diabetic = 'Yes (during pregnancy)' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN Diabetic = 'Yes (during pregnancy)' THEN 1 ELSE 0 END)) OVER(), 2) AS diabetic_during_pregnancy,
	   ROUND(CAST(SUM(CASE WHEN Diabetic = 'No, borderline diabetes' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN Diabetic = 'No, borderline diabetes' THEN 1 ELSE 0 END)) OVER(),2)  AS borderline_diabetic,
	   ROUND(CAST(SUM(CASE WHEN Diabetic = 'No' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN Diabetic = 'No' THEN 1 ELSE 0 END)) OVER(),2)  AS not_diabetic	   
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;

-- crosstab of the proportion of people who do or do not participate in physical activity and who have or do not have heart disease
SELECT HeartDisease,
	   ROUND(CAST(SUM(CASE WHEN PhysicalActivity= 'Yes' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN PhysicalActivity = 'Yes' THEN 1 ELSE 0 END)) OVER(), 2) AS PhysicalActivity,
	   ROUND(CAST(SUM(CASE WHEN PhysicalActivity = 'No' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN PhysicalActivity = 'No' THEN 1 ELSE 0 END)) OVER(),2)  AS No_PhysicalActivity
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;

-- crosstab of the proportion of people who have or do not have asthma and who have or do not have heart disease
SELECT HeartDisease,
	   ROUND(CAST(SUM(CASE WHEN Asthma = 'Yes' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN Asthma= 'Yes' THEN 1 ELSE 0 END)) OVER(), 2) AS Asthma,
	   ROUND(CAST(SUM(CASE WHEN Asthma = 'No' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN Asthma = 'No' THEN 1 ELSE 0 END)) OVER(),2)  AS No_Asthma
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;

-- crosstab of the proportion of people who have or do not have kidney disease and who have or do not have heart disease

SELECT HeartDisease,
	   ROUND(CAST(SUM(CASE WHEN KidneyDisease = 'Yes' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN KidneyDisease= 'Yes' THEN 1 ELSE 0 END)) OVER(), 2) AS KidneyDisease,
	   ROUND(CAST(SUM(CASE WHEN KidneyDisease = 'No' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN KidneyDisease = 'No' THEN 1 ELSE 0 END)) OVER(),2)  AS No_KidneyDisease
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;

-- crosstab of the proportion of people who have or do not have skin cancer and who have or do not have heart disease

SELECT HeartDisease,
	   ROUND(CAST(SUM(CASE WHEN SkinCancer = 'Yes' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN SkinCancer = 'Yes' THEN 1 ELSE 0 END)) OVER(), 2) AS Skin_Cancer,
	   ROUND(CAST(SUM(CASE WHEN SkinCancer = 'No' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN SkinCancer = 'No' THEN 1 ELSE 0 END)) OVER(),2)  AS No_Skin_Cancer
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;

-- pivot table of the proportion of people with different general health status and who have or do not have heart disease

SELECT HeartDisease,
	   ROUND(CAST(SUM(CASE WHEN GenHealth= 'Excellent' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN GenHealth='Excellent' THEN 1 ELSE 0 END)) OVER(), 2) AS Excellent_GenHealth,
	   ROUND(CAST(SUM(CASE WHEN GenHealth= 'Very good' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN GenHealth='Very good' THEN 1 ELSE 0 END)) OVER(), 2) AS Very_Good_Genhealth,
	   ROUND(CAST(SUM(CASE WHEN GenHealth = 'Good' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN GenHealth = 'Good' THEN 1 ELSE 0 END)) OVER(),2)  AS Good_Genhealth,
	   ROUND(CAST(SUM(CASE WHEN GenHealth = 'Fair' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN GenHealth = 'Fair' THEN 1 ELSE 0 END)) OVER(), 2) AS Fair_Genhealth,
	   ROUND(CAST(SUM(CASE WHEN GenHealth = 'Poor' THEN 1 ELSE 0 END) AS FLOAT)/SUM(SUM(CASE WHEN GenHealth = 'Poor' THEN 1 ELSE 0 END)) OVER(),2)  AS Poor_Genhealth   
FROM HeartDiseaseIndicators
GROUP BY HeartDisease;


