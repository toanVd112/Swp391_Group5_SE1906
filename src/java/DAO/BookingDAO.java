/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.util.*;
import java.sql.*;
import model.Booking;
import model.BookingDetail;
import model.CartRoom;
import model.MaintenanceRequest;
import model.Room;
import model.RoomInspectionReport;
import model.RoomType;
import model.ServiceUsage;

/**
 *
 * @author Admin
 */
public class BookingDAO {

    public int insertBooking(Integer userID, String checkin, String checkout, int guests,
            String status, String name, String email, String phone, Double totalAmount) throws SQLException {
        String sql = "INSERT INTO bookings (UserID, CheckInDate, CheckOutDate, GuestsCount, Status, ContactName, ContactEmail, ContactPhone,TotalAmount) VALUES (?, ?, ?, ?, ?, ?, ?, ?,?)";

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (userID != null) {
                ps.setInt(1, userID);
            } else {
                ps.setNull(1, Types.INTEGER);
            }
            ps.setString(2, checkin);
            ps.setString(3, checkout);
            ps.setInt(4, guests);
            ps.setString(5, status);
            ps.setString(6, name);
            ps.setString(7, email);
            ps.setString(8, phone);
            ps.setDouble(9, totalAmount);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }

        return -1;
    }

    public List<Integer> getAvailableRoomIDs(int roomTypeId, String checkin, String checkout, int limit) throws SQLException {
        List<Integer> roomIDs = new ArrayList<>();
        String sql = """
        SELECT r.RoomID
        FROM rooms r
        WHERE r.RoomTypeID = ?
          AND r.Status = 'Available'
          AND NOT EXISTS (
              SELECT 1
              FROM bookingdetails bd
              JOIN bookings b ON bd.BookingID = b.BookingID
              WHERE bd.RoomID = r.RoomID
                AND b.Status != 'Cancelled'
                AND b.CheckInDate < ? AND b.CheckOutDate > ?
          )
        LIMIT ?
    """;

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, roomTypeId);
            ps.setString(2, checkout); // note: logic: b.CheckIn < checkout AND b.CheckOut > checkin
            ps.setString(3, checkin);
            ps.setInt(4, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roomIDs.add(rs.getInt("RoomID"));
                }
            }
        }

        return roomIDs;
    }

    // Insert chi tiết phòng ➜ 1 dòng 1 loại phòng
   public void insertBookingDetail(int bookingID, int roomID, int roomTypeId,
                                double pricePerNight, int guests) throws SQLException {
    String sql = "INSERT INTO bookingdetails (BookingID, RoomID, RoomTypeID, PricePerNight, GuestsCount) VALUES (?, ?, ?, ?, ?)";

    try (Connection con = DBConnect.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, bookingID);
        ps.setInt(2, roomID);
        ps.setInt(3, roomTypeId);
        ps.setDouble(4, pricePerNight);
        ps.setInt(5, guests);

        ps.executeUpdate();
    }
}

    // Insert dịch vụ dùng kèm
    public void insertServiceUsage(int bookingID, int serviceID, int quantity) throws SQLException {
        String sql = "INSERT INTO ServiceUsage (BookingID, ServiceID, Quantity) VALUES (?, ?, ?)";

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingID);
            ps.setInt(2, serviceID);
            ps.setInt(3, quantity);

            ps.executeUpdate();
        }
    }

    public Booking getBookingByID(int bookingID) {
        Booking booking = null;
        String sql = "SELECT * FROM bookings WHERE BookingID = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setUserID(rs.getInt("UserID"));
                booking.setCheckInDate(rs.getString("CheckInDate"));
                booking.setCheckOutDate(rs.getString("CheckOutDate"));
                booking.setGuestsCount(rs.getInt("GuestsCount"));
                booking.setStatus(rs.getString("Status"));
                booking.setContactName(rs.getString("ContactName"));
                booking.setContactEmail(rs.getString("ContactEmail"));
                booking.setContactPhone(rs.getString("ContactPhone"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return booking;
    }

    public List<BookingDetail> getBookingDetails(int bookingID) {
        List<BookingDetail> list = new ArrayList<>();
        String sql = "SELECT bd.*, rt.Name AS RoomTypeName "
                + "FROM bookingdetails bd "
                + "JOIN roomtypes rt ON bd.RoomTypeID = rt.RoomTypeID "
                + "WHERE bd.BookingID = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookingDetail bd = new BookingDetail();
                bd.setBookingDetailID(rs.getInt("BookingDetailID"));
                bd.setBookingID(rs.getInt("BookingID"));
                bd.setRoomTypeID(rs.getInt("RoomTypeID"));
                bd.setRoomTypeName(rs.getString("RoomTypeName"));
                bd.setQuantity(rs.getInt("Quantity"));
                bd.setPricePerNight(rs.getDouble("PricePerNight"));
                bd.setGuestsCount(rs.getInt("GuestsCount"));
                list.add(bd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ServiceUsage> getBookingServices(int bookingID) {
        List<ServiceUsage> list = new ArrayList<>();
        String sql = "SELECT su.*, s.Name AS ServiceName, s.Price "
                + "FROM servicesusage su "
                + "JOIN services s ON su.ServiceID = s.ServiceID "
                + "WHERE su.BookingID = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ServiceUsage su = new ServiceUsage();
                su.setBookingID(rs.getInt("BookingID"));
                su.setServiceID(rs.getInt("ServiceID"));
                su.setServiceName(rs.getString("ServiceName"));
                su.setPrice(rs.getDouble("Price"));
                su.setQuantity(rs.getInt("Quantity"));
                list.add(su);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public static void main(String[] args) {
        BookingDAO b = new BookingDAO();

    }

    public List<Booking> getAllBookings() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
