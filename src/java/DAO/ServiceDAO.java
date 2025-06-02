/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;
import java.sql.*;
import java.util.*;
import model.Service;
/**
 *
 * @author admin
 */
public class ServiceDAO {
    private Connection conn;

    public ServiceDAO() throws SQLException {
        conn = DBConnect.getConnection(); // viết riêng DBUtil.getConnection()
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
                rs.getString("Description"),
                rs.getDouble("Price"),
                rs.getBoolean("Status")
            ));
        }
        return list;
    }

    public void insert(Service s) throws SQLException {
        String sql = "INSERT INTO services (ServiceName, Description, Price, Status) VALUES (?, ?, ?, ?)";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, s.getServiceName());
        ps.setString(2, s.getDescription());
        ps.setDouble(3, s.getPrice());
        ps.setBoolean(4, s.isStatus());
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
                rs.getString("Description"),
                rs.getDouble("Price"),
                rs.getBoolean("Status")
            );
        }
        return null;
    }
//////s
    public void update(Service s) throws SQLException {
        String sql = "UPDATE services SET ServiceName=?, Description=?, Price=?, Status=? WHERE ServiceID=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, s.getServiceName());
        ps.setString(2, s.getDescription());
        ps.setDouble(3, s.getPrice());
        ps.setBoolean(4, s.isStatus());
        ps.setInt(5, s.getServiceID());
        ps.executeUpdate();
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM services WHERE ServiceID=?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, id);
        ps.executeUpdate();
    }
}

