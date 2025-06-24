package controller.tuan;

import DAO.DiscountCodeDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "ToggleDiscountCodeStatusServlet", urlPatterns = {"/discountcodes/toggle"})
public class ToggleDiscountCodeStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        try {
            // Check authentication
            HttpSession session = request.getSession(false);
            Account account = (session != null) ? (Account) session.getAttribute("account") : null;

            if (account == null || !"Manager".equals(account.getRole())) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.print("{\"success\": false, \"message\": \"Unauthorized access. Please log in.\"}");
                out.flush();
                return;
            }

            // Get and validate ID parameter
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"Missing discount code ID.\"}");
                out.flush();
                return;
            }

            int id;
            try {
                id = Integer.parseInt(idParam);
                if (id <= 0) {
                    throw new NumberFormatException("ID must be positive");
                }
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"success\": false, \"message\": \"Invalid discount code ID.\"}");
                out.flush();
                return;
            }

            // Toggle status
            DiscountCodeDAO dao = new DiscountCodeDAO();
            if (dao.toggleDiscountCodeStatus(id)) {
                out.print("{\"success\": true, \"message\": \"Status updated successfully.\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print("{\"success\": false, \"message\": \"Discount code not found or update failed.\"}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"success\": false, \"message\": \"Server error: " + e.getMessage() + "\"}");
            e.printStackTrace();
        } finally {
            out.flush();
        }
    }
}