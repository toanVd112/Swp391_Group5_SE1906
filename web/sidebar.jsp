<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar">
    <!-- Sidebar Header -->
    <div class="sidebar-header">
        <div class="d-flex align-items-center">
        
        </div>
    </div>

    <!-- Sidebar Content -->
    <div class="sidebar-content">
        <!-- Role-based Menu -->
        <div class="menu-section">
            <div class="menu-title">${role}</div>

            <c:if test="${role eq 'Manager'}">
                <a href="${pageContext.request.contextPath}/managerAccount"  class="menu-item">👥 Manage Account</a>
                <i class="fas fa-users"></i>
              
                </a>
                <a href="${pageContext.request.contextPath}/serviceslist"  class="menu-item">🔔 Service List </a>
                <i class="fas fa-bell"></i>
               
                </a>
                <a href="${pageContext.request.contextPath}/ListRoomsServlet"  class="menu-item">📋 View Room List</a>
                <i class="fas fa-building"></i>
              
                </a>
            </c:if>

            <c:if test="${role eq 'Receptionist'}">
                <a href="${pageContext.request.contextPath}/layout.jsp?page=receptionist/maintenance.jsp" class="menu-item">
                    <i class="fas fa-wrench"></i>
                    <span>View Maintenance Requests</span>
                </a>
                <a href="${pageContext.request.contextPath}/layout.jsp?page=receptionist/inspection.jsp" class="menu-item">
                    <i class="fas fa-clipboard-list"></i>
                    <span>Room Inspection Reports</span>
                </a>
            </c:if>

            <c:if test="${role eq 'Staff'}">
                <a href="${pageContext.request.contextPath}/layout.jsp?page=staff/maintenance.jsp" class="menu-item">
                    <i class="fas fa-wrench"></i>
                    <span>View Maintenance Requests</span>
                </a>
                <a href="${pageContext.request.contextPath}/layout.jsp?page=staff/inspection.jsp" class="menu-item">
                    <i class="fas fa-clipboard-list"></i>
                    <span>Room Inspection Reports</span>
                </a>
            </c:if>
        </div>

        <!-- General Menu -->
        <hr class="menu-divider">
        <div class="menu-section">
            <div class="menu-title">General</div>
            <a href="${pageContext.request.contextPath}/layout.jsp?page=calendar.jsp" class="menu-item">
                <i class="fas fa-calendar"></i>
                <span>Calendar</span>
            </a>
            <a href="${pageContext.request.contextPath}/layout.jsp?page=messages.jsp" class="menu-item">
                <i class="fas fa-envelope"></i>
                <span>Messages</span>
            </a>
            <a href="${pageContext.request.contextPath}/layout.jsp?page=settings.jsp" class="menu-item">
                <i class="fas fa-cog"></i>
                <span>Settings</span>
            </a>
        </div>
    </div>

    <!-- Sidebar Footer -->
    <div class="sidebar-footer">
        <a href="${pageContext.request.contextPath}/Logout" class="logout-btn">
            <i class="fas fa-sign-out-alt"></i>
            <span>Logout</span>
        </a>
    </div>
</div>