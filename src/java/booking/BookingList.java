/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package booking;

import DAO.BookingDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.Arrays;
import java.util.List;
import model.Booking;

/**
 *
 * @author MyPC
 */
@WebServlet(name = "BookingList", urlPatterns = {"/bookingList"})
public class BookingList extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet BookingList</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet BookingList at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String sort = request.getParameter("sort");
        String page_raw = request.getParameter("page");
        int page = (page_raw == null) ? 1 : Integer.parseInt(page_raw);
        int pageSize = 5;

        BookingDAO dao = new BookingDAO();
        int totalBookings = dao.countAllBookings(search); // viết thêm hàm này
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);

        List<Booking> bookingList = dao.getBookingsWithPaging(search, sort, page, pageSize); // viết thêm hàm này

        request.setAttribute("bookingList", bookingList);
        request.setAttribute("statusList", Arrays.asList("Pending", "Upcoming", "Active", "Completed", "Cancelled", "Expired"));
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.getRequestDispatcher("Receptionist/reception.jsp?page=bookingList.jsp").forward(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String bookingID_raw = request.getParameter("bookingID");
        String newStatus = request.getParameter("status");

        // Lấy lại các tham số phân trang và lọc
        String search = request.getParameter("search");
        String sort = request.getParameter("sort");
        String page_raw = request.getParameter("page");
        int page = (page_raw != null) ? Integer.parseInt(page_raw) : 1;
        int pageSize = 5;

        BookingDAO dao = new BookingDAO();
        String message = null;

        try {
            int bookingID = Integer.parseInt(bookingID_raw);

            // ✅ Lấy trạng thái hiện tại từ DB
            String currentStatus = dao.getBookingStatus(bookingID);

            // ✅ Kiểm tra chuyển trạng thái có hợp lệ không
            if (isValidTransition(currentStatus, newStatus)) {
                dao.updateBookingStatus1(bookingID, newStatus);
                message = "Cập nhật trạng thái thành công.";
            } else {
                message = "Không thể chuyển trạng thái từ '" + currentStatus + "' sang '" + newStatus + "'";
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            message = "Lỗi dữ liệu booking ID.";
        }

        // Load lại danh sách booking
        int totalBookings = dao.countAllBookings(search);
        int totalPages = (int) Math.ceil((double) totalBookings / pageSize);

        List<Booking> bookingList = dao.getBookingsWithPaging(search, sort, page, pageSize);
        List<String> statusList = Arrays.asList("Pending", "Upcoming", "Active", "Completed", "Cancelled", "Expired");

        request.setAttribute("bookingList", bookingList);
        request.setAttribute("statusList", statusList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("param.search", search);
        request.setAttribute("param.sort", sort);
        request.setAttribute("message", message); // ✅ Gửi thông báo

        request.getRequestDispatcher("Receptionist/reception.jsp?page=bookingList.jsp").forward(request, response);

    }

    boolean isValidTransition(String currentStatus, String newStatus) {
        switch (currentStatus) {
            case "Pending":
                return newStatus.equals("Cancelled") || newStatus.equals("Upcoming");
            case "Upcoming":
                return newStatus.equals("Cancelled") || newStatus.equals("Active");
            case "Active":
                return newStatus.equals("Completed");
            default:
                return false; // Completed, Cancelled, Expired không cho chuyển nữa
        }
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
