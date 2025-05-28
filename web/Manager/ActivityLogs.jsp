<%-- 
    Document   : ActivityLogs.jsp
    Created on : May 28, 2025, 4:09:57 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Activity Logs</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f5f8fa;
                margin: 0;
                padding: 20px;
            }

            h1 {
                text-align: center;
                color: #2c3e50;
            }

            table {
                width: 90%;
                margin: auto;
                border-collapse: collapse;
                background: #fff;
                box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            }

            th, td {
                padding: 12px 15px;
                border: 1px solid #ddd;
                text-align: left;
            }

            th {
                background-color: #3498db;
                color: white;
            }

            tr:hover {
                background-color: #f1f1f1;
            }

            .back-btn {
                display: block;
                width: 200px;
                margin: 20px auto;
                padding: 10px;
                background-color: #2980b9;
                color: white;
                text-align: center;
                border-radius: 6px;
                text-decoration: none;
            }

            .back-btn:hover {
                background-color: #1c5980;
            }
        </style>
    </head>
    <body>
        <!-- Add ngay sau <h1>Activity Logs</h1> -->
        <form action="activityLogs" method="get" style="width: 90%; margin: 20px auto;">
            <label>Username:</label>
            <input type="text" name="username" value="${param.username}" />

            <label>Action Type:</label>
            <select name="actionType">
                <option value="">All</option>
                <option value="Add" ${param.actionType == 'Add' ? 'selected' : ''}>Add</option>
                <option value="Delete" ${param.actionType == 'Delete' ? 'selected' : ''}>Delete</option>
                <option value="Update" ${param.actionType == 'Update' ? 'selected' : ''}>Update</option>
            </select>

            <label>Target Table:</label>
            <input type="text" name="targetTable" value="${param.targetTable}" />

            <label>From:</label>
            <input type="date" name="from" value="${param.from}" />

            <label>To:</label>
            <input type="date" name="to" value="${param.to}" />

            <label>Target ID:</label>
            <input type="number" name="targetID" value="${param.targetID}" />

            <button type="submit" style="margin-left:10px; padding:6px 14px;">Filter</button>
        </form>

        <h1>Activity Logs</h1>

        <table>
            <thead>
                <tr>
                    <th>Log ID</th>
                    <th>Actor ID</th>
                    <th>Username </th>
                    <th>Action Type</th>
                    <th>Target Table</th>
                    <th>Target ID</th>
                    <th>Action Time</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="log" items="${logList}">
                    <tr>
                        <td>${log.logID}</td>
                        <td>${log.actorID}</td>
                        <td>${log.username}</td>
                        <td>${log.actionType}</td>
                        <td>${log.targetTable}</td>
                        <td>${log.targetID}</td>
                        <td>${log.actionTime}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <a class="back-btn" href="Manager/manager.jsp">← Back to Manager Home</a>

    </body>
</html>
