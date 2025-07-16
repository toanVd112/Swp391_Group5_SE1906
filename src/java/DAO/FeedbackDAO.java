/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import static DAO.DBConnect.getConnection;
import model.Feedback;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Arcueid
 */
public class FeedbackDAO {

    // Thêm đánh giá mới
    public void insertFeedback(Feedback fb) throws SQLException {
        String sql = """
            INSERT INTO feedback (UserID, BookingID, Rating, Comment, FeedbackDate,
                                  ShowEmail, ShowFacebook, ShowInstagram)
            VALUES (?, ?, ?, ?, NOW(), ?, ?, ?)
        """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, fb.getUserID());
            ps.setInt(2, fb.getBookingID());
            ps.setInt(3, fb.getRating());
            ps.setString(4, fb.getComment());
            ps.setBoolean(5, fb.isShowEmail());
            ps.setBoolean(6, fb.isShowFacebook());
            ps.setBoolean(7, fb.isShowInstagram());
            ps.executeUpdate();
        }
    }

    // Lấy danh sách feedback theo loại phòng, bao gồm thông tin người dùng
  public List<Feedback> getFeedbacksByRoomType(int roomTypeID) throws SQLException {
    List<Feedback> list = new ArrayList<>();
    String sql = """
        SELECT f.*, u.FullName, u.Email, u.Facebook, u.Instagram, u.Gender
        FROM feedback f
        JOIN users u ON f.UserID = u.UserID
        JOIN bookings b ON f.BookingID = b.BookingID
        JOIN bookingdetails bd ON b.BookingID = bd.BookingID
        JOIN rooms r ON bd.RoomID = r.RoomID
        WHERE r.RoomTypeID = ?
        ORDER BY f.FeedbackDate DESC
    """;
    try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, roomTypeID);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            Feedback fb = new Feedback();
            fb.setFeedbackID(rs.getInt("FeedbackID"));
            fb.setUserID(rs.getInt("UserID"));
            fb.setBookingID(rs.getInt("BookingID"));
            fb.setRating(rs.getInt("Rating"));
            fb.setComment(rs.getString("Comment"));
            fb.setFeedbackDate(rs.getTimestamp("FeedbackDate"));

            // Thông tin người dùng
            fb.setFullName(rs.getString("FullName"));
            fb.setEmail(rs.getString("Email"));
            fb.setFacebook(rs.getString("Facebook"));
            fb.setInstagram(rs.getString("Instagram"));
            fb.setGender(rs.getString("Gender"));

            // Tùy chọn hiển thị
            fb.setShowEmail(rs.getBoolean("ShowEmail"));
            fb.setShowFacebook(rs.getBoolean("ShowFacebook"));
            fb.setShowInstagram(rs.getBoolean("ShowInstagram"));

            list.add(fb);
        }
    }
    return list;
}

    // Kiểm tra người dùng đã thuê loại phòng chưa
    public boolean hasBookedRoomType(int userID, int roomTypeID) throws SQLException {
        String sql = """
            SELECT COUNT(*) FROM bookings b
            JOIN bookingdetails bd ON b.BookingID = bd.BookingID
            JOIN rooms r ON bd.RoomID = r.RoomID
            WHERE b.UserID = ? AND r.RoomTypeID = ?
        """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setInt(2, roomTypeID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    // Lấy điểm trung bình đánh giá
    public double getAverageRatingByRoomType(int roomTypeID) throws SQLException {
        String sql = """
            SELECT AVG(Rating) FROM feedback f
            JOIN bookings b ON f.BookingID = b.BookingID
            JOIN bookingdetails bd ON b.BookingID = bd.BookingID
            JOIN rooms r ON bd.RoomID = r.RoomID
            WHERE r.RoomTypeID = ?
        """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        }
        return 0.0;
    }

    // Phân phối số lượng feedback theo từng mức sao
    public Map<Integer, Integer> getRatingDistribution(int roomTypeID) throws SQLException {
        Map<Integer, Integer> map = new HashMap<>();
        for (int i = 1; i <= 5; i++) {
            map.put(i, 0);
        }

        String sql = """
            SELECT Rating, COUNT(*) as Count FROM feedback f
            JOIN bookings b ON f.BookingID = b.BookingID
            JOIN bookingdetails bd ON b.BookingID = bd.BookingID
            JOIN rooms r ON bd.RoomID = r.RoomID
            WHERE r.RoomTypeID = ?
            GROUP BY Rating
        """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roomTypeID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int rating = rs.getInt("Rating");
                int count = rs.getInt("Count");
                map.put(rating, count);
            }
        }
        return map;
    }

    public Integer getAnyBookingIDForUser(int userID, int roomTypeID) throws SQLException {
        String sql = """
        SELECT b.BookingID
        FROM bookings b
        JOIN bookingdetails bd ON b.BookingID = bd.BookingID
        JOIN rooms r ON bd.RoomID = r.RoomID
        WHERE b.UserID = ? AND r.RoomTypeID = ?
        ORDER BY b.BookingDate DESC
        LIMIT 1
    """;
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setInt(2, roomTypeID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("BookingID");
            }
        }
        return null;
    }
}
