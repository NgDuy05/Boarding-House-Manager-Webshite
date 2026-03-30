package Controllers;

import DALs.UserDAO;
import Models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class CustomerServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    // ===================== GET =====================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "profile";
        }

        switch (action) {

            case "profile":
                showProfile(request, response);
                break;

            case "editProfile":
                showEditProfile(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ===================== POST =====================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        switch (action) {

            case "updateProfile":
                updateProfile(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ===================== VIEW PROFILE =====================

    private void showProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        User user = (User) session.getAttribute("user");
        request.setAttribute("user", user);

        request.getRequestDispatcher("/views/customer/profile.jsp")
                .forward(request, response);
    }

    // ===================== SHOW EDIT PROFILE FORM =====================

    private void showEditProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        User user = (User) session.getAttribute("user");
        request.setAttribute("user", user);

        request.getRequestDispatcher("/views/customer/profileUpdate.jsp")
                .forward(request, response);
    }

    // ===================== UPDATE PROFILE =====================

    private void updateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        User user = (User) session.getAttribute("user");

        String fullName = request.getParameter("fullName");
        String email    = request.getParameter("email");
        String phone    = request.getParameter("phone");

        if (fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Full name is required");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/customer/profileUpdate.jsp")
                    .forward(request, response);
            return;
        }

        user.setFullName(fullName.trim());
        user.setEmail(email != null ? email.trim() : "");
        user.setPhone(phone != null ? phone.trim() : "");

        boolean success = userDAO.updateUserById(user);

        if (success) {
            session.setAttribute("user", user);
            session.setAttribute("successMessage", "Profile updated successfully!");
            response.sendRedirect(request.getContextPath() + "/customer?action=profile");
        } else {
            request.setAttribute("error", "Update failed. Please try again.");
            request.setAttribute("user", user);
            request.getRequestDispatcher("/views/customer/profileUpdate.jsp")
                    .forward(request, response);
        }
    }
}
