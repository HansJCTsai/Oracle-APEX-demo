-- 用法：sql user/pass@service @scripts/stage_deploy.sql <WORKSPACE> <APP_ID> <SCHEMA> <STAGE_ID>
-- 把 apex/f<APP_ID>/ 匯入成一份「暫時副本」（App ID = <STAGE_ID>，別名 STG<STAGE_ID>），
-- 供 Playwright 先測試；測試完會由 stage_remove.sql 刪掉。正式的 App（<APP_ID>）完全不會被動到。
set define on
whenever oserror exit failure

define ws_name    = &1
define app_id     = &2
define app_schema = &3
define stage_id   = &4

prompt === 先清掉可能殘留的暫時副本（找不到是正常的，下面可能出現一行錯誤可忽略）===
whenever sqlerror continue
begin
  apex_application_install.set_workspace('&ws_name');
  apex_application_install.set_keep_sessions(false);
  apex_application_install.remove_application(&stage_id);
end;
/
whenever sqlerror exit failure

prompt === Import STAGE copy: app &stage_id (from f&app_id) into workspace &ws_name ===
begin
  apex_application_install.set_workspace('&ws_name');
  apex_application_install.set_application_id(&stage_id);
  apex_application_install.generate_offset;
  apex_application_install.set_schema('&app_schema');
  -- 別名在同一個 Workspace 內不能重複，所以暫時副本要用不同的別名
  apex_application_install.set_application_alias('STG&stage_id');
end;
/

cd apex/f&app_id
@install.sql

prompt === STAGE copy ready ===
exit
