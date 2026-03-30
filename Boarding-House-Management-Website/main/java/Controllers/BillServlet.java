package Controllers;

import DALs.BillDAO;
import DALs.ContractDAO;
import DALs.PriceDAO;
import Models.Bill;
import Models.BillItem;
import Models.PriceCategory;
import Models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class BillServlet extends HttpServlet {

    private BillDAO     billDAO;
    private ContractDAO contractDAO;
    private PriceDAO    priceDAO;

    private static final int PAGE_SIZE = 10;

    @Override
    public void init() {
        billDAO     = new BillDAO();
        contractDAO = new ContractDAO();
        priceDAO    = new PriceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":         listBills(request, response);        break;
            case "ownerList":    ownerBillList(request, response);    break;
            case "status":       billStatus(request, response);       break;
            case "create":       showCreateForm(request, response);   break;
            case "edit":         showEditForm(request, response);      break;
            case "detail":       viewDetail(request, response);        break;
            case "delete":       deleteBill(request, response);        break;
            case "mybill":       myBills(request, response);           break;
            default:             response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {
            case "create":        createBillWithItems(request, response); break;
            case "update":        updateBill(request, response);          break;
            case "updateStatus":  updateStatus(request, response);        break;
            default:              response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ===============================
    // MY BILLS (customer)
    // GET /bill?action=mybill
    // ===============================
    private void myBills(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        User user = (User) session.getAttribute("user");
        List<Bill> all = billDAO.getBillByTenant(user.getUserId());
        applyPaginationAttrs(request, all, "bills");
        request.getRequestDispatcher("/views/customer/bills.jsp").forward(request, response);
    }

    // ===============================
    // LIST (admin, existing)
    // ===============================
    private void listBills(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Bill> all = billDAO.getAllBills();
        applyPaginationAttrs(request, all, "bills");
        request.getRequestDispatcher("/views/admin/bills/bills.jsp").forward(request, response);
    }

    // ===============================
    // OWNER BILL LIST
    // GET /bill?action=ownerList
    // Returns: bill_id, room_number, period, total_amount, status, due_date
    // ===============================
    private void ownerBillList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Bill> bills = billDAO.getBillsWithRoomInfo();
        request.setAttribute("bills", bills);
        request.getRequestDispatcher("/views/admin/bills/ownerBillList.jsp").forward(request, response);
    }

    // ===============================
    // BILL PAYMENT STATUS
    // GET /bill?action=status
    // Reuses getBillsWithRoomInfo; filter by optional ?status= param
    // ===============================
    private void billStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String filterStatus = request.getParameter("status"); // null = all

        List<Bill> all = billDAO.getBillsWithRoomInfo();
        List<Bill> filtered = new ArrayList<>();
        for (Bill b : all) {
            if (filterStatus == null || filterStatus.isEmpty()
                    || filterStatus.equals(b.getStatus())) {
                filtered.add(b);
            }
        }
        request.setAttribute("bills", filtered);
        request.setAttribute("filterStatus", filterStatus);
        request.getRequestDispatcher("/views/admin/bills/billStatus.jsp").forward(request, response);
    }

    // ===============================
    // SHOW CREATE FORM
    // ===============================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Pass contracts and price categories for dropdowns
        request.setAttribute("contracts",  contractDAO.getAll());
        request.setAttribute("categories", priceDAO.getAllPriceCategories());
        request.getRequestDispatcher("/views/admin/bills/createBill.jsp").forward(request, response);
    }

    // ===============================
    // CREATE BILL WITH ITEMS
    // POST /bill?action=create
    // Step 1: build Bill; Step 2: build BillItems; Step 3: calc total
    // ===============================
    private void createBillWithItems(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int       contractId = Integer.parseInt(request.getParameter("contractId"));
            // Parse period: supports both YYYY-MM (type=month) and YYYY-MM-DD (type=date)
            // Always normalizes to 1st of month per DB constraint CHK_bill_period
            LocalDate period     = parseMonthParam(request.getParameter("period"));
            LocalDate dueDate    = LocalDate.parse(request.getParameter("dueDate"));

            // Collect repeating item arrays from form
            String[] descs       = request.getParameterValues("itemDesc[]");
            String[] quantities  = request.getParameterValues("itemQty[]");
            String[] prices      = request.getParameterValues("itemPrice[]");
            String[] categoryIds = request.getParameterValues("itemCategoryId[]");

            List<BillItem> items = new ArrayList<>();
            BigDecimal     total = BigDecimal.ZERO;

            if (descs != null) {
                for (int i = 0; i < descs.length; i++) {
                    String desc = descs[i].trim();
                    if (desc.isEmpty()) continue;
                    BigDecimal qty   = new BigDecimal(quantities[i]);
                    BigDecimal price = new BigDecimal(prices[i]);
                    BillItem item = new BillItem();
                    item.setCategoryId(Integer.parseInt(categoryIds[i]));
                    item.setDescription(desc);
                    item.setQuantity(qty);
                    item.setUnitPrice(price);
                    items.add(item);
                    total = total.add(qty.multiply(price));
                }
            }

            Bill bill = new Bill();
            bill.setContractId(contractId);
            bill.setPeriod(period);
            bill.setDueDate(dueDate);
            bill.setTotalAmount(total);
            bill.setStatus("pending");

            billDAO.insertBillWithItems(bill, items);

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("bill?action=list");
    }

    // ===============================
    // SHOW EDIT FORM
    // ===============================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int  billId = Integer.parseInt(request.getParameter("id"));
        Bill bill   = billDAO.getBillById(billId);
        request.setAttribute("bill", bill);
        request.getRequestDispatcher("/views/admin/bills/editBill.jsp").forward(request, response);
    }

    // ===============================
    // UPDATE (full fields)
    // ===============================
    private void updateBill(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int       billId     = Integer.parseInt(request.getParameter("billId"));
        int       contractId = Integer.parseInt(request.getParameter("contractId"));
        // Parse period: supports both YYYY-MM (type=month) and YYYY-MM-DD (type=date)
        LocalDate period     = parseMonthParam(request.getParameter("period"));
        LocalDate dueDate    = LocalDate.parse(request.getParameter("dueDate"));
        String    status     = request.getParameter("status");

        Bill bill = new Bill();
        bill.setBillId(billId);
        bill.setContractId(contractId);
        bill.setPeriod(period);
        bill.setDueDate(dueDate);
        bill.setStatus(status);
        billDAO.updateBill(bill);

        response.sendRedirect("bill?action=list");
    }

    // ===============================
    // UPDATE STATUS ONLY
    // POST /bill?action=updateStatus
    // ===============================
    private void updateStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int    billId = Integer.parseInt(request.getParameter("billId"));
        String status = request.getParameter("status");
        billDAO.updateStatus(billId, status);

        // Redirect back to referrer or status page
        String ref = request.getHeader("Referer");
        response.sendRedirect(ref != null ? ref : "bill?action=status");
    }

    // ===============================
    // DETAIL
    // ===============================
    private void viewDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int  billId = Integer.parseInt(request.getParameter("id"));
        Bill bill   = billDAO.getBillById(billId);

        request.setAttribute("bill", bill);
        // Load bill items for detail view
        if (bill != null) {
            request.setAttribute("billItems", billDAO.getBillItemsByBillId(billId));
        }

        // Route to customer or admin detail view based on role
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        String view = (user != null && "customer".equals(user.getRole()))
                ? "/views/customer/billDetail.jsp"
                : "/views/admin/bills/billDetail.jsp";
        request.getRequestDispatcher(view).forward(request, response);
    }

    // ===============================
    // DELETE (soft)
    // ===============================
    private void deleteBill(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int billId = Integer.parseInt(request.getParameter("id"));
        billDAO.deleteBill(billId);
        response.sendRedirect("bill?action=list");
    }

    // ===============================
    // PAGINATION HELPER
    // ===============================
    private <T> void applyPaginationAttrs(HttpServletRequest request, List<T> all, String listAttr) {
        int totalItems = all.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException ignored) {}
        }
        page = Math.min(Math.max(page, 1), totalPages);

        int fromIndex = (page - 1) * PAGE_SIZE;
        int toIndex   = Math.min(fromIndex + PAGE_SIZE, totalItems);
        List<T> pageItems = (fromIndex < totalItems) ? all.subList(fromIndex, toIndex) : java.util.Collections.emptyList();

        request.setAttribute(listAttr,    pageItems);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages",  totalPages);
        request.setAttribute("totalItems",  totalItems);
        request.setAttribute("pageSize",    PAGE_SIZE);
    }

    /**
     * Parse period param from either:
     *   - "YYYY-MM"    (HTML input type=month)
     *   - "YYYY-MM-DD" (HTML input type=date — legacy)
     * Always returns the 1st day of the month to satisfy CHK_bill_period constraint.
     */
    private LocalDate parseMonthParam(String value) {
        if (value == null || value.isBlank()) {
            throw new IllegalArgumentException("period parameter is required");
        }
        // YYYY-MM format from <input type="month">
        if (value.length() == 7) {
            return LocalDate.parse(value + "-01");
        }
        // YYYY-MM-DD format — normalize to 1st regardless of day entered
        return LocalDate.parse(value).withDayOfMonth(1);
    }
}
