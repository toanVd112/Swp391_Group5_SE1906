<%@ page import="model.Account" %>

<style>
    #sidebar {
        width: 240px;
        position: fixed;
        top: 0;
        bottom: 0;
        left: 0;
        background-color: #6f42c1;
        color: white;
        padding: 20px;
        overflow-y: auto;
        box-shadow: 2px 0 10px rgba(0, 0, 0, 0.1);
        z-index: 1000;
        font-family: 'Roboto', sans-serif;
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
        margin-top: 14px;
        font-size: 13px;
        color: #ecf0f1;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    #sidebar a {
        display: block;
        color: white;
        text-decoration: none;
        padding: 8px 12px;
        border-radius: 4px;
        background-color: transparent;
        font-weight: 500;
        transition: none !important;
    }

    #sidebar a:hover {
        background-color: rgba(255, 255, 255, 0.1);
    }

    #sidebar a.active {
        background-color: rgba(255, 255, 255, 0.2);
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
    <h2>Welcome, <%= account.getUsername() %> (Receptionist)</h2>

    <ul>
        <li><strong>?? Room & Booking</strong></li>
        <li><a href="${pageContext.request.contextPath}/ListRoomsServlet">View Room List</a></li>
        <li><a href="bookingList.jsp">View Booking List</a></li>
        <li><a href="addBooking.jsp">Add Booking</a></li>
        <li><a href="editBooking.jsp">Edit Booking</a></li>
        <li><a href="searchGuests.jsp">Search Guests</a></li>
    </ul>

    <hr>

    <ul>
        <li><strong>? Customer Profile</strong></li>
        <li><a href="#">Profile Customer</a></li>
    </ul>

    <hr>

    <ul>
        <li><strong>?? Services</strong></li>
        <li><a href="services.jsp">Services</a></li>
        <li><a href="addService.jsp">Add Services</a></li>
        <li><a href="editService.jsp">Edit Services</a></li>
    </ul>

    <hr>

    <ul>
        <li><strong>? Others</strong></li>
        <li><a href="viewSurcharge.jsp">View Surcharge</a></li>
        <li><a href="brokenItem.jsp">Broken Items</a></li>
        <li><a href="createInvoice.jsp">Create Invoice</a></li>
    </ul>

    <a class="logout" href="${pageContext.request.contextPath}/LogoutServlet">Logout</a>
</div>
