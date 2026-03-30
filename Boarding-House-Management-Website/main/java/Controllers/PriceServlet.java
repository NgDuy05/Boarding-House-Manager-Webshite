package Controllers;

import DALs.PriceDAO;
import Models.PriceCategory;
import Models.PriceHistory;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class PriceServlet extends HttpServlet {

    private PriceDAO priceDAO;

    @Override
    public void init() {
        priceDAO = new PriceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            listCategories(request, response);
            return;
        }

        switch (action) {

            case "categories":
                listCategories(request, response);
                break;

            case "prices":
                listPrices(request, response);
                break;

            case "create":
                showCreateForm(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "delete":
                deletePrice(request, response);
                break;

            default:
                listCategories(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            insertPrice(request, response);
        } else if ("edit".equals(action)) {
            updatePrice(request, response);
        }
    }

    // ================= LIST CATEGORIES =================
    private void listCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<PriceCategory> categories = priceDAO.getAllPriceCategories();

        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/views/admin/prices/priceCategories.jsp")
                .forward(request, response);
    }

    // ================= LIST PRICES =================
    private void listPrices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<PriceHistory> list = priceDAO.getAllPrices();

        request.setAttribute("priceList", list);

        request.getRequestDispatcher("/views/admin/prices/priceCategories.jsp")
                .forward(request, response);
    }

    // ================= CREATE FORM =================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/admin/prices/createPriceCategory.jsp")
                .forward(request, response);
    }

    // ================= INSERT CATEGORY =================
    private void insertPrice(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String categoryCode = request.getParameter("categoryCode");
        String categoryType = request.getParameter("categoryType");
        String unit         = request.getParameter("unit");

        PriceCategory cat = new PriceCategory();
        cat.setCategoryCode(categoryCode != null ? categoryCode.trim() : "");
        cat.setCategoryType(categoryType != null ? categoryType.trim() : "");
        cat.setUnit(unit != null ? unit.trim() : "");

        priceDAO.insertCategory(cat);

        response.sendRedirect(request.getContextPath() + "/price");
    }

    // ================= EDIT FORM =================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        PriceCategory category = priceDAO.getCategoryById(id);
        request.setAttribute("category", category);
        request.getRequestDispatcher("/views/admin/prices/editPriceCategory.jsp")
                .forward(request, response);
    }

    // ================= UPDATE CATEGORY =================
    private void updatePrice(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int    categoryId   = Integer.parseInt(request.getParameter("categoryId"));
        String categoryCode = request.getParameter("categoryCode");
        String categoryType = request.getParameter("categoryType");
        String unit         = request.getParameter("unit");

        PriceCategory cat = new PriceCategory();
        cat.setCategoryId(categoryId);
        cat.setCategoryCode(categoryCode != null ? categoryCode.trim() : "");
        cat.setCategoryType(categoryType != null ? categoryType.trim() : "");
        cat.setUnit(unit != null ? unit.trim() : "");

        priceDAO.updateCategory(cat);

        response.sendRedirect(request.getContextPath() + "/price");
    }

    // ================= DELETE =================
    private void deletePrice(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        priceDAO.deletePrice(id);

        response.sendRedirect("priceCategories");
    }
}
