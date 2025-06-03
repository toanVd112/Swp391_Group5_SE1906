/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.tuan;

import DAO.ServiceDAO; // Đảm bảo import đúng
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Account;   // Đảm bảo import đúng
import model.Service;   // Đảm bảo import đúng

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
// import java.io.PrintWriter; // Không cần thiết nếu chỉ forward/redirect

/**
 *
 * @author admin
 */
@WebServlet(name = "editService", urlPatterns = {"/editService"})
public class editService extends HttpServlet {

    // Hiển thị form chỉnh sửa dịch vụ
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        Account currentAccount = (session != null) ? (Account) session.getAttribute("account") : null;

        // Kiểm tra quyền Manager
        if (currentAccount == null || !"Manager".equals(currentAccount.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login_2.jsp"); // Hoặc trang đăng nhập của bạn
            return;
        }

        String jspPath = "../Manager/editService.jsp"; // Đường dẫn đến JSP sửa dịch vụ (điều chỉnh nếu cần)
        ServiceDAO serviceDAO = new ServiceDAO();

        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "ID dịch vụ không được cung cấp.");
                // Chuyển hướng về trang danh sách hoặc trang lỗi phù hợp
                response.sendRedirect(request.getContextPath() + "/services/list");
                return;
            }
            int id = Integer.parseInt(idParam);
            Service service = serviceDAO.getServiceByID(id);
            List<String> serviceTypes = serviceDAO.getAllDistinctServiceType(); // Lấy danh sách loại dịch vụ

            if (service != null) {
                request.setAttribute("service", service);
                request.setAttribute("serviceTypes", serviceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
            } else {
                request.setAttribute("errorMessage", "Không tìm thấy dịch vụ với ID: " + id);
                response.sendRedirect(request.getContextPath() + "/services/list");
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID dịch vụ không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/services?action=list&error=invalidIdFormat");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống khi tải dữ liệu dịch vụ: " + e.getMessage());
            // Cân nhắc việc forward về trang lỗi chung hoặc trang trước đó với thông báo
             try {
                // Cố gắng forward lại form với thông báo lỗi nếu có thể
                request.getRequestDispatcher(jspPath).forward(request, response);
            } catch (Exception ex) {
                response.sendRedirect(request.getContextPath() + "/services?action=list&error=systemError");
            }
        }
    }

    // Xử lý việc cập nhật thông tin dịch vụ
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        Account currentAccount = (session != null) ? (Account) session.getAttribute("account") : null;

        // Kiểm tra quyền Manager
        if (currentAccount == null || !"Manager".equals(currentAccount.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login_2.jsp");
            return;
        }

        String jspPath = "../Manager/editService.jsp"; // Để forward lại form nếu có lỗi
        ServiceDAO serviceDAO = new ServiceDAO();
        int serviceId = -1; // Để lưu id cho việc tải lại form khi lỗi

        try {
            String idParam = request.getParameter("id"); // ID từ trường hidden trong form
             if (idParam == null || idParam.trim().isEmpty()) {
                request.setAttribute("errorMessage", "ID dịch vụ không được gửi trong form.");
                response.sendRedirect(request.getContextPath() + "/services?action=list&error=missingFormId");
                return;
            }
            serviceId = Integer.parseInt(idParam);

            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceStr = request.getParameter("price");
            String status = request.getParameter("status"); // Sẽ là "1" hoặc "0" nếu JSP được sửa đúng
            String serviceType = request.getParameter("serviceType");
            String serviceImage = request.getParameter("serviceImage");

            // Validate đầu vào
            if (name == null || name.trim().isEmpty() || priceStr == null || priceStr.trim().isEmpty() || serviceType == null || serviceType.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Tên dịch vụ, giá và loại dịch vụ là bắt buộc.");
                // Tải lại dữ liệu cho form để người dùng sửa
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();
                request.setAttribute("service", serviceToEdit); // Dữ liệu từ DB
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }

            int price;
            try {
                price = Integer.parseInt(priceStr); // Giả sử giá là số nguyên
                if (price < 0) {
                    request.setAttribute("errorMessage", "Giá không được là số âm.");
                    Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                    List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();
                    request.setAttribute("service", serviceToEdit);
                    request.setAttribute("serviceTypes", allServiceTypes);
                    request.getRequestDispatcher(jspPath).forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "Giá không hợp lệ. Vui lòng nhập một số nguyên.");
                Service serviceToEdit = serviceDAO.getServiceByID(serviceId);
                List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();
                request.setAttribute("service", serviceToEdit);
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
                return;
            }

            Service serviceToUpdate = new Service();
            serviceToUpdate.setId(serviceId);
            serviceToUpdate.setName(name);
            serviceToUpdate.setDescription(description);
            serviceToUpdate.setPrice(price);
            serviceToUpdate.setStatus(status); // "1" hoặc "0"
            serviceToUpdate.setType(serviceType);
            serviceToUpdate.setServiceImage(serviceImage);
            serviceToUpdate.setLastUpdateDate(LocalDateTime.now());
            serviceToUpdate.setLastUpdateBy(currentAccount.getUsername()); // Giả sử Account có getUsername()

            // Lấy thông tin ngày tạo và người tạo từ bản ghi gốc để không bị ghi đè
            Service existingService = serviceDAO.getServiceByID(serviceId);
            if (existingService != null) {
                serviceToUpdate.setCreateDate(existingService.getCreateDate());
                serviceToUpdate.setCreatedBy(existingService.getCreatedBy());
            } else {
                // Trường hợp hiếm gặp: service bị xóa trong khi đang sửa
                request.setAttribute("errorMessage", "Không tìm thấy dịch vụ gốc để cập nhật. Dịch vụ có thể đã bị xóa.");
                response.sendRedirect(request.getContextPath() + "/services?action=list&error=originalNotFound");
                return;
            }
            
            boolean success = serviceDAO.update(serviceToUpdate);

            if (success) {
                // Chuyển hướng về trang danh sách dịch vụ (hoặc trang chi tiết dịch vụ) với thông báo thành công
                response.sendRedirect(request.getContextPath() + "/services/list");
            } else {
                request.setAttribute("errorMessage", "Cập nhật dịch vụ thất bại. Vui lòng thử lại.");
                // Gửi lại các giá trị người dùng đã nhập để họ không phải nhập lại từ đầu
                List<String> allServiceTypes = serviceDAO.getAllDistinctServiceType();
                request.setAttribute("service", serviceToUpdate); // serviceToUpdate chứa dữ liệu người dùng đã nhập
                request.setAttribute("serviceTypes", allServiceTypes);
                request.getRequestDispatcher(jspPath).forward(request, response);
            }

        } catch (NumberFormatException e) {
             // Lỗi khi parse serviceId (nếu idParam không phải số)
            request.setAttribute("errorMessage", "ID dịch vụ không hợp lệ trong form gửi đi.");
            response.sendRedirect(request.getContextPath() + "/services?action=list&error=invalidFormId");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi hệ thống khi cập nhật dịch vụ: " + e.getMessage());
            // Cố gắng tải lại form với dữ liệu từ DB nếu có thể (nếu serviceId hợp lệ)
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