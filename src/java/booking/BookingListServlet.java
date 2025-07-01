/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package booking;

import DAO.BookingDAO;
import DAO.BookingDAOStaff;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.BooKinglist;
import model.Booking;


/**
 *
 * @author Admin
 */
@WebServlet(name = "BookingListServlet", urlPatterns = {"/booking-list"})
public class BookingListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BookingDAOStaff dao = new BookingDAOStaff();
        List<BooKinglist> bookings = dao.getAllBookings();
        request.setAttribute("bookings", bookings);
        request.getRequestDispatcher("booking-list.jsp").forward(request, response);
    }

}
