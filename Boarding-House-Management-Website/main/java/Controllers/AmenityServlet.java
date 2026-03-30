package Controllers;

import DALs.AmenityDAO;
import Models.Amenity;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

public class AmenityServlet extends HttpServlet {

    private AmenityDAO amenityDAO;

    @Override
    public void init() {
        amenityDAO = new AmenityDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listAmenities(request, response);
                break;
            case "create":
                showCreateForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
            case "hide":
                deleteAmenity(request, response);
                break;
            case "restore":
                restoreAmenity(request, response);
                break;
            default:
                listAmenities(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/amenity");
            return;
        }

        switch (action) {
            case "insert":
                insertAmenity(request, response);
                break;
            case "update":
                updateAmenity(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/amenity");
        }
    }

    // ===================================================
    // AMENITY ACTIONS
    // ===================================================

    private void listAmenities(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Amenity> amenities = amenityDAO.getAllAmenities();
        request.setAttribute("amenities", amenities);
        request.getRequestDispatcher("/views/admin/amenities/amenities.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/views/admin/amenities/createAmenity.jsp").forward(request, response);
    }

    private void insertAmenity(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Amenity a = new Amenity();
        a.setAmenityName(request.getParameter("amenityName"));
        a.setDescription(request.getParameter("description"));
        amenityDAO.insertAmenity(a);
        response.sendRedirect(request.getContextPath() + "/amenity");
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Amenity amenity = amenityDAO.getAmenityById(id);
        request.setAttribute("amenity", amenity);
        request.getRequestDispatcher("/views/admin/amenities/editAmenity.jsp").forward(request, response);
    }

    private void updateAmenity(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Amenity a = new Amenity();
        a.setAmenityId(Integer.parseInt(request.getParameter("amenityId")));
        a.setAmenityName(request.getParameter("amenityName"));
        a.setDescription(request.getParameter("description"));
        amenityDAO.updateAmenity(a);
        response.sendRedirect(request.getContextPath() + "/amenity");
    }

    private void deleteAmenity(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        amenityDAO.deleteAmenity(id);
        response.sendRedirect(request.getContextPath() + "/amenity");
    }

    private void restoreAmenity(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        amenityDAO.restoreAmenity(id);
        response.sendRedirect(request.getContextPath() + "/amenity");
    }
}
