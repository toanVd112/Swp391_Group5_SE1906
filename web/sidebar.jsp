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
                <a href="${pageContext.request.contextPath}/managerAccount" class="menu-item" data-page="managerAccount">
                    <i class="fas fa-users"></i>
                    <span>Manage Account</span>
                </a>
                <a href="${pageContext.request.contextPath}/serviceslist" class="menu-item" data-page="serviceslist">
                    <i class="fas fa-bell"></i>
                    <span>Service List</span>
                </a>
                <a href="${pageContext.request.contextPath}/ListRoomsServlet" class="menu-item" data-page="ListRoomsServlet">
                    <i class="fas fa-building"></i>
                    <span>View Room List</span>
                </a>
            </c:if>

            <c:if test="${role eq 'Receptionist'}">
                <a href="${pageContext.request.contextPath}/sendMaintenanceRequest" class="menu-item" data-page="sendMaintenanceRequest">
                    <i class="fas fa-wrench"></i>
                    <span>View Maintenance Requests</span>
                </a>
                <a href="${pageContext.request.contextPath}/roomInspection" class="menu-item" data-page="roomInspection">
                    <i class="fas fa-clipboard-list"></i>
                    <span>Room Inspection Reports</span>
                </a>
            </c:if>

            <c:if test="${role eq 'Staff'}">
                <a href="${pageContext.request.contextPath}/layout.jsp?page=staff/maintenance.jsp" class="menu-item" data-page="staff/maintenance">
                    <i class="fas fa-wrench"></i>
                    <span>View Maintenance Requests</span>
                </a>
                <a href="${pageContext.request.contextPath}/layout.jsp?page=staff/inspection.jsp" class="menu-item" data-page="staff/inspection">
                    <i class="fas fa-clipboard-list"></i>
                    <span>Room Inspection Reports</span>
                </a>
            </c:if>
        </div>

        <!-- General Menu -->
        <hr class="menu-divider">
        <div class="menu-section">
            <div class="menu-title">General</div>
            <a href="${pageContext.request.contextPath}/layout.jsp?page=calendar.jsp" class="menu-item" data-page="calendar">
                <i class="fas fa-calendar"></i>
                <span>Calendar</span>
            </a>
            <a href="${pageContext.request.contextPath}/layout.jsp?page=messages.jsp" class="menu-item" data-page="messages">
                <i class="fas fa-envelope"></i>
                <span>Messages</span>
            </a>
            <a href="${pageContext.request.contextPath}/layout.jsp?page=settings.jsp" class="menu-item" data-page="settings">
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

<style>
    /* Enhanced Sidebar Styles with Active States */
    .sidebar {
        width: 280px;
        background: #ffffff;
        border-right: 1px solid #e5e7eb;
        display: flex;
        flex-direction: column;
        position: fixed;
        height: 100vh;
        overflow-y: auto;
        z-index: 1000;
    }

    .sidebar-header {
        padding: 1.5rem;
        border-bottom: 1px solid #e5e7eb;
        font-size: 1.125rem;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }

    .sidebar-header .text-primary {
        color: #ffffff !important;
    }

    .sidebar-content {
        flex: 1;
        padding: 1rem 0;
    }

    .menu-section {
        margin-bottom: 1.5rem;
    }

    .menu-title {
        padding: 0.5rem 1.5rem;
        font-size: 0.875rem;
        font-weight: 600;
        color: #6b7280;
        text-transform: uppercase;
        letter-spacing: 0.05em;
        margin-bottom: 0.5rem;
    }

    .menu-item {
        display: flex;
        align-items: center;
        padding: 0.875rem 1.5rem;
        color: #374151;
        text-decoration: none;
        transition: all 0.3s ease;
        position: relative;
        border-radius: 0;
        margin: 0 0.75rem;
        border-radius: 8px;
    }

    .menu-item:hover {
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #2563eb;
        text-decoration: none;
        transform: translateX(4px);
    }

    .menu-item.active {
        background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
        color: #ffffff;
        font-weight: 600;
        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
    }

    .menu-item.active::before {
        content: '';
        position: absolute;
        left: -0.75rem;
        top: 50%;
        transform: translateY(-50%);
        width: 4px;
        height: 24px;
        background: #2563eb;
        border-radius: 0 4px 4px 0;
    }

    .menu-item i {
        width: 20px;
        margin-right: 0.75rem;
        font-size: 1rem;
        transition: all 0.3s ease;
    }

    .menu-item.active i {
        color: #ffffff;
        transform: scale(1.1);
    }

    .menu-item span {
        transition: all 0.3s ease;
    }

    .menu-divider {
        margin: 1rem 1.5rem;
        border-color: #e5e7eb;
        opacity: 0.5;
    }

    .sidebar-footer {
        padding: 1rem;
        border-top: 1px solid #e5e7eb;
        background: #f9fafb;
    }

    .logout-btn {
        display: flex;
        align-items: center;
        width: 100%;
        padding: 0.875rem 1rem;
        color: #dc2626;
        text-decoration: none;
        border-radius: 8px;
        transition: all 0.3s ease;
        font-weight: 500;
    }

    .logout-btn:hover {
        background-color: #fef2f2;
        color: #dc2626;
        text-decoration: none;
        transform: translateX(4px);
    }

    .logout-btn i {
        margin-right: 0.75rem;
        transition: all 0.3s ease;
    }

    .logout-btn:hover i {
        transform: scale(1.1);
    }

    /* Responsive */
    @media (max-width: 768px) {
        .sidebar {
            transform: translateX(-100%);
            transition: transform 0.3s ease;
        }

        .sidebar.show {
            transform: translateX(0);
        }
    }

    /* Animation for menu items */
    @keyframes slideIn {
        from {
            opacity: 0;
            transform: translateX(-10px);
        }
        to {
            opacity: 1;
            transform: translateX(0);
        }
    }

    .menu-item {
        animation: slideIn 0.3s ease forwards;
    }

    .menu-item:nth-child(1) {
        animation-delay: 0.1s;
    }
    .menu-item:nth-child(2) {
        animation-delay: 0.2s;
    }
    .menu-item:nth-child(3) {
        animation-delay: 0.3s;
    }
    .menu-item:nth-child(4) {
        animation-delay: 0.4s;
    }
    .menu-item:nth-child(5) {
        animation-delay: 0.5s;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Get current page info
        const currentPath = window.location.pathname;
        const currentSearch = window.location.search;
        const currentUrl = currentPath + currentSearch;

        // Get all menu items
        const menuItems = document.querySelectorAll('.menu-item');

        // Function to set active menu item
        function setActiveMenuItem() {
            // Remove active class from all items
            menuItems.forEach(item => {
                item.classList.remove('active');
            });

            // Find and set active item
            let activeItem = null;

            // Check for exact URL match first
            menuItems.forEach(item => {
                const href = item.getAttribute('href');
                if (href && currentUrl.includes(href.split('/').pop())) {
                    activeItem = item;
                }
            });

            // If no exact match, check by data-page attribute
            if (!activeItem) {
                menuItems.forEach(item => {
                    const dataPage = item.getAttribute('data-page');
                    if (dataPage && (currentPath.includes(dataPage) || currentSearch.includes(dataPage))) {
                        activeItem = item;
                    }
                });
            }

            // Set active class
            if (activeItem) {
                activeItem.classList.add('active');
            }
        }

        // Set active menu item on page load
        setActiveMenuItem();

        // Add click event listeners to menu items
        menuItems.forEach(item => {
            item.addEventListener('click', function (e) {
                // Remove active class from all items
                menuItems.forEach(menuItem => {
                    menuItem.classList.remove('active');
                });

                // Add active class to clicked item
                this.classList.add('active');

                // Store active item in localStorage for persistence
                const dataPage = this.getAttribute('data-page');
                if (dataPage) {
                    localStorage.setItem('activePage', dataPage);
                }
            });
        });

        // Restore active state from localStorage if available
        const storedActivePage = localStorage.getItem('activePage');
        if (storedActivePage) {
            const storedItem = document.querySelector(`[data-page="${storedActivePage}"]`);
            if (storedItem && !document.querySelector('.menu-item.active')) {
                storedItem.classList.add('active');
            }
        }
    });

// Function to manually set active menu item (can be called from other pages)
    function setActiveMenu(pageName) {
        const menuItems = document.querySelectorAll('.menu-item');
        menuItems.forEach(item => {
            item.classList.remove('active');
            if (item.getAttribute('data-page') === pageName) {
                item.classList.add('active');
            }
        });
        localStorage.setItem('activePage', pageName);
    }
</script>