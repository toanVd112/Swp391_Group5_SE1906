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

        int id = Integer.parseInt(request.getParameter("id"));
        DiscountCodeDAO dao = new DiscountCodeDAO();
        DiscountCode dc = dao.getDiscountCodeByID(id);
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

        int id = Integer.parseInt(request.getParameter("id"));
        String code = request.getParameter("code");
        double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));
        LocalDate expiryDate = LocalDate.parse(request.getParameter("expiryDate"));
        String type = request.getParameter("type");
        String status = request.getParameter("status");

        DiscountCodeDAO dao = new DiscountCodeDAO();
        DiscountCode existing = dao.getDiscountCodeByID(id);
        if (!existing.getCode().equals(code) && dao.isDuplicatedCode(code)) {
            response.sendRedirect(request.getContextPath() + "/Manager/manager.jsp?page=editDiscountCode.jsp&id=" + id + "&msg=Duplicate+code");
            return;
        }

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
            response.sendRedirect(request.getContextPath() + "/Manager/manager.jsp?page=editDiscountCode.jsp&id=" + id + "&msg=Failed+to+update+discount+code");
        }
    }
}