prompt --application/shared_components/user_interface/lovs/boolean
begin
--   Manifest
--     BOOLEAN
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.5'
,p_default_workspace_id=>9274577264219039
,p_default_application_id=>101
,p_default_id_offset=>9663907514246593
,p_default_owner=>'DEVOPSDEMO'
);
wwv_flow_imp_shared.create_list_of_values(
 p_id=>wwv_flow_imp.id(28436027684250345)
,p_lov_name=>'BOOLEAN'
,p_static_id=>'boolean'
,p_lov_query=>'.'||wwv_flow_imp.id(28436027684250345)||'.'
,p_location=>'STATIC'
,p_version_scn=>'SH256:CnCBOq-zabcz-aPWKwU8C5KDeZy6YuyjvpJoTrTywfI'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(28436728806250357)
,p_lov_disp_sequence=>2
,p_lov_disp_value=>'No'
,p_lov_return_value=>'FALSE'
,p_static_id=>'false'
);
wwv_flow_imp_shared.create_static_lov_data(
 p_id=>wwv_flow_imp.id(28436289613250353)
,p_lov_disp_sequence=>1
,p_lov_disp_value=>'Yes'
,p_lov_return_value=>'TRUE'
,p_static_id=>'true'
);
wwv_flow_imp.component_end;
end;
/
