package DALs;

import Models.DepositTransaction;
import Utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

/**
 * Data access layer for the deposit_transaction table.
 * Supports: insert deposit/refund/deduction, list by contract, list all (owner view).
 */
public class DepositDAO extends DBContext {

    // ==============================
    // INSERT TRANSACTION
    // ==============================
    /**
     * Inserts a new deposit_transaction row.
     * @return generated deposit_id, or -1 on failure
     */
    public int insert(DepositTransaction dt) {
        String sql = "INSERT INTO deposit_transaction "
                   + "(contract_id, amount, transaction_type, note, created_at, created_by) "
                   + "VALUES (?, ?, ?, ?, GETDATE(), ?)";
        try (PreparedStatement st = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            st.setInt(1, dt.getContractId());
            st.setBigDecimal(2, dt.getAmount());
            st.setString(3, dt.getTransactionType());
            st.setString(4, dt.getNote());
            st.setInt(5, dt.getCreatedBy());
            st.executeUpdate();
            ResultSet keys = st.getGeneratedKeys();
            if (keys.next()) return keys.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    // ==============================
    // GET BY CONTRACT
    // ==============================
    public List<DepositTransaction> getByContractId(int contractId) {
        List<DepositTransaction> list = new ArrayList<>();
        String sql = "SELECT dt.*, r.room_number "
                   + "FROM deposit_transaction dt "
                   + "JOIN contract c ON dt.contract_id = c.contract_id "
                   + "JOIN room r     ON c.room_id = r.room_id "
                   + "WHERE dt.contract_id = ? "
                   + "ORDER BY dt.created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, contractId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==============================
    // GET ALL (owner overview)
    // ==============================
    public List<DepositTransaction> getAll() {
        List<DepositTransaction> list = new ArrayList<>();
        String sql = "SELECT dt.*, r.room_number "
                   + "FROM deposit_transaction dt "
                   + "JOIN contract c ON dt.contract_id = c.contract_id "
                   + "JOIN room r     ON c.room_id = r.room_id "
                   + "ORDER BY dt.created_at DESC";
        try (PreparedStatement st = connection.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // ==============================
    // GET BY ID
    // ==============================
    public DepositTransaction getById(int depositId) {
        String sql = "SELECT dt.*, r.room_number "
                   + "FROM deposit_transaction dt "
                   + "JOIN contract c ON dt.contract_id = c.contract_id "
                   + "JOIN room r     ON c.room_id = r.room_id "
                   + "WHERE dt.deposit_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, depositId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) return mapRow(rs);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==============================
    // SUM BALANCE FOR CONTRACT
    // deposit - refund - deduction
    // ==============================
    public BigDecimal getBalance(int contractId) {
        String sql = "SELECT "
                   + "  SUM(CASE WHEN transaction_type = 'deposit'   THEN amount ELSE 0 END) "
                   + "- SUM(CASE WHEN transaction_type = 'refund'    THEN amount ELSE 0 END) "
                   + "- SUM(CASE WHEN transaction_type = 'deduction' THEN amount ELSE 0 END) AS balance "
                   + "FROM deposit_transaction WHERE contract_id = ?";
        try (PreparedStatement st = connection.prepareStatement(sql)) {
            st.setInt(1, contractId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                BigDecimal balance = rs.getBigDecimal("balance");
                return balance != null ? balance : BigDecimal.ZERO;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    // ==============================
    // MAP ROW
    // ==============================
    private DepositTransaction mapRow(ResultSet rs) throws SQLException {
        DepositTransaction dt = new DepositTransaction();
        dt.setDepositId(rs.getInt("deposit_id"));
        dt.setContractId(rs.getInt("contract_id"));
        dt.setAmount(rs.getBigDecimal("amount"));
        dt.setTransactionType(rs.getString("transaction_type"));
        dt.setNote(rs.getString("note"));
        dt.setCreatedBy(rs.getInt("created_by"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) dt.setCreatedAt(ts.toLocalDateTime());
        // joined
        try { dt.setRoomNumber(rs.getString("room_number")); } catch (SQLException ignored) {}
        return dt;
    }
}
