package Controllers;

import DALs.UserDAO;
import Models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class AdminServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // chưa login
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/guest/dashboard.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        // kiểm tra role admin
        if (!"admin".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/guest/dashboard.jsp");
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            action = "dashboard";
        }

        switch (action) {

            case "dashboard":
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
                break;

            case "rooms":
                request.getRequestDispatcher("/admin/rooms.jsp").forward(request, response);
                break;

            case "services":
                request.getRequestDispatcher("/admin/services.jsp").forward(request, response);
                break;

            case "bills":
                request.getRequestDispatcher("/admin/bills.jsp").forward(request, response);
                break;

            case "notifications":
                request.getRequestDispatcher("/admin/notifications.jsp").forward(request, response);
                break;

            case "profile":
                request.getRequestDispatcher("/admin/profile.jsp").forward(request, response);
                break;

            case "changePassword":
                request.getRequestDispatcher("/admin/changePassword.jsp").forward(request, response);
                break;

            default:
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        switch (action) {

            case "insert":
                insertUser(request, response);
                break;

            case "update":
                updateUser(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<User> users = userDAO.getAllUsers();

        request.setAttribute("users", users);

        request.getRequestDispatcher("/views/admin/user/list.jsp")
                .forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/admin/user/create.jsp")
                .forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        User user = userDAO.getUserById(id);

        request.setAttribute("user", user);

        request.getRequestDispatcher("/views/admin/user/edit.jsp")
                .forward(request, response);
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        User user = new User();

        user.setUsername(request.getParameter("username"));
        user.setPassword(request.getParameter("password"));
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setRole(request.getParameter("role"));
        user.setImage(request.getParameter("image"));

        userDAO.register(user);

        response.sendRedirect("admin-user?action=list");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        User user = new User();

        user.setUserId(Integer.parseInt(request.getParameter("userId")));
        user.setUsername(request.getParameter("username"));
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setPhone(request.getParameter("phone"));
        user.setRole(request.getParameter("role"));
        user.setImage(request.getParameter("image"));
        user.setPassword(request.getParameter("password"));

        userDAO.updateUserById(user);

        response.sendRedirect("admin-user?action=list");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        userDAO.deleteSoft(id);

        response.sendRedirect("admin-user?action=list");
    }
}
