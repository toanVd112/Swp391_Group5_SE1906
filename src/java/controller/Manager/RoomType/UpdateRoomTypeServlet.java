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
import java.util.Arrays;
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
@WebServlet(name = "UpdateRoomTypeServlet", urlPatterns = {"/UpdateRoomType"})
public class UpdateRoomTypeServlet extends HttpServlet {

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
        int id = Integer.parseInt(request.getParameter("id"));
        RoomType roomType = null;
        try {
            roomType = dao.getRoomTypeById(id);
        } catch (SQLException ex) {
            Logger.getLogger(UpdateRoomTypeServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        request.setAttribute("roomType", roomType);
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
    private RoomTypeDAO dao;

    @Override
    public void init() {
        dao = new RoomTypeDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        try {
            RoomType type = new RoomType();
            type.setRoomTypeID(Integer.parseInt(request.getParameter("roomTypeID")));
            type.setName(request.getParameter("name"));
            type.setDescription(request.getParameter("description"));
            type.setBasePrice(Double.parseDouble(request.getParameter("basePrice")));
            type.setImageUrl(request.getParameter("imageUrl"));
            type.setRoomDetail(request.getParameter("roomDetail"));
            type.setMaxGuests(Integer.parseInt(request.getParameter("maxGuests")));

            // Category List
            String[] categoryList = request.getParameterValues("categoryList[]");
            if (categoryList != null) {
                type.setCategoryList(Arrays.asList(categoryList));
            }

            // Amenities
            String[] amenityNames = request.getParameterValues("amenityNames[]");
            String[] amenityIcons = request.getParameterValues("amenityIcons[]");
            List<Amenity> amenities = new ArrayList<>();
            if (amenityNames != null && amenityIcons != null) {
                for (int i = 0; i < amenityNames.length; i++) {
                    Amenity a = new Amenity();
                    a.setAmenityName(amenityNames[i]);
                    a.setIcon(amenityIcons[i]);
                    amenities.add(a);
                }
            }
            type.setAmenities(amenities);

            // Images
            String[] imageUrls = request.getParameterValues("imageUrls[]");
            List<RoomImage> images = new ArrayList<>();
            if (imageUrls != null) {
                for (int i = 0; i < imageUrls.length; i++) {
                    RoomImage img = new RoomImage();
                    img.setImageUrl(imageUrls[i]);
                    img.setPrimary(false);
                    String[] categories = request.getParameterValues("imageCategories" + i);
                    if (categories != null) {
                        img.setCategories(Arrays.asList(categories));
                    }
                    images.add(img);
                }
            }
            type.setImages(images);

            boolean updated = dao.updateFullRoomType(type);
            if (updated) {
                response.sendRedirect("RoomTypeListServlet");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể cập nhật loại phòng.");
            }
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Lỗi xử lý: " + e.getMessage());
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
