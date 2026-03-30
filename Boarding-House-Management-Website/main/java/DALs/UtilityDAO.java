package DALs;

import Models.Utility;
import Models.UtilityPrice;
import Models.UtilityUsage;
import Utils.DBContext;
import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UtilityDAO extends DBContext {

    // =====================================================
    // UTILITY CRUD
    // =====================================================

    public List<Utility> getAllUtilities() {
        List<Utility> list = new ArrayList<>();
        String sql = "SELECT utility_id, utility_name, unit, description, created_at, is_deleted "
                + "FROM utility ORDER BY is_deleted ASC, utility_name ASC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapUtility(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Utility getUtilityById(int id) {
        String sql = "SELECT utility_id, utility_name, unit, description, created_at, is_deleted "
                + "FROM utility WHERE utility_id = ? AND is_deleted = 0";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapUtility(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int insertUtility(Utility u) {
        String sql = "INSERT INTO utility (utility_name, unit, description, is_deleted) VALUES (?, ?, ?, 0)";
        try {
            PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            st.setString(1, u.getUtilityName());
            st.setString(2, u.getUnit());
            st.setString(3, u.getDescription());
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

    public void updateUtility(Utility u) {
        String sql = "UPDATE utility SET utility_name = ?, unit = ?, description = ? WHERE utility_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, u.getUtilityName());
            st.setString(2, u.getUnit());
            st.setString(3, u.getDescription());
            st.setInt(4, u.getUtilityId());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteUtility(int id) {
        String sql = "UPDATE utility SET is_deleted = 1 WHERE utility_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void restoreUtility(int id) {
        String sql = "UPDATE utility SET is_deleted = 0 WHERE utility_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, id);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private Utility mapUtility(ResultSet rs) throws SQLException {
        Utility u = new Utility();
        u.setUtilityId(rs.getInt("utility_id"));
        u.setUtilityName(rs.getString("utility_name"));
        u.setUnit(rs.getString("unit"));
        u.setDescription(rs.getString("description"));
        u.setIsDeleted(rs.getBoolean("is_deleted"));
        return u;
    }

    // =====================================================
    // UTILITY PRICE CRUD
    // =====================================================

    public List<UtilityPrice> getPricesByUtilityId(int utilityId) {
        List<UtilityPrice> list = new ArrayList<>();
        String sql = "SELECT up.price_id, up.utility_id, up.price, up.effective_from, up.created_at, "
                + "u.utility_name "
                + "FROM utility_price up "
                + "JOIN utility u ON up.utility_id = u.utility_id "
                + "WHERE up.utility_id = ? ORDER BY up.effective_from DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, utilityId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapPrice(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public UtilityPrice getPriceById(int priceId) {
        String sql = "SELECT up.price_id, up.utility_id, up.price, up.effective_from, up.created_at, "
                + "u.utility_name "
                + "FROM utility_price up "
                + "JOIN utility u ON up.utility_id = u.utility_id "
                + "WHERE up.price_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, priceId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapPrice(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public UtilityPrice getCurrentPrice(int utilityId) {
        String sql = "SELECT TOP 1 up.price_id, up.utility_id, up.price, up.effective_from, up.created_at, "
                + "u.utility_name "
                + "FROM utility_price up "
                + "JOIN utility u ON up.utility_id = u.utility_id "
                + "WHERE up.utility_id = ? AND up.effective_from <= GETDATE() "
                + "ORDER BY up.effective_from DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, utilityId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapPrice(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertPrice(UtilityPrice p) {
        String sql = "INSERT INTO utility_price (utility_id, price, effective_from) VALUES (?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, p.getUtilityId());
            st.setBigDecimal(2, p.getPrice());
            st.setDate(3, p.getEffectiveFrom());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updatePrice(UtilityPrice p) {
        String sql = "UPDATE utility_price SET price = ?, effective_from = ? WHERE price_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setBigDecimal(1, p.getPrice());
            st.setDate(2, p.getEffectiveFrom());
            st.setInt(3, p.getPriceId());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deletePrice(int priceId) {
        String sql = "DELETE FROM utility_price WHERE price_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, priceId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private UtilityPrice mapPrice(ResultSet rs) throws SQLException {
        UtilityPrice p = new UtilityPrice();
        p.setPriceId(rs.getInt("price_id"));
        p.setUtilityId(rs.getInt("utility_id"));
        p.setPrice(rs.getBigDecimal("price"));
        p.setEffectiveFrom(rs.getDate("effective_from"));
        p.setCreatedAt(rs.getDate("created_at"));
        p.setUtilityName(rs.getString("utility_name"));
        return p;
    }

    // =====================================================
    // UTILITY USAGE CRUD
    // =====================================================

    public List<UtilityUsage> getAllUsages() {
        List<UtilityUsage> list = new ArrayList<>();
        String sql = "SELECT uu.usage_id, uu.room_id, uu.utility_id, uu.period, uu.old_value, uu.new_value, "
                + "uu.created_at, r.room_number, u.utility_name, u.unit "
                + "FROM utility_usage uu "
                + "JOIN room r ON uu.room_id = r.room_id "
                + "JOIN utility u ON uu.utility_id = u.utility_id "
                + "ORDER BY uu.period DESC, r.room_number";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapUsage(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<UtilityUsage> getUsagesByUtilityId(int utilityId) {
        List<UtilityUsage> list = new ArrayList<>();
        String sql = "SELECT uu.usage_id, uu.room_id, uu.utility_id, uu.period, uu.old_value, uu.new_value, "
                + "uu.created_at, r.room_number, u.utility_name, u.unit "
                + "FROM utility_usage uu "
                + "JOIN room r ON uu.room_id = r.room_id "
                + "JOIN utility u ON uu.utility_id = u.utility_id "
                + "WHERE uu.utility_id = ? "
                + "ORDER BY uu.period DESC, r.room_number";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, utilityId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapUsage(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<UtilityUsage> getUsagesByRoomId(int roomId) {
        List<UtilityUsage> list = new ArrayList<>();
        String sql = "SELECT uu.usage_id, uu.room_id, uu.utility_id, uu.period, uu.old_value, uu.new_value, "
                + "uu.created_at, r.room_number, u.utility_name, u.unit "
                + "FROM utility_usage uu "
                + "JOIN room r ON uu.room_id = r.room_id "
                + "JOIN utility u ON uu.utility_id = u.utility_id "
                + "WHERE uu.room_id = ? "
                + "ORDER BY uu.period DESC, u.utility_name";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, roomId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapUsage(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public UtilityUsage getUsageById(int usageId) {
        String sql = "SELECT uu.usage_id, uu.room_id, uu.utility_id, uu.period, uu.old_value, uu.new_value, "
                + "uu.created_at, r.room_number, u.utility_name, u.unit "
                + "FROM utility_usage uu "
                + "JOIN room r ON uu.room_id = r.room_id "
                + "JOIN utility u ON uu.utility_id = u.utility_id "
                + "WHERE uu.usage_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, usageId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapUsage(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void insertUsage(UtilityUsage u) {
        String sql = "INSERT INTO utility_usage (room_id, utility_id, period, old_value, new_value) "
                + "VALUES (?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, u.getRoomId());
            st.setInt(2, u.getUtilityId());
            st.setDate(3, u.getPeriod());
            st.setInt(4, u.getOldValue());
            st.setInt(5, u.getNewValue());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateUsage(UtilityUsage u) {
        String sql = "UPDATE utility_usage SET room_id = ?, utility_id = ?, period = ?, old_value = ?, new_value = ? "
                + "WHERE usage_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, u.getRoomId());
            st.setInt(2, u.getUtilityId());
            st.setDate(3, u.getPeriod());
            st.setInt(4, u.getOldValue());
            st.setInt(5, u.getNewValue());
            st.setInt(6, u.getUsageId());
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteUsage(int usageId) {
        String sql = "DELETE FROM utility_usage WHERE usage_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, usageId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private UtilityUsage mapUsage(ResultSet rs) throws SQLException {
        UtilityUsage u = new UtilityUsage();
        u.setUsageId(rs.getInt("usage_id"));
        u.setRoomId(rs.getInt("room_id"));
        u.setUtilityId(rs.getInt("utility_id"));
        u.setPeriod(rs.getDate("period"));
        u.setOldValue(rs.getInt("old_value"));
        u.setNewValue(rs.getInt("new_value"));
        u.setCreatedAt(rs.getDate("created_at"));
        u.setRoomNumber(rs.getString("room_number"));
        u.setUtilityName(rs.getString("utility_name"));
        u.setUnit(rs.getString("unit"));
        return u;
    }
}
