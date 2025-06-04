package DAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import model.Service; // Đảm bảo import đúng model Service của bạn

public class ServiceDAO {

    // Giữ nguyên các phương thức khác của bạn như getServiceByID, addService, update, etc.
    // ... (các phương thức hiện có của bạn) ...

    public Service getServiceByID(int id) {
        Service s = null;
        String sql = "SELECT * FROM services WHERE ServiceID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    s = new Service();
                    s.setId(rs.getInt("ServiceID"));
                    s.setName(rs.getString("ServiceName"));
                    s.setPrice(rs.getInt("Price"));
                    s.setDescription(rs.getString("Description"));
                    s.setStatus(rs.getString("AvailabilityStatus")); // "1" or "0"
                    s.setType(rs.getString("ServiceType"));
                    s.setCreateDate(rs.getObject("CreatedDate", LocalDateTime.class));
                    s.setLastUpdateDate(rs.getObject("LastUpdatedDate", LocalDateTime.class));
                    s.setCreatedBy(rs.getString("CreatedBy"));
                    s.setLastUpdateBy(rs.getString("LastUpdatedBy"));
                    s.setServiceImage(rs.getString("ServiceImage"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace(); // Nên ghi log lỗi này
        }
        return s;
    }

    public List<String> getAllDistinctServiceType() {
        List<String> serviceTypes = new ArrayList<>();
        String sql = "SELECT DISTINCT ServiceType FROM services WHERE ServiceType IS NOT NULL AND ServiceType <> '' ORDER BY ServiceType ASC";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                serviceTypes.add(rs.getString("ServiceType"));
            }
        } catch (Exception e) {
            System.err.println("Lỗi khi lấy danh sách loại dịch vụ: " + e.getMessage());
            e.printStackTrace();
        }
        return serviceTypes;
    }

    /**
     * Lấy danh sách dịch vụ dựa trên các tiêu chí lọc và tìm kiếm.
     * @param keyword Từ khóa tìm kiếm theo tên dịch vụ (có thể null hoặc rỗng).
     * @param type Lọc theo loại dịch vụ (có thể null hoặc rỗng).
     * @param status Lọc theo trạng thái ("1" cho available, "0" cho not available; có thể null hoặc rỗng).
     * @param sortBy Tiêu chí sắp xếp (ví dụ: "name_asc", "price_desc"; có thể null để sắp xếp mặc định).
     * @param page Trang hiện tại cho phân trang (0 hoặc 1 nếu không phân trang/lấy tất cả).
     * @return Danh sách các dịch vụ.
     */
    public List<Service> getFilteredServices(String keyword, String type, String status, String sortBy, int page) {
        List<Service> services = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM services WHERE 1=1"); // Mệnh đề WHERE 1=1 để dễ dàng nối thêm AND
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND ServiceName LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (type != null && !type.trim().isEmpty()) {
            sql.append(" AND ServiceType = ?");
            params.add(type.trim());
        }
        if (status != null && !status.trim().isEmpty()) {
            // Giả sử cột AvailabilityStatus trong DB là '1' (Available) hoặc '0' (Not Available)
            sql.append(" AND AvailabilityStatus = ?");
            params.add(status.trim());
        }

        // Ví dụ về sắp xếp (có thể mở rộng thêm)
        if (sortBy != null && !sortBy.trim().isEmpty()) {
            // Cần cẩn thận với SQL Injection nếu sortBy đến trực tiếp từ người dùng mà không qua kiểm tra
            // Tốt nhất là dùng whitelist cho các giá trị sortBy hợp lệ
            if (sortBy.equalsIgnoreCase("name_asc")) {
                sql.append(" ORDER BY ServiceName ASC");
            } else if (sortBy.equalsIgnoreCase("name_desc")) {
                sql.append(" ORDER BY ServiceName DESC");
            } // Thêm các trường hợp sắp xếp khác nếu cần
            else {
                sql.append(" ORDER BY ServiceID ASC"); // Sắp xếp mặc định
            }
        } else {
            sql.append(" ORDER BY ServiceID ASC"); // Sắp xếp mặc định nếu không có sortBy
        }

        // Nếu có phân trang, bạn sẽ thêm LIMIT và OFFSET ở đây
        // Ví dụ: sql.append(" LIMIT ? OFFSET ?");
        // params.add(recordsPerPage);
        // params.add((page - 1) * recordsPerPage);

        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
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
            }
        } catch (Exception e) {
            e.printStackTrace(); // Nên ghi log lỗi này
        }
        return services;
    }

    // Ghi đè hoặc sửa phương thức getAll() để sử dụng getFilteredServices
    // Điều này đảm bảo tính nhất quán nếu các phần khác của code vẫn gọi getAll()
    public List<Service> getAll() {
        // Gọi getFilteredServices không có bộ lọc, không sắp xếp cụ thể, không phân trang
        return getFilteredServices(null, null, null, null, 0);
    }

    // ... (các phương thức addService, update, toggleServiceStatus hiện có của bạn) ...
    // Đảm bảo rằng phương thức toggleServiceStatus hiện tại của bạn hoạt động đúng với ToggleServiceStatusServlet.
    // Ví dụ:
    public boolean addService(Service s) {
        String sql = "INSERT INTO services (ServiceName, Price, Description, AvailabilityStatus, ServiceType, CreatedDate, LastUpdatedDate, CreatedBy, LastUpdatedBy, ServiceImage) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setInt(2, s.getPrice());
            ps.setString(3, s.getDescription());
            ps.setString(4, s.getStatus()); // "1" or "0"
            ps.setString(5, s.getType());
            ps.setObject(6, s.getCreateDate());
            ps.setObject(7, s.getLastUpdateDate());
            ps.setString(8, s.getCreatedBy());
            ps.setString(9, s.getLastUpdateBy());
            ps.setString(10, s.getServiceImage());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("Lỗi khi thêm dịch vụ: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean update(Service s) {
        String sql = "UPDATE services SET ServiceName = ?, Price = ?, Description = ?, AvailabilityStatus = ?, " +
                     "ServiceType = ?, LastUpdatedDate = ?, LastUpdatedBy = ?, ServiceImage = ? WHERE ServiceID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setInt(2, s.getPrice());
            ps.setString(3, s.getDescription());
            ps.setString(4, s.getStatus());
            ps.setString(5, s.getType());
            ps.setObject(6, s.getLastUpdateDate());
            ps.setString(7, s.getLastUpdateBy());
            ps.setString(8, s.getServiceImage());
            ps.setInt(9, s.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Giả sử phương thức này đã tồn tại và được ToggleServiceStatusServlet sử dụng
    public boolean toggleServiceStatus(int id) { // hoặc toggleServiceStatus(int id, String updatedBy)
        boolean success = false;
        // Câu lệnh SQL của bạn có thể khác, đây chỉ là ví dụ
        String sql = "UPDATE services SET AvailabilityStatus = CASE " +
                     "WHEN AvailabilityStatus = '1' THEN '0' " +
                     "ELSE '1' END, " +
                     "LastUpdatedDate = ? " + // Nên cập nhật cả LastUpdatedDate
                   //  "LastUpdatedBy = ? " +   // Và LastUpdatedBy nếu có
                     "WHERE ServiceID = ?";
        try (Connection conn = DBConnect.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, LocalDateTime.now());
            // ps.setString(2, "current_user_from_session"); // Nếu bạn lưu người cập nhật
            ps.setInt(2, id); // Hoặc 3 nếu có LastUpdatedBy
            success = ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }
}