--Serious Injury

SELECT distinct
	PHI.DBHDSID
	,  D2.Date IncidentDate 
	, D3.Date DiscoveryDate
	, D4.Date EnterDate
	,case when DATEDIFF(DAY, D3.Date, D4.Date) = 0
		then '0'
	when DATEDIFF(DAY, D3.Date, D4.Date) = 1
		then '1'
	when DATEDIFF(DAY, D3.Date, D4.Date) = 2
		then '2'
	when DATEDIFF(DAY, D3.Date, D4.Date) = 3
		then '3'
	when DATEDIFF(DAY, D3.Date, D4.Date) > 3
		then '>3'
	end as DaysFromDiscoveryToNotifyGroup

	, IST.ServiceTypeDescription
	, PHI.LastName
	, PHI.FirstName
	, PO.ProviderOrganizationFullName Prov_Reported
	, ADR.DBHDSRegion Region
		, MAX(CASE WHEN SIT.SeriousInjuryTypeCode=31			then 'Abdominal Pain; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=1			then 'Abrasion/Cut/Scratch; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=2			then 'Adverse Reaction; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=32		then 'Allergic Reaction; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=104		then 'Asp Pneumonia; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=3			then 'Asp Pneumonia; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=4			then 'Assault by client; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=5			then 'Assault by staff; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=30		then 'Bleeding; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=117		then 'Blister; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=6			then 'Bite; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=7			then 'Burn; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=110		then 'Cardiac/Resp Arrest; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=29		then 'Change in mental status; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=8			then 'Choking; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=9			then 'Constipation/BowelObstr; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=10		then 'Contusion/Hematoma; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=200		then 'Death; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=11		then 'Decubitus Ulcer; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=28		then 'Diarrhea; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=25		then 'Difficulty Breathing; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=12		then 'Dislocation/Fracture; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=13		then 'Fall; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=27		then 'Fever; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=26		then 'Hypothermia; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=15		then 'Laceration; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=111		then 'Loss of Consciousness; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=16		then 'Med Error; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=116		then 'None Apparent; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=22		then 'Other; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=17		then 'Overdose; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=109		then 'Pain; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=18		then 'Redness/Swelling; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=19		then 'Seizure/Convulsion; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=20		then 'Sprain; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=14		then 'Substance Ingestion; ' ELSE '' END)
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=21		then 'Suicidal Attempt; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=-1		then 'Unknown; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=23		then 'UTI; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=24		then 'Vomiting; ' ELSE '' END) 
		+ MAX(CASE WHEN SIT.SeriousInjuryTypeCode=113		then 'Wound Disruption; ' ELSE '' END) 
	Incident_Type
	
FROM fact.SeriousInjuryIncident SII	
	JOIN dim.Incident I					ON SII.IncidentKey = I.IncidentKey 
	JOIN dim.ProviderOrganization PO	ON I.ProviderOrganizationKey = PO.ProviderOrganizationKey
	JOIN dim.Individual IND				ON SII.IndividualKey = IND.IndividualKey 
	JOIN dim.IndividualPHI PHI			ON SII.IndividualPHIKey = PHI.IndividualPHIKey 
		and PHI.RecordDeleted = 0
	JOIN dim.[Date] D2					ON I.IncidentDateKey = D2.DateKey
	JOIN dim.[Date] D3					ON SII.DiscoveryDateKey = D3.DateKey
	JOIN dim.[Date] D4					ON SII.EnterDateKey = D4.DateKey
	JOIN dim.SeriousInjuryTypeLink SIT	ON SII.SeriousInjuryTypeGroupKey = SIT.SeriousInjuryTypeGroupKey
	JOIN dim.ResidenceType RT			ON SII.ResidenceTypeKey = RT.ResidenceTypeKey
	JOIN dim.IncidentServiceType IST	ON SII.IncidentServiceTypeKey = IST.IncidentServiceTypeKey
	JOIN dim.Address ADR				ON SII.AddressKey = ADR.AddressKey

WHERE (D2.Date >= '01/01/2018' AND D2.Date <= '03/31/2018')

		AND (IST.ServiceTypeID in(3,5,6,7,8,9,10,11,12,13,14,15,16,17,18,39,40,41,42,43))
		AND SII.recorddeleted =0

			
		
GROUP BY	
	  D2.Date  
	, D3.Date
	, D4. Date
	, PHI.LastName
	, PHI.FirstName
	, PO.ProviderOrganizationFullName 
	, ADR.DBHDSRegion
	, PHI.Birthdate
	, sii.InjuryOther
	, SII.IncidentOther
	, PHI.DBHDSID
	, IST.ServiceTypeDescription
	
ORDER BY	D2.Date  
	, PHI.LastName
	, PHI.FirstName


;


