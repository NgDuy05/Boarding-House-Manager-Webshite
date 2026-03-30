/**
 * explore-website.js
 * Playwright script: khám phá toàn bộ Boarding House Management System
 * URL thực dùng query param: /servlet?action=xxx
 */

const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

const BASE = 'http://localhost:9999/House_management1';
const SS_DIR = path.join(__dirname, 'screenshots');
if (!fs.existsSync(SS_DIR)) fs.mkdirSync(SS_DIR, { recursive: true });

const data = { admin: {}, user: {}, meta: {} };

function log(tag, msg) { console.log(`[${tag}] ${msg}`); }

async function ss(page, name) {
  await page.screenshot({ path: path.join(SS_DIR, `${name}.png`), fullPage: true }).catch(() => {});
}

/** Thu thập thông tin trang hiện tại */
async function snap(page) {
  return page.evaluate(() => {
    const txt = (sel) => document.querySelector(sel)?.innerText?.trim() || '';
    const all = (sel) => Array.from(document.querySelectorAll(sel)).map(e => e.innerText.trim()).filter(Boolean);
    return {
      url: location.href,
      title: document.title,
      heading: txt('h1, h2, .card-header, .page-title') || txt('h3'),
      tableHeaders: all('table thead th'),
      rowCount: document.querySelectorAll('table tbody tr').length,
      formFields: Array.from(document.querySelectorAll('form input, form select, form textarea')).map(el => ({
        name: el.name || el.id || '',
        type: el.type || el.tagName.toLowerCase(),
        label: document.querySelector(`label[for="${el.id}"]`)?.innerText?.trim() || '',
        required: el.required,
        placeholder: el.placeholder || ''
      })).filter(f => f.name && f.name !== 'action'),
      buttons: all('button, .btn, input[type=submit]').slice(0, 15),
      alerts: all('.alert, .text-danger, .text-success, [class*="alert"]').slice(0, 5),
      links: Array.from(document.querySelectorAll('a.nav-link, .sidebar a, nav a')).map(a => ({
        text: a.innerText.trim(),
        href: a.getAttribute('href') || ''
      })).filter(a => a.text && a.href && !a.href.startsWith('#')),
      cardStats: Array.from(document.querySelectorAll('.card, .stat-card, .info-box')).slice(0, 8).map(c => c.innerText.trim().substring(0, 80))
    };
  });
}

/** Đăng nhập */
async function login(page, username, password) {
  await page.goto(`${BASE}/auth?action=login`, { waitUntil: 'networkidle', timeout: 20000 });
  await page.waitForTimeout(500);
  const info = await snap(page);
  log('LOGIN', `Page: ${info.title} | Fields: ${info.formFields.map(f=>f.name).join(', ')}`);

  // Điền form
  await page.fill('#username, input[name=username]', username).catch(async () => {
    await page.fill('input[type=text]', username).catch(() => {});
  });
  await page.fill('#password, input[name=password], input[type=password]', password).catch(() => {});
  await page.click('button[type=submit], input[type=submit], .btn-primary').catch(() => {});
  await page.waitForTimeout(2000);
  const after = await snap(page);
  log('LOGIN', `After login → ${after.url} | Title: ${after.title}`);
  return { loginPage: info, afterLogin: { url: after.url, title: after.title } };
}

// ─────────────────────────────────────────────────────────────────────────────
// ADMIN EXPLORATION
// ─────────────────────────────────────────────────────────────────────────────

async function exploreAdmin(browser) {
  log('ADMIN', '====== Bắt đầu khám phá ADMIN ======');
  const ctx = await browser.newContext({ viewport: { width: 1400, height: 900 } });
  const page = await ctx.newPage();

  // --- Trang đăng nhập ---
  const loginInfo = await login(page, 'test', '321321');
  data.admin.auth = loginInfo;
  await ss(page, '01-admin-login');

  // --- Dashboard ---
  log('ADMIN', '--- Dashboard ---');
  await page.goto(`${BASE}/dashboard`, { waitUntil: 'networkidle', timeout: 15000 });
  await page.waitForTimeout(1000);
  const dash = await snap(page);
  data.admin.dashboard = dash;
  await ss(page, '02-admin-dashboard');
  log('ADMIN', `Dashboard heading: ${dash.heading}`);
  log('ADMIN', `Sidebar links: ${JSON.stringify(dash.links.map(l => l.text))}`);
  log('ADMIN', `Stats cards: ${JSON.stringify(dash.cardStats.slice(0, 4))}`);

  // ── FINANCE ──────────────────────────────────────────────────────────────

  // --- Hóa đơn (Bills) ---
  data.admin.bills = await exploreList(page, 'ADMIN/Bills', '03-admin-bills',
    `${BASE}/bill?action=list`, `${BASE}/bill?action=create`);

  // --- Tiền đặt cọc (Deposits) ---
  data.admin.deposits = await exploreList(page, 'ADMIN/Deposits', '04-admin-deposits',
    `${BASE}/deposit?action=all`, `${BASE}/deposit?action=form`);

  // --- Bảng giá (Prices) ---
  data.admin.prices = await exploreList(page, 'ADMIN/Prices', '05-admin-prices',
    `${BASE}/price?action=categories`, `${BASE}/price?action=create`);

  // ── PROPERTIES ───────────────────────────────────────────────────────────

  // --- Phòng (Rooms) ---
  data.admin.rooms = await exploreList(page, 'ADMIN/Rooms', '06-admin-rooms',
    `${BASE}/room?action=list`, `${BASE}/room?action=create`,
    { editParam: 'edit' });

  // --- Cơ sở vật chất (Facilities) ---
  data.admin.facilities = await exploreList(page, 'ADMIN/Facilities', '07-admin-facilities',
    `${BASE}/facility?action=list`, `${BASE}/facility?action=create`);

  // --- Tiện nghi (Amenities) ---
  data.admin.amenities = await exploreList(page, 'ADMIN/Amenities', '08-admin-amenities',
    `${BASE}/amenity?action=list`, `${BASE}/amenity?action=create`);

  // --- Điện/nước/gas (Utilities) ---
  data.admin.utilities = await exploreList(page, 'ADMIN/Utilities', '09-admin-utilities',
    `${BASE}/utility?action=list`, `${BASE}/utility?action=create`);

  // ── TENANTS ───────────────────────────────────────────────────────────────

  // --- Hợp đồng (Contracts) ---
  data.admin.contracts = await exploreList(page, 'ADMIN/Contracts', '10-admin-contracts',
    `${BASE}/contract?action=list`, `${BASE}/contract?action=create`);

  // --- Khách hàng (Manage Customers) ---
  data.admin.customers = await exploreList(page, 'ADMIN/Customers', '11-admin-customers',
    `${BASE}/manage-customer?action=list`, `${BASE}/manage-customer?action=create`);

  // ── SERVICES ──────────────────────────────────────────────────────────────

  // --- Danh sách dịch vụ ---
  data.admin.services = await exploreList(page, 'ADMIN/Services', '12-admin-services',
    `${BASE}/services?action=adminList`, `${BASE}/services?action=create`);

  // --- Quản lý yêu cầu dịch vụ ---
  await page.goto(`${BASE}/services?action=manageRequests`, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const svcReq = await snap(page);
  data.admin.serviceRequests = svcReq;
  await ss(page, '13-admin-service-requests');
  log('ADMIN', `Service Requests heading: ${svcReq.heading} | rows: ${svcReq.rowCount}`);

  // ── SYSTEM ────────────────────────────────────────────────────────────────

  // --- Người dùng (Users) ---
  data.admin.users = await exploreList(page, 'ADMIN/Users', '14-admin-users',
    `${BASE}/user?action=list`, null);

  // --- Thông báo (Notifications) ---
  data.admin.notifications = await exploreList(page, 'ADMIN/Notifications', '15-admin-notifications',
    `${BASE}/notification?action=list`, `${BASE}/notification?action=create`);

  // --- Nhật ký hoạt động ---
  await page.goto(`${BASE}/activity-log`, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const actLog = await snap(page);
  data.admin.activityLog = actLog;
  await ss(page, '16-admin-activity-log');
  log('ADMIN', `Activity Log cols: ${JSON.stringify(actLog.tableHeaders)} | rows: ${actLog.rowCount}`);

  // --- Thử edit user nếu có ---
  await page.goto(`${BASE}/user?action=list`, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const editLink = await page.$('a[href*="action=edit"]');
  if (editLink) {
    const href = await editLink.getAttribute('href');
    await page.goto(href.startsWith('http') ? href : `${BASE}${href}`, { waitUntil: 'networkidle', timeout: 10000 });
    await page.waitForTimeout(700);
    const editUser = await snap(page);
    data.admin.editUser = editUser;
    await ss(page, '17-admin-edit-user');
    log('ADMIN', `Edit User form fields: ${JSON.stringify(editUser.formFields.map(f=>f.name))}`);
  }

  // --- Thử xem chi tiết phòng ---
  await page.goto(`${BASE}/room?action=list`, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const detailLink = await page.$('a[href*="action=detail"], a[href*="detail"]');
  if (detailLink) {
    await detailLink.click();
    await page.waitForTimeout(800);
    const roomDetail = await snap(page);
    data.admin.roomDetail = roomDetail;
    await ss(page, '18-admin-room-detail');
    log('ADMIN', `Room detail heading: ${roomDetail.heading}`);
  }

  // --- Xem chi tiết hợp đồng ---
  await page.goto(`${BASE}/contract?action=list`, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const contractDetail = await page.$('a[href*="detail"]');
  if (contractDetail) {
    await contractDetail.click();
    await page.waitForTimeout(800);
    const cd = await snap(page);
    data.admin.contractDetail = cd;
    await ss(page, '19-admin-contract-detail');
    log('ADMIN', `Contract detail heading: ${cd.heading}`);
  }

  // --- Xem chi tiết khách hàng ---
  await page.goto(`${BASE}/manage-customer?action=list`, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const custDetail = await page.$('a[href*="detail"]');
  if (custDetail) {
    await custDetail.click();
    await page.waitForTimeout(800);
    const ctd = await snap(page);
    data.admin.customerDetail = ctd;
    await ss(page, '20-admin-customer-detail');
    log('ADMIN', `Customer detail heading: ${ctd.heading}`);
  }

  // --- Xem bill detail ---
  await page.goto(`${BASE}/bill?action=list`, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const billDetailLink = await page.$('a[href*="detail"]');
  if (billDetailLink) {
    await billDetailLink.click();
    await page.waitForTimeout(800);
    const bd = await snap(page);
    data.admin.billDetail = bd;
    await ss(page, '21-admin-bill-detail');
    log('ADMIN', `Bill detail heading: ${bd.heading}`);
  }

  await ctx.close();
  log('ADMIN', '====== Hoàn thành khám phá ADMIN ======');
}

/** Helper: khám phá trang list + trang create */
async function exploreList(page, tag, ssPrefix, listUrl, createUrl, opts = {}) {
  const result = {};

  // List page
  await page.goto(listUrl, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const listSnap = await snap(page);
  result.list = listSnap;
  await ss(page, `${ssPrefix}-list`);
  log(tag, `List → heading: "${listSnap.heading}" | cols: ${JSON.stringify(listSnap.tableHeaders)} | rows: ${listSnap.rowCount}`);
  log(tag, `Buttons: ${JSON.stringify(listSnap.buttons.slice(0, 8))}`);

  // Create/Add page
  if (createUrl) {
    await page.goto(createUrl, { waitUntil: 'networkidle', timeout: 12000 });
    await page.waitForTimeout(700);
    const createSnap = await snap(page);
    result.create = createSnap;
    await ss(page, `${ssPrefix}-create`);
    log(tag, `Create → heading: "${createSnap.heading}" | fields: ${JSON.stringify(createSnap.formFields.map(f => `${f.label||f.name}${f.required?'*':''}(${f.type})`))}`);
  }

  // Edit (tìm link edit đầu tiên trong danh sách)
  await page.goto(listUrl, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(500);
  const editLink = await page.$('a[href*="action=edit"], .btn-warning[href], a.edit-btn');
  if (editLink) {
    const href = await editLink.getAttribute('href');
    if (href) {
      const editUrl = href.startsWith('http') ? href : `${BASE}${href}`;
      await page.goto(editUrl, { waitUntil: 'networkidle', timeout: 10000 });
      await page.waitForTimeout(700);
      const editSnap = await snap(page);
      result.edit = editSnap;
      await ss(page, `${ssPrefix}-edit`);
      log(tag, `Edit → heading: "${editSnap.heading}" | fields: ${JSON.stringify(editSnap.formFields.map(f => f.label||f.name))}`);
    }
  }

  return result;
}

// ─────────────────────────────────────────────────────────────────────────────
// USER (CUSTOMER) EXPLORATION
// ─────────────────────────────────────────────────────────────────────────────

async function exploreUser(browser) {
  log('USER', '====== Bắt đầu khám phá USER (sale) ======');
  const ctx = await browser.newContext({ viewport: { width: 1400, height: 900 } });
  const page = await ctx.newPage();

  const loginInfo = await login(page, 'sale', '321321');
  data.user.auth = loginInfo;
  await ss(page, '30-user-login');

  // --- Customer Dashboard ---
  await page.goto(`${BASE}/dashboard`, { waitUntil: 'networkidle', timeout: 15000 });
  await page.waitForTimeout(1000);
  const dash = await snap(page);
  data.user.dashboard = dash;
  await ss(page, '31-user-dashboard');
  log('USER', `Dashboard heading: ${dash.heading}`);
  log('USER', `Sidebar links: ${JSON.stringify(dash.links.map(l => l.text))}`);
  log('USER', `Cards: ${JSON.stringify(dash.cardStats.slice(0, 4))}`);

  // ── CUSTOMER PAGES ────────────────────────────────────────────────────────

  const userPages = [
    { key: 'profile',         url: `${BASE}/customer?action=profile`,        ss: '32-user-profile' },
    { key: 'mybill',          url: `${BASE}/bill?action=mybill`,              ss: '33-user-bills' },
    { key: 'mycontract',      url: `${BASE}/contract?action=mycontract`,      ss: '34-user-contracts' },
    { key: 'signContract',    url: `${BASE}/contract?action=signContract`,    ss: '35-user-sign-contract' },
    { key: 'services',        url: `${BASE}/services`,                         ss: '36-user-services' },
    { key: 'serviceHistory',  url: `${BASE}/services?action=myHistory`,       ss: '37-user-service-history' },
    { key: 'requestService',  url: `${BASE}/services?action=requestForm`,     ss: '38-user-request-service' },
    { key: 'notifications',   url: `${BASE}/notification?action=publicList`,  ss: '39-user-notifications' },
    { key: 'roomCategories',  url: `${BASE}/room?action=categories`,          ss: '40-user-room-categories' },
    { key: 'changePassword',  url: `${BASE}/auth?action=changePassword`,      ss: '41-user-change-password' },
  ];

  for (const p of userPages) {
    await page.goto(p.url, { waitUntil: 'networkidle', timeout: 12000 });
    await page.waitForTimeout(700);
    const info = await snap(page);
    const redirected = !info.url.includes(p.url.replace(BASE, '').split('?')[0]);
    data.user[p.key] = { ...info, wasRedirected: redirected };
    await ss(page, p.ss);
    log('USER', `[${p.key}] heading: "${info.heading}" | cols: ${JSON.stringify(info.tableHeaders)} | rows: ${info.rowCount} ${redirected ? '(REDIRECTED→'+info.url+')' : ''}`);
  }

  // --- Thử xem chi tiết phòng (public) ---
  await page.goto(`${BASE}/room?action=publicList`, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const rooms = await snap(page);
  data.user.roomList = rooms;
  await ss(page, '42-user-room-list');
  log('USER', `Room public list rows: ${rooms.rowCount}`);

  const roomDetailBtn = await page.$('a[href*="publicDetail"], a[href*="detail"], .card a, .btn-primary[href]');
  if (roomDetailBtn) {
    await roomDetailBtn.click();
    await page.waitForTimeout(800);
    const rd = await snap(page);
    data.user.roomDetail = rd;
    await ss(page, '43-user-room-detail');
    log('USER', `Room detail heading: ${rd.heading}`);
  }

  // --- Chi tiết hợp đồng ---
  await page.goto(`${BASE}/contract?action=mycontract`, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const contractLink = await page.$('a[href*="detail"], a[href*="mydetail"]');
  if (contractLink) {
    await contractLink.click();
    await page.waitForTimeout(800);
    const cd = await snap(page);
    data.user.contractDetail = cd;
    await ss(page, '44-user-contract-detail');
    log('USER', `Contract detail heading: ${cd.heading}`);
  }

  // --- Chi tiết hóa đơn ---
  await page.goto(`${BASE}/bill?action=mybill`, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const billLink = await page.$('a[href*="detail"]');
  if (billLink) {
    await billLink.click();
    await page.waitForTimeout(800);
    const bd = await snap(page);
    data.user.billDetail = bd;
    await ss(page, '45-user-bill-detail');
    log('USER', `Bill detail heading: ${bd.heading}`);
  }

  // --- UPDATE PROFILE thử nghiệm ---
  await page.goto(`${BASE}/customer?action=editProfile`, { waitUntil: 'networkidle', timeout: 12000 });
  await page.waitForTimeout(700);
  const editProfile = await snap(page);
  data.user.editProfile = editProfile;
  await ss(page, '46-user-edit-profile');
  log('USER', `Edit Profile fields: ${JSON.stringify(editProfile.formFields.map(f => f.label||f.name))}`);

  // --- Thử truy cập admin pages ---
  const adminAttempts = [
    { label: 'Admin Dashboard', url: `${BASE}/admin?action=dashboard` },
    { label: 'Admin Room List', url: `${BASE}/room?action=list` },
    { label: 'Admin Bills',     url: `${BASE}/bill?action=list` },
    { label: 'Admin Contracts', url: `${BASE}/contract?action=list` },
    { label: 'Admin Customers', url: `${BASE}/manage-customer?action=list` },
    { label: 'Admin Users',     url: `${BASE}/user?action=list` },
    { label: 'Activity Log',    url: `${BASE}/activity-log` },
    { label: 'Utility Prices',  url: `${BASE}/utility?action=list` },
  ];

  data.user.adminAccessAttempts = [];
  for (const a of adminAttempts) {
    await page.goto(a.url, { waitUntil: 'networkidle', timeout: 10000 });
    await page.waitForTimeout(600);
    const info = await snap(page);
    const isBlocked = info.url.includes('login') || info.url.includes('dashboard') || info.url.includes('403') || info.url.includes('error');
    const result = {
      label: a.label, requested: a.url,
      actual: info.url, heading: info.heading,
      blocked: isBlocked
    };
    data.user.adminAccessAttempts.push(result);
    log('USER', `[ACCESS TEST] ${a.label}: ${isBlocked ? 'BLOCKED' : 'ALLOWED'} → ${info.url}`);
  }

  await ctx.close();
  log('USER', '====== Hoàn thành khám phá USER ======');
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN
// ─────────────────────────────────────────────────────────────────────────────

(async () => {
  const browser = await chromium.launch({ headless: true });
  try {
    await exploreAdmin(browser);
    await exploreUser(browser);
  } catch (err) {
    log('ERROR', `Fatal: ${err.message}`);
    console.error(err.stack);
  } finally {
    await browser.close();
  }

  const out = path.join(__dirname, 'website-findings.json');
  fs.writeFileSync(out, JSON.stringify(data, null, 2));
  console.log(`\n=== Done ===`);
  console.log(`Findings: ${out}`);
  console.log(`Screenshots: ${SS_DIR}`);
})();
