/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Invoice;

import DAO.InvoiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;
import java.time.LocalDateTime;
import model.Invoice;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
@WebServlet(name = "CreateInvoiceServlet", urlPatterns = {"/CreateInvoiceServlet"})
public class CreateInvoiceServlet extends HttpServlet {

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
            out.println("<title>Servlet CreateInvoiceServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CreateInvoiceServlet at " + request.getContextPath() + "</h1>");
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

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String paymentStatus = request.getParameter("paymentStatus");
        String note = request.getParameter("note");

        // Giả sử bạn lấy account ID từ session
        HttpSession session = request.getSession();
        Object accIdObj = session.getAttribute("accountId");

        if (accIdObj == null) {
            // Có thể chuyển hướng về trang đăng nhập
            response.sendRedirect("login.jsp");
            return;
        }

        int accountId = (int) accIdObj;

        // Các giá trị tính từ booking/service (có thể truyền từ request hoặc tính từ DAO)
        double roomTotal = Double.parseDouble(request.getParameter("roomTotal"));
        double serviceTotal = Double.parseDouble(request.getParameter("serviceTotal"));
        String discountCode = request.getParameter("discountCode");
        int discountPercent = Integer.parseInt(request.getParameter("discountPercent"));
        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

        Invoice invoice = new Invoice();
        invoice.setBookingId(bookingId);
        invoice.setIssuedBy(accountId);
        invoice.setIssuedDate(LocalDateTime.now());
        invoice.setRoomTotal(roomTotal);
        invoice.setServiceTotal(serviceTotal);
        invoice.setDiscountCode(discountCode);
        invoice.setDiscountPercent(discountPercent);
        invoice.setTotalAmount(totalAmount);
        invoice.setPaymentStatus(paymentStatus);
        invoice.setNote(note);

        InvoiceDAO dao = new InvoiceDAO();
        try {
            if (!dao.hasInvoice(bookingId)) {
                dao.insertInvoice(invoice);
            } else {
                request.setAttribute("error", "This booking already has an invoice.");
                request.getRequestDispatcher("LoadInvoiceDataServlet").forward(request, response);
                return;
            }
        } catch (SQLException ex) {
            Logger.getLogger(CreateInvoiceServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        response.sendRedirect("LoadInvoiceDataServlet"); // hoặc thông báo thành công
        

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
