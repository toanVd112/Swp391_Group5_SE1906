package controller.Manager.ListRooms;

import DAO.ManageRoomDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Room;
import model.RoomType;

@WebServlet(name = "AddEditRoomServlet", urlPatterns = {"/AddEditRoomServlet"})
public class AddEditRoomServlet extends HttpServlet {

    private ManageRoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new ManageRoomDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String roomIdStr = request.getParameter("roomId");

        try {
            // Load room types for dropdown
            List<RoomType> roomTypes = roomDAO.getAllRoomTypes();
            request.setAttribute("roomTypes", roomTypes);

            // If editing, load room data
            if ("edit".equals(action) && roomIdStr != null) {
                try {
                    int roomId = Integer.parseInt(roomIdStr);
                    Room room = roomDAO.getRoomById(roomId);

                    if (room != null) {
                        request.setAttribute("room", room);
                    } else {
                        request.setAttribute("errorMessage", "Không tìm thấy phòng với ID: " + roomId);
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("errorMessage", "ID phòng không hợp lệ");
                }
            }

            // Thay đổi này: sử dụng layout system
            request.getRequestDispatcher("Manager/manager.jsp?page=AddEditRoom.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            // Thay đổi này: sử dụng layout system
            request.getRequestDispatcher("Manager/manager.jsp?page=AddEditRoom.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set encoding for Vietnamese characters
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                handleAddRoom(request, response);
            } else if ("edit".equals(action)) {
                handleEditRoom(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xử lý: " + e.getMessage());
            doGet(request, response); // Reload form with error
        }
    }

    private void handleAddRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomNumber = request.getParameter("roomNumber");
        String floorStr = request.getParameter("floor");
        String roomTypeIdStr = request.getParameter("roomTypeId");
        String status = request.getParameter("status");

        List<String> errors = validateRoomData(roomNumber, floorStr, roomTypeIdStr, status, null);

        if (!errors.isEmpty()) {
            request.setAttribute("errorMessage", String.join(", ", errors));
            doGet(request, response);
            return;
        }

        try {
            int floor = Integer.parseInt(floorStr);
            int roomTypeId = Integer.parseInt(roomTypeIdStr);

            if (roomDAO.isRoomNumberExists(roomNumber, null)) {
                request.setAttribute("errorMessage", "Số phòng " + roomNumber + " đã tồn tại");
                doGet(request, response);
                return;
            }

            boolean success = roomDAO.addRoom(roomNumber, floor, roomTypeId, status);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?success=add");
            } else {
                request.setAttribute("errorMessage", "Không thể thêm phòng. Vui lòng thử lại.");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Dữ liệu số không hợp lệ");
            doGet(request, response);
        }
    }

    private void handleEditRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomIdStr = request.getParameter("roomId");
        String roomNumber = request.getParameter("roomNumber");
        String floorStr = request.getParameter("floor");
        String roomTypeIdStr = request.getParameter("roomTypeId");
        String status = request.getParameter("status");

        List<String> errors = validateRoomData(roomNumber, floorStr, roomTypeIdStr, status, roomIdStr);

        if (!errors.isEmpty()) {
            request.setAttribute("errorMessage", String.join(", ", errors));
            doGet(request, response);
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdStr);
            int floor = Integer.parseInt(floorStr);
            int roomTypeId = Integer.parseInt(roomTypeIdStr);

            if (roomDAO.isRoomNumberExists(roomNumber, roomId)) {
                request.setAttribute("errorMessage", "Số phòng " + roomNumber + " đã tồn tại");
                doGet(request, response);
                return;
            }

            boolean success = roomDAO.updateRoom(roomId, roomNumber, floor, roomTypeId, status);

            if (success) {
                response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?success=edit");
            } else {
                request.setAttribute("errorMessage", "Không thể cập nhật phòng. Vui lòng thử lại.");
                doGet(request, response);
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Dữ liệu số không hợp lệ");
            doGet(request, response);
        }
    }

    private List<String> validateRoomData(String roomNumber, String floorStr, String roomTypeIdStr,
            String status, String roomIdStr) {
        List<String> errors = new ArrayList<>();

        // Validate room number
        if (roomNumber == null || roomNumber.trim().isEmpty()) {
            errors.add("Số phòng không được để trống");
        }

        // Validate floor
        if (floorStr == null || floorStr.trim().isEmpty()) {
            errors.add("Số tầng không được để trống");
        } else {
            try {
                int floor = Integer.parseInt(floorStr);
                if (floor < 1 || floor > 50) {
                    errors.add("Số tầng phải từ 1 đến 50");
                }
            } catch (NumberFormatException e) {
                errors.add("Số tầng không hợp lệ");
            }
        }

        // Validate room type
        if (roomTypeIdStr == null || roomTypeIdStr.trim().isEmpty()) {
            errors.add("Vui lòng chọn loại phòng");
        }

        // Validate status
        List<String> validStatuses = Arrays.asList("Available", "Occupied", "Maintenance", "Dirty");
        if (status == null || !validStatuses.contains(status)) {
            errors.add("Trạng thái phòng không hợp lệ");
        }

        // Validate room ID for edit action
        if (roomIdStr != null) {
            try {
                Integer.parseInt(roomIdStr);
            } catch (NumberFormatException e) {
                errors.add("ID phòng không hợp lệ");
            }
        }

        return errors;
    }

    @Override
    public String getServletInfo() {
        return "Servlet for adding and editing rooms";
    }
}
