<%@ page import="java.util.*, model.Booking, model.InvoiceData" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
//    List<Booking> completedBookings = (List<Booking>) request.getAttribute("completedBookings");
//    InvoiceData invoiceData = (InvoiceData) request.getAttribute("invoiceData");
%>

<html>
<head>
    <meta charset="UTF-8">
    <title>Create Invoice</title>
    <style>
        label { font-weight: bold; display: block; margin-top: 10px; }
        input[readonly], .readonly { background-color: #f0f0f0; }
        .section { border: 1px solid #ccc; padding: 15px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <h2>Create Invoice</h2>

    <form method="get" action="CreateInvoice.jsp">
        <label>Select Completed Booking:</label>
        <select name="bookingId" onchange="this.form.submit()">
            <option value="">-- Select --</option>
            <c:forEach var="b" items="${completedBookings}">
                <option value="${b.bookingId}" 
                    <c:if test="${invoiceData != null && invoiceData.bookingId == b.bookingId}">selected</c:if>>
                    #${b.bookingId} - ${b.customerName} (${b.checkOutDate})
                </option>
            </c:forEach>
        </select>
    </form>

    <c:if test="${invoiceData != null}">
        <form method="post" action="CreateInvoiceServlet">
            <div class="section">
                <label>Booking ID:</label>
                <input type="text" name="bookingId" value="${invoiceData.bookingId}" readonly />

                <label>Customer Name:</label>
                <input type="text" class="readonly" value="${invoiceData.customerName}" readonly />

                <label>Invoice Date:</label>
                <input type="text" class="readonly" value="${invoiceData.issuedDate}" readonly />

                <label>Room Total:</label>
                <input type="text" class="readonly" value="${invoiceData.roomTotal} VND" readonly />

                <label>Service Total:</label>
                <input type="text" class="readonly" value="${invoiceData.serviceTotal} VND" readonly />

                <c:if test="${invoiceData.discountCode != null}">
                    <label>Discount Code:</label>
                    <input type="text" class="readonly" value="${invoiceData.discountCode} (-${invoiceData.discountPercent}%)" readonly />
                </c:if>

                <label><strong>Final Total:</strong></label>
                <input type="text" class="readonly" value="${invoiceData.totalAmount} VND" readonly />
            </div>

            <div class="section">
                <label>Payment Status:</label>
                <select name="paymentStatus" required>
                    <option value="PAID">Paid</option>
                    <option value="UNPAID">Unpaid</option>
                </select>

                <label>Note:</label>
                <textarea name="note" rows="3" cols="40"></textarea>
            </div>

            <input type="submit" value="Create Invoice" />
        </form>
    </c:if>
</body>
</html>
