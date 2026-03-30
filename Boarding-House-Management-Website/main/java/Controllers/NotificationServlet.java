package Controllers;

import DALs.NotificationDAO;
import Models.Notification;
import Models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class NotificationServlet extends HttpServlet {

    private NotificationDAO notificationDAO;

    private static final int PAGE_SIZE = 10;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
    }

    // =====================================================================
    // GET
    // =====================================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "publicList";

        switch (action) {

            // ── Customer-facing ──────────────────────────────────────────
            case "publicList":
                showPublicList(request, response);
                break;

            case "publicDetail":
                showPublicDetail(request, response);
                break;

            // ── Admin / staff ────────────────────────────────────────────
            case "list":
                listNotifications(request, response);
                break;

            case "create":
                request.getRequestDispatcher("/views/admin/notifications/createNotification.jsp")
                        .forward(request, response);
                break;

            case "detail":
                showAdminDetail(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            default:
                showPublicList(request, response);
        }
    }

    // =====================================================================
    // POST
    // =====================================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect("notification");
            return;
        }

        switch (action) {
            case "create":
                createNotification(request, response);
                break;
            case "update":
                updateNotification(request, response);
                break;
            case "delete":
                deleteNotification(request, response);
                break;
            default:
                response.sendRedirect("notification");
        }
    }

    // =====================================================================
    // CUSTOMER: list (broadcast + user-relevant)
    // =====================================================================
    private void showPublicList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        List<Notification> all;

        if (user != null && ("admin".equals(user.getRole()) || "staff".equals(user.getRole()))) {
            all = notificationDAO.getAllNotifications();
        } else if (user != null) {
            all = notificationDAO.getNotificationsForUser(user.getUserId());
        } else {
            all = notificationDAO.getAllNotifications();
        }

        // Filter by type
        String typeFilter = request.getParameter("type");
        if ("broadcast".equals(typeFilter)) {
            all.removeIf(n -> !n.isBroadcast());
        } else if ("targeted".equals(typeFilter)) {
            all.removeIf(Notification::isBroadcast);
        }

        // Pagination
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
        List<Notification> notifications = (fromIndex < totalItems)
                ? all.subList(fromIndex, toIndex)
                : java.util.Collections.emptyList();

        request.setAttribute("notifications", notifications);
        request.setAttribute("typeFilter",    typeFilter != null ? typeFilter : "");
        request.setAttribute("totalItems",    totalItems);
        request.setAttribute("totalPages",    totalPages);
        request.setAttribute("currentPage",   page);
        request.setAttribute("pageSize",      PAGE_SIZE);
        request.getRequestDispatcher("/views/customer/notifications.jsp")
                .forward(request, response);
    }

    // =====================================================================
    // CUSTOMER: detail
    // =====================================================================
    private void showPublicDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Notification n = notificationDAO.getNotificationById(id);
        request.setAttribute("notification", n);
        request.getRequestDispatcher("/views/customer/notificationDetail.jsp")
                .forward(request, response);
    }

    // =====================================================================
    // ADMIN: list with filters
    // =====================================================================
    private void listNotifications(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contractParam = request.getParameter("contractId");
        String createdParam  = request.getParameter("createdBy");
        String keyword       = request.getParameter("keyword");

        String typeFilter = request.getParameter("type");

        List<Notification> list;

        if (contractParam != null && !contractParam.isEmpty()) {
            list = notificationDAO.getNotificationByContract(Integer.parseInt(contractParam));
        } else if (createdParam != null && !createdParam.isEmpty()) {
            list = notificationDAO.getNotificationByUser(Integer.parseInt(createdParam));
        } else if (keyword != null && !keyword.isEmpty()) {
            list = notificationDAO.searchNotification(keyword);
        } else {
            list = notificationDAO.getAllNotifications();
        }

        // Filter by type: broadcast (chung) or targeted (riêng)
        if ("broadcast".equals(typeFilter)) {
            list.removeIf(n -> !n.isBroadcast());
        } else if ("targeted".equals(typeFilter)) {
            list.removeIf(Notification::isBroadcast);
        }

        request.setAttribute("notifications", list);
        request.getRequestDispatcher("/views/admin/notifications/notifications.jsp")
                .forward(request, response);
    }

    // =====================================================================
    // ADMIN: detail
    // =====================================================================
    private void showAdminDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Notification n = notificationDAO.getNotificationById(id);
        request.setAttribute("notification", n);
        request.getRequestDispatcher("/views/admin/notifications/notificationDetail.jsp")
                .forward(request, response);
    }

    // =====================================================================
    // ADMIN: edit form
    // =====================================================================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Notification n = notificationDAO.getNotificationById(id);
        request.setAttribute("notification", n);
        request.getRequestDispatcher("/views/admin/notifications/editNotification.jsp")
                .forward(request, response);
    }

    // =====================================================================
    // CREATE
    // =====================================================================
    private void createNotification(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int    createdBy = Integer.parseInt(request.getParameter("createdBy"));
        String title     = request.getParameter("title");
        String content   = request.getParameter("content");
        String targetParam = request.getParameter("targetContractId");
        Integer targetContractId = (targetParam != null && !targetParam.isEmpty())
                                   ? Integer.parseInt(targetParam) : null;

        notificationDAO.insertNotification(
                new Notification(createdBy, title, content, targetContractId, false));
        response.sendRedirect("notification?action=list");
    }

    // =====================================================================
    // UPDATE
    // =====================================================================
    private void updateNotification(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int    id      = Integer.parseInt(request.getParameter("notificationId"));
        String title   = request.getParameter("title");
        String content = request.getParameter("content");
        String tp      = request.getParameter("targetContractId");
        Integer target = (tp != null && !tp.isEmpty()) ? Integer.parseInt(tp) : null;

        Notification n = new Notification();
        n.setTitle(title);
        n.setContent(content);
        n.setTargetContractId(target);

        notificationDAO.updateNotification(id, n);
        response.sendRedirect("notification?action=list");
    }

    // =====================================================================
    // DELETE
    // =====================================================================
    private void deleteNotification(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("notificationId"));
        notificationDAO.deleteNotification(id);
        response.sendRedirect("notification?action=list");
    }
}
