package DALs;

import Models.RoomCategory;
import Utils.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class RoomCategoryDAO extends DBContext {

    /** All active room categories, each enriched with the count of active rooms. */
    public List<RoomCategory> getAllCategoriesWithCount() {
        List<RoomCategory> list = new ArrayList<>();
        String sql =
            "SELECT rc.category_id, rc.category_name, rc.description, rc.base_price, " +
            "       COUNT(r.room_id) AS room_count " +
            "FROM room_category rc " +
            "LEFT JOIN room r ON r.category_id = rc.category_id AND r.is_deleted = 0 " +
            "WHERE rc.is_deleted = 0 " +
            "GROUP BY rc.category_id, rc.category_name, rc.description, rc.base_price " +
            "ORDER BY rc.base_price ASC";

        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                RoomCategory rc = mapCategory(rs);
                rc.setRoomCount(rs.getInt("room_count"));
                list.add(rc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** All active room categories (no room count). */
    public List<RoomCategory> getAllCategories() {
        List<RoomCategory> list = new ArrayList<>();
        String sql = "SELECT category_id, category_name, description, base_price " +
                     "FROM room_category WHERE is_deleted = 0 ORDER BY base_price ASC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapCategory(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Single category by PK. */
    public RoomCategory getCategoryById(int id) {
        String sql = "SELECT category_id, category_name, description, base_price " +
                     "FROM room_category WHERE category_id = ? AND is_deleted = 0";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapCategory(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private RoomCategory mapCategory(ResultSet rs) throws SQLException {
        RoomCategory rc = new RoomCategory();
        rc.setCategoryId(rs.getInt("category_id"));
        rc.setCategoryName(rs.getString("category_name"));
        rc.setDescription(rs.getString("description"));
        BigDecimal bp = rs.getBigDecimal("base_price");
        rc.setBasePrice(bp != null ? bp : BigDecimal.ZERO);
        return rc;
    }
}
