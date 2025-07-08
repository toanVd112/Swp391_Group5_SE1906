package DAO;

import model.RevenueStats;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RevenueDAO {
    private static final Logger LOGGER = Logger.getLogger(RevenueDAO.class.getName());

    // Get revenue by room type with date range and grouping
    public List<RevenueStats> getRoomRevenueByType(String startDate, String endDate, String groupBy) {
        List<RevenueStats> revenueList = new ArrayList<>();
        String groupByClause = switch (groupBy) {
            case "day" -> "DATE(i.PaymentDate)";
            case "month" -> "DATE_FORMAT(i.PaymentDate, '%Y-%m')";
            case "year" -> "YEAR(i.PaymentDate)";
            default -> "rt.Name";
        };
        String sql = "SELECT " + groupByClause + " AS category, SUM(i.TotalAmount) AS totalRevenue " +
                     "FROM invoices i " +
                     "JOIN bookings b ON i.BookingID = b.BookingID " +
                     "JOIN rooms r ON b.RoomID = r.RoomID " +
                     "JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                     "WHERE i.Paid = 1 AND i.PaymentDate BETWEEN ? AND ? " +
                     "GROUP BY " + groupByClause;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    RevenueStats stats = new RevenueStats();
                    stats.setCategory(rs.getString("category"));
                    stats.setAmount(rs.getDouble("totalRevenue"));
                    revenueList.add(stats);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching room revenue: ", e);
        }
        return revenueList;
    }

    // Get revenue by service type with date range and grouping
    public List<RevenueStats> getServiceRevenueByType(String startDate, String endDate, String groupBy) {
        List<RevenueStats> revenueList = new ArrayList<>();
        String groupByClause = switch (groupBy) {
            case "day" -> "DATE(su.UsageDate)";
            case "month" -> "DATE_FORMAT(su.UsageDate, '%Y-%m')";
            case "year" -> "YEAR(su.UsageDate)";
            default -> "s.ServiceType";
        };
        String sql = "SELECT " + groupByClause + " AS category, SUM(su.Quantity * s.Price) AS totalRevenue " +
                     "FROM serviceusage su " +
                     "JOIN services s ON su.ServiceID = s.ServiceID " +
                     "WHERE su.UsageDate BETWEEN ? AND ? " +
                     "GROUP BY " + groupByClause;

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, startDate);
            ps.setString(2, endDate);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String category = rs.getString("category");
                    if (category == null) category = "Other";
                    RevenueStats stats = new RevenueStats();
                    stats.setCategory(category);
                    stats.setAmount(rs.getDouble("totalRevenue"));
                    revenueList.add(stats);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error fetching service revenue: ", e);
        }
        return revenueList;
    }
}