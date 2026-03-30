package Controllers;

import DALs.ActivityLogDAO;
import DALs.UserDAO;
import Models.ActivityLog;
import Models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class ActivityLogServlet extends HttpServlet {

    private ActivityLogDAO logDAO;
    private UserDAO userDAO;

    private static final int PAGE_SIZE = 15;

    @Override
    public void init() {
        logDAO  = new ActivityLogDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminOrStaff(request)) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        // ---- filters ----
        String search     = request.getParameter("search");
        String typeFilter = request.getParameter("type");
        String dateFrom   = request.getParameter("dateFrom");
        String dateTo     = request.getParameter("dateTo");
        String userIdStr  = request.getParameter("userId");

        int filterUserId = 0;
        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            try { filterUserId = Integer.parseInt(userIdStr); } catch (NumberFormatException ignored) {}
        }

        // ---- fetch all matching logs ----
        List<ActivityLog> all = logDAO.getLogs(filterUserId, typeFilter, dateFrom, dateTo, search);

        // ---- pagination ----
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
        List<ActivityLog> logs = (fromIndex < totalItems)
                ? all.subList(fromIndex, toIndex)
                : java.util.Collections.emptyList();

        // ---- customer list for filter dropdown ----
        List<User> customers = userDAO.getAllCustomers(null, "active");

        request.setAttribute("logs",         logs);
        request.setAttribute("totalItems",   totalItems);
        request.setAttribute("totalPages",   totalPages);
        request.setAttribute("currentPage",  page);
        request.setAttribute("pageSize",     PAGE_SIZE);
        request.setAttribute("customers",    customers);
        request.setAttribute("search",       search);
        request.setAttribute("typeFilter",   typeFilter);
        request.setAttribute("dateFrom",     dateFrom);
        request.setAttribute("dateTo",       dateTo);
        request.setAttribute("filterUserId", filterUserId);

        request.getRequestDispatcher("/views/admin/activityLog/activityLog.jsp")
                .forward(request, response);
    }

    private boolean isAdminOrStaff(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) return false;
        User u = (User) session.getAttribute("user");
        if (u == null) return false;
        return "admin".equalsIgnoreCase(u.getRole()) || "staff".equalsIgnoreCase(u.getRole());
    }
}
