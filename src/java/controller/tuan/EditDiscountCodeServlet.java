package controller.tuan;

import DAO.DiscountCodeDAO;
import model.DiscountCode;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import java.io.IOException;
import java.time.LocalDate;
import java.net.URLEncoder;

@WebServlet(name = "EditDiscountCodeServlet", urlPatterns = {"/discountcodes/edit"})
public class EditDiscountCodeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Account account = (session != null) ? (Account) session.getAttribute("account") : null;

        if (account == null || !"Manager".equals(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        int id = 0;
        try {
            id = Integer.parseInt(idStr);
            if (id <= 0) {
                response.sendRedirect(request.getContextPath() + "/discountcodes/list?msg=Invalid+discount+code+ID");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/discountcodes/list?msg=Invalid+discount+code+ID");
            return;
        }

        DiscountCodeDAO dao = new DiscountCodeDAO();
        DiscountCode dc = dao.getDiscountCodeByID(id);
        if (dc == null) {
            response.sendRedirect(request.getContextPath() + "/discountcodes/list?msg=Discount+code+not+found");
            return;
        }
        request.setAttribute("discountCode", dc);
        request.getRequestDispatcher("/Manager/manager.jsp?page=editDiscountCode.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        Account account = (session != null) ? (Account) session.getAttribute("account") : null;

        if (account == null || !"Manager".equals(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Get parameters
        String idStr = request.getParameter("id");
        String code = request.getParameter("code");
        String discountPercentStr = request.getParameter("discountPercent");
        String expiryDateStr = request.getParameter("expiryDate");
        String type = request.getParameter("type");
        String status = request.getParameter("status");

        // Validation
        StringBuilder errorMsg = new StringBuilder();
        int id = 0;
        double discountPercent = 0;
        LocalDate expiryDate = null;

        // Validate id
        try {
            id = Integer.parseInt(idStr);
            if (id <= 0) {
                errorMsg.append("Invalid discount code ID.\n");
            }
        } catch (NumberFormatException e) {
            errorMsg.append("Invalid discount code ID.\n");
        }

        // Validate code
        if (code == null || code.trim().isEmpty() || code.length() > 50 || !code.matches("^[A-Za-z0-9]+$")) {
            errorMsg.append("Code must be alphanumeric, not empty, and up to 50 characters.\n");
        }

        // Validate discountPercent
        try {
            discountPercent = Double.parseDouble(discountPercentStr);
            if (discountPercent < 0) {
                errorMsg.append("Discount must be non-negative.\n");
            } else if ("1".equals(type) && discountPercent > 99) {
                errorMsg.append("Percentage discount must be between 0.00 and 99.00.\n");
            } else if ("2".equals(type) && discountPercent > 999.999) {
                errorMsg.append("Fixed amount discount must be between 0.00 and 999.999.\n");
            }
        } catch (NumberFormatException e) {
            errorMsg.append("Invalid discount value.\n");
        }

        // Validate expiryDate
        try {
            expiryDate = LocalDate.parse(expiryDateStr);
            if (expiryDate.isBefore(LocalDate.now())) {
                errorMsg.append("Expiry date must be today or later.\n");
            }
        } catch (Exception e) {
            errorMsg.append("Invalid expiry date.\n");
        }

        // Validate type
        if (type == null || !type.matches("1|2")) {
            errorMsg.append("Invalid discount type.\n");
        }

        // Validate status
        if (status == null || !status.matches("Active|Inactive")) {
            errorMsg.append("Invalid status.\n");
        }

        // Check discount code existence and duplicate code
        DiscountCodeDAO dao = new DiscountCodeDAO();
        DiscountCode existing = null;
        if (id > 0) {
            existing = dao.getDiscountCodeByID(id);
            if (existing == null) {
                errorMsg.append("Discount code not found.\n");
            } else if (!existing.getCode().equals(code) && dao.isDuplicatedCode(code)) {
                errorMsg.append("Discount code already exists.\n");
            }
        } else {
            errorMsg.append("Invalid discount code ID.\n");
        }

        // If validation fails, redirect with error
        if (errorMsg.length() > 0) {
            response.sendRedirect(request.getContextPath() + "/Manager/manager.jsp?page=editDiscountCode.jsp&id=" + idStr + "&msg=" + URLEncoder.encode(errorMsg.toString(), "UTF-8"));
            return;
        }

        // Proceed with updating
        DiscountCode dc = new DiscountCode();
        dc.setDiscountCodeID(id);
        dc.setCode(code);
        dc.setDiscountPercent(discountPercent);
        dc.setExpiryDate(expiryDate);
        dc.setType(type);
        dc.setStatus(status);

        if (dao.updateDiscountCode(dc)) {
            response.sendRedirect(request.getContextPath() + "/discountcodes/list?msg=Discount+code+updated+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/Manager/manager.jsp?page=editDiscountCode.jsp&id=" + idStr + "&msg=Failed+to+update+discount+code");
        }
    }
}