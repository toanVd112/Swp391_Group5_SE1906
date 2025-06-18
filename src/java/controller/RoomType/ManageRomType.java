/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.RoomType;

import DAO.RoomTypeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.RoomType;

/**
 *
 * @author Arcueid
 */
@WebServlet(name="ManageRomType", urlPatterns={"/ManageRomType"})
public class ManageRomType extends HttpServlet {
   
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
            out.println("<title>Servlet ManageRomType</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ManageRomType at " + request.getContextPath () + "</h1>");
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
    private RoomTypeDAO roomTypeDAO; 

    @Override
    public void init() {
        roomTypeDAO = new RoomTypeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            try {
                int id = Integer.parseInt(idParam);
                RoomType roomType = roomTypeDAO.getRoomTypeById(id);
                request.setAttribute("roomType", roomType);
            } catch (NumberFormatException e) {
            }
        }
        request.getRequestDispatcher("room-type-form.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String idRaw = request.getParameter("roomTypeID");
        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String basePriceRaw = request.getParameter("basePrice");
        String imageUrl = request.getParameter("imageUrl");
        String roomDetail = request.getParameter("roomDetail");

        try {
            double basePrice = Double.parseDouble(basePriceRaw);

            RoomType type = new RoomType();
            type.setName(name);
            type.setDescription(description);
            type.setBasePrice(basePrice);
            type.setImageUrl(imageUrl);
            type.setRoomDetail(roomDetail);

            if (idRaw == null || idRaw.isEmpty()) {
                roomTypeDAO.insertRoomType(type);
            } else {
                int id = Integer.parseInt(idRaw);
                type.setRoomTypeID(id);
                roomTypeDAO.updateRoomType(type);
            }

            response.sendRedirect("roomtypes.jsp");
        } catch (IOException | NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Lỗi xử lý dữ liệu loại phòng");
        }
    }

    @Override
    public String getServletInfo() {
        return "Manage room types (add/edit)";
    }
}
