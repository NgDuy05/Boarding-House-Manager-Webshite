package DALs;

import Models.Amenity;
import Utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AmenityDAO extends DBContext {

    // =====================================================
    // AMENITY CRUD
    // =====================================================

    public List<Amenity> getAllAmenities() {
        List<Amenity> list = new ArrayList<>();
        String sql = "SELECT amenity_id, amenity_name, description, created_at, is_deleted "
                + "FROM amenity ORDER BY is_deleted ASC, amenity_name ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapAmenity(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Amenity getAmenityById(int id) {
        String sql = "SELECT amenity_id, amenity_name, description, created_at, is_deleted "
                + "FROM amenity WHERE amenity_id = ? AND is_deleted = 0";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapAmenity(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insertAmenity(Amenity a) {
        String sql = "INSERT INTO amenity (amenity_name, description, is_deleted) VALUES (?, ?, 0)";
        try {
            PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, a.getAmenityName());
            st.setString(2, a.getDescription());
            int affected = st.executeUpdate();
            if (affected > 0) {
                ResultSet keys = st.getGeneratedKeys();
                if (keys.next()) {
                    return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public void updateAmenity(Amenity a) {
        String sql = "UPDATE amenity SET amenity_name = ?, description = ? WHERE amenity_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, a.getAmenityName());
            st.setString(2, a.getDescription());
            st.setInt(3, a.getAmenityId());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteAmenity(int id) {
        String sql = "UPDATE amenity SET is_deleted = 1 WHERE amenity_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void restoreAmenity(int id) {
        String sql = "UPDATE amenity SET is_deleted = 0 WHERE amenity_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Amenity mapAmenity(ResultSet rs) throws SQLException {
        Amenity a = new Amenity();
        a.setAmenityId(rs.getInt("amenity_id"));
        a.setAmenityName(rs.getString("amenity_name"));
        a.setDescription(rs.getString("description"));
        a.setIsDeleted(rs.getBoolean("is_deleted"));
        return a;
    }

    // =====================================================
    // ROOM_AMENITY (assignment of amenities to rooms)
    // =====================================================

    public List<Amenity> getAmenitiesByRoomId(int roomId) {
        List<Amenity> list = new ArrayList<>();
        String sql = "SELECT a.amenity_id, a.amenity_name, a.description, a.created_at, a.is_deleted "
                + "FROM amenity a "
                + "JOIN room_amenity ra ON a.amenity_id = ra.amenity_id "
                + "WHERE ra.room_id = ? AND a.is_deleted = 0 "
                + "ORDER BY a.amenity_name";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapAmenity(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void assignAmenityToRoom(int roomId, int amenityId) {
        String sql = "IF NOT EXISTS (SELECT 1 FROM room_amenity WHERE room_id = ? AND amenity_id = ?) "
                + "INSERT INTO room_amenity (room_id, amenity_id) VALUES (?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomId);
            st.setInt(2, amenityId);
            st.setInt(3, roomId);
            st.setInt(4, amenityId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void removeAmenityFromRoom(int roomId, int amenityId) {
        String sql = "DELETE FROM room_amenity WHERE room_id = ? AND amenity_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomId);
            st.setInt(2, amenityId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void removeAllAmenitiesFromRoom(int roomId) {
        String sql = "DELETE FROM room_amenity WHERE room_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Integer> getAmenityIdsByRoomId(int roomId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT amenity_id FROM room_amenity WHERE room_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("amenity_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return ids;
    }
}
