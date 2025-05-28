/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.Account;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.CustomerQuestion;

/**
 *
 * @author Admin
 */
public class CustomerQuestionDAO {

    public List<CustomerQuestion> getAllQuestions() {
        List<CustomerQuestion> list = new ArrayList<>();
        String sql = "SELECT * FROM CustomerQuestions ORDER BY CreatedAt DESC";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CustomerQuestion q = new CustomerQuestion();
                q.setQuestionID(rs.getInt("QuestionID"));
                q.setCustomerName(rs.getString("CustomerName"));
                q.SetEmail(rs.getString("Email"));
                q.SetQuestion(rs.getString("Question"));
                q.setCreateAt(rs.getTimestamp("CreatedAt"));
                q.setAdminReply(rs.getString("AdminReply"));
                q.setRepliedAt(rs.getTimestamp("RepliedAt"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void replyToQuestion(int questionID, String reply) {
        String sql = "UPDATE CustomerQuestions SET AdminReply = ?, RepliedAt = NOW() WHERE QuestionID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setInt(2, questionID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void insertQuestion(String name, String email, String question) {
        String sql = "INSERT INTO CustomerQuestions (CustomerName, Email, Question, CreatedAt) VALUES (?, ?, ?, NOW())";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, question);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
