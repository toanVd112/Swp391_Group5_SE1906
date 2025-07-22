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
import model.RoomType;
import model.User;

/**
 *
 * @author Arcueid
 */
public class FeedbackDAO {

    public boolean submitFeedback(Feedback feedback) {
        String sql = "INSERT INTO feedback (BookingID, UserID, RoomTypeID, Rating, Comment, IsAnonymous) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedback.getBookingID());
            stmt.setInt(2, feedback.getUserID());
            stmt.setInt(3, feedback.getRoomTypeID());
            stmt.setInt(4, feedback.getRating());
            stmt.setString(5, feedback.getComment());
            stmt.setBoolean(6, feedback.isAnonymous());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check if user can submit feedback (booking must be completed and checked out)
    public boolean canSubmitFeedback(int bookingID, int userID) {
        String sql = "SELECT COUNT(*) FROM bookings b "
                + "WHERE b.BookingID = ? AND b.UserID = ? "
                + "AND b.Status = 'Completed' "
                + "AND b.ActualCheckOutTime IS NOT NULL "
                + "AND NOT EXISTS (SELECT 1 FROM feedback f WHERE f.BookingID = ?)";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, bookingID);
            stmt.setInt(2, userID);
            stmt.setInt(3, bookingID);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    // Get all feedback for a specific room type with user information
    public List<Feedback> getFeedbackByRoomType(int roomTypeID) {
        List<Feedback> feedbackList = new ArrayList<>();
        String query = "SELECT f.*, rt.Name as RoomTypeName, "
                + "u.FullName, u.Email, u.avatar_path, "
                + "a.AccountID "
                + "FROM feedback f "
                + "JOIN roomtypes rt ON f.RoomTypeID = rt.RoomTypeID "
                + "JOIN users u ON f.UserID = u.UserID "
                + "JOIN accounts a ON u.AccountID = a.AccountID "
                + "WHERE f.RoomTypeID = ? "
                + "ORDER BY f.FeedbackDate DESC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, roomTypeID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackID(rs.getInt("FeedbackID"));
                feedback.setBookingID(rs.getInt("BookingID"));
                feedback.setUserID(rs.getInt("UserID"));
                feedback.setRoomTypeID(rs.getInt("RoomTypeID"));
                feedback.setRating(rs.getInt("Rating"));
                feedback.setComment(rs.getString("Comment"));
                feedback.setFeedbackDate(rs.getTimestamp("FeedbackDate"));
                feedback.setAnonymous(rs.getBoolean("IsAnonymous"));
                feedback.setRoomTypeName(rs.getString("RoomTypeName"));

                // Set user information based on anonymous flag
                if (!feedback.isAnonymous()) {
                    feedback.setUserName(rs.getString("FullName"));
                    feedback.setUserEmail(rs.getString("Email"));
                    feedback.setUserAvatar(rs.getString("avatar_path"));
                } else {
                    feedback.setUserName("Anonymous Guest");
                    feedback.setUserEmail("");
                    feedback.setUserAvatar("/images/anonymous-avatar.png");
                }

                feedbackList.add(feedback);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return feedbackList;
    }

    // Get average rating for a room type
    public double getAverageRating(int roomTypeID) {
        String sql = "SELECT AVG(Rating) as AvgRating FROM feedback WHERE RoomTypeID = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, roomTypeID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return rs.getDouble("AvgRating");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    // Get rating distribution for a room type
    public int[] getRatingDistribution(int roomTypeID) {
        int[] distribution = new int[5]; // Index 0 = 1 star, Index 4 = 5 stars
        String sql = "SELECT Rating, COUNT(*) as Count FROM feedback WHERE RoomTypeID = ? GROUP BY Rating";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, roomTypeID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int rating = rs.getInt("Rating");
                int count = rs.getInt("Count");
                if (rating >= 1 && rating <= 5) {
                    distribution[rating - 1] = count;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return distribution;
    }

    // Get user's completed bookings that can be reviewed
    public List<Feedback> getReviewableBookings(int userID) {
        List<Feedback> reviewableBookings = new ArrayList<>();
        String sql = "SELECT b.BookingID, b.CheckInDate, b.CheckOutDate, "
                + "bd.RoomTypeID, rt.Name as RoomTypeName "
                + "FROM bookings b "
                + "JOIN bookingdetails bd ON b.BookingID = bd.BookingID "
                + "JOIN roomtypes rt ON bd.RoomTypeID = rt.RoomTypeID "
                + "WHERE b.UserID = ? AND b.Status = 'Completed' "
                + "AND b.ActualCheckOutTime IS NOT NULL "
                + "AND NOT EXISTS (SELECT 1 FROM feedback f WHERE f.BookingID = b.BookingID) "
                + "ORDER BY b.CheckOutDate DESC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setBookingID(rs.getInt("BookingID"));
                feedback.setUserID(userID);
                feedback.setRoomTypeID(rs.getInt("RoomTypeID"));
                feedback.setRoomTypeName(rs.getString("RoomTypeName"));

                reviewableBookings.add(feedback);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return reviewableBookings;
    }

    // Get user by UserID - synchronized with UserDao pattern
    public User getUserByUserId(int userId) {
        User user = null;
        String query = "SELECT u.*, a.AccountID FROM users u "
                + "JOIN accounts a ON u.AccountID = a.AccountID "
                + "WHERE u.UserID = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userId);
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

    // Get feedback by feedback ID
    public Feedback getFeedbackById(int feedbackID) {
        Feedback feedback = null;
        String query = "SELECT f.*, rt.Name as RoomTypeName, rt.RoomTypeImage, "
                + "u.FullName, u.Email, u.avatar_path "
                + "FROM feedback f "
                + "JOIN roomtypes rt ON f.RoomTypeID = rt.RoomTypeID "
                + "JOIN users u ON f.UserID = u.UserID "
                + "WHERE f.FeedbackID = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, feedbackID);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                feedback = new Feedback();
                feedback.setFeedbackID(rs.getInt("FeedbackID"));
                feedback.setBookingID(rs.getInt("BookingID"));
                feedback.setUserID(rs.getInt("UserID"));
                feedback.setRoomTypeID(rs.getInt("RoomTypeID"));
                feedback.setRating(rs.getInt("Rating"));
                feedback.setComment(rs.getString("Comment"));
                feedback.setFeedbackDate(rs.getTimestamp("FeedbackDate"));
                feedback.setAnonymous(rs.getBoolean("IsAnonymous"));
                feedback.setRoomTypeName(rs.getString("RoomTypeName"));

                // Create and set room type information
                RoomType roomType = new RoomType();
                roomType.setRoomTypeID(rs.getInt("RoomTypeID"));
                roomType.setName(rs.getString("RoomTypeName"));
                roomType.setImageUrl(rs.getString("RoomTypeImage"));
                feedback.setRoomType(roomType);

                // Set user information
                if (!feedback.isAnonymous()) {
                    feedback.setUserName(rs.getString("FullName"));
                    feedback.setUserEmail(rs.getString("Email"));
                    feedback.setUserAvatar(rs.getString("avatar_path"));
                } else {
                    feedback.setUserName("Anonymous Guest");
                    feedback.setUserEmail("");
                    feedback.setUserAvatar("/images/anonymous-avatar.png");
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return feedback;
    }

    // Update feedback
    // Update feedback method
    public boolean updateFeedback(Feedback feedback) {
        String sql = "UPDATE feedback SET Rating = ?, Comment = ?, IsAnonymous = ? WHERE FeedbackID = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedback.getRating());
            stmt.setString(2, feedback.getComment());
            stmt.setBoolean(3, feedback.isAnonymous());
            stmt.setInt(4, feedback.getFeedbackID());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete feedback method
    public boolean deleteFeedback(int feedbackID) {
        String sql = "DELETE FROM feedback WHERE FeedbackID = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, feedbackID);
            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    // Get all feedback by user ID

    public List<Feedback> getFeedbackByUserId(int userID) {
        List<Feedback> feedbackList = new ArrayList<>();
        String query = "SELECT f.*, rt.Name as RoomTypeName, rt.RoomTypeImage, "
                + "u.FullName, u.Email, u.avatar_path "
                + "FROM feedback f "
                + "JOIN roomtypes rt ON f.RoomTypeID = rt.RoomTypeID "
                + "JOIN users u ON f.UserID = u.UserID "
                + "WHERE f.UserID = ? "
                + "ORDER BY f.FeedbackDate DESC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, userID);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackID(rs.getInt("FeedbackID"));
                feedback.setBookingID(rs.getInt("BookingID"));
                feedback.setUserID(rs.getInt("UserID"));
                feedback.setRoomTypeID(rs.getInt("RoomTypeID"));
                feedback.setRating(rs.getInt("Rating"));
                feedback.setComment(rs.getString("Comment"));
                feedback.setFeedbackDate(rs.getTimestamp("FeedbackDate"));
                feedback.setAnonymous(rs.getBoolean("IsAnonymous"));
                feedback.setRoomTypeName(rs.getString("RoomTypeName"));

                // Create and set room type information
                RoomType roomType = new RoomType();
                roomType.setRoomTypeID(rs.getInt("RoomTypeID"));
                roomType.setName(rs.getString("RoomTypeName"));
                roomType.setImageUrl(rs.getString("RoomTypeImage"));
                feedback.setRoomType(roomType);

                // Set user information
                feedback.setUserName(rs.getString("FullName"));
                feedback.setUserEmail(rs.getString("Email"));
                feedback.setUserAvatar(rs.getString("avatar_path"));

                feedbackList.add(feedback);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return feedbackList;
    }

 
        }

