package DAO;

import model.User;
import java.sql.*;

/**
 * DAO lớp User: - getUserByAccountId() đọc thêm dateOfBirth - insertUser() chèn
 * thêm dateOfBirth - updateUser() cập nhật thêm dateOfBirth
 */
public class UserDao extends DBConnect {

    public User getUserByAccountId(int accountId) {
        User user = null;
        String query = "SELECT * FROM Users WHERE AccountID = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, accountId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("UserID"));
                user.setAccountId(rs.getInt("AccountID"));
                user.setFullName(rs.getString("FullName"));
                user.setEmail(rs.getString("Email"));
                user.setPhone(rs.getString("Phone"));
                user.setDateOfBirth(rs.getString("DateOfBirth"));
                user.setAddress(rs.getString("Address"));
                user.setAvatarPath(rs.getString("avatar_path"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean updateUser(User user) {
        String query = "UPDATE Users SET FullName = ?, Email = ?, Phone = ?, DateOfBirth = ?, Address = ?, avatar_path = ? WHERE AccountID = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, user.getFullName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setString(4, user.getDateOfBirth());
            stmt.setString(5, user.getAddress());
            stmt.setString(6, user.getAvatarPath());
            stmt.setInt(7, user.getAccountId());

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserInfoByAccountID(int accountId) throws SQLException {
        String sql = "SELECT UserID, FullName, Email, Phone FROM Users WHERE AccountID = ?";

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, accountId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("UserID"));
                    user.setFullName(rs.getString("FullName"));
                    user.setEmail(rs.getString("Email"));
                    user.setPhone(rs.getString("Phone"));
                    return user;
                }
            }
        }
        return null;
    }

    public static void main(String[] args) {
        UserDao uDao = new UserDao();
        int accountId = 28; // 👈 Thay bằng AccountID bạn muốn test

        try {
            User user = uDao.getUserInfoByAccountID(accountId);
            if (user != null) {
                System.out.println("✅ Found user:");
                System.out.println("UserID: " + user.getUserId());
                System.out.println("FullName: " + user.getFullName());
                System.out.println("Email: " + user.getEmail());
                System.out.println("Phone: " + user.getPhone());
            } else {
                System.out.println("❌ No user found for AccountID: " + accountId);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

    }
}
