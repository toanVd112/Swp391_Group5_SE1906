/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Manager.RoomType;

import DAO.RoomTypeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Amenity;
import model.RoomImage;
import model.RoomType;

/**
 *
 * @author Arcueid
 */
@WebServlet(name = "AddRoomTypeServlet", urlPatterns = {"/AddRoomType"})
public class AddRoomTypeServlet extends HttpServlet {

    private RoomTypeDAO dao;

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
            out.println("<title>Servlet NewServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet NewServlet at " + request.getContextPath() + "</h1>");
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
        request.getRequestDispatcher("Manager/manager.jsp?page=managerRoomType.jsp").forward(request, response);
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
    public void init() {
        dao = new RoomTypeDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        RoomType type = new RoomType();
        type.setName(request.getParameter("name"));
        type.setDescription(request.getParameter("description"));
        type.setBasePrice(Double.parseDouble(request.getParameter("basePrice")));
        type.setImageUrl(request.getParameter("imageUrl"));
        type.setRoomDetail(request.getParameter("roomDetail"));
        String guestStr = request.getParameter("maxGuests");
        int maxGuests = 0;
        try {
            if (guestStr != null && !guestStr.isBlank()) {
                maxGuests = Integer.parseInt(guestStr);
            }
        } catch (NumberFormatException e) {
            // Ghi log hoặc bỏ qua, giữ maxGuests = 0
        }
        type.setMaxGuests(maxGuests);
        // Danh mục
        List<String> categoryList = new ArrayList<>();
        String[] cats = request.getParameterValues("categoryList[]");
        if (cats != null) {
            for (String c : cats) {
                if (!c.isBlank()) {
                    categoryList.add(c.trim());
                }
            }
        }
        String sync = request.getParameter("categorySync");
        if (categoryList.isEmpty() && sync != null) {
            categoryList.addAll(List.of(sync.split(",")));
        }
        type.setCategoryList(categoryList);

        // Tiện ích
        List<Amenity> amenities = new ArrayList<>();
        String[] names = request.getParameterValues("amenityNames[]");
        String[] icons = request.getParameterValues("amenityIcons[]");
        if (names != null && icons != null) {
            for (int i = 0; i < names.length; i++) {
                if (!names[i].isBlank()) {
                    Amenity a = new Amenity();
                    a.setAmenityName(names[i]);
                    a.setIcon(icons[i]);
                    amenities.add(a);
                }
            }
        }
        type.setAmenities(amenities);

        // Ảnh chi tiết
        List<RoomImage> images = new ArrayList<>();
        String[] urls = request.getParameterValues("imageUrls[]");
        if (urls != null) {
            for (int i = 0; i < urls.length; i++) {
                String url = urls[i];
                if (url != null && !url.isBlank()) {
                    RoomImage img = new RoomImage();
                    img.setImageUrl(url.trim());
                    img.setPrimary(false);
                    List<String> imgCats = new ArrayList<>();
                    String[] imageCats = request.getParameterValues("imageCategories" + i);
                    if (imageCats != null) {
                        for (String c : imageCats) {
                            if (!c.trim().isEmpty()) {
                                imgCats.add(c.trim());
                            }
                        }
                    }
                    img.setCategories(imgCats);
                    images.add(img);
                }
            }
        }
        type.setImages(images);

        try {
            boolean success = dao.insertFullRoomType(type);
            if (success) {
                response.sendRedirect("RoomTypeListServlet");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể thêm loại phòng.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi SQL: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
