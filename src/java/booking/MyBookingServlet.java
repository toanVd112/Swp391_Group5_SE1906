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
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.Booking;
import model.User;

/**
 *
 * @author Admin
 */
@WebServlet(name = "MyBookingServlet", urlPatterns = {"/MyBookingServlet"})
public class MyBookingServlet extends HttpServlet {

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
            out.println("<title>Servlet MyBookingServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MyBookingServlet at " + request.getContextPath() + "</h1>");
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

        HttpSession session = request.getSession(false);
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = new ArrayList<>();

        try {
            User userInfo = null;
            if (session != null) {
                userInfo = (User) session.getAttribute("userInfo");
            }

            if (userInfo != null) {
                int userId = userInfo.getUserId();

                String statusFilter = request.getParameter("statusFilter");
                if (statusFilter == null || statusFilter.trim().isEmpty()) {
                    statusFilter = "";
                }

                String searchBookingIdParam = request.getParameter("searchBookingId");
                Integer searchBookingId = null;

                if (searchBookingIdParam != null && !searchBookingIdParam.trim().isEmpty()) {
                    try {
                        searchBookingId = Integer.parseInt(searchBookingIdParam.trim());
                    } catch (NumberFormatException ex) {
                        // Ignore invalid input
                    }
                }

                // Phân trang
                int page = 1;
                int limit = 5;
                String pageParam = request.getParameter("page");
                if (pageParam != null) {
                    try {
                        page = Integer.parseInt(pageParam);
                    } catch (NumberFormatException e) {
                        page = 1;
                    }
                }
                int offset = (page - 1) * limit;

                // Lấy danh sách phân trang kèm filter
                bookings = bookingDAO.getBookingsWithPagination(userId, statusFilter, searchBookingId, offset, limit);
                int totalBookings = bookingDAO.countBookingsByUser(userId, statusFilter, searchBookingId);
                int totalPages = (int) Math.ceil((double) totalBookings / limit);

                // Gửi dữ liệu sang JSP
                if (bookings == null) {
                    bookings = new ArrayList<>();
                }

                request.setAttribute("bookings", bookings);
                request.setAttribute("currentPage", page);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("statusFilter", statusFilter);
                request.setAttribute("searchBookingId", searchBookingIdParam);

                request.getRequestDispatcher("MyBooking.jsp").forward(request, response);

            } else {
                // Xử lý Guest tra cứu
                String bookingIdParam = request.getParameter("bookingID");
                String bookingToken = request.getParameter("bookingToken");

                if (bookingIdParam != null && bookingToken != null) {
                    try {
                        int bookingId = Integer.parseInt(bookingIdParam.trim());
                        Booking guestBooking = bookingDAO.getBookingByIdAndToken(bookingId, bookingToken);
                        if (guestBooking != null) {
                            bookings.add(guestBooking);
                        }
                    } catch (NumberFormatException ex) {
                        System.out.println("Invalid bookingID: " + bookingIdParam);
                    }
                }

                request.setAttribute("bookings", bookings);
                request.getRequestDispatcher("MyBooking.jsp").forward(request, response);
            }

        } catch (Exception e) {
            throw new ServletException(e);
        }
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
        processRequest(request, response);
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
