package DAO;

import java.sql.*;
import java.util.*;
import model.RoomInspectionReport;
import java.sql.Timestamp;

public class RoomInspectionReportDAO {

    public void insert(RoomInspectionReport report) throws SQLException {
        String sql = "INSERT INTO RoomInspectionReports  (BookingID, RoomID, StaffID, Notes) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, report.getBookingID());
            stmt.setInt(2, report.getRoomID());
            stmt.setObject(3, report.getStaffID(), Types.INTEGER); // nullable

            // Kiểm tra null cho isRoomOk
            stmt.setString(4, report.getNotes());
            stmt.executeUpdate();
        }
    }

    public List<RoomInspectionReport> getAll() throws SQLException {
        List<RoomInspectionReport> list = new ArrayList<>();
        String sql = "SELECT * FROM RoomInspectionReports ";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                RoomInspectionReport report = new RoomInspectionReport();
                report.setReportID(rs.getInt("ReportID"));
                report.setBookingID(rs.getInt("BookingID"));
                report.setRoomID(rs.getInt("RoomID"));
                report.setStaffID(rs.getObject("StaffID") != null ? rs.getInt("StaffID") : null);
                report.setInspectionTime(rs.getTimestamp("InspectionTime"));

                // Xử lý nullable isRoomOk
                boolean isRoomOk = rs.getBoolean("isRoomOk");
                report.setIsRoomOk(rs.wasNull() ? null : isRoomOk);

                report.setNotes(rs.getString("Notes"));
                // Có thể thêm inspectionTime nếu muốn
                list.add(report);
            }
        }
        return list;
    }

    public void update(RoomInspectionReport report) throws SQLException {
        String sql = "UPDATE RoomInspectionReports  SET BookingID = ?, RoomID = ?, StaffID = ?, isRoomOk = ?, Notes = ? WHERE ReportID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, report.getBookingID());
            stmt.setInt(2, report.getRoomID());
            stmt.setObject(3, report.getStaffID(), java.sql.Types.INTEGER);
            if (report.getIsRoomOk() == null) {
                stmt.setNull(4, Types.BOOLEAN);
            } else {
                stmt.setBoolean(4, report.getIsRoomOk());
            }

            stmt.setString(5, report.getNotes());
            stmt.setInt(6, report.getReportID());
            stmt.executeUpdate();
        }
    }

    public RoomInspectionReport getByID(int reportID) throws SQLException {
        String sql = "SELECT * FROM RoomInspectionReports  WHERE ReportID = ?";
        try (Connection conn = DBConnect.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reportID);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    RoomInspectionReport report = new RoomInspectionReport();
                    report.setReportID(rs.getInt("ReportID"));
                    report.setBookingID(rs.getInt("BookingID"));
                    report.setRoomID(rs.getInt("RoomID"));
                    report.setStaffID(rs.getObject("StaffID") != null ? rs.getInt("StaffID") : null);
                    report.setIsRoomOk(rs.getBoolean("isRoomOk"));
                    report.setNotes(rs.getString("Notes"));
                    return report;
                }
            }
        }
        return null;
    }

    public String getUsernameByStaffID(int staffID) throws SQLException {
        String username = null;
        String sql = "SELECT Username FROM Accounts WHERE AccountID = ?";

        try (Connection conn = DBConnect.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, staffID);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    username = rs.getString("Username");
                }
            }
        }

        return username;
    }

    public static void main(String[] args) throws SQLException {
        //      try {
        //        RoomInspectionReportDAO dao = new RoomInspectionReportDAO();

//            RoomInspectionReport report = new RoomInspectionReport();
//            report.setBookingID(4);       // ⚠️ Thay bằng ID có thật trong DB
//            report.setRoomID(1);        // ⚠️ Thay bằng ID có thật trong DB
//            report.setStaffID(28);         // ⚠️ Thay bằng AccountID của Staff hợp lệ
//            report.setNotes("Kiểm tra quạt");
//            // Không set isRoomOk để test giá trị null
//
//            dao.insert(report);
//
//            System.out.println("✅ Thêm report thành công!");
//
//        } catch (Exception e) {
//            System.err.println("❌ Lỗi khi thêm report:");
//            e.printStackTrace();
//        }
        //}
            RoomInspectionReportDAO dao = new RoomInspectionReportDAO();
        System.out.println(dao.getUsernameByStaffID(40));
    }
}
