/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import DAO.DBConnect;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
/**
 *
 * @author AD
 */
public class TokenDAO extends DBConnect{
    public void insertToken(String token, java.sql.Timestamp expiryTime, boolean isUsed, int accountId) {
        String sql = "INSERT INTO tokenForgetPassword (token, expiryTime, isUsed, accountId) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.setTimestamp(2, expiryTime);
            ps.setBoolean(3, isUsed);
            ps.setInt(4, accountId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public TokenInfo getTokenInfo(String token) {
        String sql = "SELECT * FROM tokenForgetPassword WHERE token = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                TokenInfo info = new TokenInfo();
                info.setAccountId(rs.getInt("accountId"));
                info.setExpiryTime(rs.getTimestamp("expiryTime"));   
                info.setUsed(rs.getBoolean("isUsed"));         // BỔ SUNG DÒNG NÀY
                info.setToken(rs.getString("token")); 
                return info;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public void markTokenAsUsed(String token) {
        String sql = "UPDATE tokenForgetPassword SET isUsed = 1 WHERE token = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, token);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }
}
