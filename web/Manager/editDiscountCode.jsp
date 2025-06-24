<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.Account" %>

<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Discount Code</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <h2>Edit Discount Code</h2>
        <form method="POST" action="${pageContext.request.contextPath}/discountcodes/edit">
            <input type="hidden" name="id" value="${discountCode.discountCodeID}">
            <div class="mb-3">
                <label for="code" class="form-label">Code</label>
                <input type="text" class="form-control" id="code" name="code" value="${discountCode.code}" required>
            </div>
            <div class="mb-3">
                <label for="discountPercent" class="form-label">Discount Value</label>
                <input type="number" step="0.01" class="form-control" id="discountPercent" name="discountPercent" value="${discountCode.discountPercent}" required>
            </div>
            <div class="mb-3">
                <label for="expiryDate" class="form-label">Expiry Date</label>
                <input type="date" class="form-control" id="expiryDate" name="expiryDate" value="${discountCode.expiryDate}" required>
            </div>
            <div class="mb-3">
                <label for="type" class="form-label">Type</label>
                <select class="form-select" id="type" name="type" required>
                    <option value="1" ${discountCode.type == '1' ? 'selected' : ''}>Percentage (%)</option>
                    <option value="2" ${discountCode.type == '2' ? 'selected' : ''}>Fixed Amount (VND)</option>
                </select>
            </div>
            <div class="mb-3">
                <label for="status" class="form-label">Status</label>
                <select class="form-select" id="status" name="status" required>
                    <option value="Active" ${discountCode.status == 'Active' ? 'selected' : ''}>Active</option>
                    <option value="Inactive" ${discountCode.status == 'Inactive' ? 'selected' : ''}>Inactive</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Update</button>
            <a href="${pageContext.request.contextPath}/discountcodes/list" class="btn btn-secondary">Cancel</a>
        </form>

        <c:if test="${not empty msg}">
            <script>
                alert("${msg}");
            </script>
        </c:if>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>