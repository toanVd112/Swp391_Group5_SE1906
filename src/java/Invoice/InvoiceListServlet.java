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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;
import model.Invoice;

/**
 *
 * @author Admin
 */
@WebServlet(name = "InvoiceListServlet", urlPatterns = {"/InvoiceListServlet"})
public class InvoiceListServlet extends HttpServlet {

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
            out.println("<title>Servlet InvoiceListServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet InvoiceListServlet at " + request.getContextPath() + "</h1>");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy tham số lọc từ form
        String customerName = request.getParameter("customerName");
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");
        String status = request.getParameter("paymentStatus");

        java.sql.Date fromDate = null;
        java.sql.Date toDate = null;

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            if (fromDateStr != null && !fromDateStr.isEmpty()) {
                java.util.Date utilFromDate = sdf.parse(fromDateStr);
                fromDate = new java.sql.Date(utilFromDate.getTime());
            }
            if (toDateStr != null && !toDateStr.isEmpty()) {
                java.util.Date utilToDate = sdf.parse(toDateStr);
                toDate = new java.sql.Date(utilToDate.getTime());
            }
        } catch (Exception e) {
            // Ghi log gọn hoặc dùng logger
            System.err.println("Lỗi parse ngày: " + e.getMessage());
        }

        // Gọi DAO để lọc dữ liệu
        InvoiceDAO dao = new InvoiceDAO();
        List<Invoice> invoiceList = null;
        try {
            invoiceList = dao.filterInvoices(customerName, fromDate, toDate, status);
        } catch (SQLException ex) {
            Logger.getLogger(InvoiceListServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Truyền dữ liệu sang JSP
        request.setAttribute("invoiceList", invoiceList);
        request.setAttribute("customerName", customerName);
        request.setAttribute("fromDate", fromDateStr);
        request.setAttribute("toDate", toDateStr);
        request.setAttribute("paymentStatus", status);

        request.getRequestDispatcher("Receptionist/reception.jsp?page=invoiceList.jsp").forward(request, response);
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
