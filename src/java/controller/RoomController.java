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
@WebServlet(name="RoomController", urlPatterns={"/roomlist"})
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

        String typeParam = request.getParameter("typeId");
        String floorParam = request.getParameter("floor");

        Integer typeId = (typeParam != null && !typeParam.isEmpty()) ? Integer.valueOf(typeParam) : null;
        Integer floor = (floorParam != null && !floorParam.isEmpty()) ? Integer.valueOf(floorParam) : null;

        List<Room> filteredRooms = dao.filterRooms(floor, typeId);

        // Xử lý phân trang
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

        int totalRooms = filteredRooms.size();
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);
        int start = (page - 1) * pageSize;
        int end = Math.min(start + pageSize, totalRooms);

        List<Room> paginatedRooms = filteredRooms.subList(start, end);

        // Truyền dữ liệu sang JSP
        request.setAttribute("listR", paginatedRooms);
        request.setAttribute("roomTypes", roomTypes);
        request.setAttribute("floors", floors);
        request.setAttribute("latestRoom", latestRoom);
        request.setAttribute("selectedType", typeId);
        request.setAttribute("selectedFloor", floor);
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