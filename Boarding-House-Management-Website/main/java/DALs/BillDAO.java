package DALs;

import Models.Bill;
import Models.BillItem;
import Utils.DBContext;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class BillDAO extends DBContext {

    // ==============================
    // GET ALL BILLS
    // ==============================
    public List<Bill> getAllBills() {

        List<Bill> list = new ArrayList<>();

        String sql = "SELECT * FROM bill WHERE is_deleted = 0 ORDER BY bill_id DESC";

        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                list.add(mapBill(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ==============================
    // GET BILL BY ID
    // ==============================
    public Bill getBillById(int id) {

        String sql = "SELECT * FROM bill WHERE bill_id = ? AND is_deleted = 0";

        try (PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, id);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return mapBill(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ==============================
    // GET BILL BY TENANT
    // ==============================
    public List<Bill> getBillByTenant(int userId) {

        List<Bill> list = new ArrayList<>();

        // contract has no user_id column — link through contract_user junction table
        String sql = "SELECT b.* "
                + "FROM bill b "
                + "JOIN contract_user cu ON b.contract_id = cu.contract_id "
                + "WHERE cu.user_id = ? AND b.is_deleted = 0 "
                + "ORDER BY b.bill_id DESC";

        try (PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, userId);

            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                list.add(mapBill(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ==============================
    // GET BILLS BY CONTRACT
    // ==============================
    public List<Bill> getBillsByContractId(int contractId) {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT * FROM bill WHERE contract_id = ? AND is_deleted = 0 ORDER BY period DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, contractId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapBill(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ==============================
    // GET UNPAID BILLS
    // ==============================
    public List<Bill> getUnpaidBills() {

        List<Bill> list = new ArrayList<>();

        String sql = "SELECT * FROM bill "
                + "WHERE status = 'pending' "
                + "AND is_deleted = 0";
        try (PreparedStatement st = connection.prepareStatement(sql); ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                list.add(mapBill(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ==============================
    // INSERT BILL
    // ==============================
    public void insertBill(Bill b) {

        String sql = "INSERT INTO bill "
                + "(contract_id, period, due_date, total_amount, status, is_deleted) "
                + "VALUES (?, ?, ?, ?, ?, 0)";

        try (PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, b.getContractId());
            st.setDate(2, Date.valueOf(b.getPeriod()));
            st.setDate(3, Date.valueOf(b.getDueDate()));
            st.setBigDecimal(4, b.getTotalAmount());
            st.setString(5, b.getStatus());

            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ==============================
    // UPDATE BILL
    // ==============================
    public void updateBill(Bill b) {

        String sql = "UPDATE bill "
                + "SET contract_id = ?, "
                + "period = ?, "
                + "due_date = ?, "
                + "total_amount = ?, "
                + "status = ? "
                + "WHERE bill_id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, b.getContractId());
            st.setDate(2, Date.valueOf(b.getPeriod()));
            st.setDate(3, Date.valueOf(b.getDueDate()));
            st.setBigDecimal(4, b.getTotalAmount());
            st.setString(5, b.getStatus());
            st.setInt(6, b.getBillId());

            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ==============================
    // SOFT DELETE
    // ==============================
    public void deleteBill(int id) {

        String sql = "UPDATE bill SET is_deleted = 1 WHERE bill_id = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, id);

            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ==============================
    // CALCULATE TOTAL BILL
    // ==============================
    public BigDecimal calculateTotal(int contractId) {

        String sql = "SELECT r.price AS room_price, "
                + "SUM(us.quantity * s.price) AS service_cost "
                + "FROM contract c "
                + "JOIN room r ON c.room_id = r.room_id "
                + "LEFT JOIN usage_service us ON us.contract_id = c.contract_id "
                + "LEFT JOIN service s ON s.service_id = us.service_id "
                + "WHERE c.contract_id = ? "
                + "GROUP BY r.price";

        try (PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, contractId);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {

                BigDecimal room = rs.getBigDecimal("room_price");
                BigDecimal service = rs.getBigDecimal("service_cost");

                if (service == null) {
                    service = BigDecimal.ZERO;
                }

                return room.add(service);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // ==============================
    // AUTO CREATE BILL EVERY MONTH
    // ==============================
    public void createMonthlyBill(int contractId) {

        LocalDate today = LocalDate.now();

        LocalDate period = LocalDate.of(today.getYear(), today.getMonth(), 1);

        LocalDate dueDate = period.plusDays(10);

        BigDecimal total = calculateTotal(contractId);

        Bill bill = new Bill();

        bill.setContractId(contractId);
        bill.setPeriod(period);
        bill.setDueDate(dueDate);
        bill.setTotalAmount(total);
        bill.setStatus("pending");

        insertBill(bill);
    }

    // ==============================
    // CHECK BILL EXISTS FOR MONTH
    // ==============================
    public boolean billExists(int contractId, LocalDate period) {

        String sql = "SELECT COUNT(*) "
                + "FROM bill "
                + "WHERE contract_id = ? "
                + "AND period = ?";

        try (PreparedStatement st = connection.prepareStatement(sql)) {

            st.setInt(1, contractId);
            st.setDate(2, Date.valueOf(period));

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // ==============================
    // MAP RESULTSET -> BILL
    // ==============================
    private Bill mapBill(ResultSet rs) throws SQLException {

        return new Bill(
                rs.getInt("bill_id"),
                rs.getInt("contract_id"),
                rs.getDate("period").toLocalDate(),
                rs.getDate("due_date").toLocalDate(),
                rs.getBigDecimal("total_amount"),
                rs.getString("status"),
                rs.getBoolean("is_deleted")
        );
    }

    // ==============================
    // GET BILLS WITH ROOM NUMBER
    // (owner bill-list / status views)
    // ==============================
    public List<Bill> getBillsWithRoomInfo() {
        List<Bill> list = new ArrayList<>();
        String sql = "SELECT b.*, r.room_number "
                   + "FROM bill b "
                   + "JOIN contract c ON b.contract_id = c.contract_id "
                   + "JOIN room r     ON c.room_id = r.room_id "
                   + "WHERE b.is_deleted = 0 "
                   + "ORDER BY b.bill_id DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Bill b = mapBill(rs);
                b.setRoomNumber(rs.getString("room_number"));
                list.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==============================
    // GET BILL ITEMS BY BILL ID
    // ==============================
    public List<BillItem> getBillItemsByBillId(int billId) {
        List<BillItem> list = new ArrayList<>();
        String sql = "SELECT * FROM bill_item WHERE bill_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, billId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapBillItem(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==============================
    // INSERT BILL + ITEMS (transaction)
    // Returns new bill_id or -1 on failure
    // ==============================
    public int insertBillWithItems(Bill bill, List<BillItem> items) {
        String insertBillSql = "INSERT INTO bill "
                + "(contract_id, period, due_date, total_amount, status, created_at, is_deleted) "
                + "VALUES (?, ?, ?, ?, ?, GETDATE(), 0)";
        String insertItemSql = "INSERT INTO bill_item "
                + "(bill_id, category_id, description, quantity, unit_price) "
                + "VALUES (?, ?, ?, ?, ?)";
        try {
            connection.setAutoCommit(false);

            // Step 1: insert bill, get generated id
            int newBillId;
            try (PreparedStatement st = connection.prepareStatement(
                    insertBillSql, Statement.RETURN_GENERATED_KEYS)) {
                st.setInt(1, bill.getContractId());
                st.setDate(2, Date.valueOf(bill.getPeriod()));
                st.setDate(3, Date.valueOf(bill.getDueDate()));
                st.setBigDecimal(4, bill.getTotalAmount());
                st.setString(5, bill.getStatus() != null ? bill.getStatus() : "pending");
                st.executeUpdate();
                ResultSet keys = st.getGeneratedKeys();
                if (!keys.next()) { connection.rollback(); return -1; }
                newBillId = keys.getInt(1);
            }

            // Step 2: insert each item
            try (PreparedStatement st = connection.prepareStatement(insertItemSql)) {
                for (BillItem item : items) {
                    st.setInt(1, newBillId);
                    st.setInt(2, item.getCategoryId());
                    st.setString(3, item.getDescription());
                    st.setBigDecimal(4, item.getQuantity());
                    st.setBigDecimal(5, item.getUnitPrice());
                    st.addBatch();
                }
                st.executeBatch();
            }

            connection.commit();
            return newBillId;

        } catch (SQLException e) {
            e.printStackTrace();
            try { connection.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        } finally {
            try { connection.setAutoCommit(true); } catch (SQLException e) { e.printStackTrace(); }
        }
        return -1;
    }

    // ==============================
    // UPDATE STATUS ONLY
    // ==============================
    public void updateStatus(int billId, String status) {
        String sql = "UPDATE bill SET status = ? WHERE bill_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setString(1, status);
            st.setInt(2, billId);
            st.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // ==============================
    // MAP RESULTSET -> BILL ITEM
    // ==============================
    private BillItem mapBillItem(ResultSet rs) throws SQLException {
        BillItem item = new BillItem();
        item.setBillItemId(rs.getInt("bill_item_id"));
        item.setBillId(rs.getInt("bill_id"));
        item.setDescription(rs.getString("description"));
        item.setQuantity(rs.getBigDecimal("quantity"));
        item.setUnitPrice(rs.getBigDecimal("unit_price"));
        return item;
    }

}
