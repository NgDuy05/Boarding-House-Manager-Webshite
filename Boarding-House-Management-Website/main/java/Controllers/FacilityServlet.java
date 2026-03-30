package Controllers;

import DALs.FacilityDAO;
import Models.Facility;
import Models.RoomAmenity;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class FacilityServlet extends HttpServlet {

    private FacilityDAO facilityDAO;

    @Override
    public void init() {
        facilityDAO = new FacilityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {

            case "list":
                listFacilities(request, response);
                break;

            case "detail":
                showDetail(request, response);
                break;

            case "create":
                showCreateForm(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "delete":
                deleteFacility(request, response);
                break;

            case "byRoom":
                facilitiesByRoom(request, response);
                break;

            default:
                listFacilities(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect("facility");
            return;
        }

        switch (action) {

            case "create":
                insertFacility(request, response);
                break;

            case "edit":
                updateFacility(request, response);
                break;

            default:
                response.sendRedirect("facility");
        }
    }

    // ================= LIST =================
    private void listFacilities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Facility> facilities = facilityDAO.getAllFacilities();

        request.setAttribute("facilities", facilities);

        request.getRequestDispatcher("/views/admin/facilities/facilities.jsp")
                .forward(request, response);
    }

    // ================= DETAIL =================
    private void showDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Facility facility = facilityDAO.getFacilityById(id);

        request.setAttribute("facility", facility);

        request.getRequestDispatcher("/views/admin/facilities/facilityDetail.jsp")
                .forward(request, response);
    }

    // ================= CREATE FORM =================
    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/admin/facilities/createFacility.jsp")
                .forward(request, response);
    }

    // ================= INSERT =================
    private void insertFacility(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String name = request.getParameter("facilityName");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String description = request.getParameter("description");
        String image = request.getParameter("image");

        Facility f = new Facility();
        f.setFacilityName(name);
        f.setCategoryId(categoryId);
        f.setDescription(description);
        f.setImage(image);

        facilityDAO.insertFacility(f);

        response.sendRedirect("facility");
    }

    // ================= EDIT FORM =================
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        Facility facility = facilityDAO.getFacilityById(id);

        request.setAttribute("facility", facility);

        request.getRequestDispatcher("/views/admin/facilities/editFacility.jsp")
                .forward(request, response);
    }

    // ================= UPDATE =================
    private void updateFacility(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("facilityId"));
        String name = request.getParameter("facilityName");
        int categoryId = Integer.parseInt(request.getParameter("categoryId"));
        String description = request.getParameter("description");
        String image = request.getParameter("image");

        Facility f = new Facility();
        f.setFacilityId(id);
        f.setFacilityName(name);
        f.setCategoryId(categoryId);
        f.setDescription(description);
        f.setImage(image);

        facilityDAO.updateFacility(f);

        response.sendRedirect("facility");
    }

    // ================= DELETE =================
    private void deleteFacility(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(request.getParameter("id"));

        facilityDAO.deleteFacility(id);

        response.sendRedirect("facility");
    }

    // ================= BY ROOM (JSON for AJAX) =================
    private void facilitiesByRoom(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int roomId = 0;
        try { roomId = Integer.parseInt(request.getParameter("roomId")); }
        catch (NumberFormatException e) {
            response.getWriter().write("[]");
            return;
        }
        List<RoomAmenity> list = facilityDAO.getAmenitiesByRoomId(roomId);
        StringBuilder json = new StringBuilder("[");
        for (int i = 0; i < list.size(); i++) {
            RoomAmenity a = list.get(i);
            json.append("{\"facilityId\":").append(a.getFacilityId())
                .append(",\"facilityName\":\"").append(a.getFacilityName().replace("\"", "\\\""))
                .append("\",\"quantity\":").append(a.getQuantity()).append("}");
            if (i < list.size() - 1) json.append(",");
        }
        json.append("]");
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(json.toString());
    }
}
