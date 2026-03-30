# Code Review: Unified Room Categories + Room List Page

**Date:** 2026-03-21
**Reviewer:** code-reviewer
**Scope:** 3 files changed for the "Unified Room Categories + Room List Page" feature

Files reviewed:
- `src/main/java/Controllers/RoomServlet.java` (lines 101-114)
- `src/main/webapp/views/customer/roomCategories.jsp` (full rewrite)
- `src/main/webapp/views/navbar.jsp` (minor change)

---

## Summary

The implementation is functionally sound and the core client-side filter engine works correctly. The majority of the review findings are **low-severity**, with one **medium-severity XSS vector** in the JSP-to-JSON embedding block and two **logic gaps** that affect UX consistency.

---

## Findings

### [MEDIUM] XSS: Unescaped string fields in the JSON embedding block

**File:** `roomCategories.jsp`, lines 350-361

**Problem:** Several Room string fields are interpolated directly into the JS literal using JSP EL/JSTL without proper escaping:

```jsp
roomNumber: "${room.roomNumber}",
status:     "${room.status}",
image:      "${not empty room.image ? room.image : ''}",
categoryName: "<c:out value='${room.categoryName}' escapeXml='false'/>",
```

- `room.roomNumber`, `room.status`, and `room.image` use plain EL `"${...}"` inside a JS double-quoted string. If any of these values contain a `"` character or a `\`, they can break out of the JS string, causing either a syntax error or script injection.
- `categoryName` uses `<c:out escapeXml='false'/>`, which explicitly disables XML escaping. While `categoryName` comes from an admin-controlled database field, `escapeXml='false'` means a value like `Deluxe"});alert(1)//` would inject arbitrary JS. It also makes the intent confusing to future maintainers.

**Expected:** All string fields embedded into a JS string literal must be JavaScript-escaped (backslash-escape `\`, `"`, `'`, `/`, newlines, carriage returns). XML/HTML escaping (`&quot;`) is NOT the right escape for a JS string context. The standard patterns are:
- Replace `\` with `\\`, `"` with `\"`, newline with `\n`, carriage return with `\r`.
- Or use a JSON serializer (e.g., Jackson via a servlet attribute, then `${roomsJson}` verbatim).

**Concrete risk:** `room.image` is user-supplied data written via the admin `insertRoom` form — no sanitisation is applied in `insertRoom()`. If an admin enters `"; alert(1); //` as an image path, it injects into the page JS for all public visitors.

**Recommendation:** Either:
1. Serialize `allRooms` to JSON in the servlet using Jackson/Gson and pass it as a single pre-serialised string attribute, then emit it as `var allRooms = ${allRoomsJson};` — zero escaping risk.
2. Or add a JSTL custom EL function / use `fn:replace` chains to escape `\` and `"` before embedding each field.

---

### [LOW] `escapeXml='false'` on categoryName contradicts the XSS-safety intent

**File:** `roomCategories.jsp`, line 357

```jsp
categoryName: "<c:out value='${room.categoryName}' escapeXml='false'/>",
```

The comment in the feature description states "`c:out escapeXml` used for categoryName in JSON embedding" as a safety measure. But `escapeXml='false'` disables that protection. The intent was clearly to escape — the attribute value should be `escapeXml='true'` (which is also the default). However, note that even with `escapeXml='true'`, HTML entities like `&amp;` are incorrect inside a JS string; the correct fix is JS-level escaping, not XML escaping (see finding above).

---

### [LOW] `setStatus('')` toggle asymmetry — "All" pill never clears via double-click

**File:** `roomCategories.jsp`, `setStatus()` function, lines 372-379

```js
function setStatus(status) {
    if (activeStatus === status) {
        activeStatus = '';
    } else {
        activeStatus = status;
    }
    applyFilters();
}
```

The "All" status pill calls `setStatus('')`. When `activeStatus` is already `''`, clicking "All" computes `'' === ''` → true → sets `activeStatus = ''` (no-op, correct). That part is fine.

The asymmetry is: clicking "Available" once sets `activeStatus = 'available'`; clicking it again clears to `''`. But the stats chips (`onclick="setStatus('available')"`) have the same toggle, meaning clicking the same chip twice acts as an unexpected toggle-off. This is the stated design intent, so it is not a bug, but the "All" pill in the status filter bar would **never** visually un-highlight on a second click — it already is `active` when `activeStatus === ''`, and double-clicking it does nothing visible. Acceptable but worth noting.

---

### [LOW] `setCategory()` from pill bar does not toggle (unlike `selectCategoryCard()`)

**File:** `roomCategories.jsp`, lines 367-370

```js
function setCategory(catId) {
    activeCategoryId = catId;
    applyFilters();
}
```

`selectCategoryCard()` (line 389) implements toggle behaviour: clicking the same card twice clears the filter. `setCategory()` does not — clicking the same pill twice keeps the filter active. This creates an inconsistency: the card and the pill for the same category behave differently on a second click. If the intent was symmetry, `setCategory` should mirror the toggle pattern.

---

### [LOW] `status-badge` class applied with unsanitised `r.status` value

**File:** `roomCategories.jsp`, `renderRooms()`, line 450

```js
<span class="status-badge status-${r.status}">${statusLabel}</span>
```

`r.status` is interpolated directly into a class attribute using a JS template literal (not `escHtml`). If `r.status` ever contains a space or `"`, it would break the class string or the HTML structure. Since `status` is an enum-like DB column (`available`/`occupied`/`maintenance`), this is unlikely to cause issues in practice. However, for defensive consistency, `escHtml(r.status)` should be applied here. `statusLabel` uses `charAt(0).toUpperCase() + slice(1)` and is text-node content injected with `${}` (innerHTML), which is safe since `r.status` values have no HTML-special characters.

---

### [LOW] `updateResultsInfo()` calls `allRooms.find()` on the full dataset to get category name

**File:** `roomCategories.jsp`, lines 466-469

```js
const cat = allRooms.find(r => r.categoryId === activeCategoryId);
if (cat) label += ` in <strong>${escHtml(cat.categoryName)}</strong>`;
```

This works correctly. However, if a category has zero rooms (all filtered out), `allRooms.find()` returns `undefined` and no category label is shown — silently. For a category that genuinely has rooms, this always finds a match. Edge case: if the category filter is active but the category has 0 rooms (possible if `roomCount` on the category card shows 0), the results info would not show the category name. This is a minor cosmetic gap, not a data-correctness issue.

A more robust approach: build a `categoryMap` from the server-rendered `categories` list (already present in the DOM as pill buttons with `data-cat` and text content) at init time, rather than deriving category name from a room that may not exist.

---

### [LOW] `roomNumber` and `image` path not JS-escaped in `imgTag` / alt attribute

**File:** `roomCategories.jsp`, `renderRooms()`, lines 439-441

```js
const imgTag = imgSrc
    ? `<img src="${imgSrc}" alt="Room ${escHtml(r.roomNumber)}"
           onerror="...">`
    : '';
```

`imgSrc` is built as `` `${CTX}/assets/images/room/${r.image}` `` without escaping. If `r.image` contains `"`, the `src` attribute would be broken (though not injectable since the template literal is inside a JS string, the `"` would close the HTML attribute in the resulting innerHTML). `escHtml(r.image)` should be used when constructing `imgSrc`.

---

### [LOW] `occupied` status: both "View Details" and "Book Now" buttons shown

**File:** `roomCategories.jsp`, `renderRooms()`, lines 433-437

```js
const bookBtn = r.status === 'maintenance'
    ? `<a ... class="btn-detail">View Details</a>
       <span class="btn-book disabled">Unavailable</span>`
    : `<a ... class="btn-detail">View Details</a>
       <a ... class="btn-book">Book Now</a>`;
```

The ternary treats `available` and `occupied` identically — both show a live "Book Now" button. The server-side `rooms.jsp` (line 338) does the same: `room.status == 'maintenance' ? 'disabled' : 'Book Now!'`. So this matches existing behaviour and is consistent with the old page. However, showing "Book Now" on an `occupied` room is semantically misleading. The booking page itself would reject the request, so this is a UX concern rather than a bug. The `rooms.jsp` pattern and the `roomDetail.jsp` presumably handle this downstream.

---

### [INFO] `showPublicList` action still exists and is reachable

**File:** `RoomServlet.java`, lines 51-53 and `navbar.jsp` line 58

The "Available Rooms" dropdown item in the navbar still links to `room?action=publicList&status=available`, which hits `showPublicList()` → forwards to `rooms.jsp`. This is intentional backward compat. However:
- The `rooms.jsp` page is now a secondary path, not removed.
- The navbar still exposes this link (one entry under the Rooms dropdown).
- `showPublicList` still does server-side pagination, which differs from the unified page's client-side-only approach.

No bug here, but this creates two divergent filter UIs for the same data. If the intent is full unification, the "Available Rooms" link should eventually redirect to `room?action=categories` with a pre-selected status (e.g., via a query param that the categories JS reads on load). For now, it is documented as backward compat.

---

### [INFO] Servlet: no error handling if `roomDAO.getAllRooms()` returns null

**File:** `RoomServlet.java`, line 106

`RoomDAO.getAllRooms()` always returns a non-null `ArrayList` (initialised before the try block), so this is safe. No action needed.

---

### [INFO] `statusCounts` may show `null` in JSP if a status key is absent from DB

**File:** `roomCategories.jsp`, lines 209, 215, 221

```jsp
<div class="chip-num">${statusCounts['available']}</div>
```

`RoomDAO.getCountByStatus()` pre-seeds the map with `0` for all three keys, so this always outputs a number. Safe.

---

### [INFO] Bootstrap JS loaded after the custom `<script>` block

**File:** `roomCategories.jsp`, line 519

```html
<script src="...bootstrap.bundle.min.js"></script>
```

The custom script block (lines 346-517) runs on `DOMContentLoaded`, which fires before Bootstrap JS is evaluated. This is fine since the custom code does not depend on Bootstrap JS at init time. No issue.

---

### [INFO] Navbar: "Available Rooms" still links to old `publicList`

**File:** `navbar.jsp`, line 58

```html
<a ... href=".../room?action=publicList&status=available">Available Rooms</a>
```

Per the feature scope, this is intentional. Noted for completeness.

---

## Positive Observations

- `escHtml()` is correctly applied in all `innerHTML` injection points for `r.roomNumber` and `r.categoryName` (the text-content paths).
- `formatNum()` using `toLocaleString('vi-VN')` is appropriate for the Vietnamese locale.
- Filter logic in `applyFilters()` correctly ANDs category and status conditions.
- `selectCategoryCard()` toggle (second click clears) is correctly implemented.
- `updateActiveButtons()` correctly syncs all four UI elements (pill bars, cards, chips) on every filter change.
- `resetFilters()` resets both dimensions and re-renders.
- Servlet `showCategories()` correctly calls `getAllCategoriesWithCount()` (returns `roomCount`) so pill counts are accurate.
- `rooms.jsp` and `roomDetail.jsp` are untouched — backward compat maintained.
- No DAOs, Models, or web.xml changes — minimal footprint.
- Soft-delete filter (`is_deleted = 0`) is consistent throughout the DAO.
- The `basePrice` null → `BigDecimal.ZERO` guard in `mapRoom()` means `r.basePrice` is always a number in JS (never `null`).

---

## Action Items (Priority Order)

| # | Severity | File | Action |
|---|----------|------|--------|
| 1 | MEDIUM | roomCategories.jsp L350-361 | JS-escape all string fields in the JSON embedding block, or serialize via Jackson/Gson in the servlet |
| 2 | LOW | roomCategories.jsp L357 | Change `escapeXml='false'` to `escapeXml='true'` (or remove attribute, true is default) — then fix via item 1 |
| 3 | LOW | roomCategories.jsp L450 | Apply `escHtml(r.status)` when building the status-badge class string |
| 4 | LOW | roomCategories.jsp L425 | Apply `escHtml(r.image)` when building `imgSrc` for the `src` attribute |
| 5 | LOW | roomCategories.jsp `setCategory()` | Decide if pill-bar category filter should also toggle on second click (match card behaviour) |
| 6 | LOW | roomCategories.jsp `updateResultsInfo()` | Build a `categoryMap` from DOM/categories data at init to avoid `allRooms.find()` failing for empty categories |

---

## Unresolved Questions

1. Is the "Available Rooms" navbar link intentionally kept pointing to `publicList` long-term, or is the plan to eventually redirect it into the unified page with a pre-selected status filter on load?
2. Should `occupied` rooms show a disabled "Book Now" button (matching `maintenance` behaviour) or is the intent to let customers navigate to the detail page and get rejected there?
3. Is `room.image` admin-only input (no public-facing upload)? If yes, the XSS risk for item 1 is admin-only, downgrading practical severity. Clarify for risk assessment.
