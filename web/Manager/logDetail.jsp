<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Log Details</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        .container { max-width: 600px; margin: auto; }
        .detail { margin: 10px 0; }
        .error { color: red; margin: 10px 0; }
        button { padding: 6px 12px; margin: 5px; }
    </style>
</head>
<body>
<div class="container">
    <h2>Log Details</h2>

    <c:if test="${not empty errorMessage}">
        <div class="error">${errorMessage}</div>
    </c:if>

    <c:if test="${not empty log}">
        <div class="detail"><strong>Log ID:</strong> ${log.logId}</div>
        <div class="detail"><strong>Username:</strong> ${log.username}</div>
        <div class="detail"><strong>Role:</strong> ${log.role}</div>
        <div class="detail"><strong>Action Type:</strong> ${log.actionType}</div>
        <div class="detail"><strong>Target:</strong> ${log.targetTable} #${log.targetId}</div>
        <div class="detail"><strong>Description:</strong> ${log.description}</div>
        <div class="detail"><strong>IP Address:</strong> ${log.ipAddress}</div>
        <div class="detail"><strong>Time:</strong> ${log.actionTime}</div>
    </c:if>

    <button onclick="window.location.href='ActivityLogServlet'">Back to Logs</button>
</div>
</body>
</html>