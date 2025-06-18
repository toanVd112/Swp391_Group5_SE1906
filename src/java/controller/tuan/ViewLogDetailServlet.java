package controller.tuan;

import DAO.DBConnect;
import dao.ActivityLogDAO;
import model.ActivityLog;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet(name = "ViewLogDetailServlet", urlPatterns = {"/ViewLogDetailServlet"})
public class ViewLogDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null || !session.getAttribute("role").equals("manager")) {
            response.sendError(403, "Access Denied: Only managers are allowed to view log details.");
            return;
        }

        String idParam = request.getParameter("id");
        try (Connection conn = DBConnect.getConnection()) {
            String sql = "SELECT al.*, acc.Username, acc.Role FROM activitylogs al " +
                         "JOIN accounts acc ON al.ActorID = acc.AccountID WHERE al.LogID = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(idParam));
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ActivityLog log = new ActivityLog();
                log.setLogId(rs.getInt("LogID"));
                log.setUsername(rs.getString("Username"));
                log.setRole(rs.getString("Role"));
                log.setActionType(rs.getString("ActionType"));
                log.setTargetTable(rs.getString("TargetTable"));
                log.setTargetId(rs.getInt("TargetID"));
                log.setDescription(rs.getString("Description"));
                log.setActionTime(rs.getTimestamp("ActionTime"));
                request.setAttribute("log", log);
                request.getRequestDispatcher("Manager/viewLogDetail.jsp").forward(request, response);
            } else {
                response.sendError(404, "Log not found");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "Internal Server Error");
        }
    }
}