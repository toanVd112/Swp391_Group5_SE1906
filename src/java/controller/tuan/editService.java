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

@WebServlet(name = "editService", urlPatterns = {"/editService"})
public class editService extends HttpServlet {

    // Regex for service name: letters (including Vietnamese), numbers, spaces, hyphens, underscores
    private static final Pattern NAME_PATTERN = Pattern.compile("^[\\p{L}0-9\\s-_]{3,64}$");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        Account currentAccount = (session != null) ? (Account) session.getAttribute("account") : null;
        if (currentAccount == null || !"Manager".equals(currentAccount.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String jspPath = "/Manager/editService.jsp";
        ServiceDAO serviceDAO = new ServiceDAO();

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "ID dịch vụ không được cung cấp.");
                response.sendRedirect(request.getContextPath() + "/serviceslist?action=list");
                return;
            }
            int id = Integer.parseInt(idParam);
            Service service = serviceDAO.getServiceByID(id);
            List<String> serviceTypes = serviceDAO.getAllDistinctServiceType();

            if (service != null) {
                request.setAttribute("service", service);
                request.setAttribute("serviceTypes", serviceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Không tìm thấy dịch vụ với ID: " + id);
                response.sendRedirect(request.getContextPath() + "/serviceslist?action=list");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID dịch vụ không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/serviceslist?action=list&error=invalidIdFormat");
        } catch (Exception e) {
            this.log("Lỗi hệ thống khi tải dữ liệu dịch vụ: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi hệ thống khi tải dữ liệu dịch vụ: " + e.getMessage());
            try {
                request.getRequestDispatcher(jspPath).forward(request, response);
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/serviceslist?action=list&error=systemError");
            }
        }
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

        String jspPath = "/Manager/editService.jsp";
        ServiceDAO serviceDAO = new ServiceDAO();
        int serviceId = -1;

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "ID dịch vụ không được gửi trong form.");
                response.sendRedirect(request.getContextPath() + "/serviceslist?action=list&error=missingFormId");
                return;
            }
            serviceId = Integer.parseInt(idParam);

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String status = request.getParameter("status");
            String serviceType = request.getParameter("serviceType");
            String serviceImage = request.getParameter("serviceImage");

            List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();

            // Validate inputs
            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Tên dịch vụ không được để trống.");
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }

            if (!NAME_PATTERN.matcher(name).matches()) {
                request.setAttribute("errorMessage", "Tên dịch vụ phải từ 3 đến 64 ký tự, chỉ chứa chữ, số, dấu cách, gạch ngang hoặc gạch dưới.");
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }

            if (serviceDAO.isDuplicatedServiceName(name, serviceId)) {
                request.setAttribute("errorMessage", "Tên dịch vụ đã tồn tại. Vui lòng chọn tên khác.");
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }

            if (description != null && description.length() > 1000) {
                request.setAttribute("errorMessage", "Mô tả không được vượt quá 1000 ký tự.");
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }

            if (priceStr == null || priceStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Giá dịch vụ không được để trống.");
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }

            if (serviceType == null || serviceType.trim().isEmpty() || !allServiceTypes.contains(serviceType)) {
                request.setAttribute("errorMessage", "Loại dịch vụ không hợp lệ.");
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }

            if (status == null || (!status.equals("0") && !status.equals("1"))) {
                request.setAttribute("errorMessage", "Trạng thái dịch vụ không hợp lệ. Phải là '0' hoặc '1'.");
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }

            int price;
            try {
                price = Integer.parseInt(priceStr);
                if (price < 0) {
                    request.setAttribute("errorMessage", "Giá không được là số âm.");
                    Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                    request.setAttribute("service", serviceToEdit);
                    request.setAttribute("serviceTypes", allServiceTypes);
                    request.getRequestDispatcher(jspPath).forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Giá không hợp lệ. Vui lòng nhập một số nguyên.");
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }

            Service serviceToUpdate = new Service();
            serviceToUpdate.setId(serviceId);
            serviceToUpdate.setName(name);
            serviceToUpdate.setDescription(description != null ? description : "");
            serviceToUpdate.setPrice(price);
            serviceToUpdate.setStatus(status);
            serviceToUpdate.setType(serviceType);
            serviceToUpdate.setServiceImage(serviceImage != null ? serviceImage : "");
            serviceToUpdate.setLastUpdateDate(LocalDateTime.now());
            serviceToUpdate.setLastUpdateBy(currentAccount.getUsername());

            Service existingService = serviceDAO.getServiceByID(serviceId);
            if (existingService != null) {
                serviceToUpdate.setCreateDate(existingService.getCreateDate());
                serviceToUpdate.setCreatedBy(existingService.getCreatedBy());
            } else {
                request.setAttribute("errorMessage", "Không tìm thấy dịch vụ gốc để cập nhật.");
                response.sendRedirect(request.getContextPath() + "/serviceslist?action=list&error=originalNotFound");
                return;
            }

            boolean success = serviceDAO.update(serviceToUpdate);
            if (success) {
                response.sendRedirect(request.getContextPath() + "/serviceslist?action=list&msg=Update+success");
            } else {
                request.setAttribute("errorMessage", "Cập nhật dịch vụ thất bại. Vui lòng thử lại.");
                request.setAttribute("service", serviceToUpdate);
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID dịch vụ không hợp lệ trong form gửi đi.");
            response.sendRedirect(request.getContextPath() + "/serviceslist?action=list&error=invalidFormId");
        } catch (Exception e) {
            this.log("Lỗi hệ thống khi cập nhật dịch vụ: " + e.getMessage());
            request.setAttribute("errorMessage", "Lỗi hệ thống khi cập nhật dịch vụ: " + e.getMessage());
            if (serviceId != -1) {
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
            }
            request.getRequestDispatcher(jspPath).forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for editing an existing service.";
    }
}