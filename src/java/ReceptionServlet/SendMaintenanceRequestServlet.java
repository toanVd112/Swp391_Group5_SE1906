///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
package ReceptionServlet;
//

import DAO.AccountDAO;
import DAO.MaintenanceRequestDAO1;
import DAO.RoomDAO;
import model.Room;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;
import model.MaintenanceRequest;

@WebServlet("/sendMaintenanceRequest")
public class SendMaintenanceRequestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomNumber = request.getParameter("roomNumber");
        int staffID = Integer.parseInt(request.getParameter("staffID"));
        String description = request.getParameter("description");

        RoomDAO roomDAO = new RoomDAO();
        MaintenanceRequestDAO1 maintenanceDAO = new MaintenanceRequestDAO1();
        AccountDAO accountDAO = new AccountDAO();

        try {
            // Kiểm tra phòng có tồn tại không
            Room room = roomDAO.getRoomByNumber(roomNumber);
            if (room == null) {
                request.setAttribute("error", "This room does not exist!");
                setRequestAttributes(request);
                request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
                return;
            }

            // Kiểm tra phòng có sẵn không
            if (!"Available".equalsIgnoreCase(room.getStatus())) {
                request.setAttribute("error", "Room not available for maintenance! (Status: " + room.getStatus() + ")");
                setRequestAttributes(request);
                request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
                return;
            }

            // Thêm yêu cầu bảo trì
            boolean success = maintenanceDAO.insertRequest(room.getRoomID(), staffID, description);
            List<MaintenanceRequest> allRequests = maintenanceDAO.getAllRequests();
            request.setAttribute("requestList", allRequests);

            if (success) {
                // Cập nhật trạng thái phòng thành 'In process'
                roomDAO.updateRoomStatus(room.getRoomID(), "In process");

                // Đặt thông báo thành công và làm mới trang
                request.setAttribute("success", "Maintenance request has been submitted successfully and notification has been sent to staff!");
                setRequestAttributes(request);
                request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Unable to send request.");
                setRequestAttributes(request);
                request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            Logger.getLogger(SendMaintenanceRequestServlet.class.getName()).log(Level.SEVERE, "Lỗi chuyển đổi staffID: " + e.getMessage(), e);
            request.setAttribute("error", "Định dạng staffID không hợp lệ!");
            try {
                setRequestAttributes(request);
            } catch (SQLException ex) {
                Logger.getLogger(SendMaintenanceRequestServlet.class.getName()).log(Level.SEVERE, "Lỗi khi đặt thuộc tính request: " + ex.getMessage(), ex);
            }
            request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
        } catch (SQLException e) {
            Logger.getLogger(SendMaintenanceRequestServlet.class.getName()).log(Level.SEVERE, "Lỗi SQL khi xử lý yêu cầu: " + e.getMessage(), e);
            request.setAttribute("error", "Đã xảy ra lỗi cơ sở dữ liệu khi xử lý yêu cầu!");
            try {
                setRequestAttributes(request);
            } catch (SQLException ex) {
                Logger.getLogger(SendMaintenanceRequestServlet.class.getName()).log(Level.SEVERE, "Lỗi khi đặt thuộc tính request: " + ex.getMessage(), ex);
            }
            request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
        } catch (Exception e) {
            Logger.getLogger(SendMaintenanceRequestServlet.class.getName()).log(Level.SEVERE, null, e);
            request.setAttribute("error", "An error occurred while processing the request!");
            try {
                setRequestAttributes(request);
            } catch (SQLException ex) {
                Logger.getLogger(SendMaintenanceRequestServlet.class.getName()).log(Level.SEVERE, "Lỗi khi đặt thuộc tính request: " + ex.getMessage(), ex);
            }
            request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AccountDAO accountDAO = new AccountDAO();
        RoomDAO roomDAO = new RoomDAO();
        MaintenanceRequestDAO1 maintenanceDAO = new MaintenanceRequestDAO1();

        try {
            // Lấy danh sách staff
            List<Account> staffList = accountDAO.getAccountsByRole("Staff");
            request.setAttribute("staffList", staffList);

            // Gán Map<staffID, username>
            Map<Integer, String> staffMap = new HashMap<>();
            for (Account acc : staffList) {
                staffMap.put(acc.getAccountID(), acc.getUsername());
            }
            request.setAttribute("staffMap", staffMap);

            // Lấy danh sách phòng sẵn sàng
            List<Room> availableRooms = roomDAO.getAvailableRooms();
            request.setAttribute("availableRooms", availableRooms);

            // Lấy danh sách yêu cầu bảo trì
            List<MaintenanceRequest> allRequests = maintenanceDAO.getAllRequests();
            request.setAttribute("requestList", allRequests);

            request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
        } catch (SQLException ex) {
            Logger.getLogger(SendMaintenanceRequestServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Error retrieving data!");
            request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
        }
    }

    private void setRequestAttributes(HttpServletRequest request) throws SQLException {
        AccountDAO accountDAO = new AccountDAO();
        RoomDAO roomDAO = new RoomDAO();
        MaintenanceRequestDAO1 maintenanceDAO = new MaintenanceRequestDAO1();

        request.setAttribute("staffList", accountDAO.getAccountsByRole("Staff"));
        Map<Integer, String> staffMap = new HashMap<>();
        for (Account acc : (List<Account>) request.getAttribute("staffList")) {
            staffMap.put(acc.getAccountID(), acc.getUsername());
        }
        request.setAttribute("staffMap", staffMap);
        request.setAttribute("availableRooms", roomDAO.getAvailableRooms());
        request.setAttribute("requestList", maintenanceDAO.getAllRequests());
    }
}
