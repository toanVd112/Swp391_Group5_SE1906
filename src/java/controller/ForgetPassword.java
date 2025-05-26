/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author AD
 */
@WebServlet(name="ForgetPassword", urlPatterns={"/ForgetPassword"})
public class ForgetPassword extends HttpServlet {
    private DataSource dataSource;
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
            out.println("<title>Servlet ForgetPassword</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgetPassword at " + request.getContextPath () + "</h1>");
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
        processRequest(request, response);
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
        String email = request.getParameter("email");
        if (email != null && !email.isEmpty()) {
            try (Connection conn = dataSource.getConnection()) {
                String sql = "SELECT id FROM users WHERE email = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, email);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            int userId = rs.getInt("id");
                            String token = UUID.randomUUID().toString();
                            String insertToken = "INSERT INTO password_reset(user_id, token, created_at) VALUES (?,?,NOW())";
                            try (PreparedStatement ps2 = conn.prepareStatement(insertToken)) {
                                ps2.setInt(1, userId);
                                ps2.setString(2, token);
                                ps2.executeUpdate();
                            }
                            String resetLink = request.getScheme() + "://" + request.getServerName() + 
                                ":" + request.getServerPort() + request.getContextPath() + "/reset-password.jsp?token=" + token;
                            sendResetEmail(email, resetLink);
                        }
                    }
                }
            } catch (Exception e) {
                throw new ServletException("Error when processing password reset request", e);
            }
        }
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public void init() throws ServletException {
        try {
            Context ctx = new InitialContext();
            dataSource = (DataSource) ctx.lookup("java:comp/env/jdbc/YourDB");
        } catch (NamingException e) {
            throw new ServletException("Cannot retrieve DataSource java:comp/env/jdbc/YourDB", e);
        }
    }
    
    private void sendResetEmail(String toEmail, String resetLink) throws MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.example.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        Session mailSession = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("your_email@example.com", "your_email_password");
            }
        });
        Message message = new MimeMessage(mailSession);
        message.setFrom(new InternetAddress("no-reply@hoangnamhotel.com"));
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
        message.setSubject("Yêu cầu đặt lại mật khẩu");
        message.setText("Xin chào,\n\nVui lòng nhấp vào link sau để đặt lại mật khẩu:\n" + resetLink + "\nNếu bạn không thực hiện, bỏ qua email này.");
        Transport.send(message);
    }
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
