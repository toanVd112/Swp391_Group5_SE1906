/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.*;
import java.util.*;
import model.Service;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 *
 * @author admin
 */
public class ServiceDAO {
    private Connection conn;

    public ServiceDAO() throws SQLException {
        conn = DBConnect.getConnection(); // Assumes DBConnect.getConnection() is defined elsewhere
    }

    public List<Service> getAll() throws SQLException {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM services";
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            list.add(new Service(
                rs.getInt("ServiceID"),
                rs.getString("ServiceName"),
                rs.getBigDecimal("Price"),
                rs.getString("Description"),
                rs.getString("AvailabilityStatus"),
                rs.getString("ServiceType"),
                rs.getObject("CreatedDate", LocalDateTime.class),
                rs.getObject("LastUpdatedDate", LocalDateTime.class),
                rs.getString("CreatedBy"),
                rs.getString("LastUpdatedBy"),
                rs.getString("ServiceImage")
            ));
        }
        return list;
    }

    public void insert(Service s) throws SQLException {
        String sql = "INSERT INTO services (ServiceName, Price, Description, AvailabilityStatus, ServiceType, CreatedDate, LastUpdatedDate, CreatedBy, LastUpdatedBy, ServiceImage) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, s.getServiceName());
        ps.setBigDecimal(2, s.getPrice());
        ps.setString(3, s.getDescription());
        ps.setString(4, s.getAvailabilityStatus());
        ps.setString(5, s.getServiceType());
        ps.setObject(6, s.getCreatedDate());
        ps.setObject(7, s.getLastUpdatedDate());
        ps.setString(8, s.getCreatedBy());
        ps.setString(9, s.getLastUpdatedBy());
        ps.setString(10, s.getServiceImage());
        ps.executeUpdate();
    }

    public Service getById(int id) throws SQLException {
        String sql = "SELECT * FROM services WHERE ServiceID=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new Service(
                rs.getInt("ServiceID"),
                rs.getString("ServiceName"),
                rs.getBigDecimal("Price"),
                rs.getString("Description"),
                rs.getString("AvailabilityStatus"),
                rs.getString("ServiceType"),
                rs.getObject("CreatedDate", LocalDateTime.class),
                rs.getObject("LastUpdatedDate", LocalDateTime.class),
                rs.getString("CreatedBy"),
                rs.getString("LastUpdatedBy"),
                rs.getString("ServiceImage")
            );
        }
        return null;
    }

    public void update(Service s) throws SQLException {
        String sql = "UPDATE services SET ServiceName=?, Price=?, Description=?, AvailabilityStatus=?, ServiceType=?, CreatedDate=?, LastUpdatedDate=?, CreatedBy=?, LastUpdatedBy=?, ServiceImage=? WHERE ServiceID=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, s.getServiceName());
        ps.setBigDecimal(2, s.getPrice());
        ps.setString(3, s.getDescription());
        ps.setString(4, s.getAvailabilityStatus());
        ps.setString(5, s.getServiceType());
        ps.setObject(6, s.getCreatedDate());
        ps.setObject(7, s.getLastUpdatedDate());
        ps.setString(8, s.getCreatedBy());
        ps.setString(9, s.getLastUpdatedBy());
        ps.setString(10, s.getServiceImage());
        ps.setInt(11, s.getServiceID());
        ps.executeUpdate();
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM services WHERE ServiceID=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();
    }
}