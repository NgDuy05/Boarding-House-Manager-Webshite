package Controllers;

import DALs.BillDAO;
import DALs.ContractDAO;
import DALs.FacilityDAO;
import DALs.RoomDAO;
import DALs.UserDAO;
import Models.Bill;
import Models.Contract;
import Models.ContractTenant;
import Models.ContractUser;
import Models.Facility;
import Models.Room;
import Models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

public class ContractServlet extends HttpServlet {

    private ContractDAO contractDAO;
    private RoomDAO     roomDAO;
    private UserDAO     userDAO;
    private BillDAO     billDAO;
    private FacilityDAO facilityDAO;

    private static final int PAGE_SIZE = 10;

    @Override
    public void init() {
        contractDAO = new ContractDAO();
        roomDAO     = new RoomDAO();
        userDAO     = new UserDAO();
        billDAO     = new BillDAO();
        facilityDAO = new FacilityDAO();
    }

    // =====================================================================
    // GET
    // =====================================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = isAdminOrStaff(request) ? "list" : "mycontract";
        }

        switch (action) {

            // ── ADMIN ──────────────────────────────────────────────────────
            case "list":
                listContracts(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            case "terminate":
                terminateContract(request, response);
                break;
            case "delete":
                deleteContract(request, response);
                break;
            case "addTenant":
                showAddTenantForm(request, response);
                break;
            case "removeTenant":
                removeTenant(request, response);
                break;

            // ── CONTRACT_TENANT (non-account tenants) ──────────────────────
            case "addContractTenant":
                showAddContractTenantForm(request, response);
                break;
            case "editContractTenant":
                showEditContractTenantForm(request, response);
                break;
            case "removeContractTenant":
                removeContractTenant(request, response);
                break;

            // ── CUSTOMER ──────────────────────────────────────────────────
            case "mycontract":
                myContracts(request, response);
                break;
            case "mydetail":
                myContractDetail(request, response);
                break;
            case "signContract":
                showSignContractForm(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/contract?action=list");
        }
    }

    // =====================================================================
    // POST
    // =====================================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "insert":
                insertContract(request, response);
                break;
            case "customerSign":
                customerSignContract(request, response);
                break;
            case "update":
                updateContract(request, response);
                break;
            case "addTenant":
                addTenant(request, response);
                break;
            // ── CONTRACT_TENANT (non-account tenants) ──────────────────────
            case "saveContractTenant":
                saveContractTenant(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/contract?action=list");
        }
    }

    // =====================================================================
    // ADMIN – LIST
    // =====================================================================
    private void listContracts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }

        String statusFilter = request.getParameter("status");
        String search       = request.getParameter("search");

        List<Contract> all = contractDAO.getAllWithDetails(statusFilter, search);

        // stats
        long activeCount     = all.stream().filter(c -> "active".equals(c.getStatus())).count();
        long terminatedCount = all.stream().filter(c -> "terminated".equals(c.getStatus())).count();

        // pagination
        int totalItems = all.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));
        int page = parsePage(request.getParameter("page"), totalPages);

        int from = (page - 1) * PAGE_SIZE;
        int to   = Math.min(from + PAGE_SIZE, totalItems);
        List<Contract> contracts = (from < totalItems) ? all.subList(from, to) : java.util.Collections.emptyList();

        request.setAttribute("contracts",       contracts);
        request.setAttribute("activeCount",     activeCount);
        request.setAttribute("terminatedCount", terminatedCount);
        request.setAttribute("totalItems",      totalItems);
        request.setAttribute("totalPages",      totalPages);
        request.setAttribute("currentPage",     page);
        request.setAttribute("pageSize",        PAGE_SIZE);
        request.setAttribute("statusFilter",    statusFilter);
        request.setAttribute("search",          search);

        forward(request, response, "/views/admin/contracts/contracts.jsp");
    }

    // =====================================================================
    // ADMIN – CREATE
    // =====================================================================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }

        List<Room> availableRooms = roomDAO.getByStatus("available");
        List<User> customers      = userDAO.getAllCustomers(null, "active");
        List<Facility> facilities = facilityDAO.getAllFacilities();

        request.setAttribute("availableRooms",       availableRooms);
        request.setAttribute("customers",            customers);
        request.setAttribute("facilities",           facilities);
        request.setAttribute("activeContractUserIds", contractDAO.getActiveContractUserIds());
        forward(request, response, "/views/admin/contracts/createContract.jsp");
    }

    private void insertContract(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }

        try {
            int        roomId    = Integer.parseInt(request.getParameter("roomId"));
            LocalDate  startDate = LocalDate.parse(request.getParameter("startDate"));
            String     endStr    = request.getParameter("endDate");
            LocalDate  endDate   = (endStr == null || endStr.isEmpty()) ? null : LocalDate.parse(endStr);
            BigDecimal deposit   = new BigDecimal(request.getParameter("deposit").replaceAll(",", ""));
            int        userId    = Integer.parseInt(request.getParameter("primaryUserId"));

            Contract c = new Contract(0, roomId, startDate, endDate, deposit, "active", false);
            int newId = contractDAO.insertWithTenant(c, userId);

            // Also create a contract_tenant record from the form fields if provided
            String tenantName = request.getParameter("tenantName");
            if (newId > 0 && tenantName != null && !tenantName.trim().isEmpty()) {
                ContractTenant ct = new ContractTenant();
                ct.setContractId(newId);
                ct.setFullName(tenantName.trim());
                ct.setPhone(request.getParameter("tenantPhone"));
                ct.setCccd(request.getParameter("tenantCccd"));
                String bdStr = request.getParameter("tenantBirthDate");
                if (bdStr != null && !bdStr.isEmpty()) ct.setBirthDate(LocalDate.parse(bdStr));
                ct.setPrimary(true);
                contractDAO.addContractTenant(ct);
            }

            if (newId > 0) {
                // Save selected facilities to room_facility
                String[] facilityIds  = request.getParameterValues("facilityId");
                String[] facilityQtys = request.getParameterValues("facilityQty");
                if (facilityIds != null) {
                    facilityDAO.softDeleteRoomFacilities(roomId);
                    for (int i = 0; i < facilityIds.length; i++) {
                        try {
                            int fid = Integer.parseInt(facilityIds[i]);
                            int qty = (facilityQtys != null && i < facilityQtys.length)
                                    ? Math.max(1, Integer.parseInt(facilityQtys[i]))
                                    : 1;
                            facilityDAO.upsertRoomFacility(roomId, fid, qty);
                        } catch (NumberFormatException ignored) {}
                    }
                }
                flash(request, "contractSuccess", "Contract #" + newId + " created successfully!");
                response.sendRedirect(request.getContextPath() + "/contract?action=list");
            } else {
                // Insert failed — stay on create form, preserve input
                forwardBackToCreate(request, response, "Failed to create contract. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            forwardBackToCreate(request, response, "Invalid input: " + e.getMessage());
        }
    }

    /** Re-load create form with error message and original request params preserved as attributes */
    private void forwardBackToCreate(HttpServletRequest request, HttpServletResponse response,
                                     String errorMsg) throws ServletException, IOException {
        request.setAttribute("contractError", errorMsg);
        // Re-populate dropdowns
        request.setAttribute("availableRooms",       roomDAO.getByStatus("available"));
        request.setAttribute("customers",            userDAO.getAllCustomers(null, "active"));
        request.setAttribute("facilities",           facilityDAO.getAllFacilities());
        request.setAttribute("activeContractUserIds", contractDAO.getActiveContractUserIds());
        // Preserve submitted values so JSP can re-select them
        request.setAttribute("formRoomId",       request.getParameter("roomId"));
        request.setAttribute("formUserId",       request.getParameter("primaryUserId"));
        request.setAttribute("formStartDate",    request.getParameter("startDate"));
        request.setAttribute("formEndDate",      request.getParameter("endDate"));
        request.setAttribute("formDeposit",      request.getParameter("deposit"));
        request.setAttribute("formTenantName",   request.getParameter("tenantName"));
        request.setAttribute("formTenantPhone",  request.getParameter("tenantPhone"));
        request.setAttribute("formTenantCccd",   request.getParameter("tenantCccd"));
        request.setAttribute("formTenantBd",     request.getParameter("tenantBirthDate"));
        forward(request, response, "/views/admin/contracts/createContract.jsp");
    }

    // =====================================================================
    // CUSTOMER – SIGN CONTRACT (POST)
    // =====================================================================
    private void customerSignContract(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = currentUser(request);
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth?action=login"); return; }

        // One active contract per person at a time
        if (contractDAO.hasActiveContract(user.getUserId())) {
            flash(request, "contractError",
                    "You already have an active contract. Please terminate your current contract before signing a new one.");
            response.sendRedirect(request.getContextPath() + "/contract?action=mycontract");
            return;
        }

        try {
            int        roomId    = Integer.parseInt(request.getParameter("roomId"));
            LocalDate  startDate = LocalDate.parse(request.getParameter("startDate"));
            String     endStr    = request.getParameter("endDate");
            LocalDate  endDate   = (endStr == null || endStr.isEmpty()) ? null : LocalDate.parse(endStr);
            BigDecimal deposit   = new BigDecimal(request.getParameter("deposit").replaceAll(",", ""));

            Contract c = new Contract(0, roomId, startDate, endDate, deposit, "active", false);
            int newId = contractDAO.insertWithTenant(c, user.getUserId());

            if (newId > 0) {
                flash(request, "contractSuccess", "Contract signed! Your contract #" + newId + " is now active.");
                response.sendRedirect(request.getContextPath() + "/contract?action=mydetail&id=" + newId);
            } else {
                flash(request, "contractError", "Could not sign contract. The room may no longer be available.");
                response.sendRedirect(request.getContextPath() + "/contract?action=signContract&roomId=" + roomId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            flash(request, "contractError", "Invalid input: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/contract?action=signContract");
        }
    }

    // =====================================================================
    // ADMIN – EDIT
    // =====================================================================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }

        int id = Integer.parseInt(request.getParameter("id"));
        Contract c = contractDAO.getDetailById(id);
        if (c == null) { response.sendRedirect(request.getContextPath() + "/contract?action=list"); return; }

        request.setAttribute("contract", c);
        forward(request, response, "/views/admin/contracts/editContract.jsp");
    }

    private void updateContract(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }

        try {
            int        contractId = Integer.parseInt(request.getParameter("contractId"));
            int        roomId     = Integer.parseInt(request.getParameter("roomId"));
            LocalDate  startDate  = LocalDate.parse(request.getParameter("startDate"));
            String     endStr     = request.getParameter("endDate");
            LocalDate  endDate    = (endStr == null || endStr.isEmpty()) ? null : LocalDate.parse(endStr);
            BigDecimal deposit    = new BigDecimal(request.getParameter("deposit").replaceAll(",", ""));
            String     status     = request.getParameter("status");

            Contract c = new Contract(contractId, roomId, startDate, endDate, deposit, status, false);
            contractDAO.update(c);
            flash(request, "contractSuccess", "Contract updated successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            flash(request, "contractError", "Update failed: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/contract?action=list");
    }

    // =====================================================================
    // ADMIN – DETAIL
    // =====================================================================
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }

        int id = Integer.parseInt(request.getParameter("id"));
        Contract c = contractDAO.getDetailById(id);
        if (c == null) { response.sendRedirect(request.getContextPath() + "/contract?action=list"); return; }

        List<ContractUser> tenants = contractDAO.getTenantsWithInfo(id);
        List<Bill>         bills   = billDAO.getBillsByContractId(id);
        List<User>         customers = userDAO.getAllCustomers(null, "active");
        List<ContractTenant> contractTenants = contractDAO.getTenantsByContractId(id);

        request.setAttribute("contract",        c);
        request.setAttribute("tenants",         tenants);
        request.setAttribute("bills",           bills);
        request.setAttribute("customers",       customers);
        request.setAttribute("contractTenants", contractTenants);
        forward(request, response, "/views/admin/contracts/contractDetail.jsp");
    }

    // =====================================================================
    // ADMIN – TERMINATE
    // =====================================================================
    private void terminateContract(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }

        int contractId = Integer.parseInt(request.getParameter("id"));
        int roomId     = Integer.parseInt(request.getParameter("roomId"));
        contractDAO.terminate(contractId, roomId);
        flash(request, "contractSuccess", "Contract #" + contractId + " has been terminated.");
        response.sendRedirect(request.getContextPath() + "/contract?action=list");
    }

    // =====================================================================
    // ADMIN – DELETE
    // =====================================================================
    private void deleteContract(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }

        int id = Integer.parseInt(request.getParameter("id"));
        contractDAO.delete(id);
        flash(request, "contractSuccess", "Contract deleted.");
        response.sendRedirect(request.getContextPath() + "/contract?action=list");
    }

    // =====================================================================
    // ADMIN – CO-TENANTS
    // =====================================================================
    private void showAddTenantForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }

        int id = Integer.parseInt(request.getParameter("id"));
        Contract c = contractDAO.getDetailById(id);
        List<ContractUser> tenants   = contractDAO.getTenantsWithInfo(id);
        List<User>         customers = userDAO.getAllCustomers(null, "active");

        request.setAttribute("contract",  c);
        request.setAttribute("tenants",   tenants);
        request.setAttribute("customers", customers);
        forward(request, response, "/views/admin/contracts/manageTenants.jsp");
    }

    private void addTenant(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }

        try {
            int       contractId = Integer.parseInt(request.getParameter("contractId"));
            int       userId     = Integer.parseInt(request.getParameter("userId"));
            String    role       = request.getParameter("role");
            String    joinedStr  = request.getParameter("joinedAt");
            LocalDate joinedAt   = (joinedStr == null || joinedStr.isEmpty()) ? LocalDate.now() : LocalDate.parse(joinedStr);

            // One active contract per person at a time
            if (contractDAO.hasActiveContract(userId)) {
                flash(request, "contractError",
                        "This person already has an active contract. They must leave their current contract first.");
                response.sendRedirect(request.getContextPath() + "/contract?action=addTenant&id=" + contractId);
                return;
            }

            boolean ok = contractDAO.addTenant(contractId, userId, role, joinedAt);
            if (ok) {
                flash(request, "contractSuccess", "Tenant added successfully!");
            } else {
                flash(request, "contractError", "Tenant already exists in this contract.");
            }
            response.sendRedirect(request.getContextPath() + "/contract?action=addTenant&id=" + contractId);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/contract?action=list");
        }
    }

    private void removeTenant(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }

        int contractId = Integer.parseInt(request.getParameter("contractId"));
        int userId     = Integer.parseInt(request.getParameter("userId"));
        contractDAO.removeTenant(contractId, userId);
        flash(request, "contractSuccess", "Tenant removed from contract.");
        response.sendRedirect(request.getContextPath() + "/contract?action=addTenant&id=" + contractId);
    }

    // =====================================================================
    // CUSTOMER – MY CONTRACTS
    // =====================================================================
    private void myContracts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = currentUser(request);
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth?action=login"); return; }

        List<Contract> contracts = contractDAO.getContractsByUserId(user.getUserId());
        request.setAttribute("contracts", contracts);
        forward(request, response, "/views/customer/contracts.jsp");
    }

    // =====================================================================
    // CUSTOMER – MY CONTRACT DETAIL
    // =====================================================================
    private void myContractDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = currentUser(request);
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth?action=login"); return; }

        int id = Integer.parseInt(request.getParameter("id"));
        Contract c = contractDAO.getDetailById(id);

        // Security: verify this user belongs to this contract
        List<ContractUser> tenants = contractDAO.getTenantsWithInfo(id);
        boolean belongs = tenants.stream().anyMatch(t -> t.getUserId() == user.getUserId());
        if (c == null || !belongs) {
            response.sendRedirect(request.getContextPath() + "/contract?action=mycontract");
            return;
        }

        List<Bill> bills = billDAO.getBillsByContractId(id);
        List<ContractTenant> contractTenants = contractDAO.getTenantsByContractId(id);
        request.setAttribute("contract",        c);
        request.setAttribute("tenants",         tenants);
        request.setAttribute("bills",           bills);
        request.setAttribute("contractTenants", contractTenants);
        forward(request, response, "/views/customer/contractDetail.jsp");
    }

    // =====================================================================
    // CUSTOMER – SIGN CONTRACT (browse available rooms → select → sign)
    // =====================================================================
    private void showSignContractForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = currentUser(request);
        if (user == null) { response.sendRedirect(request.getContextPath() + "/auth?action=login"); return; }

        // Pass active-contract flag so JSP can warn/block
        boolean alreadyHasContract = contractDAO.hasActiveContract(user.getUserId());
        request.setAttribute("alreadyHasContract", alreadyHasContract);

        String roomIdStr = request.getParameter("roomId");
        if (roomIdStr != null) {
            Room room = roomDAO.getRoomById(Integer.parseInt(roomIdStr));
            request.setAttribute("room", room);
        } else {
            List<Room> availableRooms = roomDAO.getByStatus("available");
            request.setAttribute("availableRooms", availableRooms);
        }
        forward(request, response, "/views/customer/signContract.jsp");
    }

    // =====================================================================
    // ADMIN – CONTRACT_TENANT CRUD
    // =====================================================================

    /** GET: show add-tenant form (blank) or edit-tenant form (prefilled) */
    private void showAddContractTenantForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }
        int contractId = Integer.parseInt(request.getParameter("id"));
        Contract c = contractDAO.getDetailById(contractId);
        if (c == null) { response.sendRedirect(request.getContextPath() + "/contract?action=list"); return; }
        request.setAttribute("contract", c);
        request.setAttribute("contractTenants", contractDAO.getTenantsByContractId(contractId));
        // blank form for add
        request.setAttribute("editTenant", null);
        forward(request, response, "/views/admin/contracts/manageContractTenants.jsp");
    }

    private void showEditContractTenantForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }
        int tenantId   = Integer.parseInt(request.getParameter("tenantId"));
        ContractTenant t = contractDAO.getTenantById(tenantId);
        if (t == null) { response.sendRedirect(request.getContextPath() + "/contract?action=list"); return; }
        Contract c = contractDAO.getDetailById(t.getContractId());
        request.setAttribute("contract",        c);
        request.setAttribute("contractTenants", contractDAO.getTenantsByContractId(t.getContractId()));
        request.setAttribute("editTenant",      t);
        forward(request, response, "/views/admin/contracts/manageContractTenants.jsp");
    }

    /** POST: add or update a contract_tenant record */
    private void saveContractTenant(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }
        try {
            int    contractId = Integer.parseInt(request.getParameter("contractId"));
            String tenantIdStr = request.getParameter("tenantId");
            String fullName   = request.getParameter("fullName");
            String phone      = request.getParameter("phone");
            String cccd       = request.getParameter("cccd");
            String bdStr      = request.getParameter("birthDate");
            boolean isPrimary = "1".equals(request.getParameter("isPrimary"));

            ContractTenant t = new ContractTenant();
            t.setContractId(contractId);
            t.setFullName(fullName);
            t.setPhone(phone != null ? phone : "");
            t.setCccd(cccd != null ? cccd : "");
            t.setBirthDate((bdStr != null && !bdStr.isEmpty()) ? LocalDate.parse(bdStr) : null);
            t.setPrimary(isPrimary);

            boolean ok;
            if (tenantIdStr != null && !tenantIdStr.isEmpty()) {
                // update existing
                t.setTenantId(Integer.parseInt(tenantIdStr));
                ok = contractDAO.updateContractTenant(t);
                flash(request, "contractSuccess", ok ? "Occupant updated." : "Update failed.");
            } else {
                // add new
                ok = contractDAO.addContractTenant(t);
                flash(request, "contractSuccess", ok ? "Occupant added." : "Failed to add occupant.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            flash(request, "contractError", "Invalid input: " + e.getMessage());
        }
        int contractId = Integer.parseInt(request.getParameter("contractId"));
        response.sendRedirect(request.getContextPath() + "/contract?action=addContractTenant&id=" + contractId);
    }

    /** GET: delete a contract_tenant row */
    private void removeContractTenant(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (!isAdminOrStaff(request)) { redirect401(request, response); return; }
        int tenantId   = Integer.parseInt(request.getParameter("tenantId"));
        int contractId = Integer.parseInt(request.getParameter("contractId"));
        contractDAO.removeContractTenant(tenantId);
        flash(request, "contractSuccess", "Occupant removed.");
        response.sendRedirect(request.getContextPath() + "/contract?action=addContractTenant&id=" + contractId);
    }

    // =====================================================================
    // HELPERS
    // =====================================================================
    private void forward(HttpServletRequest req, HttpServletResponse res, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, res);
    }

    private void flash(HttpServletRequest req, String key, String msg) {
        req.getSession().setAttribute(key, msg);
    }

    private void redirect401(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        User u = currentUser(req);
        if (u == null) {
            // Not logged in → go to login
            res.sendRedirect(req.getContextPath() + "/auth?action=login");
        } else {
            // Logged in but not authorized → send to customer area with error
            flash(req, "contractError", "You don't have permission to access that page.");
            res.sendRedirect(req.getContextPath() + "/contract?action=mycontract");
        }
    }

    private int parsePage(String param, int max) {
        try { int p = Integer.parseInt(param); return Math.min(Math.max(p, 1), max); }
        catch (Exception e) { return 1; }
    }

    private User currentUser(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        return (s != null) ? (User) s.getAttribute("user") : null;
    }

    private boolean isAdminOrStaff(HttpServletRequest req) {
        User u = currentUser(req);
        if (u == null) return false;
        return "admin".equalsIgnoreCase(u.getRole()) || "staff".equalsIgnoreCase(u.getRole());
    }
}
