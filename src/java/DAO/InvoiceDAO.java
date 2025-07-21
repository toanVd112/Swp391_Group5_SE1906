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
import java.time.LocalDate;
import java.sql.Date;

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
        String sqlRoom = "SELECT SUM(bd.PricePerNight * DATEDIFF(bk.CheckOutDate, bk.CheckInDate)) AS RoomTotal\n"
                + "FROM bookingdetails bd\n"
                + "JOIN bookings bk ON bd.BookingID = bk.BookingID\n"
                + "WHERE bd.BookingID = ?";
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

    public List<InvoiceData> getLastInvoices(int limit) throws SQLException {
        List<InvoiceData> list = new ArrayList<>();
        String sql = "SELECT i.BookingID, b.ContactName AS CustomerName, i.IssuedDate, i.TotalAmount "
                + "FROM invoices i "
                + "JOIN bookings b ON i.BookingID = b.BookingID "
              
                + "ORDER BY i.IssuedDate DESC "
                + "LIMIT ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                InvoiceData inv = new InvoiceData();
                inv.setBookingId(rs.getInt("BookingID"));
                inv.setCustomerName(rs.getString("CustomerName"));
                Timestamp ts = rs.getTimestamp("IssuedDate");
                inv.setIssuedDate(ts.toLocalDateTime().toLocalDate());

                inv.setTotalAmount(rs.getDouble("TotalAmount"));
                list.add(inv);
            }
        }

        return list;
    }

    public static void main(String[] args) {
        try {
        InvoiceDAO dao = new InvoiceDAO();
        LocalDateTime now = LocalDateTime.now();

        for (int i = 0; i < 10; i++) {
            Invoice invoice = new Invoice();
            invoice.setBookingId(141 + i); // Tăng bookingId mỗi dòng
            invoice.setRoomTotal(100.0 + i * 10); // Tăng tiền để dễ phân biệt
            invoice.setServiceTotal(20.0); // giữ nguyên
            invoice.setDiscountCode(null);
            invoice.setDiscountPercent(0);
            invoice.setTotalAmount(invoice.getRoomTotal() + invoice.getServiceTotal());
            invoice.setPaymentStatus("PAID");
            invoice.setNote("Test insert #" + (i + 1));
            invoice.setIssuedDate(now.minusDays(i)); // Mỗi dòng lùi ngày một chút
            invoice.setIssuedBy(49);

            dao.insertInvoice(invoice);
            System.out.println("✅ Inserted invoice for BookingID: " + invoice.getBookingId());
        }

    } catch (Exception e) {
        System.out.println("❌ Error inserting invoices:");
        e.printStackTrace();
    }
        
    }
}
