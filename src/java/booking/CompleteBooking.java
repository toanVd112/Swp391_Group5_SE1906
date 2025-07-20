/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package booking;

import DAO.BookingDAO;
import DAO.DiscountCodeDAO;
import DAO.RoomDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.List;
import model.Booking;
import model.DiscountCode;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CompleteBooking", urlPatterns = {"/CompleteBooking"})
public class CompleteBooking extends HttpServlet {

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
            out.println("<title>Servlet CompleteBooking</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CompleteBooking at " + request.getContextPath() + "</h1>");
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
        processRequest(request, response);
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
        request.setCharacterEncoding("UTF-8");

        int bookingID = Integer.parseInt(request.getParameter("bookingID"));
        String discountCode = request.getParameter("discountCode");

        BookingDAO bookingDAO = new BookingDAO();
        RoomDAO roomDAO = new RoomDAO();
        DiscountCodeDAO discountDAO = new DiscountCodeDAO();

        Booking booking = bookingDAO.getBookingByID(bookingID);
        if (booking == null) {
            response.sendRedirect("error.jsp");
            return;
        }

        String email = booking.getContactEmail();
        String fullName = booking.getContactName();
        double discountAmount = 0;

        // ⚙️ Kiểm tra discountCode (nếu có nhập)
        if (discountCode != null && !discountCode.trim().isEmpty()) {
            DiscountCode dc = discountDAO.getDiscountCodeByCode(discountCode.trim());

            boolean valid = false;
            if (dc != null && "Active".equals(dc.getStatus()) && dc.getExpiryDate().isAfter(java.time.LocalDate.now())) {
                valid = discountDAO.isUserEligibleForCode(email, discountCode.trim());
            }

            if (valid) {
                double total = booking.getTotalAmount();
                discountAmount = total * dc.getDiscountPercent() / 100;
                total=total-discountAmount;
                // Nếu bạn có cột DiscountCode và DiscountAmount trong bảng bookings thì ghi lại:
                bookingDAO.applyDiscountToBooking(bookingID, dc.getDiscountCodeID(), total);

                // (Optional) Thông báo mã đã dùng
                request.getSession().setAttribute("flashMsg", "🎉 Mã giảm giá đã được áp dụng thành công!");
            } else {
                request.getSession().setAttribute("flashMsg", "❌ Mã giảm giá không hợp lệ hoặc bạn chưa đủ điều kiện.");
                response.sendRedirect("thanhtoan.jsp?bookingID=" + bookingID);
                return;
            }
        }

        // Gửi mail xác nhận
        try {
            MailUtils.sendBookingSuccessMail(
                    email,
                    fullName,
                    bookingID,
                    booking.getCheckInDate(),
                    booking.getCheckOutDate()
            );
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

        // Cập nhật trạng thái booking
        boolean updated = bookingDAO.updateBookingStatus(bookingID, "Upcoming");
        if (updated) {
            // Cập nhật trạng thái phòng
            List<Integer> roomIDs = bookingDAO.getRoomIDsByBookingID(bookingID);
            for (int roomID : roomIDs) {
                roomDAO.updateRoomStatus(roomID, "Occupied");
            }

            // Xoá expiryTime nếu có
            bookingDAO.clearExpiryTime(bookingID);
// Sau khi xác nhận thành công, kiểm tra để gửi mã khuyến mãi mới
            int bookingCount = discountDAO.countCompletedBookingsByEmail(email);

            String level = null;
            if (bookingCount == 1) {
                level = "WELCOME";
            } else if (bookingCount == 3) {
                level = "LOYAL";
            } else if (bookingCount >= 5) {
                level = "VIP";
            }

            if (level != null) {
                String nextCode = discountDAO.getActiveCodeByLevel(level);
                if (nextCode != null) {
                    try {
                        MailUtils.sendWelcomeDiscountMail(email, fullName, nextCode);
                        System.out.println("✅ Đã gửi mã " + nextCode + " cho khách " + email);
                    } catch (UnsupportedEncodingException e) {
                        e.printStackTrace();
                    }
                }
            }

            // Điều hướng về Home
            response.sendRedirect("Home");
        } else {
            response.sendRedirect("error.jsp");
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
