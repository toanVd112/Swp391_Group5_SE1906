<%@page contentType="text/html;charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Activity Logs</title>
        <style>
            .main-content {
                margin-left: 260px;
                padding: 30px;
                width: calc(100% - 260px);
                box-sizing: border-box;
            }

            .card {
                background: #fff;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                max-width: 1200px;
                margin: auto;
            }

            .card h1 {
                text-align: center;
                color: #2c3e50;
                margin-bottom: 25px;
            }

            .filter-form {
                margin-bottom: 30px;
                display: flex;
                flex-wrap: wrap;
                gap: 12px;
            }

            .filter-form label {
                font-weight: bold;
            }

            .filter-form input,
            .filter-form select {
                padding: 6px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            .filter-form button {
                padding: 6px 14px;
                background-color: #2980b9;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
            }

            .filter-form button:hover {
                background-color: #1c5980;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                background: #fff;
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
                display: inline-block;
                margin-top: 20px;
                padding: 10px 16px;
                background-color: #2980b9;
                color: white;
                border-radius: 6px;
                text-decoration: none;
            }

            .back-btn:hover {
                background-color: #1c5980;
            }
        </style>
    </head>
    <body>
        <%@ include file="sidebar.jsp" %>

        <div class="main-content">
            <div class="card">
                <h1>Activity Logs</h1>

                <form class="filter-form" action="activityLogs" method="get">
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

                    <button type="submit">Filter</button>
                </form>

                <table>
                    <thead>
                        <tr>
                            <th>Log ID</th>
                            <th>Actor ID</th>
                            <th>Username</th>
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
            </div>
        </div>
    </body>
</html>
