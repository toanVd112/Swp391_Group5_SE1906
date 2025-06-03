/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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

    public List<Service> getAll() throws SQLException {
        List<Service> services = null;
        String sql = "";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }

        return services;
    }
    
    public boolean update(Service s) {
        String sql = "";

        try {
            Connection conn = DBConnect.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return true;
    }

}
