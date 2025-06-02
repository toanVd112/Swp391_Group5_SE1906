<%@ page contentType="text/html;charset=UTF-8" language="java" %><%@ page import="model.Account" %>
<%
  Account account = (Account) session.getAttribute("account");
  if (account == null || !"Manager".equals(account.getRole())) {
      response.sendRedirect("../login_2.jsp");
      return;
  }
%>
<html>
    <head>
        <title>Thêm Dịch vụ</title>
    </head>
    <body>

        <h2>Thêm Dịch vụ mới</h2>
        <form action="addService" method="post">
            <label>Tên dịch vụ:</label><br>
            <input type="text" name="name" required><br><br>

            <label>Mô tả:</label><br>
            <textarea name="description" rows="4" cols="40"></textarea><br><br>

            <label>Giá:</label><br>
            <input type="number" step="0.01" name="price" required><br><br>

            <label>Trạng thái:</label><br>
            <select name="status">
                <option value="1" selected>Hoạt động</option>
                <option value="0">Ngừng</option>
            </select><br><br>

            <input type="submit" value="Lưu">
        </form>
        <br>
        <a href="services">← Quay lại danh sách</a>
    </body>
</html>
