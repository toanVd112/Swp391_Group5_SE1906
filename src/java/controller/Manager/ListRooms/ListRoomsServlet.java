package controller.Manager.ListRooms;

import DAO.ManageRoomDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Room;
import model.RoomType;

@WebServlet(name = "ListRoomsServlet", urlPatterns = {"/ListRoomsServlet"})
public class ListRoomsServlet extends HttpServlet {

    private ManageRoomDAO roomDAO;

    @Override
    public void init() {
        roomDAO = new ManageRoomDAO();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException ignored) {
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                handleDeleteRoom(request, response);
            } else {
                handleListRooms(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            handleListRooms(request, response);
        }
    }

    private void handleListRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy tham số từ request
        Integer roomTypeId = parseIntOrNull(request.getParameter("roomTypeId"));
        String status = emptyToNull(request.getParameter("status"));
        String keyword = emptyToNull(request.getParameter("keyword"));
        Integer minFloor = parseIntOrNull(request.getParameter("minFloor"));
        Integer maxFloor = parseIntOrNull(request.getParameter("maxFloor"));
        Double minPrice = parseDoubleOrNull(request.getParameter("minPrice"));
        Double maxPrice = parseDoubleOrNull(request.getParameter("maxPrice"));
        Integer minGuests = parseIntOrNull(request.getParameter("minGuests"));
        Integer maxGuests = parseIntOrNull(request.getParameter("maxGuests"));
        String sortOrder = emptyToNull(request.getParameter("sort"));

        // Kiểm tra đầu vào
        String errorMessage = null;
        if (minFloor != null && minFloor < 0) {
            minFloor = null;
            errorMessage = "Tầng tối thiểu không được âm!";
        }
        if (maxFloor != null && maxFloor < 0) {
            maxFloor = null;
            errorMessage = "Tầng tối đa không được âm!";
        }
        if (minPrice != null && minPrice < 0) {
            minPrice = null;
            errorMessage = "Giá tối thiểu không được âm!";
        }
        if (maxPrice != null && maxPrice < 0) {
            maxPrice = null;
            errorMessage = "Giá tối đa không được âm!";
        }
        if (minGuests != null && minGuests < 0) {
            minGuests = null;
            errorMessage = "Số khách tối thiểu không được âm!";
        }
        if (maxGuests != null && maxGuests < 0) {
            maxGuests = null;
            errorMessage = "Số khách tối đa không được âm!";
        }
        if (minFloor != null && maxFloor != null && minFloor > maxFloor) {
            errorMessage = "Tầng tối thiểu không được lớn hơn tầng tối đa!";
            minFloor = null;
            maxFloor = null;
        }
        if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
            errorMessage = "Giá tối thiểu không được lớn hơn giá tối đa!";
            minPrice = null;
            maxPrice = null;
        }
        if (minGuests != null && maxGuests != null && minGuests > maxGuests) {
            errorMessage = "Số khách tối thiểu không được lớn hơn số khách tối đa!";
            minGuests = null;
            maxGuests = null;
        }

        // Xử lý phân trang
        int page = parseIntOrDefault(request.getParameter("page"), 1);
        int pageSize = parseIntOrDefault(request.getParameter("pageSize"), 5);

        if (page < 1) {
            page = 1;
        }
        if (pageSize < 5) {
            pageSize = 5;
        }
        if (pageSize > 50) {
            pageSize = 50;
        }

        int offset = (page - 1) * pageSize;

        try {
            // Lấy dữ liệu từ DAO
            List<RoomType> roomTypes = roomDAO.getAllRoomTypes();
            List<Room> rooms = roomDAO.getRoomsByPage(roomTypeId, status, keyword, minFloor, maxFloor, minPrice, maxPrice, minGuests, maxGuests, sortOrder, offset, pageSize);
            int totalRooms = roomDAO.countRooms(roomTypeId, status, keyword, minFloor, maxFloor, minPrice, maxPrice, minGuests, maxGuests);
            int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

            // Gán thuộc tính cho request
            request.setAttribute("roomTypes", roomTypes);
            request.setAttribute("rooms", rooms);

            request.setAttribute("f_type", roomTypeId);
            request.setAttribute("f_status", status);
            request.setAttribute("f_keyword", keyword);
            request.setAttribute("f_minFloor", minFloor);
            request.setAttribute("f_maxFloor", maxFloor);
            request.setAttribute("f_minPrice", minPrice);
            request.setAttribute("f_maxPrice", maxPrice);
            request.setAttribute("f_minGuests", minGuests);
            request.setAttribute("f_maxGuests", maxGuests);
            request.setAttribute("sort", sortOrder);

            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalRooms", totalRooms);
            request.setAttribute("pageSize", pageSize);

            int startRecord = offset + 1;
            int endRecord = Math.min(offset + pageSize, totalRooms);
            request.setAttribute("startRecord", startRecord);
            request.setAttribute("endRecord", endRecord);

            // Xử lý thông báo
            String successMessage = getSuccessMessage(request.getParameter("success"), request);
            if (successMessage != null) {
                request.setAttribute("successMessage", successMessage);
            }
            if (errorMessage != null) {
                request.setAttribute("errorMessage", errorMessage);
            } else {
                String errorParam = getErrorMessage(request.getParameter("error"));
                if (errorParam != null) {
                    request.setAttribute("errorMessage", errorParam);
                }
            }

            // Chuyển tiếp đến JSP
            request.getRequestDispatcher("Manager/manager.jsp?page=ListRooms.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Không thể tải danh sách phòng: " + e.getMessage());
            request.setAttribute("rooms", List.of());
            request.setAttribute("roomTypes", List.of());
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 0);
            request.setAttribute("totalRooms", 0);
            request.getRequestDispatcher("Manager/manager.jsp?page=ListRooms.jsp").forward(request, response);
        }
    }

    private void handleDeleteRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String roomIdStr = request.getParameter("roomId");

        if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=invalidId");
            return;
        }

        try {
            int roomId = Integer.parseInt(roomIdStr);
            Room room = roomDAO.getRoomById(roomId);
            if (room == null) {
                response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=notFound");
                return;
            }
            if ("Occupied".equals(room.getStatus())) {
                response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=occupied");
                return;
            }
            boolean success = roomDAO.deleteRoom(roomId);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?success=delete&roomNumber=" + room.getRoomnumber());
            } else {
                response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=deleteFailed");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=invalidId");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=system");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        try {
            if ("delete".equals(action)) {
                handleDeleteRoom(request, response);
            } else if ("bulkDelete".equals(action)) {
                handleBulkDelete(request, response);
            } else {
                handleListRooms(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi xử lý: " + e.getMessage());
            handleListRooms(request, response);
        }
    }

    private void handleBulkDelete(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String[] roomIds = request.getParameterValues("selectedRooms");

        if (roomIds == null || roomIds.length == 0) {
            response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=noSelection");
            return;
        }

        int deletedCount = 0;
        int failedCount = 0;

        try {
            for (String roomIdStr : roomIds) {
                try {
                    int roomId = Integer.parseInt(roomIdStr);
                    Room room = roomDAO.getRoomById(roomId);
                    if (room != null && !"Occupied".equals(room.getStatus())) {
                        if (roomDAO.deleteRoom(roomId)) {
                            deletedCount++;
                        } else {
                            failedCount++;
                        }
                    } else {
                        failedCount++;
                    }
                } catch (NumberFormatException e) {
                    failedCount++;
                }
            }

            String result = "bulkDelete&deleted=" + deletedCount + "&failed=" + failedCount;
            response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?success=" + result);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ListRoomsServlet?error=bulkDeleteFailed");
        }
    }

    private Integer parseIntOrNull(String s) {
        try {
            return (s == null || s.isBlank()) ? null : Integer.parseInt(s);
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Double parseDoubleOrNull(String s) {
        try {
            return (s == null || s.isBlank()) ? null : Double.parseDouble(s);
        } catch (NumberFormatException e) {
            return null;
        }
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

    private String getSuccessMessage(String success, HttpServletRequest request) {
        if (success == null) {
            return null;
        }

        switch (success) {
            case "add":
                return "Thêm phòng thành công!";
            case "edit":
                return "Cập nhật phòng thành công!";
            case "delete":
                String roomNumber = request.getParameter("roomNumber");
                return "Xóa phòng " + (roomNumber != null ? roomNumber : "") + " thành công!";
            case "bulkDelete":
                String deleted = request.getParameter("deleted");
                String failed = request.getParameter("failed");
                return String.format("Xóa thành công %s phòng. %s phòng không thể xóa.",
                        deleted != null ? deleted : "0",
                        failed != null ? failed : "0");
            default:
                return null;
        }
    }

    private String getErrorMessage(String error) {
        if (error == null) {
            return null;
        }

        switch (error) {
            case "invalidId":
                return "ID phòng không hợp lệ!";
            case "notFound":
                return "Không tìm thấy phòng!";
            case "occupied":
                return "Không thể xóa phòng đang được thuê!";
            case "deleteFailed":
                return "Xóa phòng thất bại!";
            case "noSelection":
                return "Vui lòng chọn ít nhất một phòng để xóa!";
            case "bulkDeleteFailed":
                return "Xóa nhiều phòng thất bại!";
            case "system":
                return "Lỗi hệ thống, vui lòng thử lại!";
            default:
                return "Có lỗi xảy ra!";
        }
    }

    @Override
    public String getServletInfo() {
        return "List Rooms Servlet - handles room listing with advanced filtering and management";
    }
}
