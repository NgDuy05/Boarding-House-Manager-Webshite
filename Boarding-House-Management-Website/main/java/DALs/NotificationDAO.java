package DALs;

import Models.Notification;
import Utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO extends DBContext {

    /** Base SELECT — always JOIN with [user] to get creator name. */
    private static final String SELECT_BASE =
        "SELECT n.notification_id, n.created_by, n.title, n.content, " +
        "       n.target_contract_id, n.created_at, n.is_deleted, " +
        "       u.full_name AS creator_name " +
        "FROM notification n " +
        "LEFT JOIN [user] u ON n.created_by = u.user_id ";

    // =====================================================================
    // GET ALL (admin / staff)
    // =====================================================================
    public List<Notification> getAllNotifications() {
        List<Notification> list = new ArrayList<>();
        String sql = SELECT_BASE + "WHERE n.is_deleted = 0 ORDER BY n.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapNotification(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // =====================================================================
    // GET NOTIFICATIONS FOR A USER (customer view)
    // Returns:
    //   • all broadcast notifications (target_contract_id IS NULL)
    //   • notifications targeted at contracts the user belongs to
    // =====================================================================
    public List<Notification> getNotificationsForUser(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = SELECT_BASE +
            "WHERE n.is_deleted = 0 " +
            "AND ( " +
            "      n.target_contract_id IS NULL " +
            "   OR n.target_contract_id IN ( " +
            "          SELECT c.contract_id " +
            "          FROM contract c " +
            "          JOIN contract_user cu ON c.contract_id = cu.contract_id " +
            "          WHERE cu.user_id = ? " +
            "      ) " +
            ") " +
            "ORDER BY n.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapNotification(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    /** Count of notifications visible to a given user (for badge). */
    public int countForUser(int userId) {
        String sql =
            "SELECT COUNT(*) FROM notification n " +
            "WHERE n.is_deleted = 0 " +
            "AND ( " +
            "      n.target_contract_id IS NULL " +
            "   OR n.target_contract_id IN ( " +
            "          SELECT c.contract_id FROM contract c " +
            "          JOIN contract_user cu ON c.contract_id = cu.contract_id " +
            "          WHERE cu.user_id = ? " +
            "      ) " +
            ")";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // =====================================================================
    // GET BY ID
    // =====================================================================
    public Notification getNotificationById(int id) {
        String sql = SELECT_BASE + "WHERE n.notification_id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapNotification(rs);
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // =====================================================================
    // GET BY CONTRACT
    // =====================================================================
    public List<Notification> getNotificationByContract(int contractId) {
        List<Notification> list = new ArrayList<>();
        String sql = SELECT_BASE +
            "WHERE n.is_deleted = 0 " +
            "AND (n.target_contract_id IS NULL OR n.target_contract_id = ?) " +
            "ORDER BY n.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapNotification(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // =====================================================================
    // GET BY USER (created by)
    // =====================================================================
    public List<Notification> getNotificationByUser(int userId) {
        List<Notification> list = new ArrayList<>();
        String sql = SELECT_BASE +
            "WHERE n.created_by = ? AND n.is_deleted = 0 ORDER BY n.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapNotification(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // =====================================================================
    // SEARCH
    // =====================================================================
    public List<Notification> searchNotification(String keyword) {
        List<Notification> list = new ArrayList<>();
        String sql = SELECT_BASE +
            "WHERE n.is_deleted = 0 AND (n.title LIKE ? OR n.content LIKE ?) " +
            "ORDER BY n.created_at DESC";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(mapNotification(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // =====================================================================
    // INSERT
    // =====================================================================
    public void insertNotification(Notification n) {
        String sql = "INSERT INTO notification(created_by,title,content,target_contract_id,is_deleted) " +
                     "VALUES(?,?,?,?,0)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, n.getCreatedBy());
            ps.setString(2, n.getTitle());
            ps.setString(3, n.getContent());
            if (n.getTargetContractId() == null) ps.setNull(4, Types.INTEGER);
            else ps.setInt(4, n.getTargetContractId());
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // =====================================================================
    // UPDATE
    // =====================================================================
    public void updateNotification(int id, Notification n) {
        String sql = "UPDATE notification SET title=?, content=?, target_contract_id=? " +
                     "WHERE notification_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, n.getTitle());
            ps.setString(2, n.getContent());
            if (n.getTargetContractId() == null) ps.setNull(3, Types.INTEGER);
            else ps.setInt(3, n.getTargetContractId());
            ps.setInt(4, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // =====================================================================
    // SOFT DELETE
    // =====================================================================
    public void deleteNotification(int id) {
        String sql = "UPDATE notification SET is_deleted=1 WHERE notification_id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    // =====================================================================
    // COUNT (admin)
    // =====================================================================
    public int countNotifications() {
        String sql = "SELECT COUNT(*) FROM notification WHERE is_deleted=0";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // =====================================================================
    // MAP ResultSet → Notification
    // =====================================================================
    private Notification mapNotification(ResultSet rs) throws SQLException {
        Notification n = new Notification();
        n.setNotificationId(rs.getInt("notification_id"));
        n.setCreatedBy(rs.getInt("created_by"));
        n.setTitle(rs.getString("title"));
        n.setContent(rs.getString("content"));
        Object target = rs.getObject("target_contract_id");
        if (target != null) n.setTargetContractId((Integer) target);
        n.setCreatedAt(rs.getTimestamp("created_at"));
        n.setIsDeleted(rs.getBoolean("is_deleted"));
        try { n.setCreatedByName(rs.getString("creator_name")); } catch (SQLException ignored) {}
        return n;
    }
}
