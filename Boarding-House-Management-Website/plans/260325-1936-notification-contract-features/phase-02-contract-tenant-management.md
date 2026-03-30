# Phase 2: Contract Tenant Management (contract_tenant CRUD)

**Priority:** High
**Status:** Pending
**Scope:** Verify existing implementation works; fix if broken.

## Context

The contract_tenant table stores people living in a room who may NOT have system accounts. Fields: tenant_id, contract_id, full_name, phone, cccd, birth_date, is_primary.

## Current State Analysis (from codebase review)

**ContractDAO** - All methods exist and look correct:
- `getTenantsByContractId(int contractId)` - line 439
- `getTenantById(int tenantId)` - line 451
- `addContractTenant(ContractTenant t)` - line 462
- `updateContractTenant(ContractTenant t)` - line 486
- `removeContractTenant(int tenantId)` - line 512 (hard delete)

**ContractServlet** - All actions are handled:
- GET `addContractTenant` -> `showAddContractTenantForm()` - line 543
- GET `editContractTenant` -> `showEditContractTenantForm()` - line 556
- GET `removeContractTenant` -> `removeContractTenant()` - line 610
- POST `saveContractTenant` -> `saveContractTenant()` - line 570

**manageContractTenants.jsp** - 189 lines, fully functional:
- Left panel: tenant list with edit/remove buttons
- Right panel: add/edit form
- Flash messages working
- Navigation back to contract detail working

**contractDetail.jsp** - Has link to manage tenants:
- "Manage Tenants" button links to `action=addContractTenant&id=` (line 169)

## Related Code Files

**Verify (no changes expected):**
1. `src/main/java/DALs/ContractDAO.java` - tenant CRUD methods
2. `src/main/java/Controllers/ContractServlet.java` - tenant action handlers
3. `src/main/webapp/views/admin/contracts/manageContractTenants.jsp` - UI

**May need minor fix:**
4. `src/main/webapp/views/admin/contracts/contractDetail.jsp` - verify navigation link

## Implementation Steps

### Step 1: Functional verification

Test the following flow manually or review code paths:
1. Navigate to contractDetail.jsp -> click "Manage Tenants" button
2. Verify the form loads with existing tenants listed
3. Add a new tenant (full_name required, phone/cccd/birthDate optional)
4. Edit an existing tenant
5. Remove a tenant with confirmation dialog

### Step 2: Fix issues if found

Based on review, the implementation appears complete. Possible issues to check:
- Ensure `contractDetail.jsp` "Manage Tenants" link uses correct action name
  - Current: `action=addContractTenant&id=${contract.contractId}` (line 169) - correct
- Ensure `manageContractTenants.jsp` redirect after save is correct
  - Current: redirects to `action=addContractTenant&id=` (line 606 of servlet) - correct

### Step 3: Update Vietnamese labels (if needed)

Update button/form labels to Vietnamese:
- "Manage Tenants" -> "Quan ly nguoi o"
- "Add Tenant" -> "Them nguoi o"
- "Edit Tenant" -> "Sua thong tin"
- "Full Name" -> "Ho va ten"
- "Phone" -> "So dien thoai"
- "CCCD / ID" -> "CCCD"
- "Date of Birth" -> "Ngay sinh"
- "Primary renter" -> "Nguoi thue chinh"

## Todo List

- [ ] Verify contractDetail.jsp -> manageContractTenants.jsp navigation works
- [ ] Verify add tenant flow works end-to-end
- [ ] Verify edit tenant flow works end-to-end
- [ ] Verify remove tenant flow works end-to-end
- [ ] Update labels to Vietnamese if requested

## Success Criteria

- Admin can add/edit/remove contract_tenant records from manageContractTenants.jsp
- Navigation from contractDetail.jsp to tenant management works
- Primary tenant flag toggles correctly (only one primary per contract)
- Form validation works (full_name required)

## Risk Assessment

- Low risk: Implementation appears complete based on code review
- Only issue might be runtime errors (DB connection, mapping) - needs manual testing
