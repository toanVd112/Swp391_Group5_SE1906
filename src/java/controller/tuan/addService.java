///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
//package controller.tuan;
//
//import DAO.ServiceDAO;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//import java.math.BigDecimal;
//
//import java.sql.SQLException;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//import model.Service;
//
///**
// *
// * @author admin
// */
//@WebServlet(name = "addService", urlPatterns = {"/addService"})
//public class addService extends HttpServlet {
//
//    /**
//     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
//     * methods.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet addService</title>");
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet addService at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    }
//
//    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
//    /**
//     * Handles the HTTP <code>GET</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//    
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        try {
//            ServiceDAO dao = new ServiceDAO();
//            String idStr = request.getParameter("id");
//
//            // Lấy các giá trị từ request
//            String name = request.getParameter("serviceName");
//            String description = request.getParameter("description");
//            String priceStr = request.getParameter("price");
//            String statusStr = request.getParameter("status");
//            String serviceType = request.getParameter("serviceType");
//            String createdBy = request.getParameter("createdBy");
//            String lastUpdatedBy = request.getParameter("lastUpdatedBy");
//            String serviceImage = request.getParameter("serviceImage");
//
//            // Khởi tạo đối tượng Service
//            Service service = new Service();
//            service.setServiceName(name);
//            service.setDescription(description);
//            service.setPrice(new BigDecimal(priceStr));
//            service.setStatus("1".equals(statusStr)); // true nếu status = "1", false nếu khác
//            service.setServiceType(serviceType);
//            service.setCreatedBy(createdBy);
//            service.setLastUpdatedBy(lastUpdatedBy);
//            service.setServiceImage(serviceImage);
//
//            if (idStr == null || idStr.trim().isEmpty()) {
//                // Insert mới
//                dao.insert(service);
//            } else {
//                // Cập nhật
//                service.setServiceID(Integer.parseInt(idStr));
//                dao.update(service);
//            }
//
//            // Chuyển hướng về trang danh sách
//            response.sendRedirect("services");
//
//        } catch (SQLException e) {
//            throw new ServletException("SQL Error: " + e.getMessage(), e);
//        } catch (Exception e) {
//            Logger.getLogger(addService.class.getName()).log(Level.SEVERE, null, e);
//            throw new ServletException("Unexpected Error: " + e.getMessage(), e);
//        }
//    }
//    /**
//     * Handles the HTTP <code>POST</code> method.
//     *
//     * @param request servlet request
//     * @param response servlet response
//     * @throws ServletException if a servlet-specific error occurs
//     * @throws IOException if an I/O error occurs
//     */
//
//    /**
//     * Returns a short description of the servlet.
//     *
//     * @return a String containing servlet description
//     */
//}
