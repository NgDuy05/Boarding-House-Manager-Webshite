package Controllers;

import DALs.BillDAO;
import DALs.ContractDAO;
import DALs.NotificationDAO;
import DALs.ServiceDAO;
import Models.Bill;
import Models.Contract;
import Models.Notification;
import Models.ServiceUsage;
import Models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class DashboardServlet extends HttpServlet {

    private ContractDAO     contractDAO;
    private BillDAO         billDAO;
    private NotificationDAO notificationDAO;
    private ServiceDAO      serviceDAO;

    @Override
    public void init() {
        contractDAO     = new ContractDAO();
        billDAO         = new BillDAO();
        notificationDAO = new NotificationDAO();
        serviceDAO      = new ServiceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        User user = (User) session.getAttribute("user");

        if ("admin".equalsIgnoreCase(user.getRole())
                || "staff".equalsIgnoreCase(user.getRole())) {

            request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);

        } else if ("customer".equalsIgnoreCase(user.getRole())) {

            loadCustomerDashboard(request, response, user);

        } else {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    // Load all dashboard data for the customer view
    private void loadCustomerDashboard(HttpServletRequest request,
                                       HttpServletResponse response,
                                       User user)
            throws ServletException, IOException {

        int userId = user.getUserId();

        // 1. Active contract + room info (roomNumber, categoryName, endDate, tenantCount)
        Contract contract = contractDAO.getActiveContractByUserId(userId);
        request.setAttribute("contract", contract);

        // 2. Latest unpaid/current bill for this user
        if (contract != null) {
            List<Bill> bills = billDAO.getBillByTenant(userId);
            // Show most recent bill (first in list — ordered DESC by bill_id)
            Bill currentBill = bills.isEmpty() ? null : bills.get(0);
            request.setAttribute("currentBill", currentBill);
        }

        // 3. Recent 3 notifications
        List<Notification> notifications = notificationDAO.getNotificationsForUser(userId);
        int notiEnd = Math.min(3, notifications.size());
        request.setAttribute("recentNotifications", notifications.subList(0, notiEnd));

        // 4. Recent 5 service requests
        List<ServiceUsage> serviceRequests = serviceDAO.getUsageByUserId(userId);
        int svcEnd = Math.min(5, serviceRequests.size());
        request.setAttribute("recentServices", serviceRequests.subList(0, svcEnd));

        request.getRequestDispatcher("/views/customer/dashboard.jsp").forward(request, response);
    }
}
