/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

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
import java.sql.Date;
/**
 *
 * @author Admin
 */
public class BookingDAO {

    public BookingResult insertBooking(Integer userID, String checkin, String checkout, int guests,
            String status, String name, String email, String phone, Double totalAmount) throws SQLException {
        String sql = "INSERT INTO bookings (UserID, CheckInDate, CheckOutDate, GuestsCount, Status, ContactName, ContactEmail, ContactPhone, TotalAmount, ExpiryTime, BookingToken) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            if (userID != null) {
                ps.setInt(1, userID);
            } else {
                ps.setNull(1, Types.INTEGER);
            }

            LocalDateTime expiry = LocalDateTime.now().plusMinutes(5);
            String token = UUID.randomUUID().toString().replace("-", "").substring(0, 12);

            ps.setString(2, checkin);
            ps.setString(3, checkout);
            ps.setInt(4, guests);
            ps.setString(5, status);
            ps.setString(6, name);
            ps.setString(7, email);
            ps.setString(8, phone);
            ps.setDouble(9, totalAmount);
            ps.setTimestamp(10, Timestamp.valueOf(expiry));
            ps.setString(11, token);
            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    int bookingID = rs.getInt(1);
                    return new BookingResult(bookingID, token);
                }
            }

        }

        return null;
    }

    public int getMaxGuestsAvailable(String checkin, String checkout) throws SQLException {
        int total = 0;
        String sql = """
      SELECT SUM(rt.MaxGuests) AS TotalMaxGuests
      FROM rooms r
      JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID
      WHERE r.Status = 'Available'
      AND NOT EXISTS (
          SELECT 1 FROM bookingdetails bd
          JOIN bookings b ON bd.BookingID = b.BookingID
          WHERE bd.RoomID = r.RoomID
            AND b.Status IN ('Pending', 'Upcoming', 'Active')
            AND b.CheckInDate < ? AND b.CheckOutDate > ?
      )
    """;

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, checkout);
            ps.setString(2, checkin);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("TotalMaxGuests");
            }
        }
        return total;
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

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingID);
            ps.setInt(2, roomID);
            ps.setInt(3, roomTypeId);
            ps.setDouble(4, pricePerNight);
            ps.setInt(5, guests);

            ps.executeUpdate();
        }
    }

    // Insert dịch vụ dùng kèm
    public void insertServiceUsage(int bookingID, int serviceID, int quantity, int unitPrice, int subTotal) throws SQLException {
        String sql = "INSERT INTO serviceUsage (BookingID, ServiceID, Quantity,UnitPrice,SubTotal) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingID);
            ps.setInt(2, serviceID);
            ps.setInt(3, quantity);
            ps.setInt(4, unitPrice);
            ps.setInt(5, subTotal);
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
                booking.setTotalAmount(rs.getDouble("TotalAmount"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return booking;
    }

//    public List<BookingDetail> getBookingDetails(int bookingID) {
//        List<BookingDetail> list = new ArrayList<>();
//        String sql = "SELECT bd.*, rt.Name AS RoomTypeName "
//                + "FROM bookingdetails bd "
//                + "JOIN roomtypes rt ON bd.RoomTypeID = rt.RoomTypeID "
//                + "WHERE bd.BookingID = ?";
//        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
//            ps.setInt(1, bookingID);
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                BookingDetail bd = new BookingDetail();
//                bd.setBookingDetailID(rs.getInt("BookingDetailID"));
//                bd.setBookingID(rs.getInt("BookingID"));
//                bd.setRoomTypeID(rs.getInt("RoomTypeID"));
//                bd.setRoomTypeName(rs.getString("RoomTypeName"));
//                bd.s(rs.getInt("Quantity"));
//                bd.setPricePerNight(rs.getDouble("PricePerNight"));
//                bd.setGuestsCount(rs.getInt("GuestsCount"));
//                list.add(bd);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
//    public List<ServiceUsage> getBookingServices(int bookingID) {
//        List<ServiceUsage> list = new ArrayList<>();
//        String sql = "SELECT su.*, s.Name AS ServiceName, s.Price "
//                + "FROM servicesusage su "
//                + "JOIN services s ON su.ServiceID = s.ServiceID "
//                + "WHERE su.BookingID = ?";
//        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
//            ps.setInt(1, bookingID);
//            ResultSet rs = ps.executeQuery();
//            while (rs.next()) {
//                ServiceUsage su = new ServiceUsage();
//                su.setBookingID(rs.getInt("BookingID"));
//                su.setServiceID(rs.getInt("ServiceID"));
//                su.setServiceName(rs.getString("ServiceName"));
//                su.setUnitPrice(rs.getInt("Price"));
//                su.setQuantity(rs.getInt("Quantity"));
//                list.add(su);
//            }
//        } catch (SQLException e) {
//            e.printStackTrace();
//        }
//        return list;
//    }
    public void archiveExpiredBookings() throws SQLException {
        String insertSQL = "INSERT INTO deleted_bookings "
                + "(OriginalBookingID, UserID, BookingDate, ExpiryTime, "
                + "CheckInDate, CheckOutDate, GuestsCount, TotalAmount, Status, "
                + "BookingToken, ContactName, ContactEmail, ContactPhone) "
                + "SELECT BookingID, UserID, BookingDate, ExpiryTime, "
                + "CheckInDate, CheckOutDate, GuestsCount, TotalAmount, Status, "
                + "BookingToken, ContactName, ContactEmail, ContactPhone "
                + "FROM bookings "
                + "WHERE Status = 'Pending' AND ExpiryTime < NOW()";

        String deleteSQL = "DELETE FROM bookings WHERE Status = 'Pending' AND ExpiryTime < NOW()";

        try (Connection con = DBConnect.getConnection()) {
            try (PreparedStatement psInsert = con.prepareStatement(insertSQL)) {
                psInsert.executeUpdate();
            }

            try (PreparedStatement psDelete = con.prepareStatement(deleteSQL)) {
                psDelete.executeUpdate();
            }
        }
    }

    public static boolean checkEmailExist(String email) {
        boolean exists = false;
        String sql = "SELECT 1 FROM users WHERE Email = ?";

        try {
            Connection con = DBConnect.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                exists = true; // Đã tồn tại
            }

            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return exists;
    }

    public List<Booking> getBookingsByUserId(int userId) throws SQLException {
        List<Booking> list = new ArrayList<>();

        String sql = """
   SELECT 
        BookingID, UserID, CheckInDate, BookingDate, CheckOutDate,ExpiryTime, GuestsCount, TotalAmount,
        CASE WHEN Status = 'Pending' AND ExpiryTime < NOW() THEN 'Expired' ELSE Status END AS Status,
        BookingToken, ContactName, ContactEmail, ContactPhone
      FROM bookings
      WHERE UserID = ?
      
      UNION ALL
      
      SELECT 
        OriginalBookingID AS BookingID, UserID, BookingDate, CheckInDate, CheckOutDate,ExpiryTime, GuestsCount, TotalAmount,
        'Expired' AS Status,
        BookingToken, ContactName, ContactEmail, ContactPhone
      FROM deleted_bookings
      WHERE UserID = ?
      
      ORDER BY CheckInDate DESC
    """;

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("BookingID"));
                b.setUserID(rs.getInt("UserID"));
                b.setBookingDate(rs.getString("BookingDate"));
                b.setCheckInDate(rs.getString("CheckInDate"));
                b.setCheckOutDate(rs.getString("CheckOutDate"));
                b.setExpiryTime(rs.getString("ExpiryTime"));
                b.setGuestsCount(rs.getInt("GuestsCount"));
                b.setStatus(rs.getString("Status"));
                b.setTotalAmount(rs.getDouble("TotalAmount"));
                b.setContactName(rs.getString("ContactName"));
                b.setContactEmail(rs.getString("ContactEmail"));
                b.setContactPhone(rs.getString("ContactPhone"));
                list.add(b);
            }
        }
        return list;
    }

    public Booking getBookingByIdAndToken(int bookingId, String token) throws SQLException {
        Booking booking = null;

        String sqlBooking = "SELECT BookingID, UserID, CheckInDate, BookingDate, ExpiryTime, "
                + "CheckOutDate, GuestsCount, TotalAmount, Status, BookingToken, "
                + "ContactName, ContactEmail, ContactPhone "
                + "FROM bookings WHERE BookingID = ? AND BookingToken = ?";

        String sqlDeleted = "SELECT OriginalBookingID AS BookingID, UserID, BookingDate, ExpiryTime, "
                + "CheckInDate, CheckOutDate, GuestsCount, TotalAmount, Status, BookingToken, "
                + "ContactName, ContactEmail, ContactPhone "
                + "FROM deleted_bookings WHERE OriginalBookingID = ? AND BookingToken = ?";

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sqlBooking)) {

            ps.setInt(1, bookingId);
            ps.setString(2, token);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    booking = new Booking();
                    booking.setBookingID(rs.getInt("BookingID"));
                    booking.setUserID(rs.getInt("UserID"));
                    booking.setCheckInDate(rs.getString("CheckInDate"));
                    booking.setBookingDate(rs.getString("BookingDate"));
                    booking.setExpiryTime(rs.getString("ExpiryTime"));
                    booking.setCheckOutDate(rs.getString("CheckOutDate"));
                    booking.setGuestsCount(rs.getInt("GuestsCount"));
                    booking.setTotalAmount(rs.getDouble("TotalAmount"));
                    booking.setStatus(rs.getString("Status"));

                    booking.setContactName(rs.getString("ContactName"));
                    booking.setContactEmail(rs.getString("ContactEmail"));
                    booking.setContactPhone(rs.getString("ContactPhone"));
                } else {
                    // Không có trong bookings → kiểm tra deleted_bookings
                    try (PreparedStatement psDeleted = con.prepareStatement(sqlDeleted)) {
                        psDeleted.setInt(1, bookingId);
                        psDeleted.setString(2, token);

                        try (ResultSet rsDeleted = psDeleted.executeQuery()) {
                            if (rsDeleted.next()) {
                                booking = new Booking();
                                booking.setBookingID(rsDeleted.getInt("BookingID"));
                                booking.setUserID(rsDeleted.getInt("UserID"));
                                booking.setBookingDate(rsDeleted.getString("BookingDate"));
                                booking.setExpiryTime(rsDeleted.getString("ExpiryTime"));
                                booking.setCheckInDate(rsDeleted.getString("CheckInDate"));
                                booking.setCheckOutDate(rsDeleted.getString("CheckOutDate"));
                                booking.setGuestsCount(rsDeleted.getInt("GuestsCount"));
                                booking.setTotalAmount(rsDeleted.getDouble("TotalAmount"));
                                booking.setStatus("Expired"); // Ghi đè rõ ràng

                                booking.setContactName(rsDeleted.getString("ContactName"));
                                booking.setContactEmail(rsDeleted.getString("ContactEmail"));
                                booking.setContactPhone(rsDeleted.getString("ContactPhone"));
                            }
                        }
                    }
                }
            }
        }

        return booking;
    }

    public List<Booking> getBookingsWithAdvancedFilters(
            int userId,
            String statusFilter,
            Integer searchBookingId,
            String bookingDateFrom,
            String bookingDateTo,
            String checkinDate,
            String checkoutDate,
            int offset,
            int limit
    ) throws SQLException {
        List<Booking> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
        SELECT 
            BookingID, UserID, CheckInDate, BookingDate, CheckOutDate, ExpiryTime, GuestsCount, TotalAmount,
            CASE 
                WHEN Status = 'Pending' AND ExpiryTime < NOW() THEN 'Expired'
                ELSE Status
            END AS Status,
            BookingToken, ContactName, ContactEmail, ContactPhone
        FROM bookings
        WHERE UserID = ?
          AND (
              (? = 'Pending' AND Status = 'Pending' AND ExpiryTime >= NOW())
              OR (? = 'Expired' AND Status = 'Pending' AND ExpiryTime < NOW())
              OR (? = 'Upcoming' AND Status = 'Upcoming' AND DATE(CheckInDate) >= CURDATE())
              OR (? = 'Active' AND Status IN ('Confirmed', 'Checked-in') AND DATE(CheckInDate) <= CURDATE() AND DATE(CheckOutDate) >= CURDATE())
              OR (? = 'Completed' AND (Status = 'Checked-out' OR (Status = 'Confirmed' AND DATE(CheckOutDate) < CURDATE())))
              OR (? = 'Cancelled' AND Status = 'Cancelled')
              OR (? = '')
          )
    """);

        // Điều kiện bổ sung
        if (bookingDateFrom != null) {
            sql.append(" AND BookingDate >= ? ");
        }
        if (bookingDateTo != null) {
            sql.append(" AND BookingDate <= ? ");
        }
        if (checkinDate != null) {
            sql.append(" AND CheckInDate >= ? ");
        }
        if (checkoutDate != null) {
            sql.append(" AND CheckOutDate <= ? ");
        }
        if (searchBookingId != null) {
            sql.append(" AND BookingID = ? ");
        }

        // deleted_bookings
        sql.append("""
        UNION ALL
        SELECT 
            OriginalBookingID AS BookingID,
            UserID, CheckInDate, BookingDate, CheckOutDate, ExpiryTime, GuestsCount, TotalAmount,
            'Expired' AS Status,
            BookingToken, ContactName, ContactEmail, ContactPhone
        FROM deleted_bookings
        WHERE UserID = ?
          AND (
              (? = 'Expired')
              OR (? = '')
          )
    """);

        if (bookingDateFrom != null) {
            sql.append(" AND BookingDate >= ? ");
        }
        if (bookingDateTo != null) {
            sql.append(" AND BookingDate <= ? ");
        }
        if (checkinDate != null) {
            sql.append(" AND CheckInDate >= ? ");
        }
        if (checkoutDate != null) {
            sql.append(" AND CheckOutDate <= ? ");
        }
        if (searchBookingId != null) {
            sql.append(" AND OriginalBookingID = ? ");
        }

        sql.append(" ORDER BY CheckInDate DESC LIMIT ? OFFSET ? ");

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {
            int i = 1;

            ps.setInt(i++, userId);
            // Đếm đúng số `?` cho statusFilter bên trên
            for (int j = 0; j < 7; j++) {
                ps.setString(i++, statusFilter);  // nếu SQL chỉ có 7 cái
            }

            if (bookingDateFrom != null) {
                ps.setString(i++, bookingDateFrom);
            }
            if (bookingDateTo != null) {
                ps.setString(i++, bookingDateTo);
            }
            if (checkinDate != null) {
                ps.setString(i++, checkinDate);
            }
            if (checkoutDate != null) {
                ps.setString(i++, checkoutDate);
            }
            if (searchBookingId != null) {
                ps.setInt(i++, searchBookingId);
            }

            ps.setInt(i++, userId);
            ps.setString(i++, statusFilter);
            ps.setString(i++, statusFilter);

            if (bookingDateFrom != null) {
                ps.setString(i++, bookingDateFrom);
            }
            if (bookingDateTo != null) {
                ps.setString(i++, bookingDateTo);
            }
            if (checkinDate != null) {
                ps.setString(i++, checkinDate);
            }
            if (checkoutDate != null) {
                ps.setString(i++, checkoutDate);
            }
            if (searchBookingId != null) {
                ps.setInt(i++, searchBookingId);
            }

            ps.setInt(i++, limit);
            ps.setInt(i++, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("BookingID"));
                b.setUserID(rs.getInt("UserID"));
                b.setBookingDate(rs.getString("BookingDate"));
                b.setCheckInDate(rs.getString("CheckInDate"));
                b.setCheckOutDate(rs.getString("CheckOutDate"));
                b.setGuestsCount(rs.getInt("GuestsCount"));
                b.setStatus(rs.getString("Status"));
                b.setTotalAmount(rs.getDouble("TotalAmount"));
                b.setContactName(rs.getString("ContactName"));
                b.setContactEmail(rs.getString("ContactEmail"));
                b.setContactPhone(rs.getString("ContactPhone"));
                b.setExpiryTime(rs.getString("ExpiryTime"));
                list.add(b);
            }
        }

        return list;
    }

    public int countBookingsByUser(
            int userId,
            String statusFilter,
            Integer searchBookingId
    ) throws SQLException {

        StringBuilder sql = new StringBuilder("""
        SELECT COUNT(*) FROM (
            SELECT BookingID FROM bookings
            WHERE UserID = ?
            AND (
                (? = 'Pending' AND Status = 'Pending' AND ExpiryTime >= NOW())
                OR (? = 'Expired' AND Status = 'Pending' AND ExpiryTime < NOW())
                OR (? = 'Upcoming' AND Status = 'Confirmed' AND CheckInDate > NOW())
                OR (? = 'Active' AND (Status = 'Confirmed' OR Status = 'Checked-in') AND CheckInDate <= NOW() AND CheckOutDate >= NOW())
                OR (? = 'Completed' AND (Status = 'Checked-out' OR (Status = 'Confirmed' AND CheckOutDate < NOW())))
                OR (? = 'Cancelled' AND Status = 'Cancelled')
                OR (? = '')
            )
    """);

        if (searchBookingId != null) {
            sql.append(" AND BookingID = ? ");
        }

        sql.append("""
        UNION ALL
        SELECT OriginalBookingID AS BookingID FROM deleted_bookings
        WHERE UserID = ?
        AND (
            (? = 'Expired')
            OR (? = '')
        )
    """);

        if (searchBookingId != null) {
            sql.append(" AND OriginalBookingID = ? ");
        }

        sql.append(") AS total");

        int count = 0;

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int i = 1;
            ps.setInt(i++, userId);

            // 🔑 BIND TẤT CẢ FILTER LUÔN LUÔN
            ps.setString(i++, statusFilter);
            ps.setString(i++, statusFilter);
            ps.setString(i++, statusFilter);
            ps.setString(i++, statusFilter);
            ps.setString(i++, statusFilter);
            ps.setString(i++, statusFilter);
            ps.setString(i++, statusFilter); // OR (? = '')

            if (searchBookingId != null) {
                ps.setInt(i++, searchBookingId);
            }

            ps.setInt(i++, userId);
            ps.setString(i++, statusFilter); // Expired in deleted_bookings
            ps.setString(i++, statusFilter); // All in deleted_bookings

            if (searchBookingId != null) {
                ps.setInt(i++, searchBookingId);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        }

        return count;
    }

    public void truncateAllBookingTables() {
        String[] sqls = {
            "SET FOREIGN_KEY_CHECKS = 0;",
            "TRUNCATE TABLE bookings;",
            "TRUNCATE TABLE bookingdetails;",
            "TRUNCATE TABLE serviceusage;",
            "TRUNCATE TABLE deleted_bookings;",
            "TRUNCATE TABLE deleted_bookingdetails;",
            "TRUNCATE TABLE deleted_serviceusage;",
            "SET FOREIGN_KEY_CHECKS = 1;"
        };

        try (Connection con = DBConnect.getConnection()) {
            for (String sql : sqls) {
                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.execute();
                }
            }
            System.out.println("✅ All booking tables truncated (MySQL)!");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) throws SQLException {
//        int bookingID = 1; // 👈 Sửa ID để test
        BookingDAO dao = new BookingDAO();
////        dao.truncateAllBookingTables();
//        BookingDAO bookingDAO = new BookingDAO();
//        ServiceDAO serviceDAO = new ServiceDAO();
//
//        System.out.println("=== Booking Details ===");
//        List<BookingDetail> bookingDetails = bookingDAO.getBookingDetailsByBookingID(bookingID);
//        for (BookingDetail bd : bookingDetails) {
//            System.out.println("BookingDetailID: " + bd.getBookingDetailID());
//            System.out.println("RoomID: " + bd.getRoomID());
//            System.out.println("RoomTypeName: " + bd.getRoomTypeName());
//            System.out.println("PricePerNight: " + bd.getPricePerNight());
//            System.out.println("GuestsCount: " + bd.getGuestsCount());
//            System.out.println("Notes: " + bd.getNotes());
//            System.out.println("----------------------");
//        }
//
//        System.out.println("\n=== Service Usage ===");
//        List<ServiceUsage> services = serviceDAO.getServiceUsageByBookingID(bookingID);
//        for (ServiceUsage su : services) {
//            System.out.println("ServiceUsageID: " + su.getServiceUsageID());
//            System.out.println("ServiceName: " + su.getServiceName());
//            System.out.println("Quantity: " + su.getQuantity());
//            System.out.println("Unit: " + su.getUnit());
//            System.out.println("UnitPrice: " + su.getUnitPrice());
//            System.out.println("SubTotal: " + su.getSubTotal());
//            System.out.println("Notes: " + su.getNotes());
//            System.out.println("----------------------");
        // Gán ngày checkin/checkout test

    }

    public int getServicePriceByID(int serviceID) throws SQLException {
        int price = 0;
        String sql = "SELECT Price FROM services WHERE ServiceID = ?";
        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, serviceID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                price = rs.getInt("Price");
            }
        }
        return price;
    }

    public List<BookingDetail> getBookingDetailsByBookingID(int bookingID) {
        List<BookingDetail> list = new ArrayList<>();

        String sql;
        if (isBookingActive(bookingID)) {
            sql = "SELECT bd.*, rt.Name AS RoomTypeName, b.CheckInDate, b.CheckOutDate "
                    + "FROM bookingdetails bd "
                    + "JOIN roomtypes rt ON bd.RoomTypeID = rt.RoomTypeID "
                    + "JOIN bookings b ON bd.BookingID = b.BookingID "
                    + "WHERE bd.BookingID = ?";
        } else {
            sql = "SELECT bd.*, rt.Name AS RoomTypeName, b.CheckInDate, b.CheckOutDate "
                    + "FROM deleted_bookingdetails bd "
                    + "JOIN roomtypes rt ON bd.RoomTypeID = rt.RoomTypeID "
                    + "JOIN deleted_bookings b ON bd.BookingID = b.OriginalBookingID "
                    + "WHERE bd.BookingID = ?";
        }

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingID);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                BookingDetail bd = new BookingDetail();
                bd.setBookingDetailID(rs.getInt("BookingDetailID"));
                bd.setBookingID(rs.getInt("BookingID"));
                bd.setRoomID(rs.getInt("RoomID"));
                bd.setRoomTypeID(rs.getInt("RoomTypeID"));
                bd.setRoomTypeName(rs.getString("RoomTypeName"));
                bd.setPricePerNight(BigDecimal.valueOf(rs.getInt("PricePerNight")));
                bd.setGuestsCount(rs.getInt("GuestsCount"));
                bd.setNotes(rs.getString("Notes"));

                LocalDate checkIn = rs.getDate("CheckInDate").toLocalDate();
                LocalDate checkOut = rs.getDate("CheckOutDate").toLocalDate();
                long nights = ChronoUnit.DAYS.between(checkIn, checkOut);
                if (nights <= 0) {
                    nights = 1;
                }

                bd.setNights(nights);
                bd.setSubTotal(bd.getPricePerNight().multiply(BigDecimal.valueOf(nights)));

                list.add(bd);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private boolean isBookingActive(int bookingID) {
        String sql = "SELECT 1 FROM bookings WHERE BookingID = ?";
        try {
            Connection con = DBConnect.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, bookingID);
            ResultSet rs = ps.executeQuery();
            boolean exists = rs.next();
            rs.close();
            ps.close();
            con.close();
            return exists;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean cancelBookingByID(int bookingID) throws SQLException {
        String sql = "UPDATE bookings SET Status = 'Cancelled' WHERE BookingID = ? AND Status = 'Pending'";

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    public boolean updateBookingStatus(int bookingID, String status) {
        String sql = "UPDATE bookings SET Status = ? WHERE BookingID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, bookingID);
            int rowsUpdated = ps.executeUpdate();

            return rowsUpdated > 0; // ✅ true nếu có bản ghi bị cập nhật
        } catch (Exception e) {
            e.printStackTrace();
            return false; // ❌ lỗi thì trả về false
        }
    }

    public List<Integer> getRoomIDsByBookingID(int bookingID) {
        List<Integer> list = new ArrayList<>();
        String sql = "SELECT RoomID FROM bookingdetails WHERE BookingID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(rs.getInt("RoomID"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public void clearExpiryTime(int bookingID) {
        String sql = "UPDATE bookings SET ExpiryTime = NULL WHERE BookingID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void applyDiscountToBooking(int bookingID, int discountCodeID, double discountAmount) {
        String sql = "UPDATE bookings SET DiscountCodeID = ?, TotalAmount = ? WHERE BookingID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, discountCodeID);
            ps.setDouble(2, discountAmount);
            ps.setInt(3, bookingID);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
// Lấy danh sách booking COMPLETED chưa lập hóa đơn

    public List<Booking> getCompletedBookingsWithoutInvoice() throws SQLException {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM bookings WHERE Status = 'COMPLETED' AND BookingID NOT IN (SELECT BookingID FROM invoices)";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingID(rs.getInt("BookingID"));
                b.setContactName(rs.getString("ContactName"));

                // Convert java.sql.Date to String
                Date checkOutDate = rs.getDate("CheckOutDate");
                if (checkOutDate != null) {
                    String formattedDate = new java.text.SimpleDateFormat("dd/MM/yyyy").format(checkOutDate);
                    b.setCheckOutDate(formattedDate);
                }

                list.add(b);
            }
        }
        return list;
    }

}
