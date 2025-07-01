/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package booking;

import DAO.BookingDAO;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.lang.reflect.Type;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.RoomItem;
import model.ServiceItem;
import model.User;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ProceedBookingServlet", urlPatterns = {"/ProceedBookingServlet"})
public class ProceedBookingServlet extends HttpServlet {

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
            out.println("<title>Servlet ProceedBookingServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProceedBookingServlet at " + request.getContextPath() + "</h1>");
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
        String roomsJSON = request.getParameter("selectedRoomsJSON");
        String servicesJSON = request.getParameter("selectedServicesJSON");
        String checkin = request.getParameter("checkin");
        String checkout = request.getParameter("checkout");
        DateTimeFormatter inFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter outFmt = DateTimeFormatter.ofPattern("yyyy-MM-dd");

        LocalDate checkinDate = LocalDate.parse(checkin, inFmt);
        LocalDate checkoutDate = LocalDate.parse(checkout, inFmt);

        checkin = checkinDate.format(outFmt);
        checkout = checkoutDate.format(outFmt);

        int guests = Integer.parseInt(request.getParameter("guests"));
        String paymentMethod = request.getParameter("paymentMethod");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

        Integer userID = null;
        if (request.getSession().getAttribute("user") != null) {
            User u = (User) request.getSession().getAttribute("user");
            userID = u.getUserId();
        }

// Parse JSON
        Gson gson = new Gson();
        Type roomListType = new TypeToken<List<RoomItem>>() {
        }.getType();
        List<RoomItem> selectedRooms = gson.fromJson(roomsJSON, roomListType);

        Type serviceListType = new TypeToken<List<ServiceItem>>() {
        }.getType();
        List<ServiceItem> selectedServices = gson.fromJson(servicesJSON, serviceListType);

// ➜ DEBUG quan trọng!
        System.out.println("✅ Servlet: roomsJSON = " + roomsJSON);
        System.out.println("✅ Servlet: selectedRooms = " + selectedRooms);
        System.out.println("✅ Servlet: paymentMethod = " + paymentMethod);

        BookingDAO bookingDAO = new BookingDAO();
        int bookingID = 0;
        try {
            bookingID = bookingDAO.insertBooking(userID, checkin, checkout, guests, "Pending", fullName, email, phone, totalAmount);
        } catch (SQLException ex) {
            Logger.getLogger(ProceedBookingServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        if (bookingID <= 0) {
            throw new RuntimeException(
                    "❌ Insert booking failed:\n"
                    + "  userID = " + userID + "\n"
                    + "  fullName = " + fullName + "\n"
                    + "  email = " + email + "\n"
                    + "  phone = " + phone + "\n"
                    + "  checkin = " + checkin + "\n"
                    + "  checkout = " + checkout + "\n"
                    + "  guests = " + guests + "\n"
                    + "  roomsJSON = " + roomsJSON + "\n"
                    + "  servicesJSON = " + servicesJSON + "\n"
                    + "  selectedRooms = " + selectedRooms + "\n"
                    + "  selectedServices = " + selectedServices + "\n"
                    + "  paymentMethod = " + paymentMethod
            );
        }

// Insert detail
        for (RoomItem item : selectedRooms) {
            if (item.rooms != null && !item.rooms.isEmpty()) {
                for (RoomItem r : item.rooms) {
                    try {
                        bookingDAO.insertBookingDetail(bookingID, r.roomTypeId, r.quantity, r.basePrice, r.roomCapacity);
                    } catch (SQLException ex) {
                        Logger.getLogger(ProceedBookingServlet.class.getName()).log(Level.SEVERE, null, ex);
                    }
                }
            } else {
                try {
                    bookingDAO.insertBookingDetail(bookingID, item.roomTypeId, item.quantity, item.basePrice, item.roomCapacity);
                } catch (SQLException ex) {
                    Logger.getLogger(ProceedBookingServlet.class.getName()).log(Level.SEVERE, null, ex);
                }
            }
        }

// Insert service
        for (ServiceItem s : selectedServices) {
            try {
                bookingDAO.insertServiceUsage(bookingID, s.serviceId, 1);
            } catch (SQLException ex) {
                Logger.getLogger(ProceedBookingServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        System.out.println("✅ Insert OK ➜ bookingID = " + bookingID);

        if ("online".equals(paymentMethod)) {
            response.sendRedirect("PaymentGatewayServlet?bookingID=" + bookingID);
        } else {
            response.sendRedirect("thanhtoan.jsp?bookingID=" + bookingID);
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
