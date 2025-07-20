/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import model.Invoice;
import java.math.BigDecimal;
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
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.UUID;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import model.BookingResult;
import model.InvoiceData;

/**
 *
 * @author Admin
 */
public class InvoiceDAO {

    public void insertInvoice(Invoice invoice) throws SQLException {
        String sql = "INSERT INTO invoices (BookingID, IssuedBy, IssuedDate, RoomTotal, ServiceTotal, DiscountCode, DiscountPercent, TotalAmount, PaymentStatus, Note) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, invoice.getBookingId());
            ps.setInt(2, invoice.getIssuedBy());
            ps.setTimestamp(3, Timestamp.valueOf(invoice.getIssuedDate()));
            ps.setDouble(4, invoice.getRoomTotal());
            ps.setDouble(5, invoice.getServiceTotal());
            ps.setString(6, invoice.getDiscountCode());
            ps.setInt(7, invoice.getDiscountPercent());
            ps.setDouble(8, invoice.getTotalAmount());
            ps.setString(9, invoice.getPaymentStatus());
            ps.setString(10, invoice.getNote());
            ps.executeUpdate();
        }
    }

    public boolean hasInvoice(int bookingId) throws SQLException {
        String sql = "SELECT 1 FROM invoices WHERE BookingID = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    public InvoiceData getInvoiceDataByBookingId(int bookingId) throws SQLException {
        InvoiceData data = new InvoiceData();

        // 1. Lấy thông tin từ bookings
        String sqlBooking = "SELECT ContactName, DiscountCodeID FROM bookings WHERE BookingID = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sqlBooking)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                data.setBookingId(bookingId);
                data.setCustomerName(rs.getString("ContactName"));
                data.setIssuedDate(java.time.LocalDate.now());

                int discountCodeId = rs.getInt("DiscountCodeID");

                // 2. Lấy mã giảm giá (nếu có)
                if (discountCodeId != 0) {
                    String sqlDiscount = "SELECT Code, DiscountPercent FROM discountcodes WHERE DiscountCodeID = ?";
                    try (PreparedStatement ps2 = con.prepareStatement(sqlDiscount)) {
                        ps2.setInt(1, discountCodeId);
                        ResultSet rs2 = ps2.executeQuery();
                        if (rs2.next()) {
                            data.setDiscountCode(rs2.getString("Code"));
                            data.setDiscountPercent(rs2.getInt("DiscountPercent"));
                        }
                    }
                }
            }
        }

        // 3. Tính tổng tiền phòng
        String sqlRoom = "SELECT SUM(PricePerNight * DATEDIFF(CheckOutDate, CheckInDate)) AS RoomTotal FROM bookingdetails WHERE BookingID = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sqlRoom)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                data.setRoomTotal(rs.getDouble("RoomTotal"));
            }
        }

        // 4. Tính tổng tiền dịch vụ
        String sqlService = "SELECT SUM(SubTotal) AS ServiceTotal FROM serviceusage WHERE BookingID = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sqlService)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                data.setServiceTotal(rs.getDouble("ServiceTotal"));
            }
        }

        // 5. Tính tổng tiền cuối cùng
        double beforeDiscount = data.getRoomTotal() + data.getServiceTotal();
        double discount = beforeDiscount * data.getDiscountPercent() / 100.0;
        data.setTotalAmount(beforeDiscount - discount);

        return data;
    }

}
