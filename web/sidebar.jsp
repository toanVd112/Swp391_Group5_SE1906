<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar">
    <div class="menu-grid">
        <c:if test="${role eq 'Manager'}">
            <div class="menu-title">Manager</div>
            <a href="${pageContext.request.contextPath}/managerAccount">👥 Manage Account</a>
            <a href="${pageContext.request.contextPath}/layout.jsp?page=serviceList.jsp">🔔 Service List</a>
            <a href="${pageContext.request.contextPath}/ListRoomsServlet">📋 View Room List</a>
        </c:if>

        <c:if test="${role eq 'Receptionist'}">
            <div class="menu-title">Receptionist</div>
            <a href="${pageContext.request.contextPath}/layout.jsp?page=pendingMaintenance.jsp">🛠 View Maintenance Requests</a>
            <a href="${pageContext.request.contextPath}/layout.jsp?page=pendingCheckoutRequests.jsp">📋 Room Inspection Reports</a>
        </c:if>

        <c:if test="${role eq 'Staff'}">
            <div class="menu-title">Staff</div>
            <a href="${pageContext.request.contextPath}/layout.jsp?page=pendingMaintenance.jsp">🛠 View Maintenance Requests</a>
            <a href="${pageContext.request.contextPath}/layout.jsp?page=pendingCheckoutRequests.jsp">📋 Room Inspection Reports</a>
        </c:if>

        <hr style="border-color: #3b82f6; margin: 20px 0;">
        <a class="logout" href="${pageContext.request.contextPath}/Logout">🚪 Logout</a>
    </div>
</div>
