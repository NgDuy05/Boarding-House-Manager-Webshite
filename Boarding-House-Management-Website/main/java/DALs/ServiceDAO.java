package DALs;

import Utils.DBContext;
import Models.PriceCategory;
import Models.Service;
import Models.ServiceUsage;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;
import java.time.LocalDate;

public class ServiceDAO extends DBContext {

    // =============================
    // GET ALL SERVICES (active only – customer-facing)
    // =============================
    public List<Service> getAllServices() {

        List<Service> list = new ArrayList<>();

        String sql = "SELECT * FROM service WHERE is_deleted = 0";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Service s = new Service();

                s.setServiceId(rs.getInt("service_id"));
                s.setServiceName(rs.getString("service_name"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setDescription(rs.getString("description"));
                s.setImage(rs.getString("image"));
                s.setIsDeleted(rs.getBoolean("is_deleted"));

                list.add(s);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // =============================
    // GET ALL SERVICES (admin – includes hidden)
    // =============================
    public List<Service> getAllServicesAdmin() {

        List<Service> list = new ArrayList<>();

        String sql = "SELECT * FROM service ORDER BY is_deleted ASC, service_id ASC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Service s = new Service();
                s.setServiceId(rs.getInt("service_id"));
                s.setServiceName(rs.getString("service_name"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setDescription(rs.getString("description"));
                s.setImage(rs.getString("image"));
                s.setIsDeleted(rs.getBoolean("is_deleted"));
                list.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // =============================
    // RESTORE SERVICE (undo soft-delete)
    // =============================
    public void restoreService(int id) {

        String sql = "UPDATE service SET is_deleted = 0 WHERE service_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =============================
    // GET SERVICE BY ID
    // =============================
    public Service getServiceById(int id) {

        String sql = "SELECT * FROM service WHERE service_id = ?";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                Service s = new Service();

                s.setServiceId(rs.getInt("service_id"));
                s.setServiceName(rs.getString("service_name"));
                s.setCategoryId(rs.getInt("category_id"));
                s.setDescription(rs.getString("description"));
                s.setImage(rs.getString("image"));
                s.setIsDeleted(rs.getBoolean("is_deleted"));

                return s;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // =============================
    // INSERT SERVICE
    // =============================
    public void insertService(Service s) {

        String sql = "INSERT INTO service(service_name, category_id, description, image, is_deleted) VALUES(?,?,?,?,0)";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, s.getServiceName());
            ps.setInt(2, s.getCategoryId());
            ps.setString(3, s.getDescription());
            ps.setString(4, s.getImage());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =============================
    // UPDATE SERVICE
    // =============================
    public void updateService(Service s) {

        String sql = "UPDATE service SET service_name=?, category_id=?, description=?, image=? WHERE service_id=?";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setString(1, s.getServiceName());
            ps.setInt(2, s.getCategoryId());
            ps.setString(3, s.getDescription());
            ps.setString(4, s.getImage());
            ps.setInt(5, s.getServiceId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =============================
    // DELETE SERVICE (SOFT DELETE)
    // =============================
    public void deleteService(int id) {

        String sql = "UPDATE service SET is_deleted = 1 WHERE service_id=?";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =============================
    // ADD SERVICE USAGE
    // =============================
    public void addUsage(ServiceUsage u) {

        String sql = "INSERT INTO service_usage(contract_id, service_id, quantity, usage_date, billed, status) "
                + "VALUES(?,?,?,?,0,'approved')";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, u.getContractId());
            ps.setInt(2, u.getServiceId());
            ps.setBigDecimal(3, u.getQuantity());
            ps.setDate(4, Date.valueOf(u.getUsageDate()));

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =============================
    // GET SERVICE USAGE BY CONTRACT
    // =============================
    public List<ServiceUsage> getUsageByContract(int contractId) {

        List<ServiceUsage> list = new ArrayList<>();

        String sql = "SELECT * FROM service_usage WHERE contract_id = ?";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, contractId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                ServiceUsage u = new ServiceUsage();

                u.setUsageId(rs.getInt("usage_id"));
                u.setContractId(rs.getInt("contract_id"));
                u.setServiceId(rs.getInt("service_id"));
                u.setQuantity(rs.getBigDecimal("quantity"));
                u.setUsageDate(rs.getDate("usage_date").toLocalDate());
                u.setBilled(rs.getBoolean("billed"));

                list.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // =============================
    // GET SERVICE PRICE
    // =============================
    public BigDecimal getServicePrice(int serviceId, LocalDate usageDate) {

        String sql
                = "SELECT TOP 1 ph.price_amount "
                + "FROM service s "
                + "JOIN price_history ph ON s.category_id = ph.category_id "
                + "WHERE s.service_id = ? "
                + "AND ph.effective_from <= ? "
                + "ORDER BY ph.effective_from DESC";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);

            ps.setInt(1, serviceId);
            ps.setDate(2, Date.valueOf(usageDate));

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal("price_amount");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // =============================
    // CALCULATE USAGE COST
    // =============================
    public BigDecimal calculateUsageCost(ServiceUsage usage) {

        BigDecimal price = getServicePrice(
                usage.getServiceId(),
                usage.getUsageDate()
        );

        return price.multiply(usage.getQuantity());
    }

    // =============================
    // TOTAL SERVICE COST BY CONTRACT
    // =============================
    public BigDecimal calculateServiceTotal(int contractId) {

        BigDecimal total = BigDecimal.ZERO;

        List<ServiceUsage> list = getUsageByContract(contractId);

        for (ServiceUsage u : list) {

            if (!u.isBilled()) {
                total = total.add(calculateUsageCost(u));
            }

        }

        return total;
    }

    // =============================
    // GET ALL USAGE WITH DETAILS (admin: request list)
    // =============================
    public List<ServiceUsage> getAllUsageWithDetails() {
        return getAllRequestsWithDetails(null);
    }

    // =============================
    // GET USAGE BY USER ID (customer: service history)
    // =============================
    public List<ServiceUsage> getUsageByUserId(int userId) {

        List<ServiceUsage> list = new ArrayList<>();

        String sql = "SELECT su.usage_id, su.contract_id, su.service_id, su.quantity, "
                + "su.usage_date, su.billed, su.status, "
                + "s.service_name, r.room_number, "
                + "u2.full_name AS requester_name, "
                + "ph.price_amount AS unit_price "
                + "FROM service_usage su "
                + "JOIN service s ON su.service_id = s.service_id "
                + "JOIN contract c ON su.contract_id = c.contract_id "
                + "JOIN room r ON c.room_id = r.room_id "
                + "JOIN contract_user cu ON c.contract_id = cu.contract_id "
                + "LEFT JOIN [user] u2 ON cu.user_id = u2.user_id AND cu.role = 'owner' "
                + "LEFT JOIN price_history ph ON s.category_id = ph.category_id "
                + "  AND ph.effective_from = ( "
                + "    SELECT TOP 1 effective_from FROM price_history "
                + "    WHERE category_id = s.category_id "
                + "    AND effective_from <= su.usage_date "
                + "    ORDER BY effective_from DESC "
                + "  ) "
                + "WHERE cu.user_id = ? "
                + "ORDER BY su.usage_date DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ServiceUsage u = mapUsageDetail(rs);
                list.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // =============================
    // GET SERVICE CATEGORIES (for forms)
    // =============================
    public List<PriceCategory> getServicePriceCategories() {

        List<PriceCategory> list = new ArrayList<>();

        String sql = "SELECT category_id, category_code, category_type, unit "
                + "FROM price_category "
                + "WHERE is_deleted = 0 AND category_type = 'service' "
                + "ORDER BY category_code";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                PriceCategory c = new PriceCategory();
                c.setCategoryId(rs.getInt("category_id"));
                c.setCategoryCode(rs.getString("category_code"));
                c.setCategoryType(rs.getString("category_type"));
                c.setUnit(rs.getString("unit"));
                list.add(c);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // =============================
    // MARK USAGE BILLED
    // =============================
    public void markUsageBilled(int contractId) {

        String sql = "UPDATE service_usage SET billed = 1 WHERE contract_id = ?";

        try {

            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, contractId);
            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =============================
    // GET ACTIVE CONTRACT ID BY USER
    // =============================
    public int getActiveContractIdByUserId(int userId) {

        String sql = "SELECT TOP 1 c.contract_id "
                + "FROM contract c "
                + "JOIN contract_user cu ON c.contract_id = cu.contract_id "
                + "WHERE cu.user_id = ? AND c.status = 'active' AND c.is_deleted = 0";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("contract_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // =============================
    // CUSTOMER: REQUEST A SERVICE
    // =============================
    public boolean requestService(int contractId, int serviceId, BigDecimal quantity, LocalDate usageDate) {

        String sql = "INSERT INTO service_usage(contract_id, service_id, quantity, usage_date, billed, status) "
                + "VALUES(?,?,?,?,0,'pending')";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, contractId);
            ps.setInt(2, serviceId);
            ps.setBigDecimal(3, quantity);
            ps.setDate(4, Date.valueOf(usageDate));
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // =============================
    // ADMIN: GET ALL REQUESTS WITH DETAILS
    // status filter: null = all, "pending" / "approved" / "rejected"
    // =============================
    public List<ServiceUsage> getAllRequestsWithDetails(String statusFilter) {

        List<ServiceUsage> list = new ArrayList<>();

        String sql = "SELECT su.usage_id, su.contract_id, su.service_id, su.quantity, "
                + "su.usage_date, su.billed, su.status, "
                + "s.service_name, r.room_number, "
                + "u.full_name AS requester_name, "
                + "ph.price_amount AS unit_price "
                + "FROM service_usage su "
                + "JOIN service s ON su.service_id = s.service_id "
                + "JOIN contract c ON su.contract_id = c.contract_id "
                + "JOIN room r ON c.room_id = r.room_id "
                + "LEFT JOIN contract_user cu ON c.contract_id = cu.contract_id AND cu.role = 'owner' "
                + "LEFT JOIN [user] u ON cu.user_id = u.user_id "
                + "LEFT JOIN price_history ph ON s.category_id = ph.category_id "
                + "  AND ph.effective_from = ( "
                + "    SELECT TOP 1 effective_from FROM price_history "
                + "    WHERE category_id = s.category_id "
                + "    AND effective_from <= su.usage_date "
                + "    ORDER BY effective_from DESC "
                + "  ) "
                + (statusFilter != null && !statusFilter.isEmpty()
                        ? "WHERE su.status = ? " : "")
                + "ORDER BY "
                + "  CASE su.status WHEN 'pending' THEN 1 WHEN 'approved' THEN 2 ELSE 3 END, "
                + "  su.usage_date DESC";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(1, statusFilter);
            }
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                ServiceUsage u = mapUsageDetail(rs);
                list.add(u);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // =============================
    // ADMIN: APPROVE REQUEST
    // =============================
    public void approveRequest(int usageId) {

        String sql = "UPDATE service_usage SET status = 'approved' WHERE usage_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, usageId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =============================
    // ADMIN: UPDATE REQUEST STATUS (any value)
    // =============================
    public void updateRequestStatus(int usageId, String status) {

        String sql = "UPDATE service_usage SET status = ? WHERE usage_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, status);
            ps.setInt(2, usageId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =============================
    // ADMIN: COUNT PENDING REQUESTS
    // =============================
    public int countPendingRequests() {

        String sql = "SELECT COUNT(*) FROM service_usage WHERE status = 'pending'";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // =============================
    // ADMIN: REJECT REQUEST
    // =============================
    public void rejectRequest(int usageId) {

        String sql = "UPDATE service_usage SET status = 'rejected' WHERE usage_id = ?";

        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, usageId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // =============================
    // HELPER: Map result set to ServiceUsage with detail fields
    // =============================
    private ServiceUsage mapUsageDetail(ResultSet rs) throws SQLException {
        ServiceUsage u = new ServiceUsage();
        u.setUsageId(rs.getInt("usage_id"));
        u.setContractId(rs.getInt("contract_id"));
        u.setServiceId(rs.getInt("service_id"));
        u.setQuantity(rs.getBigDecimal("quantity"));
        u.setUsageDate(rs.getDate("usage_date").toLocalDate());
        u.setBilled(rs.getBoolean("billed"));
        u.setStatus(rs.getString("status"));
        u.setServiceName(rs.getString("service_name"));
        u.setRoomNumber(rs.getString("room_number"));
        u.setRequesterName(rs.getString("requester_name"));
        BigDecimal unitPrice = rs.getBigDecimal("unit_price");
        if (unitPrice == null) unitPrice = BigDecimal.ZERO;
        u.setUnitPrice(unitPrice);
        u.setTotalCost(unitPrice.multiply(u.getQuantity()));
        return u;
    }
}
