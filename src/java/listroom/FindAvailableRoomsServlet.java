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

            // 2. Truy vấn DB để lấy loại phòng còn trống
            RoomTypeDAO dao = new RoomTypeDAO();

            // 1. Lấy tham số lọc
            java.sql.Date checkin = (java.sql.Date) params.checkin;
            java.sql.Date checkout = (java.sql.Date) params.checkout;
            String roomTypeFilter = params.roomTypeFilter;
            Integer minGuests = params.minGuests;

            Double maxPrice = params.maxPrice;

// 2. Gọi DAO để lấy danh sách RoomType còn trống phù hợp
            List<RoomType> availableRoomTypes = dao.getAvailableRoomTypes(
                    checkin,
                    checkout,
                    roomTypeFilter,
                    minGuests,
                    maxPrice
            );

            List<RoomType> allRoomTypes = dao.getAllRoomTypes(); // cho dropdown filter

            // 3. Tính toán gợi ý tổ hợp phòng
            List<List<RoomSuggestion>> suggestionCombos = generateSuggestions(availableRoomTypes, params.guests);

            // 4. Phân trang (giả định)
            int currentPage = 1;
            int totalPages = 1;

            // 5. Gán dữ liệu cho JSP
            request.setAttribute("checkin", params.checkinStr);
            request.setAttribute("checkout", params.checkoutStr);
            request.setAttribute("guests", params.guests);
            request.setAttribute("rooms", params.requestedRooms);
            request.setAttribute("availableRooms", availableRoomTypes);
            request.setAttribute("roomTypes", allRoomTypes);
            request.setAttribute("suggestions", suggestionCombos);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("roomlist.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Lỗi xử lý: " + e.getMessage());
        }
    }

    private List<List<RoomSuggestion>> generateSuggestions(List<RoomType> roomTypes, int totalGuests) {
        List<List<RoomSuggestion>> combos = new ArrayList<>();

        for (RoomType rt : roomTypes) {
            int maxPerRoom = rt.getMaxGuests();
            int needed = (int) Math.ceil((double) totalGuests / maxPerRoom);
            if (needed <= rt.getAvailableRooms()) {
                List<RoomSuggestion> combo = new ArrayList<>();
                combo.add(new RoomSuggestion(rt, needed));
                combos.add(combo);
            }
        }

        // TODO: Bổ sung logic tổ hợp nhiều loại phòng
        return combos;
    }

    private SearchParams getSearchParams(HttpServletRequest request) {
        String checkinStr = request.getParameter("checkin");
        String checkoutStr = request.getParameter("checkout");
        String guestsStr = request.getParameter("guests");
        String roomsStr = request.getParameter("rooms");
        String roomTypeFilter = request.getParameter("roomType");
        String minGuestsStr = request.getParameter("minGuests");
        String maxPriceStr = request.getParameter("maxPrice");

        java.sql.Date checkin = java.sql.Date.valueOf(request.getParameter("checkin"));
        java.sql.Date checkout = java.sql.Date.valueOf(request.getParameter("checkout"));

        int guests = Integer.parseInt(guestsStr);
        int requestedRooms = Integer.parseInt(roomsStr);

        Integer minGuests = (minGuestsStr != null && !minGuestsStr.isBlank())
                ? Integer.parseInt(minGuestsStr)
                : null;
        Double maxPrice = (maxPriceStr != null && !maxPriceStr.isBlank())
                ? Double.parseDouble(maxPriceStr)
                : null;

        return new SearchParams(checkinStr, checkoutStr, checkin, checkout, guests, requestedRooms, roomTypeFilter, minGuests, maxPrice);
    }

    // Class phụ trợ để gom các input
    private static class SearchParams {

        String checkinStr, checkoutStr, roomTypeFilter;
        Date checkin, checkout;
        int guests, requestedRooms;
        Integer minGuests;
        Double maxPrice;

        public SearchParams(String checkinStr, String checkoutStr, Date checkin, Date checkout,
                int guests, int requestedRooms, String roomTypeFilter,
                Integer minGuests, Double maxPrice) {
            this.checkinStr = checkinStr;
            this.checkoutStr = checkoutStr;
            this.checkin = checkin;
            this.checkout = checkout;
            this.guests = guests;
            this.requestedRooms = requestedRooms;
            this.roomTypeFilter = roomTypeFilter;
            this.minGuests = minGuests;
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
