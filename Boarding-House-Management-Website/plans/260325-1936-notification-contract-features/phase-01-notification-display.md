# Phase 1: Notification Display - Type Filter (Chung/Rieng)

**Priority:** High
**Status:** Pending
**Scope:** Display-only. No DB/model changes needed.

## Context

- `target_contract_id IS NULL` = Thong bao chung (broadcast)
- `target_contract_id IS NOT NULL` = Thong bao rieng (private/targeted)
- Notification model already has `isBroadcast()` method
- Customer JSP already has working filter tabs (All/Broadcast/For Me)

## Related Code Files

**Modify:**
1. `src/main/java/Controllers/NotificationServlet.java` - Add type filter to admin `listNotifications()`
2. `src/main/webapp/views/admin/notifications/notifications.jsp` - Add filter tabs
3. `src/main/webapp/views/customer/notifications.jsp` - Update tab labels to Vietnamese
4. `src/main/webapp/views/admin/notifications/createNotification.jsp` - Improve label text

## Implementation Steps

### Step 1: NotificationServlet - Add type filter to admin list (lines 163-185)

In `listNotifications()`, after fetching the list, add type filtering logic (same as `showPublicList`):

```java
// After line 179 (list = notificationDAO.getAllNotifications())
// Add type filter
String typeFilter = request.getParameter("type");
if ("broadcast".equals(typeFilter)) {
    list.removeIf(n -> !n.isBroadcast());
} else if ("targeted".equals(typeFilter)) {
    list.removeIf(Notification::isBroadcast);
}
request.setAttribute("typeFilter", typeFilter != null ? typeFilter : "");
```

### Step 2: Admin notifications.jsp - Add filter tabs

After the search form (line 29), before the card, add:

```html
<ul class="nav nav-pills mb-3">
  <li class="nav-item">
    <a href="...?action=list" class="nav-link ${empty typeFilter ? 'active' : ''}">Tat ca</a>
  </li>
  <li class="nav-item">
    <a href="...?action=list&type=broadcast" class="nav-link ${typeFilter == 'broadcast' ? 'active' : ''}">Chung</a>
  </li>
  <li class="nav-item">
    <a href="...?action=list&type=targeted" class="nav-link ${typeFilter == 'targeted' ? 'active' : ''}">Rieng</a>
  </li>
</ul>
```

### Step 3: Customer notifications.jsp - Update tab labels to Vietnamese

Change existing filter bar labels (lines 135-150):
- "All" -> "Tat ca"
- "Broadcast" -> "Thong bao chung"
- "For Me" -> "Thong bao rieng"

### Step 4: createNotification.jsp - Improve label text

Update the target contract field label (line 31):
- Current: "Target Contract ID (leave blank to broadcast to all)"
- New: "Gui rieng cho hop dong (de trong = gui chung cho tat ca)"

## Todo List

- [ ] Add type filter logic to `NotificationServlet.listNotifications()`
- [ ] Add filter tabs to admin `notifications.jsp`
- [ ] Update customer `notifications.jsp` tab labels to Vietnamese
- [ ] Update `createNotification.jsp` label text
- [ ] Verify filter works with existing search/keyword filter

## Success Criteria

- Admin can filter notifications by Tat ca / Chung / Rieng
- Customer sees Vietnamese labels: Thong bao chung / Thong bao rieng
- Create form clearly labels broadcast vs targeted
- Existing search functionality still works alongside type filter
