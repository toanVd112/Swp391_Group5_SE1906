/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package CartRooms;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author Admin
 */
@WebServlet(name = "addToGuestCart", urlPatterns = {"/addToGuestCart"})
public class addToGuestCart extends HttpServlet {

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
           response.sendRedirect("Home");
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
      
         response.sendRedirect("Home");
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

        HttpSession session = request.getSession();
        session.setMaxInactiveInterval(2 * 60 * 60); // 2 tiếng

        List<Map<String, String>> cart = (List<Map<String, String>>) session.getAttribute("guestCart");
        if (cart == null) {
            cart = new ArrayList<>();
        }

        String roomTypeId = request.getParameter("roomTypeId");
        boolean exists = cart.stream().anyMatch(r -> r.get("roomTypeId").equals(roomTypeId));
        if (!exists) {
            Map<String, String> item = new HashMap<>();
            item.put("roomTypeId", roomTypeId);
            item.put("roomName", request.getParameter("roomName"));
            item.put("basePrice", request.getParameter("basePrice"));
            item.put("imageUrl", request.getParameter("imageUrl"));
            item.put("maxguest", request.getParameter("maxguest"));
            cart.add(item);
        }

        session.setAttribute("guestCart", cart);
        response.sendRedirect("myrooms_db.jsp"); // hoặc trang hiện tại
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
