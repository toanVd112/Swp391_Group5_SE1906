///*
// * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
// * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
// */
package ReceptionServlet;
//

import DAO.AccountDAO;
import DAO.MaintenanceRequestDAO1;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Account;
import model.MaintenanceRequest;

@WebServlet("/sendMaintenanceRequest")
public class SendMaintenanceRequestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int roomID = Integer.parseInt(request.getParameter("roomID"));
        int staffID = Integer.parseInt(request.getParameter("staffID"));
        String description = request.getParameter("description");

        MaintenanceRequestDAO1 dao = new MaintenanceRequestDAO1();
        boolean success = dao.insertRequest(roomID, staffID, description);
        List<MaintenanceRequest> allRequests = new MaintenanceRequestDAO1().getAllRequests();
        request.setAttribute("requestList", allRequests);
        if (success) {
            request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Không thể gửi yêu cầu.");
            request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        AccountDAO dao = new AccountDAO();
        List<Account> staffList = new ArrayList<>();
        try {
            staffList = dao.getAccountsByRole("Staff");
        } catch (SQLException ex) {
            Logger.getLogger(SendMaintenanceRequestServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        request.setAttribute("staffList", staffList);

        // Gán Map<staffID, username>
        Map<Integer, String> staffMap = new HashMap<>();
        for (Account acc : staffList) {
            staffMap.put(acc.getAccountID(), acc.getUsername());
        }
        request.setAttribute("staffMap", staffMap);

        // Danh sách yêu cầu bảo trì
        List<MaintenanceRequest> allRequests = new MaintenanceRequestDAO1().getAllRequests();
        request.setAttribute("requestList", allRequests);

        request.getRequestDispatcher("Receptionist/reception.jsp?page=sendMaintenanceRequest.jsp").forward(request, response);
    }

}
