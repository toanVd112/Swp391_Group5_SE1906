package controller.tuan;

import DAO.ServiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;
import model.Service;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.regex.Pattern;

@WebServlet(name = "AddServiceServlet", urlPatterns = {"/addService"})
public class addService extends HttpServlet {

    // Regex for service name: letters (including Vietnamese), numbers, spaces, hyphens, underscores
    private static final Pattern NAME_PATTERN = Pattern.compile("^[\\p{L}0-9\\s-_]{3,100}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("account") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        Account account = (Account) session.getAttribute("account");
        if (!"Manager".equals(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        ServiceDAO serviceDAO = new ServiceDAO();
        List<String> serviceTypes = serviceDAO.getAllDistinctServiceType();
        request.setAttribute("serviceTypes", serviceTypes);
        request.getRequestDispatcher("/Manager/addService.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        Account currentAccount = (session != null) ? (Account) session.getAttribute("account") : null;
        if (currentAccount == null || !"Manager".equals(currentAccount.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        String loggedInUser = currentAccount.getUsername();

        String name = request.getParameter("name");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String status = request.getParameter("status");
        String serviceType = request.getParameter("serviceType");
        String serviceImage = request.getParameter("serviceImage");

        String jspPath = "/Manager/addService.jsp";
        ServiceDAO serviceDAO = new ServiceDAO();
        List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();

        // Validate inputs
        if (name == null || name.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Tên dịch vụ không được để trống.");
            request.setAttribute("serviceTypes", allServiceTypes);
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        if (!NAME_PATTERN.matcher(name).matches()) {
            request.setAttribute("errorMessage", "Tên dịch vụ phải từ 3 đến 100 ký tự, chỉ chứa chữ, số, dấu cách, gạch ngang hoặc gạch dưới.");
            request.setAttribute("serviceTypes", allServiceTypes);
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        if (serviceDAO.isDuplicatedServiceName(name, -1)) {
            request.setAttribute("errorMessage", "Tên dịch vụ đã tồn tại.");
            request.setAttribute("serviceTypes", allServiceTypes);
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        if (description != null && description.length() > 1000) {
            request.setAttribute("errorMessage", "Mô tả không được vượt quá 1000 ký tự.");
            request.setAttribute("serviceTypes", allServiceTypes);
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        if (priceStr == null || priceStr.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Giá dịch vụ không được để trống.");
            request.setAttribute("serviceTypes", allServiceTypes);
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        if (serviceType == null || serviceType.trim().isEmpty() || !allServiceTypes.contains(serviceType)) {
            request.setAttribute("errorMessage", "Loại dịch vụ không hợp lệ.");
            request.setAttribute("serviceTypes", allServiceTypes);
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        if (status == null || (!status.equals("0") && !status.equals("1"))) {
            request.setAttribute("errorMessage", "Trạng态 dịch vụ không hợp lệ. Phải là '0' hoặc '1'.");
            request.setAttribute("serviceTypes", allServiceTypes);
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        int price;
        try {
            price = Integer.parseInt(priceStr);
            if (price < 0) {
                request.setAttribute("errorMessage", "Giá không được là số âm.");
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Giá không hợp lệ. Vui lòng nhập một số nguyên.");
            request.setAttribute("serviceTypes", allServiceTypes);
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        Service newService = new Service();
        newService.setName(name);
        newService.setDescription(description != null ? description : "");
        newService.setPrice(price);
        newService.setStatus(status);
        newService.setType(serviceType);
        newService.setServiceImage(serviceImage != null ? serviceImage : "");
        newService.setCreateDate(LocalDateTime.now());
        newService.setLastUpdateDate(LocalDateTime.now());
        newService.setCreatedBy(loggedInUser);
        newService.setLastUpdateBy(loggedInUser);

        boolean success = false;
        try {
            success = serviceDAO.addService(newService);
        } catch (Exception e) {
            this.log("Lỗi hệ thống khi thêm dịch vụ: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi hệ thống khi thêm dịch vụ: " + e.getMessage());
            request.setAttribute("serviceTypes", allServiceTypes);
            request.getRequestDispatcher(jspPath).forward(request, response);
            return;
        }

        if (success) {
            response.sendRedirect(request.getContextPath() + "/serviceslist?action=list&addStatus=success");
        } else {
            request.setAttribute("errorMessage", "Thêm dịch vụ mới thất bại. Vui lòng thử lại.");
            request.setAttribute("serviceTypes", allServiceTypes);
            request.getRequestDispatcher(jspPath).forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet để thêm dịch vụ mới";
    }
}