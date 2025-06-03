/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Service;

/**
 *
 * @author admin
 */
public class ServiceDAO {

    public Service getServiceByID(int id) {
        Service s = null;
        String sql = "SELECT * FROM services WHERE ServiceID = ?";
        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                s = new Service();
                s.setId(rs.getInt("ServiceID"));
                s.setName(rs.getString("ServiceName"));
                s.setPrice(rs.getInt("Price"));
                s.setDescription(rs.getString("Description"));
                s.setStatus(rs.getString("AvailabilityStatus"));
                s.setType(rs.getString("ServiceType"));
                s.setCreateDate(rs.getObject("CreatedDate", LocalDateTime.class));
                s.setLastUpdateDate(rs.getObject("LastUpdatedDate", LocalDateTime.class));
                s.setCreatedBy(rs.getString("CreatedBy"));
                s.setLastUpdateBy(rs.getString("LastUpdatedBy"));
                s.setServiceImage(rs.getString("ServiceImage"));
            }
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return s;
    }

    public List<String> getAllDistinctServiceType() {
        List<String> serviceTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT ServiceType FROM services WHERE ServiceType IS NOT NULL ORDER BY ServiceType ASC";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String type = rs.getString("ServiceType");
                serviceTypes.add(type);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy danh sách loại dịch vụ: " + e.getMessage());
        }

        return serviceTypes;
    }

    public List<Service> getAll() {
        List<Service> services = null;
        String sql = "SELECT * FROM services";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            services = new ArrayList<>(); // Initialize the list here
            while (rs.next()) {
                Service s = new Service();
                s.setId(rs.getInt("ServiceID"));
                s.setName(rs.getString("ServiceName"));
                s.setPrice(rs.getInt("Price"));
                s.setDescription(rs.getString("Description"));
                s.setStatus(rs.getString("AvailabilityStatus"));
                s.setType(rs.getString("ServiceType"));
                s.setCreateDate(rs.getObject("CreatedDate", LocalDateTime.class));
                s.setLastUpdateDate(rs.getObject("LastUpdatedDate", LocalDateTime.class));
                s.setCreatedBy(rs.getString("CreatedBy"));
                s.setLastUpdateBy(rs.getString("LastUpdatedBy"));
                s.setServiceImage(rs.getString("ServiceImage"));
                services.add(s);
            }

            // Close resources
            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return services != null ? services : new ArrayList<>(); // Return empty list if null
    }
        public boolean addService(Service s) {
        String sql = "INSERT INTO services (ServiceName, Price, Description, AvailabilityStatus, ServiceType, CreatedDate, LastUpdatedDate, CreatedBy, LastUpdatedBy, ServiceImage) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection(); // Đảm bảo DBConnect.getConnection() hoạt động đúng
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getName());
            ps.setInt(2, s.getPrice()); // Giả định Price là int theo model và DAO hiện tại
            ps.setString(3, s.getDescription());
            ps.setString(4, s.getStatus());
            ps.setString(5, s.getType());
            ps.setObject(6, s.getCreateDate()); // LocalDateTime
            ps.setObject(7, s.getLastUpdateDate()); // LocalDateTime
            ps.setString(8, s.getCreatedBy());
            ps.setString(9, s.getLastUpdateBy());
            ps.setString(10, s.getServiceImage());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (Exception e) {
            System.err.println("Lỗi khi thêm dịch vụ: " + e.getMessage());
            e.printStackTrace(); // Log lỗi để dễ dàng debug
            return false;
        }
    }
    public boolean update(Service s) {
        String sql = "UPDATE services "
                + "SET "
                + "ServiceName = ?, "
                + "Price = ?, "
                + "Description = ?, "
                + "AvailabilityStatus = ?, "        // Giá trị này nên là "1" hoặc "0"
                + "ServiceType = ?, "
                + "LastUpdatedDate = ?, "           // Nên truyền vào từ Java
                + "LastUpdatedBy = ?, "
                + "ServiceImage = ? "
                + "WHERE ServiceID = ?;";
        boolean rowUpdated = false;
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, s.getName());
            ps.setInt(2, s.getPrice());
            ps.setString(3, s.getDescription());
            ps.setString(4, s.getStatus()); // Ví dụ: "1" cho Hoạt động, "0" cho Ngừng
            ps.setString(5, s.getType());
            ps.setObject(6, s.getLastUpdateDate()); // LocalDateTime.now() sẽ được set trong servlet
            ps.setString(7, s.getLastUpdateBy());
            ps.setString(8, s.getServiceImage());
            ps.setInt(9, s.getId());

            rowUpdated = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace(); // Quan trọng: log lỗi để debug
        }
        return rowUpdated;
    }

    public static void main(String[] args) {
        ServiceDAO dao = new ServiceDAO();
        System.out.println(dao.toggleServiceStatus(1));
    }

    public boolean toggleServiceStatus(int id) {
        boolean success = false;
        String sql = "UPDATE services SET AvailabilityStatus = CASE " +
                     "WHEN AvailabilityStatus = '1' THEN '0' " +
                     "ELSE '1' END " +
                     "WHERE ServiceID = ?";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            int affectedLine = ps.executeUpdate();
            if (affectedLine > 0) {
                success = true;
            }
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return success;
    }

}
