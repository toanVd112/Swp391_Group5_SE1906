/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Invoice;

import DAO.InvoiceDAO;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.FontFactory;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfWriter;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.time.format.DateTimeFormatter;
import model.Invoice;
import com.lowagie.text.pdf.PdfPTable;

/**
 *
 * @author Admin
 */
@WebServlet(name = "GenerateInvoicePDFServlet", urlPatterns = {"/GenerateInvoicePDFServlet"})
public class GenerateInvoicePDFServlet extends HttpServlet {

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
            out.println("<title>Servlet GenerateInvoicePDFServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GenerateInvoicePDFServlet at " + request.getContextPath() + "</h1>");
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
        try {
            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));

            InvoiceDAO dao = new InvoiceDAO();
            Invoice inv = dao.getInvoiceById(invoiceId);
            if (inv == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Invoice not found.");
                return;
            }

            // Thiết lập response là file PDF
            response.setContentType("application/pdf");
            response.setHeader("Content-Disposition", "inline; filename=invoice_" + invoiceId + ".pdf");

            OutputStream out = response.getOutputStream();
            Document doc = new Document();
            PdfWriter.getInstance(doc, out);

            doc.open();

            // Tạo font
            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 18);
            Font labelFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 12);
            Font valueFont = FontFactory.getFont(FontFactory.HELVETICA, 12);
            Font totalFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 14);

// Tiêu đề căn giữa
            Paragraph title = new Paragraph("PAYMENT INVOICE", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            title.setSpacingAfter(20);
            doc.add(title);

// Tạo bảng 2 cột: label + value
            PdfPTable table = new PdfPTable(2);

            table.setWidthPercentage(70); // Đừng để 100% nếu muốn đẹp khi căn giữa
            table.setSpacingBefore(10);
            table.setSpacingAfter(20);
            table.setWidths(new float[]{1.5f, 3.5f});
            table.setHorizontalAlignment(Element.ALIGN_CENTER); // 👈 Căn giữa

// Tiện ích add dòng
            addRow(table, "Customer", inv.getCustomerName(), labelFont, valueFont);
            addRow(table, "Invoice ID", String.valueOf(inv.getInvoiceId()), labelFont, valueFont);
            addRow(table, "Date created", inv.getIssuedDate().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")), labelFont, valueFont);
            addRow(table, "Booking ID", String.valueOf(inv.getBookingId()), labelFont, valueFont);
            addRow(table, "Room", formatCurrency(inv.getRoomTotal()), labelFont, valueFont);
            addRow(table, "Service", formatCurrency(inv.getServiceTotal()), labelFont, valueFont);
            addRow(table, "Discount", inv.getDiscountPercent() + "%", labelFont, valueFont);

// Tổng cộng (in đậm)
            PdfPCell totalLabel = new PdfPCell(new Phrase("Total", totalFont));
            PdfPCell totalValue = new PdfPCell(new Phrase(formatCurrency(inv.getTotalAmount()), totalFont));
            totalLabel.setBorder(Rectangle.NO_BORDER);
            totalValue.setBorder(Rectangle.NO_BORDER);
            table.addCell(totalLabel);
            table.addCell(totalValue);

// Trạng thái
            addRow(table, "Status", inv.getPaymentStatus(), labelFont, valueFont);

// Ghi chú (nếu có)
            addRow(table, "Note", inv.getNote() != null ? inv.getNote() : "-", labelFont, valueFont);

            doc.add(table);

            doc.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi khi tạo PDF.");
        }
    }

    private void addRow(PdfPTable table, String label, String value, Font labelFont, Font valueFont) {
        PdfPCell cell1 = new PdfPCell(new Phrase(label + ":", labelFont));
        PdfPCell cell2 = new PdfPCell(new Phrase(value, valueFont));
        cell1.setBorder(Rectangle.NO_BORDER);
        cell2.setBorder(Rectangle.NO_BORDER);
        table.addCell(cell1);
        table.addCell(cell2);
    }

    private String formatCurrency(double value) {
        return String.format("%,.0f", value) + " đ";
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
