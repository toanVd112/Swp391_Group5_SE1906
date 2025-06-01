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

public class AccountDAO extends DBConnect{

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
        }////
        return null; // không tìm thấy tài khoản
    }

    public List<Account> getAccountStaff() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM accounts\n"
                + "WHERE Role IN ('Receptionist', 'Staff')";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Account(rs.getInt("AccountID"),
                        rs.getString("Username"),
                        rs.getString("Password"),
                        rs.getString("Role"),
                        rs.getBoolean("IsActive"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("Email")
                ));
            }
        } catch (SQLException e) {
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

        String sql = "SELECT * FROM accounts\n"
                + "WHERE AccountID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, aid);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return new Account(rs.getInt("AccountID"),
                        rs.getString("Username"),
                        rs.getString("Password"),
                        rs.getString("Role"),
                        rs.getBoolean("IsActive"),
                        rs.getTimestamp("CreatedAt"),
                        rs.getString("Email")
                );
            }
        } catch (SQLException e) {
        }
        return null;
    }

    public void editAccount(String username, String password, String role, boolean isActive, String email,String aid) {
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

    public static void main(String[] args) {
        AccountDAO dao = new AccountDAO();
        Account a = dao.getAccountByID("1");
        System.out.println(a);
    }

}

//test commit
//nhap pass vô hạn 
//commit 1