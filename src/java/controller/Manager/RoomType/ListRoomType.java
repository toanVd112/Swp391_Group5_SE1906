/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.Manager.RoomType;

import DAO.RoomTypeDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.RoomType;

/**
 *
 * @author Arcueid
 */
@WebServlet(name = "RoomTypeListServlet", urlPatterns = {"/RoomTypeListServlet"})
public class ListRoomType extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
   private static final int PAGE_SIZE = 10;
    private RoomTypeDAO roomTypeDAO;

    @Override
    public void init() {
        roomTypeDAO = new RoomTypeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        // Nhận tham số lọc và sắp xếp
        String keyword = request.getParameter("keyword");
        String sortBy = request.getParameter("sortBy");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");

        // Giá trị mặc định nếu không nhập
        double minPrice = (minPriceStr != null && !minPriceStr.isEmpty()) ? Double.parseDouble(minPriceStr) : 0;
        double maxPrice = (maxPriceStr != null && !maxPriceStr.isEmpty()) ? Double.parseDouble(maxPriceStr) : Double.MAX_VALUE;

        // Phân trang
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                currentPage = Integer.parseInt(pageParam);
            } catch (NumberFormatException ignored) {}
        }
        int offset = (currentPage - 1) * PAGE_SIZE;

        // Truy vấn DAO
        List<RoomType> roomTypes = roomTypeDAO.searchRoomTypes(keyword, minPrice, maxPrice, sortBy, offset, PAGE_SIZE);
        int totalRoomTypes = roomTypeDAO.countRoomTypes(keyword, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) totalRoomTypes / PAGE_SIZE);

        // Gửi dữ liệu sang JSP
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("f_keyword", keyword);
        request.setAttribute("f_minPrice", minPriceStr);
        request.setAttribute("f_maxPrice", maxPriceStr);
        request.setAttribute("f_sortBy", sortBy);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Forward đến JSP
        request.getRequestDispatcher("Manager/manager.jsp?page=ListRoomType.jsp").forward(request, response);
    }
}
