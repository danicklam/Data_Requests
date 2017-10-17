create table MGRS_LAM.PC_LEVEL
as
(
sel --count (distinct shp.piece_id)
shp.piece_id, shp.event_actual_date, stl.postcode 
from
edw_scver_bo_views.v_shipper_piece shp --sel top 10 * from edw_scver_bo_views.v_shipper_piece
inner join
edw_scver_bo_views.v_Postal_Piece_Event ppe --sel top 10 * from edw_scver_bo_views.v_Postal_Piece_Event
on SHP.PIECE_ID = PPE.PIECE_ID
and SHP.SOURCE_SYSTEM IN ('TODS')
and shp.event_actual_date between date '2017-08-23' and date '2017-09-20'

inner join edw_scver_bo_views.v_delivery d -- sel top 10 * from edw_scver_bo_views.v_delivery
on d.event_id = ppe.event_id
AND RM_Event_Code LIKE 'EVK%'
AND RM_Event_Code <>  'EVKLC'
AND RM_Event_Code <> 'EVKLS'

inner join
edw_scver_coda_accs_views.v_sales_transaction_line stl  -- sel top 10 * from edw_scver_coda_accs_views.v_Sales_Transaction_Line
on ppe.piece_id = stl.piece_id  
and (stl.postcode like 'E%'
or stl.postcode like 'N%'
or stl.postcode like 'SE%'
or stl.postcode like 'SW%'
or stl.postcode like 'W%'
or stl.postcode like 'WC%')
and stl.postcode not like 'EH%'
and stl.postcode not like 'EN%'
and stl.postcode not like 'EX%'
and stl.postcode not like 'NG%'
and stl.postcode not like 'NN%'
and stl.postcode not like 'NE%'
and stl.postcode not like 'NP%'
and stl.postcode not like 'NR%'
and stl.postcode not like 'WA%'
and stl.postcode not like 'WD%'
and stl.postcode not like 'WF%'
and stl.postcode not like 'WR%'
and stl.postcode not like 'WS%'
and stl.postcode not like 'WN%'
group by 1,2,3
) with data
;  
-- sel count (*) from MGRS_LAM.PC_LEVEL;
-- sel count (distinct piece_id) from MGRS_LAM.PC_LEVEL;
-- sel  from MGRS_LAM.PC_LEVEL group by 1,3;
--sel top 100 * from MGRS_LAM.PC_LEVEL;
-- drop table MGRS_LAM.PC_LEVEL;
--DELETE FROM MGRS_LAM.PC_LEVEL WHERE postcode like 'NE%';

create table MGRS_LAM.DPS_LEVEL
as
(
sel --count (distinct ep.piece_id) from
ep.piece_id, ep.event_actual_dt, da.postcode, da.delivery_point_suffix_val from
edw_scver_coda_accs_views.v_event_party ep    ------- sel top 10 * from edw_scver_coda_accs_views.v_event_party
inner join edw_scver_coda_accs_views.v_party_address pa
on  pa.party_id = ep.party_id
and pa.address_type_id = 1
and ep.event_actual_dt between date  '2017-08-23' and date '2017-09-20'
and ep.data_source_type_id = 2 
inner join edw_scver_coda_dim_views.v_dim_address da --sel top 10 * from edw_scver_coda_dim_views.v_dim_address
on da.address_id = pa.address_id
and 
(  da.postcode_area = 'E'
or da.postcode_area = 'EC'
or da.postcode_area = 'N'
or da.postcode_area = 'NW'
or da.postcode_area = 'SE'
or da.postcode_area = 'SW'
or da.postcode_area = 'W'
or da.postcode_area = 'WC' )

inner join edw_scver_bo_views.v_delivery d
on d.event_id = ep.event_id
and d.rm_event_code like 'EVK%'
AND d.RM_Event_Code <> 'EVKLS'
AND RM_Event_Code <> 'EVKLS'
group by 1,2,3,4
)
with data
;  
--sel count (*) from MGRS_LAM.DPS_LEVEL;
--sel count (distinct piece_id) from MGRS_LAM.DPS_LEVEL;
-- sel top 100 * from MGRS_LAM.DPS_LEVEL;
-- drop table MGRS_LAM.DPS_LEVEL;

--drop table MGRS_LAM.PC_DPS_LEVEL


create table MGRS_LAM.PC_DPS_LEVEL
as
(
sel dps.piece_id, dps.event_actual_dt as event_actual_date, dps.postcode, dps.delivery_point_suffix_val 
from MGRS_LAM.PC_LEVEL pc
inner join
MGRS_LAM.DPS_LEVEL dps
on pc.piece_id = dps.piece_id
group by 1,2,3,4

UNION
sel 
pc.piece_id, pc.event_actual_date, pc.postcode, '' as delivery_point_suffix_val
from MGRS_LAM.PC_LEVEL pc
where not exists
(
sel piece_id from
MGRS_LAM.DPS_LEVEL dps
where pc.piece_id = dps.piece_id)
group by 1,2,3,4
) with data
; -- sel count (*) from MGRS_LAM.PC_DPS_LEVEL

sel top 10 * from MGRS_LAM.PC_DPS_LEVEL;
sel top 10 * from MGRS_LAM.PC_DPS_LEVEL where  delivery_point_suffix_val = '';

sel event_actual_date as "date", postcode, delivery_point_suffix_val as dps, count(distinct piece_id) as nTrackedParcels
from MGRS_LAM.PC_DPS_LEVEL
group by 1,2,3,4;





-- sel count (*) from MGRS_LAM.PC_DPS_LEVEL
-- sel count (distinct piece_id) from MGRS_LAM.PC_DPS_LEVEL
-- drop table MGRS_LAM.PC_DPS_LEVEL


sel distinct postcode from 
MGRS_LAM.PC_LEVEL;

--sel count (*) from (
--sel ppe.event_actual_date, stl.postcode, stl.piece_id from 
--edw_scver_coda_accs_views.v_Sales_Transaction_Line stl
--inner join
----edw_scver_coda_accs_views.v_Sales_Transaction st
----on stl.sales_tran_id = st.sales_tran_id
--edw_scver_coda_accs_views.v_Postal_Piece_Event ppe
--on ppe.piece_id = stl.piece_id
--and ppe.event_actual_date between date '2017-09-01' and date '2017-09-30'
----and st.source_system = 'TODS'
----and stl.promised_fulfillment_dt between date '2017-09-01' and date '2017-09-30'
----and (stl.postcode like 'E%'
----or stl.postcode like 'N%'
----or stl.postcode like 'SE%'
----or stl.postcode like 'SW%'
----or stl.postcode like 'W%'
----or stl.postcode like 'WC%')
--inner join edw_scver_bo_views.v_Delivery d
--on d.event_id = ppe.event_id
--and d.source_system = 'TODS'
--and d.rm_event_code IN ('EVK%','EVKLC')
--AND d.RM_Event_Code <> 'EVKLS'
--and d.event_actual_date between date '2017-09-01' and date '2017-09-30'
--)x
--;

sel count (distinct ep.piece_id) from
--distinct ep.piece_id, ep.event_actual_dt, da.postcode, da.delivery_point_suffix_val from
edw_scver_coda_accs_views.v_event_party ep    ------- sel top 10 * from edw_scver_coda_accs_views.v_event_party
inner join edw_scver_coda_accs_views.v_party_address pa
on pa.party_id = ep.party_id
and ep.event_actual_dt between date  '2017-08-23' and date '2017-09-20'
and ep.data_source_type_id = 2 ---- 11,953,766
inner join edw_scver_coda_dim_views.v_dim_address da --sel top 10 * from edw_scver_coda_dim_views.v_dim_address
on da.address_id = pa.address_id
and 
(da.postcode_area  = 'E'
or da.postcode_area = 'EC'
or da.postcode_area = 'N'
or da.postcode_area = 'NW'
or da.postcode_area = 'SE'
or da.postcode_area = 'SW'
or da.postcode_area = 'W'
or da.postcode_area = 'WC')
inner join edw_scver_bo_views.v_delivery d
on d.piece_id = ep.piece_id
;




select count (distinct ep.piece_id) from 
---ep.piece_id, ep.event_actual_dt, da.postcode, da.delivery_point_suffix_val from
edw_scver_coda_accs_views.v_event_party ep    ------- sel top 10 * from edw_scver_coda_accs_views.v_event_party
inner join edw_scver_coda_accs_views.v_party_address pa
on pa.party_id = ep.party_id
and ep.event_actual_dt between date'2017-09-01' and date '2017-09-30'
and ep.data_source_type_id = 2 ---- 11,953,766
inner join edw_scver_coda_dim_views.v_dim_address da --sel top 10 * from edw_scver_coda_dim_views.v_dim_address
on da.address_id = pa.address_id
and (da.postcode_area  = 'E'
or da.postcode = 'N'
or da.postcode = 'SE'
or da.postcode = 'SW'
or da.postcode = 'W'
or da.postcode = 'WC')
;

sel count (distinct bbtd.piece_id)
--bbtd.piece_id, bbtd.rm_event_code, bbtd.event_id 
from edw_scver_bo_views.v_bo_base_track_data_dtl bbtd
inner join edw_scver_coda_accs_views.v_Sales_Transaction_Line stl
on stl.piece_id = bbtd.piece_id
and bbtd.rm_event_code IN ('EVK%','EVKLC') 
AND bbtd.RM_Event_Code <> 'EVKLS'
inner join edw_scver_bo_views.v_Delivery d
on bbtd.event_id = d.event_id
and d.source_system = 'TODS'
and d.event_actual_date between date'2017-09-01' and date '2017-09-30'
;


show view edw_scver__views.v_bo_base_track_data_dtl;


select count (distinct piece_id) from edw_scver_bo_views.v_bo_base_track_data_dtl bbtd
where bbtd.rm_event_code IN ('EVK%','EVKLC') 
AND bbtd.RM_Event_Code <> 'EVKLS'
and bbtd.event_actual_date between date'2017-09-01' and date '2017-09-30'
;

sel top 10 * from edw_scver_bo_views.v_bo_base_track_data_dtl;
sel top 10 * from edw_scver_coda_accs_views.v_Sales_Transaction_Line;

sel count (*) from edw_scver_coda_accs_views.v_Sales_Transaction_Line;
sel count (*) from edw_scver_bo_views.v_Sales_Transaction_Line;

sel top 10 * from edw_scver_bo_views.v_bo_base_track_data;
sel top 10 * from edw_scver_bo_views.v_bo_base_track_data_dtl;
sel top 10 * from edw_scver_bo_views.v_Shipper_Piece;
sel top 10 * from edw_scver_bo_views.v_Postal_Piece_Event;
sel top 10 * from edw_scver_coda_accs_views.v_Sales_Transaction;
sel top 10 * from edw_scver_coda_accs_views.v_Sales_Transaction_Line;
sel top 10 * from edw_scver_coda_accs_views.v_Sales_Transaction_Line_dtls;
sel top 10 * from edw_scver_coda_accs_views.v_Sales_Transaction where source_system = 'TODS';
sel top 10 * from edw_scver_bo_views.v_Delivery;
sel top 10 * from edw_scver_bo_views.v_Postal_Exception;
sel top 10 * from edw_scver_bo_views.v_Exception_Reason;