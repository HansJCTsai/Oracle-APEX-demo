prompt --application/delete_application
begin
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.5'
,p_default_workspace_id=>9274577264219039
,p_default_application_id=>101
,p_default_id_offset=>9663907514246593
,p_default_owner=>'DEVOPSDEMO'
);
wwv_flow_imp.remove_flow(wwv_flow.g_flow_id);
wwv_flow_imp.component_end;
end;
/
