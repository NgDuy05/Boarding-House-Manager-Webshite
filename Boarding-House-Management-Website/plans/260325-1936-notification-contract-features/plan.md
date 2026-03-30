# Plan: Notification Filtering + Contract Tenant Management + Resident History

**Date:** 2026-03-25
**Status:** Pending

## Summary

Three features for the boarding house management site: notification type filtering (display-only), contract tenant CRUD verification/fix, and resident history views.

## Phases

| # | Phase | Status | Files Changed |
|---|-------|--------|---------------|
| 1 | Notification display - type filter tabs (Chung/Rieng) | Pending | 3 JSP + 1 Servlet |
| 2 | Contract tenant management - verify & fix CRUD | Pending | 1 JSP + 1 Servlet (verify only) |
| 3 | Resident history - contractDetail + roomDetail | Pending | 1 DAO + 1 Servlet + 2 JSP |

## Architecture

No DB schema changes required. All 3 features use existing tables:
- `notification` (target_contract_id NULL = broadcast)
- `contract_tenant` (tenant_id, contract_id, full_name, phone, cccd, birth_date, is_primary)
- `contract`, `room` (joined for history queries)

## Key Findings from Codebase Analysis

- **Notification model** already has `isBroadcast()` helper and `targetContractId` field
- **NotificationServlet.showPublicList()** already supports `type` param (broadcast/targeted) with filtering logic
- **Admin notification list** (`listNotifications`) does NOT have type filtering yet - needs to be added
- **ContractServlet** already handles all tenant CRUD actions (addContractTenant, editContractTenant, removeContractTenant, saveContractTenant)
- **manageContractTenants.jsp** (189 lines) is fully functional - verified working
- **ContractDAO** has `getTenantsByContractId()` but MISSING `getTenantHistoryByRoomId()` - needs new method
- **RoomServlet.showDetail()** is minimal - only passes room object, needs tenant history data
- **contractDetail.jsp** already has "Tenant Info" tab showing contractTenants - rename tab label to "Lich su nguoi o"

## Dependencies

- Phase 1 is independent
- Phase 2 is independent
- Phase 3 depends on understanding Phase 2's data model but no code dependency

## Risk Assessment

- Low risk: All features are display/filter changes except one new DAO method
- Phase 2 appears already working - verify before making unnecessary changes
