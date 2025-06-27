package DAO;

import model.RevenueStats;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RevenueDAO {

    // Get revenue by room type from invoices
    public List<RevenueStats> getRoomRevenueByType() {
        List<RevenueStats> revenueList = new ArrayList<>();
        String sql = "SELECT rt.Name, SUM(i.TotalAmount) AS totalRevenue " +
                     "FROM invoices i " +
                     "JOIN bookings b ON i.BookingID = b.BookingID " +
                     "JOIN rooms r ON b.RoomID = r.RoomID " +
                     "JOIN roomtypes rt ON r.RoomTypeID = rt.RoomTypeID " +
                     "WHERE i.Paid = 1 " +
                     "GROUP BY rt.RoomTypeID, rt.Name";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                RevenueStats stats = new RevenueStats();
                stats.setCategory(rs.getString("Name"));
                stats.setAmount(rs.getDouble("totalRevenue"));
                revenueList.add(stats);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return revenueList;
    }

    // Get revenue by service type from serviceusage
    public List<RevenueStats> getServiceRevenueByType() {
        List<RevenueStats> revenueList = new ArrayList<>();
        String sql = "SELECT s.ServiceType, SUM(su.Quantity * s.Price) AS totalRevenue " +
                     "FROM serviceusage su " +
                     "JOIN services s ON su.ServiceID = s.ServiceID " +
                     "GROUP BY s.ServiceType";

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String serviceType = rs.getString("ServiceType");
                if (serviceType == null) serviceType = "Other"; // Handle null ServiceType
                RevenueStats stats = new RevenueStats();
                stats.setCategory(serviceType);
                stats.setAmount(rs.getDouble("totalRevenue"));
                revenueList.add(stats);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return revenueList;
    }
}