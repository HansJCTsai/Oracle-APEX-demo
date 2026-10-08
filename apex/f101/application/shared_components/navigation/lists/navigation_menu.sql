prompt --application/shared_components/navigation/lists/navigation_menu
begin
--   Manifest
--     LIST: Navigation Menu
--   Manifest End
wwv_flow_imp.component_begin (
 p_version_yyyy_mm_dd=>'2026.03.30'
,p_release=>'26.1.5'
,p_default_workspace_id=>9274577264219039
,p_default_application_id=>101
,p_default_id_offset=>9459774277770428
,p_default_owner=>'DEVOPSDEMO'
);
wwv_flow_imp_shared.create_list(
 p_id=>wwv_flow_imp.id(18759350040003496)
,p_name=>'Navigation Menu'
,p_static_id=>'navigation-menu'
,p_version_scn=>'SH256:cHt1JBAsdhBQ33AnvpfXBU18H-3M3vYQlMNJXIW4-yc'
);
wwv_flow_imp_shared.create_list_item(
 p_id=>wwv_flow_imp.id(18770592048003726)
,p_list_item_display_sequence=>10
,p_list_item_link_text=>'Home'
,p_static_id=>'home'
,p_list_item_link_target=>'f?p=&APP_ID.:1:&APP_SESSION.::&DEBUG.:::'
,p_list_item_icon=>'fa-home'
,p_list_item_current_type=>'TARGET_PAGE'
);
wwv_flow_imp.component_end;
end;
/
