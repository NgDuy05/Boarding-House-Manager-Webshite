package DALs;

import Utils.DBContext;
import Models.PriceCategory;
import Models.PriceHistory;

import java.math.BigDecimal;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PriceDAO extends DBContext {

    // ===============================
    // GET ALL PRICE
    // ===============================
    public List<PriceHistory> getAllPrices() {

        List<PriceHistory> list = new ArrayList<>();

        String sql = "SELECT price_id, category_id, price_amount, effective_from "
                + "FROM price_history "
                + "ORDER BY effective_from DESC";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {

                PriceHistory p = new PriceHistory();

                p.setPriceId(rs.getInt("price_id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setPriceAmount(rs.getBigDecimal("price_amount"));
                p.setEffectiveFrom(rs.getDate("effective_from").toLocalDate());

                list.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ===============================
    // GET PRICE BY ID
    // ===============================
    public PriceHistory getPriceById(int priceId) {

        String sql = "SELECT price_id, category_id, price_amount, effective_from "
                + "FROM price_history "
                + "WHERE price_id = ?";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, priceId);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {

                PriceHistory p = new PriceHistory();

                p.setPriceId(rs.getInt("price_id"));
                p.setCategoryId(rs.getInt("category_id"));
                p.setPriceAmount(rs.getBigDecimal("price_amount"));
                p.setEffectiveFrom(rs.getDate("effective_from").toLocalDate());

                return p;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // ===============================
    // INSERT PRICE
    // ===============================
    public void insertPrice(PriceHistory price) {

        String sql = "INSERT INTO price_history "
                + "(category_id, price_amount, effective_from) "
                + "VALUES (?, ?, ?)";

        try {

            PreparedStatement st = connection.prepareStatement(sql);

            st.setInt(1, price.getCategoryId());
            st.setBigDecimal(2, price.getPriceAmount());
            st.setDate(3, Date.valueOf(price.getEffectiveFrom()));

            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // UPDATE PRICE
    // ===============================
    public void updatePrice(PriceHistory price) {

        String sql = "UPDATE price_history "
                + "SET category_id = ?, "
                + "price_amount = ?, "
                + "effective_from = ? "
                + "WHERE price_id = ?";

        try {

            PreparedStatement st = connection.prepareStatement(sql);

            st.setInt(1, price.getCategoryId());
            st.setBigDecimal(2, price.getPriceAmount());
            st.setDate(3, Date.valueOf(price.getEffectiveFrom()));
            st.setInt(4, price.getPriceId());

            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // DELETE PRICE
    // ===============================
    public void deletePrice(int priceId) {

        String sql = "DELETE FROM price_history WHERE price_id = ?";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, priceId);

            st.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // INSERT PRICE CATEGORY
    // ===============================
    public void insertCategory(PriceCategory cat) {
        String sql = "INSERT INTO price_category (category_code, category_type, unit, is_deleted) VALUES (?, ?, ?, 0)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, cat.getCategoryCode());
            st.setString(2, cat.getCategoryType());
            st.setString(3, cat.getUnit());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // GET CATEGORY BY ID
    // ===============================
    public PriceCategory getCategoryById(int categoryId) {
        String sql = "SELECT category_id, category_code, category_type, unit, is_deleted "
                + "FROM price_category WHERE category_id = ? AND is_deleted = 0";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                PriceCategory c = new PriceCategory();
                c.setCategoryId(rs.getInt("category_id"));
                c.setCategoryCode(rs.getString("category_code"));
                c.setCategoryType(rs.getString("category_type"));
                c.setUnit(rs.getString("unit"));
                c.setIsDeleted(rs.getBoolean("is_deleted"));
                return c;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ===============================
    // UPDATE PRICE CATEGORY
    // ===============================
    public void updateCategory(PriceCategory cat) {
        String sql = "UPDATE price_category SET category_code = ?, category_type = ?, unit = ? WHERE category_id = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, cat.getCategoryCode());
            st.setString(2, cat.getCategoryType());
            st.setString(3, cat.getUnit());
            st.setInt(4, cat.getCategoryId());
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ===============================
    // GET ALL PRICE CATEGORIES
    // ===============================
    public List<PriceCategory> getAllPriceCategories() {
        List<PriceCategory> list = new ArrayList<>();
        String sql = "SELECT category_id, category_code, category_type, unit, is_deleted "
                + "FROM price_category WHERE is_deleted = 0 "
                + "ORDER BY category_type, category_code";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                PriceCategory c = new PriceCategory();
                c.setCategoryId(rs.getInt("category_id"));
                c.setCategoryCode(rs.getString("category_code"));
                c.setCategoryType(rs.getString("category_type"));
                c.setUnit(rs.getString("unit"));
                c.setIsDeleted(rs.getBoolean("is_deleted"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // ===============================
    // GET CURRENT PRICE
    // ===============================
    public BigDecimal getCurrentPrice(int categoryId) {

        String sql = "SELECT TOP 1 price_amount "
                + "FROM price_history "
                + "WHERE category_id = ? "
                + "ORDER BY effective_from DESC";

        try {

            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal("price_amount");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }

    // ===============================
    // GET PRICE BY DATE
    // ===============================
    public BigDecimal getPriceByDate(int categoryId, Date date) {

        String sql = "SELECT TOP 1 price_amount "
                + "FROM price_history "
                + "WHERE category_id = ? "
                + "AND effective_from <= ? "
                + "ORDER BY effective_from DESC";

        try {

            PreparedStatement st = connection.prepareStatement(sql);

            st.setInt(1, categoryId);
            st.setDate(2, date);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getBigDecimal("price_amount");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return BigDecimal.ZERO;
    }
}
