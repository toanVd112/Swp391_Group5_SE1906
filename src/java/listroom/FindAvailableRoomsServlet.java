/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package listroom;

import DAO.RoomTypeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import model.RoomSuggestion;
import model.RoomType;
import java.text.SimpleDateFormat;
import java.util.Comparator;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

/**
 *
 * @author Admin
 */
@WebServlet(name = "FindAvailableRoomsServlet", urlPatterns = {"/FindAvailableRoomsServlet"})
public class FindAvailableRoomsServlet extends HttpServlet {

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
            out.println("<title>Servlet FindAvailableRoomsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FindAvailableRoomsServlet at " + request.getContextPath() + "</h1>");
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // 1. Lấy input từ request
            SearchParams params = getSearchParams(request);

            // 2. Truy vấn DB để lấy loại phòng còn trống theo bộ lọc từng phòng
            RoomTypeDAO dao = new RoomTypeDAO();
            java.sql.Date checkin = (java.sql.Date) params.checkin;
            java.sql.Date checkout = (java.sql.Date) params.checkout;

            List<RoomType> availableRoomTypes = dao.getAvailableRoomTypes(
                    checkin,
                    checkout,
                    params.roomTypeFilter,
                    params.minGuestsPerRoom,
                    params.maxPrice
            );

            List<RoomType> allRoomTypes = dao.getAllRoomTypes(); // cho dropdown filter

            // 3. Tính toán tổ hợp phòng phù hợp với số người
            List<List<RoomSuggestion>> combos = generateSuggestions(availableRoomTypes, params.guests);

            // 4. Lọc tổ hợp theo tổng giá và tổng sức chứa
            if (params.maxPrice != null || params.minTotalGuests != null) {
                combos = combos.stream()
                        .filter(combo -> {
                            double totalPrice = combo.stream()
                                    .mapToDouble(s -> s.getQuantity() * s.getRoomType().getBasePrice())
                                    .sum();

                            int totalGuests = combo.stream()
                                    .mapToInt(s -> s.getQuantity() * s.getRoomType().getMaxGuests())
                                    .sum();

                            return (params.maxPrice == null || totalPrice <= params.maxPrice)
                                    && (params.minTotalGuests == null || totalGuests >= params.minTotalGuests);
                        })
                        .limit(10)
                        .collect(Collectors.toList());
            }

            // 5. Gán dữ liệu cho JSP
            request.setAttribute("checkin", params.checkinStr);
            request.setAttribute("checkout", params.checkoutStr);
            request.setAttribute("guests", params.guests);

            request.setAttribute("availableRooms", availableRoomTypes);
            request.setAttribute("roomTypes", allRoomTypes);
            request.setAttribute("suggestions", combos);

            // Nếu bạn dùng phân trang sau này
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);

            request.getRequestDispatcher("roomlist.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi xử lý: " + e.getMessage());
        }
    }

    private List<List<RoomSuggestion>> generateSuggestions(List<RoomType> roomTypes, int totalGuests) {
        Set<String> seen = new HashSet<>();
        List<List<RoomSuggestion>> result = new ArrayList<>();

        // ✅ Bước 1: Ưu tiên gợi ý 1 phòng nếu đủ
        for (RoomType rt : roomTypes) {
            if (rt.getMaxGuests() >= totalGuests && rt.getAvailableRooms() >= 1) {
                List<RoomSuggestion> single = List.of(new RoomSuggestion(rt, 1));
                String key = "1x" + rt.getName();
                if (seen.add(key)) {
                    result.add(single);
                }
            }
        }

// Nếu đã có phòng đủ 1 phòng, không sinh thêm tổ hợp nhiều phòng nữa
        if (!result.isEmpty()) {
            return result;
        }

        // ✅ Bước 2: Sinh tổ hợp nhiều phòng
        backtrackSmart(roomTypes, 0, totalGuests, new ArrayList<>(), result, seen);

        // ✅ Bước 3: Sắp xếp ưu tiên ít phòng và giá rẻ nhất
        return result.stream()
                .sorted(Comparator
                        .comparingInt((List<RoomSuggestion> combo)
                                -> combo.stream().mapToInt(RoomSuggestion::getQuantity).sum()) // tổng số phòng
                        .thenComparingDouble(combo
                                -> combo.stream().mapToDouble(s -> s.getQuantity() * s.getRoomType().getBasePrice()).sum()) // tổng giá
                )
                .limit(10) // giới hạn gợi ý hiển thị
                .collect(Collectors.toList());
    }

    private void backtrackSmart(List<RoomType> roomTypes, int index, int requiredGuests,
            List<RoomSuggestion> current, List<List<RoomSuggestion>> result, Set<String> seen) {

        int totalGuests = current.stream()
                .mapToInt(s -> s.getQuantity() * s.getRoomType().getMaxGuests())
                .sum();

        int totalRooms = current.stream()
                .mapToInt(RoomSuggestion::getQuantity)
                .sum();

        // ✅ Nếu đã đủ sức chứa
        if (totalGuests >= requiredGuests) {
            // Bỏ qua nếu sức chứa vượt quá nhiều (giới hạn dư 50%)
            if (totalGuests > requiredGuests * 1.5) {
                return;
            }

            // Khóa tổ hợp theo tên phòng
            String key = current.stream()
                    .sorted(Comparator.comparing(s -> s.getRoomType().getName()))
                    .map(s -> s.getQuantity() + "x" + s.getRoomType().getName())
                    .collect(Collectors.joining("+"));

            if (seen.add(key)) {
                result.add(new ArrayList<>(current));
            }
            return;
        }

        if (index >= roomTypes.size()) {
            return;
        }

        RoomType rt = roomTypes.get(index);
        int maxQty = rt.getAvailableRooms();

        for (int qty = 1; qty <= maxQty; qty++) {
            current.add(new RoomSuggestion(rt, qty));
            backtrackSmart(roomTypes, index + 1, requiredGuests, current, result, seen);
            current.remove(current.size() - 1);
        }

        // Thử nhánh không chọn loại phòng này
        backtrackSmart(roomTypes, index + 1, requiredGuests, current, result, seen);
    }

    private SearchParams getSearchParams(HttpServletRequest request) {
        String checkinStr = request.getParameter("checkin");
        String checkoutStr = request.getParameter("checkout");
        String guestsStr = request.getParameter("guests");

        String roomTypeFilter = request.getParameter("roomType");
        String minGuestsPerRoomStr = request.getParameter("minGuestsPerRoom");
        String minTotalGuestsStr = request.getParameter("minTotalGuests");
        String maxPriceStr = request.getParameter("maxPrice");

        java.sql.Date checkin = java.sql.Date.valueOf(checkinStr);
        java.sql.Date checkout = java.sql.Date.valueOf(checkoutStr);
        int guests = Integer.parseInt(guestsStr);

        Integer minGuestsPerRoom = (minGuestsPerRoomStr != null && !minGuestsPerRoomStr.isBlank())
                ? Integer.parseInt(minGuestsPerRoomStr)
                : null;

        Integer minTotalGuests = (minTotalGuestsStr != null && !minTotalGuestsStr.isBlank())
                ? Integer.parseInt(minTotalGuestsStr)
                : null;

        Double maxPrice = (maxPriceStr != null && !maxPriceStr.isBlank())
                ? Double.parseDouble(maxPriceStr)
                : null;

        return new SearchParams(
                checkinStr, checkoutStr,
                checkin, checkout,
                guests,
                roomTypeFilter, minGuestsPerRoom, minTotalGuests, maxPrice
        );
    }

    // Class phụ trợ để gom các input
    private static class SearchParams {

        String checkinStr, checkoutStr, roomTypeFilter;
        Date checkin, checkout;
        int guests;

        Integer minGuestsPerRoom;     // lọc trong DAO
        Integer minTotalGuests;       // lọc sau khi generate tổ hợp
        Double maxPrice;

        public SearchParams(String checkinStr, String checkoutStr, Date checkin, Date checkout,
                int guests, String roomTypeFilter,
                Integer minGuestsPerRoom, Integer minTotalGuests, Double maxPrice) {
            this.checkinStr = checkinStr;
            this.checkoutStr = checkoutStr;
            this.checkin = checkin;
            this.checkout = checkout;
            this.guests = guests;
            this.roomTypeFilter = roomTypeFilter;
            this.minGuestsPerRoom = minGuestsPerRoom;
            this.minTotalGuests = minTotalGuests;
            this.maxPrice = maxPrice;
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
