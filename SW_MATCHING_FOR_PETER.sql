/*
create table MGRS_LAM.star_wars_PC as
(
select da.address_id, da.postcode, '1' as address_type_id from
edw_scver_coda_accs_views.v_dim_address da
where da.postcode IN
(
'LN2 2QB'
)) WITH DATA
;
*/

sel count (*) from 
mgrs_lam.star_wars_PC
;

create multiset volatile table vt_star_wars_parties as
(
sel distinct party_id, postcode from 
edw_scver_coda_accs_views.v_party_address pa
inner join mgrs_lam.star_wars_PC sw
on pa.address_type_id = sw.address_type_id
and pa.address_id = sw.address_id
) WITH DATA
ON COMMIT PRESERVE ROWS;


sel count (*) from
vt_star_wars_parties
;


collect statistics column (surname)
on
MgrS_LAM.SWC_SURNAMES;


create multiset table mgrs_lam.SW_PPPA as
(
sel 
pa.party_id, pa.forename, pa.lastname, swp.postcode, ppp.data_source_cd, ppp.email_preference_ind, ppp.mail_preference_ind,
vem.electronic_address, pa.scver_upd_dttm
from edw_scver_coda_accs_views.v_party_privacy_preferences ppp
inner join vt_star_wars_parties swp
on swp.party_id = ppp.party_id
inner join edw_scver_coda_accs_views.v_individual pa
on pa.party_id = swp.party_id
inner join MgrS_LAM.SWC_SURNAMES sws
on sws.surname = pa.lastname
left join edw_scver_coda_accs_views.v_party_address vpa
on vpa.party_id = ppp.party_id
and vpa.address_type_id = 2
left join edw_scver_coda_accs_views.v_electronic_address vem
on vem.electronic_address_id = vpa.address_id
)
with data
;








sel * from edw_scver_coda_accs_views.v_address_type;


sel count (*) from mgrs_lam.SW_PPPA;
sel top 10 * from mgrs_lam.SW_PPPA;


sel top 10 * from 
mgrs_lam.SW_PPP

;

sel top 10 * from
edw_scver_coda_accs_views.v_electronic_address
;


sel top 10 * from 
edw_scver_coda_accs_views.v_individual
;

sel top 10* from
edw_scver_coda_accs_views.v_party_privacy_preferences
;


sel requested_start_dt, count (distinct src_agreement_num)  from edw_scver_coda_dim_views.v_dim_agreement
where agreement_type_desc = 'BUSINESS'
and requested_start_dt > date '2017-06-01'
group by 1
order by requested_start_dt desc;



select top 100 * from edw_scver_coda_accs_views.v_mears_shipper_piece;

sel top 10 * from 
MgrS_SELF_SERVE_CDT.VW_RPT_INTLREVMAN;


sel min (keyed_date) from
MgrS_SELF_SERVE_CDT.VW_RPT_INTLREVMAN
;

show view
MgrS_SELF_SERVE_CDT.VW_RPT_INTLREVMAN
;

select fiscal_year_period, count (*) from 
MgrS_SELF_SERVE_CDT.VW_RPT_INTLREVMAN
group by 1
;

