/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Manager.ListRooms;

import DAO.ManageRoomDAO;
import DAO.RoomDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.nio.charset.StandardCharsets;
import model.Room;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author MyPC
 */
@WebServlet(name = "DeleteRoom", urlPatterns = {"/deleteRoom"})
public class DeleteRoom extends HttpServlet {

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
            out.println("<title>Servlet DeleteRoom</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet DeleteRoom at " + request.getContextPath() + "</h1>");
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
    private static final String STATUS_OCCUPIED = "Occupied";
    private final ManageRoomDAO roomDAO = new ManageRoomDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String format = request.getParameter("format");
        boolean isJson = "json".equals(format);

        if (isJson) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            handleJsonResponse(request, response);
        } else {
            handleRedirectResponse(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Chuyển hướng POST sang GET để đơn giản hóa
    }

    private void handleJsonResponse(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Map<String, Object> responseData = new HashMap<>();
        try {
            String roomIdStr = request.getParameter("roomId");

            if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                responseData.put("success", false);
                responseData.put("message", "ID phòng không hợp lệ!");

                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            Room room = roomDAO.getRoomById(roomId);

            if (room == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                responseData.put("success", false);
                responseData.put("message", "Không tìm thấy phòng!");

                return;
            }

            if (STATUS_OCCUPIED.equalsIgnoreCase(room.getStatus())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                responseData.put("success", false);
                responseData.put("message", "Không thể xóa phòng đang được thuê!");

                return;
            }

            boolean success = roomDAO.deleteRoom(roomId);
            if (success) {
                responseData.put("success", true);
                responseData.put("message", "Xóa phòng " + room.getRoomnumber() + " thành công!");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                responseData.put("success", false);
                responseData.put("message", "Xóa phòng thất bại!");
            }

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            responseData.put("success", false);
            responseData.put("message", "ID phòng không hợp lệ!");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            responseData.put("success", false);
            responseData.put("message", "Lỗi hệ thống, vui lòng thử lại!");

        }
    }

    private void handleRedirectResponse(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            String roomIdStr = request.getParameter("roomId");

            if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=invalidId");
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            Room room = roomDAO.getRoomById(roomId);

            if (room == null) {
                response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=notFound");
                return;
            }

            if (STATUS_OCCUPIED.equalsIgnoreCase(room.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=occupied");
                return;
            }

            boolean success = roomDAO.deleteRoom(roomId);
            if (success) {
                String encodedRoomNumber = URLEncoder.encode(room.getRoomnumber(), StandardCharsets.UTF_8.name());
                response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?success=delete&roomNumber=" + encodedRoomNumber);
            } else {
                response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=deleteFailed");
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=invalidId");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=system");
        }
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
