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
        return null;
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

    public boolean update(Service s) {
        String sql = "UPDATE services "
                + "SET "
                + "`ServiceName` = ?, "
                + "`Price` = ?, "
                + "`Description` = ?, "
                + "`AvailabilityStatus` = ?, "
                + "`ServiceType` = ?, "
                + "`LastUpdatedDate` = CURRENT_TIMESTAMP, "
                + "`LastUpdatedBy` = ?, "
                + "`ServiceImage` = ? "
                + "WHERE ServiceID = ?;";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return true;
    }
    
    public static void main(String[] args) {
        ServiceDAO dao = new ServiceDAO();
        System.out.println(dao.getAll());
    }

}
