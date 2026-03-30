package Controllers;

import DALs.RoomDAO;
import DALs.UtilityDAO;
import Models.Room;
import Models.Utility;
import Models.UtilityPrice;
import Models.UtilityUsage;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.Collections;
import java.util.List;

public class UtilityServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private UtilityDAO utilityDAO;
    private RoomDAO roomDAO;

    @Override
    public void init() {
        utilityDAO = new UtilityDAO();
        roomDAO = new RoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listUtilities(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
            case "hide":
                deleteUtility(request, response);
                break;
            case "restore":
                restoreUtility(request, response);
                break;
            case "detail":
                showDetail(request, response);
                break;
            case "addPrice":
                showAddPriceForm(request, response);
                break;
            case "editPrice":
                showEditPriceForm(request, response);
                break;
            case "deletePrice":
                deletePrice(request, response);
                break;
            case "addUsage":
                showAddUsageForm(request, response);
                break;
            case "editUsage":
                showEditUsageForm(request, response);
                break;
            case "deleteUsage":
                deleteUsage(request, response);
                break;
            default:
                listUtilities(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/utility");
            return;
        }

        switch (action) {
            case "insert":
                insertUtility(request, response);
                break;
            case "update":
                updateUtility(request, response);
                break;
            case "insertPrice":
                insertPrice(request, response);
                break;
            case "updatePrice":
                updatePrice(request, response);
                break;
            case "insertUsage":
                insertUsage(request, response);
                break;
            case "updateUsage":
                updateUsage(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/utility");
        }
    }

    // ===================================================
    // UTILITY ACTIONS
    // ===================================================

    private void listUtilities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Utility> all = utilityDAO.getAllUtilities();
        int totalItems = all.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try { page = Integer.parseInt(pageParam); } catch (NumberFormatException ignored) {}
        }
        page = Math.min(Math.max(page, 1), totalPages);
        int from = (page - 1) * PAGE_SIZE;
        int to   = Math.min(from + PAGE_SIZE, totalItems);
        List<Utility> utilities = (from < totalItems) ? all.subList(from, to) : Collections.emptyList();

        request.setAttribute("utilities",   utilities);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages",  totalPages);
        request.setAttribute("totalItems",  totalItems);
        request.setAttribute("pageSize",    PAGE_SIZE);
        request.getRequestDispatcher("/views/admin/utilities/utilities.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/utilities/createUtility.jsp").forward(request, response);
    }

    private void insertUtility(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Utility u = new Utility();
        u.setUtilityName(request.getParameter("utilityName"));
        u.setUnit(request.getParameter("unit"));
        u.setDescription(request.getParameter("description"));
        utilityDAO.insertUtility(u);
        response.sendRedirect(request.getContextPath() + "/utility");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Utility utility = utilityDAO.getUtilityById(id);
        request.setAttribute("utility", utility);
        request.getRequestDispatcher("/views/admin/utilities/editUtility.jsp").forward(request, response);
    }

    private void updateUtility(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Utility u = new Utility();
        u.setUtilityId(Integer.parseInt(request.getParameter("utilityId")));
        u.setUtilityName(request.getParameter("utilityName"));
        u.setUnit(request.getParameter("unit"));
        u.setDescription(request.getParameter("description"));
        utilityDAO.updateUtility(u);
        response.sendRedirect(request.getContextPath() + "/utility");
    }

    private void deleteUtility(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        utilityDAO.deleteUtility(id);
        response.sendRedirect(request.getContextPath() + "/utility");
    }

    private void restoreUtility(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        utilityDAO.restoreUtility(id);
        response.sendRedirect(request.getContextPath() + "/utility");
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Utility utility = utilityDAO.getUtilityById(id);
        List<UtilityPrice> prices = utilityDAO.getPricesByUtilityId(id);
        List<UtilityUsage> usages = utilityDAO.getUsagesByUtilityId(id);
        request.setAttribute("utility", utility);
        request.setAttribute("prices", prices);
        request.setAttribute("usages", usages);
        request.getRequestDispatcher("/views/admin/utilities/utilityDetail.jsp").forward(request, response);
    }

    // ===================================================
    // PRICE ACTIONS
    // ===================================================

    private void showAddPriceForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int utilityId = Integer.parseInt(request.getParameter("utilityId"));
        Utility utility = utilityDAO.getUtilityById(utilityId);
        request.setAttribute("utility", utility);
        request.getRequestDispatcher("/views/admin/utilities/addPrice.jsp").forward(request, response);
    }

    private void insertPrice(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int utilityId = Integer.parseInt(request.getParameter("utilityId"));
        UtilityPrice p = new UtilityPrice();
        p.setUtilityId(utilityId);
        p.setPrice(new BigDecimal(request.getParameter("price")));
        p.setEffectiveFrom(Date.valueOf(request.getParameter("effectiveFrom")));
        utilityDAO.insertPrice(p);
        response.sendRedirect(request.getContextPath() + "/utility?action=detail&id=" + utilityId);
    }

    private void showEditPriceForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int priceId = Integer.parseInt(request.getParameter("id"));
        UtilityPrice price = utilityDAO.getPriceById(priceId);
        request.setAttribute("utilityPrice", price);
        request.getRequestDispatcher("/views/admin/utilities/editPrice.jsp").forward(request, response);
    }

    private void updatePrice(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int priceId = Integer.parseInt(request.getParameter("priceId"));
        int utilityId = Integer.parseInt(request.getParameter("utilityId"));
        UtilityPrice p = new UtilityPrice();
        p.setPriceId(priceId);
        p.setUtilityId(utilityId);
        p.setPrice(new BigDecimal(request.getParameter("price")));
        p.setEffectiveFrom(Date.valueOf(request.getParameter("effectiveFrom")));
        utilityDAO.updatePrice(p);
        response.sendRedirect(request.getContextPath() + "/utility?action=detail&id=" + utilityId);
    }

    private void deletePrice(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int priceId = Integer.parseInt(request.getParameter("id"));
        int utilityId = Integer.parseInt(request.getParameter("utilityId"));
        utilityDAO.deletePrice(priceId);
        response.sendRedirect(request.getContextPath() + "/utility?action=detail&id=" + utilityId);
    }

    // ===================================================
    // USAGE ACTIONS
    // ===================================================

    private void showAddUsageForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int utilityId = Integer.parseInt(request.getParameter("utilityId"));
        Utility utility = utilityDAO.getUtilityById(utilityId);
        List<Room> rooms = roomDAO.getAllRooms();
        request.setAttribute("utility", utility);
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("/views/admin/utilities/addUsage.jsp").forward(request, response);
    }

    private void insertUsage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int utilityId = Integer.parseInt(request.getParameter("utilityId"));
        UtilityUsage u = new UtilityUsage();
        u.setUtilityId(utilityId);
        u.setRoomId(Integer.parseInt(request.getParameter("roomId")));
        u.setPeriod(Date.valueOf(request.getParameter("period")));
        u.setOldValue(Integer.parseInt(request.getParameter("oldValue")));
        u.setNewValue(Integer.parseInt(request.getParameter("newValue")));
        utilityDAO.insertUsage(u);
        response.sendRedirect(request.getContextPath() + "/utility?action=detail&id=" + utilityId);
    }

    private void showEditUsageForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int usageId = Integer.parseInt(request.getParameter("id"));
        UtilityUsage usage = utilityDAO.getUsageById(usageId);
        List<Room> rooms = roomDAO.getAllRooms();
        List<Utility> utilities = utilityDAO.getAllUtilities();
        request.setAttribute("usage", usage);
        request.setAttribute("rooms", rooms);
        request.setAttribute("utilities", utilities);
        request.getRequestDispatcher("/views/admin/utilities/editUsage.jsp").forward(request, response);
    }

    private void updateUsage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int utilityId = Integer.parseInt(request.getParameter("utilityId"));
        UtilityUsage u = new UtilityUsage();
        u.setUsageId(Integer.parseInt(request.getParameter("usageId")));
        u.setUtilityId(utilityId);
        u.setRoomId(Integer.parseInt(request.getParameter("roomId")));
        u.setPeriod(Date.valueOf(request.getParameter("period")));
        u.setOldValue(Integer.parseInt(request.getParameter("oldValue")));
        u.setNewValue(Integer.parseInt(request.getParameter("newValue")));
        utilityDAO.updateUsage(u);
        response.sendRedirect(request.getContextPath() + "/utility?action=detail&id=" + utilityId);
    }

    private void deleteUsage(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int usageId = Integer.parseInt(request.getParameter("id"));
        int utilityId = Integer.parseInt(request.getParameter("utilityId"));
        utilityDAO.deleteUsage(usageId);
        response.sendRedirect(request.getContextPath() + "/utility?action=detail&id=" + utilityId);
    }
}
