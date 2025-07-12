<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Account" %>
<%@ page import="DAO.ServiceDAO" %>
<%@ page import="java.util.List" %>

<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    List<String> types = new ServiceDAO().getAllDistinctServiceType();
    request.setAttribute("serviceTypes", types);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Service</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: flex-start;
            min-height: 100vh;
            padding: 40px 20px;
        }
        .container {
            background: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 800px;
        }
        h2 {
            text-align: center;
            margin-bottom: 30px;
        }
        .form-container {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }
        .form-column {
            flex: 1;
            min-width: 280px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
        }
        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 15px;
        }
        input[type="submit"] {
            width: 100%;
            background: #007bff;
            color: #fff;
            border: none;
            padding: 12px;
            border-radius: 5px;
            font-size: 16px;
            cursor: pointer;
        }
        input[type="submit"]:hover {
            background: #0056b3;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            text-decoration: none;
            color: #007bff;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .error-message {
            background: #f8d7da;
            color: #721c24;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .input-error {
            border-color: #dc3545;
        }
        @media (max-width: 600px) {
            .form-column {
                min-width: 100%;
            }
        }
    </style>

    <script>
        async function isDupeServiceName(name) {
            try {
                const response = await fetch('${pageContext.request.contextPath}/services/dupe', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({ data: name })
                });
                if (!response.ok) throw new Error('API response error');
                return await response.json();
            } catch (err) {
                console.error(err);
                return false;
            }
        }

        async function validateForm(form) {
            let valid = true;
            let messages = [];

            const nameEl = document.getElementById("name");
            const priceEl = document.getElementById("price");
            const unitEl = document.getElementById("unit");
            const typeEl = document.getElementById("serviceType");
            const descEl = document.getElementById("description");
            const imageEl = document.getElementById("serviceImage");

            document.querySelectorAll(".input-error").forEach(e => e.classList.remove("input-error"));

            const name = nameEl.value.trim();
            const price = priceEl.value.trim();
            const unit = unitEl.value.trim();
            const type = typeEl.value.trim();
            const desc = descEl.value.trim();
            const image = imageEl.value.trim();

            const namePattern = /^[\w\s-]{3,100}$/;

            if (!name) {
                nameEl.classList.add("input-error");
                messages.push("Tên dịch vụ không được để trống.");
                valid = false;
            } else if (!namePattern.test(name)) {
                nameEl.classList.add("input-error");
                messages.push("Tên dịch vụ phải từ 3-100 ký tự, chỉ chứa chữ, số, dấu cách, gạch ngang/gạch dưới.");
                valid = false;
            } else if (await isDupeServiceName(name)) {
                nameEl.classList.add("input-error");
                messages.push("Tên dịch vụ đã tồn tại.");
                valid = false;
            }

            if (!price || isNaN(price) || price <= 0) {
                priceEl.classList.add("input-error");
                messages.push("Giá phải là số lớn hơn 0.");
                valid = false;
            }

            if (!unit) {
                unitEl.classList.add("input-error");
                messages.push("Đơn vị không được để trống.");
                valid = false;
            }

            if (!type) {
                typeEl.classList.add("input-error");
                messages.push("Phải chọn loại dịch vụ.");
                valid = false;
            }

            if (desc.length > 1000) {
                descEl.classList.add("input-error");
                messages.push("Mô tả không vượt quá 1000 ký tự.");
                valid = false;
            }

            if (image) {
                const imgPattern = /(\.jpg|\.jpeg|\.png|\.gif)$/i;
                if (!imgPattern.test(image)) {
                    imageEl.classList.add("input-error");
                    messages.push("URL hình ảnh không hợp lệ.");
                    valid = false;
                }
            }

            if (!valid) {
                alert(messages.join("\n"));
                return false;
            }

            form.submit();
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Thêm Dịch Vụ Mới</h2>

        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/addService" method="post" onsubmit="event.preventDefault(); validateForm(this);">
            <div class="form-container">
                <div class="form-column">
                    <div class="form-group">
                        <label for="name">Tên dịch vụ *</label>
                        <input type="text" id="name" name="name" value="${service.name}" maxlength="100" required>
                    </div>
                    <div class="form-group">
                        <label for="price">Giá *</label>
                        <input type="number" id="price" name="price" min="0" step="1" required>
                    </div>
                    <div class="form-group">
                        <label for="unit">Đơn vị *</label>
                        <input type="text" id="unit" name="unit" value="${service.unit}" maxlength="100" required>
                    </div>
                    <div class="form-group">
                        <label for="serviceType">Loại dịch vụ *</label>
                        <select id="serviceType" name="serviceType" required>
                            <option value="">-- Chọn loại --</option>
                            <c:forEach var="type" items="${serviceTypes}">
                                <option value="${type}" ${service.type eq type ? 'selected' : ''}>${type}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="form-column">
                    <div class="form-group">
                        <label for="description">Mô tả</label>
                        <textarea id="description" name="description" maxlength="1000">${service.description}</textarea>
                    </div>
                    <div class="form-group">
                        <label for="status">Trạng thái</label>
                        <select id="status" name="status">
                            <option value="1" ${service.status == '1' ? 'selected' : ''}>Hoạt động</option>
                            <option value="0" ${service.status == '0' ? 'selected' : ''}>Ngừng Hoạt động</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="serviceImage">URL Hình ảnh</label>
                        <input type="text" id="serviceImage" name="serviceImage" maxlength="255" value="${service.serviceImage}">
                    </div>
                </div>
            </div>
            <input type="submit" value="Lưu">
        </form>
        <a class="back-link" href="${pageContext.request.contextPath}/services?action=list">← Quay lại danh sách</a>
    </div>
</body>
</html>
