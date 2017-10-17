SELECT TOP 9999999 *
FROM EDW_SCVER_BO_VIEWS.v_delivery_point_address
WHERE --POSTCODE_AREA_VAL = 'SN'
--AND 
POINT_ADDRESS_ID = '316968997'
;


SELECT COUNT (*)
FROM 
EDW_SCVER_BO_VIEWS.v_delivery_point_address
;


SEL top 100*
FROM 
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address
;

SEL DISTINCT POSTCODE
FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address
WHERE POSTCODE IN 
(
'B1%','B2%','B3%','B4%','B5%',
'B6%','B7%','B8%','B9%')
;


SEL DISTINCT POSTCODE
FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address
WHERE POSTCODE LIKE 
(
'LS%')
;

SEL * FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_base_pre_adv_item_detail
WHERE delivery_postcode LIKE ANY
(
'B1%','B2%','B3%','B4%','B5%',
'B6%','B7%','B8%','B9%')
;

SEL * FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_base_pre_adv_item_detail
WHERE delivery_postcode LIKE 'LS'
;


SEL COUNT (*) FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_base_pre_adv_item_detail
WHERE delivery_postcode LIKE ANY
(
'B1%','B2%','B3%','B4%','B5%',
'B6%','B7%','B8%','B9%')
;


SEL COUNT (*) FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_base_pre_adv_item_detail
WHERE delivery_postcode LIKE ANY
(
'LS%')
;




SEL da.postcode, da.Delivery_point_suffix_val, latitude_meas, longitude_meas
from
EDW_SCVER_BO_VIEWS.v_delivery_point_address dps
inner join 
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address da
ON
da.Postcode = dps.Postcode
and da.Delivery_point_suffix_val = dps.Delivery_point_suffx_val
and da.address_id = 316968997;


/* Create a volatile table of the following DPS */




SEL DISTINCT Delivery_Point
FROM EDW_SCVER_BO_VIEWS.v_base_mpe mpe
INNER JOIN edw_Scver_coda_dim_views.v_dim_address vda
    ON OREPLACE(Delivery_Point, ' ', '') = OREPLACE(Postcode || Delivery_Point_Suffix_Val, ' ', '')
WHERE Location_ID IN ( 9699 )   --, 9391, 52624474
AND SUBSTR(tracked_event_cd, 1, 3) = 'EVK'
AND CAST(SUBSTR(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') BETWEEN '2016-08-01' AND '2016-10-31'
GROUP BY 1
;

sel count (*) FROM (
SELECT Unique_item_id, cast(substr(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') as DDate, Delivery_Point, COUNT(er_mpe_id)
FROM EDW_SCVER_BO_VIEWS.v_base_mpe
WHERE Location_ID IN ( 9699 )   --, 9391, 52624474
AND SUBSTR(tracked_event_cd, 1, 3) = 'EVK'
AND CAST(SUBSTR(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') BETWEEN '2016-08-01' AND '2016-10-31'
GROUP BY 1, 2, 3 )test
;


SELECT Unique_item_id, cast(substr(scan_dttm,1,10) AS DATE FORMAT 'yyyy-mm-dd') as DDate, Address_Id, Delivery_Point, Delivery_point_suffix_val, COUNT(er_mpe_id)
FROM EDW_SCVER_BO_VIEWS.v_base_mpe mpe
INNER JOIN edw_Scver_coda_dim_views.v_dim_address vda
    ON OREPLACE(mpe.Delivery_Point, ' ', '') = OREPLACE(vda.Postcode || vda.Delivery_Point_Suffix_Val, ' ', '')
WHERE Location_ID IN ( 9699 )   --, 9391, 52624474
AND SUBSTR(Postcode, 1 ,2) = 'SN'
AND SUBSTR(tracked_event_cd, 1, 3) = 'EVK'
AND CAST(SUBSTR(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') BETWEEN '2016-08-01' AND '2016-10-31'
and delivery_point not = ' '
GROUP BY 1, 2, 3, 4, 5;


/* 33,538 records */
SELECT Unique_item_id, cast(substr(scan_dttm,1,10) AS DATE FORMAT 'yyyy-mm-dd') as DDate, Delivery_Point, COUNT(er_mpe_id)
FROM EDW_SCVER_BO_VIEWS.v_base_mpe mpe
WHERE Location_ID IN ( 9699 )   --, 9391, 52624474
--AND SUBSTR(Postcode, 1 ,2) = 'SN'
AND SUBSTR(tracked_event_cd, 1, 3) = 'EVK'
AND CAST(SUBSTR(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') BETWEEN '2016-08-01' AND '2016-10-31'
--and delivery_point not = ' '
GROUP BY 1, 2, 3 ;

/* 123,780 */
SEL MAIL_PIECE_ID, DESTINATION_ADDRESS_ID
FROM EDW_SCVER_CODA_ACCS_VIEWS.v_SHIPPER_PIECE sp
INNER JOIN
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address da
ON sp.destination_address_id = da.address_ID
WHERE SOURCE_SYSTEM ='PARCELS'
AND sp.EVENT_ACTUAL_DATE >= '2016-08-01'
AND da.LOC_PostTown ='SWINDON' ;



Sel * FROM
EDW_SCVER_BO_VIEWS.v_base_mpe
SAMPLE 10
WHERE Location_ID IN ( 9699 )   --, 9391, 52624474
AND CAST(SUBSTR(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') BETWEEN '2016-08-01' AND '2016-10-31'
and delivery_point not = ' ';

SELECT Unique_item_id, cast(substr(scan_dttm,1,10) AS DATE FORMAT 'yyyy-mm-dd') as DDate, Address_Id, Delivery_Point, COUNT(er_mpe_id)
FROM EDW_SCVER_CODA_ACCS_VIEWS.v_base_mpe mpe
INNER JOIN edw_Scver_coda_dim_views.v_dim_address vda
    ON OREPLACE(mpe.Delivery_Point, ' ', '') = OREPLACE(vda.Postcode || vda.Delivery_Point_Suffix_Val, ' ', '')
WHERE Location_ID IN ( 9699 )   --, 9391, 52624474
AND SUBSTR(tracked_event_cd, 1, 3) = 'EVK'
AND CAST(SUBSTR(scan_dttm,1,10) AS DATE FORMAT 'yyyy-mm-dd') BETWEEN '2016-08-01' AND '2016-10-31'
and delivery_point not = ' '
GROUP BY 1, 2, 3, 4;


sel count (*) FROM (
SELECT Unique_item_id, cast(substr(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') as DDate, Address_Id, Delivery_Point, COUNT(er_mpe_id) as mpeid
FROM EDW_SCVER_BO_VIEWS.v_base_mpe mpe
INNER JOIN edw_Scver_coda_dim_views.v_dim_address vda
    ON OREPLACE(Delivery_Point, ' ', '') = OREPLACE(Postcode || Delivery_Point_Suffix_Val, ' ', '')
WHERE Location_ID IN ( 9699 )   --, 9391, 52624474
AND SUBSTR(tracked_event_cd, 1, 3) = 'EVK'
AND CAST(SUBSTR(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') BETWEEN '2016-08-01' AND '2016-10-31'
and delivery_point not = ' '
GROUP BY 1, 2, 3, 4
)num;


sel count (*) FROM (
SELECT Unique_item_id, cast(substr(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') as DDate, Address_Id, Delivery_Point, COUNT(er_mpe_id) as mpeid
FROM EDW_SCVER_BO_VIEWS.v_base_mpe mpe
LEFT JOIN edw_Scver_coda_dim_views.v_dim_address vda
    ON OREPLACE(Delivery_Point, ' ', '') = OREPLACE(Postcode || Delivery_Point_Suffix_Val, ' ', '')
WHERE Location_ID IN ( 9699 )   --, 9391, 52624474
AND SUBSTR(tracked_event_cd, 1, 3) = 'EVK'
AND CAST(SUBSTR(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') BETWEEN '2016-08-01' AND '2016-10-31'
and delivery_point not = ' '
GROUP BY 1, 2, 3, 4
)num;



SEL recipient_name, Ddate, Address_id, delivery_point, Parcels  FROM
(SELECT Unique_item_id, cast(substr(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') as DDate, Address_Id, Delivery_Point, COUNT(er_mpe_id) as Parcels
FROM EDW_SCVER_BO_VIEWS.v_base_mpe mpe
INNER JOIN edw_Scver_coda_dim_views.v_dim_address vda
    ON OREPLACE(Delivery_Point, ' ', '') = OREPLACE(Postcode || Delivery_Point_Suffix_Val, ' ', '')
WHERE Location_ID IN ( 9699 )   --, 9391, 52624474
AND SUBSTR(tracked_event_cd, 1, 3) = 'EVK'
AND CAST(SUBSTR(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') BETWEEN '2016-08-01' AND '2016-10-31'
and delivery_point not = ' '
GROUP BY 1, 2, 3, 4) DPS
LEFT JOIN
EDW_SCVER_CODA_ACCS_VIEWS.v_base_pre_adv_item_detail bpaid
ON bpaid.Unique_Item_id = DPS.unique_item_id
and recipient_name is not null
;



SELECT Address_Id, Delivery_Postcode, SUM(Mailpiece_count)
FROM EDW_SCVER_BO_VIEWS.v_pcl_ana_rep
INNER JOIN edw_Scver_coda_dim_views.v_dim_address vda
    ON OREPLACE(Delivery_Postcode, ' ', '') = OREPLACE(Postcode || Delivery_Point_Suffix_Val, ' ', '')
WHERE Expected_DO_Location_ID IN ( 9699 )   --, 9391, 52624474
AND SUBSTR(Current_status, 1, 3) = 'EVK'
--AND CAST(SUBSTR(doorstep_scan_time_dttm,1,10) AS DATE FORMAT 'YYYY-MM-DD') BETWEEN '2016-08-01' AND '2016-08-02'
AND doorstep_scan_time_dttm between '2016-08-01' AND '2016-10-31'

and delivery_postcode not = ' '
GROUP BY 1, 2;


SEL Event_actual_date, recipient_address_id, count (Recipient_party_id) as parties
FROM EDW_SCVER_CODA_DIM_VIEWS.v_fct_piece_event
WHERE Data_source_Type_id = '11'
and event_actual_date between date '2016-08-01' AND '2016-10-31'
GROUP BY 1,2 ;

sel * 
SAMPLE 10 from
EDW_SCVER_CODA_DIM_VIEWS.v_fct_piece_event
WHERE Data_source_Type_id = '11'
and event_actual_date = '2016-10-01';


sel postal_event_type_id, count (*)
From EDW_SCVER_CODA_ACCS_VIEWS.v_postal_event
where postal_event_type_id = 11
--and event_actual_Dttm = date ''
GROUP by 1;



EDW_SCVER_CODA_ACCS_VIEWS.v_party_source_dtl
EDW_SCVER_CODA_ACCS_VIEWS.v_party_address

SEL COUNT (*) FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address
WHERE LOC_POstTown = 'SWINDON';




SEL * FROM
/* 33,538 records */
(SELECT mpe.Unique_mail_id, cast(substr(scan_dttm,1,10) AS DATE FORMAT 'yyyy-mm-dd') as DDate, Delivery_Point, COUNT(er_mpe_id) as mpecount
FROM EDW_SCVER_BO_VIEWS.v_base_mpe mpe
WHERE Location_ID IN ( 9699 )   --, 9391, 52624474
--AND SUBSTR(Postcode, 1 ,2) = 'SN'
AND SUBSTR(tracked_event_cd, 1, 3) = 'EVK'
AND CAST(SUBSTR(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') BETWEEN '2016-08-01' AND '2016-10-31'
--and delivery_point not = ' '
GROUP BY 1, 2, 3 )UBPE
LEFT JOIN
/* 123,780 */
(SEL MAIL_PIECE_ID, DESTINATION_ADDRESS_ID
FROM EDW_SCVER_CODA_ACCS_VIEWS.v_SHIPPER_PIECE sp
INNER JOIN
EDW_SCVER_CODA_ACCS_VIEWS.v_dim_address da
ON sp.destination_address_id = da.address_ID
WHERE SOURCE_SYSTEM ='PARCELS'
AND sp.EVENT_ACTUAL_DATE >= '2016-08-01'
AND da.LOC_PostTown ='SWINDON' )SDATA
ON SDATA.Mail_PIECE_ID = UBPE.UNIQUE_MAIL_ID
;


SEL ER_MPE_ID, TRACKED_EVENT_CD, scan_dttm_bt, LOCATION_ID, DELIVERY_POINT, SCANLOCATION_LONGITUDE, SCANLOCATION_LATITUDE FROM 
--EDW_SCVER_CODA_ACCS_VIEWS.v_pcl_ana_rep
EDW_SCVER_BO_VIEWS.v_base_mpe mpe
where SUBSTR(TRACKED_EVENT_CD,1,3) = 'EVK'
AND CAST(SUBSTR(scan_dttm_bt,1,10) AS DATE FORMAT 'yyyy-mm-dd') BETWEEN '2016-08-01' AND '2016-10-31'
AND SCANLOCATION_LONGITUDE >= -1.9387
AND SCANLOCATION_LONGITUDE <= -1.6174
AND SCANLOCATION_LATITUDE >= 51.5051
AND SCANLOCATION_LATITUDE <= 51.6342
;


SEL 'msp' as source, tag_creation_date as tagdate, count (distinct tag_id||Tag_creation_date) FROM
EDW_SCVER_CODA_ACCS_VIEWS.v_mears_shipper_piece
where tag_creation_date between date '2017-01-11' and date '2017-01-20'
GROUP BY 1,2
UNION
SEL 'fpe' as source, mears_tag_creation_dt as tagdate, COUNT (distinct MEARS_TAG_ID||MEARS_TAG_CREATION_DT) FROM
EDW_SCVER_CODA_DIM_VIEWS.v_fct_piece_event
where mears_tag_creation_dt between date '2017-01-11' and  date'2017-01-20'
GROUP BY 1,2;


SEL event_actual_date , count(*) 
EDW_SCVER_CODA_DIM_VIEWS.v_fct_piece_event
where data_source_type_id = 2 
and event_actual_date between date '2017-01-01' and date '2017-01-07'
Group by 1;


sel * from
EDW_SCVER_CODA_DIM_VIEWS.v_fct_piece_event
where event_id = 20056993974
and event_actual_date = date '2016-11-03';



