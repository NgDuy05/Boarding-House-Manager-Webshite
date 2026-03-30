package DALs;

import Models.ActivityLog;
import Utils.DBContext;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ActivityLogDAO extends DBContext {

    /**
     * Fetch activity logs aggregated from multiple tables.
     *
     * @param userId     filter by specific customer (0 = all customers)
     * @param typeFilter filter by activity type (null = all)
     * @param dateFrom   earliest date in yyyy-MM-dd (null = no limit)
     * @param dateTo     latest date in yyyy-MM-dd   (null = no limit)
     * @param search     full-name or username keyword (null = all)
     */
    public List<ActivityLog> getLogs(int userId, String typeFilter,
                                     String dateFrom, String dateTo,
                                     String search) {
        List<ActivityLog> logs = new ArrayList<>();

        // Each branch of the UNION must produce the same columns:
        // activity_type, user_id, username, full_name, activity_date, description, related_id
        String sql =
            // 1. Account created
            "SELECT 'ACCOUNT_CREATED' AS activity_type, "
          + "       u.user_id, u.userName, u.full_name, "
          + "       u.created_at AS activity_date, "
          + "       CONCAT('Account registered: @', u.userName) AS description, "
          + "       NULL AS related_id "
          + "FROM [user] u "
          + "WHERE u.role = 'customer' AND u.created_at IS NOT NULL "

          + "UNION ALL "

            // 2. Tenant joined a contract
          + "SELECT 'CONTRACT_JOINED', u.user_id, u.userName, u.full_name, "
          + "       CONVERT(datetime, cu.joined_at), "
          + "       CONCAT('Joined contract #', c.contract_id, ' — Room ', r.room_number), "
          + "       c.contract_id "
          + "FROM contract_user cu "
          + "JOIN [user] u ON cu.user_id = u.user_id "
          + "JOIN contract c ON cu.contract_id = c.contract_id "
          + "JOIN room r ON c.room_id = r.room_id "
          + "WHERE u.role = 'customer' AND cu.joined_at IS NOT NULL "

          + "UNION ALL "

            // 3. Tenant left a contract
          + "SELECT 'CONTRACT_LEFT', u.user_id, u.userName, u.full_name, "
          + "       CONVERT(datetime, cu.left_at), "
          + "       CONCAT('Left contract #', c.contract_id, ' — Room ', r.room_number), "
          + "       c.contract_id "
          + "FROM contract_user cu "
          + "JOIN [user] u ON cu.user_id = u.user_id "
          + "JOIN contract c ON cu.contract_id = c.contract_id "
          + "JOIN room r ON c.room_id = r.room_id "
          + "WHERE u.role = 'customer' AND cu.left_at IS NOT NULL "

          + "UNION ALL "

            // 4. Bill issued
          + "SELECT 'BILL_CREATED', u.user_id, u.userName, u.full_name, "
          + "       b.created_at, "
          + "       CONCAT('Bill #', b.bill_id, ' issued — period ', "
          + "              FORMAT(b.period,'MM/yyyy'), ', amount: ', "
          + "              FORMAT(b.total_amount,'N0'), 'đ'), "
          + "       b.bill_id "
          + "FROM bill b "
          + "JOIN contract c ON b.contract_id = c.contract_id "
          + "JOIN contract_user cu ON c.contract_id = cu.contract_id "
          + "JOIN [user] u ON cu.user_id = u.user_id "
          + "WHERE u.role = 'customer' AND b.is_deleted = 0 AND b.created_at IS NOT NULL "

          + "UNION ALL "

            // 5. Bill paid
          + "SELECT 'BILL_PAID', u.user_id, u.userName, u.full_name, "
          + "       b.created_at, "
          + "       CONCAT('Paid bill #', b.bill_id, ' — period ', "
          + "              FORMAT(b.period,'MM/yyyy'), ', amount: ', "
          + "              FORMAT(b.total_amount,'N0'), 'đ'), "
          + "       b.bill_id "
          + "FROM bill b "
          + "JOIN contract c ON b.contract_id = c.contract_id "
          + "JOIN contract_user cu ON c.contract_id = cu.contract_id "
          + "JOIN [user] u ON cu.user_id = u.user_id "
          + "WHERE u.role = 'customer' AND b.status = 'paid' "
          + "  AND b.is_deleted = 0 AND b.created_at IS NOT NULL "

          + "UNION ALL "

            // 6. Service used
          + "SELECT 'SERVICE_USED', u.user_id, u.userName, u.full_name, "
          + "       CONVERT(datetime, su.usage_date), "
          + "       CONCAT('Used service: ', s.service_name, ' × ', "
          + "              FORMAT(su.quantity,'N0')), "
          + "       su.usage_id "
          + "FROM service_usage su "
          + "JOIN service s ON su.service_id = s.service_id "
          + "JOIN contract c ON su.contract_id = c.contract_id "
          + "JOIN contract_user cu ON c.contract_id = cu.contract_id "
          + "JOIN [user] u ON cu.user_id = u.user_id "
          + "WHERE u.role = 'customer' "

          + "UNION ALL "

            // 7. Utility reading recorded
          + "SELECT 'UTILITY_READING', u.user_id, u.userName, u.full_name, "
          + "       uu.created_at, "
          + "       CONCAT(ut.utility_name, ' reading — Room ', r.room_number, "
          + "              ': ', uu.old_value, ' → ', uu.new_value, ' ', ut.unit), "
          + "       uu.usage_id "
          + "FROM utility_usage uu "
          + "JOIN utility ut ON uu.utility_id = ut.utility_id "
          + "JOIN room r ON uu.room_id = r.room_id "
          + "JOIN contract c ON c.room_id = r.room_id AND c.is_deleted = 0 "
          + "JOIN contract_user cu ON cu.contract_id = c.contract_id "
          + "JOIN [user] u ON cu.user_id = u.user_id "
          + "WHERE u.role = 'customer' AND uu.created_at IS NOT NULL ";

        // Wrap entire UNION in a subquery so we can filter on derived columns
        StringBuilder wrapped = new StringBuilder();
        wrapped.append("SELECT * FROM (").append(sql).append(") AS logs WHERE 1=1 ");

        if (userId > 0) {
            wrapped.append("AND user_id = ? ");
        }
        if (typeFilter != null && !typeFilter.trim().isEmpty()) {
            wrapped.append("AND activity_type = ? ");
        }
        if (dateFrom != null && !dateFrom.trim().isEmpty()) {
            wrapped.append("AND activity_date >= ? ");
        }
        if (dateTo != null && !dateTo.trim().isEmpty()) {
            wrapped.append("AND activity_date <= DATEADD(day,1,?) ");
        }
        if (search != null && !search.trim().isEmpty()) {
            wrapped.append("AND (userName LIKE ? OR full_name LIKE ?) ");
        }
        wrapped.append("ORDER BY activity_date DESC");

        try {
            PreparedStatement st = connection.prepareStatement(wrapped.toString());
            int idx = 1;
            if (userId > 0)                                     st.setInt(idx++, userId);
            if (typeFilter != null && !typeFilter.trim().isEmpty()) st.setString(idx++, typeFilter);
            if (dateFrom != null && !dateFrom.trim().isEmpty()) st.setString(idx++, dateFrom);
            if (dateTo != null && !dateTo.trim().isEmpty())     st.setString(idx++, dateTo);
            if (search != null && !search.trim().isEmpty()) {
                String kw = "%" + search.trim() + "%";
                st.setString(idx++, kw);
                st.setString(idx++, kw);
            }

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ActivityLog log = new ActivityLog();
                log.setActivityType(rs.getString("activity_type"));
                log.setUserId(rs.getInt("user_id"));
                log.setUsername(rs.getString("userName"));
                log.setFullName(rs.getString("full_name"));
                Timestamp ts = rs.getTimestamp("activity_date");
                if (ts != null) log.setActivityDate(ts.toLocalDateTime());
                log.setDescription(rs.getString("description"));
                int rid = rs.getInt("related_id");
                log.setRelatedId(rs.wasNull() ? null : rid);
                logs.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }
}
