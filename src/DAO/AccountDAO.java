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

public class AccountDAO {

   public boolean insertAccount(Account account) {
        String sql = "INSERT INTO accounts (Username, Password, Role, IsActive, CreatedAt, Email) VALUES (?, ?, ?, ?, NOW(), ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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
}
