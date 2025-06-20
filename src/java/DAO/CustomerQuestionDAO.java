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
        String sql = "SELECT * FROM CustomerQuestions ORDER BY SubmittedAt DESC";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                CustomerQuestion q = new CustomerQuestion();
                q.setQuestionID(rs.getInt("QuestionID"));
                q.setCustomerName(rs.getString("CustomerName"));
                q.setPhone(rs.getString("Phone"));
                q.setQuestion(rs.getString("Message"));
                q.setCreatedAt(rs.getTimestamp("SubmittedAt"));
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

    public void insertQuestion(String name, String phone, String question) {
        String sql = "INSERT INTO CustomerQuestions (CustomerName, Phone, Message, SubmittedAt) VALUES (?, ?, ?, NOW())";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, question);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<CustomerQuestion> getQuestionsByPhone(String phone) {
        List<CustomerQuestion> list = new ArrayList<>();
        String sql = "SELECT * FROM CustomerQuestions "
                + "WHERE Phone = ? ORDER BY SubmittedAt DESC";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomerQuestion q = new CustomerQuestion();
                q.setQuestionID(rs.getInt("QuestionID"));
                q.setCustomerName(rs.getString("CustomerName"));
                q.setPhone(rs.getString("Phone"));
                q.setQuestion(rs.getString("Message"));
                q.setCreatedAt(rs.getTimestamp("SubmittedAt"));
                q.setAdminReply(rs.getString("AdminReply"));
                q.setRepliedAt(rs.getTimestamp("RepliedAt"));
                list.add(q);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void main(String[] args) {
        CustomerQuestionDAO o = new CustomerQuestionDAO();
        List<CustomerQuestion> questions = new ArrayList<>();
        questions = o.getQuestionsByPhone("1111111111");
        System.out.println(questions);
    }
}
