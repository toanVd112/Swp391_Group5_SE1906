<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="sidebar">
    <!-- Sidebar Header -->
    <div class="sidebar-header">
        <div class="d-flex align-items-center">
            <span class="text-primary">Hotel Management</span>
        </div>
    </div>

    <!-- Sidebar Content -->
    <div class="sidebar-content">
        <!-- Role-based Menu -->
        <div class="menu-section">
            <div class="menu-title">${role}</div>
            <a href="${pageContext.request.contextPath}/Manager/manager.jsp" class="menu-item" data-page="Dashboard">
                <i class="fas fa-users"></i>
                <span>Dashboard</span>
            </a>
            <c:if test="${role eq 'Manager'}">
                <a href="${pageContext.request.contextPath}/managerAccount" class="menu-item" data-page="managerAccount">
                    <i class="fas fa-users"></i>
                    <span>Manage Account</span>
                </a>
                <a href="${pageContext.request.contextPath}/serviceslist" class="menu-item" data-page="serviceslist">
                    <i class="fas fa-bell"></i>
                    <span>Service List</span>
                </a>
                <a href="${pageContext.request.contextPath}/discountcodes/list" class="menu-item" data-page="discountcodeslist">
                    <i class="fas fa-tag"></i>
                    <span>Discount Code List</span>
                </a>
                <a href="${pageContext.request.contextPath}/roomoccupancy" class="menu-item" data-page="roomoccupancy">
                    <i class="fas fa-chart-bar"></i>
                    <span>Room Occupancy</span>
                </a>
                <a href="${pageContext.request.contextPath}/revenuestats" class="menu-item" data-page="revenuestats">
                    <i class="fas fa-chart-line"></i>
                    <span>Revenue Statistics</span>
                </a>
                <a href="${pageContext.request.contextPath}/ListRoomsServlet" class="menu-item" data-page="ListRoomsServlet">
                    <i class="fas fa-building"></i>
                    <span>View Room Status</span>
                </a>
                <a href="${pageContext.request.contextPath}/RoomTypeListServlet" class="menu-item" data-page="RoomTypeList">
                    <i class="fas fa-list"></i>
                    <span>View Room Types</span>
                </a>
            </c:if>

            <c:if test="${role eq 'Receptionist'}">
                <a href="${pageContext.request.contextPath}/bookingList" class="menu-item" data-page="bookingList">
                    <i class="fas fa-clipboard-list"></i>
                    <span>Booking List</span>
                </a>
                <a href="${pageContext.request.contextPath}/managerAccountC" class="menu-item" data-page="managerAccountC">
                    <i class="fas fa-clipboard-list"></i>
                    <span>View Account Customer</span>
                </a>
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
                <a href="${pageContext.request.contextPath}/pendingMaintenance" class="menu-item" data-page="staff/maintenance">
                    <i class="fas fa-wrench"></i>
                    <span>View Maintenance Requests</span>
                </a>
                <a href="${pageContext.request.contextPath}/pendingCheckout" class="menu-item" data-page="staff/inspection">
                    <i class="fas fa-clipboard-list"></i>
                    <span>Room Inspection Reports</span>
                </a>
            </c:if>

            <!-- Statistics Menu -->
            <div class="menu-item dropdown" data-page="statistics">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    <i class="fas fa-chart-pie"></i>
                    <span>Statistics</span>
                    <i class="fas fa-chevron-down dropdown-icon"></i>
                </a>
                <div class="dropdown-menu">
                    <c:if test="${role eq 'Manager'}">
                        <a href="${pageContext.request.contextPath}/revenuestats" class="dropdown-item" data-page="revenuestats">
                            <i class="fas fa-chart-line"></i>
                            <span>Revenue Statistics</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/roomoccupancy" class="dropdown-item" data-page="roomoccupancy">
                            <i class="fas fa-chart-bar"></i>
                            <span>Room Occupancy</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/bookingtrends" class="dropdown-item" data-page="bookingtrends">
                            <i class="fas fa-chart-area"></i>
                            <span>Booking Trends</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/customerdemographics" class="dropdown-item" data-page="customerdemographics">
                            <i class="fas fa-users"></i>
                            <span>Customer Demographics</span>
                        </a>
                    </c:if>
                    <c:if test="${role eq 'Receptionist'}">
                        <a href="${pageContext.request.contextPath}/bookingtrends" class="dropdown-item" data-page="bookingtrends">
                            <i class="fas fa-chart-area"></i>
                            <span>Booking Trends</span>
                        </a>
                        <a href="${pageContext.request.contextPath}/customerdemographics" class="dropdown-item" data-page="customerdemographics">
                            <i class="fas fa-users"></i>
                            <span>Customer Demographics</span>
                        </a>
                    </c:if>
                    <c:if test="${role eq 'Staff'}">
                        <a href="${pageContext.request.contextPath}/maintenancestats" class="dropdown-item" data-page="maintenancestats">
                            <i class="fas fa-wrench"></i>
                            <span>Maintenance Statistics</span>
                        </a>
                    </c:if>
                </div>
            </div>
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
        padding-left: 1rem;
    }

    .menu-item {
        display: flex;
        align-items: center;
        padding: 0.875rem 1.5rem;
        color: #374151;
        text-decoration: none;
        transition: all 0.3s ease;
        position: relative;
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

    /* Dropdown Styles */
    .dropdown {
        position: relative;
    }

    .dropdown-toggle {
        display: flex;
        align-items: center;
        width: 100%;
        text-decoration: none;
        color: #374151;
        /*        padding: 0.875rem 1.5rem;
                margin: 0 0.75rem;*/
        border-radius: 8px;
        transition: all 0.3s ease;
    }

    .dropdown-toggle:hover {
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #2563eb;
        text-decoration: none;
        transform: translateX(4px);
    }

    .dropdown-toggle i:not(.dropdown-icon) {
        width: 20px;
        margin-right: 0.75rem;
        font-size: 1rem;
    }

    .dropdown-toggle span {
        flex-grow: 1;
        text-align: left;
    }

    .dropdown-toggle .dropdown-icon {
        margin-left: auto;
        font-size: 0.875rem;
        transition: transform 0.3s ease;
    }

    .dropdown:hover .dropdown-icon {
        transform: rotate(180deg);
    }

    .dropdown:hover .dropdown-menu {
        display: block;
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
        transition: opacity 0.2s ease, visibility 0s linear 0s, transform 0.2s ease;
    }

    .dropdown-menu {
        display: block;
        opacity: 0;
        visibility: hidden;
        position: absolute;
        background: #ffffff;
        margin-left: 1rem;
        padding: 0.5rem 0;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        z-index: 1001;
        min-width: 200px;
        transform: translateY(-10px);
        transition: opacity 0.2s ease, visibility 0s linear 0.2s, transform 0.2s ease;
    }

    .dropdown-item {
        display: flex;
        align-items: center;
        padding: 0.75rem 1.5rem;
        color: #374151;
        text-decoration: none;
        transition: all 0.3s ease;
    }

    .dropdown-item:hover {
        background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%);
        color: #2563eb;
        transform: translateX(4px);
    }

    .dropdown-item.active {
        background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
        color: #ffffff;
        font-weight: 600;
    }

    .dropdown-item i {
        width: 20px;
        margin-right: 0.75rem;
        font-size: 1rem;
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

        .dropdown-menu {
            position: relative;
            width: 100%;
            margin-left: 0;
            transform: none;
        }

        .dropdown:hover .dropdown-menu {
            transform: none;
        }
    }

    /* Animations */
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

    .menu-item, .dropdown-item {
        animation: slideIn 0.3s ease forwards;
    }

    .menu-item:nth-child(1), .dropdown-item:nth-child(1) {
        animation-delay: 0.1s;
    }
    .menu-item:nth-child(2), .dropdown-item:nth-child(2) {
        animation-delay: 0.2s;
    }
    .menu-item:nth-child(3), .dropdown-item:nth-child(3) {
        animation-delay: 0.3s;
    }
    .menu-item:nth-child(4), .dropdown-item:nth-child(4) {
        animation-delay: 0.4s;
    }
    .menu-item:nth-child(5), .dropdown-item:nth-child(5) {
        animation-delay: 0.5s;
    }
</style>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Get current page info
        const currentPath = window.location.pathname;
        const currentSearch = window.location.search;

        // Get all menu items
        const menuItems = document.querySelectorAll('.menu-item, .dropdown-item');

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
                if (href && href !== '#' && currentPath === new URL(href, window.location.origin).pathname) {
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
                // If the active item is a dropdown-item, also activate the parent dropdown
                const parentDropdown = activeItem.closest('.dropdown');
                if (parentDropdown) {
                    parentDropdown.querySelector('.dropdown-toggle').classList.add('active');
                    // Ensure dropdown is visible for active item
                    parentDropdown.classList.add('show');
                }
            }
        }

        // Set active menu item on page load
        setActiveMenuItem();

        // Add click event listeners to menu items
        menuItems.forEach(item => {
            item.addEventListener('click', function (e) {
                if (this.classList.contains('dropdown-toggle')) {
                    return; // Prevent default behavior for dropdown toggles
                }

                // Remove active class from all items
                menuItems.forEach(menuItem => {
                    menuItem.classList.remove('active');
                });

                // Add active class to clicked item
                this.classList.add('active');

                // If the clicked item is a dropdown-item, activate the parent dropdown
                const parentDropdown = this.closest('.dropdown');
                if (parentDropdown) {
                    parentDropdown.querySelector('.dropdown-toggle').classList.add('active');
                }

                // Store active item in localStorage
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
            if (storedItem && !document.querySelector('.menu-item.active, .dropdown-item.active')) {
                storedItem.classList.add('active');
                const parentDropdown = storedItem.closest('.dropdown');
                if (parentDropdown) {
                    parentDropdown.querySelector('.dropdown-toggle').classList.add('active');
                    parentDropdown.classList.add('show');
                }
            }
        }

        // Function to manually set active menu item
        window.setActiveMenu = function (pageName) {
            menuItems.forEach(item => {
                item.classList.remove('active');
                if (item.getAttribute('data-page') === pageName) {
                    item.classList.add('active');
                    const parentDropdown = item.closest('.dropdown');
                    if (parentDropdown) {
                        parentDropdown.querySelector('.dropdown-toggle').classList.add('active');
                        parentDropdown.classList.add('show');
                    }
                }
            });
            localStorage.setItem('activePage', pageName);
        };

        // Ensure dropdowns with active items are visible on load
        const activeDropdownItem = document.querySelector('.dropdown-item.active');
        if (activeDropdownItem) {
            const parentDropdown = activeDropdownItem.closest('.dropdown');
            if (parentDropdown) {
                parentDropdown.classList.add('show');
            }
        }
    });
</script>