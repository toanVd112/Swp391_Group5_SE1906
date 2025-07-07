<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="model.Account" %>
<%@ page import="model.Service" %>
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

<html>
<head>
    <title>Add Service</title>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            display: flex;
            min-height: 100vh;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 800px;
        }
        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            font-size: 24px;
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
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }
        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            max-width: 100%;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
            transition: border-color 0.3s;
            word-break: break-word;
            overflow-wrap: break-word;
        }
        input[type="text"]:focus,
        input[type="number"]:focus,
        textarea:focus,
        select:focus {
            outline: none;
            border-color: #007bff;
            box-shadow: 0 0 5px rgba(0,123,255,0.3);
        }
        textarea {
            resize: vertical;
            min-height: 100px;
            max-height: 300px;
        }
        input[type="submit"] {
            background-color: #007bff;
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background-color 0.3s;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #007bff;
            text-decoration: none;
            font-size: 16px;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .error-message {
            color: #dc3545;
            background-color: #f8d7da;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .input-error {
            border-color: #dc3545;
        }
        @media (max-width: 600px) {
            .container {
                padding: 20px;
            }
            h2 {
                font-size: 20px;
            }
            .form-column {
                min-width: 100%;
            }
        }
    </style>
    <script>
        async function isDupeServiceName(input) {
            const dataToSend = input;
            try {
                const response = await fetch('${pageContext.request.contextPath}/services/dupe', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ data: dataToSend })
                });
                if (!response.ok) throw new Error('Phản hồi từ API không thành công');
                const result = await response.json();
                return result === true || result === "true";
            } catch (error) {
                console.error('Lỗi:', error);
                return false;
            }
        }

        async function validateForm(form) {
            let isValid = true;
            let errorMessages = [];
            const nameInput = document.getElementById("name");
            const descriptionInput = document.getElementById("description");
            const priceInput = document.getElementById("price");
            const serviceTypeInput = document.getElementById("serviceType");
            const serviceImageInput = document.getElementById("serviceImage");

            if (!nameInput || !descriptionInput || !priceInput || !serviceTypeInput || !serviceImageInput) {
                alert("Lỗi: Không tìm thấy các trường dữ liệu cần thiết.");
                return false;
            }

            const name = nameInput.value.trim();
            const description = descriptionInput.value.trim();
            const price = priceInput.value.trim();
            const serviceType = serviceTypeInput.value.trim();
            const serviceImage = serviceImageInput.value.trim();

            document.querySelectorAll(".input-error").forEach(el => el.classList.remove("input-error"));

            const nameRegex = /^[a-zA-Z0-9\s-_]{3,100}$/;
            const isDupServiceName = await isDupeServiceName(name);
            if (!name) {
                nameInput.classList.add("input-error");
                errorMessages.push("Tên dịch vụ không được để trống.");
                isValid = false;
            } else if (!nameRegex.test(name)) {
                nameInput.classList.add("input-error");
                errorMessages.push("Tên dịch vụ phải từ 3 đến 100 ký tự, chỉ chứa chữ, số, dấu cách, gạch ngang hoặc gạch dưới.");
                isValid = false;
            } else if (isDupServiceName) {
                nameInput.classList.add("input-error");
                errorMessages.push("Tên dịch vụ đã tồn tại.");
                isValid = false;
            }

            if (description.length > 1000) {
                descriptionInput.classList.add("input-error");
                errorMessages.push("Mô tả không được vượt quá 1000 ký tự.");
                isValid = false;
            }

            const priceValue = parseFloat(price);
            if (!price || isNaN(priceValue) || priceValue < 0 || priceValue > 1000000000) {
                priceInput.classList.add("input-error");
                errorMessages.push("Giá phải là số hợp lệ từ 0 đến 1,000,000,000.");
                isValid = false;
            }

            if (!serviceType) {
                serviceTypeInput.classList.add("input-error");
                errorMessages.push("Loại dịch vụ không được để trống.");
                isValid = false;
            }

            if (serviceImage) {
                const imageRegex = /^(https?:\/\/[a-zA-Z0-9\-\.]+\/.+|\/[a-zA-Z0-9\-\/]+|assets\/[a-zA-Z0-9\-\/]+)\.(jpg|jpeg|png|gif)$/i;
                if (!imageRegex.test(serviceImage)) {
                    serviceImageInput.classList.add("input-error");
                    errorMessages.push("URL hình ảnh không hợp lệ.");
                    isValid = false;
                }
            }

            if (!isValid) {
                alert(errorMessages.join("\n"));
            } else {
                form.submit();
            }
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Add New Service</h2>
        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>
        <form action="${pageContext.request.contextPath}/addService" method="post" onsubmit="event.preventDefault(); validateForm(this);">
            <div class="form-container">
                <div class="form-column">
                    <div class="form-group">
                        <label for="name">Tên dịch vụ: <span title="Từ 3-100 ký tự, chỉ chứa chữ, số, dấu cách, gạch ngang, gạch dưới">*</span></label>
                        <input type="text" id="name" name="name" value="${service.name}" required maxlength="100">
                    </div>
                    <div class="form-group">
                        <label for="price">Giá: <span title="Số nguyên từ 0 đến 1,000,000,000">*</span></label>
                        <input type="number" id="price" name="price" step="1" min="0" max="1000000000" value="" required>
                    </div>
                    <div class="form-group">
                        <label for="serviceType">Loại dịch vụ: <span title="Chọn một loại từ danh sách">*</span></label>
                        <select id="serviceType" name="serviceType" required>
                            <option value="">Chọn loại</option>
                            <c:forEach var="type" items="${serviceTypes}">
                                <option value="${type}" ${service.type eq type ? 'selected' : ''}>${type}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="form-column">
                    <div class="form-group">
                        <label for="description">Mô tả: <span title="Tối đa 1000 ký tự"></span></label>
                        <textarea id="description" name="description" rows="4" maxlength="1000">${service.description}</textarea>
                    </div>
                    <div class="form-group">
                        <label for="status">Trạng thái:</label>
                        <select id="status" name="status">
                            <option value="1" ${service.status == '1' ? 'selected' : ''}>Hoạt động</option>
                            <option value="0" ${service.status == '0' ? 'selected' : ''}>Ngừng Hoạt động</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="serviceImage">Hình ảnh: <span title="URL hợp lệ (jpg, jpeg, png, gif), tối đa 255 ký tự"></span></label>
                        <input type="text" id="serviceImage" name="serviceImage" value="${service.serviceImage}" maxlength="255" pattern="^(https?://|\/|assets\/).+\.(jpg|jpeg|png|gif)$" title="URL hợp lệ với định dạng jpg, jpeg, png, gif">
                    </div>
                </div>
            </div>
            <input type="submit" value="Save">
        </form>
        <a class="back-link" href="${pageContext.request.contextPath}/services?action=list">← Back to Service List</a>
    </div>
</body>
</html>