package DALs;

import Models.Facility;
import Utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FacilityDAO extends DBContext {

    // ===============================
    // GET ALL FACILITIES
    // ===============================
    public List<Facility> getAllFacilities() {
        List<Facility> list = new ArrayList<>();
        String sql = "SELECT facility_id, facility_name, category_id, description, image, is_deleted "
                + "FROM facility WHERE is_deleted = 0 ORDER BY facility_name";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapFacility(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
    // GET FACILITY BY ID
    // ===============================
    public Facility getFacilityById(int id) {
        String sql = "SELECT facility_id, facility_name, category_id, description, image, is_deleted "
                + "FROM facility WHERE facility_id = ? AND is_deleted = 0";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapFacility(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===============================
    // GET FACILITIES BY ROOM
    // ===============================
    public List<Facility> getFacilitiesByRoom(int roomId) {
        List<Facility> list = new ArrayList<>();
        String sql = "SELECT f.facility_id, f.facility_name, f.category_id, f.description, f.image, f.is_deleted "
                + "FROM facility f "
                + "INNER JOIN room_facility rf ON f.facility_id = rf.facility_id "
                + "WHERE rf.room_id = ? AND f.is_deleted = 0 AND rf.is_deleted = 0";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapFacility(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
    // GET AMENITIES (facility + quantity) BY ROOM
    // ===============================
    public List<Models.RoomAmenity> getAmenitiesByRoomId(int roomId) {
        List<Models.RoomAmenity> list = new ArrayList<>();
        String sql = "SELECT f.facility_id, f.facility_name, f.description, f.image, rf.quantity "
                + "FROM facility f "
                + "INNER JOIN room_facility rf ON f.facility_id = rf.facility_id "
                + "WHERE rf.room_id = ? "
                + "  AND ISNULL(rf.is_deleted, 0) = 0 "
                + "  AND ISNULL(f.is_deleted,  0) = 0";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(new Models.RoomAmenity(
                        rs.getInt("facility_id"),
                        rs.getString("facility_name"),
                        rs.getString("description"),
                        rs.getString("image"),
                        rs.getInt("quantity")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
    // INSERT FACILITY
    // ===============================
    public void insertFacility(Facility f) {
        String sql = "INSERT INTO facility (facility_name, category_id, description, image, is_deleted) "
                + "VALUES (?, ?, ?, ?, 0)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, f.getFacilityName());
            st.setInt(2, f.getCategoryId());
            st.setString(3, f.getDescription());
            st.setString(4, f.getImage());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // UPDATE FACILITY
    // ===============================
    public void updateFacility(Facility f) {
        String sql = "UPDATE facility SET facility_name = ?, category_id = ?, description = ?, image = ? "
                + "WHERE facility_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, f.getFacilityName());
            st.setInt(2, f.getCategoryId());
            st.setString(3, f.getDescription());
            st.setString(4, f.getImage());
            st.setInt(5, f.getFacilityId());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // SOFT DELETE
    // ===============================
    public void deleteFacility(int id) {
        String sql = "UPDATE facility SET is_deleted = 1 WHERE facility_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // UPSERT ROOM_FACILITY (insert or update quantity)
    // ===============================
    public boolean upsertRoomFacility(int roomId, int facilityId, int quantity) {
        // Try update first; if no rows affected, insert
        String updateSql = "UPDATE room_facility SET quantity = ?, is_deleted = 0 "
                + "WHERE room_id = ? AND facility_id = ?";
        String insertSql = "INSERT INTO room_facility (room_id, facility_id, quantity, is_deleted) "
                + "VALUES (?, ?, ?, 0)";
        try {
            PreparedStatement upd = connection.prepareStatement(updateSql);
            upd.setInt(1, quantity);
            upd.setInt(2, roomId);
            upd.setInt(3, facilityId);
            if (upd.executeUpdate() == 0) {
                PreparedStatement ins = connection.prepareStatement(insertSql);
                ins.setInt(1, roomId);
                ins.setInt(2, facilityId);
                ins.setInt(3, quantity);
                ins.executeUpdate();
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // ===============================
    // SOFT-DELETE ALL ROOM_FACILITY ROWS FOR A ROOM
    // ===============================
    public void softDeleteRoomFacilities(int roomId) {
        String sql = "UPDATE room_facility SET is_deleted = 1 WHERE room_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // MAP ResultSet → Facility
    // ===============================
    private Facility mapFacility(ResultSet rs) throws SQLException {
        return new Facility(
                rs.getInt("facility_id"),
                rs.getString("facility_name"),
                rs.getInt("category_id"),
                rs.getString("description"),
                rs.getString("image"),
                rs.getBoolean("is_deleted")
        );
    }
}
