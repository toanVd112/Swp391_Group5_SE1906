/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.tuan;

import DAO.ServiceDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
<<<<<<< HEAD
import java.math.BigDecimal;
=======
>>>>>>> d0e996313656d347c86c0d7c1d6d2accd17cfc86
import java.sql.SQLException;
import model.Service;

/**
 *
 * @author admin
 */
@WebServlet(name = "addService", urlPatterns = {"/addService"})
public class addService extends HttpServlet {

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
            out.println("<title>Servlet addService</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet addService at " + request.getContextPath() + "</h1>");
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
        try {
            ServiceDAO dao = new ServiceDAO();
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            boolean status = "1".equals(request.getParameter("status"));

<<<<<<< HEAD
            Service service = new Service();
            service.setServiceID(Integer.parseInt(request.getParameter("serviceID")));
            service.setServiceName(request.getParameter("serviceName"));
            service.setPrice(new BigDecimal(request.getParameter("price")));
            service.setDescription(request.getParameter("description"));
            service.setAvailabilityStatus(request.getParameter("availabilityStatus"));
            service.setServiceType(request.getParameter("serviceType"));
            // CreatedDate and LastUpdatedDate are set in DB (CURRENT_TIMESTAMP) or null
            service.setCreatedBy(request.getParameter("createdBy"));
            service.setLastUpdatedBy(request.getParameter("lastUpdatedBy"));
            service.setServiceImage(request.getParameter("serviceImage"));

            if (idStr == null || idStr.isEmpty()) {
                dao.insert(service);
            } else {
                service.setServiceID(Integer.parseInt(idStr));
                dao.update(service);
=======
            Service s = new Service();
            s.setServiceName(name);
            s.setDescription(description);
            s.setPrice(price);
            s.setStatus(status);

            if (idStr == null || idStr.isEmpty()) {
                dao.insert(s);
            } else {
                s.setServiceID(Integer.parseInt(idStr));
                dao.update(s);
>>>>>>> d0e996313656d347c86c0d7c1d6d2accd17cfc86
            }

            response.sendRedirect("services");
        } catch (SQLException e) {
            throw new ServletException("SQL Error: " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ServletException("Error: " + e.getMessage(), e);
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
<<<<<<< HEAD

=======
        processRequest(request, response);
>>>>>>> d0e996313656d347c86c0d7c1d6d2accd17cfc86
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
