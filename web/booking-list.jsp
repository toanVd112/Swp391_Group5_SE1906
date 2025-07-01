<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.BooKinglist" %>
<%@ page import="java.util.List" %>

<html>
<head>
    <title>Booking List</title>
    <style>
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; }
        th { background-color: #f2f2f2; }
    </style>
</head>
<body>
<h2>Booking List</h2>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Booking Date</th>
        <th>Check-In</th>
        <th>Check-Out</th>
        <th>Status</th>
        <th>Customer</th>
        <th>Email</th>
        <th>Phone</th>
        <th>Room Type</th>
        <th>Room Number</th>
        <th>Quantity</th>
        <th>Guests</th>
        <th>Discount Code</th>
        <th>Notes</th>
    </tr>
    </thead>
    <tbody>
    <%
        List<BooKinglist> bookings = (List<BooKinglist>) request.getAttribute("bookings");
        if (bookings != null) {
            for (BooKinglist b : bookings) {
    %>
    <tr>
        <td><%= b.getBookingID() %></td>
        <td><%= b.getBookingDate() %></td>
        <td><%= b.getCheckInDate() %></td>
        <td><%= b.getCheckOutDate() %></td>
        <td><%= b.getStatus() %></td>
        <td><%= b.getFullName() %></td>
        <td><%= b.getContactEmail() %></td>
        <td><%= b.getContactPhone() %></td>
        <td><%= b.getRoomTypeName() %></td>
        <td><%= b.getRoomNumber() != null ? b.getRoomNumber() : "-" %></td>
        <td><%= b.getQuantity() %></td>
        <td><%= b.getGuestsCount() %></td>
        <td><%= b.getDiscountCode() != null ? b.getDiscountCode() : "-" %></td>
        <td><%= b.getNotes() != null ? b.getNotes() : "-" %></td>
    </tr>
    <% } } %>
    </tbody>
</table>

</body>
</html>
