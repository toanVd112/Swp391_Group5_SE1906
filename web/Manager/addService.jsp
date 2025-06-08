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
    // Lấy đối tượng Account từ session (phiên đăng nhập của người dùng)
    Account account = (Account) session.getAttribute("account");
    
    // Kiểm tra nếu người dùng chưa đăng nhập (account == null) hoặc không phải Manager
    if (account == null || !"Manager".equals(account.getRole())) {
        // Chuyển hướng về trang đăng nhập (login.jsp) nếu không đủ quyền
        response.sendRedirect("../login.jsp");
        return; // Dừng xử lý JSP
    }
    
    // Lấy danh sách các loại dịch vụ duy nhất từ ServiceDAO
    List<String> types = new ServiceDAO().getAllDistinctServiceType();
    // Lưu danh sách loại dịch vụ vào request để sử dụng trong JSP
    request.setAttribute("serviceTypes", types);
%>

<%-- Khai báo HTML5 và ngôn ngữ trang là tiếng Anh --%>
<html>
<head>
    <%-- Tiêu đề của trang --%>
    <title>Thêm Dịch vụ</title>
    
    <%-- CSS tùy chỉnh để tạo giao diện đẹp và responsive --%>
    <style>
        /* Định dạng body với font chữ, nền, và căn giữa nội dung */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background-color: #f5f6fa; /* Màu nền nhạt */
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center; /* Căn giữa nội dung */
            min-height: 100vh; /* Đảm bảo chiều cao tối thiểu */
        }
        
        /* Định dạng container chứa form */
        .container {
            background: white; /* Nền trắng */
            padding: 30px;
            border-radius: 10px; /* Bo góc */
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Hiệu ứng bóng */
            width: 100%;
            max-width: 500px; /* Chiều rộng tối đa */
        }
        
        /* Định dạng tiêu đề h2 */
        h2 {
            color: #333;
            text-align: center;
            margin-bottom: 30px;
            font-size: 24px;
        }
        
        /* Định dạng mỗi nhóm input trong form */
        .form-group {
            margin-bottom: 20px; /* Khoảng cách giữa các nhóm */
        }
        
        /* Định dạng nhãn (label) */
        label {
            display: block;
            margin-bottom: 8px;
            color: #555;
            font-weight: 500;
        }
        
        /* Định dạng các input và select */
        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%; /* Chiếm toàn bộ chiều rộng */
            padding: 10px;
            border: 1px solid #ddd; /* Viền nhạt */
            border-radius: 5px; /* Bo góc */
            font-size: 16px;
            box-sizing: border-box; /* Bao gồm padding trong kích thước */
            transition: border-color 0.3s; /* Hiệu ứng khi focus */
        }
        
        /* Hiệu ứng khi focus vào input */
        input[type="text"]:focus,
        input[type="number"]:focus,
        textarea:focus,
        select:focus {
            outline: none;
            border-color: #007bff; /* Viền xanh khi focus */
            box-shadow: 0 0 5px rgba(0,123,255,0.3); /* Hiệu ứng bóng */
        }
        
        /* Định dạng textarea */
        textarea {
            resize: vertical; /* Chỉ cho phép thay đổi chiều cao */
            min-height: 100px;
        }
        
        /* Định dạng nút submit */
        input[type="submit"] {
            background-color: #007bff; /* Màu xanh */
            color: white;
            padding: 12px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            transition: background-color 0.3s; /* Hiệu ứng hover */
        }
        
        /* Hiệu ứng hover cho nút submit */
        input[type="submit"]:hover {
            background-color: #0056b3; /* Màu xanh đậm hơn */
        }
        
        /* Định dạng liên kết quay lại */
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #007bff; /* Màu xanh */
            text-decoration: none;
            font-size: 16px;
        }
        
        /* Hiệu ứng hover cho liên kết */
        .back-link:hover {
            text-decoration: underline; /* Gạch chân khi hover */
        }
        
        /* Responsive cho màn hình nhỏ */
        @media (max-width: 600px) {
            .container {
                padding: 20px; /* Giảm padding */
            }
            h2 {
                font-size: 20px; /* Giảm kích thước chữ */
            }
        }
    </style>
</head>
<body>
    <%-- Container chứa form thêm dịch vụ --%>
    <div class="container">
        <%-- Tiêu đề của form --%>
        <h2>Thêm Dịch vụ mới</h2>
        
        <%-- Form gửi dữ liệu đến Servlet /addService qua phương thức POST --%>
        <form action="${pageContext.request.contextPath}/addService" method="post">
            <%-- Nhóm input: Tên dịch vụ --%>
            <div class="form-group">
                <label for="name">Tên dịch vụ:</label>
                <input type="text" id="name" name="name" required> <%-- Trường bắt buộc --%>
            </div>
            
            <%-- Nhóm input: Mô tả --%>
            <div class="form-group">
                <label for="description">Mô tả:</label>
                <textarea id="description" name="description" rows="4"></textarea> <%-- Không bắt buộc --%>
            </div>
            
            <%-- Nhóm input: Giá --%>
            <div class="form-group">
                <label for="price">Giá:</label>
                <input type="number" id="price" step="1" name="price" required> <%-- Trường bắt buộc, chỉ nhận số nguyên --%>
            </div>
            
            <%-- Nhóm input: Trạng thái --%>
            <div class="form-group">
                <label for="status">Trạng thái:</label>
                <select id="status" name="status">
                    <option value="1" selected>Hoạt động</option> <%-- Mặc định chọn "Hoạt động" --%>
                    <option value="0">Ngừng Hoạt động</option>
                </select>
            </div>
            
            <%-- Nhóm input: Loại dịch vụ --%>
            <div class="form-group">
                <label for="serviceType">Loại dịch vụ:</label>
                <select id="serviceType" name="serviceType">
                    <option value="">Chọn loại</option> <%-- Tùy chọn mặc định --%>
                    <%-- Lặp qua danh sách serviceTypes để hiển thị các loại dịch vụ --%>
                    <c:forEach var="type" items="${serviceTypes}">
                        <%-- ${service.type eq type ? 'selected' : ''} kiểm tra xem type có được chọn không, nhưng không cần ở đây vì là form thêm mới --%>
                        <option value="${type}" ${service.type eq type ? 'selected' : ''}>${type}</option>
                    </c:forEach>
                </select>
            </div>
            
            <%-- Nhóm input: Hình ảnh (URL) --%>
            <div class="form-group">
                <label for="serviceImage">Hình ảnh:</label>
                <input type="text" id="serviceImage" name="serviceImage"> <%-- Không bắt buộc --%>
            </div>
            
            <%-- Nút gửi form --%>
            <input type="submit" value="Lưu">
        </form>
        
        <%-- Liên kết quay lại danh sách dịch vụ --%>
        <a class="back-link" href="${pageContext.request.contextPath}/services/list">← Quay lại danh sách</a>
    </div>
</body>
</html>