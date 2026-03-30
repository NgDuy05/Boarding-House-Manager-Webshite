# Phase 3: Resident History (Lich su nguoi o)

**Priority:** Medium
**Status:** Pending
**Scope:** Show tenant history in contractDetail.jsp and roomDetail.jsp

## Context

Two views need resident history:
1. **contractDetail.jsp** - Already shows tenants in "Tenant Info" tab. Rename to "Lich su nguoi o".
2. **roomDetail.jsp** - Currently has no tenant history. Add new section showing all tenants across all contracts for that room.

## Related Code Files

**Modify:**
1. `src/main/java/DALs/ContractDAO.java` - Add `getTenantHistoryByRoomId(int roomId)`
2. `src/main/java/Controllers/RoomServlet.java` - Pass tenant history to roomDetail view
3. `src/main/webapp/views/admin/rooms/roomDetail.jsp` - Add resident history section
4. `src/main/webapp/views/admin/contracts/contractDetail.jsp` - Rename "Tenant Info" tab label

## Implementation Steps

### Step 1: ContractDAO - Add getTenantHistoryByRoomId()

Add after `removeContractTenant()` method (after line 519):

```java
public List<ContractTenant> getTenantHistoryByRoomId(int roomId) {
    List<ContractTenant> list = new ArrayList<>();
    String sql = "SELECT ct.*, c.start_date AS contract_start, c.end_date AS contract_end, "
               + "c.status AS contract_status, c.contract_id "
               + "FROM contract_tenant ct "
               + "JOIN contract c ON ct.contract_id = c.contract_id "
               + "WHERE c.room_id = ? AND c.is_deleted = 0 "
               + "ORDER BY c.start_date DESC, ct.is_primary DESC";
    try (PreparedStatement st = connection.prepareStatement(sql)) {
        st.setInt(1, roomId);
        ResultSet rs = st.executeQuery();
        while (rs.next()) list.add(mapTenantWithContract(rs));
    } catch (SQLException e) { e.printStackTrace(); }
    return list;
}
```

**Note:** Need a new mapping method or extend ContractTenant model to carry contract dates. Options:
- **Option A (recommended):** Add transient fields `contractStart`, `contractEnd`, `contractStatus` to ContractTenant model
- **Option B:** Return a List of Maps (not type-safe, avoid)

Add to `ContractTenant.java`:
```java
// Transient fields for history display (not in contract_tenant table)
private LocalDate contractStart;
private LocalDate contractEnd;
private String contractStatus;
// + getters/setters
```

Add mapping method to ContractDAO:
```java
private ContractTenant mapTenantWithContract(ResultSet rs) throws SQLException {
    ContractTenant t = mapTenant(rs);
    try { t.setContractStart(rs.getDate("contract_start").toLocalDate()); } catch (Exception ignored) {}
    try { Date ed = rs.getDate("contract_end"); if (ed != null) t.setContractEnd(ed.toLocalDate()); } catch (Exception ignored) {}
    try { t.setContractStatus(rs.getString("contract_status")); } catch (Exception ignored) {}
    return t;
}
```

### Step 2: RoomServlet.showDetail() - Pass tenant history

Modify `showDetail()` method (line 300-308):

```java
private void showDetail(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    int id = Integer.parseInt(request.getParameter("id"));
    Room room = roomDAO.getRoomById(id);
    List<ContractTenant> tenantHistory = contractDAO.getTenantHistoryByRoomId(id);
    request.setAttribute("room", room);
    request.setAttribute("tenantHistory", tenantHistory);
    request.getRequestDispatcher("/views/admin/rooms/roomDetail.jsp").forward(request, response);
}
```

Add import at top of RoomServlet: `import Models.ContractTenant;` and `import java.util.List;` (List may already be imported).

### Step 3: roomDetail.jsp - Add resident history section

After the room info card and action buttons (after line 70), add:

```html
<c:if test="${not empty tenantHistory}">
    <div class="card shadow-sm border-0 mt-4" style="max-width:800px;">
        <div class="card-header bg-white fw-semibold">
            <i class="bi bi-clock-history me-2"></i>Lich su nguoi o
        </div>
        <div class="card-body p-0">
            <table class="table table-hover mb-0 align-middle">
                <thead class="table-light">
                    <tr>
                        <th>Ho ten</th><th>CCCD</th><th>SĐT</th>
                        <th>Hop dong</th><th>Thoi gian</th><th>Trang thai</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="t" items="${tenantHistory}">
                        <tr>
                            <td class="fw-semibold">${t.fullName}
                                <c:if test="${t.primary}">
                                    <span class="badge bg-primary rounded-pill ms-1" style="font-size:10px">Chinh</span>
                                </c:if>
                            </td>
                            <td class="small text-muted">${not empty t.cccd ? t.cccd : '—'}</td>
                            <td class="small text-muted">${not empty t.phone ? t.phone : '—'}</td>
                            <td><a href="...?action=detail&id=${t.contractId}">#${t.contractId}</a></td>
                            <td class="small">${t.contractStart} - ${not empty t.contractEnd ? t.contractEnd : 'now'}</td>
                            <td><span class="badge ...">${t.contractStatus}</span></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</c:if>
```

### Step 4: contractDetail.jsp - Rename tab label

Change the "Tenant Info" tab button text (line 112-115):
- From: `<i class="bi bi-person-vcard me-1"></i>Tenant Info`
- To: `<i class="bi bi-clock-history me-1"></i>Lich su nguoi o`

## Todo List

- [ ] Add transient fields to ContractTenant model (contractStart, contractEnd, contractStatus)
- [ ] Add `getTenantHistoryByRoomId()` to ContractDAO
- [ ] Add `mapTenantWithContract()` to ContractDAO
- [ ] Update RoomServlet.showDetail() to pass tenantHistory
- [ ] Add resident history table to admin roomDetail.jsp
- [ ] Rename "Tenant Info" tab in contractDetail.jsp to "Lich su nguoi o"

## Success Criteria

- roomDetail.jsp shows all tenants across all contracts for that room
- Each history row shows tenant name, CCCD, phone, contract ID (linked), date range, status
- contractDetail.jsp "Tenant Info" tab renamed to "Lich su nguoi o"
- Empty state handled (no history section shown if no tenants)

## Risk Assessment

- Medium: New DAO method + model changes need testing
- SQL JOIN is straightforward - uses existing indexed columns
- ContractTenant model changes are additive (new fields only) - no breaking changes
