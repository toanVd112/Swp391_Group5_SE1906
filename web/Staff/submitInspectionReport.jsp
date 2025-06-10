<%-- 
    Document   : submitInspectionReport.jsp
    Created on : 10 thg 6, 2025, 23:51:24
    Author     : MyPC
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="DBConnect" %>
<%
    String reportID = request.getParameter("reportID");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Gửi báo cáo kiểm tra</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            padding: 30px;
            background-color: #f3f4f6;
        }
        .container {
            max-width: 600px;
            margin: auto;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px #ccc;
        }
        h2 {
            text-align: center;
            color: #1e3a8a;
        }
        label, textarea, select {
            display: block;
            width: 100%;
            margin-bottom: 15px;
        }
        button {
            padding: 10px 20px;
            background-color: #3b82f6;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        button:hover {
            background-color: #2563eb;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Gửi báo cáo kiểm tra phòng</h2>

    <form method="post">
        <input type="hidden" name="reportID" value="<%= reportID %>"/>

        <label for="isRoomOk">Kết quả kiểm tra phòng:</label>
        <select name="isRoomOk" required>
            <option value="1">Đạt</option>
            <option value="0">Không đạt</option>
        </select>

        <label for="notes">Ghi chú:</label>
        <textarea name="notes" rows="5" placeholder="Nhập ghi chú..."></textarea>

        <button type="submit">Gửi báo cáo</button>
    </form>

    <%
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String isRoomOk = request.getParameter("isRoomOk");
            String notes = request.getParameter("notes");

            try (Connection conn = DBConnect.getConnection()) {
                String sql = "UPDATE roominspectionreport SET IsRoomOk = ?, Notes = ? WHERE ReportID = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, Integer.parseInt(isRoomOk));
                    ps.setString(2, notes);
                    ps.setInt(3, Integer.parseInt(reportID));
                    int rows = ps.executeUpdate();
                    if (rows > 0) {
                        out.println("<p style='color:green'>Gửi báo cáo thành công!</p>");
                    } else {
                        out.println("<p style='color:red'>Không tìm thấy báo cáo để cập nhật.</p>");
                    }
                }
            } catch (Exception e) {
                out.println("<p style='color:red'>Lỗi: " + e.getMessage() + "</p>");
            }
        }
    %>
</div>
</body>
</html>

