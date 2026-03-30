package DALs;

import Models.Room;
import Utils.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class RoomDAO extends DBContext {

    private static final String SELECT_WITH_CAT =
        "SELECT r.room_id, r.room_number, r.status, r.image, r.is_deleted, " +
        "       r.category_id, rc.category_name, rc.base_price " +
        "FROM room r " +
        "LEFT JOIN room_category rc ON r.category_id = rc.category_id AND rc.is_deleted = 0 ";

    // ── Get all rooms ────────────────────────────────────────────────────────
    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        String sql = SELECT_WITH_CAT + "WHERE r.is_deleted = 0 ORDER BY r.room_number";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRoom(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── Get room by ID ───────────────────────────────────────────────────────
    public Room getRoomById(int id) {
        String sql = SELECT_WITH_CAT + "WHERE r.room_id = ? AND r.is_deleted = 0";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapRoom(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ── Filter by status ─────────────────────────────────────────────────────
    public List<Room> getByStatus(String status) {
        List<Room> list = new ArrayList<>();
        String sql = SELECT_WITH_CAT + "WHERE r.status = ? AND r.is_deleted = 0 ORDER BY r.room_number";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRoom(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── Filter by category ───────────────────────────────────────────────────
    public List<Room> getRoomsByCategoryId(int categoryId) {
        List<Room> list = new ArrayList<>();
        String sql = SELECT_WITH_CAT +
                     "WHERE r.category_id = ? AND r.is_deleted = 0 ORDER BY r.room_number";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRoom(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── Filter by category AND status ────────────────────────────────────────
    public List<Room> getRoomsByCategoryAndStatus(int categoryId, String status) {
        List<Room> list = new ArrayList<>();
        String sql = SELECT_WITH_CAT +
                     "WHERE r.category_id = ? AND r.status = ? AND r.is_deleted = 0 ORDER BY r.room_number";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, categoryId);
            st.setString(2, status);
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRoom(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── Available rooms only ─────────────────────────────────────────────────
    public List<Room> getAvailableRooms() {
        return getByStatus("available");
    }

    // ── Count rooms grouped by status ────────────────────────────────────────
    public Map<String, Integer> getCountByStatus() {
        Map<String, Integer> counts = new LinkedHashMap<>();
        counts.put("available",   0);
        counts.put("occupied",    0);
        counts.put("maintenance", 0);
        String sql = "SELECT status, COUNT(*) AS cnt FROM room WHERE is_deleted = 0 GROUP BY status";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) counts.put(rs.getString("status"), rs.getInt("cnt"));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return counts;
    }

    // ── Search by room number ─────────────────────────────────────────────────
    public List<Room> searchByNumber(String keyword) {
        List<Room> list = new ArrayList<>();
        String sql = SELECT_WITH_CAT +
                     "WHERE r.room_number LIKE ? AND r.is_deleted = 0 ORDER BY r.room_number";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, "%" + keyword + "%");
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRoom(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ── Insert ───────────────────────────────────────────────────────────────
    public void insertRoom(Room r) {
        String sql = "INSERT INTO room(room_number, status, image, category_id, is_deleted) " +
                     "VALUES (?, ?, ?, ?, 0)";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, r.getRoomNumber());
            st.setString(2, r.getStatus());
            st.setString(3, r.getImage());
            if (r.getCategoryId() > 0)
                st.setInt(4, r.getCategoryId());
            else
                st.setNull(4, Types.INTEGER);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ── Update ───────────────────────────────────────────────────────────────
    public void updateRoom(Room r) {
        String sql = "UPDATE room SET room_number = ?, status = ?, image = ?, category_id = ? " +
                     "WHERE room_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, r.getRoomNumber());
            st.setString(2, r.getStatus());
            st.setString(3, r.getImage());
            if (r.getCategoryId() > 0)
                st.setInt(4, r.getCategoryId());
            else
                st.setNull(4, Types.INTEGER);
            st.setInt(5, r.getRoomId());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ── Soft delete ──────────────────────────────────────────────────────────
    public void deleteRoom(int id) {
        String sql = "UPDATE room SET is_deleted = 1 WHERE room_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ── Update status only ───────────────────────────────────────────────────
    public void updateStatus(int roomId, String status) {
        String sql = "UPDATE room SET status = ? WHERE room_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            st.setInt(2, roomId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ── Map ResultSet → Room (with category fields) ──────────────────────────
    private Room mapRoom(ResultSet rs) throws SQLException {
        Room room = new Room(
                rs.getInt("room_id"),
                rs.getString("room_number"),
                rs.getString("status"),
                rs.getString("image"),
                rs.getBoolean("is_deleted")
        );
        room.setCategoryId(rs.getInt("category_id"));
        room.setCategoryName(rs.getString("category_name"));
        BigDecimal bp = rs.getBigDecimal("base_price");
        room.setBasePrice(bp != null ? bp : BigDecimal.ZERO);
        return room;
    }
}
