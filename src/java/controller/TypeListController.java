/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;


import DAO.RoomDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import model.Room;
import model.RoomType;
/**
 *
 * @author Arcueid
 */
@WebServlet(name="TypeListController", urlPatterns={"/TypeListController"})
public class TypeListController extends HttpServlet {
   
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
            out.println("<title>Servlet TypeListController</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TypeListController at " + request.getContextPath () + "</h1>");
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
    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RoomDAO dao = new RoomDAO();

        List<Room> list;
        List<RoomType> roomTypes;
        Room latestRoom;

        // Lấy danh sách loại phòng để hiển thị trong filter
        try {
            roomTypes = dao.getAllRoomTypes();
        } catch (SQLException e) {
            e.printStackTrace();
            roomTypes = null;
        }

        // Lấy phòng mới nhất
        latestRoom = dao.getLatestRoom();

        // Lọc theo typeId
        String typeParam = request.getParameter("typeId");

        if (typeParam != null && !typeParam.isEmpty()) {
            try {
                int typeId = Integer.parseInt(typeParam);
                list = dao.getRoomsByType(typeId);
            } catch (Exception e) {
                e.printStackTrace();
                try {
                    list = dao.getAllRooms(); // fallback nếu có lỗi
                } catch (SQLException ex) {
                    ex.printStackTrace();
                    list = null;
                }
            }
        } else {
            try {
                list = dao.getAllRooms();
            } catch (SQLException e) {
                e.printStackTrace();
                list = null;
            }
        }

        // Truyền dữ liệu sang JSP
        request.setAttribute("listR", list);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("latestRoom", latestRoom);
        request.getRequestDispatcher("rooms.jsp").forward(request, response);
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
