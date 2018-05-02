--Deaths

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

	
FROM fact.DeathRecord DR
	JOIN dim.Incident I					ON DR.IncidentKey = I.IncidentKey 
	JOIN dim.ProviderOrganization PO	ON I.ProviderOrganizationKey = PO.ProviderOrganizationKey
	JOIN dim.Individual IND				ON DR.IndividualKey = IND.IndividualKey 
	JOIN dim.IndividualPHI PHI			ON DR.IndividualPHIKey = PHI.IndividualPHIKey 
		and PHI.RecordDeleted = 0
	JOIN dim.[Date] D2					ON I.IncidentDateKey = D2.DateKey
	JOIN dim.[Date] D3					ON DR.DiscoveryDateKey = D3.DateKey
	JOIN dim.[Date] D4					ON DR.EnterDateKey = D4.DateKey
	JOIN dim.ResidenceType RT			ON DR.ResidenceTypeKey = RT.ResidenceTypeKey
	JOIN dim.IncidentServiceType IST	ON DR.IncidentServiceTypeKey = IST.IncidentServiceTypeKey
	JOIN dim.Address ADR				ON DR.AddressKey = ADR.AddressKey

WHERE (D2.Date >= '01/01/2018' AND D2.Date <= '03/31/2018')

		AND (IST.ServiceTypeID in(3,5,6,7,8,9,10,11,12,13,14,15,16,17,18,39,40,41,42,43))
		AND DR.recorddeleted =0

			
		
GROUP BY	
	  D2.Date  
	, D3.Date
	, D4. Date
	, PHI.LastName
	, PHI.FirstName
	, PO.ProviderOrganizationFullName 
	, ADR.DBHDSRegion
	, PHI.Birthdate
	, PHI.DBHDSID
	, IST.ServiceTypeDescription
	
ORDER BY	D2.Date  
	, PHI.LastName
	, PHI.FirstName


;