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
        <form id="editDiscountForm" method="POST" action="${pageContext.request.contextPath}/discountcodes/edit">
            <input type="hidden" name="id" id="id" value="${discountCode.discountCodeID}">
            <div class="mb-3">
                <label for="code" class="form-label">Code</label>
                <input type="text" class="form-control" id="code" name="code" maxlength="50" value="${discountCode.code}" required pattern="[A-Za-z0-9]+">
                <div class="invalid-feedback">Code must be alphanumeric, up to 50 characters.</div>
            </div>
            <div class="mb-3">
                <label for="discountPercent" class="form-label">Discount Value</label>
                <input type="number" step="0.01" min="0" class="form-control" id="discountPercent" name="discountPercent" value="${discountCode.discountPercent}" required>
                <div class="invalid-feedback" id="discountPercentFeedback">Discount must be valid.</div>
            </div>
            <div class="mb-3">
                <label for="expiryDate" class="form-label">Expiry Date</label>
                <input type="date" class="form-control" id="expiryDate" name="expiryDate" value="${discountCode.expiryDate}" required>
                <div class="invalid-feedback">Expiry date must be today or later.</div>
            </div>
            <div class="mb-3">
                <label for="type" class="form-label">Type</label>
                <select class="form-select" id="type" name="type" required>
                    <option value="1" ${discountCode.type == '1' ? 'selected' : ''}>Percentage</option>
                    <option value="2" ${discountCode.type == '2' ? 'selected' : ''}>Fixed Amount</option>
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
    <script>
        const typeSelect = document.getElementById('type');
        const discountPercentInput = document.getElementById('discountPercent');
        const discountPercentFeedback = document.getElementById('discountPercentFeedback');

        // Update discountPercent validation based on type
        function updateDiscountValidation() {
            if (typeSelect.value === '1') {
                discountPercentInput.setAttribute('max', '99');
                discountPercentFeedback.textContent = 'Discount must be between 0.00 and 99.00 for Percentage.';
            } else {
                discountPercentInput.setAttribute('max', '999.999');
                discountPercentFeedback.textContent = 'Discount must be between 0.00 and 999.999 for Fixed Amount.';
            }
        }

        // Initialize validation on page load
        updateDiscountValidation();

        // Update validation when type changes
        typeSelect.addEventListener('change', updateDiscountValidation);

        // Form submission validation
        document.getElementById('editDiscountForm').addEventListener('submit', function(event) {
            const code = document.getElementById('code').value.trim();
            const discountPercent = parseFloat(discountPercentInput.value);
            const expiryDate = new Date(document.getElementById('expiryDate').value);
            const today = new Date();
            today.setHours(0, 0, 0, 0);

            let isValid = true;

            // Validate code
            if (!/^[A-Za-z0-9]+$/.test(code) || code.length > 50 || code.length === 0) {
                document.getElementById('code').classList.add('is-invalid');
                isValid = false;
            } else {
                document.getElementById('code').classList.remove('is-invalid');
            }

            // Validate discountPercent based on type
            if (isNaN(discountPercent) || discountPercent < 0) {
                discountPercentInput.classList.add('is-invalid');
                isValid = false;
            } else if (typeSelect.value === '1' && discountPercent > 99) {
                discountPercentInput.classList.add('is-invalid');
                discountPercentFeedback.textContent = 'Discount must be between 0.00 and 99.00 for Percentage.';
                isValid = false;
            } else if (typeSelect.value === '2' && discountPercent > 999.99) {
                discountPercentInput.classList.add('is-invalid');
                discountPercentFeedback.textContent = 'Discount must be between 0.00 and 999.99 for Fixed Amount.';
                isValid = false;
            } else {
                discountPercentInput.classList.remove('is-invalid');
            }

            // Validate expiryDate
            if (isNaN(expiryDate.getTime()) || expiryDate < today) {
                document.getElementById('expiryDate').classList.add('is-invalid');
                isValid = false;
            } else {
                document.getElementById('expiryDate').classList.remove('is-invalid');
            }

            if (!isValid) {
                event.preventDefault();
            }
        });
    </script>
</body>
</html>