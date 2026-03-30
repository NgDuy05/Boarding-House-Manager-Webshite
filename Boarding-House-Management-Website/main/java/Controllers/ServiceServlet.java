package Controllers;

import DALs.PriceDAO;
import DALs.ServiceDAO;
import Models.PriceCategory;
import Models.Service;
import Models.ServiceUsage;
import Models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;

public class ServiceServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private ServiceDAO serviceDAO;
    private PriceDAO   priceDAO;

    @Override
    public void init() {
        serviceDAO = new ServiceDAO();
        priceDAO   = new PriceDAO();
    }

    // =============================== GET ===============================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "default";

        switch (action) {

            // ── Customer ───────────────────────────────────────────────
            case "default":
            case "publicList":
                showPublicList(request, response);
                break;

            case "myHistory":
                showMyHistory(request, response);
                break;

            case "requestForm":
                showRequestForm(request, response);
                break;

            // ── Admin ──────────────────────────────────────────────────
            case "adminList":
                showAdminList(request, response);
                break;

            case "requestList":
                showRequestList(request, response);
                break;

            case "manageRequests":
                showManageRequests(request, response);
                break;

            case "approve":
                approveRequest(request, response);
                break;

            case "reject":
                rejectRequest(request, response);
                break;

            case "create":
                showCreateForm(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "delete":
            case "hide":
                hideService(request, response);
                break;
            case "restore":
                restoreService(request, response);
                break;

            case "detail":
                showDetail(request, response);
                break;

            case "usage":
                listUsage(request, response);
                break;

            case "markBilled":
                markBilled(request, response);
                break;

            default:
                showPublicList(request, response);
        }
    }

    // =============================== POST ===============================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "insert":
                insertService(request, response);
                break;
            case "update":
                updateService(request, response);
                break;
            case "addUsage":
                addUsage(request, response);
                break;
            case "submitRequest":
                submitRequest(request, response);
                break;
            case "updateStatus":
                updateRequestStatus(request, response);
                break;
        }
    }

    // ================= CUSTOMER: PUBLIC SERVICE LIST =================
    private void showPublicList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Service> list = serviceDAO.getAllServices();
        request.setAttribute("services", list);
        request.getRequestDispatcher("/views/customer/services.jsp")
                .forward(request, response);
    }

    // ================= CUSTOMER: MY SERVICE HISTORY =================
    private void showMyHistory(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        List<ServiceUsage> historyList = serviceDAO.getUsageByUserId(user.getUserId());
        request.setAttribute("historyList", historyList);
        request.getRequestDispatcher("/views/customer/serviceHistory.jsp")
                .forward(request, response);
    }

    // ================= CUSTOMER: SHOW REQUEST FORM =================
    private void showRequestForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        int contractId = serviceDAO.getActiveContractIdByUserId(user.getUserId());
        if (contractId == -1) {
            request.setAttribute("errorMsg", "Bạn chưa có hợp đồng thuê phòng đang hoạt động.");
        }

        List<Service> services = serviceDAO.getAllServices();
        String preselectedId = request.getParameter("serviceId");

        request.setAttribute("contractId",    contractId);
        request.setAttribute("services",      services);
        request.setAttribute("preselectedId", preselectedId);
        request.getRequestDispatcher("/views/customer/requestService.jsp")
                .forward(request, response);
    }

    // ================= CUSTOMER: SUBMIT REQUEST (POST) =================
    private void submitRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        int contractId = serviceDAO.getActiveContractIdByUserId(user.getUserId());
        if (contractId == -1) {
            response.sendRedirect(request.getContextPath()
                    + "/services?action=requestForm&error=nocontract");
            return;
        }

        int        serviceId = Integer.parseInt(request.getParameter("serviceId"));
        BigDecimal quantity  = new BigDecimal(request.getParameter("quantity"));
        LocalDate  useDate   = LocalDate.parse(request.getParameter("usageDate"));

        boolean ok = serviceDAO.requestService(contractId, serviceId, quantity, useDate);

        if (ok) {
            response.sendRedirect(request.getContextPath()
                    + "/services?action=myHistory&success=requested");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/services?action=requestForm&error=failed");
        }
    }

    // ================= ADMIN: MANAGE SERVICES LIST =================
    private void showAdminList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Service>       all        = serviceDAO.getAllServicesAdmin();
        List<PriceCategory> categories = priceDAO.getAllPriceCategories();
        long hiddenCount = all.stream().filter(s -> s.isIsDeleted()).count();

        int totalItems = all.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));
        int page = parsePage(request.getParameter("page"), totalPages);
        int from = (page - 1) * PAGE_SIZE;
        int to   = Math.min(from + PAGE_SIZE, totalItems);
        List<Service> list = (from < totalItems) ? all.subList(from, to) : Collections.emptyList();

        request.setAttribute("services",        list);
        request.setAttribute("priceCategories", categories);
        request.setAttribute("hiddenCount",     hiddenCount);
        request.setAttribute("currentPage",     page);
        request.setAttribute("totalPages",      totalPages);
        request.setAttribute("totalItems",      totalItems);
        request.setAttribute("pageSize",        PAGE_SIZE);
        request.getRequestDispatcher("/views/admin/services/services.jsp")
                .forward(request, response);
    }

    // ================= ADMIN: SERVICE REQUEST LIST (all usage) =================
    private void showRequestList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<ServiceUsage> all      = serviceDAO.getAllUsageWithDetails();
        List<Service>      services = serviceDAO.getAllServices();

        int totalItems = all.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));
        int page = parsePage(request.getParameter("page"), totalPages);
        int from = (page - 1) * PAGE_SIZE;
        int to   = Math.min(from + PAGE_SIZE, totalItems);
        List<ServiceUsage> usageList = (from < totalItems) ? all.subList(from, to) : Collections.emptyList();

        request.setAttribute("usageList",   usageList);
        request.setAttribute("services",    services);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages",  totalPages);
        request.setAttribute("totalItems",  totalItems);
        request.setAttribute("pageSize",    PAGE_SIZE);
        request.getRequestDispatcher("/views/admin/services/requestList.jsp")
                .forward(request, response);
    }

    // ================= ADMIN: MANAGE REQUESTS (approve/reject) =================
    private void showManageRequests(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // --- ROLE CHECK (comment out to disable) ---
        // User user = (User) request.getSession().getAttribute("user");
        // if (user == null || (!user.getRole().equals("admin") && !user.getRole().equals("staff"))) {
        //     response.sendRedirect(request.getContextPath() + "/auth?action=login");
        //     return;
        // }

        String statusFilter = request.getParameter("status");
        List<ServiceUsage> requestList = serviceDAO.getAllRequestsWithDetails(statusFilter);

        // Count by status
        long pendingCount  = requestList.stream().filter(u -> "pending".equals(u.getStatus())).count();
        long approvedCount = requestList.stream().filter(u -> "approved".equals(u.getStatus())).count();
        long rejectedCount = requestList.stream().filter(u -> "rejected".equals(u.getStatus())).count();

        request.setAttribute("requestList",   requestList);
        request.setAttribute("statusFilter",  statusFilter != null ? statusFilter : "");
        request.setAttribute("pendingCount",  pendingCount);
        request.setAttribute("approvedCount", approvedCount);
        request.setAttribute("rejectedCount", rejectedCount);
        request.getRequestDispatcher("/views/admin/services/manageRequests.jsp")
                .forward(request, response);
    }

    // ================= ADMIN: UPDATE REQUEST STATUS (POST) =================
    private void updateRequestStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // --- ROLE CHECK (comment out to disable) ---
        // User user = (User) request.getSession().getAttribute("user");
        // if (user == null || (!user.getRole().equals("admin") && !user.getRole().equals("staff"))) {
        //     response.sendRedirect(request.getContextPath() + "/auth?action=login");
        //     return;
        // }

        int    usageId    = Integer.parseInt(request.getParameter("id"));
        String newStatus  = request.getParameter("status");
        String filter     = request.getParameter("statusFilter");

        serviceDAO.updateRequestStatus(usageId, newStatus);

        String redirect = request.getContextPath() + "/services?action=manageRequests";
        if (filter != null && !filter.isEmpty()) {
            redirect += "&status=" + filter;
        }
        response.sendRedirect(redirect);
    }

    // ================= ADMIN: APPROVE REQUEST =================
    private void approveRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // --- ROLE CHECK (comment out to disable) ---
        // User user = (User) request.getSession().getAttribute("user");
        // if (user == null || (!user.getRole().equals("admin") && !user.getRole().equals("staff"))) {
        //     response.sendRedirect(request.getContextPath() + "/auth?action=login");
        //     return;
        // }

        int usageId = Integer.parseInt(request.getParameter("id"));
        serviceDAO.approveRequest(usageId);
        String ref = request.getParameter("from");
        if ("pending".equals(ref)) {
            response.sendRedirect(request.getContextPath()
                    + "/services?action=manageRequests&status=pending");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/services?action=manageRequests");
        }
    }

    // ================= ADMIN: REJECT REQUEST =================
    private void rejectRequest(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // --- ROLE CHECK (comment out to disable) ---
        // User user = (User) request.getSession().getAttribute("user");
        // if (user == null || (!user.getRole().equals("admin") && !user.getRole().equals("staff"))) {
        //     response.sendRedirect(request.getContextPath() + "/auth?action=login");
        //     return;
        // }

        int usageId = Integer.parseInt(request.getParameter("id"));
        serviceDAO.rejectRequest(usageId);
        String ref = request.getParameter("from");
        if ("pending".equals(ref)) {
            response.sendRedirect(request.getContextPath()
                    + "/services?action=manageRequests&status=pending");
        } else {
            response.sendRedirect(request.getContextPath()
                    + "/services?action=manageRequests");
        }
    }

    // ================= ADMIN: CREATE FORM =================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<PriceCategory> categories = serviceDAO.getServicePriceCategories();
        request.setAttribute("priceCategories", categories);
        request.getRequestDispatcher("/views/admin/services/createService.jsp")
                .forward(request, response);
    }

    // ================= ADMIN: EDIT FORM =================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Service service = serviceDAO.getServiceById(id);
        List<PriceCategory> categories = serviceDAO.getServicePriceCategories();
        request.setAttribute("service",         service);
        request.setAttribute("priceCategories", categories);
        request.getRequestDispatcher("/views/admin/services/editService.jsp")
                .forward(request, response);
    }

    // ================= ADMIN: INSERT =================
    private void insertService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String name        = request.getParameter("serviceName");
        int    categoryId  = Integer.parseInt(request.getParameter("categoryId"));
        String description = request.getParameter("description");
        String image       = request.getParameter("image");
        if (image == null || image.isBlank()) image = "service.jpg";

        Service s = new Service();
        s.setServiceName(name);
        s.setCategoryId(categoryId);
        s.setDescription(description);
        s.setImage(image);

        serviceDAO.insertService(s);
        response.sendRedirect(request.getContextPath() + "/services?action=adminList");
    }

    // ================= ADMIN: UPDATE =================
    private void updateService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int    id          = Integer.parseInt(request.getParameter("serviceId"));
        String name        = request.getParameter("serviceName");
        int    categoryId  = Integer.parseInt(request.getParameter("categoryId"));
        String description = request.getParameter("description");
        String image       = request.getParameter("image");
        if (image == null || image.isBlank()) image = "service.jpg";

        Service s = new Service();
        s.setServiceId(id);
        s.setServiceName(name);
        s.setCategoryId(categoryId);
        s.setDescription(description);
        s.setImage(image);

        serviceDAO.updateService(s);
        response.sendRedirect(request.getContextPath() + "/services?action=adminList");
    }

    // ================= ADMIN: HIDE (soft-delete) =================
    private void hideService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        serviceDAO.deleteService(id);   // sets is_deleted = 1
        response.sendRedirect(request.getContextPath() + "/services?action=adminList");
    }

    // ================= ADMIN: RESTORE =================
    private void restoreService(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        serviceDAO.restoreService(id);  // sets is_deleted = 0
        response.sendRedirect(request.getContextPath() + "/services?action=adminList");
    }

    // ================= ADMIN: DETAIL =================
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Service service = serviceDAO.getServiceById(id);
        request.setAttribute("service", service);
        request.getRequestDispatcher("/views/admin/services/serviceDetail.jsp")
                .forward(request, response);
    }

    // ================= ADMIN: LIST USAGE BY CONTRACT =================
    private void listUsage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int contractId = Integer.parseInt(request.getParameter("contractId"));
        List<ServiceUsage> usageList = serviceDAO.getUsageByContract(contractId);
        request.setAttribute("usageList",   usageList);
        request.setAttribute("contractId",  contractId);
        request.getRequestDispatcher("/views/admin/services/requestList.jsp")
                .forward(request, response);
    }

    // ================= ADMIN: ADD USAGE =================
    private void addUsage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int        contractId = Integer.parseInt(request.getParameter("contractId"));
        int        serviceId  = Integer.parseInt(request.getParameter("serviceId"));
        BigDecimal qty        = new BigDecimal(request.getParameter("quantity"));
        LocalDate  useDate    = LocalDate.parse(request.getParameter("usageDate"));

        ServiceUsage u = new ServiceUsage();
        u.setContractId(contractId);
        u.setServiceId(serviceId);
        u.setQuantity(qty);
        u.setUsageDate(useDate);

        serviceDAO.addUsage(u);
        response.sendRedirect(request.getContextPath() + "/services?action=requestList");
    }

    // ================= ADMIN: MARK BILLED =================
    private void markBilled(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int contractId = Integer.parseInt(request.getParameter("contractId"));
        serviceDAO.markUsageBilled(contractId);
        response.sendRedirect(request.getContextPath() + "/services?action=requestList");
    }

    // ================= PAGINATION HELPER =================
    private int parsePage(String param, int totalPages) {
        int page = 1;
        if (param != null) {
            try { page = Integer.parseInt(param); } catch (NumberFormatException ignored) {}
        }
        return Math.min(Math.max(page, 1), totalPages);
    }
}
