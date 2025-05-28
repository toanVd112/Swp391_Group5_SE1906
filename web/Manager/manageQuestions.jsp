<%-- 
    Document   : manageQuestions
    Created on : May 28, 2025, 9:39:34 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!-- File: Manager/manageQuestions.jsp -->

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Customer Questions</title>
</head>
<body>
<h2>Customer Questions</h2>
<table border="1">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Email</th>
        <th>Question</th>
        <th>Submitted At</th>
        <th>Reply</th>
    </tr>
    <c:forEach var="q" items="${questions}">
        <tr>
            <td>${q.questionID}</td>
            <td>${q.customerName}</td>
            <td>${q.email}</td>
            <td>${q.question}</td>
            <td>${q.createdAt}</td>
            <td>
                <c:choose>
                    <c:when test="${empty q.adminReply}">
                        <form action="replyQuestion" method="post">
                            <input type="hidden" name="questionID" value="${q.questionID}" />
                            <textarea name="adminReply" rows="3" cols="30"></textarea><br>
                            <input type="submit" value="Send Reply" />
                        </form>
                    </c:when>
                    <c:otherwise>
                        ${q.adminReply} <br/>
                        <small><i>on ${q.repliedAt}</i></small>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
