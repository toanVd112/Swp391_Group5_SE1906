package controller.Manager.RoomType;

import DAO.RoomTypeDAO;
import java.io.IOException;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;
import model.RoomType;

/**
 *
 * @author Arcueid
 */
@WebServlet(name = "RoomTypeListServlet", urlPatterns = {"/RoomTypeListServlet"})
public class ListRoomType extends HttpServlet {
    private static final int PAGE_SIZE = 10;
    private static final Logger LOGGER = Logger.getLogger(ListRoomType.class.getName());
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
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                LOGGER.warning("Số trang không hợp lệ: " + pageParam);
                currentPage = 1;
            }
        }
        int offset = (currentPage - 1) * PAGE_SIZE;

        // Truy vấn DAO
        List<RoomType> roomTypes = null;
        int totalRoomTypes = 0;
        try {
            roomTypes = roomTypeDAO.searchRoomTypes(keyword, minPrice, maxPrice, sortBy, offset, PAGE_SIZE);
            totalRoomTypes = roomTypeDAO.countRoomTypes(keyword, minPrice, maxPrice);
        } catch (SQLException e) {
            LOGGER.severe("Lỗi khi truy vấn danh sách loại phòng: " + e.getMessage());
            request.setAttribute("error", "Lỗi khi tải danh sách loại phòng");
        }

        int totalPages = (totalRoomTypes > 0) ? (int) Math.ceil((double) totalRoomTypes / PAGE_SIZE) : 1;
        if (currentPage > totalPages) currentPage = totalPages;

        // Gửi dữ liệu sang JSP
        request.setAttribute("roomTypes", roomTypes != null ? roomTypes : new ArrayList<>());
        request.setAttribute("f_keyword", keyword);
        request.setAttribute("f_minPrice", minPriceStr);
        request.setAttribute("f_maxPrice", maxPriceStr);
        request.setAttribute("f_sortBy", sortBy);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);

        // Forward đến JSP
        request.getRequestDispatcher("Manager/manager.jsp?page=ListRoomType.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng POST về GET để giữ logic nhất quán
        doGet(request, response);
    }
}