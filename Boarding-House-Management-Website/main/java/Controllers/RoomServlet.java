package Controllers;

import DALs.ContractDAO;
import DALs.FacilityDAO;
import DALs.RoomCategoryDAO;
import DALs.RoomDAO;
import Models.Room;
import Models.RoomAmenity;
import Models.RoomCategory;
import Models.ContractTenant;
import Models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class RoomServlet extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private RoomDAO         roomDAO;
    private RoomCategoryDAO categoryDAO;
    private FacilityDAO     facilityDAO;
    private ContractDAO     contractDAO;

    @Override
    public void init() {
        roomDAO     = new RoomDAO();
        categoryDAO = new RoomCategoryDAO();
        facilityDAO = new FacilityDAO();
        contractDAO = new ContractDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "categories";

        switch (action) {

            // ── Customer-facing ──────────────────────────────────────────────
            case "categories":
                showCategories(request, response);
                break;

            case "publicList":
                showPublicList(request, response);
                break;

            case "publicDetail":
                showPublicDetail(request, response);
                break;

            // ── Admin ────────────────────────────────────────────────────────
            case "list":
                listRooms(request, response);
                break;

            case "create":
                showCreateForm(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "delete":
                deleteRoom(request, response);
                break;

            case "detail":
                showDetail(request, response);
                break;

            default:
                listRooms(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        switch (action) {
            case "create":
                insertRoom(request, response);
                break;
            case "edit":
                updateRoom(request, response);
                break;
        }
    }

    // ================= CUSTOMER: CATEGORIES =================
    private void showCategories(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Fresh DAO instances per request to avoid stale singleton connections
        RoomDAO freshRoomDAO         = new RoomDAO();
        RoomCategoryDAO freshCatDAO  = new RoomCategoryDAO();

        List<RoomCategory> categories    = freshCatDAO.getAllCategoriesWithCount();
        List<Room>         allRooms      = freshRoomDAO.getAllRooms();
        Map<String, Integer> statusCounts = freshRoomDAO.getCountByStatus();

        request.setAttribute("categories",   categories);
        request.setAttribute("allRooms",     allRooms);
        request.setAttribute("statusCounts", statusCounts);
        request.getRequestDispatcher("/views/customer/roomCategories.jsp")
                .forward(request, response);
    }

    // ================= CUSTOMER: PUBLIC LIST =================
    // Supports filtering by categoryId and/or status
    private void showPublicList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String categoryParam = request.getParameter("categoryId");
        String statusParam   = request.getParameter("status");

        List<Room> rooms;
        int    activeCategoryId = 0;
        String activeStatus     = "";

        boolean hasCategory = categoryParam != null && !categoryParam.trim().isEmpty();
        boolean hasStatus   = statusParam   != null && !statusParam.trim().isEmpty();

        if (hasCategory) {
            activeCategoryId = Integer.parseInt(categoryParam.trim());
            if (hasStatus) {
                activeStatus = statusParam.trim();
                rooms = roomDAO.getRoomsByCategoryAndStatus(activeCategoryId, activeStatus);
            } else {
                rooms = roomDAO.getRoomsByCategoryId(activeCategoryId);
            }
        } else if (hasStatus) {
            activeStatus = statusParam.trim();
            rooms = roomDAO.getByStatus(activeStatus);
        } else {
            rooms = roomDAO.getAllRooms();
        }

        List<RoomCategory>   categories   = categoryDAO.getAllCategories();
        Map<String, Integer> statusCounts = roomDAO.getCountByStatus();

        int totalItems = rooms.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));
        int page = parsePage(request.getParameter("page"), totalPages);
        int from = (page - 1) * PAGE_SIZE;
        int to   = Math.min(from + PAGE_SIZE, totalItems);
        List<Room> pageRooms = (from < totalItems) ? rooms.subList(from, to) : Collections.emptyList();

        request.setAttribute("rooms",            pageRooms);
        request.setAttribute("categories",       categories);
        request.setAttribute("statusCounts",     statusCounts);
        request.setAttribute("activeCategoryId", activeCategoryId);
        request.setAttribute("activeStatus",     activeStatus);
        request.setAttribute("currentPage",      page);
        request.setAttribute("totalPages",       totalPages);
        request.setAttribute("totalItems",       totalItems);
        request.setAttribute("pageSize",         PAGE_SIZE);
        request.getRequestDispatcher("/views/customer/rooms.jsp")
                .forward(request, response);
    }

    // ================= CUSTOMER: PUBLIC DETAIL + AMENITIES =================
    private void showPublicDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Room room = roomDAO.getRoomById(id);
        List<RoomAmenity> amenities = facilityDAO.getAmenitiesByRoomId(id);

        // Fetch full category info for base price display
        RoomCategory category = null;
        if (room != null && room.getCategoryId() > 0) {
            category = categoryDAO.getCategoryById(room.getCategoryId());
        }

        // Tell the JSP whether the current customer already has an active contract
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if ("customer".equalsIgnoreCase(user.getRole())) {
                boolean alreadyHasContract = contractDAO.hasActiveContract(user.getUserId());
                request.setAttribute("alreadyHasContract", alreadyHasContract);
            }
        }

        request.setAttribute("room",      room);
        request.setAttribute("amenities", amenities);
        request.setAttribute("category",  category);
        request.getRequestDispatcher("/views/customer/roomDetail.jsp")
                .forward(request, response);
    }

    // ================= LIST (admin) =================
    private void listRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Room> allRooms  = roomDAO.getAllRooms();
        List<RoomCategory> categories = categoryDAO.getAllCategories();

        int totalItems = allRooms.size();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalItems / PAGE_SIZE));
        int page = parsePage(request.getParameter("page"), totalPages);
        int from = (page - 1) * PAGE_SIZE;
        int to   = Math.min(from + PAGE_SIZE, totalItems);
        List<Room> rooms = (from < totalItems) ? allRooms.subList(from, to) : Collections.emptyList();

        request.setAttribute("rooms",       rooms);
        request.setAttribute("categories",  categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages",  totalPages);
        request.setAttribute("totalItems",  totalItems);
        request.setAttribute("pageSize",    PAGE_SIZE);
        request.getRequestDispatcher("/views/admin/rooms/rooms.jsp")
                .forward(request, response);
    }

    // ================= CREATE (admin) =================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<RoomCategory> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/admin/rooms/createRoom.jsp")
                .forward(request, response);
    }

    private void insertRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String roomNumber    = request.getParameter("roomNumber");
        String status        = request.getParameter("status");
        String image         = request.getParameter("image");
        String categoryParam = request.getParameter("categoryId");

        Room room = new Room();
        room.setRoomNumber(roomNumber);
        room.setStatus(status);
        room.setImage(image);
        if (categoryParam != null && !categoryParam.isEmpty()) {
            room.setCategoryId(Integer.parseInt(categoryParam));
        }
        roomDAO.insertRoom(room);
        response.sendRedirect("room?action=list");
    }

    // ================= EDIT (admin) =================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        Room room = roomDAO.getRoomById(id);
        List<RoomCategory> categories = categoryDAO.getAllCategories();
        request.setAttribute("room",       room);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/admin/rooms/editRoom.jsp")
                .forward(request, response);
    }

    private void updateRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int    id            = Integer.parseInt(request.getParameter("id"));
        String roomNumber    = request.getParameter("roomNumber");
        String status        = request.getParameter("status");
        String image         = request.getParameter("image");
        String categoryParam = request.getParameter("categoryId");

        Room room = new Room();
        room.setRoomId(id);
        room.setRoomNumber(roomNumber);
        room.setStatus(status);
        room.setImage(image);
        if (categoryParam != null && !categoryParam.isEmpty()) {
            room.setCategoryId(Integer.parseInt(categoryParam));
        }
        roomDAO.updateRoom(room);
        response.sendRedirect("room?action=list");
    }

    // ================= DELETE (admin) =================
    private void deleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        roomDAO.deleteRoom(id);
        response.sendRedirect("room?action=list");
    }

    // ================= DETAIL (admin) =================
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int  id   = Integer.parseInt(request.getParameter("id"));
        Room room = roomDAO.getRoomById(id);
        request.setAttribute("room", room);
        // Pass resident history for this room
        request.setAttribute("tenantHistory", contractDAO.getTenantHistoryByRoomId(id));
        request.getRequestDispatcher("/views/admin/rooms/roomDetail.jsp")
                .forward(request, response);
    }

    // ================= PAGINATION HELPER =================
    private int parsePage(String param, int totalPages) {
        int page = 1;
        if (param != null) {
            try { page = Integer.parseInt(param); } catch (NumberFormatException ignored) {}
        }
        return Math.min(Math.max(page, 1), totalPages);
    }
}
