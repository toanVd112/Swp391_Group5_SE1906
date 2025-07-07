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
import java.sql.Timestamp;
import java.util.UUID;
import java.time.LocalDateTime;
import model.BookingResult;

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
            String token = UUID.randomUUID().toString();
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
                su.setPrice(rs.getInt("Price"));
                su.setQuantity(rs.getInt("Quantity"));
                list.add(su);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

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

        String sqlBooking = "SELECT BookingID, UserID, CheckInDate, BookingDate, CheckOutDate, GuestsCount, TotalAmount, Status, BookingToken, ContactName, ContactEmail, ContactPhone "
                + "FROM bookings WHERE BookingID = ? AND BookingToken = ?";

        String sqlDeleted = "SELECT OriginalBookingID AS BookingID, UserID,BookingDate, CheckInDate, BookingDate, CheckOutDate, GuestsCount, TotalAmount, Status, BookingToken, ContactName, ContactEmail, ContactPhone "
                + "FROM deleted_bookings WHERE OriginalBookingID = ? AND BookingToken = ?";

        try (Connection con = DBConnect.getConnection(); PreparedStatement ps = con.prepareStatement(sqlBooking)) {

            ps.setInt(1, bookingId);
            ps.setString(2, token);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                booking = new Booking();
                booking.setBookingID(rs.getInt("BookingID"));
                booking.setUserID(rs.getInt("UserID"));
                booking.setCheckInDate(rs.getString("CheckInDate"));
                booking.setCheckOutDate(rs.getString("CheckOutDate"));
                booking.setGuestsCount(rs.getInt("GuestsCount"));
                booking.setStatus(rs.getString("Status"));
                booking.setBookingDate(rs.getString("BookingDate"));
                booking.setTotalAmount(rs.getDouble("TotalAmount"));
                booking.setContactName(rs.getString("ContactName"));
                booking.setContactEmail(rs.getString("ContactEmail"));
                booking.setContactPhone(rs.getString("ContactPhone"));
                booking.setExpiryTime(rs.getString("ExpiryTime"));
            } else {
                // Không tìm thấy ở bookings → tìm ở deleted_bookings
                try (PreparedStatement psDeleted = con.prepareStatement(sqlDeleted)) {
                    psDeleted.setInt(1, bookingId);
                    psDeleted.setString(2, token);

                    ResultSet rsDeleted = psDeleted.executeQuery();
                    if (rsDeleted.next()) {
                        booking = new Booking();
                        booking.setBookingID(rsDeleted.getInt("BookingID"));
                        booking.setUserID(rsDeleted.getInt("UserID"));
                        booking.setBookingDate(rs.getString("BookingDate"));
                        booking.setCheckInDate(rsDeleted.getString("CheckInDate"));
                        booking.setCheckOutDate(rsDeleted.getString("CheckOutDate"));
                        booking.setGuestsCount(rsDeleted.getInt("GuestsCount"));

                        booking.setStatus("Expired"); // Bắt buộc đổi status hiển thị cho rõ ràng
                        booking.setTotalAmount(rsDeleted.getDouble("TotalAmount"));
                        booking.setContactName(rsDeleted.getString("ContactName"));
                        booking.setContactEmail(rsDeleted.getString("ContactEmail"));
                        booking.setContactPhone(rsDeleted.getString("ContactPhone"));
                        booking.setExpiryTime(rs.getString("ExpiryTime"));
                    }
                }
            }
        }

        return booking;
    }

    public List<Booking> getBookingsWithPagination(
            int userId,
            String statusFilter,
            Integer searchBookingId,
            int offset,
            int limit
    ) throws SQLException {

        List<Booking> list = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
        SELECT 
            BookingID, UserID, CheckInDate, BookingDate, CheckOutDate, ExpiryTime,GuestsCount, TotalAmount,
            CASE WHEN Status = 'Pending' AND ExpiryTime < NOW() THEN 'Expired' ELSE Status END AS Status,
            BookingToken, ContactName, ContactEmail, ContactPhone
        FROM bookings
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
        SELECT 
          OriginalBookingID AS BookingID,
          UserID,
          CheckInDate,
          BookingDate,
          CheckOutDate,
          ExpiryTime,
          GuestsCount,
          TotalAmount,
          'Expired' AS Status,
          BookingToken,
          ContactName,
          ContactEmail,
          ContactPhone
        FROM deleted_bookings
        WHERE UserID = ?
        AND (
            (? = 'Expired')
            OR (? = '')
        )
    """);

        if (searchBookingId != null) {
            sql.append(" AND OriginalBookingID = ? ");
        }

        sql.append(" ORDER BY CheckInDate DESC LIMIT ? OFFSET ? ");

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
            ps.setString(i++, statusFilter); // OR (? = '') All

            if (searchBookingId != null) {
                ps.setInt(i++, searchBookingId);
            }

            ps.setInt(i++, userId);
            ps.setString(i++, statusFilter); // Expired in deleted_bookings
            ps.setString(i++, statusFilter); // All in deleted_bookings

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

    public static void main(String[] args) {
        BookingDAO dao = new BookingDAO();
        try {
            // ✅ Test Customer: get all bookings by userID
            int testUserId = 4; // Thay ID hợp lệ trong DB của bạn
            List<Booking> userBookings = dao.getBookingsByUserId(testUserId);

            System.out.println("---- BOOKINGS FOR USER ID: " + testUserId + " ----");
            for (Booking b : userBookings) {
                System.out.println("BookingID: " + b.getBookingID()
                        + ", CheckIn: " + b.getCheckInDate()
                        + ", CheckOut: " + b.getCheckOutDate()
                        + ", Status: " + b.getStatus()
                        + ", TotalAmount: " + b.getTotalAmount());
            }

            // ✅ Test Guest: tra 1 booking by ID + Token
            int testBookingID = 85; // Thay bằng BookingID thực tế
            String testToken = "f8fa83a5-af66-4214-affb-84e42f1e41d0"; // Thay bằng BookingToken thực tế
            Booking guestBooking = dao.getBookingByIdAndToken(testBookingID, testToken);

            System.out.println("\n---- GUEST BOOKING ----");
            if (guestBooking != null) {
                System.out.println("BookingID: " + guestBooking.getBookingID()
                        + ", CheckIn: " + guestBooking.getCheckInDate()
                        + ", CheckOut: " + guestBooking.getCheckOutDate()
                        + ", Status: " + guestBooking.getStatus()
                        + ", TotalAmount: " + guestBooking.getTotalAmount());
            } else {
                System.out.println("No booking found for ID: " + testBookingID + " & Token: " + testToken);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

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
}
