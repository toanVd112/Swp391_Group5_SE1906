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
                    null, null, null
            );

            List<RoomType> allRoomTypes = dao.getAllRoomTypes(); // cho dropdown filter

            // 3. Tính toán tổ hợp phòng phù hợp với số người
            List<List<RoomSuggestion>> combos = generateSuggestions(availableRoomTypes, params.guests, params.roomTypeFilter);
            if (params.guests <= 2) {  // hoặc chỉ cần: if (params.guests == 1)
                // loại bỏ các combo chứa phòng quá lớn
                combos = combos.stream()
                        .filter(combo -> combo.stream()
                        .noneMatch(s -> s.getRoomType().getMaxGuests() > params.guests * 1.5))
                        .collect(Collectors.toList());
            }

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

                            boolean priceOk = params.maxPrice == null || totalPrice <= params.maxPrice;
                            boolean totalGuestsOk = params.minTotalGuests == null || totalGuests >= params.minTotalGuests;

                            boolean roomTooBig = combo.size() == 1
                                    && combo.stream().mapToInt(s -> s.getRoomType().getMaxGuests()).sum() > params.guests * 1.5;

                            // ✅ Sửa lại comboTooBig cho đúng yêu cầu
                            boolean comboTooBig = totalGuests > params.guests + 2;

                            return priceOk && totalGuestsOk && !roomTooBig && !comboTooBig;
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
            boolean noSuggestions = combos == null || combos.isEmpty();
            request.setAttribute("noSuggestions", noSuggestions);

            // Nếu bạn dùng phân trang sau này
            request.setAttribute("currentPage", 1);
            request.setAttribute("totalPages", 1);

            request.getRequestDispatcher("roomlist.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("roomlist.jsp").forward(request, response);
        }
    }

    private List<List<RoomSuggestion>> generateSuggestions(List<RoomType> roomTypes, int totalGuests, String requiredRoomTypeName) {
        Set<String> seen = new HashSet<>();
        List<List<RoomSuggestion>> result = new ArrayList<>();

        // ✅ BƯỚC 0: Ưu tiên tổ hợp chỉ dùng 1 loại phòng (nếu đủ)
        for (RoomType rt : roomTypes) {
            int maxGuestPerRoom = rt.getMaxGuests();
            int maxQty = rt.getAvailableRooms();

            // Tính số phòng tối thiểu cần để đủ chỗ cho totalGuests
            int neededRooms = (int) Math.ceil((double) totalGuests / maxGuestPerRoom);

            if (neededRooms <= maxQty) {
                List<RoomSuggestion> singleTypeCombo = List.of(new RoomSuggestion(rt, neededRooms));
                String key = neededRooms + "x" + rt.getName();
                if (seen.add(key)) {
                    result.add(singleTypeCombo);
                }
            }
        }

        // ✅ BƯỚC 1: tổ hợp 1 phòng nếu phòng đơn đã đủ
        for (RoomType rt : roomTypes) {
            if (rt.getMaxGuests() >= totalGuests
                    && rt.getMaxGuests() <= totalGuests * 1.5 // 👈 giới hạn dư công suất
                    && rt.getAvailableRooms() >= 1) {
                List<RoomSuggestion> single = List.of(new RoomSuggestion(rt, 1));
                String key = "1x" + rt.getName();
                if (seen.add(key)) {
                    result.add(single);
                }
            }
        }

        // ✅ BƯỚC 2: tổ hợp nhiều loại phòng
        if (totalGuests > 1) {
            backtrackSmart(roomTypes, 0, totalGuests, new ArrayList<>(), result, seen);
        }
        // ✅ BƯỚC 3: lọc theo loại phòng bắt buộc nếu có
        if (requiredRoomTypeName != null && !requiredRoomTypeName.isBlank()) {
            result = result.stream()
                    .filter(combo -> combo.stream()
                    .anyMatch(s -> s.getRoomType().getName().equalsIgnoreCase(requiredRoomTypeName)))
                    .collect(Collectors.toList());
        }

        // ✅ BƯỚC 4: sắp xếp tổ hợp (ưu tiên ít phòng, giá rẻ)
        return result.stream()
                .filter(combo -> {
                    int totalGuestsInCombo = combo.stream()
                            .mapToInt(s -> s.getQuantity() * s.getRoomType().getMaxGuests())
                            .sum();
                    return totalGuestsInCombo <= totalGuests + 1; // lệch tối đa 2 người
                })
                .sorted(Comparator
                        .comparingInt((List<RoomSuggestion> combo)
                                -> combo.stream().mapToInt(RoomSuggestion::getQuantity).sum())
                        .thenComparingDouble(combo
                                -> combo.stream().mapToDouble(s -> s.getQuantity() * s.getRoomType().getBasePrice()).sum()))
                .limit(10)
                .collect(Collectors.toList());

    }

    private void backtrackSmart(List<RoomType> roomTypes, int index, int requiredGuests,
            List<RoomSuggestion> current, List<List<RoomSuggestion>> result, Set<String> seen) {

        int totalGuests = current.stream()
                .mapToInt(s -> s.getQuantity() * s.getRoomType().getMaxGuests())
                .sum();

        if (totalGuests > requiredGuests + 2) {
            return;
        }

        int totalRooms = current.stream()
                .mapToInt(RoomSuggestion::getQuantity)
                .sum();

        if (totalGuests >= requiredGuests) {
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

        for (int qty = maxQty; qty >= 1; qty--) {
            current.add(new RoomSuggestion(rt, qty));
            backtrackSmart(roomTypes, index + 1, requiredGuests, current, result, seen);
            current.remove(current.size() - 1);
        }

        // Nhánh không chọn loại phòng này
        backtrackSmart(roomTypes, index + 1, requiredGuests, current, result, seen);
    }

    private SearchParams getSearchParams(HttpServletRequest request) throws ServletException {
        String checkinStr = request.getParameter("checkin"); // "20/07/2025"
        String checkoutStr = request.getParameter("checkout");
        String guestsStr = request.getParameter("guests");

        String roomTypeFilter = request.getParameter("roomType");
        String minGuestsPerRoomStr = request.getParameter("minGuestsPerRoom");
        String minTotalGuestsStr = request.getParameter("minTotalGuests");
        String maxPriceStr = request.getParameter("maxPrice");

        java.sql.Date checkin;
        java.sql.Date checkout;
        int guests;

        try {
            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
            sdf.setLenient(false);

            Date parsedCheckin = sdf.parse(checkinStr);
            Date parsedCheckout = sdf.parse(checkoutStr);

            checkin = new java.sql.Date(parsedCheckin.getTime());
            checkout = new java.sql.Date(parsedCheckout.getTime());

        } catch (Exception e) {
            throw new ServletException("❌ Ngày không hợp lệ. Vui lòng nhập đúng định dạng dd/MM/yyyy.");
        }

        if (!checkout.after(checkin)) {
            throw new ServletException("❌ Ngày đi phải sau ngày đến ít nhất 1 ngày.");
        }

        try {
            guests = Integer.parseInt(guestsStr);
        } catch (NumberFormatException e) {
            throw new ServletException("❌ Số lượng khách không hợp lệ.");
        }

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
