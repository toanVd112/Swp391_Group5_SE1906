<%-- Khai báo loại nội dung của trang là HTML, mã hóa UTF-8 để hỗ trợ tiếng Việt --%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%-- Nhúng thư viện JSTL core để sử dụng các thẻ như <c:forEach> --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%-- Nhúng thư viện JSTL fmt để định dạng số, ngày tháng (không dùng trong file này nhưng có thể cần sau) --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%-- Import các lớp cần thiết từ package model và DAO --%>
<%@ page import="model.Account" %>
<%@ page import="model.Service" %>
<%@ page import="DAO.ServiceDAO" %>
<%@ page import="java.util.List" %>

<%-- Kiểm tra quyền truy cập --%>
<%
    // Lấy đối tượng Account từ session
    Account account = (Account) session.getAttribute("account");
    
    // Kiểm tra nếu người dùng chưa đăng nhập hoặc không phải Manager
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login_2.jsp");
        return;
    }
    
    // Lấy danh sách các loại dịch vụ duy nhất từ ServiceDAO
    List<String> types = new ServiceDAO().getAllDistinctServiceType();
    request.setAttribute("serviceTypes", types);
%>

<%-- Khai báo HTML5 và ngôn ngữ trang là tiếng Anh --%>
<html>
<head>
    <title>Thêm Dịch vụ</title>
    
    <%-- CSS tùy chỉnh để tạo giao diện đẹp và responsive --%>
    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f5f6fa;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            min-height: 100vh;
        }
        
        .container {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px;
        }
        
        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            font-size: 24px;
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
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 16px;
            box-sizing: border-box;
            transition: border-color 0.3s;
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
        
        /* Định dạng thông báo lỗi */
        .error-message {
            color: #dc3545; /* Màu đỏ */
            background-color: #f8d7da; /* Nền hồng nhạt */
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        
        /* Định dạng input lỗi */
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
        }
    </style>
    
    <%-- JavaScript để validate phía client (tùy chọn) --%>
    <script>
        function validateForm() {
            let isValid = true;
            const name = document.getElementById("name").value.trim();
            const price = document.getElementById("price").value.trim();
            const serviceType = document.getElementById("serviceType").value.trim();
            const serviceImage = document.getElementById("serviceImage").value.trim();
            
            // Xóa lớp input-error trước khi validate
            document.querySelectorAll(".input-error").forEach(el => el.classList.remove("input-error"));
            
            // Validate tên dịch vụ
            if (!name) {
                document.getElementById("name").classList.add("input-error");
                isValid = false;
            } else if (name.length < 3 || name.length > 100) {
                document.getElementById("name").classList.add("input-error");
                isValid = false;
            }
            
            // Validate giá
            if (!price) {
                document.getElementById("price").classList.add("input-error");
                isValid = false;
            } else if (isNaN(price) || price < 0 || price > 1000000000) {
                document.getElementById("price").classList.add("input-error");
                isValid = false;
            }
            
            // Validate loại dịch vụ
            if (!serviceType) {
                document.getElementById("serviceType").classList.add("input-error");
                isValid = false;
            }
            
            // Validate URL hình ảnh
            if (serviceImage) {
                const imageRegex = /^(https?:\/\/|\/).+\.(jpg|jpeg|png|gif)$/i;
                if (!imageRegex.test(serviceImage)) {
                    document.getElementById("serviceImage").classList.add("input-error");
                    isValid = false;
                }
            }
            
            if (!isValid) {
                alert("Vui lòng kiểm tra các trường dữ liệu được đánh dấu đỏ.");
            }
            
            return isValid;
        }
    </script>
</head>
<body>
    <div class="container">
        <h2>Thêm Dịch vụ mới</h2>
        
        <%-- Hiển thị thông báo lỗi nếu có --%>
        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>
        
        <%-- Form thêm dịch vụ --%>
        <form action="${pageContext.request.contextPath}/addService" method="post" onsubmit="return validateForm()">
            <div class="form-group">
                <label for="name">Tên dịch vụ: <span title="Từ 3-100 ký tự, chỉ chứa chữ, số, dấu cách, gạch ngang, gạch dưới">*</span></label>
                <input type="text" id="name" name="name" value="${service.name}" required
                       pattern="[A-Za-z0-9\s\-_]+" title="Chỉ chứa chữ, số, dấu cách, gạch ngang, gạch dưới">
            </div>
            
            <div class="form-group">
                <label for="description">Mô tả: <span title="Tối đa 1000 ký tự"></span></label>
                <textarea id="description" name="description" rows="4" maxlength="1000">${service.description}</textarea>
            </div>
            
            <div class="form-group">
                <label for="price">Giá: <span title="Số nguyên từ 0 đến 1,000,000,000">*</span></label>
                <input type="number" id="price" name="price" step="1" min="0" max="1000000000"
                       value="${service.price > 0 ? service.price : ''}" required>
            </div>
            
            <div class="form-group">
                <label for="status">Trạng thái:</label>
                <select id="status" name="status">
                    <option value="1" ${service.status == '1' ? 'selected' : ''}>Hoạt động</option>
                    <option value="0" ${service.status == '0' ? 'selected' : ''}>Ngừng Hoạt động</option>
                </select>
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
            
            <div class="form-group">
                <label for="serviceImage">Hình ảnh: <span title="URL hợp lệ (jpg, jpeg, png, gif), tối đa 255 ký tự"></span></label>
                <input type="text" id="serviceImage" name="serviceImage" value="${service.serviceImage}"
                       maxlength="255" pattern="^(https?://|/).+\.(jpg|jpeg|png|gif)$"
                       title="URL hợp lệ với định dạng jpg, jpeg, png, gif">
            </div>
            
            <input type="submit" value="Lưu">
        </form>
        
        <a class="back-link" href="${pageContext.request.contextPath}/services/list">← Quay lại danh sách</a>
    </div>
</body>
</html>