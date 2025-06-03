<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Account" %>
<%@ page import="DAO.ServiceDAO" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("id"));
    new ServiceDAO().toggleStatus(id);
    response.sendRedirect("ServiceList.jsp");
%>