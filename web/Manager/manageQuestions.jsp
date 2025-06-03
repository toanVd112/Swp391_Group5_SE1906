<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Account" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    Account account = (Account) session.getAttribute("account");
    if (account == null || !"Manager".equals(account.getRole())) {
        response.sendRedirect("../login_2.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Customer Questions</title>
        <link href="https://fonts.googleapis.com/css2?family=Roboto&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Roboto', sans-serif;
                margin: 0;
                padding: 0;
                display: flex;
                background-color: #f4f7f9;
            }

            .main-content {
                margin-left: 260px;
                padding: 30px;
                width: calc(100% - 260px);
                box-sizing: border-box;
            }

            h2 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 30px;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background-color: #fff;
                box-shadow: 0 0 12px rgba(0, 0, 0, 0.05);
            }

            th, td {
                border: 1px solid #ddd;
                padding: 10px 12px;
                text-align: left;
            }

            th {
                background-color: #3498db;
                color: white;
            }

            tr:hover {
                background-color: #f1f1f1;
            }

            textarea {
                width: 100%;
                border-radius: 5px;
                padding: 6px;
            }

            input[type="submit"] {
                background-color: #2ecc71;
                color: white;
                border: none;
                padding: 6px 12px;
                border-radius: 4px;
                cursor: pointer;
                margin-top: 6px;
            }

            input[type="submit"]:hover {
                background-color: #27ae60;
            }

            small {
                color: #555;
            }

            b {
                display: block;
                margin-bottom: 4px;
            }
        </style>
    </head>
    <body>

        <%@ include file="sidebar.jsp" %>

        <div class="main-content">
            <h2>Customer Questions</h2>

            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Phone</th>
                        <th>Question</th>
                        <th>Submitted At</th>
                        <th>Reply / Action</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="q" items="${questions}">
                        <tr>
                            <td>${q.questionID}</td>
                            <td>${q.customerName}</td>
                            <td>${q.phone}</td>
                            <td>${q.question}</td>
                            <td>${q.createdAt}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${empty q.adminReply}">
                                        <form action="ReplyQuestionServlet" method="post">
                                            <input type="hidden" name="questionID" value="${q.questionID}" />
                                            <textarea name="adminReply" rows="3" required></textarea>
                                            <input type="submit" value="Send Reply" />
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <b>${q.adminReply}</b>
                                        <small><i>Replied at ${q.repliedAt}</i></small>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

    </body>
</html>
