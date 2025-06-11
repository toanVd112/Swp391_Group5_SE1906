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
import java.util.List;
import model.Account;

@WebServlet(name = "RoomInspectionServlet", urlPatterns = {"/roomInspection"})
public class RoomInspectionServlet extends HttpServlet {

    private final RoomInspectionReportDAO dao = new RoomInspectionReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            AccountDAO accountDao = new AccountDAO();
            List<Account> staffList = accountDao.getAccountsByRole("Staff");
            request.setAttribute("staffList", staffList);

            request.setAttribute("reports", dao.getAll());
            request.getRequestDispatcher("Receptionist/roomInspection.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tải danh sách yêu cầu!");
            request.getRequestDispatcher("Receptionist/roomInspection.jsp").forward(request, response);
        }
    }

    @Override

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            int bookingId = Integer.parseInt(request.getParameter("bookingId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String notes = request.getParameter("notes");
            int staffId = Integer.parseInt(request.getParameter("staffId"));

            RoomInspectionReport report = new RoomInspectionReport(bookingId, roomId);
            report.setStaffID(staffId);
            report.setNotes(notes);

            dao.insert(report);
            response.sendRedirect("roomInspection");

        } catch (SQLException e) {
            e.printStackTrace();
            try {
                AccountDAO accountDao = new AccountDAO();
                List<Account> staffList = accountDao.getAccountsByRole("Staff");
                request.setAttribute("staffList", staffList);

                request.setAttribute("reports", dao.getAll()); // load lại danh sách báo cáo nếu cần
            } catch (Exception ex) {
                ex.printStackTrace(); // log thêm lỗi phụ
            }

            request.setAttribute("error", "Lỗi khi thêm yêu cầu!");
            request.getRequestDispatcher("Receptionist/roomInspection.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            e.printStackTrace();
            try {
                AccountDAO accountDao = new AccountDAO();
                List<Account> staffList = accountDao.getAccountsByRole("Staff");
                request.setAttribute("staffList", staffList);
                request.setAttribute("reports", dao.getAll());
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            request.setAttribute("error", "Dữ liệu đầu vào không hợp lệ!");
            request.getRequestDispatcher("Receptionist/roomInspection.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet cho Receptionist gửi yêu cầu kiểm tra phòng";
    }
}
