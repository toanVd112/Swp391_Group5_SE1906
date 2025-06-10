<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <jsp:include page="/header.jsp" />
        <style>
            /* Dùng lại toàn bộ CSS bạn gửi từ trang listRooms.jsp */
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                margin: 0;
                padding: 0;
                background-color: #f3f4f6;
            }
            .main-content {
                max-width: 800px;
                margin: 40px auto;
                background-color: #ffffff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
            }
            h2 {
                font-size: 24px;
                color: #1e293b;
                margin-bottom: 20px;
                border-left: 5px solid #3b82f6;
                padding-left: 10px;
            }
            form {
                display: flex;
                flex-direction: column;
                gap: 16px;
            }
            select, input, textarea {
                padding: 10px;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                font-size: 14px;
                width: 100%;
            }
            button {
                padding: 12px;
                background-color: #2563eb;
                color: white;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                cursor: pointer;
            }
            button:hover {
                background-color: #1e40af;
            }
            .success-msg {
                color: green;
                font-weight: bold;
            }
            .error-msg {
                color: red;
                font-weight: bold;
            }
        </style>
    </head>
    <body>
        <div class="main-content">
            <h2>Giao Nhiệm Vụ Cho Nhân Viên</h2>

            <c:if test="${param.success == '1'}">
                <p class="success-msg">✔ Giao nhiệm vụ thành công!</p>
            </c:if>
            <c:if test="${param.error == '1'}">
                <p class="error-msg">❌ Có lỗi xảy ra khi giao nhiệm vụ.</p>
            </c:if>

            <form method="post" action="AssignTaskServlet">

                <label for="roomNumber">Số phòng:</label>
                <input type="number" name="roomNumber" required placeholder="Nhập số phòng..." />



                <label for="staffId">Nhân viên:</label>
                <select name="staffId" required>
                    <option value="">--Chọn nhân viên--</option>
                    <c:forEach var="s" items="${staffList}">
                        <option value="${s.accountID}">${s.fullName}</option>
                    </c:forEach>
                </select>

                <label for="taskType">Loại nhiệm vụ:</label>
                <select name="taskType" required>
                    <option value="inspection">Kiểm tra phòng</option>
                    <option value="maintenance">Bảo trì</option>
                </select>

                <label for="deadline">Hạn xử lý:</label>
                <input type="datetime-local" name="deadline" required />

                <label for="description">Ghi chú nhiệm vụ:</label>
                <textarea name="description" rows="4" placeholder="Nhập chi tiết công việc..." required></textarea>

                <button type="submit">Giao nhiệm vụ</button>
            </form>
        </div>

        <jsp:include page="/footer.jsp" />
    </body>
</html>
