<%-- 
    Document   : manageQuestions
    Created on : May 28, 2025, 9:39:34 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Customer Questions</title>
        <style>
            table{
                width:90%;
                margin:auto;
                border-collapse:collapse
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

        <h2 style="text-align:center">Customer Questions</h2>

        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Phone</th>
                    <th>Question</th>
                    <th>Submitted&nbsp;At</th>
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
                                        <input type="hidden" name="questionID" value="${q.questionID}"/>
                                        <textarea name="adminReply" rows="3" cols="30" required></textarea><br/>
                                        <input type="submit" value="Send Reply"/>
                                    </form>
                                </c:when>

                                <c:otherwise>
                                    <b>${q.adminReply}</b><br/>
                                    <small><i>Replied&nbsp;at&nbsp;${q.repliedAt}</i></small>
                                </c:otherwise>
                            </c:choose>
                        </td>

                    </tr>
                </c:forEach>
            </tbody>
        </table>

    </body>
</html>
