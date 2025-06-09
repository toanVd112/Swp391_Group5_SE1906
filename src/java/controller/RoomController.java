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
            if (latestRoom != null && (latestRoom.getRoomImage() == null || latestRoom.getRoomImage().trim().isEmpty())) {
                latestRoom.setRoomImage(latestRoom.getRoomType().getImageUrl());
            }
        } catch (SQLException e) {
            roomTypes = null;
            floors = null;
            latestRoom = null;
        }

        // Lấy parameter lọc
        String typeParam = request.getParameter("typeId");
        String floorParam = request.getParameter("floor");
        String sort = request.getParameter("sort");

        Integer typeId = (typeParam != null && !typeParam.isEmpty()) ? Integer.valueOf(typeParam) : null;
        Integer floor = (floorParam != null && !floorParam.isEmpty()) ? Integer.valueOf(floorParam) : null;

        // Phân loại sắp xếp
        String sortPrice = null;
        String sortFloor = null;
        if (sort != null) {
            if (sort.equals("asc") || sort.equals("desc")) {
                sortPrice = sort;
            } else if (sort.equals("floor-asc")) {
                sortFloor = "asc";
            } else if (sort.equals("floor-desc")) {
                sortFloor = "desc";
            }
        }

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

        // Truy vấn danh sách phòng
        List<Room> paginatedRooms = dao.getRooms(floor, typeId, sortFloor, sortPrice, offset, pageSize);
        for (Room r : paginatedRooms) {
            if (r.getRoomImage() == null || r.getRoomImage().trim().isEmpty()) {
                // Gán ảnh loại phòng làm mặc định nếu phòng không có ảnh
                r.setRoomImage(r.getRoomType().getImageUrl());
            }
        }
        int totalRooms = dao.countRoomsByFilter(floor, typeId);
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

        // Truyền dữ liệu sang JSP
        request.setAttribute("listR", paginatedRooms);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("floors", floors);
        request.setAttribute("latestRoom", latestRoom);
        request.setAttribute("selectedType", typeId);
        request.setAttribute("selectedFloor", floor);
        request.setAttribute("sort", sort); // dùng cho phần active
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
