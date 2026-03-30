package Controllers;

import DALs.BillDAO;
import DALs.ContractDAO;
import DALs.UserDAO;
import Models.Bill;
import Models.Contract;
import Models.User;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class ManageCustomerServlet extends HttpServlet {

    private UserDAO userDAO;
    private ContractDAO contractDAO;
    private BillDAO billDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
        contractDAO = new ContractDAO();
        billDAO = new BillDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminOrStaff(request)) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listCustomers(request, response);
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
            case "hide":
            case "delete":
                hideCustomer(request, response);
                break;
            case "restore":
                restoreCustomer(request, response);
                break;
            default:
                listCustomers(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminOrStaff(request)) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/manage-customer");
            return;
        }

        switch (action) {
            case "insert":
                insertCustomer(request, response);
                break;
            case "update":
                updateCustomer(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/manage-customer");
        }
    }

    // ===================================================
    // LIST
    // ===================================================

    private static final int PAGE_SIZE = 10;

    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String search = request.getParameter("search");
        String statusFilter = request.getParameter("status");

        List<User> all = userDAO.getAllCustomers(search, statusFilter);

        long activeCount = all.stream().filter(u -> !u.isIsDeleted()).count();
        long hiddenCount = all.stream().filter(u ->  u.isIsDeleted()).count();

        // Pagination
        int totalItems = all.size();
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);
        if (totalPages == 0) totalPages = 1;

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException ignored) {}
        }
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        int fromIndex = (page - 1) * PAGE_SIZE;
        int toIndex   = Math.min(fromIndex + PAGE_SIZE, totalItems);
        List<User> customers = (fromIndex < totalItems) ? all.subList(fromIndex, toIndex) : all.subList(0, 0);

        request.setAttribute("customers",   customers);
        request.setAttribute("activeCount", activeCount);
        request.setAttribute("hiddenCount", hiddenCount);
        request.setAttribute("search",      search);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages",  totalPages);
        request.setAttribute("totalItems",  totalItems);
        request.setAttribute("pageSize",    PAGE_SIZE);

        request.getRequestDispatcher("/views/admin/customers/customers.jsp")
                .forward(request, response);
    }

    // ===================================================
    // CREATE
    // ===================================================

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/customers/createCustomer.jsp")
                .forward(request, response);
    }

    private void insertCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");

        if (userDAO.existsByUsername(username)) {
            request.getSession().setAttribute("customerError", "Username '" + username + "' already exists!");
            response.sendRedirect(request.getContextPath() + "/manage-customer?action=create");
            return;
        }

        User u = new User();
        u.setUsername(username);
        u.setPassword(password);
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPhone(phone);
        u.setRole("customer");
        u.setImage("default.png");

        boolean ok = userDAO.insertCustomer(u);
        if (ok) {
            request.getSession().setAttribute("customerSuccess", "Customer added successfully!");
        } else {
            request.getSession().setAttribute("customerError", "Failed to add customer. Please try again.");
        }
        response.sendRedirect(request.getContextPath() + "/manage-customer");
    }

    // ===================================================
    // EDIT
    // ===================================================

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        User customer = userDAO.getUserByIdAny(id);

        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/manage-customer");
            return;
        }

        request.setAttribute("customer", customer);
        request.getRequestDispatcher("/views/admin/customers/editCustomer.jsp")
                .forward(request, response);
    }

    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
        throws IOException, ServletException {

    int id = Integer.parseInt(request.getParameter("userId"));
    User u = userDAO.getUserByIdAny(id);

    if (u == null) {
        response.sendRedirect(request.getContextPath() + "/manage-customer");
        return;
    }

    String fullName = request.getParameter("fullName");
    String email    = request.getParameter("email");
    String phone    = request.getParameter("phone");
    String newPwd   = request.getParameter("password");

    // ================= VALIDATION =================
    String error = null;

    // Validate email
    if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
        error = "Invalid email format!";
    }

    // Validate phone (10 digits)
    else if (phone == null || !phone.matches("^\\d{10}$")) {
        error = "Phone must be exactly 10 digits!";
    }

    // Validate password (bắt buộc)
    else if (newPwd == null || newPwd.trim().isEmpty()) {
        error = "Password is required!";
    }

    else if (newPwd.length() < 6) {
        error = "Password must be at least 6 characters!";
    }

    // Nếu có lỗi → quay lại form
    if (error != null) {
        request.setAttribute("customerError", error);
        request.setAttribute("customer", u);
        request.getRequestDispatcher("/views/admin/customers/editCustomer.jsp")
               .forward(request, response);
        return;
    }

    // ================= UPDATE =================
    u.setFullName(fullName);
    u.setEmail(email);
    u.setPhone(phone);
    u.setPassword(newPwd.trim()); // đã validate nên set luôn

    boolean ok = userDAO.updateUserById(u);

    if (ok) {
        request.getSession().setAttribute("customerSuccess", "Updated successfully!");
    } else {
        request.getSession().setAttribute("customerError", "Update failed!");
    }

    response.sendRedirect(request.getContextPath() + "/manage-customer");
}

    // ===================================================
    // DETAIL + ACTIVITY LOG
    // ===================================================

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        User customer = userDAO.getUserByIdAny(id);

        if (customer == null) {
            response.sendRedirect(request.getContextPath() + "/manage-customer");
            return;
        }

        List<Contract> customerContracts = contractDAO.getContractsByUserId(id);
        List<Bill> customerBills = billDAO.getBillByTenant(id);

        request.setAttribute("customer", customer);
        request.setAttribute("contracts", customerContracts);
        request.setAttribute("bills", customerBills);

        request.getRequestDispatcher("/views/admin/customers/customerDetail.jsp")
                .forward(request, response);
    }

    // ===================================================
    // HIDE / RESTORE
    // ===================================================

    private void hideCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteSoft(id);
        request.getSession().setAttribute("customerSuccess", "Customer has been hidden.");
        response.sendRedirect(request.getContextPath() + "/manage-customer");
    }

    private void restoreCustomer(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.restoreUser(id);
        request.getSession().setAttribute("customerSuccess", "Customer restored successfully!");
        response.sendRedirect(request.getContextPath() + "/manage-customer");
    }

    // ===================================================
    // HELPER
    // ===================================================

    private boolean isAdminOrStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User u = (User) session.getAttribute("user");
        if (u == null) return false;
        return "admin".equalsIgnoreCase(u.getRole()) || "staff".equalsIgnoreCase(u.getRole());
    }
}
