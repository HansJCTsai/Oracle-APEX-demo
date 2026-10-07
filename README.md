# APEX × GitHub Actions：Commit 後自動部署 Demo

Demo 內容：修改 APEX 應用程式的一個小地方 → commit、push → GitHub Actions 自動把新版匯入資料庫 → 重新整理網頁看到變更。

## 專案結構

```
apex-demo/
├─ .github/workflows/deploy.yml   # 自動部署流程（DEV 自動、PROD 需人工核准）
├─ scripts/
│  ├─ export.sh                   # 把 APEX App 匯出成可 diff 的拆分檔
│  └─ deploy.sql                  # 把拆分檔匯入目標資料庫
├─ apex/                          # 匯出的 App 放這裡（apex/f<App ID>/...）
└─ .gitignore                     # 不讓 wallet 進版控
```

## 一次性準備（Demo 前一天做完）

1. **資料庫**：Oracle Autonomous Database（Always Free）+ APEX，建好 Workspace 與一個簡單的 App（以下以 Workspace `GITDEMO_WS`、App ID `<App ID>`、Schema `GITDEMO` 為例；GITDEMO 是用 ADMIN 自己建立的，密碼自己設定。App ID 以建立 App 後工具列顯示的數字為準）。完整的新手逐步說明請看 Claude Docs 的《Oracle APEX 自動部署：初學者從零開始手順》。
2. **下載 Wallet**：OCI Console → Autonomous Database → DB Connection → Download wallet（Instance wallet），得到 `Wallet_xxx.zip`。
3. **本機裝 SQLcl**（Java 17 以上），把 wallet 放專案根目錄並改名 `wallet.zip`。
4. **第一次匯出並 push**：
   ```bash
   export DB_USER=GITDEMO DB_PASSWORD='你的 Schema 密碼（只用英文字母和數字）' DB_SERVICE=devopsserver_high
   ./scripts/export.sh <App ID>
   git init && git add . && git commit -m "初始版本" 
   git branch -M main
   git remote add origin https://github.com/<你的帳號>/apex-demo.git
   git push -u origin main
   ```
5. **GitHub 設定**（Settings）：
   - Environments → 新增 `dev`，在裡面加 Secrets：

     | Secret | 內容 |
     |---|---|
     | `DB_USER` | App 的擁有者 Schema（如 `GITDEMO`，不是 ADMIN、也不是 APEX 開發者帳號）；部署時也會當成 schema 參數 |
     | `DB_PASSWORD` | 密碼 |
     | `DB_SERVICE` | 連線名稱，如 `devopsserver_high`（看 wallet 內 tnsnames.ora） |
     | `WALLET_B64` | `base64 -w0 wallet.zip` 的輸出（Mac 用 `base64 -i wallet.zip`） |

   - Secrets and variables → Variables：新增 `APEX_WORKSPACE`＝`GITDEMO_WS`、`APEX_APP_ID`＝`<App ID>`。
6. **先手動跑一次**：Actions → Deploy APEX app → Run workflow，確認綠燈。Demo 當天就不怕第一次失敗。

> 只有一個資料庫時，PROD 那段不用啟用（`ENABLE_PROD` 不設定就會略過）。想秀「正式環境人工核准」：新增 `production` environment，勾 Required reviewers，再把 Variable `ENABLE_PROD` 設成 `true`，並在 `production` 環境放正式庫的 Secrets。

## Demo 當天腳本（約 5–8 分鐘）

| 步驟 | 操作 | 要講的話 |
|---|---|---|
| 1 | 開 APEX 頁面，讓大家看到現在的標題 | 這是目前線上的版本 |
| 2 | 在 APEX Builder 改一個看得見的地方（例如首頁 Region 標題改成「Hello 自動部署」），儲存 | 平常我們改完就停在這裡，還要手動部署 |
| 3 | 終端機執行 `./scripts/export.sh <App ID>` | 把 App 匯出成文字檔，才能用 Git 管理 |
| 4 | `git diff` | 變更範圍小、清楚可讀，這就是可追溯 |
| 5 | `git add . && git commit -m "更新首頁標題" && git push` | 之後只要做這一步 |
| 6 | 開 GitHub → Actions，點進最新一次執行 | 不需要任何人登入系統，流程自動跑 |
| 7 | 等綠燈（約 1–2 分鐘），回 APEX 頁面重新整理 | 變更已自動上線 |

**備案**：網路不穩時，事先錄一段第 5–7 步的螢幕錄影；或準備一個已經跑成功的 Actions 紀錄頁面給大家看。

## 常見問題

- **`apex export` 找不到指令**：SQLcl 版本太舊，更新到最新版。
- **匯入時權限或 schema 錯誤**：`deploy.sql` 的第 3 個參數（CI 會帶入 `DB_USER`）必須是 App 的 Parsing Schema。
- **連不上資料庫**：確認 `DB_SERVICE` 名稱、wallet 是否完整；Always Free 的 ADB 若設了 ACL，需放行 GitHub Actions 的 IP，或改用自架 runner。
- **跑一次要很久**：SQLcl 下載約數十秒，屬正常，Demo 時可邊等邊講解。
