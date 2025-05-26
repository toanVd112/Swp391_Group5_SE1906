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

public class AccountDAO {

    public boolean insertAccount(Account account) {
        String sql = "INSERT INTO accounts (Username, Password, Role, IsActive, CreatedAt, Email) VALUES (?, ?, ?, ?, NOW(), ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, account.getUsername());
            ps.setString(2, account.getPassword());
            ps.setString(3, account.getRole());
            ps.setBoolean(4, true);
            ps.setString(5, account.getEmail());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
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
        }
        return null; // không tìm thấy tài khoản
    }

}

//test commit
//nhap pass vô hạn 