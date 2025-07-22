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

    public static void main(String[] args) throws SQLException {
        InvoiceDAO dao = new InvoiceDAO();
//        try {
//            InvoiceDAO dao = new InvoiceDAO();
//            LocalDateTime now = LocalDateTime.now();
//
//            for (int i = 0; i < 10; i++) {
//                Invoice invoice = new Invoice();
//                invoice.setBookingId(170 + i); // Tăng bookingId mỗi dòng
//                invoice.setRoomTotal(100.0 + i * 10); // Tăng tiền để dễ phân biệt
//                invoice.setServiceTotal(20.0); // giữ nguyên
//                invoice.setDiscountCode(null);
//                invoice.setDiscountPercent(0);
//                invoice.setTotalAmount(invoice.getRoomTotal() + invoice.getServiceTotal());
//                invoice.setPaymentStatus("PAID");
//                invoice.setNote("Test insert #" + (i + 1));
//                invoice.setIssuedDate(now.minusDays(i)); // Mỗi dòng lùi ngày một chút
//                invoice.setIssuedBy(49);
//
//                dao.insertInvoice(invoice);
//                System.out.println("✅ Inserted invoice for BookingID: " + invoice.getBookingId());
//            }
//
//        } catch (Exception e) {
//            System.out.println("❌ Error inserting invoices:");
//            e.printStackTrace();
//        }
//        String customerName = ""; // có thể null
//        Date fromDate = Date.valueOf(LocalDate.of(2024, 1, 1));
//        Date toDate = Date.valueOf(LocalDate.of(2025, 12, 31));
//        String status = "Paid"; // hoặc null
//
//        List<Invoice> result = dao.filterInvoices(customerName, fromDate, toDate, status);
//
//        for (Invoice inv : result) {
//            System.out.println("Invoice ID: " + inv.getInvoiceId());
//            System.out.println("Booking ID: " + inv.getBookingId());
//            System.out.println("Issued Date: " + inv.getIssuedDate());
//            System.out.println("Room Total: " + inv.getRoomTotal());
//            System.out.println("Service Total: " + inv.getServiceTotal());
//            System.out.println("Discount Code: " + inv.getDiscountCode());
//            System.out.println("Discount %: " + inv.getDiscountPercent());
//            System.out.println("Total Amount: " + inv.getTotalAmount());
//            System.out.println("Payment Status: " + inv.getPaymentStatus());
//            System.out.println("Note: " + inv.getNote());
//            System.out.println("-----------------------------");
//        }
//
//        if (result.isEmpty()) {
//            System.out.println("Không tìm thấy hóa đơn nào phù hợp.");
//        }
Invoice inv = dao.getInvoiceById(23); // thay bằng ID thật

    if (inv != null) {
        System.out.println("InvoiceID: " + inv.getInvoiceId());
        System.out.println("BookingID: " + inv.getBookingId());
        System.out.println("CustomerName: " + inv.getCustomerName());
    } else {
        System.out.println("Invoice NOT FOUND");
    }

    }

    public List<Invoice> filterInvoices(String customerName, Date fromDate, Date toDate, String paymentStatus) throws SQLException {
        List<Invoice> list = new ArrayList<>();
        Connection conn = DBConnect.getConnection();
        StringBuilder sql = new StringBuilder(
                "SELECT i.*, b.ContactName "
                + "FROM invoices i "
                + "JOIN bookings b ON i.BookingID = b.BookingID "
                + "WHERE 1 = 1"
        );

        List<Object> params = new ArrayList<>();

        if (customerName != null && !customerName.trim().isEmpty()) {
            sql.append(" AND b.ContactName LIKE ?");
            params.add("%" + customerName + "%");
        }
        if (fromDate != null) {
            sql.append(" AND i.IssuedDate >= ?");
            params.add(fromDate);
        }
        if (toDate != null) {
            sql.append(" AND i.IssuedDate <= ?");
            params.add(toDate);
        }
        if (paymentStatus != null && !paymentStatus.trim().isEmpty()) {
            sql.append(" AND i.PaymentStatus = ?");
            params.add(paymentStatus);
        }

        sql.append(" ORDER BY i.IssuedDate DESC");

        try (PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Invoice inv = mapInvoice(rs);
                inv.setCustomerName(rs.getString("ContactName")); // Tạm dùng trường `note` để gắn tên khách nếu không muốn đổi model
                list.add(inv);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    private Invoice mapInvoice(ResultSet rs) throws SQLException {
        Invoice inv = new Invoice();

        inv.setInvoiceId(rs.getInt("InvoiceID"));
        inv.setBookingId(rs.getInt("BookingID"));
        inv.setIssuedBy(rs.getInt("IssuedBy"));
        inv.setIssuedDate(rs.getTimestamp("IssuedDate").toLocalDateTime());
        inv.setRoomTotal(rs.getDouble("RoomTotal"));
        inv.setServiceTotal(rs.getDouble("ServiceTotal"));
        inv.setDiscountCode(rs.getString("DiscountCode"));
        inv.setDiscountPercent(rs.getInt("DiscountPercent"));
        inv.setTotalAmount(rs.getDouble("TotalAmount"));
        inv.setPaymentStatus(rs.getString("PaymentStatus"));
        inv.setNote(rs.getString("Note"));

        return inv;
    }

    public Invoice getInvoiceById(int invoiceId) {
        String sql = "SELECT i.*, b.ContactName "
                + "FROM invoices i "
                + "JOIN bookings b ON i.BookingID = b.BookingID "
             
                + "WHERE i.InvoiceID = ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Invoice inv = new Invoice();
                inv.setInvoiceId(rs.getInt("InvoiceID"));
                inv.setBookingId(rs.getInt("BookingID"));
                inv.setIssuedBy(rs.getInt("IssuedBy"));
                inv.setIssuedDate(rs.getTimestamp("IssuedDate").toLocalDateTime());
                inv.setRoomTotal(rs.getDouble("RoomTotal"));
                inv.setServiceTotal(rs.getDouble("ServiceTotal"));
                inv.setDiscountCode(rs.getString("DiscountCode"));
                inv.setDiscountPercent(rs.getInt("DiscountPercent"));
                inv.setTotalAmount(rs.getDouble("TotalAmount"));
                inv.setPaymentStatus(rs.getString("PaymentStatus"));
                inv.setNote(rs.getString("Note"));

                // Set tên khách hàng
                inv.setCustomerName(rs.getString("ContactName"));

                return inv;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

}
