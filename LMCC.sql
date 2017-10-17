DROP TABLE vt_addresses;

CREATE MULTISET VOLATILE TABLE vt_addresses
AS ( 
SEL * FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address da
where
da.postcode like  'BD9 4%' 
UNION
SEL * FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address da
where
da.postcode like  'EH7 5%' 
UNION
SEL * FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address da
where
da.postcode like  'SN8 1%' 
)
WITH DATA
UNIQUE PRIMARY INDEX(Address_Id) 
ON COMMIT PRESERVE ROWS;


SEL COUNT (*)
FROM
vt_addresses;

drop table vt_partyaddresses;

CREATE MULTISET VOLATILE TABLE vt_partyaddresses
AS ( 
SEL vta.*, pa.party_id FROM
vt_addresses vta
INNER JOIN  
EDW_SCVER_CODA_ACCS_VIEWS.v_party_address pa
ON VTA.address_id = pa.address_id
and pa.address_type_id = 1
)
WITH DATA
UNIQUE PRIMARY INDEX(party_Id) 
ON COMMIT PRESERVE ROWS;

COLLECT STATS column (party_id) ON vt_partyaddresses;

SEL COUNT (*)
FROM
vt_partyaddresses;




Select i.*, vtpa.*
From EDW_SCVER_CODA_ACCS_VIEWS.V_individual i
INNER JOIN
vt_partyaddresses vtpa
ON i.party_id = vtpa.party_id
;






SEL count(*) FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address da
where
da.postcode like  'BD9 4%' 
--,'EH7 5%%','SN8 1%%')
;