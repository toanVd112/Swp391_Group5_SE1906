/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package CartRooms;

import DAO.CartRoomDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Account;
import model.Room;
import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import java.io.BufferedReader;
import java.lang.reflect.Type;
import model.Room;
import model.SelectedRoom;

/**
 *
 * @author Admin
 */
@WebServlet(name = "MyRoomsServlet", urlPatterns = {"/myrooms"})
public class MyRoomsServlet extends HttpServlet {

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
            out.println("<title>Servlet MyRoomsServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet MyRoomsServlet at " + request.getContextPath() + "</h1>");
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
        request.getSession().setAttribute("isGuest", false);

        Account user = (Account) request.getSession().getAttribute("user");

        if (user != null) {
            // 👉 Đã login: lấy phòng từ DB
            CartRoomDAO dao = new CartRoomDAO();
            List<Integer> roomIds = dao.getRoomIdsByAccount(user.getAccountID());
            List<Room> selectedRooms = dao.getRoomsByIds(roomIds);
            double total = selectedRooms.stream().mapToDouble(r -> r.getRoomType().getBasePrice()).sum();

            request.setAttribute("selectedRooms", selectedRooms);
            request.setAttribute("totalPrice", total);
            request.getRequestDispatcher("myrooms_db.jsp").forward(request, response);
        } else {
            // 👉 Chưa login: client phải gửi localStorage bằng JavaScript → POST
            request.getRequestDispatcher("myrooms_local_redirect.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getSession().setAttribute("isGuest", true);

        // 👉 Nhận JSON từ localStorage
        BufferedReader reader = request.getReader();
        StringBuilder json = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            json.append(line);
        }

        // 👉 Parse JSON thành List<SelectedRoom>
        Gson gson = new Gson();
        Type listType = new TypeToken<List<SelectedRoom>>() {
        }.getType();
        List<SelectedRoom> selectedRooms = gson.fromJson(json.toString(), listType);

        // 👉 Tính tổng tiền
        double total = selectedRooms.stream()
                .mapToDouble(SelectedRoom::getPrice)
                .sum();

        // 👉 Lưu vào session để JSP đọc
        request.getSession().setAttribute("selectedRooms", selectedRooms);
        request.getSession().setAttribute("totalPrice", total);

        response.sendRedirect("myrooms_db.jsp");
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
