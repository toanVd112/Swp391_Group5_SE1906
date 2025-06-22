package DAO;

import model.User;
import java.sql.*;

/**
 * DAO lớp User: 
 * - getUserByAccountId() đọc thêm dateOfBirth 
 * - insertUser() chèn thêm dateOfBirth 
 * - updateUser() cập nhật thêm dateOfBirth
 */
public class UserDao {

    public User getUserByAccountId(int accountId) {
        String sql = "SELECT * FROM Users WHERE AccountID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("UserID"));
                user.setAccountId(accountId);
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setPhone(rs.getString("Phone"));
                user.setDateOfBirth(rs.getString("DateOfBirth"));
                user.setAddress(rs.getString("Address"));
                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /** Chèn thêm thông tin DOB */
    public boolean insertUser(User user) {
        String sql = """
            INSERT INTO Users
              (AccountID, FullName, Email, Phone, DateOfBirth, Address)
            VALUES (?,?,?,?,?,?)
            """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, user.getAccountId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getDateOfBirth());
            ps.setString(6, user.getAddress());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Cập nhật thêm DOB */
    public boolean updateUser(User user) {
        String sql = """
            UPDATE Users
               SET FullName    = ?,
                   Email       = ?,
                   Phone       = ?,
                   DateOfBirth = ?,
                   Address     = ?
             WHERE AccountID   = ?
            """;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setString(4, user.getDateOfBirth());
            ps.setString(5, user.getAddress());
            ps.setInt(6, user.getAccountId());
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
