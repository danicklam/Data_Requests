/* SW TABLE CREATION
 * sel count (*) from MGRS_LAM.star_wars_PC
 *  */


INSert into MGRS_LAM.star_wars_PC
select da.address_id, da.postcode, '1' as address_type_id from
edw_scver_coda_accs_views.v_dim_address da
where da.postcode IN
(
'SW4 0LD',
'ST8 7NY',
'CF2 0PX',
'SO19 8ES',
'NW6 7YD'
);