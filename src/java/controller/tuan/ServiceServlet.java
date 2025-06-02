/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.tuan;

import DAO.ServiceDAO;
import model.Service;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author admin
 */
@WebServlet(name = "ServiceServlet", urlPatterns = {"/services"})
public class ServiceServlet extends HttpServlet {

    private ServiceDAO serviceDAO;

    @Override
    public void init() throws ServletException {
        try {
            serviceDAO = new ServiceDAO();
        } catch (SQLException e) {
            throw new ServletException("Cannot initialize ServiceDAO", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if (action != null && action.equals("delete")) {
                int serviceID = Integer.parseInt(request.getParameter("id"));
                serviceDAO.delete(serviceID);
                response.sendRedirect("services");
            } else {
                System.out.println("Pass here 1");
                this.log("Pass here 1");
                request.getRequestDispatcher("/Manager/ServiceList.jsp").forward(request, response);
                return;
            }
        } catch (SQLException e) {
            throw new ServletException("Error processing GET request", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
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

            if (action != null && action.equals("update")) {
                serviceDAO.update(service);
            } else {
                serviceDAO.insert(service);
            }
            response.sendRedirect("services");
        } catch (SQLException e) {
            throw new ServletException("Error processing POST request", e);
        } catch (NumberFormatException e) {
            throw new ServletException("Invalid number format", e);
        }
    }
}