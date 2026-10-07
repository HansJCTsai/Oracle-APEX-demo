-- 用法：sql user/pass@service @scripts/deploy.sql <WORKSPACE> <APP_ID> <SCHEMA>
-- SCHEMA = App 的 Parsing Schema（資料庫使用者），例如 DEMO；注意它通常和 WORKSPACE 名稱不同
-- 讀取 apex/f<APP_ID>/ 底下 split export 的內容，匯入到目標資料庫
set define on
whenever sqlerror exit failure
whenever oserror exit failure

define ws_name = &1
define app_id  = &2
define app_schema = &3

prompt === Deploy APEX app &app_id to workspace &ws_name (schema &app_schema) ===

begin
  apex_application_install.set_workspace('&ws_name');
  apex_application_install.set_application_id(&app_id);
  apex_application_install.generate_offset;
  apex_application_install.set_schema('&app_schema');
end;
/

-- install.sql 內用相對路徑載入其他檔案，所以要先切到該資料夾
cd apex/f&app_id
@install.sql

prompt === Done ===
exit
