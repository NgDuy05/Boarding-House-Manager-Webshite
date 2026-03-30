package Controllers;

import DALs.UserDAO;
import Models.User;
import Utils.EmailService;
import Utils.OtpStore;

import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AuthServlet extends HttpServlet {

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
            showLogin(request, response);
            return;
        }

        switch (action) {

            case "login":
                showLogin(request, response);
                break;

            case "register":
                showRegister(request, response);
                break;

            case "logout":
                logout(request, response);
                break;

            case "forgetPassword":
                showForgetPassword(request, response);
                break;

            case "changePassword":
                showChangePassword(request, response);
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

            case "login":
                login(request, response);
                break;

            case "register":
                register(request, response);
                break;

            case "changePassword":
                changePassword(request, response);
                break;

            // Step 1: look up account by email, send OTP
            case "verifyReset":
                verifyReset(request, response);
                break;

            // Step 2: verify the OTP code
            case "verifyOtp":
                verifyOtp(request, response);
                break;

            // Step 3: set new password
            case "doResetPassword":
                doResetPassword(request, response);
                break;

            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ===================== SHOW FORMS =====================

    private void showLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    private void showRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(request.getContextPath() + "/dashboard");
            return;
        }
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }

    private void showForgetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("phase", 1);
        request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
    }

    private void showChangePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }
        request.getRequestDispatcher("/views/customer/changePassword.jsp").forward(request, response);
    }

    // ===================== LOGIN =====================

    private void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("error", "Incorrect username or password");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }

    // ===================== REGISTER =====================

    private void register(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username  = request.getParameter("username");
        String password  = request.getParameter("password");
        String confirm   = request.getParameter("confirmPassword");
        String fullName  = request.getParameter("fullName");
        String email     = request.getParameter("email");
        String phone     = request.getParameter("phone");

        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        if (confirm != null && !confirm.isEmpty() && !confirm.equals(password)) {
            request.setAttribute("error", "Passwords do not match");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        if (userDAO.existsByUsername(username.trim())) {
            request.setAttribute("error", "Username is already taken");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        User user = new User();
        user.setUsername(username.trim());
        user.setPassword(password);
        user.setFullName(fullName != null ? fullName.trim() : "");
        user.setEmail(email != null ? email.trim() : "");
        user.setPhone(phone != null ? phone.trim() : "");
        user.setRole("customer");
        user.setImage("default.png");

        boolean success = userDAO.register(user);

        if (success) {
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Account created successfully! Please sign in.");
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }

    // ===================== LOGOUT =====================

    private void logout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
  
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }

    // ===================== CHANGE PASSWORD =====================

    private void changePassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
            return;
        }

        User user = (User) session.getAttribute("user");

        String oldPassword     = request.getParameter("oldPassword");
        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (oldPassword == null || oldPassword.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all fields");
            request.getRequestDispatcher("/views/customer/changePassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "New passwords do not match");
            request.getRequestDispatcher("/views/customer/changePassword.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "New password must be at least 6 characters");
            request.getRequestDispatcher("/views/customer/changePassword.jsp").forward(request, response);
            return;
        }

        boolean success = userDAO.changePassword(user.getUserId(), oldPassword, newPassword);

        if (success) {
            request.setAttribute("success", "Password changed successfully!");
            request.getRequestDispatcher("/views/customer/changePassword.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Current password is incorrect");
            request.getRequestDispatcher("/views/customer/changePassword.jsp").forward(request, response);
        }
    }

    // ===================== RESET PASSWORD — STEP 1: LOOK UP ACCOUNT & SEND OTP =====================

    private void verifyReset(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your email address");
            request.setAttribute("phase", 1);
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
            return;
        }

        // Look up any active account with this email
        User user = userDAO.findByEmail(email.trim());

        if (user == null) {
            // Generic message to avoid email enumeration
            request.setAttribute("info", "If this email is registered, an OTP has been sent to your inbox.");
            request.setAttribute("phase", 2);
            request.setAttribute("maskedEmail", maskEmail(email.trim()));
            HttpSession session = request.getSession();
            session.setAttribute("resetEmail", email.trim());
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
            return;
        }

        // Generate and send OTP
        String otp = OtpStore.getInstance().generate(email.trim());

        try {
            EmailService.getInstance().sendOtpEmail(email.trim(), otp);
        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to send email. Please try again later.");
            request.setAttribute("phase", 1);
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
            return;
        }

        // Store email in session to use in later steps
        HttpSession session = request.getSession();
        session.setAttribute("resetEmail", email.trim());

        request.setAttribute("phase", 2);
        request.setAttribute("maskedEmail", maskEmail(email.trim()));
        request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
    }

    // ===================== RESET PASSWORD — STEP 2: VERIFY OTP =====================

    private void verifyOtp(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("resetEmail") == null) {
            request.setAttribute("error", "Session expired. Please try again.");
            request.setAttribute("phase", 1);
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
            return;
        }

        String resetEmail = (String) session.getAttribute("resetEmail");
        String otp        = request.getParameter("otp");

        if (otp == null || otp.trim().isEmpty()) {
            request.setAttribute("error", "Please enter the OTP code");
            request.setAttribute("phase", 2);
            request.setAttribute("maskedEmail", maskEmail(resetEmail));
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
            return;
        }

        if (!OtpStore.getInstance().verify(resetEmail, otp.trim())) {
            request.setAttribute("error", "Invalid or expired OTP code");
            request.setAttribute("phase", 2);
            request.setAttribute("maskedEmail", maskEmail(resetEmail));
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
            return;
        }

        // OTP correct — consume it and advance to password reset step
        OtpStore.getInstance().remove(resetEmail);
        session.setAttribute("otpVerified", true);

        request.setAttribute("phase", 3);
        request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
    }

    // ===================== RESET PASSWORD — STEP 3: SET NEW PASSWORD =====================

    private void doResetPassword(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("resetEmail") == null
                || !Boolean.TRUE.equals(session.getAttribute("otpVerified"))) {
            request.setAttribute("error", "Session expired. Please try again.");
            request.setAttribute("phase", 1);
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
            return;
        }

        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Please enter a new password");
            request.setAttribute("phase", 3);
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match");
            request.setAttribute("phase", 3);
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
            return;
        }

        if (newPassword.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters");
            request.setAttribute("phase", 3);
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
            return;
        }

        String resetEmail = (String) session.getAttribute("resetEmail");
        User   user       = userDAO.findByEmail(resetEmail);

        if (user == null) {
            request.setAttribute("error", "Account not found. Please try again.");
            request.setAttribute("phase", 1);
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
            return;
        }

        boolean success = userDAO.resetPassword(user.getUserId(), newPassword);

        // Clean up session
        session.removeAttribute("resetEmail");
        session.removeAttribute("otpVerified");

        if (success) {
            session.setAttribute("successMessage", "Password reset successfully! Please sign in.");
            response.sendRedirect(request.getContextPath() + "/auth?action=login");
        } else {
            request.setAttribute("error", "Failed to reset password. Please try again.");
            request.setAttribute("phase", 1);
            request.getRequestDispatcher("/views/forgetPassword.jsp").forward(request, response);
        }
    }

    // ===================== HELPERS =====================

    /**
     * Mask email for display: e.g. "user@example.com" → "us**@example.com"
     */
    private String maskEmail(String email) {
        int at = email.indexOf('@');
        if (at <= 2) return email;
        return email.substring(0, 2) + "**" + email.substring(at);
    }
}
