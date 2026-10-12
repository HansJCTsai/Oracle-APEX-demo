// 部署後驗證：用瀏覽器打開 APEX App，走兩條真實使用流程，並留下截圖。
//   1. 登入 → 畫面顯示預期文字
//   2. 登入 → 開使用者選單 → 登出 → 回到登入頁
// 需要的環境變數（CI 由 GitHub Secrets / Variables 提供）：
//   APEX_APP_URL        App 的網址（在瀏覽器「登出狀態」下執行 App 時網址列的那一串）
//   APEX_TEST_USER      APEX 開發者帳號（例如 DEVUSER）
//   APEX_TEST_PASSWORD  該帳號的密碼
// 期望出現的文字：環境變數 EXPECTED_TEXT 優先（手動執行 workflow 時可臨時指定，用來示範失敗），
// 沒有的話讀 tests/expected.txt；兩者都沒有就只驗證流程能走通。
import { test, expect } from '@playwright/test';
import fs from 'node:fs';
import path from 'node:path';

const appUrl = process.env.APEX_APP_URL;
const user = process.env.APEX_TEST_USER;
const password = process.env.APEX_TEST_PASSWORD;

const expectedFile = path.join(import.meta.dirname, 'expected.txt');
const expectedText = (process.env.EXPECTED_TEXT || '').trim()
  || (fs.existsSync(expectedFile) ? fs.readFileSync(expectedFile, 'utf8').trim() : '');

test.beforeEach(() => {
  test.skip(!appUrl, '未設定 APEX_APP_URL，略過');
  test.skip(!user || !password, '未設定 APEX_TEST_USER / APEX_TEST_PASSWORD，略過');
});

// APEX 預設登入頁（頁面 9999）：Username / Password / Sign In
async function login(page) {
  await page.goto(appUrl, { waitUntil: 'domcontentloaded' });
  const username = page.locator('#P9999_USERNAME');
  if (await username.isVisible({ timeout: 15_000 }).catch(() => false)) {
    await username.fill(user);
    await page.locator('#P9999_PASSWORD').fill(password);
    await page.getByRole('button', { name: /sign in|登入/i }).click();
  }
  await expect(page.locator('#P9999_USERNAME')).toHaveCount(0, { timeout: 30_000 });
}

test('流程 1：可登入，且畫面顯示預期文字', async ({ page }) => {
  await login(page);

  if (expectedText) {
    await expect(
      page.locator('body'),
      `驗證失敗：畫面上找不到預期文字「${expectedText}」。請確認 APEX 畫面與 tests/expected.txt 是否一致`,
    ).toContainText(expectedText, { timeout: 15_000 });
  }

  // 不管內容為何，都存一張截圖，Demo 時可以直接給大家看
  await page.screenshot({ path: 'test-results/1-logged-in.png', fullPage: true });
});

test('流程 2：開使用者選單並登出，回到登入頁', async ({ page }) => {
  await login(page);

  // 右上角使用者選單（按鈕上顯示登入帳號名稱，APEX 可能轉成小寫）
  await page.getByRole('button', { name: new RegExp(user, 'i') }).first().click();
  await page.getByRole('menuitem', { name: /sign out|登出/i }).click();

  // 登出後應回到登入頁
  await expect(page.locator('#P9999_USERNAME')).toBeVisible({ timeout: 30_000 });
  await page.screenshot({ path: 'test-results/2-signed-out.png', fullPage: true });
});
