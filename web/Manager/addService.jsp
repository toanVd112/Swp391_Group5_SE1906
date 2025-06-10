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
    <title>Add Service</title>
    
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
        
        span {
            color: red;
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
    
        <%-- JavaScript để validate phía client --%>
        <script>
            async function isDupeServiceName(input) {
                const dataToSend = input;

                try {
                    const response = await fetch('${pageContext.request.contextPath}/services/dupe', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json',
                        },
                        body: JSON.stringify({data: dataToSend})
                    });

                    if (!response.ok) {
                        throw new Error('Phản hồi từ API không thành công');
                    }

                    const result = await response.json();
                    console.log('Kết quả:', result);
                    return result === true || result === "true"; // Hỗ trợ cả boolean và chuỗi
                } catch (error) {
                    console.error('Lỗi:', error);
                    return false; // Trả về false khi lỗi, giả sử không trùng lặp nếu API thất bại
                }
            }

            async function validateForm(form) {
                let isValid = true;
                let errorMessages = [];

                // Lấy các phần tử HTML và kiểm tra tồn tại
                const nameInput = document.getElementById("name");
                const priceInput = document.getElementById("price");
                const serviceTypeInput = document.getElementById("serviceType");
                const serviceImageInput = document.getElementById("serviceImage");

                if (!nameInput || !priceInput || !serviceTypeInput || !serviceImageInput) {
                    console.error("Một hoặc nhiều phần tử HTML không tồn tại.");
                    alert("Lỗi: Không tìm thấy các trường dữ liệu cần thiết.");
                    return false;
                }

                // Lấy giá trị từ các trường
                const name = nameInput.value.trim();
                const price = priceInput.value.trim();
                const serviceType = serviceTypeInput.value.trim();
                const serviceImage = serviceImageInput.value.trim();

                // Xóa lớp input-error trước khi validate
                document.querySelectorAll(".input-error").forEach(el => el.classList.remove("input-error"));

                // Kiểm tra tên dịch vụ trùng lặp
                const isDupServiceName = await isDupeServiceName(name);

                // Validate tên dịch vụ
                if (!name) {
                    nameInput.classList.add("input-error");
                    errorMessages.push("Tên dịch vụ không được để trống.");
                    isValid = false;
                } else if (name.length < 3 || name.length > 100) {
                    nameInput.classList.add("input-error");
                    errorMessages.push("Tên dịch vụ phải từ 3 đến 100 ký tự.");
                    isValid = false;
                } else if (isDupServiceName) {
                    console.log("Tên dịch vụ trùng lặp");
                    nameInput.classList.add("input-error");
                    errorMessages.push("Tên dịch vụ đã tồn tại.");
                    isValid = false;
                }

                // Validate giá
                const priceValue = parseFloat(price);
                if (!price || isNaN(priceValue) || priceValue < 0 || priceValue > 1000000000) {
                    priceInput.classList.add("input-error");
                    errorMessages.push("Giá phải là số hợp lệ từ 0 đến 1,000,000,000.");
                    isValid = false;
                }

                // Validate loại dịch vụ
                if (!serviceType) {
                    serviceTypeInput.classList.add("input-error");
                    errorMessages.push("Loại dịch vụ không được để trống.");
                    isValid = false;
                }

                // Validate URL hình ảnh
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
        
        <%-- Hiển thị thông báo lỗi nếu có --%>
        <c:if test="${not empty errorMessage}">
            <div class="error-message">${errorMessage}</div>
        </c:if>
        
        <%-- Form thêm dịch vụ --%>
        <form action="${pageContext.request.contextPath}/addService" method="post" onsubmit="event.preventDefault(); validateForm(this);">
            <div class="form-group">
                <label for="name">Tên dịch vụ: <span title="Từ 3-100 ký tự, chỉ chứa chữ, số, dấu cách, gạch ngang, gạch dưới">*</span></label>
                <input type="text" id="name" name="name" value="${service.name}" required>
            </div>
            
            <div class="form-group">
                <label for="description">Mô tả: <span title="Tối đa 1000 ký tự"></span></label>
                <textarea id="description" name="description" rows="4" maxlength="1000">${service.description}</textarea>
            </div>
            
            <div class="form-group">
                <label for="price">Giá: <span title="Số nguyên từ 0 đến 1,000,000,000">*</span></label>
                <input 
                    type="number" 
                    id="price" 
                    name="price" 
                    step="1" 
                    min="0" 
                    max="1000000000" 
                    value="" 
                    required />
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