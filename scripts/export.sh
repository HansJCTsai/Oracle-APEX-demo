#!/usr/bin/env bash
# 把 APEX App 匯出成可 diff 的拆分檔（split export）
# 用法：./scripts/export.sh <APP_ID>      例如 ./scripts/export.sh 100
# 需先在同一個終端機視窗設定：DB_USER DB_PASSWORD DB_SERVICE，並把 wallet.zip 放在專案根目錄
# 不知道 App ID？先連線後執行：select application_id, application_name from apex_applications;
set -euo pipefail
APP_ID="${1:?請帶入 Application ID，例如 ./scripts/export.sh 100}"
: "${DB_USER:?請先 export DB_USER=GITDEMO（App 的擁有者 Schema）}"
: "${DB_PASSWORD:?請先 export DB_PASSWORD='你的密碼'}"
: "${DB_SERVICE:?請先 export DB_SERVICE=devopsserver_high}"
[ -f wallet.zip ] || { echo "找不到 wallet.zip，請放在專案根目錄"; exit 1; }

rm -rf "apex/f${APP_ID}"
sql -S -cloudconfig wallet.zip "${DB_USER}/${DB_PASSWORD}@${DB_SERVICE}" <<SQL
apex export -applicationid ${APP_ID} -split -skipExportDate -dir apex
exit
SQL

# SQLcl 即使匯出失敗，結束碼也可能是 0，所以改檢查檔案是否真的產生
if [ ! -f "apex/f${APP_ID}/install.sql" ]; then
  echo "匯出失敗：找不到 apex/f${APP_ID}/install.sql。"
  echo "最常見原因是 App ID 不存在，請確認 App ID 與 DB_USER 是否正確。"
  exit 1
fi
echo "已匯出到 apex/f${APP_ID}/"
