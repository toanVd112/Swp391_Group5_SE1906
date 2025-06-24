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

@WebServlet(name = "AddDiscountCodeServlet", urlPatterns = {"/discountcodes/add"})
public class AddDiscountCodeServlet extends HttpServlet {

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

        String code = request.getParameter("code");
        double discountPercent = Double.parseDouble(request.getParameter("discountPercent"));
        LocalDate expiryDate = LocalDate.parse(request.getParameter("expiryDate"));
        String type = request.getParameter("type");
        String status = request.getParameter("status");

        DiscountCodeDAO dao = new DiscountCodeDAO();
        if (dao.isDuplicatedCode(code)) {
            response.sendRedirect(request.getContextPath() + "/Manager/manager.jsp?page=addDiscountCode.jsp&msg=Duplicate+code");
            return;
        }

        DiscountCode dc = new DiscountCode();
        dc.setCode(code);
        dc.setDiscountPercent(discountPercent);
        dc.setExpiryDate(expiryDate);
        dc.setType(type);
        dc.setStatus(status);

        if (dao.addDiscountCode(dc)) {
            response.sendRedirect(request.getContextPath() + "/discountcodes/list?msg=Discount+code+added+successfully");
        } else {
            response.sendRedirect(request.getContextPath() + "/Manager/manager.jsp?page=addDiscountCode.jsp&msg=Failed+to+add+discount+code");
        }
    }
}