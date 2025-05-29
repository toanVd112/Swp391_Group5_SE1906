<%-- 
    Document   : checkReply
    Created on : May 29, 2025, 11:40:52 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Check Your Reply</title>
        <style>
            body{
                font-family:Arial;
                background:#f4f7f9;
                padding:40px;
                text-align:center
            }
            form{
                display:inline-block;
                background:#fff;
                padding:30px;
                border-radius:8px;
                box-shadow:0 0 10px rgba(0,0,0,.1)
            }
            input{
                padding:10px;
                width:250px;
                border:1px solid #ccc;
                border-radius:4px;
                margin-top:10px
            }
            button{
                margin-top:15px;
                padding:10px 25px;
                border:none;
                border-radius:4px;
                background:#2980b9;
                color:#fff;
                cursor:pointer
            }
            table{
                margin:20px auto;
                border-collapse:collapse;
                width:80%
            }
            th,td{
                border:1px solid #ccc;
                padding:8px
            }
            th{
                background:#3498db;
                color:#fff
            }
        </style>
    </head>
    <body>

        <h2>Tra cứu phản hồi từ khách sạn</h2>

        <form action="CheckReplyServlet" method="get">
            <label>Nhập số điện thoại (10 số):</label><br/>
            <input type="text" name="phone" 
                   inputmode="numeric" 
                   pattern="^\d{10}$" 
                   maxlength="10" 
                   oninput="this.value = this.value.replace(/[^0-9]/g, '')" 
                   class="form-control" 
                   required
                   title="Số điện thoại phải gồm đúng 10 chữ số">
            <button type="submit">Tra cứu</button>
        </form>

        <!-- Hiển thị kết quả khi servlet trả về -->
        <c:if test="${not empty replies}">
            <h3>Kết quả tìm thấy</h3>
            <table>
                <tr>
                    <th>Ngày gửi</th>
                    <th>Câu hỏi</th>
                    <th>Phản hồi</th>
                    <th>Ngày phản hồi</th>
                </tr>
                <c:forEach var="r" items="${replies}">
                    <tr>
                        <td>${r.createdAt}</td>
                        <td>${r.question}</td>
                        <td><c:out value="${empty r.adminReply ? 'Chưa có phản hồi' : r.adminReply}"/></td>
                        <td>${r.repliedAt}</td>
                    </tr>
                </c:forEach>
            </c:if>

            <!-- Thông báo không tìm thấy -->
            <c:if test="${param.searched eq 'true' and empty replies}">
                <p style="color:red;margin-top:20px">Không tìm thấy câu hỏi nào khớp số điện thoại.</p>
            </c:if>

    </body>
</html>