/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Invoice;

import DAO.BookingDAO;
import DAO.InvoiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Booking;
import model.InvoiceData;

/**
 *
 * @author Admin
 */
@WebServlet(name="LoadInvoiceDataServlet", urlPatterns={"/LoadInvoiceDataServlet"})
public class LoadInvoiceDataServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet LoadInvoiceDataServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoadInvoiceDataServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
  
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String bookingIdParam = request.getParameter("bookingId");
            int selectedBookingId = bookingIdParam != null && !bookingIdParam.isEmpty()
                    ? Integer.parseInt(bookingIdParam)
                    : -1;

            BookingDAO bookingDAO = new BookingDAO();
            InvoiceDAO invoiceDAO = new InvoiceDAO();

            // 1. Lấy danh sách booking COMPLETED và chưa có hóa đơn
            List<Booking> completedBookings = bookingDAO.getCompletedBookingsWithoutInvoice();

            // 2. Nếu người dùng chọn booking cụ thể → load chi tiết để hiện form
            InvoiceData invoiceData = null;
            if (selectedBookingId > 0) {
                invoiceData = invoiceDAO.getInvoiceDataByBookingId(selectedBookingId);
            }

            // 3. Gửi dữ liệu về JSP
            request.setAttribute("completedBookings", completedBookings);
            request.setAttribute("invoiceData", invoiceData);

            // Forward tới JSP tạo hóa đơn
            request.getRequestDispatcher("CreateInvoice.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading invoice data.");
        }
    }
    /** 
     * Handles the HTTP <code>POST</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
