/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Manager.ListRooms;

import DAO.ManageRoomList;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Account;
import model.Room2;
import model.RoomType2;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ListRoomsServlet1", urlPatterns = {"/ListRoomsServlet1"})
public class ListRoomsServlet1 extends HttpServlet {

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
            out.println("<title>Servlet ListRoomsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListRoomsServlet at " + request.getContextPath() + "</h1>");
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
    public void init() {
        ManageRoomList dao = new ManageRoomList();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ignored) {
        }
    }

    @Override

    protected void doGet(HttpServletRequest req, HttpServletResponse response)
            throws ServletException, IOException {
        Account account = (Account) req.getSession().getAttribute("account");
        if (account == null || !"Receptionist".equals(account.getRole())) {
            response.sendRedirect(req.getContextPath() + "/login_2.jsp");
            return;
        }

        ManageRoomList dao = new ManageRoomList();

        Integer roomTypeId = parseIntOrNull(req.getParameter("roomTypeId"));
        String status = emptyToNull(req.getParameter("status"));
        String keyword = emptyToNull(req.getParameter("keyword"));
        Integer minFloor = parseIntOrNull(req.getParameter("minFloor"));
        Integer maxFloor = parseIntOrNull(req.getParameter("maxFloor"));
        Double minPrice = parseDoubleOrNull(req.getParameter("minPrice"));
        Double maxPrice = parseDoubleOrNull(req.getParameter("maxPrice"));

        int page = parseIntOrDefault(req.getParameter("page"), 1);
        int pageSize = 5;
        int offset = (page - 1) * pageSize;

        try {
            List<RoomType2> roomTypes = dao.getRoomTypes();
            int totalRooms = dao.countRooms(roomTypeId, status, keyword, minFloor, maxFloor, minPrice, maxPrice);
            int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

            List<Room2> rooms = dao.searchRoomsPaginated(
                    roomTypeId, status, keyword, minFloor, maxFloor, minPrice, maxPrice, offset, pageSize
            );

            // Dữ liệu
            req.setAttribute("roomTypes", roomTypes);
            req.setAttribute("rooms", rooms);

            // Filter giữ nguyên
            req.setAttribute("f_type", roomTypeId);
            req.setAttribute("f_status", status);
            req.setAttribute("f_keyword", keyword);
            req.setAttribute("f_minFloor", minFloor);
            req.setAttribute("f_maxFloor", maxFloor);
            req.setAttribute("f_minPrice", minPrice);
            req.setAttribute("f_maxPrice", maxPrice);

            // Phân trang
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);

            req.getRequestDispatcher("Receptionist/ListRooms1.jsp").forward(req, response);
        } catch (Exception e) {
            throw new ServletException(e);
        }
    }

    private Integer parseIntOrNull(String s) {
        return (s == null || s.isBlank()) ? null : Integer.valueOf(s);
    }

    private Double parseDoubleOrNull(String s) {
        return (s == null || s.isBlank()) ? null : Double.valueOf(s);
    }

    private String emptyToNull(String s) {
        return (s == null || s.isBlank()) ? null : s;
    }

    private int parseIntOrDefault(String s, int def) {
        try {
            return (s == null || s.isBlank()) ? def : Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return def;
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
