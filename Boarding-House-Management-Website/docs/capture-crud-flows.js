/**
 * capture-crud-flows.js
 * Playwright script to capture step-by-step CRUD operation screenshots
 * for 8 modules: Room, RoomCategory, Contract, Bill, Utility, Service, Notification, Deposit
 * + Customer perspective flows.
 *
 * Naming: screenshots/crud-{module}-{step}-{action}.png
 * Strategy: create test data with prefix [TEST], do NOT delete after (avoids complex cleanup).
 * Each module is isolated in try/catch — one failure won't stop others.
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

// ── Helpers ───────────────────────────────────────────────────────────────────

/** Save a named screenshot (no numeric prefix — CRUD shots use descriptive names) */
async function shot(page, name) {
  const file = path.join(OUT_DIR, `${name}.png`);
  await page.screenshot({ path: file, fullPage: true });
  console.log(`  [OK] ${path.basename(file)}`);
  return file;
}

/** Navigate and wait, then screenshot */
async function nav(page, url, name, wait = 900) {
  await page.goto(BASE_URL + url, { waitUntil: 'networkidle', timeout: 15000 });
  await page.waitForTimeout(wait);
  return shot(page, name);
}

/** Login and return {ctx, page} */
async function login(browser, username, password) {
  const ctx  = await browser.newContext({ viewport: VIEWPORT });
  const page = await ctx.newPage();
  await page.goto(`${BASE_URL}/auth`, { waitUntil: 'networkidle', timeout: 15000 });
  await page.waitForTimeout(500);
  await page.locator('input[name="username"]').first().fill(username);
  await page.locator('input[name="password"]').first().fill(password);
  await Promise.all([
    page.waitForNavigation({ waitUntil: 'networkidle', timeout: 15000 }).catch(() => {}),
    page.keyboard.press('Enter'),
  ]);
  await page.waitForTimeout(1000);
  return { ctx, page };
}

/** Click first link matching selector, wait, screenshot. Returns new URL. */
async function clickFirst(page, selector, shotName) {
  const el   = page.locator(selector).first();
  const href = await el.getAttribute('href').catch(() => null);
  if (href) {
    const url = href.startsWith('http') ? href : BASE_URL + (href.startsWith('/') ? '' : '/') + href;
    await page.goto(url, { waitUntil: 'networkidle', timeout: 15000 });
    await page.waitForTimeout(800);
    await shot(page, shotName);
    return url;
  }
  console.log(`  [SKIP] clickFirst — no match for: ${selector}`);
  return null;
}

/** Fill a form field if it exists */
async function fillIfExists(page, selector, value) {
  const el = page.locator(selector).first();
  if (await el.count()) await el.fill(String(value));
}

/** Select option if exists */
async function selectIfExists(page, selector, value) {
  const el = page.locator(selector).first();
  if (await el.count()) await el.selectOption(String(value));
}

// ── Module: Room CRUD ─────────────────────────────────────────────────────────
// Admin uses /room (default = categories/publicList view)
// Room detail: /room?action=publicDetail&id=N
// Room edit:   /room?action=edit&id=N  (admin only)
// Room create: /room?action=create

async function captureRoomCrud(page) {
  console.log('\n[CRUD] Room');
  try {
    // 1. Room categories / public list (this IS the main room admin view)
    await nav(page, '/room', 'crud-room-01-list');

    // 2. Room detail (publicDetail - visible to admin with edit button)
    await page.goto(BASE_URL + '/room?action=publicDetail&id=1', { waitUntil: 'networkidle', timeout: 12000 });
    await page.waitForTimeout(800);
    await shot(page, 'crud-room-02-detail');

    // 3. Edit form
    await page.goto(BASE_URL + '/room?action=edit&id=1', { waitUntil: 'networkidle', timeout: 12000 });
    await page.waitForTimeout(800);
    await shot(page, 'crud-room-03-edit-form');

    // 4. Fill edit form and submit
    await selectIfExists(page, 'select[name="status"]', 'Occupied');
    await shot(page, 'crud-room-04-edit-filled');
    await Promise.all([
      page.waitForNavigation({ waitUntil: 'networkidle', timeout: 12000 }).catch(() => {}),
      page.locator('button[type="submit"], input[type="submit"]').first().click(),
    ]);
    await page.waitForTimeout(800);
    await shot(page, 'crud-room-05-edit-result');

    // 5. Create form
    await nav(page, '/room?action=create', 'crud-room-06-create-form');

    // 6. Fill create form
    await fillIfExists(page, 'input[name="roomNumber"]', 'TEST-101');
    const catSel = page.locator('select[name="categoryId"]').first();
    if (await catSel.count()) {
      const opts = await catSel.locator('option[value]:not([value=""])').all();
      if (opts.length) await catSel.selectOption(await opts[0].getAttribute('value'));
    }
    await selectIfExists(page, 'select[name="status"]', 'Available');
    await shot(page, 'crud-room-07-create-filled');
  } catch (e) {
    console.log(`  [ERROR] Room CRUD: ${e.message}`);
  }
}

// ── Module: Room Category ─────────────────────────────────────────────────────

async function captureRoomCategoryCrud(page) {
  console.log('\n[CRUD] Room Category');
  try {
    // List
    await nav(page, '/room?action=categories', 'crud-roomcat-01-list');

    // Create form — try common action names
    const createUrls = ['/room?action=createCategory', '/room?action=create-category'];
    let created = false;
    for (const url of createUrls) {
      await page.goto(BASE_URL + url, { waitUntil: 'networkidle', timeout: 10000 });
      await page.waitForTimeout(600);
      if (!page.url().includes('404') && !page.url().includes('error')) {
        await shot(page, 'crud-roomcat-02-create-form');
        created = true;
        break;
      }
    }
    if (!created) {
      // Try clicking "Add" button on list page
      await nav(page, '/room?action=categories', 'crud-roomcat-01-list');
      const addBtn = page.locator('a:has-text("Thêm"), a:has-text("Add"), a:has-text("Tạo"), .btn-primary').first();
      const addHref = await addBtn.getAttribute('href').catch(() => null);
      if (addHref) {
        await page.goto(BASE_URL + addHref, { waitUntil: 'networkidle', timeout: 10000 });
        await page.waitForTimeout(600);
        await shot(page, 'crud-roomcat-02-create-form');
      }
    }

    // Edit form — click first edit button on category list
    await nav(page, '/room?action=categories', 'crud-roomcat-01-list');
    await clickFirst(page,
      'a[href*="edit"], a:has-text("Sửa"), a:has-text("Edit"), .btn-warning',
      'crud-roomcat-03-edit-form');
  } catch (e) {
    console.log(`  [ERROR] RoomCategory CRUD: ${e.message}`);
  }
}

// ── Module: Contract ──────────────────────────────────────────────────────────

async function captureContractCrud(page) {
  console.log('\n[CRUD] Contract');
  try {
    // List
    await nav(page, '/contract', 'crud-contract-01-list');

    // Create form
    await nav(page, '/contract?action=create', 'crud-contract-02-create-form');

    // Detail — first contract
    await nav(page, '/contract', 'crud-contract-01-list');
    const detailUrl = await clickFirst(page,
      'a[href*="action=detail"], a[href*="contractId"], table tbody tr:first-child td a',
      'crud-contract-03-detail');

    // Manage tenants from detail page
    if (detailUrl) {
      const tenantBtn = page.locator(
        'a[href*="addContractTenant"], a[href*="manageTenant"], a:has-text("Quản lý người thuê"), a:has-text("Tenant")'
      ).first();
      const tenantHref = await tenantBtn.getAttribute('href').catch(() => null);
      if (tenantHref) {
        await page.goto(BASE_URL + tenantHref, { waitUntil: 'networkidle', timeout: 12000 });
        await page.waitForTimeout(800);
        await shot(page, 'crud-contract-04-tenant-management');
      }
    }

    // Edit form
    await nav(page, '/contract', 'crud-contract-01-list');
    await clickFirst(page,
      'a[href*="action=edit"], a:has-text("Sửa"), a:has-text("Edit")',
      'crud-contract-05-edit-form');
  } catch (e) {
    console.log(`  [ERROR] Contract CRUD: ${e.message}`);
  }
}

// ── Module: Bill ──────────────────────────────────────────────────────────────

async function captureBillCrud(page) {
  console.log('\n[CRUD] Bill');
  try {
    // List
    await nav(page, '/bill', 'crud-bill-01-list');

    // Create form
    await nav(page, '/bill?action=create', 'crud-bill-02-create-form');

    // Detail — first bill
    await nav(page, '/bill', 'crud-bill-01-list');
    const detailUrl = await clickFirst(page,
      'a[href*="action=detail"], a[href*="billId"], table tbody tr:first-child td a',
      'crud-bill-03-detail');

    // Update status form
    if (detailUrl) {
      const statusBtn = page.locator(
        'a[href*="status"], a[href*="updateStatus"], button:has-text("Cập nhật"), a:has-text("Trạng thái")'
      ).first();
      const statusHref = await statusBtn.getAttribute('href').catch(() => null);
      if (statusHref) {
        await page.goto(BASE_URL + statusHref, { waitUntil: 'networkidle', timeout: 12000 });
        await page.waitForTimeout(800);
        await shot(page, 'crud-bill-04-status-update');
      } else {
        // Try navigating to bill status page
        await page.goto(`${BASE_URL}/bill?action=status`, { waitUntil: 'networkidle', timeout: 10000 });
        await page.waitForTimeout(600);
        if (!page.url().includes('404')) await shot(page, 'crud-bill-04-status-update');
      }
    }
  } catch (e) {
    console.log(`  [ERROR] Bill CRUD: ${e.message}`);
  }
}

// ── Module: Utility ───────────────────────────────────────────────────────────

async function captureUtilityCrud(page) {
  console.log('\n[CRUD] Utility');
  try {
    // List
    await nav(page, '/utility', 'crud-utility-01-list');

    // Detail of first utility
    await clickFirst(page,
      'a[href*="action=detail"], a[href*="utilityId"], table tbody tr:first-child td a',
      'crud-utility-02-detail');

    // Add usage form
    const usageUrls = ['/utility?action=addUsage', '/utility?action=add-usage', '/utility?action=usage'];
    for (const url of usageUrls) {
      await page.goto(BASE_URL + url, { waitUntil: 'networkidle', timeout: 10000 });
      await page.waitForTimeout(600);
      if (!page.url().includes('error')) {
        await shot(page, 'crud-utility-03-add-usage-form');
        break;
      }
    }

    // Add price form
    const priceUrls = ['/utility?action=addPrice', '/utility?action=add-price'];
    for (const url of priceUrls) {
      await page.goto(BASE_URL + url, { waitUntil: 'networkidle', timeout: 10000 });
      await page.waitForTimeout(600);
      if (!page.url().includes('error')) {
        await shot(page, 'crud-utility-04-add-price-form');
        break;
      }
    }
  } catch (e) {
    console.log(`  [ERROR] Utility CRUD: ${e.message}`);
  }
}

// ── Module: Service ───────────────────────────────────────────────────────────
// Admin URLs: /services?action=adminList, create, edit&id=N, manageRequests

async function captureServiceCrud(page) {
  console.log('\n[CRUD] Service');
  try {
    // Admin list
    await nav(page, '/services?action=adminList', 'crud-service-01-admin-list');

    // Edit form (id=1 exists from debug)
    await page.goto(BASE_URL + '/services?action=edit&id=1', { waitUntil: 'networkidle', timeout: 12000 });
    await page.waitForTimeout(800);
    await shot(page, 'crud-service-02-edit-form');

    // Create form
    await nav(page, '/services?action=create', 'crud-service-03-create-form');

    // Request/manage list
    await nav(page, '/services?action=manageRequests', 'crud-service-04-manage-requests');

    // All usage records
    await nav(page, '/services?action=requestList', 'crud-service-05-all-usage');
  } catch (e) {
    console.log(`  [ERROR] Service CRUD: ${e.message}`);
  }
}

// ── Module: Notification ──────────────────────────────────────────────────────
// Admin URLs: /notification?action=list, create, detail&id=N, edit&id=N

async function captureNotificationCrud(page) {
  console.log('\n[CRUD] Notification');
  try {
    // List
    await nav(page, '/notification?action=list', 'crud-notif-01-list');

    // Create broadcast form
    await nav(page, '/notification?action=create', 'crud-notif-02-create-form');
    await fillIfExists(page, 'input[name="title"]', '[TEST] Thong bao chung');
    await fillIfExists(page, 'textarea[name="content"], input[name="content"]', 'Noi dung thong bao chung gui den tat ca nguoi thue.');
    await shot(page, 'crud-notif-03-broadcast-filled');

    // Create targeted notification
    await nav(page, '/notification?action=create', 'crud-notif-04-create-targeted-form');
    await fillIfExists(page, 'input[name="title"]', '[TEST] Thong bao rieng');
    await fillIfExists(page, 'textarea[name="content"], input[name="content"]', 'Noi dung thong bao rieng theo hop dong.');
    const contractSel = page.locator('select[name="targetContractId"]').first();
    if (await contractSel.count()) {
      const opts = await contractSel.locator('option[value]:not([value=""])').all();
      if (opts.length) await contractSel.selectOption(await opts[0].getAttribute('value'));
    }
    await shot(page, 'crud-notif-05-targeted-filled');

    // Detail of first notification
    await page.goto(BASE_URL + '/notification?action=detail&id=8', { waitUntil: 'networkidle', timeout: 12000 });
    await page.waitForTimeout(800);
    await shot(page, 'crud-notif-06-detail');

    // Edit form
    await page.goto(BASE_URL + '/notification?action=edit&id=8', { waitUntil: 'networkidle', timeout: 12000 });
    await page.waitForTimeout(800);
    await shot(page, 'crud-notif-07-edit-form');
  } catch (e) {
    console.log(`  [ERROR] Notification CRUD: ${e.message}`);
  }
}

// ── Module: Deposit ───────────────────────────────────────────────────────────

async function captureDepositCrud(page) {
  console.log('\n[CRUD] Deposit');
  try {
    // List
    await nav(page, '/deposit', 'crud-deposit-01-list');

    // Create form
    const createUrls = ['/deposit?action=create', '/deposit?action=form'];
    for (const url of createUrls) {
      await page.goto(BASE_URL + url, { waitUntil: 'networkidle', timeout: 10000 });
      await page.waitForTimeout(600);
      if (!page.url().includes('error')) {
        await shot(page, 'crud-deposit-02-create-form');
        break;
      }
    }
  } catch (e) {
    console.log(`  [ERROR] Deposit CRUD: ${e.message}`);
  }
}

// ── Customer CRUD perspective ─────────────────────────────────────────────────
// Customer contract: /contract?action=mycontract, mydetail&id=N
// Customer bill: /bill?action=mybill, detail&id=N
// Customer service: /services (public list), services?action=request

async function captureCustomerFlows(page) {
  console.log('\n[CRUD] Customer flows');
  try {
    // Contract list
    await nav(page, '/contract?action=mycontract', 'crud-cust-01-contract-list');

    // Contract detail (id=18 found in debug)
    await page.goto(BASE_URL + '/contract?action=mydetail&id=18', { waitUntil: 'networkidle', timeout: 12000 });
    await page.waitForTimeout(800);
    await shot(page, 'crud-cust-02-contract-detail');

    // Bill list
    await nav(page, '/bill', 'crud-cust-03-bill-list');

    // Bill detail — click first
    await clickFirst(page,
      'a[href*="action=detail"], a[href*="billId"], table tbody tr:first-child td a, .table a',
      'crud-cust-04-bill-detail');

    // Service list (public)
    await nav(page, '/services', 'crud-cust-05-service-list');

    // Service request form
    const reqUrls = ['/services?action=request', '/services?action=requestService'];
    for (const url of reqUrls) {
      await page.goto(BASE_URL + url, { waitUntil: 'networkidle', timeout: 10000 });
      await page.waitForTimeout(600);
      if (!page.url().includes('auth')) {
        await shot(page, 'crud-cust-06-service-request-form');
        break;
      }
    }

    // Service history
    await nav(page, '/services?action=myHistory', 'crud-cust-07-service-history');
  } catch (e) {
    console.log(`  [ERROR] Customer flows: ${e.message}`);
  }
}

// ── Main ──────────────────────────────────────────────────────────────────────

(async () => {
  if (!fs.existsSync(OUT_DIR)) fs.mkdirSync(OUT_DIR, { recursive: true });

  const browser = await chromium.launch({ headless: true });

  // ── Admin CRUD flows ──────────────────────────────────────────────────────
  const { ctx: adminCtx, page: adminPage } = await login(browser, ADMIN_USER, ADMIN_PASS);
  console.log('[INFO] Logged in as admin:', adminPage.url());

  await captureRoomCrud(adminPage);
  await captureRoomCategoryCrud(adminPage);
  await captureContractCrud(adminPage);
  await captureBillCrud(adminPage);
  await captureUtilityCrud(adminPage);
  await captureServiceCrud(adminPage);
  await captureNotificationCrud(adminPage);
  await captureDepositCrud(adminPage);

  await adminCtx.close();

  // ── Customer flows ────────────────────────────────────────────────────────
  const { ctx: userCtx, page: userPage } = await login(browser, USER_USER, USER_PASS);
  console.log('[INFO] Logged in as customer:', userPage.url());

  await captureCustomerFlows(userPage);

  await userCtx.close();
  await browser.close();

  // Summary
  const cruds = fs.readdirSync(OUT_DIR).filter(f => f.startsWith('crud-')).sort();
  console.log(`\nDone! ${cruds.length} CRUD screenshots saved:`);
  cruds.forEach(f => console.log(`  ${f}`));
})();
