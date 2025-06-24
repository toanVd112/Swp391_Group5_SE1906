package DAO;

import model.DiscountCode;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DiscountCodeDAO {

    // Get a single discount code by ID
    public DiscountCode getDiscountCodeByID(int id) {
        DiscountCode dc = null;
        String sql = "SELECT * FROM discountcodes WHERE DiscountCodeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    dc = new DiscountCode();
                    dc.setDiscountCodeID(rs.getInt("DiscountCodeID"));
                    dc.setCode(rs.getString("Code"));
                    dc.setDiscountPercent(rs.getDouble("DiscountPercent"));
                    dc.setExpiryDate(rs.getObject("ExpiryDate", LocalDate.class));
                    dc.setType(rs.getString("type"));
                    dc.setStatus(rs.getString("status"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dc;
    }

    // Get all distinct discount code types
    public List<String> getAllDistinctDiscountTypes() {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT type FROM discountcodes WHERE type IS NOT NULL AND type <> '' ORDER BY type ASC";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                types.add(rs.getString("type"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return types;
    }

    // Get filtered discount codes
    public List<DiscountCode> getFilteredDiscountCodes(String keyword, String type, String status) {
        List<DiscountCode> discountCodes = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM discountcodes WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND Code LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND type = ?");
            params.add(type.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status.trim());
        }

        sql.append(" ORDER BY DiscountCodeID ASC");

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DiscountCode dc = new DiscountCode();
                    dc.setDiscountCodeID(rs.getInt("DiscountCodeID"));
                    dc.setCode(rs.getString("Code"));
                    dc.setDiscountPercent(rs.getDouble("DiscountPercent"));
                    dc.setExpiryDate(rs.getObject("ExpiryDate", LocalDate.class));
                    dc.setType(rs.getString("type"));
                    dc.setStatus(rs.getString("status"));
                    discountCodes.add(dc);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return discountCodes;
    }

    // Add a new discount code
    public boolean addDiscountCode(DiscountCode dc) {
        String sql = "INSERT INTO discountcodes (Code, DiscountPercent, ExpiryDate, type, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dc.getCode());
            ps.setDouble(2, dc.getDiscountPercent());
            ps.setObject(3, dc.getExpiryDate());
            ps.setString(4, dc.getType());
            ps.setString(5, dc.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update an existing discount code
    public boolean updateDiscountCode(DiscountCode dc) {
        String sql = "UPDATE discountcodes SET Code = ?, DiscountPercent = ?, ExpiryDate = ?, type = ?, status = ? WHERE DiscountCodeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, dc.getCode());
            ps.setDouble(2, dc.getDiscountPercent());
            ps.setObject(3, dc.getExpiryDate());
            ps.setString(4, dc.getType());
            ps.setString(5, dc.getStatus());
            ps.setInt(6, dc.getDiscountCodeID());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Toggle discount code status (Active/Inactive)
    public boolean toggleDiscountCodeStatus(int id) {
        String sql = "UPDATE discountcodes SET status = CASE WHEN status = 'Active' THEN 'Inactive' ELSE 'Active' END WHERE DiscountCodeID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check for duplicate discount code
    public boolean isDuplicatedCode(String code) {
        String sql = "SELECT 1 FROM discountcodes WHERE Code = ? LIMIT 1";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}