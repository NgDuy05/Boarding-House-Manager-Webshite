/**
 * capture-screenshots.js
 * Playwright script to capture all major screens of the Boarding House Management app.
 * Output: docs/screenshots/*.png (ordered with numeric prefix for doc ordering)
 */

const { chromium } = require('playwright');
const path = require('path');
const fs   = require('fs');

const BASE_URL   = 'http://localhost:9999/House_management1';
const ADMIN_USER = 'test';
const ADMIN_PASS = '321321';
const USER_USER  = 'sale';
const USER_PASS  = '321321';
const OUT_DIR    = path.join(__dirname, 'screenshots');
const VIEWPORT   = { width: 1440, height: 900 };

// Helpers ----------------------------------------------------------------

/** Take a screenshot with a numbered, slugged filename */
async function shot(page, idx, name) {
  const file = path.join(OUT_DIR, `${String(idx).padStart(2,'0')}-${name}.png`);
  await page.screenshot({ path: file, fullPage: true });
  console.log(`  [OK] ${path.basename(file)}`);
  return file;
}

/** Wait for network to settle, then screenshot */
async function nav(page, url, idx, name, extraWait = 800) {
  await page.goto(url, { waitUntil: 'networkidle', timeout: 15000 });
  await page.waitForTimeout(extraWait);
  return shot(page, idx, name);
}

/** Login helper — returns a fresh page already logged-in */
async function login(browser, username, password) {
  const ctx  = await browser.newContext({ viewport: VIEWPORT });
  const page = await ctx.newPage();
  await page.goto(`${BASE_URL}/auth`, { waitUntil: 'networkidle', timeout: 15000 });
  await page.waitForTimeout(500);
  // Fill login form
  const userField = page.locator('input[name="username"], input[type="text"]').first();
  const passField = page.locator('input[name="password"], input[type="password"]').first();
  await userField.fill(username);
  await passField.fill(password);
  await page.screenshot({ path: path.join(OUT_DIR, `00-login-filled-${username}.png`), fullPage: true });
  await page.keyboard.press('Enter');
  await page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }).catch(() => {});
  await page.waitForTimeout(1000);
  return { ctx, page };
}

// Main -------------------------------------------------------------------

(async () => {
  if (!fs.existsSync(OUT_DIR)) fs.mkdirSync(OUT_DIR, { recursive: true });

  const browser = await chromium.launch({ headless: true });

  // ── 1. GUEST PAGES ─────────────────────────────────────────────────────
  console.log('\n[GUEST]');
  const guestCtx  = await browser.newContext({ viewport: VIEWPORT });
  const guestPage = await guestCtx.newPage();

  await nav(guestPage, `${BASE_URL}/home`,     1,  'guest-trang-chu');
  await nav(guestPage, `${BASE_URL}/rooms`,    2,  'guest-danh-sach-phong');

  // Room detail — try multiple locator strategies with explicit wait
  await guestPage.goto(`${BASE_URL}/rooms`, { waitUntil: 'networkidle', timeout: 15000 });
  await guestPage.waitForTimeout(800);
  const firstRoom = guestPage.locator('a[href*="roomId"], a[href*="publicDetail"], table tbody tr:first-child a, .card a[href]').first();
  const firstRoomHref = await firstRoom.getAttribute('href').catch(() => null);
  if (firstRoomHref) {
    const detailUrl = firstRoomHref.startsWith('http') ? firstRoomHref : `${BASE_URL}${firstRoomHref.startsWith('/') ? '' : '/'}${firstRoomHref}`;
    await guestPage.goto(detailUrl, { waitUntil: 'networkidle', timeout: 15000 });
    await guestPage.waitForTimeout(800);
    await shot(guestPage, 3, 'guest-chi-tiet-phong');
  } else {
    console.log('  [SKIP] guest room detail — no link found');
  }

  await nav(guestPage, `${BASE_URL}/auth`,     4,  'guest-dang-nhap');

  // Register page
  const regLink = guestPage.locator('a[href*="register"], a:has-text("Đăng ký"), a:has-text("Register")').first();
  if (await regLink.count()) {
    await regLink.click();
    await guestPage.waitForLoadState('networkidle');
    await guestPage.waitForTimeout(600);
    await shot(guestPage, 5, 'guest-dang-ky');
  } else {
    await nav(guestPage, `${BASE_URL}/auth?action=register`, 5, 'guest-dang-ky');
  }

  await guestCtx.close();

  // ── 2. ADMIN PAGES ──────────────────────────────────────────────────────
  console.log('\n[ADMIN]');

  // Login screenshot (before submitting)
  const adminLoginCtx  = await browser.newContext({ viewport: VIEWPORT });
  const adminLoginPage = await adminLoginCtx.newPage();
  await adminLoginPage.goto(`${BASE_URL}/auth`, { waitUntil: 'networkidle' });
  await adminLoginPage.waitForTimeout(500);
  const ul = adminLoginPage.locator('input[name="username"], input[type="text"]').first();
  const pl = adminLoginPage.locator('input[name="password"], input[type="password"]').first();
  await ul.fill(ADMIN_USER);
  await pl.fill(ADMIN_PASS);
  await shot(adminLoginPage, 6, 'admin-login-nhap-thong-tin');
  await adminLoginCtx.close();

  const { ctx: adminCtx, page: adminPage } = await login(browser, ADMIN_USER, ADMIN_PASS);
  await shot(adminPage, 7, 'admin-dashboard');

  // Room management
  await nav(adminPage, `${BASE_URL}/room`,          8,  'admin-quan-ly-phong');
  await nav(adminPage, `${BASE_URL}/room?action=create`, 9, 'admin-them-phong');

  // Room category — correct URL is /room?action=categories (no /room-category servlet)
  await nav(adminPage, `${BASE_URL}/room?action=categories`, 10, 'admin-danh-muc-phong');

  // Contracts
  await nav(adminPage, `${BASE_URL}/contract`,      11, 'admin-hop-dong');
  await nav(adminPage, `${BASE_URL}/contract?action=create`, 12, 'admin-tao-hop-dong');

  // Bills
  await nav(adminPage, `${BASE_URL}/bill`,          13, 'admin-hoa-don');
  await nav(adminPage, `${BASE_URL}/bill?action=create`, 14, 'admin-tao-hoa-don');

  // Utilities
  await nav(adminPage, `${BASE_URL}/utility`,       15, 'admin-tien-ich');

  // Services — plural URL mapping in web.xml
  await nav(adminPage, `${BASE_URL}/services`,      16, 'admin-dich-vu');

  // Notifications
  await nav(adminPage, `${BASE_URL}/notification`,  17, 'admin-thong-bao');
  await nav(adminPage, `${BASE_URL}/notification?action=create`, 18, 'admin-tao-thong-bao');

  // Users & Customers
  await nav(adminPage, `${BASE_URL}/user`,          19, 'admin-nguoi-dung');
  await nav(adminPage, `${BASE_URL}/manage-customer`, 20, 'admin-khach-hang');

  // Amenities & Facilities
  await nav(adminPage, `${BASE_URL}/amenity`,       21, 'admin-tien-nghi');
  await nav(adminPage, `${BASE_URL}/facility`,      22, 'admin-co-so-vat-chat');

  // Deposits & Pricing
  await nav(adminPage, `${BASE_URL}/deposit`,       23, 'admin-dat-coc');
  await nav(adminPage, `${BASE_URL}/price`,         24, 'admin-bang-gia');

  // Activity log
  await nav(adminPage, `${BASE_URL}/activity-log`,  25, 'admin-nhat-ky');

  await adminCtx.close();

  // ── 3. CUSTOMER PAGES ───────────────────────────────────────────────────
  console.log('\n[CUSTOMER]');
  const { ctx: userCtx, page: userPage } = await login(browser, USER_USER, USER_PASS);
  await shot(userPage, 26, 'customer-dashboard');

  await nav(userPage, `${BASE_URL}/contract`,       27, 'customer-hop-dong');
  await nav(userPage, `${BASE_URL}/bill`,           28, 'customer-hoa-don');
  await nav(userPage, `${BASE_URL}/services`,       29, 'customer-dich-vu');
  await nav(userPage, `${BASE_URL}/notification`,   30, 'customer-thong-bao');

  // Profile — use direct URL (dropdown link is hidden until hover, causes timeout)
  await nav(userPage, `${BASE_URL}/customer?action=profile`, 31, 'customer-ho-so');

  await userCtx.close();
  await browser.close();

  // Summary
  const files = fs.readdirSync(OUT_DIR).filter(f => f.endsWith('.png')).sort();
  console.log(`\nDone! ${files.length} screenshots saved to: ${OUT_DIR}`);
  files.forEach(f => console.log(`  ${f}`));
})();
