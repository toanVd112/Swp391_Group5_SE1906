package controller.tuan;

import DAO.ServiceDAO;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Service;

@WebServlet("/services")
public class ServiceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            ServiceDAO dao = new ServiceDAO();

            switch (action) {
                case "add":
                    request.getRequestDispatcher("Manager/addService.jsp").forward(request, response);
                    break;
                case "edit":
                    int id = Integer.parseInt(request.getParameter("id"));
                    Service s = dao.getById(id);
                    request.setAttribute("service", s);
                    request.getRequestDispatcher("Manager/editService.jsp").forward(request, response);
                    break;
                case "delete":
                    int deleteId = Integer.parseInt(request.getParameter("id"));
                    dao.delete(deleteId);
                    response.sendRedirect("services");
                    break;
                default:
                    List<Service> list = dao.getAll();
                    request.setAttribute("services", list);
                    request.getRequestDispatcher("Manager/listServices.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException("SQL Error: " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ServletException("Error: " + e.getMessage(), e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            ServiceDAO dao = new ServiceDAO();
            String idStr = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            double price = Double.parseDouble(request.getParameter("price"));
            boolean status = "1".equals(request.getParameter("status"));

            Service s = new Service();
            s.setServiceName(name);
            s.setDescription(description);
            s.setPrice(price);
            s.setStatus(status);

            if (idStr == null || idStr.isEmpty()) {
                dao.insert(s);
            } else {
                s.setServiceID(Integer.parseInt(idStr));
                dao.update(s);
            }

            response.sendRedirect("services");
        } catch (SQLException e) {
            throw new ServletException("SQL Error: " + e.getMessage(), e);
        } catch (Exception e) {
            throw new ServletException("Error: " + e.getMessage(), e);
        }
    }

    @Override
    public String getServletInfo() {
        return "Service management servlet";
    }
}
