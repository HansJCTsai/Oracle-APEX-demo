-- 用法：sql user/pass@service @scripts/stage_remove.sql <WORKSPACE> <STAGE_ID>
-- 刪除 stage_deploy.sql 建出來的暫時副本。找不到時不當成失敗（可能根本沒建成功）。
set define on
whenever sqlerror continue

define ws_name  = &1
define stage_id = &2

prompt === Remove STAGE copy &stage_id from workspace &ws_name ===
begin
  apex_application_install.set_workspace('&ws_name');
  apex_application_install.set_keep_sessions(false);
  apex_application_install.remove_application(&stage_id);
end;
/
exit
