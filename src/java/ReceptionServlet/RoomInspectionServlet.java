package ReceptionServlet;

import DAO.AccountDAO;
import DAO.RoomInspectionReportDAO;
import model.RoomInspectionReport;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Account;

@WebServlet(name = "RoomInspectionServlet", urlPatterns = {"/roomInspection"})
public class RoomInspectionServlet extends HttpServlet {

    private final RoomInspectionReportDAO dao = new RoomInspectionReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Map<Integer, String> roomMap = dao.getRoomIdToRoomNumberMap();
            request.setAttribute("roomMap", roomMap);
            AccountDAO accountDao = new AccountDAO();
            List<Account> staffList = accountDao.getAccountsByRole("Staff");
            request.setAttribute("staffList", staffList);

            // Lấy toàn bộ báo cáo
            List<RoomInspectionReport> reports = dao.getAll();
            request.setAttribute("reports", reports);

            // Tạo map staffID → Username
            Map<Integer, String> staffMap = new HashMap<>();
            for (Account staff : staffList) {
                staffMap.put(staff.getAccountID(), staff.getUsername());
            }
            request.setAttribute("staffMap", staffMap);

            // Forward
            request.getRequestDispatcher("Receptionist/reception.jsp?page=roomInspection.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách yêu cầu!");
            request.getRequestDispatcher("Receptionist/reception.jsp?page=roomInspection.jsp").forward(request, response);
        }
    }

//
    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            String roomNumber = request.getParameter("roomNumber");
            String notes = request.getParameter("notes");
            int staffId = Integer.parseInt(request.getParameter("staffId"));

            // 1. Lấy RoomID từ RoomNumber
            int roomId = dao.getRoomIdByRoomNumber(roomNumber);

            // 2. Lấy BookingID từ RoomNumber có trạng thái 'Active'
            int bookingId = dao.getActiveBookingIdByRoomNumber(roomNumber);

            // 3. Tạo báo cáo
            RoomInspectionReport report = new RoomInspectionReport(bookingId, roomId);
            report.setStaffID(staffId);
            report.setNotes(notes);

            dao.insert(report);
            response.sendRedirect("roomInspection");

        } catch (SQLException e) {
            e.printStackTrace();
            handleError(request, response, "Không thể gửi yêu cầu: " + e.getMessage());
        } catch (NumberFormatException e) {
            e.printStackTrace();
            handleError(request, response, "Dữ liệu đầu vào không hợp lệ!");
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        try {
            AccountDAO accountDao = new AccountDAO();
            List<Account> staffList = accountDao.getAccountsByRole("Staff");
            request.setAttribute("staffList", staffList);
            request.setAttribute("reports", dao.getAll());
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        request.setAttribute("error", message);
        request.getRequestDispatcher("Receptionist/reception.jsp?page=roomInspection.jsp").forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet cho Receptionist gửi yêu cầu kiểm tra phòng";
    }
}
