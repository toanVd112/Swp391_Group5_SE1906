/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

/**
 *
 * @author Admin
 */
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.Account;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;

public class AccountDAO extends DBConnect {

    public boolean insertAccount(Account account) {
        String sql = "INSERT INTO accounts (Username, Password, Role, IsActive, CreatedAt, Email) VALUES (?, ?, ?, ?, NOW(), ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, account.getUsername());
            ps.setString(2, account.getPassword());
            ps.setString(3, account.getRole());
            ps.setBoolean(4, true);
            ps.setString(5, account.getEmail());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating account failed, no rows affected.");
            }

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    int accountId = generatedKeys.getInt(1);

                    // 👉 Sau khi có accountId ➜ Insert Users
                    insertUser(accountId, account.getUsername(), account.getEmail());

                    return true;
                } else {
                    throw new SQLException("Creating account failed, no ID obtained.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void insertUser(int accountId, String fullName, String email) throws SQLException {
        String sql = "INSERT INTO Users (AccountID, FullName, Email) VALUES (?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);
            ps.setString(2, fullName); // Có thể là tên mặc định, username...
            ps.setString(3, email);

            ps.executeUpdate();
        }
    }

    public boolean isDuplicateAccount(String username, String email) {
        String sql = "SELECT COUNT(*) FROM Accounts WHERE Username = ? OR Email = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, email);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                return count > 0; // nếu tồn tại ít nhất 1 dòng -> trùng
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false; // không có lỗi nhưng không tìm thấy trùng
    }

    public Account login(String username, String password) {
        String sql = "SELECT * FROM accounts WHERE Username = ? AND Password = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Account account = new Account();
                account.setAccountID(rs.getInt("AccountID"));
                account.setUsername(rs.getString("Username"));
                account.setPassword(rs.getString("Password"));
                account.setRole(rs.getString("Role"));
                account.setEmail(rs.getString("Email"));
                return account;
            } //////////////
        } catch (SQLException e) {
            e.printStackTrace();//////////
        }////
        return null; // không tìm thấy tài khoản
    }

    public List<Account> getAccountStaff() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM accounts WHERE Role IN ('Receptionist', 'Staff')";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAccount(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteAccount(String aid) {
        String sql = "DELETE FROM Accounts WHERE AccountID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, aid);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    public void addAccount(String username, String password, String role, boolean isActive, String email) {
        String sql = "INSERT INTO Accounts (Username, Password, Role, IsActive, Email)\n"
                + "VALUES (?,?,?,?,?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);
            ps.setBoolean(4, isActive);
            ps.setString(5, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getLatestAccountID() {
        int latestID = -1;
        String sql = "SELECT AccountID FROM accounts ORDER BY AccountID DESC LIMIT 1";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                latestID = rs.getInt("AccountID");
            }

        } catch (SQLException e) {
            e.printStackTrace(); // Hoặc log lỗi ra hệ thống
        }

        return latestID;
    }

    public Account getAccountByID(String aid) {
        String sql = "SELECT * FROM accounts WHERE AccountID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, Integer.parseInt(aid));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractAccount(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void editAccount(String username, String password, String role, boolean isActive, String email, String aid) {
        String sql = "Update accounts\n"
                + "Set Username = ?,"
                + "Password = ?,"
                + "Role = ?,"
                + "IsActive = ? ,"
                + "Email = ?\n"
                + "Where AccountID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setString(3, role);
            ps.setBoolean(4, isActive);
            ps.setString(5, email);
            ps.setString(6, aid);
            ps.executeUpdate();

        } catch (SQLException e) {
        }
    }

    public List<Account> getFilteredAccountsWithPage(String search, String sort, int offset, int limit) {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM accounts WHERE Role IN ('Staff', 'Receptionist')";
        boolean hasSearch = search != null && !search.trim().isEmpty();

        if (hasSearch) {
            sql += " AND Username LIKE ?";
        }

        if ("asc".equalsIgnoreCase(sort)) {
            sql += " ORDER BY CreatedAt ASC";
        } else if ("desc".equalsIgnoreCase(sort)) {
            sql += " ORDER BY CreatedAt DESC";
        }

        sql += " LIMIT ? OFFSET ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = 1;
            if (hasSearch) {
                ps.setString(index++, "%" + search.trim() + "%");
            }
            ps.setInt(index++, limit);
            ps.setInt(index, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAccount(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countFilteredAccounts(String search) {
        String sql = "SELECT COUNT(*) FROM accounts WHERE Role IN ('Staff', 'Receptionist')";
        boolean hasSearch = search != null && !search.trim().isEmpty();

        if (hasSearch) {
            sql += " AND Username LIKE ?";
        }

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (hasSearch) {
                ps.setString(1, "%" + search.trim() + "%");
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean updatePasswordByEmail(String email, String hashedPassword) {
        String sql = "UPDATE Accounts SET Password = ? WHERE Email = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, hashedPassword);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Account getAccountByEmail(String email) {
        String sql = "SELECT * FROM accounts WHERE Email = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractAccount(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getEmailByAccountId(int accountId) {
        String sql = "SELECT Email FROM Accounts WHERE AccountID = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("Email");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public String getPasswordByEmail(String email) {
        String sql = "SELECT Password FROM Accounts WHERE Email = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("Password");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean verifyAccount(String code) {
        String sql = "UPDATE accounts SET is_verified = TRUE, verification_code = NULL WHERE verification_code = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private Account extractAccount(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setAccountID(rs.getInt("AccountID"));
        account.setUsername(rs.getString("Username"));
        account.setPassword(rs.getString("Password"));
        account.setRole(rs.getString("Role"));
        account.setIsActive(rs.getBoolean("IsActive"));
        account.setCreatedAt(rs.getTimestamp("CreatedAt"));
        account.setEmail(rs.getString("Email"));
        // Không còn xử lý verificationCode, isVerified
        return account;
    }

    public static void main(String[] args) {
        AccountDAO dao = new AccountDAO();
        Account a = dao.getAccountByID("1");
        System.out.println(a);
    }

    public List<Account> getAccountsByRole(String role) throws SQLException {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM accounts WHERE Role = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, role);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Account acc = new Account();
                acc.setAccountID(rs.getInt("AccountID"));
                acc.setUsername(rs.getString("Username"));
                list.add(acc);
            }
        }
        return list;
    }

    public List<Account> getFilteredAccountsWithPageC(String search, String sort, int offset, int limit) {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM accounts WHERE Role IN ('Customer')";
        boolean hasSearch = search != null && !search.trim().isEmpty();

        if (hasSearch) {
            sql += " AND Username LIKE ?";
        }

        if ("asc".equalsIgnoreCase(sort)) {
            sql += " ORDER BY CreatedAt ASC";
        } else if ("desc".equalsIgnoreCase(sort)) {
            sql += " ORDER BY CreatedAt DESC";
        }

        sql += " LIMIT ? OFFSET ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            int index = 1;
            if (hasSearch) {
                ps.setString(index++, "%" + search.trim() + "%");
            }
            ps.setInt(index++, limit);
            ps.setInt(index, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractAccount(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int countFilteredAccountsC(String search) {
        String sql = "SELECT COUNT(*) FROM accounts WHERE Role IN ('Customer')";
        boolean hasSearch = search != null && !search.trim().isEmpty();

        if (hasSearch) {
            sql += " AND Username LIKE ?";
        }

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            if (hasSearch) {
                ps.setString(1, "%" + search.trim() + "%");
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public void editAccountC(String username, String password, boolean isActive, String email, String aid) {
        String sql = "Update accounts\n"
                + "Set Username = ?,"
                + "Password = ?,"
                + "Role = 'Customer',"
                + "IsActive = ? ,"
                + "Email = ?\n"
                + "Where AccountID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ps.setBoolean(3, isActive);
            ps.setString(4, email);
            ps.setString(5, aid);
            ps.executeUpdate();

        } catch (SQLException e) {
        }
    }

    public void addAccountC(String username, String password, boolean isActive, String email) {
        String sql = "INSERT INTO Accounts (Username, Password, Role, IsActive, Email)\n"
                + "VALUES (?,?,'Customer',?,?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);
            ps.setBoolean(3, isActive);
            ps.setString(4, email);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public Integer getUserIDByAccountID(int accountId) throws SQLException {
        String sql = "SELECT UserID FROM Users WHERE AccountID = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("UserID");
                }
            }
        }
        return null;
    }

    public boolean changePassword(String email, String currentPassword, String newPassword) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnect.getConnection();
            // Lấy mật khẩu hiện tại từ email
            String oldPassword = getPasswordByEmail(email);
            if (oldPassword == null) {
                return false; // Email không tồn tại
            }

        // Kiểm tra mật khẩu hiện tại
            if (!oldPassword.equals(currentPassword)) {
                return false; // Mật khẩu hiện tại không đúng
            }

        // Kiểm tra mật khẩu mới không trùng với mật khẩu cũ
            if (oldPassword.equals(newPassword)) {
                return false; // Mật khẩu mới trùng mật khẩu cũ
            }

        // Kiểm tra độ dài mật khẩu (tối thiểu 6 ký tự)
            if (newPassword.length() < 6) {
                return false; // Mật khẩu quá ngắn
            }

        // Cập nhật mật khẩu mới
            String sql = "UPDATE Accounts SET Password = ? WHERE Email = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, newPassword);
                ps.setString(2, email);
                int rowsAffected = ps.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e; // Ném lại ngoại lệ để Servlet xử lý
        } finally {
            if (conn != null) {
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }
}
