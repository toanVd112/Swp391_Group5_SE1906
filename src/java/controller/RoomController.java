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
import model.Room;
import model.RoomType;

/**
 *
 * @author Arcueid
 */
@WebServlet(name = "RoomController", urlPatterns = {"/roomlist"})
public class RoomController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        RoomDAO dao = new RoomDAO();
        List<RoomType> roomTypes;
        List<Integer> floors;
        Room latestRoom;

        try {
            roomTypes = dao.getAllRoomTypes();
            floors = dao.getAllFloors();
            latestRoom = dao.getLatestRoom();
        } catch (SQLException e) {
            roomTypes = null;
            floors = null;
            latestRoom = null;
        }

        // Lấy parameter lọc và sắp xếp
        String typeParam = request.getParameter("typeId");
        String floorParam = request.getParameter("floor");
        String sort = request.getParameter("sort");
        if (sort == null || sort.isEmpty()) {
            sort = "floor-asc"; // Mặc định sắp xếp theo tầng tăng dần
        }

        Integer typeId = (typeParam != null && !typeParam.isEmpty()) ? Integer.valueOf(typeParam) : null;
        Integer floor = (floorParam != null && !floorParam.isEmpty()) ? Integer.valueOf(floorParam) : null;

        // Phân trang
        int pageSize = 12;
        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * pageSize;

        // Lấy dữ liệu phân trang từ DB
        List<Room> paginatedRooms = dao.getRooms(floor, typeId, sort, offset, pageSize);
        int totalRooms = dao.countRoomsByFilter(floor, typeId);
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

        // Truyền dữ liệu sang JSP
        request.setAttribute("listR", paginatedRooms);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("floors", floors);
        request.setAttribute("latestRoom", latestRoom);
        request.setAttribute("selectedType", typeId);
        request.setAttribute("selectedFloor", floor);
        request.setAttribute("sort", sort);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("rooms.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "FilterRoomController handles room filtering based on type and floor.";
    }
}
