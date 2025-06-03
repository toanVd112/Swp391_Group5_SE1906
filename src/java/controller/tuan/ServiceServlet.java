// src/main/java/com/example/controller/ServiceServlet.java
package controller.tuan;

import DAO.ServiceDAO;
import model.Service;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/services") // URL mapping cho servlet
public class ServiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ServiceDAO serviceDAO;

    public void init() {
        serviceDAO = new ServiceDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Mặc định là hiển thị danh sách
        }

        try {
            switch (action) {
                // Thêm các case cho "new", "insert", "delete", "edit", "update" sau
                // case "new":
                //     showNewForm(request, response);
                //     break;
                // case "insert":
                //     insertService(request, response);
                //     break;
                // case "delete":
                //     deleteService(request, response);
                //     break;
                // case "edit":
                //     showEditForm(request, response);
                //     break;
                // case "update":
                //     updateService(request, response);
                //     break;
                default:
                    listServices(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiện tại POST sẽ gọi doGet, bạn có thể tách riêng logic sau
        doGet(request, response);
    }

    private void listServices(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {

        String searchTerm = request.getParameter("search");
        String filterServiceType = request.getParameter("serviceType");
        String filterStatus = request.getParameter("status");

        int currentPage = 1;
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }
        int recordsPerPage = 5; // Số bản ghi trên mỗi trang (có thể cấu hình)

        int[] totalRecordsArray = new int[1]; // Dùng mảng để truyền tham chiếu
        List<Service> listService = serviceDAO.getServices(searchTerm, filterServiceType, filterStatus, currentPage, recordsPerPage, totalRecordsArray);
        int totalRecords = totalRecordsArray[0];

        int totalPages = (int) Math.ceil((double) totalRecords / recordsPerPage);

        List<String> serviceTypes = serviceDAO.getDistinctServiceTypes();
        List<String> statuses = serviceDAO.getDistinctStatuses();


        request.setAttribute("listService", listService);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("recordsPerPage", recordsPerPage); // Cần để tính toán số thứ tự item

        // Gửi lại các giá trị filter và search để giữ trạng thái trên form
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("selectedServiceType", filterServiceType);
        request.setAttribute("selectedStatus", filterStatus);
        request.setAttribute("serviceTypes", serviceTypes);
        request.setAttribute("statuses", statuses);

        RequestDispatcher dispatcher = request.getRequestDispatcher("services.jsp");
        dispatcher.forward(request, response);
    }

    // Các phương thức cho CRUD (showNewForm, insertService, ...) sẽ được định nghĩa ở đây
    // Ví dụ:
    // private void showNewForm(HttpServletRequest request, HttpServletResponse response)
    //         throws ServletException, IOException {
    //     RequestDispatcher dispatcher = request.getRequestDispatcher("service-form.jsp");
    //     dispatcher.forward(request, response);
    // }
}