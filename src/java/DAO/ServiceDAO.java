// Giả sử ServiceDAO.java cũng nằm trong package DAO hoặc bạn đã import DAO.DBConnect;
// package DAO; // Hoặc package com.example.dao; và có import DAO.DBConnect;

import DAO.DBConnect;
import model.Service; // Hoặc import model.Service; nếu package là DAO
// import DAO.DBConnect; // Nếu ServiceDAO ở package khác và DBConnect ở package DAO

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

public class ServiceDAO {

    // Không cần các biến jdbcURL, jdbcUsername, jdbcPassword ở đây nữa

    private static final String SELECT_ALL_SERVICES_PAGED_SQL = "SELECT SQL_CALC_FOUND_ROWS * FROM services WHERE 1=1 ";
    private static final String SELECT_FOUND_ROWS_SQL = "SELECT FOUND_ROWS()";
    private static final String SELECT_DISTINCT_SERVICE_TYPES_SQL = "SELECT DISTINCT ServiceType FROM services WHERE ServiceType IS NOT NULL ORDER BY ServiceType";
    private static final String SELECT_DISTINCT_STATUSES_SQL = "SELECT DISTINCT AvailabilityStatus FROM services WHERE AvailabilityStatus IS NOT NULL ORDER BY AvailabilityStatus";

    // Các phương thức CRUD khác sẽ sử dụng DBConnect.getConnection() tương tự

    public List<String> getDistinctServiceTypes() throws SQLException {
        List<String> serviceTypes = new ArrayList<>();
        // Sử dụng try-with-resources cho Connection, PreparedStatement, ResultSet
        try (Connection connection = DBConnect.getConnection(); // <-- THAY ĐỔI Ở ĐÂY
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_DISTINCT_SERVICE_TYPES_SQL);
             ResultSet rs = preparedStatement.executeQuery()) {
            while (rs.next()) {
                serviceTypes.add(rs.getString("ServiceType"));
            }
        } // Connection, PreparedStatement, ResultSet sẽ tự động đóng
        return serviceTypes;
    }

    public List<String> getDistinctStatuses() throws SQLException {
        List<String> statuses = new ArrayList<>();
        try (Connection connection = DBConnect.getConnection(); // <-- THAY ĐỔI Ở ĐÂY
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_DISTINCT_STATUSES_SQL);
             ResultSet rs = preparedStatement.executeQuery()) {
            while (rs.next()) {
                statuses.add(rs.getString("AvailabilityStatus"));
            }
        }
        return statuses;
    }

    public List<Service> getServices(String searchTerm, String filterServiceType, String filterStatus, int page, int recordsPerPage, int[] totalRecords) throws SQLException {
        List<Service> services = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder(SELECT_ALL_SERVICES_PAGED_SQL);
        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sqlBuilder.append("AND ServiceName LIKE ? ");
            params.add("%" + searchTerm.trim() + "%");
        }
        if (filterServiceType != null && !filterServiceType.isEmpty()) {
            sqlBuilder.append("AND ServiceType = ? ");
            params.add(filterServiceType);
        }
        if (filterStatus != null && !filterStatus.isEmpty()) {
            sqlBuilder.append("AND AvailabilityStatus = ? ");
            params.add(filterStatus);
        }
        sqlBuilder.append("ORDER BY ServiceID ASC LIMIT ? OFFSET ?");
        int offset = (page - 1) * recordsPerPage;
        params.add(recordsPerPage);
        params.add(offset);

        // Sử dụng try-with-resources cho Connection và PreparedStatement
        // ResultSet cho truy vấn chính sẽ được đóng trong try-with-resources bên trong nếu cần,
        // nhưng ở đây chúng ta xử lý nó trong cùng một khối try.
        try (Connection connection = DBConnect.getConnection(); // <-- THAY ĐỔI Ở ĐÂY
             PreparedStatement preparedStatement = connection.prepareStatement(sqlBuilder.toString())) {

            int paramIndex = 1;
            for (Object param : params) {
                preparedStatement.setObject(paramIndex++, param);
            }
            System.out.println("Executing SQL: " + preparedStatement.toString()); // Để debug

            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    services.add(mapRowToService(rs));
                }
            } // ResultSet rs tự động đóng

            // Lấy tổng số bản ghi (quan trọng cho phân trang)
            try (PreparedStatement countStatement = connection.prepareStatement(SELECT_FOUND_ROWS_SQL);
                 ResultSet countRs = countStatement.executeQuery()) {
                if (countRs.next()) {
                    totalRecords[0] = countRs.getInt(1);
                }
            } // countStatement và countRs tự động đóng

        } catch (SQLException e) {
            System.err.println("SQL Exception in getServices: " + e.getMessage());
            e.printStackTrace(); // In chi tiết lỗi ra console của server
            throw e; // Ném lại exception để tầng trên xử lý nếu cần
        }
        System.out.println("DAO: Fetched " + services.size() + " services. Total records: " + totalRecords[0]); // Để debug
        return services;
    }

    private Service mapRowToService(ResultSet rs) throws SQLException {
        int serviceID = rs.getInt("ServiceID");
        String serviceName = rs.getString("ServiceName");
        BigDecimal price = rs.getBigDecimal("Price");
        String description = rs.getString("Description");
        String availabilityStatus = rs.getString("AvailabilityStatus");
        String serviceType = rs.getString("ServiceType");
        Timestamp createdDate = rs.getTimestamp("CreatedDate");
        Timestamp lastUpdatedDate = rs.getTimestamp("LastUpdatedDate");
        String createdBy = rs.getString("CreatedBy");
        String lastUpdatedBy = rs.getString("LastUpdatedBy");
        String serviceImage = rs.getString("ServiceImage");

        return new Service(serviceID, serviceName, price, description, availabilityStatus, serviceType, createdDate, lastUpdatedDate, createdBy, lastUpdatedBy, serviceImage);
    }

    // Triển khai các phương thức CRUD khác (addService, updateService, deleteService, getServiceById)
    // cũng sẽ sử dụng DBConnect.getConnection() tương tự.
    // Ví dụ:
    /*
    public void addService(Service service) throws SQLException {
        String sql = "INSERT INTO services (ServiceName, Price, Description, AvailabilityStatus, ServiceType, CreatedBy, ServiceImage) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection connection = DBConnect.getConnection(); // <-- SỬ DỤNG DBConnect
             PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, service.getServiceName());
            ps.setBigDecimal(2, service.getPrice());
            ps.setString(3, service.getDescription());
            ps.setString(4, service.getAvailabilityStatus());
            ps.setString(5, service.getServiceType());
            ps.setString(6, service.getCreatedBy()); // Giả sử có người tạo
            ps.setString(7, service.getServiceImage());
            ps.executeUpdate();
        }
    }
    */
}