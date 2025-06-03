<style>
    #sidebar {
        width: 240px;
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        background-color: #6f42c1; /* Màu tím c? ??nh */
        color: white;
        padding: 20px;
        font-family: 'Roboto', sans-serif;
        overflow-y: auto; /* Cho phép cu?n khi quá nhi?u m?c */
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        z-index: 1000;
    }

    #sidebar h2 {
        font-size: 20px;
        color: white;
        margin-bottom: 20px;
    }

    #sidebar ul {
        list-style-type: none;
        padding-left: 0;
        margin-bottom: 20px;
    }

    #sidebar li {
        margin: 8px 0;
    }

    #sidebar li strong {
        display: block;
        margin-top: 12px;
        color: #e0d3f8;
        font-size: 14px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    #sidebar a {
        display: block;
        color: white;
        text-decoration: none;
        padding: 8px 12px;
        border-radius: 4px;
        font-weight: 500;
        background-color: transparent;
        transition: none !important;
    }

    #sidebar a:hover {
        background-color: rgba(255, 255, 255, 0.1);
        color: white;
    }

    #sidebar a.active {
        background-color: rgba(255, 255, 255, 0.2);
        color: white;
        font-weight: bold;
    }

    #sidebar hr {
        border: none;
        height: 1px;
        background-color: rgba(255, 255, 255, 0.3);
        margin: 16px 0;
    }

    .logout {
        display: inline-block;
        margin-top: 20px;
        padding: 8px 14px;
        background-color: #dc3545;
        color: white;
        text-decoration: none;
        border-radius: 5px;
    }

    .logout:hover {
        background-color: #b02a37;
    }
</style>

<div id="sidebar">
    <h2>Hotel Management</h2>

    <ul>
        <li><strong>Room Management</strong></li>
        <li><a href="${pageContext.request.contextPath}/ListRoomsServlet">View Room List</a></li>
        <li><a href="${pageContext.request.contextPath}/managerR">CRUD Rooms</a></li>
        <li><a href="#">Add Room Images</a></li>
        <li><a href="#">Amenities</a></li>
        <li><a href="#">Update Room Status</a></li>
        <li><a href="#">Booking & Lock Rooms</a></li>
        <li><a href="#">Maintenance Requests</a></li>
        <li><a href="#">Report & Statistics</a></li>
        <li><a href="#">Role Permissions</a></li>
    </ul>

    <hr>

    <ul>
        <li><strong>Staff Management</strong></li>
        <li><a href="${pageContext.request.contextPath}/activityLogs">Activity Logs</a></li>
        <li><a href="staffList.jsp">View Staff List</a></li>
        <li><a href="${pageContext.request.contextPath}/managerAccount">Manage Staff/Receptionist</a></li>
    </ul>

    <hr>

    <ul>
        <li><strong>Service & Feedback</strong></li>
        <li><a href="${pageContext.request.contextPath}/ReplyQuestionServlet">View Questions</a></li>
        <li><a href="../Manager/addService.jsp">Add Service</a></li>
        <!--<li><a href="editService.jsp">Edit Service</a></li>-->
        <li><a href="${pageContext.request.contextPath}/services/list">Service List</a></li>
        <li><a href="feedbacks.jsp">View Feedback</a></li>
    </ul>

    <hr>

    <ul>
        <li><strong>Reports</strong></li>
        <li><a href="revenueReport.jsp">View Revenue Report</a></li>
    </ul>

    <a class="logout" href="${pageContext.request.contextPath}/Logout">Logout</a>
</div>
