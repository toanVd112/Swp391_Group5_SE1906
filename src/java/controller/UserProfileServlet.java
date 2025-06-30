/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import DAO.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.*;
import java.io.*;
import jakarta.servlet.annotation.MultipartConfig;
import DAO.UserDao;
import model.Account;
import model.User;
import java.util.ArrayList;
import java.text.SimpleDateFormat;
import java.util.List;

/**
 *
 * @author AD
 */
@WebServlet(name="UserProfileServlet", urlPatterns={"/user-profile"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class UserProfileServlet extends HttpServlet {
    private UserDao userDAO = new UserDao();
    private AccountDAO accountDAO = new AccountDAO();
    private static final String UPLOAD_DIR = "Uploads";
    
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet UserProfileServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet UserProfileServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        

        try {
            User user = userDAO.getUserByAccountId(accountId);
            Account account = accountDAO.getAccountByID(String.valueOf(accountId));
            if (user == null || account == null) {
                request.setAttribute("error", "Không tìm thấy thông tin hồ sơ hoặc tài khoản!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }
            request.setAttribute("user", user);
            request.setAttribute("account", account);
            request.getRequestDispatcher("/user_profile2.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy thông tin hồ sơ!");
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); // Đảm bảo nhận Tiếng Việt
        
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        if (accountId == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        try {
            User user = userDAO.getUserByAccountId(accountId);
            Account account = accountDAO.getAccountByID(String.valueOf(accountId));
            if (user == null || account == null) {
                request.setAttribute("error", "Không tìm thấy thông tin hồ sơ hoặc tài khoản!");
                request.getRequestDispatcher("/error.jsp").forward(request, response);
                return;
            }

            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");
            String dateOfBirth = request.getParameter("dateOfBirth");
            String address = request.getParameter("address");

            // Validation
            List<String> errors = new ArrayList<>();
            if (fullName == null || fullName.trim().isEmpty()) {
                errors.add("Họ và tên không được để trống!");
            } else if (fullName.length() > 100) {
                errors.add("Họ và tên không được vượt quá 100 ký tự!");
            } else if (!isValidName(fullName)) {
                errors.add("Họ và tên chỉ được chứa chữ cái và khoảng trắng!");
            }
            if (!isValidEmail(email)) {
                errors.add("Định dạng email không hợp lệ!");
            } else if (!account.getEmail().equals(email) && accountDAO.isDuplicateAccount(null, email)) {
                errors.add("Email đã được sử dụng bởi tài khoản khác!");
            }
            if (!isValidPhone(phone)) {
                errors.add("Số điện thoại phải là 10 chữ số!");
            }
            if (dateOfBirth != null && !dateOfBirth.isEmpty() && !isValidDate(dateOfBirth)) {
                errors.add("Định dạng ngày sinh không hợp lệ! Sử dụng YYYY-MM-DD.");
            }

            if (!errors.isEmpty()) {
                request.setAttribute("errors", errors);
                request.setAttribute("tempFullName", fullName);
                request.setAttribute("tempEmail", email);
                request.setAttribute("tempPhone", phone);
                request.setAttribute("tempDob", dateOfBirth);
                request.setAttribute("tempAddress", address);
                request.setAttribute("user", user);
                request.setAttribute("account", account);
                request.getRequestDispatcher("/user_profile2.jsp").forward(request, response);
                return;
            }

            // Cập nhật thông tin user
            user.setFullName(fullName.trim());
            user.setEmail(email.trim());
            user.setPhone(phone.trim());
            user.setDateOfBirth(dateOfBirth != null ? dateOfBirth.trim() : null);
            user.setAddress(address != null ? address.trim() : null);

            // Xử lý upload ảnh
            Part filePart = request.getPart("photo");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = extractFileName(filePart);
                if (!fileName.matches(".*\\.(jpg|jpeg|png|gif)$")) {
                    request.setAttribute("error", "Định dạng ảnh không hợp lệ! Chỉ chấp nhận JPG, PNG, GIF.");
                    request.setAttribute("user", user);
                    request.setAttribute("account", account);
                    request.getRequestDispatcher("/user_profile2.jsp").forward(request, response);
                    return;
                }
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                // Xóa ảnh cũ nếu tồn tại
                if (user.getAvatarPath() != null) {
                    File oldFile = new File(getServletContext().getRealPath("") + File.separator + user.getAvatarPath());
                    if (oldFile.exists()) {
                        oldFile.delete();
                    }
                }
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                user.setAvatarPath(UPLOAD_DIR + "/" + fileName);
            }

            // Cập nhật hồ sơ
            if (userDAO.updateUser(user)) {
                // Cập nhật email trong bảng Accounts nếu thay đổi
                if (!account.getEmail().equals(email)) {
                    accountDAO.editAccount(account.getUsername(), account.getPassword(), account.getRole(), 
                            account.isActive(), email, String.valueOf(accountId));
                }
                request.setAttribute("message", "Cập nhật hồ sơ thành công!");
            } else {
                request.setAttribute("error", "Cập nhật hồ sơ thất bại!");
            }

            request.setAttribute("user", user);
            request.setAttribute("account", account);
            request.getRequestDispatcher("/user_profile2.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật hồ sơ!");
            request.setAttribute("user", userDAO.getUserByAccountId(accountId));
            request.setAttribute("account", accountDAO.getAccountByID(String.valueOf(accountId)));
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
    
    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return System.currentTimeMillis() + "_" + s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
    
    // Validate email theo regex đơn giản
    private boolean isValidEmail(String email) {
        return email != null && email.matches("^[\\w-.]+@[\\w-]+(\\.[\\w-]+)+$");
    }

    // Validate số điện thoại (chỉ số và 10 ký tự)
    private boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^\\d{10}$");
    }
    
    // Cho phép chữ cái tiếng Việt, chữ hoa, thường, và khoảng trắng, không số hoặc ký tự đặc biệt
    private boolean isValidName(String name) {
        return name != null && name.matches("^[a-zA-ZÀ-ỹ\\s]+$");
    }
    
    private boolean isValidDate(String date) {
        if (date == null || !date.matches("^\\d{4}-\\d{2}-\\d{2}$")) {
            return false;
        }
        try {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            sdf.setLenient(false);
            sdf.parse(date);
            return true;
        } catch (Exception e) {
            return false;
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
