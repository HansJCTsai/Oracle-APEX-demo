prompt --application/pages/page_groups
begin
--   Manifest
--     PAGE GROUPS: 101
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.5'
,p_default_workspace_id=>9274577264219039
,p_default_application_id=>101
,p_default_id_offset=>0
,p_default_owner=>'DEVOPSDEMO'
);
wwv_flow_imp_page.create_page_group(
 p_id=>wwv_flow_imp.id(9304145825233234)
,p_group_name=>'Administration'
,p_static_id=>'administration'
);
wwv_flow_imp.component_end;
end;
/
