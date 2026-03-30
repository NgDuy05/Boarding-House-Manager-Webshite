package Filter;

import Models.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req     = (HttpServletRequest)  request;
        HttpServletResponse res     = (HttpServletResponse) response;
        HttpSession         session = req.getSession(false);

        String path  = req.getRequestURI();
        String query = req.getQueryString() != null ? req.getQueryString() : "";

        boolean loggedIn = (session != null && session.getAttribute("user") != null);

        boolean isPublicPath =
                path.contains("/auth")
                || path.contains("/login")
                || path.contains("/home")
                || path.contains("/views/login")
                || path.contains("/views/register")
                || path.contains("/views/forget")
                || path.contains("/views/guest/")
                || path.endsWith("/")
                || path.contains("assets/")
                || path.endsWith(".css")
                || path.endsWith(".js")
                || path.endsWith(".html")
                || path.endsWith(".png")
                || path.endsWith(".jpg")
                || path.endsWith(".jpeg")
                || path.endsWith(".webp")
                || path.endsWith(".gif")
                || path.endsWith(".ico")
                || path.endsWith(".woff")
                || path.endsWith(".woff2")
                || path.endsWith(".ttf");

        if (!loggedIn && !isPublicPath) {
            res.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }

        // Role-based guard: block customers from admin-only paths
        if (loggedIn) {
            User user = (User) session.getAttribute("user");
            if ("customer".equals(user.getRole())) {
                boolean isAdminOnlyPath =
                        // Bill admin actions (but not mybill or detail)
                        (path.contains("/bill") && (
                                query.contains("action=list")
                                || query.contains("action=ownerList")
                                || query.contains("action=create")
                                || query.contains("action=edit")
                                || query.contains("action=status")
                                || query.contains("action=delete")
                        ))
                        || path.contains("/manage-customer")
                        || path.contains("/user")
                        || path.contains("/utility")
                        || path.contains("/amenity")
                        || path.contains("/facility")
                        || path.contains("/activity-log")
                        || path.contains("/price")
                        || path.contains("/deposit");

                if (isAdminOnlyPath) {
                    res.sendRedirect(req.getContextPath() + "/dashboard");
                    return;
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
